" Vim filetype detection file
" Syntax:       Personal Notes Syntax

if &compatible || version < 600
    finish
endif

" Detect notes from this extension
au BufNewFile,BufRead *.note	    set filetype=notes
au BufNewFile,BufRead *.notes	    set filetype=notes
au BufNewFile,BufRead *.txt	        set filetype=notes
au BufNewFile,BufRead ~/spoiler/*	set filetype=notes
au BufNewFile,BufRead *.mkd	        set filetype=notes
au BufNewFile,BufRead *.pdc	        set filetype=notes
au BufNewFile,BufRead README        set filetype=notes
syn clear
