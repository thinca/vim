#!/bin/bash
# Build a base and a patched Vim and measure the typval copy/clear
# microbenchmarks.  Two binaries are built per commit:
#   - release-like (-O2, no -g): the binary a user actually runs; binary size
#     and native wall-clock are measured on this one
#   - debug-info (-O2 -g): run under callgrind so functions/lines resolve;
#     total and per-function instruction-reads (Ir) come from this one
# -g does not change the generated code, so Ir and timing are equivalent either
# way; the split just keeps user-facing figures on the user's binary and the
# detailed analysis on the debuggable one.
#
# Reported per workload:
#   - Ir total (deterministic, runner-independent)
#   - per-function Ir of the out-of-line copy/clear (copy_tv/clear_tv on base,
#     copy_tv_inner/clear_tv_inner on patched), showing scalar work moving inline
#   - native wall-clock, min of a few runs (informational, noisy on shared CI)
# Plus the built binary size (base vs patched).
#
# Two workloads are measured (see ci/bench/*.vim):
#   scalar    - Sieve of Eratosthenes; the fast-path's best case
#   container - string/list/dict heavy (deepcopy/slice/remove); the worst case,
#               where the scalar check adds a branch before the non-scalar
#               fallback.  Used to show the non-scalar regression stays small.
#
# Usage: run_typval_bench.sh <base-sha> [patched-sha]
#   patched-sha defaults to HEAD.
# Run from the top of a vim/vim work tree.  The bench scripts are read from the
# patched checkout, so this works even when the base commit predates them.

set -eu

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

BASE_SHA=${1:?"base sha required"}
PATCHED_SHA=${2:-HEAD}

NATIVE_RUNS=3

# name:file:callgrind_iter:native_iter
#   callgrind_iter is small (valgrind is ~50x slower); native_iter targets a
#   few seconds of wall-clock so the minimum is stable.
BENCHES=(
    "scalar:scalarbench.vim:4000:8000"
    "container:containerbench.vim:2000:20000"
)

WORK=$(mktemp -d)
# Restore the caller's branch/HEAD on exit: the patched build checks out
# PATCHED_SHA below, which would otherwise leave the work tree on a detached HEAD.
ORIG_HEAD=$(git symbolic-ref --quiet --short HEAD || git rev-parse HEAD)
trap 'git checkout --quiet "$ORIG_HEAD" 2>/dev/null || true; git worktree remove --force "$WORK/base" 2>/dev/null || true; rm -rf "$WORK"' EXIT

# Keep the bench scripts from the current (patched) checkout so the base build,
# which may predate them, can still be measured.
cp ci/bench/*.vim "$WORK"/

CONFIGURE_FLAGS="--with-features=huge --disable-gui --without-x \
  --disable-luainterp --disable-perlinterp --disable-python3interp \
  --disable-pythoninterp --disable-rubyinterp --disable-tclinterp"
JOBS=$(nproc)

# build_tree <srcdir> <side>  (side = base|patched)
# Builds two variants from one source tree, into $WORK/vim-<side>-{rel,dbg}:
#   rel = -O2 (no -g): the user binary, for size and wall-clock
#   dbg = -O2 -g: for callgrind, so functions/lines resolve
build_tree() {
    local dir=$1 side=$2
    (
        cd "$dir/src"
        make distclean >/dev/null 2>&1 || true
        ./configure $CONFIGURE_FLAGS >"$WORK/configure-$side.log" 2>&1
        make CFLAGS="-O2" -j"$JOBS" >"$WORK/build-$side-rel.log" 2>&1
        cp vim "$WORK/vim-$side-rel"
        make clean >/dev/null 2>&1
        make CFLAGS="-O2 -g" -j"$JOBS" >"$WORK/build-$side-dbg.log" 2>&1
        cp vim "$WORK/vim-$side-dbg"
    )
}

total_ir() {
    # The Ir count is the first column of the "PROGRAM TOTALS" line, e.g.
    # "2,354,962,538 (100.0%)  PROGRAM TOTALS"; take that field only.
    callgrind_annotate "$1" 2>/dev/null \
        | awk '/PROGRAM TOTALS/ { gsub(/,/, "", $1); print $1; exit }'
}

# fn_ir <callgrind.out> <function> -> that function's Ir (empty if not present).
# --threshold=100 lists every function (so a near-zero callee still shows);
# the regex anchors on the function name preceded by a non-identifier char and
# followed by a space or "[" so that e.g. copy_tv does not match copy_tv_inner.
fn_ir() {
    callgrind_annotate --auto=no --threshold=100 "$1" 2>/dev/null \
        | grep -m1 -E "[^_[:alnum:]]$2( |\[)" \
        | grep -oE "^[[:space:]]*[0-9,]+" | tr -d ', '
}

# run_cg <vim> <bench-file> <iter> <out> -> prints "<Ir> <check>".
# Returns non-zero (printing nothing on stdout) if the run or extraction fails,
# so a crashed run can never be mistaken for a successful one.
run_cg() {
    local vim=$1 file=$2 iter=$3 out=$4
    local result="$out.check"		# unique per run; never shared or stale
    rm -f "$result" "$out"
    if ! valgrind --tool=callgrind --callgrind-out-file="$out" \
        --dump-instr=no --branch-sim=no \
        "$vim" -es -u NONE -i NONE --cmd "let g:ITER=$iter" \
        --cmd "let g:BENCH_OUT='$result'" -S "$file" \
        >/dev/null 2>"$out.log"; then
        echo "vim/valgrind failed for $file (see $out.log)" >&2
        return 1
    fi
    local ir check
    ir=$(total_ir "$out")
    check=$(sed -n 's/.*check=//p' "$result" 2>/dev/null)
    if ! [[ "$ir" =~ ^[0-9]+$ ]]; then
        echo "no Ir count from callgrind for $file (see $out.log)" >&2
        return 1
    fi
    if [ -z "$check" ]; then
        echo "bench wrote no check value for $file (did not complete)" >&2
        return 1
    fi
    echo "$ir $check"
}

# run_native <vim> <bench-file> <iter> <prefix> -> prints the min elapsed
# (seconds) over NATIVE_RUNS runs; returns non-zero on failure.
run_native() {
    local vim=$1 file=$2 iter=$3 pfx=$4
    local result="$pfx.nat" min="" e r
    for r in $(seq 1 "$NATIVE_RUNS"); do
        rm -f "$result"
        if ! "$vim" -es -u NONE -i NONE --cmd "let g:ITER=$iter" \
            --cmd "let g:BENCH_OUT='$result'" -S "$file" >/dev/null 2>&1; then
            echo "native run failed for $file" >&2
            return 1
        fi
        e=$(sed -n 's/.*elapsed=\([0-9.][0-9.]*\)s.*/\1/p' "$result" 2>/dev/null)
        [ -n "$e" ] || { echo "no elapsed for $file" >&2; return 1; }
        if [ -z "$min" ] || awk "BEGIN { exit !($e < $min) }"; then
            min=$e
        fi
    done
    echo "$min"
}

pct() {  # pct <base> <patched> -> signed percentage, e.g. "-10.08"
    awk "BEGIN { printf \"%+.2f\", ($2 - $1) * 100.0 / $1 }"
}

file_size() {  # file_size <file> -> size in bytes
    stat -c %s "$1" 2>/dev/null || wc -c <"$1"
}

stripped_size() {  # stripped_size <binary> -> size in bytes after stripping
    # The size a packaged binary ships at: distributions strip the symbol table.
    local tmp="$WORK/strip.tmp"
    cp "$1" "$tmp"
    strip "$tmp" 2>/dev/null || true
    file_size "$tmp"
    rm -f "$tmp"
}

echo "== building patched ($PATCHED_SHA) =="
git checkout --quiet "$PATCHED_SHA"
build_tree "$REPO_ROOT" patched

echo "== building base ($BASE_SHA) in a worktree =="
git worktree add --quiet --detach "$WORK/base" "$BASE_SHA"
build_tree "$WORK/base" base

fail=0
echo
echo "================ typval fast-path benchmark ================"
echo "base sha    : $BASE_SHA"
echo "patched sha : $PATCHED_SHA"
echo "------------------------------------------------------------"
echo "vim binary size (bytes, -O2, no -g):"
b_raw=$(file_size "$WORK/vim-base-rel");     p_raw=$(file_size "$WORK/vim-patched-rel")
b_str=$(stripped_size "$WORK/vim-base-rel"); p_str=$(stripped_size "$WORK/vim-patched-rel")
echo "  as built  : base=$b_raw patched=$p_raw  ($(pct "$b_raw" "$p_raw")%)"
echo "  stripped  : base=$b_str patched=$p_str  ($(pct "$b_str" "$p_str")%)"
for entry in "${BENCHES[@]}"; do
    IFS=: read -r name file cg_iter nat_iter <<<"$entry"
    echo "------------------------------------------------------------"
    echo "[$name] (callgrind ITER=$cg_iter, native ITER=$nat_iter)"

    # Callgrind (Ir, per-function) on the -g binary.  Command substitution (not
    # "read < <(...)") so a failed run trips the guard instead of silently
    # yielding empty/garbage fields.
    if ! base_out=$(run_cg "$WORK/vim-base-dbg" "$WORK/$file" "$cg_iter" "$WORK/cg-base-$name.out"); then
        echo "  ERROR: base callgrind run failed"; fail=1; continue
    fi
    if ! patched_out=$(run_cg "$WORK/vim-patched-dbg" "$WORK/$file" "$cg_iter" "$WORK/cg-patched-$name.out"); then
        echo "  ERROR: patched callgrind run failed"; fail=1; continue
    fi
    read -r base_ir base_chk <<<"$base_out"
    read -r patched_ir patched_chk <<<"$patched_out"

    # Per-function Ir of the out-of-line copy/clear.  On base these are
    # copy_tv/clear_tv (run for every type); on patched they are
    # copy_tv_inner/clear_tv_inner (only the non-scalar fallback) -- scalars are
    # handled inline at the call site and no longer reach an out-of-line call.
    b_cp=$(fn_ir "$WORK/cg-base-$name.out" copy_tv); b_cp=${b_cp:-0}
    b_cl=$(fn_ir "$WORK/cg-base-$name.out" clear_tv); b_cl=${b_cl:-0}
    p_cp=$(fn_ir "$WORK/cg-patched-$name.out" copy_tv_inner); p_cp=${p_cp:-0}
    p_cl=$(fn_ir "$WORK/cg-patched-$name.out" clear_tv_inner); p_cl=${p_cl:-0}

    # Native wall-clock on the user (-O2, no -g) binary; min of NATIVE_RUNS runs.
    base_t=$(run_native "$WORK/vim-base-rel" "$WORK/$file" "$nat_iter" "$WORK/nat-base-$name") || base_t=""
    patched_t=$(run_native "$WORK/vim-patched-rel" "$WORK/$file" "$nat_iter" "$WORK/nat-patched-$name") || patched_t=""

    echo "  check        : base=$base_chk patched=$patched_chk"
    echo "  Ir total     : base=$base_ir patched=$patched_ir  ($(pct "$base_ir" "$patched_ir")%)"
    echo "  Ir copy_tv   : base=$b_cp patched(inner)=$p_cp"
    echo "  Ir clear_tv  : base=$b_cl patched(inner)=$p_cl"
    if [ -n "$base_t" ] && [ -n "$patched_t" ]; then
        echo "  time min/$NATIVE_RUNS : base=${base_t}s patched=${patched_t}s  ($(pct "$base_t" "$patched_t")%)"
    else
        echo "  time         : (native run unavailable)"
    fi
    if [ "$base_chk" != "$patched_chk" ]; then
        echo "  ERROR: check value differs (correctness regression)"
        fail=1
    fi
done
echo "============================================================"

# Only correctness gates the job; Ir and timing are reported for the write-up.
# A small Ir/time increase on the container workload is expected (the scalar
# check adds a branch before the non-scalar fallback) and is not a failure.
exit $fail
