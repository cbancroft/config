set cmdheight=1
set nocompatible        " use gVim defaults
set encoding=utf-8
syntax on               " enable syntax highlighting

if v:version >= 700
	"set cursorline
	set listchars+=tab:»·,trail:·,extends:~,nbsp:.
endif

if has("gui_running")
    let &guicursor = &guicursor . ",a:blinkon0"
    set guioptions-=T
    set guioptions+=g
    set guioptions-=t
    set guioptions-=m
    set guioptions-=L
    set guioptions-=l
    set guioptions-=r
    set guioptions-=R
    set guioptions-=e
    set guioptions-=r
    set guioptions+=a
    set guioptions+=c
    set t_Co=256
    colorscheme xoria256
    "colorscheme wombat2
    set anti " Antialias font
    set guitablabel=%t " set label for tab to just file name
    if has ('win32')
        set columns=120
        set lines=60
        set guifont=Bitstream_Vera_Sans_Mono:h8:cANSI
    else
        "set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
        set guifont=Terminus\ 8
    endif
elseif (&term =~ 'screen' || &term =~ 'linux' || &term =~ 'rxvt-unicode-256color')
    set t_Co=256
    set mouse=r
    set termencoding=utf-8
    set nocursorline
    colorscheme xoria256
    "colorscheme wombat2
else
    set t_Co=256
    "colorscheme xoria256
    colorscheme wombat2
    set mouse=r
    set ttymouse=xterm
    set termencoding=utf-8
endif

set shell=/bin/bash
set vb
set t_vb=
set foldenable
set foldmethod=marker
set expandtab           " insert spaces instead of tab chars
set tabstop=4           " a n-space tab width
set shiftwidth=4        " allows the use of < and > for VISUAL indenting
set softtabstop=4       " counts n spaces when DELETE or BCKSPCE is used
set textwidth=80
set autoindent          " auto indents next new line
set nosmartindent       " intelligent indenting -- DEPRECATED by cindent
set hlsearch            " highlight all search results
set incsearch           " increment search
"set ignorecase          " case-insensitive search
set smartcase           " upper-case sensitive search
set backspace=indent,eol,start
set history=500         " 100 lines of command line history
set cmdheight=1         " command line height
set laststatus=2        " occasions to show status line, 2=always.
set ruler               " ruler display in status line
set showmode            " show mode at bottom of screen
set number              " show line numbers
set nobackup            " disable backup files (filename~)
"set showmatch           " show matching brackets (),{},[]
set whichwrap=h,l,<,>,[,]
set showcmd
set modeline
set wildmenu
set splitbelow
set formatoptions+=l
set cursorline
set selection=inclusive
set autowrite
set cinoptions=g0,:0,l1,(0,t0
set shortmess=a
set complete=.,t,i,b,w,k
set wildchar=<tab>
set wildmenu
set wildmode=longest:full,full
set previewheight=5
" let &background = "dark"
" Set up the status line
fun! <SID>SetStatusLine()
    let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
    let l:s2="[%{strlen(&filetype)?&filetype:'?'},%{&encoding},%{&fileformat}]"
    let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
    execute "set statusline=" . l:s1 . l:s2 . l:s3
endfun
set laststatus=2
call <SID>SetStatusLine()

" common save shortcuts
inoremap <C-s> <esc>:w<cr>a
nnoremap <C-s> :w<cr>

" mutt rules
au BufRead /tmp/mutt-* set tw=72 spell

" drupal rules
if has("autocmd")
    augroup module
        autocmd BufRead *.module set filetype=php
    augroup END
endif

" Set taglist plugin options
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 0
let Tlist_Inc_Winwidth = 1

" Set bracket matching and comment formats
set matchpairs+=<:>
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=n::

" Basic abbreviations
iab teh the
iab DATE <C-R>=strftime("%B %d, %Y (%A, %H:%M)")<CR>

" Fix filetype detection
au BufNewFile,BufRead .torsmorc* set filetype=rc
au BufNewFile,BufRead *.inc set filetype=php
au BufNewFile,BufRead *.sys set filetype=php
au BufNewFile,BufRead grub.conf set filetype=grub
au BufNewFile,BufRead *.dentry set filetype=dentry
au BufNewFile,BufRead *.blog set filetype=blog
au BufNewFile,BufRead .fonts.conf set filetype=xml

" C file specific options
au FileType c,cpp set cindent
au FileType c,cpp set formatoptions+=ro
au FileType lua set cindent

" HTML abbreviations
au FileType html,xhtml,php,eruby imap bbb <br />
au FileType html,xhtml,php,eruby imap aaa <a href=""><left><left>
au FileType html,xhtml,php,eruby imap iii <img src="" /><left><left><left><left>
au FileType html,xhtml,php,eruby imap ddd <div class=""><left><left>

" Compile and run keymappings
au FileType c,cpp map <F5> :!./%:r<CR>
au FileType java map <F5> :make %<CR>
au FileType sh,php,perl,python,ruby map <F5> :!./%<CR>
au FileType java map <F6> :java %:r
au FileType c,cpp map <F6> :make<CR>
au FileType php map <F6> :!php &<CR>
au FileType python map <F6> :!python %<CR>
au FileType perl map <F6> :!perl %<CR>
au FileType ruby map <F6> :!ruby %<CR>
au FileType html,xhtml map <F5> :!firefox3 %<CR>
au FileType ruby setlocal sts=2 sw=2				" Enable width of 2 for ruby tabbing

" MS Word document reading
au BufReadPre *.doc set ro
au BufReadPre *.doc set hlsearch!
au BufReadPost *.doc %!antiword "%"

" Toggle dark/light default colour theme for shitty terms
map <F2> :let &background = ( &background == "dark" ? "light" : "dark" )<CR>

" Toggle taglist script
map <F7> :Tlist<CR>

" Cursor keys suck. Use ctrl with home keys to move in insert mode.
"imap <C-h> <Left>
"imap <C-j> <Down>
"imap <C-k> <Up>
"imap <C-l> <Right>

" Prevent annoying typo
imap <F1> <esc>
nmap q: :q<cr>

" Do Toggle Commentify
map <M-c> :call ToggleCommentify()<CR>j
imap <M-c> <ESC>:call ToggleCommentify()<CR>j

" VTreeExplorer
map <F12> :VSTreeExplore <CR>
let g:treeExplVertical=1
let g:treeExplWinSize=35
let g:treeExplDirSort=1

set makeprg=jikes\ %
"set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set errorformat=%f:%l:%c:%*\d:%*\d:%*\s%m
" Basics
syntax on               " enable syntax highlighting
set showmatch           " show matching brackets (),{},[]
set number
set nocompatible
"set background=light
set encoding=utf-8
filetype on
set complete=k          " global autocompletion
set completeopt+=longest

" Set bracket matching and comment formats
set matchpairs+=<:>
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=n::


" C file specific options
au FileType c,cpp set cindent
au FileType c,cpp set formatoptions+=ro

" HTML abbreviations
" Session Settings
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
map <c-q> :mksession! ~/.vim/.session <cr>


" Turn off blinking
set visualbell
" Turn off beep
set noerrorbells
set t_vb=

" highlight redundant whitespaces and tabs.
" highlight RedundantSpaces ctermbg=red guibg=red
" match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

"set t_Co=256
"colorscheme wombat2
