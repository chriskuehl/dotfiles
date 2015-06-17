" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

set t_Co=256

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Plugins
execute pathogen#infect()

map <C-n> :NERDTreeTabsToggle<CR>

" Tab movement
map <C-H> gT
map <C-L> gt

"map <C-H> :execute "tabmove" tabpagenr() - 2 <CR>
"map <C-L> :execute "tabmove" tabpagenr() <CR>

syntax on
set hidden

" Reload files modified outside vim
set autoread

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-C> to temporarily turn off highlighting)
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

"------------------------------------------------------------
" Indentation options {{{1

set shiftwidth=4
set tabstop=4
set softtabstop=4
set noexpandtab

" allow toggling between local and default mode
function TabToggle()
	if &expandtab
		set noexpandtab
	else
		set expandtab
	endif
endfunction

nmap <F9> :call TabToggle()<CR>

"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Ctrl-C to disable highlighting
nnoremap <C-C> :nohl<CR><silent><C-C>

nnoremap j gj
nnoremap k gk

colorscheme ron

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=blue guibg=blue
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" airline
let g:airline_theme             = 'luna'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1

" Map <C-J> to split line
nnoremap <NL> i<CR><ESC>

" Ignore dependencies and spam for ctrlp
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

autocmd FileType python setlocal et
autocmd FileType email setlocal et
autocmd FileType mail setlocal et
autocmd FileType markdown setlocal et sw=4 sts=4 ts=4
autocmd FileType ruby setlocal et sw=2 sts=2 ts=2
autocmd FileType puppet setlocal et sw=2 sts=2 ts=2
autocmd FileType cucumber setlocal et sw=4 sts=4 ts=4
