" syntaxMarkerFold
" Maintainer:  Jorengarenar <https://joren.ga>
" License:     MIT

" if exists('g:loaded_syntaxMarkerFold') | finish | endif
let s:cpoptions = &cpoptions | set cpoptions&vim

" let s:attr = ' transparent fold containedin=Comment '
let s:attr = ' fold keepend matchgroup=Comment containedin=vimQuoteComment contains=ALL '

" Folds above level
function! s:init_levels(level, mark1, mark2) abort
  let [head, tail] = ['\m\s\+', '\(\s.*\)\?$']
  let other = '\%(' . a:mark1 . '\|' . a:mark2 . '\)'
  let other = other . '[' . join(range(a:level), '') . ']'
  let other = '\%(' . a:mark1 . a:level . '\|' . other . '\)'
  let back = '\ze\n.*'
  exec 'syn region syntaxMarkerFold' . s:attr
    \ ' start = /' . head . a:mark1 . a:level . tail . '/'
    \ ' end = /' . head . a:mark2 . a:level . '\?' . tail . '/'
    \ ' end = /\ze.*' . head . other . tail . '/'
endfunction

" General folds
function! s:init() abort
  let [mark1, mark2] = split(&l:foldmarker, ',')
  let [head, tail] = ['\m\s\+', '\(\s.*\)\?$']
  silent! syn clear syntaxMarkerFold
  exec 'syn region syntaxMarkerFold ' . s:attr
    \ ' start = /' . head . mark1 . tail . '/'
    \ ' end = /' . head . mark2 . tail . '/'
  let name = 'syntaxMarkerFold_maxlevel'
  let nmax = get(b:, name, get(g:, name, 5))
  for level in range(1, nmax)
    call s:init_levels(level, mark1, mark2)
  endfor
endfunction

augroup syntaxMarkerFold
  autocmd!
  autocmd Syntax *\v\c(off)@<! call s:init()
  autocmd OptionSet foldmarker call s:init()
augroup END

let g:loaded_syntaxMarkerFold = 1
let &cpoptions = s:cpoptions | unlet s:cpoptions
