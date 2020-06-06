" Plugins {{{
" Initialize plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible' " Defaults
Plug 'tpope/vim-fugitive' " Git stuff
Plug 'airblade/vim-gitgutter' " Git gutter
Plug 'tpope/vim-surround' " Surrounds
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder
Plug 'sheerun/vim-polyglot' " Syntax highlighting
Plug 'styled-components/vim-styled-components', { 'branch': 'main' } " CSS in JS syntax support
Plug 'itchyny/lightline.vim' " Status line
Plug 'tpope/vim-commentary' " Code commenting
Plug 'tpope/vim-unimpaired' " Bracket mappings
Plug 'christoomey/vim-tmux-navigator' " Tmux integration
Plug 'joshdick/onedark.vim' " Theme
Plug 'ntpeters/vim-better-whitespace' " Whitespace highlighting and removal
Plug 'jiangmiao/auto-pairs' " Auto pairs
Plug 'preservim/nerdtree' " Nerd tree
Plug 'Xuyuanp/nerdtree-git-plugin' " Nerd tree git
Plug 'neoclide/coc.nvim', { 'branch': 'release' } " Intellisense
Plug 'alvan/vim-closetag' " Auto close tags
Plug 'psliwka/vim-smoothie' " Smooth scrolling
Plug 'vimwiki/vimwiki' " Wiki
Plug 'tpope/vim-sleuth' " Indentation
call plug#end()
" }}}
" Styles {{{
colorscheme onedark
let g:onedark_terminal_italics = 1
" Normally, vim-sleuth will infer the correct indentation. However, in cases where the desired
" indentation cannot be inferred, vim-sleuth normally defaults to 8 spaces, which is... not great.
" This changes that, so that the default is set to 2 spaces for certain filetypes, and 4 spaces for
" everything else.
if get(g:, '_has_set_default_indent_settings', 0) == 0
  " Set the indenting level to 2 spaces for the following file types.
  autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml
    \ setlocal expandtab tabstop=2 shiftwidth=2
  set expandtab
  set tabstop=4
  set shiftwidth=4
  let g:_has_set_default_indent_settings = 1
endif
" Enable italics
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
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
" Diff coloring
hi DiffAdd ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse
hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse
hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse
" More accurate syntax highlighting for js/ts files, at the expense of speed
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
" }}}
" Mappings {{{
" Leader mappings
let mapleader = " "
let maplocalleader = ","
nnoremap <space> <nop>
" Easy editing of vimrc
nnoremap <leader>ev :tabe ~/.vimrc<cr>
" Quickfix toggling
nnoremap <leader>qt :call <SID>ToggleQuickfix()<cr>
function! s:ToggleQuickfix()
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&syntax') ==# 'qf'
      cclose
      return
    endif
  endfor
  copen
endfunction
" Automatically open quickfix after search
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup end
" Shorcuts for tabs
nnoremap <leader>tn :tabn<cr>
nnoremap <leader>tp :tabp<cr>
" Replacement for <C-i>, since it is the same as <TAB> and used by COC
nnoremap <C-l> <tab>
" Easy toggling
nnoremap <leader>z za
nnoremap <leader>Z :call <SID>ToggleGlobalFold()<cr>
function! s:ToggleGlobalFold()
  let currentLineHasFold = foldlevel('.') != 0
  let currentFoldIsOpen = foldclosed('.') == -1
  if currentLineHasFold && currentFoldIsOpen
    " Close all folds
    normal! zM
  else
    " Open all folds
    normal! zR
  endif
endfunction
nnoremap <leader>gg :silent grep!<space>
" Merge conflict resolution
" LO is for local
nnoremap <leader>dl :diffg LO<cr>
" RE is for remote
nnoremap <leader>dr :diffg RE<cr>
" Grep operator {{{
" g@ calls the function assigned to operatorfunc as an operator
" <SID> allows for referencing a value that's scoped to the current script
nnoremap <leader>go :set operatorfunc=<SID>GrepOperator<cr>g@
" <c-u> means 'delete from the cursor to the beginning of the line', removing the '<,'> that
" automaticaly gets added by vim to indicate the operation should apply to the selected text.
" visualmode() is a built-in function returning a one-character string representing the type of
" visual mode used (characterwise, linewise, blockwise).
vnoremap <leader>go :<c-u>call <SID>GrepOperator(visualmode())<cr>
" The s: prefix places this in the current script's namespace
function! s:GrepOperator(type)
  let savedUnnamedRegister = @@
  if a:type ==# 'v' " we're in characterwise visual mode
    normal! `<v`>y
  elseif a:type ==# 'char' " we're in normal mode using a characterwise motion
    normal! `[v`]y
  else " ignore linewise and blockwise motions
    return
  endif
  silent execute "grep! " . shellescape(@@)
  copen
  let @@ = savedUnnamedRegister
endfunction
" }}}
" }}}
" Settings {{{
syntax on " Syntax highlighting
set number " Show line numbers
set relativenumber " Relative line numbers
set linebreak " Break lines at word (requires Wrap lines)
set showbreak=+++ " Wrap-broken line prefix
set textwidth=100 " Line wrap (number of cols)
set showmatch " Highlight matching brace
set noerrorbells visualbell t_vb= " Disable beeping/flashing on errors
set hlsearch " Highlight all search results
set smartcase " Enable smart-case search
set ignorecase " Always case-insensitive
set incsearch " Searches for strings incrementally
set autoindent " Auto-indent new lines
set expandtab " Use spaces instead of tabs
set smartindent " Enable smart-indent
set smarttab " Enable smart-tabs
set undolevels=1000 " Number of undo levels
set backspace=indent,eol,start " Backspace behaviour
set autoread " Reload files when they change on disk
set clipboard+=unnamedplus " Enable copying from vim
set splitright " Open new vertical splits to the right instead of the left
set splitbelow " Open new horizontal splits below rather than above
set nocompatible " Requested by VimWiki
filetype plugin on
augroup VimFileSettings
  autocmd!
  autocmd FileType vim set foldmethod=marker | set foldlevelstart=0
augroup end
" }}}
" Plugin settings {{{
" Better whitespace {{{
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0
let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf', 'help']
" }}}
" Closetag {{{
let g:closetag_filenames = '*.html,*.jsx,*.tsx' " filenames where the plugin is enabled.
let g:closetag_xhtml_filenames = '*.html,*.jsx,*.tsx' " make non-closing tags self-closing.
let g:closetag_filetypes = 'html,jsx,tsx' " file types where the plugin is enabled.
let g:closetag_xhtml_filetypes = 'html,jsx,tsx' " make non-closing tags self-closing.
let g:closetag_emptyTags_caseSensitive = 1 " make non-closing tags case-sensitive (e.g. `<Link>` will be closed while`<link>` won't.)
" Disable auto-close if not in a 'valid' region (based on filetype)
let g:closetag_regions = {
  \ 'typescriptreact': 'jsxRegion,tsxRegion',
  \ 'typescript.tsx': 'jsxRegion,tsxRegion',
  \ 'javascript.jsx': 'jsxRegion',
  \ }
" }}}
" CoC {{{
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-python',
  \ 'coc-phpls',
  \ 'coc-go'
  \ ]
set hidden " TextEdit might fail if hidden is not set.
set nobackup " Some servers have issues with backup files, see #649.
set nowritebackup
set cmdheight=2 " Give more space for displaying messages.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
augroup CocHoldHighlight
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Run Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" }}}
" Ctrl-P {{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --hidden\ --ignore\ .git " Use ag over grep
  let g:ctrlp_user_command = 'ag %s -l --hidden --ignore .git --nocolor -g ""'
  let g:ctrlp_use_caching = 0 " ag is fast enough that CtrlP doesn't need to cache
endif
" }}}
" Lightline {{{
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
    \ 'left': [
      \ [ 'mode', 'paste' ],
      \ [ 'readonly', 'filename', 'modified', 'gitbranch' ]
    \ ]
  \ },
  \ 'component_function': {
    \ 'gitbranch': 'FugitiveHead'
  \ }
\ }
function! s:LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction
" Reload lightline when re-sourcing vimrc
augroup ReloadLightline
  autocmd!
  autocmd SourcePost *.vimrc call <SID>LightlineReload()
augroup end
" }}}
" NerdTree {{{
augroup NerdTreeOnQuit
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
map <C-n> :NERDTreeToggle<CR>
map <leader>n :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '.DS_Store']
let NERDTreeShowLineNumbers=1
let g:NERDTreeWinSize=50
" }}}
" Tmux navigator {{{
" Prevents unzooming when accidentally navigating beyond edges
let g:tmux_navigator_disable_when_zoomed = 1
" }}}
" Vimwiki {{{
" Use markdown instead of default syntax
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
" Make sure vim only treats markdown files in the wiki directory as vimwiki files
let g:vimwiki_global_ext = 0
" }}}
" }}}

