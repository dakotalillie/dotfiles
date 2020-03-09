" Plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Defaults
Plug 'tpope/vim-sensible'

" Git stuff
Plug 'tpope/vim-fugitive'

" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Status line
Plug 'vim-airline/vim-airline'

" Code commenting
Plug 'tpope/vim-commentary'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'

" Theme
Plug 'joshdick/onedark.vim'

" Auto pairs
Plug 'jiangmiao/auto-pairs'

" Prettier
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Nerd tree
Plug 'preservim/nerdtree'

call plug#end()

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
" if (empty($TMUX))
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif
" endif

colorscheme onedark
let g:onedark_terminal_italics = 0
let g:airline_theme='onedark'

" Ctrl-P config
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" Diff coloring
hi DiffAdd ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse
hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse
hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse

" Syntax highlighting
syntax on

" Show line numbers
set number

" Relative line numbers
set relativenumber

" Break lines at word (requires Wrap lines)
set linebreak	

" Wrap-broken line prefix
set showbreak=+++

" Line wrap (number of cols)
set textwidth=100

" Highlight matching brace
set showmatch

" Disable beeping/flashing on errors
set noerrorbells visualbell t_vb=
 
" Highlight all search results
set hlsearch

" Enable smart-case search
set smartcase

" Always case-insensitive
set ignorecase

" Searches for strings incrementally
set incsearch
 
" Auto-indent new lines
set autoindent

" Use spaces instead of tabs
set expandtab

" Number of auto-indent spaces
set shiftwidth=2

" Enable smart-indent
set smartindent

" Enable smart-tabs
set smarttab

" Number of spaces per Tab
set softtabstop=2
 
" Number of undo levels
set undolevels=1000

" Backspace behaviour
set backspace=indent,eol,start

