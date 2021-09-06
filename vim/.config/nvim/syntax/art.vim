" Vim syntax file
" Language: ART

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

syn keyword artPrelude prelude skipwhite nextgroup=artEvalBlock
syn keyword artSupport support skipwhite nextgroup=artEvalBlock

syn region artEvalBlock matchgroup=artBraces start='{' end='}' contained contains=artEvalBlock extend

syn match artVariableDef '<[^>]*>' contained contains=artVariableDefLAngleToken skipwhite nextgroup=artDefineOperator
syn match artVariableDefLAngleToken '<' contained nextgroup=artVariableDefIdent
syn match artVariableDefIdent '[A-Za-z][A-Za-z0-9]*' contained skipwhite nextgroup=artVariableDefColonToken
syn match artVariableDefColonToken ':' contained skipwhite nextgroup=artVariableDefType
syn match artVariableDefType '[A-Za-z][A-Za-z0-9]*' contained skipwhite nextgroup=artVariableDefIdent,artVariableDefRAngleToken
syn match artVariableDefRAngleToken '>' contained

syn match artDefineOperator '::=' contained skipwhite skipempty nextgroup=artExpr

syn match artExpr /\(\(&\=[A-Za-z][A-Za-z0-9_]*<\=\|'\([^']*\|\\[\\']\)*'\|`[A-Za-z0-9]\|#\)\^\{,3}\|(\*.\{-}\*)\|\/\*.\{-}\*\/\|\/\/.*$\)/ contains=artExprVariable,artExprLitStr,artExprLitChar,artExprEpsilon,artExprFoldTear,artNestComment,artBlockComment,artComment skipwhite skipempty nextgroup=artGlobal,artExpr,artExprBlock,artExprPipeToken,artVariableDef,artDefineOperator

syn match artExprVariable '&\=[A-Za-z][A-Za-z0-9_]*<\=' contained contains=artExprVariableBuiltIn,artExprVariableLArrow skipwhite skipempty
syn region artExprLitStr start=/'/ skip=/\\[\\']/ end=/'/ contained skipwhite skipempty
syn match artExprLitChar '`[A-Za-z0-9]' contained skipwhite skipempty
syn match artExprEpsilon '#' contained skipwhite skipempty

syn match artExprVariableBuiltIn '&' contained skipwhite skipempty
syn match artExprVariableLArrow '<' contained skipwhite skipempty
syn match artExprFoldTear '\^\{1,3}' contained skipwhite skipempty

syn region artExprBlock matchgroup=artBraces start='{' end='}' contains=artEvalBlock skipwhite skipempty nextgroup=artExpr,artExprPipeToken
syn match artExprPipeToken '|' skipwhite skipempty nextgroup=artExpr

syn region artNestComment start=/(\*/ end=/\*)/ contains=artNestComment skipwhite skipempty
syn region artBlockComment start=/\/\*/ end=/\*\// contains=artBlockComment skipwhite skipempty
syn match artComment '//.*$' contains=artComment skipwhite skipempty


" Highlighting

hi def link artPrelude Include
hi def link artSupport Define

hi def link artBraces Delimiter

hi def link artVariableDefLAngle Delimiter
hi def link artVariableDefIdent Identifier
hi def link artVariableDefColonToken Delimiter
hi def link artVariableDefType Type
hi def link artVariableDefRAngle Delimiter

hi def link artDefineOperator Operator

hi def link artExprVariable Constant
hi def link artExprVariableBuiltIn Operator
hi def link artExprVariableLArrow Operator
hi def link artExprFoldTear Operator
hi def link artExprLitStr String
hi def link artExprLitChar Character
hi def link artExprEpsilon String
hi def link artExprBlock Normal
hi def link artExprPipeToken Operator

hi def link artNestComment Comment
hi def link artBlockComment Comment
hi def link artComment Comment

let b:current_syntax = 'ART'

let &cpo = s:cpo_save
unlet s:cpo_save
