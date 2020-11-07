" Vim syntax file
" Language: Tig config

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

"
" Settings
"

set iskeyword=@,48-57,_,-

"
" Comments
"

" Line comment.
syn region tigComment start='#' end='$' keepend

"
" Statement
"

syn cluster tigStatement contains=tigSetStatement

"
" Set statement
"

syn cluster tigSetStatement contains=tigSet

syn keyword tigSet set skipwhite nextgroup=tigVar,tigView

syn keyword tigVar contained diff-options blame-options log-options main-options reference-format line-graphics truncation-delimiter horizontal-scroll git-colors show-notes show-changes show-untracked vertical-split split-view-height split-view-width status-show-untracked-dirs status-show-untracked-files tab-size diff-context diff-highlight ignore-space commit-order ignore-case mailmap wrap-lines focus-child send-child-enter editor-line-number history-size mouse mouse-scroll mouse-wheel-cursor pgrp start-on-head refresh-mode refresh-interval file-args rev-args wrap-search
syn keyword tigView contained blob-view diff-view log-view pager-view stage-view blame-view grep-view main-view reflog-view refs-view stash-view status-view tree-view

syn region tigSetExpr matchgroup=tigSetEq start='=' skip='\\\n' end='\($\|#\)\@=' keepend contains=@tigVarValue,@tigColumn nextgroup=tigStatement

syn cluster tigVarValue contains=tigVarBool,tigVarBool,tigVarInt,tigVarStringDq,tigVarStringSq,tigVarStringUnq,tigVarConstant
syn match tigVarStringUnq '\S\+' contained
syn keyword tigVarBool  contained
      \ true false yes no
syn match tigVarInt '\d\+%\?' contained
syn region tigVarStringDq start='"' skip='\\"' end='"' contained
syn region tigVarStringSq start="'" skip="\\'" end="'" contained
syn keyword tigVarConstant contained
      \ ascii default utf-8 auto all some at-eol topo date author-date reverse smart-case manual after-command periodic

syn cluster tigColumn contains=tigColumnType

syn keyword tigColumnType contained skipwhite nextgroup=tigColumnOptions author commit-title date file-name file-size id line-number mode ref status text

syn region tigColumnOptions contained matchgroup=tigColumnColon start=':' skip='\\\n' end='\(\s\|$\)\@=' keepend contains=@tigColumnOption,tigColumnComma

syn match tigColumnComma ',' contained nextgroup=@tigColumnOption

syn cluster tigColumnOption contains=tigColumnOptionName,@tigColumnValue
syn keyword tigColumnOptionName contained nextgroup=tigColumnOptionEq
      \ display width maxwidth graph refs overflow local format interval commit-title-overflow color
syn match tigColumnOptionEq '=' contained nextgroup=@tigColumnValue

syn cluster tigColumnValue contains=tigColumnBool,tigColumnInt,tigColumnStringDq,tigColumnStringSq,tigColumnConstant
syn keyword tigColumnBool       contained nextgroup=tigColumnComma
      \ true false yes no
syn match tigColumnInt '\d\+'   contained nextgroup=tigColumnComma
syn region tigColumnStringDq start='"' skip='\\"' end='"' contained nextgroup=tigColumnComma
syn region tigColumnStringSq start="'" skip="\\'" end="'" contained nextgroup=tigColumnComma
syn keyword tigColumnConstant   contained nextgroup=tigColumnComma
      \ full abbreviated email email-user
      \ relative relative-compact custom default
      \ auto always
      \ default units
      \ short long

"
" Links
"

" Comments

hi def link tigComment Comment


" Set statements.

hi def link tigSet Define

hi def link tigVar  Identifier
hi def link tigView Identifier

hi def link tigSetEq Operator

hi def link tigVarBool      Boolean
hi def link tigVarInt       Number
hi def link tigVarStringDq  String
hi def link tigVarStringSq  String
hi def link tigVarStringUnq String
hi def link tigVarConstant  Constant

hi def link tigColumnType Identifier

hi def link tigColumnColon  Delimiter
hi def link tigColumnComma  Delimiter

hi def link tigColumnOptionName Type
hi def link tigColumnOptionEq   Operator

hi def link tigColumnBool       Boolean
hi def link tigColumnInt        Number
hi def link tigColumnStringDq   String
hi def link tigColumnStringSq   String
hi def link tigColumnConstant   Constant


" Generic

hi def link tigOp     Operator


let b:current_syntax = 'Tig config'

let &cpo = s:cpo_save
unlet s:cpo_save
