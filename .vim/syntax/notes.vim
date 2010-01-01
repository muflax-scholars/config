" personalised syntax for note-taking

syn case match

" some keywords and basic formatting
syn match notes_keywords /#TODO/
syn match notes_keywords /#FIXME/
syn match notes_keywords /#DONE/
syn match notes_keywords /#RESEARCH/
hi def link notes_keywords Todo

syn match notes_arrows /\(-\+\|=\+\)>/
syn match notes_arrows /<\(-\+\|=\+\)/
hi def link notes_arrows Special

syn region notes_italic start=/_/ skip=/\w_\w/ end=/_/ oneline
syn region notes_bold start=/\*/ skip=/\w\*\w/ end=/\*/ oneline
hi def link notes_italic Underlined
hi def link notes_bold String

" comments
syn region notes_comment start=/\/\*/ end=/\*\//
hi def link notes_comment Comment

" sentences starting with - or * are bullets
syn match notes_bullet /^\s*- /
syn match notes_bullet /^\s*\* /
hi def link notes_bullet Label

" titles
syn match notes_title /^\s*[=-]\+$/
hi def link notes_title Title 

" a synchronisation guideline for basic synching
syntax sync minlines=40 maxlines=500
let b:current_syntax="notes"
