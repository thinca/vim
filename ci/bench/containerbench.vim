vim9script
# ./vim -es -u NONE -i NONE -S containerbench.vim ; cat /tmp/containerbench.txt
# override iterations: --cmd "let g:ITER = 2000"  (small for callgrind)
# override output path: --cmd "let g:BENCH_OUT = '/path/out.txt'"
#
# Non-scalar-heavy counterpart to scalarbench.vim: hammers copy_tv()/clear_tv()
# on strings, lists and dicts (deepcopy / slice / extend / remove / scope exit),
# so any regression from the scalar fast-path's extra branch on non-scalar
# values would show here.
const OUT = exists('g:BENCH_OUT') ? g:BENCH_OUT : '/tmp/containerbench.txt'
def Build(n: number): list<dict<any>>
  var out: list<dict<any>> = []
  for i in range(n)
    out->add({
      name: 'item_' .. i,
      tag: 'tag_' .. (i % 7),
      vals: [string(i), string(i * 2), string(i * 3)],
      meta: {a: 'x' .. i, b: 'y' .. i},
    })
  endfor
  return out
enddef
def Churn(base: list<dict<any>>): number
  var total = 0
  var c = deepcopy(base)		# copy_tv over every nested string/list/dict
  var s = c[0 : len(c) / 2]		# list slice: copy_tv of dict refs
  c->extend(s)
  for d in c
    total += len(d.name) + len(d.vals)
    for v in d.vals
      total += str2nr(v)		# fold the copied value content, not just its length
    endfor
    if has_key(d, 'meta')
      total += len(d.meta) + len(d.meta.a) + len(d.meta.b)
    endif
  endfor
  while len(c) > 0
    remove(c, 0)			# clear_tv of non-scalar items
  endwhile
  return total
enddef
def Main()
  var iter = 20000
  if exists('g:ITER')
    iter = g:ITER
  endif
  var base = Build(32)
  var t = reltime()
  var acc = 0
  for _ in range(iter)
    acc += Churn(base)
  endfor
  writefile([printf('ITER=%d elapsed=%.3fs check=%d',
    iter, reltimefloat(reltime(t)), acc)], OUT)
enddef
try
  Main()
catch
  writefile(['EXC: ' .. v:exception .. ' @ ' .. v:throwpoint], OUT)
endtry
qall!
