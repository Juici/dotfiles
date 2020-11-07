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
" Generic
"

" Line comment.
syn region tigComment start='#' end='$' keepend

" Statement.
syn cluster tigStatement contains=tigComment,tigSetStatement,tigBindStatement


"
" Set statement
"

syn region tigSetStatement start='^\s*\<set\>\@=' skip='\\\n' end='\($\|#\)\@=' keepend contains=tigSet,tigSetEq nextgroup=@tigStatement

syn keyword tigSet set contained skipwhite nextgroup=tigVar,tigView

syn keyword tigVar nextgroup=tigSetEqVarValue skipwhite contained diff-options blame-options log-options main-options reference-format line-graphics truncation-delimiter horizontal-scroll git-colors show-notes show-changes show-untracked vertical-split split-view-height split-view-width status-show-untracked-dirs status-show-untracked-files tab-size diff-context diff-highlight ignore-space commit-order ignore-case mailmap wrap-lines focus-child send-child-enter editor-line-number history-size mouse mouse-scroll mouse-wheel-cursor pgrp start-on-head refresh-mode refresh-interval file-args rev-args wrap-search
syn keyword tigView nextgroup=tigSetEqColumns skipwhite contained blob-view diff-view log-view pager-view stage-view blame-view grep-view main-view reflog-view refs-view stash-view status-view tree-view

syn match tigSetEqVarValue '=' nextgroup=@tigVarValue skipwhite contained
syn match tigSetEqColumns '=' nextgroup=tigColumns skipwhite contained

syn cluster tigVarValue contains=tigVarStringUnq,tigVarStringDq,tigVarStringSq,tigVarBool,tigVarBool,tigVarInt,tigVarConstant
syn match tigVarStringUnq '\S\+' nextgroup=tigVarStringUnq skipwhite contained
syn region tigVarStringDq start='"' skip='\\"' end='"' contained
syn region tigVarStringSq start="'" skip="\\'" end="'" contained
syn keyword tigVarBool contained  true false yes no
syn match tigVarInt '\d\+%\?' contained
syn keyword tigVarConstant contained  ascii default utf-8 auto all some at-eol topo date author-date reverse smart-case manual after-command periodic

syn region tigColumns start='=\@<=' skip='\\\n' end='\($\|#\)\@=' keepend contains=@tigColumn contained
syn cluster tigColumn contains=tigColumnType

syn keyword tigColumnType nextgroup=tigColumnOptions skipwhite contained  author commit-title date file-name file-size id line-number mode ref status text

syn region tigColumnOptions contained matchgroup=tigColumnColon start=':' skip='\\\n' end='\(\s\|$\)\@=' keepend contains=@tigColumnOption,tigColumnComma

syn match tigColumnComma ',' contained nextgroup=@tigColumnOption

syn cluster tigColumnOption contains=tigColumnOptionName,@tigColumnValue
syn keyword tigColumnOptionName contained nextgroup=tigColumnOptionEq   display width maxwidth graph refs overflow local format interval commit-title-overflow color
syn match tigColumnOptionEq '=' contained nextgroup=@tigColumnValue

syn cluster tigColumnValue contains=tigColumnStringUnq,tigColumnStringDq,tigColumnStringSq,tigColumnBool,tigColumnInt,tigColumnConstant
syn match tigColumnStringUnq '[^[:space:],=]\+' contained
syn region tigColumnStringDq start='"' skip='\\"' end='"' contained nextgroup=tigColumnComma
syn region tigColumnStringSq start="'" skip="\\'" end="'" contained nextgroup=tigColumnComma
syn keyword tigColumnBool       contained nextgroup=tigColumnComma  true false yes no
syn match tigColumnInt '\d\+'   contained nextgroup=tigColumnComma
syn keyword tigColumnConstant   contained nextgroup=tigColumnComma  full abbreviated email email-user relative relative-compact custom default auto always default units short long

"
" Bind statement
"

syn region tigBindStatement start='^\s*\<bind\>\@=' skip='\\\n' end='\($\|#\)\@=' nextgroup=@tigStatement keepend contains=tigBind

syn keyword tigBind bind nextgroup=tigBindKeymap skipwhite contained
syn keyword tigBindKeymap nextgroup=tigBindKey skipwhite contained  main diff log reflog help pager status stage tree blob blame refs stash grep generic search
syn match tigBindKey '\S\+' nextgroup=tigBindAction skipwhite contained
syn region tigBindAction start='' skip='\\\n' end='\($\|#\)\@=' contained


"
" Links
"

" Set statements.

hi def link tigSet tigKeyword

hi def link tigVar  tigIdent
hi def link tigView tigIdent

hi def link tigSetEq          tigOp
hi def link tigSetEqVarValue  tigSetEq
hi def link tigSetEqColumns   tigSetEq

hi def link tigVarStringUnq tigString
hi def link tigVarStringDq  tigString
hi def link tigVarStringSq  tigString
hi def link tigVarBool      tigBoolean
hi def link tigVarInt       tigNumber
hi def link tigVarConstant  tigConstant

hi def link tigColumnType   tigType
hi def link tigColumnColon  tigDelim
hi def link tigColumnComma  tigDelim

hi def link tigColumnOptionName tigType
hi def link tigColumnOptionEq   tigDelim

hi def link tigColumnStringUnq  tigString
hi def link tigColumnStringDq   tigString
hi def link tigColumnStringSq   tigString
hi def link tigColumnBool       tigBoolean
hi def link tigColumnInt        tigNumber
hi def link tigColumnConstant   tigConstant


" Bind statements.

hi def link tigBind       tigKeyword
hi def link tigBindKeymap tigType
hi def link tigBindKey    tigIdent
hi def link tigBindAction tigString


" Generic

hi def link tigComment    Comment

hi def link tigKeyword    Statement
hi def link tigIdent      Identifier
hi def link tigType       Type

hi def link tigOp         Operator
hi def link tigDelim      Delimiter

hi def link tigString     String
hi def link tigBoolean    Boolean
hi def link tigNumber     Number
hi def link tigConstant   Constant


let b:current_syntax = 'Tig config'

let &cpo = s:cpo_save
unlet s:cpo_save
