set encoding=utf-8
scriptencoding utf-8

nnoremap ; :
inoremap jk <Esc>

" レコーディングモードの一部無効化
nnoremap qH <Nop>
nnoremap qJ <Nop>
nnoremap qK <Nop>
nnoremap qL <Nop>
nnoremap qQ <Nop>

nnoremap qh <Nop>
nnoremap qj <Nop>
nnoremap qk <Nop>
nnoremap ql <Nop>
nnoremap qq <Nop>

set relativenumber
set number
set ruler
set showcmd
set showmatch
set hlsearch
set textwidth=0
set scrolloff=10
set cursorline
set list

set laststatus=2
syntax enable

" 背景透過{{{
augroup TransparentBG
  autocmd!
  autocmd Colorscheme * highlight Normal ctermbg=none
  autocmd Colorscheme * highlight NonText ctermbg=none
  " autocmd Colorscheme * highlight LineNr ctermbg=none
  " autocmd Colorscheme * highlight Folded ctermbg=none
  autocmd Colorscheme * highlight EndOfBuffer ctermbg=none 
augroup END
"}}}

" indent移動 {{{
function! s:same_indent(dir) abort
  let lnum = line('.')
  let width = col('.') <= 1 ? 0 : strdisplaywidth(matchstr(getline(lnum)[: col('.')-2], '^\s*'))
  while 1 <= lnum && lnum <= line('$')
    let lnum += (a:dir ==# '+' ? 1 : -1)
    let line = getline(lnum)
    if width >= strdisplaywidth(matchstr(line, '^\s*')) && line =~# '^\s*\S'
      break
    endif
  endwhile
  return abs(line('.') - lnum) . a:dir
endfunction
nnoremap <expr><silent> aj <SID>same_indent('+')
nnoremap <expr><silent> ak <SID>same_indent('-')
onoremap <expr><silent> aj <SID>same_indent('+')
onoremap <expr><silent> ak <SID>same_indent('-')
xnoremap <expr><silent> aj <SID>same_indent('+')
xnoremap <expr><silent> ak <SID>same_indent('-')
"}}}

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" lazyload
augroup lazy_load_i
  autocmd!
  autocmd! InsertEnter * call s:lazy_config_insert()
augroup END

function! s:lazy_config_insert()
  packadd vim-lsp
  packadd vim-lsp-settings
endfunction

function! s:lazy_config_vim()
endfunction

augroup lazy_load
  autocmd!
  autocmd FileType vim call s:lazy_config_vim()
augroup END
