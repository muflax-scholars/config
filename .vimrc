"colors
set t_Co=256
set background=dark
colorscheme inkpot

"basic options
syntax on
set nocompatible
set history=100
set ruler
set fileencodings=ucs-bom,utf8,euc-jp,shift-jis,default,latin1
set ttyfast
set nobackup
set showtabline=2

"save last 1000 jumps and global marks
set viminfo='1000,f1 

"allow increment / decrement of single chars
set nrformats=hex,alpha

"line length
set textwidth=80
"t wrap text
"c and comments,
"r comment leader on <Enter>,
"q allow gq,
"n numbered lists,
"m break multi-byte
set formatoptions=tcrqnm

"search
set incsearch
set ignorecase  
set smartcase
set hlsearch

"indenting
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set backspace=indent,eol,start
filetype plugin indent on

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
set foldlevel=1
nnoremap <space> za
vnoremap <space> zf
au FileType c set foldmethod=syntax
au FileType cpp set foldmethod=syntax
au FileType perl set foldmethod=syntax

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
"noremap <tab> gt
"noremap <s-tab> gT

"Jesus saves
cabbr jesus write

"perldo is too long
cabbr pd perldo

"faster writing
map WW :w<CR>

"perl stuff
let perl_include_pod = 1
let perl_extended_vars = 1
let perl_fold = 1
"let perl_fold_blocks

"supertab
let g:SuperTabDefaultCompletionType = "context"

"toggle paste with F3
:set pastetoggle=<F3>

"underline with F11 (=) / F12 (-)
nnoremap <F11> yyp<c-v>$r=
inoremap <F11> <Esc>yyp<c-v>$r=o
nnoremap <F12> yyp<c-v>$r-
inoremap <F12> <Esc>yyp<c-v>$r-o
