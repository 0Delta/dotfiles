" base {{{
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
set cursorcolumn
set list

set laststatus=2
syntax enable
" }}}

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
" augroup Yank
"   au!
"   if executable("gocopy.exe")
"     autocmd TextYankPost * :call system('gocopy.exe', @")
"   endif
" augroup END
" if executable("gopaste.exe")
"   noremap <silent> p :call setreg('"',system('gopaste.exe'))<CR>""p
" endif
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

" fold {{{
function! Json_fold(lnum)
  set debug=msg
  let l:thisline = getline(a:lnum)
  if match(l:thisline, '^.*[[{][^\]}]*$') >= 0
    return 'a1'
  elseif match(l:thisline, '^[^{[]*[}\]]') >= 0
    return 's1'
  else
    return '='
  endif
endfunction

function! Json_fold_text()
  if v:foldlevel == 2
    let i = 0
    let sev = "UNKNOWN"
    let mes = ""
    while i < v:foldend - v:foldstart
      let i += 1
      let line2 = getline(v:foldstart+i)
      if match(line2, 'severity') >= 0
        let line2 = substitute(line2, '.*:\s*"', '', 'g')
        let sev = substitute(line2, '",', '', 'g')
      endif
      let line2 = getline(v:foldstart+i)
      if match(line2, 'message') >= 0
        let mes = line2
      endif
      let line2 = getline(v:foldstart+i)
      if match(line2, 'logName') >= 0
        if mes == ""
          let mes = line2
        endif
      endif
    endwhile
    return v:folddashes . sev . " " . mes
  endif
  let line = getline(v:foldstart)
  let sub = substitute(line, '^.\{-}"', '', 'g')
  let sub = substitute(sub, '".*$', '', 'g')
  return repeat("  ", v:foldlevel) . sub
endfunction

function! Go_fold(lnum)
  " set debug=msg
  let l:thisline = getline(a:lnum)
  if match(l:thisline, '^import (') >= 0
    return '1'
  elseif match(l:thisline, '^func') >= 0
    return '1'
  elseif match(l:thisline, '^type.*{') >= 0
    return '1'
  elseif match(l:thisline, '^var (') >= 0
    return '1'
  elseif match(l:thisline, '^const (') >= 0
    return '1'
  elseif match(l:thisline, '^)') >= 0
    return '<1'
  elseif match(l:thisline, '^}') >= 0
    return '<1'
  elseif match(l:thisline, '^\s*if err != nil {') >= 0
    return '2'
  elseif match(l:thisline, '^\s*}') >= 0
    return '<2'
  else
    return '='
  endif
endfunction

function! Go_fold_text()
  let line = getline(v:foldstart)
  if v:foldlevel == 1
    let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    return v:folddashes . " " . sub
  elseif v:foldlevel == 2
    let i = 0
    let line = substitute(line, 'if err != nil {', 'iferr:', 'g')
    let line = substitute(line, '\t', '  ', 'g')
    let sub = line
    while i < v:foldend - v:foldstart
      let i += 1
      let line2 = getline(v:foldstart+i)
      let line2 = substitute(line2, '\s', ' ', 'g')
      let line2 = substitute(line2, 'return', '↗', 'g')
      let line2 = substitute(line2, '}', '', 'g')
      let sub = sub . line2
    endwhile
    return sub
  else
    let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    return v:folddashes . " " . sub
  endif
endfunction

function! Vim_fold(lnum)
  set debug=msg
  let l:thisline = getline(a:lnum)
  if match(l:thisline, '^".*{{{') >= 0
    return '1'
  elseif match(l:thisline, '^".*}}}') >= 0
    return '<1'
  else
    return '='
  endif
endfunction
" }}}

" lsp {{{
packadd vim-lsp
packadd vim-lsp-settings

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

augroup LspAutoFmt
"  autocmd BufWritePre *.kt LspDocumentFormatSync
  autocmd BufWritePre *.go LspDocumentFormatSync redraw!
  autocmd BufWritePre *.md LspDocumentFormatSync redraw!
augroup END

nnoremap <M-j> yy
nnoremap <A-j> yy

function! s:lsp_user_buffer_enabled()
  setl omnifunc=lsp#complete
endfunction

if !has('nvim')
  let g:lsp_diagnostics_float_cursor = 1
endif

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_settings_filetype_go=['golangci-lint-langserver', 'gopls']
let g:lsp_settings_filetype_json=['vscode-json-language-server']
let g:lsp_settings_filetype_markdown=['efm-langserver']
let g:lsp_untitled_buffer_enabled=0
let g:lsp_settings = {
\  'pylsp-all': {
\    'workspace_config': {
\      'pylsp': {
\        'configurationSources': ['flake8'],
\        'plugins': {
\          'pycodestyle': {
\            'ignore': ["E501"]
\          }
\        }
\      }
\    }
\  },
\  'efm-langserver': {
\    'disabled': v:false,
\    'allowlist': ['markdown'],
\  },
\}

" }}}

" lazyload {{{
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
  highlight CursorColumn ctermbg=NONE guibg=NONE ctermfg=darkgray guifg=darkgray
  packadd tagbar
  packadd vim-showtime
endfunction


function! s:lazy_config_insert()
endfunction

function! s:lazy_config_json()
  " set foldmethod=syntax
  packadd vim-jsbeautify
  set foldmethod=expr
  set foldexpr=Json_fold(v:lnum)
  set foldtext=Json_fold_text()
  map <c-f> :call JsonBeautify()<cr>
  autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
endfunction

function! s:lazy_config_go()
  " set foldmethod=syntax
  set foldmethod=expr
  set foldexpr=Go_fold(v:lnum)
  set foldtext=Go_fold_text()
  set foldnestmax=2

  let g:goimports = 1
endfunction

function! s:lazy_config_vim()
  set foldmethod=expr
  set foldexpr=Vim_fold(v:lnum)
  set foldnestmax=1
endfunction

function! s:lazy_config_js()
  packadd vim-jsbeautify
  map <c-f> :call JsBeautify()<cr>
  autocmd FileType javascript vnoremap <buffer> <c-f> :call RangeJsBeautify()<cr>
endfunction

function! s:lazy_config_jsx()
  packadd vim-jsbeautify
  map <c-f> :call JsxBeautify()<cr>
  autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
endfunction

function! s:lazy_config_html()
  packadd vim-jsbeautify
  map <c-f> :call HtmlBeautify()<cr>
  autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
endfunction

function! s:lazy_config_css()
  packadd vim-jsbeautify
  map <c-f> :call CssBeautify()<cr>
  autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
endfunction

augroup lazy_load
  autocmd!
  autocmd FileType go call s:lazy_config_go()
  autocmd FileType json call s:lazy_config_json()
  autocmd FileType vim call s:lazy_config_vim()
  autocmd FileType javascript call s:lazy_config_js()
  autocmd FileType jsx call s:lazy_config_jsx()
  autocmd FileType html call s:lazy_config_html()
  autocmd FileType css call s:lazy_config_css()
  autocmd User lsp_buffer_enabled nested call s:lsp_user_buffer_enabled()
augroup END

let lezy_load_timer = timer_start(0, function("s:lazy_timer"))
" }}}

augroup Indent
  autocmd!
  autocmd Filetype vim setl tabstop=2 shiftwidth=2 expandtab
  autocmd Filetype kotlin setl tabstop=4 shiftwidth=4 expandtab
augroup END

let g:fern#default_exclude = '^\%(\.git\|\go.sum\)$'
let g:preview_markdown_auto_update=1

" tasker
" ref: https://blog.ksoichiro.com/ja/post/2018/12/vim/
augroup Todo
  autocmd!
  autocmd BufNewFile,BufRead *.todo setf todo
augroup END

