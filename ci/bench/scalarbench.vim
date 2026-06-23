vim9script
# ./vim -es -u NONE -i NONE -S scalarbench.vim ; cat /tmp/scalarbench.txt
# override iterations: --cmd "let g:ITER = 4000"  (small for callgrind)
# override output path: --cmd "let g:BENCH_OUT = '/path/out.txt'"
#
# Scalar-heavy workload (the fast-path's best case): a Sieve of Eratosthenes
# over a reused list<bool>.  Each pass resets, sieves and counts purely through
# list-index reads and writes of scalar typvals plus arithmetic and
# comparisons; the list is allocated once (outside the loop) and no builtin or
# string work is in the hot path, so the inline copy_tv()/clear_tv() win is
# what moves the number.
const OUT = exists('g:BENCH_OUT') ? g:BENCH_OUT : '/tmp/scalarbench.txt'
def CountPrimes(sieve: list<bool>): number
  var n = len(sieve)
  var k = 0
  while k < n
    sieve[k] = true			# reset: scalar store (clear_tv + copy_tv)
    k += 1
  endwhile
  var i = 2
  while i * i < n
    if sieve[i]
      var j = i * i
      while j < n
        sieve[j] = false		# mark composite: scalar store
        j += i
      endwhile
    endif
    i += 1
  endwhile
  var count = 0
  i = 2
  while i < n
    if sieve[i]				# read scalar onto the stack
      count += 1
    endif
    i += 1
  endwhile
  return count
enddef
def Main()
  var iter = 200000
  if exists('g:ITER')
    iter = g:ITER
  endif
  var sieve: list<bool> = []
  for _ in range(2000)
    sieve->add(true)			# allocate once, outside the timed loop
  endfor
  var t = reltime()
  var acc = 0
  for _ in range(iter)
    acc += CountPrimes(sieve)		# pi(2000) = 303, so check = iter * 303
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
