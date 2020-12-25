set encoding=UTF-8
scriptencoding UTF-8
set nobomb

let mapleader='`'

" Plugins with VimPlug
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
  let NERDTreeMapJumpNextSibling = '<Leader>j'
  let NERDTreeMapJumpPrevSibling = '<Leader>k'
  let NERDTreeShowHidden=1
  let g:NERDTreeWinPos = 'right'
  map <C-n> :NERDTreeToggle<CR>
  map <C-f> :NERDTreeFind<CR>
Plug 'ryanoasis/vim-devicons'

Plug 'preservim/nerdcommenter'
  let g:NERDCreateDefaultMappings = 0
  let g:NERDDefaultAlign = 'left'
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

Plug 'preservim/tagbar'
  nnoremap <F8> :TagbarToggle<CR>

Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'dense-analysis/ale'
  let g:ale_linters = {
      \ 'cpp': ['clangd'],
      \ }
  let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'sh': ['shfmt'],
      \ 'cpp': ['clang-format'],
      \ 'cmake': [],
      \ 'html': ['prettier'],
      \ 'haskell': ['brittany']
      \ }
  let g:ale_fix_on_save = 1
  let g:ale_lint_delay = 1000
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  nmap <silent> [a <Plug>(ale_previous_wrap)
  nmap <silent> ]a <Plug>(ale_next_wrap)

Plug 'Raimondi/delimitMate'
  let delimitMate_expand_cr=1
  let delimitMate_expand_space=1

Plug 'glepnir/galaxyline.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }

Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
  " Magic buffer-picking mode
  nnoremap <silent> <C-s> :BufferPick<CR>
  " Sort automatically by...
  nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
  nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
  " Move to previous/next
  nnoremap <silent>    <A-,> :BufferPrevious<CR>
  nnoremap <silent>    <A-.> :BufferNext<CR>
  " Re-order to previous/next
  nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
  nnoremap <silent>    <A->> :BufferMoveNext<CR>
  " Goto buffer in position...
  nnoremap <silent>    <A-1> :BufferGoto 1<CR>
  nnoremap <silent>    <A-2> :BufferGoto 2<CR>
  nnoremap <silent>    <A-3> :BufferGoto 3<CR>
  nnoremap <silent>    <A-4> :BufferGoto 4<CR>
  nnoremap <silent>    <A-5> :BufferGoto 5<CR>
  nnoremap <silent>    <A-6> :BufferGoto 6<CR>
  nnoremap <silent>    <A-7> :BufferGoto 7<CR>
  nnoremap <silent>    <A-8> :BufferGoto 8<CR>
  nnoremap <silent>    <A-9> :BufferLast<CR>
  " Close buffer
  nnoremap <silent>    <A-c> :BufferClose<CR>

"Plug 'vim-airline/vim-airline'
"  let g:airline_theme='nord'
"  let g:airline#extensions#ale#enabled = 1
"  let g:airline_powerline_fonts = 1

" Vim Theme
Plug 'arcticicestudio/nord-vim'

Plug 'mattn/emmet-vim'
  let g:user_emmet_leader_key = ','
  let g:user_emmet_install_global = 0
  augroup emmet
    autocmd!
    autocmd FileType html,css EmmetInstall
  augroup END

Plug 'junegunn/rainbow_parentheses.vim'
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['{', '}'], ['[', ']']]
  let g:rainbow#blacklist = [248, 59, 239, 238]
  augroup rainbow
    autocmd!
    " cmake syntax highlight conflict with RainbowParentheses
    let ftToIgnRainbow = ['cmake']
    autocmd BufEnter *
        \ if index(ftToIgnRainbow, &ft) < 0 |
        \   RainbowParentheses |
        \ else |
        \   RainbowParentheses! |
        \ endif
  augroup END

Plug 'liuchengxu/vista.vim'
  let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
  let g:vista_executive_for = {
      \ 'vim': 'ctags',
      \ 'cpp': 'coc',
      \ 'rust': 'coc',
      \ 'javascript': 'coc',
      \ 'html': 'coc',
      \ 'haskell': 'coc'
      \ }
  let g:vista_update_on_text_changed = 1
  let g:vista_update_on_text_changed_delay = 3000
  nmap <Leader><F8> :Vista!!<CR>

Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'easymotion/vim-easymotion'

Plug 'Yggdroot/indentLine'
  let g:indentLine_char = '┆'
  augroup IndentLineDisableJsonConceal
    autocmd!
    autocmd FileType json let g:indentLine_setConceal = 0
  augroup END

Plug 'rust-lang/rust.vim'
Plug 'turbio/bracey.vim'
Plug 'tjdevries/coc-zsh'
Plug 'dag/vim-fish'
Plug 'pboettch/vim-cmake-syntax'
Plug 'airblade/vim-gitgutter'

call plug#end()

luafile ~/.config/nvim/spaceline.lua
"luafile ~/.config/nvim/eviline.lua

set number
set ruler
set title
set wrap
set cursorline
set linebreak
set showmatch
set showcmd
set hidden
set belloff=all
set laststatus=2
set scrolloff=5

" Line length guide
set colorcolumn=80

" Indent setting
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

" tags
set tags=./tags;/

" mouse setting
set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Preview replace
if has('nvim')
  set inccommand=nosplit
endif

if !has('gui_running')
  set t_Co=256
endif

" Syntax Highlighting
if has('syntax')
  syntax on
endif

if &shell =~# 'fish$'
  set shell=sh
endif

augroup NewBuffer
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "norm g`\"" |
      \ endif
augroup END

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme nord

" Change Color Highlight
" No background color for transparency
"highlight Normal guibg=NONE ctermbg=NONE
" for ALEWarning
highlight SpellCap gui=underline cterm=underline guibg=NONE ctermbg=NONE
" for bufferline(barbar.nvim)
highlight BufferCurrentMod guifg=lightgreen guibg=#2e3440
highlight BufferVisibleMod guifg=lightgreen guibg=#4c566a
highlight BufferInactiveMod guifg=lightgreen guibg=#3b4252

augroup file_type
  autocmd!
  "autocmd FileType cpp nmap <buffer> <F5>
  "    \ :wa<cr>:!g++ -g -o %:r.out % && ./%:r.out<cr>
  autocmd FileType vim,sh,zsh,html setlocal shiftwidth=2 tabstop=2
  autocmd FileType help,h wincmd L
augroup END

" skip over closing parenthesis
"inoremap <expr> <Tab> stridx('])}"', getline('.')[col('.')-1])==-1 ?
"    \ "\t" : "\<Right>"

" termdebug setting
packadd termdebug
  let g:termdebug_wide=1
  nnoremap <F5> :silent! Termdebug<CR>
  nnoremap <Leader><F5> :Run<CR>
  nnoremap <F6> :Step<CR>
  nnoremap <Leader><F6> :Over<CR>
  nnoremap <F7> :Continue<CR>
  nnoremap <F9> :Break<CR>
  nnoremap <F10> :Stop<CR>

nmap <Leader>h :bprevious<CR>
nmap <Leader>l :bnext<CR>

" close buffer
nmap <leader>qq :bp <BAR> bd #<CR>

" resize split window
nnoremap <C-W><C-h> :vertical resize -5<CR>
nnoremap <C-W><C-j> :resize -2<CR>
nnoremap <C-W><C-k> :resize +2<CR>
nnoremap <C-W><C-l> :vertical resize +5<CR>

"===================
" Coc.nvim settings
"===================

" Extensions for install
let g:coc_global_extensions = [
    \ 'coc-cmake', 'coc-clangd', 'coc-vimlsp', 'coc-rust-analyzer',
    \ 'coc-html', 'coc-json', 'coc-eslint', 'coc-tsserver', 'coc-prettier',
    \ 'coc-css', 'coc-stylelint', 'coc-emmet', 'coc-sh', 'coc-snippets',
    \ 'coc-lua'
    \ ]

" Coc Configs
call coc#config('coc.preferences.formatOnSaveFiletypes', [
    \ 'javascript', 'css', 'markdown', 'rust'
    \ ])

call coc#config('languageserver', {
    \ 'haskell': {
    \   'command': 'haskell-language-server-wrapper',
    \   'args': ['--lsp'],
    \   'rootPatterns': [
    \     '*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml'
    \   ],
    \   'filetypes': ['haskell', 'lhaskell']
    \ }})

call coc#config('clangd.semanticHighlighting', v:true)
call coc#config('clangd.arguments', ['-header-insertion=never'])

call coc#config('prettier.tabWidth', 4)

" for scrolling popup
nnoremap <expr> <c-d> coc#float#has_float() ? coc#float#scroll(1,2) : '<c-d>'
nnoremap <expr> <c-u> coc#float#has_float() ? coc#float#scroll(0,2) : '<c-u>'

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" stridx(... for skip closing brakets and braces
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ coc#expandableOrJumpable() ?
    \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ stridx('])}"', getline('.')[col('.')-1])!=-1 ? "\<Right>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" '\<c-r>=coc#on_enter()\<CR>' for delimitMate_expand_cr
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ?
      \ "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ?
      \ "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endif

" GoTo code navigation.
nnoremap <silent> gd :<C-u>call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent> gy :<C-u>call CocActionAsync('jumpTypeDefinition')<CR>
nnoremap <silent> gi :<C-u>call CocActionAsync('jumpImplementation')<CR>
nnoremap <silent> gr :<C-u>call CocActionAsync('jumpReferences')<CR>

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
augroup CocHighlight
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>