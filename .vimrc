"colors
set t_Co=256
set background=dark
colorscheme inkpot

"basic options
set nocompatible
set backspace=indent,eol,start
set autoindent
set history=100
set ruler
set textwidth=80
set formatoptions=rq
set fileencodings=ucs-bom,utf8,euc-jp,shift-jis,default,latin1
set ttyfast
set nobackup
set showtabline=2
syntax on

"search
set incsearch
set ignorecase  
set smartcase

"tab indent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

"virtual edit
set virtualedit=all
set mouse=v

"wrap line, mark with +
set lbr
set showbreak=+

"disable highlighting
map <F5> :set hls!<bar>set hls?<CR>

"move up and down in wrapped, not real lines
map <Down> gj
map <Up> gk

"tag browser to look up methods
au FileType python set tags+=$HOME/.vim/tags/python.ctags
au FileType c set tags+=$HOME/.vim/tags/c.ctags
"noremap <silent><C-> <C-T>
"noremap <silent><C-> <C-]>

"code completion, <Nul> is Ctrl-Space
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
inoremap <Nul> <C-x><C-o>

"folding, set foldlevel to something high to circumvent starting with closed
"folds
"set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf
au FileType c set foldmethod=syntax

"buffer switching with <f1>, <f2>
noremap <f1> :bprev<CR>
noremap <f2> :bnext<CR> 

"vim-explorer
let g:VEConf_showHiddenFiles = 0
let g:VEConf_filePanelSortType = 1

"more useful indent keys
no <C-d> >>
no <C-t> <<

"switch tabs with Shift/Ctrl-Tab
noremap <tab> gt
noremap <s-tab> gT

"Jesus saves
cabbr jesus write

"mutt
au BufRead /tmp/mutt-* set tw=72

