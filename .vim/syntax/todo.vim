syntax region todoTag start=/\[/ end=/\]/
syntax region todoDone start=/^\s*x /ms=e-1 end=/^\s*[_x\-.]/me=s-1

hi link todoTag Constant
if &background == "light"
  hi todoDone ctermfg=darkgray guifg=#999999
else
  hi todoDone ctermfg=darkgray guifg=#666666
endif

set cursorline

command! -nargs=0 TodoToggle call TodoToggle()
function! TodoToggle()
  if !empty(matchstr(getline('.'), '\(\s*\)x '))
    s/\(\s*\)x /\1_ /
  elseif !empty(matchstr(getline('.'), '\(\s*\)_ '))
    s/\(\s*\)_ /\1x /
  endif
endfunction

command! -nargs=0 TodoDone call TodoDone()
function! TodoDone()
  if !empty(matchstr(getline('.'), '\(\s*\)[_\-.] '))
    s/\(\s*\)[_\-.] /\1x /
  endif
endfunction

command! -nargs=0 TodoUndone call TodoUndone()
function! TodoUndone()
  if !empty(matchstr(getline('.'), '\(\s*\)[x\-.] '))
    s/\(\s*\)[x\-.] /\1_ /
  endif
endfunction

map <Leader>tt :TodoToggle<CR><Esc>
map <Leader>td :TodoDone<CR><Esc>
map <Leader>tu :TodoUndone<CR><Esc>

let b:current_syntax = "todo"
