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
"
" yank {{{
augroup Yank
  au!
  if executable("win32yank.exe")
    autocmd TextYankPost * :call system('win32yank.exe -i', @")
  endif
augroup END
noremap <silent> p :call setreg('"',system('win32yank.exe -o --lf'))<CR>""p
" }}}

" plugin settings {{{
filetype plugin on

let g:sonictemplate_vim_template_dir = [
\ '$HOME/.vim/sonictemplate'
\]
"}}}

" tagbar {{{
let g:tagbar_type_ansible = {
  \ 'ctagstype' : 'ansible',
  \ 'kinds' : [
    \ 't:tasks'
  \ ],
  \ 'sort' : 0
\ }

let g:tagbar_type_go = {
  \ 'ctagstype': 'go',
  \ 'kinds' : [
    \'f:function',
    \'v:variables',
    \'t:type',
    \'c:const'
  \]
\}
let g:tagbar_type_json = {
    \ 'ctagstype' : 'json',
    \ 'kinds' : [
      \ 'o:objects',
      \ 'a:arrays',
      \ 'n:numbers',
      \ 's:strings',
      \ 'b:booleans',
      \ 'z:nulls'
    \ ],
  \ 'sro' : '.',
    \ 'scope2kind': {
    \ 'object': 'o',
      \ 'array': 'a',
      \ 'number': 'n',
      \ 'string': 's',
      \ 'boolean': 'b',
      \ 'null': 'z'
    \ },
    \ 'kind2scope': {
    \ 'o': 'object',
      \ 'a': 'array',
      \ 'n': 'number',
      \ 's': 'string',
      \ 'b': 'boolean',
      \ 'z': 'null'
    \ },
    \ 'sort' : 0
    \ }
let g:tagbar_type_make = {
            \ 'kinds':[
                \ 'm:macros',
                \ 't:targets'
            \ ]
\}
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3',
        \ 'l:Heading_L4'
    \ ]
\ }
let g:tagbar_type_yaml = {
    \ 'ctagstype' : 'yaml',
    \ 'kinds' : [
        \ 'a:anchors',
        \ 's:section',
        \ 'e:entry'
    \ ],
  \ 'sro' : '.',
    \ 'scope2kind': {
      \ 'section': 's',
      \ 'entry': 'e'
    \ },
    \ 'kind2scope': {
      \ 's': 'section',
      \ 'e': 'entry'
    \ },
    \ 'sort' : 0
    \ }
" }}}

" goimports {{{
let g:goimports_simplify = 1
let g:goimports_local = 'github.com/0delta,local.package,local.packages'
" }}}

" lazyload
augroup lazy_load_i
  autocmd!
  autocmd! InsertEnter * call s:lazy_config_insert()
augroup END

function! s:lazy_timer(timer)
  set background=dark
  colorscheme iceberg
  highlight Normal ctermbg=NONE guibg=NONE
  highlight NonText ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
  packadd tagbar
endfunction

function! s:lazy_config_insert()
endfunction

function! s:lazy_config_go()
endfunction

function! s:lsp_user_buffer_enabled()
  setl omnifunc=lsp#complete
endfunction

augroup lazy_load
  autocmd!
  autocmd FileType go call s:lazy_config_go()
  autocmd User lsp_buffer_enabled nested call s:lsp_user_buffer_enabled()
augroup END

let lezy_load_timer = timer_start(0, function("s:lazy_timer"))
packadd vim-lsp
packadd vim-lsp-settings

let g:preview_markdown_auto_update=1

