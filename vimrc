" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"Want status line always
set laststatus=2

" Want UTF-8 encoding
set encoding=utf-8
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching


set t_Co=256
colors xoria256
if !has("gui_running")
	"set term=screen-256color-bce
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=r
endif

set vb
set t_vb=
set foldenable
set foldmethod=marker
set expandtab		"insert spaces instead of tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=80
set autoindent
set nosmartindent
set hlsearch
set incsearch
set history=500
set smartcase
set backspace=indent,eol,start
set laststatus=2
set cursorline
set ruler
set showmode
set number
set whichwrap=h,l,<,>,[,]
set showcmd
set modeline
set wildmenu
set splitbelow
set formatoptions+=l		"Don't break long lines
set selection=inclusive
set autowrite			"Write out the file when changing buffers
set cinoptions=g0,:0,l1,(0,t0	"Fix some dumb indentation rules
set shortmess=a
"set complete=.,t,i,b,w,k
"set completeopt+=longest
"set nowildmenu
"set wildchar=<tab>
"set wildmode=longest:full,full
set previewheight=5
set matchpairs+=<:>
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=n::
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		" Also don't do it when the mark is in the first line, that is the default
		" position when opening a file.
		autocmd BufReadPost *
					\ if line("'\"") > 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif

	augroup END

	au BufNewFile,BufRead *.repy set filetype=python
	au BufRead /tmp/mutt-* set tw=72 spell
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

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

" Cursor keys suck. Use ctrl with home keys to move in insert mode.
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>


" Powerline goodnes
"let g:Powerline_symbols = 'fancy'
"let g:Powerline_cache_file = expand("~/.vim//.Powerline.cache")
"source ~/git/powerline/powerline/bindings/vim/plugin/source_plugin.vim
"python from powerline.bindings.vim import source_plugin; source_plugin()
"set rtp+=/usr/lib/python3.3/site-packages/powerline/bindings/vim

"let g:jedi#use_tabs_not_buffers = 0
