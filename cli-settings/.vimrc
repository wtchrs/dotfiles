let mapleader="`"

" Plugins with VimPlug
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
  let NERDTreeMapJumpNextSibling = "<Leader>j"
  let NERDTreeMapJumpPrevSibling = "<Leader>k"
  let NERDTreeShowHidden=1
  let g:NERDTreeWinPos = "right"
  map <C-n> :NERDTreeToggle<CR>
  map <C-f> :NERDTreeFind<CR>

Plug 'preservim/nerdcommenter'
  let g:NERDCreateDefaultMappings = 0
  let g:NERDDefaultAlign = 'left'
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-pathogen'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'Raimondi/delimitMate'
  let delimitMate_expand_cr=1
  let delimitMate_expand_space=1

Plug 'vim-airline/vim-airline'
  let g:airline_theme='bubblegum'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1

Plug 'vim-airline/vim-airline-themes'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'joshdick/onedark.vim'

Plug 'mattn/emmet-vim'
  let g:user_emmet_leader_key = ','

Plug 'junegunn/rainbow_parentheses.vim', {'on': 'RainbowParentheses'}
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['{', '}'], ['[', ']']]
  let g:rainbow#blacklist = [248, 59, 239, 238]
  autocmd VimEnter * RainbowParentheses

Plug 'liuchengxu/vista.vim'
  let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
  let g:vista_executive_for = {
      \ 'cpp': 'ctags',
      \ 'rust': 'coc',
      \ 'javascript': 'coc',
      \ 'html': 'coc',
      \ 'haskell': 'coc'
      \ }
  let g:vista_update_on_text_changed = 1
  let g:vista_update_on_text_changed_delay = 3000
  nmap <F8> :Vista!!<CR>

Plug 'jackguo380/vim-lsp-cxx-highlight'
"Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'rhysd/vim-clang-format'
  let g:clang_format#detect_style_file = 1
  " map to <Leader>cf in C++ code
  autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
  " auto-enabling auto-formating
  autocmd FileType c,cpp ClangFormatAutoEnable

"Plug 'kana/vim-operator-user'
Plug 'easymotion/vim-easymotion'

Plug 'Yggdroot/indentLine'
  let g:indentLine_char = '┆'

Plug 'rust-lang/rust.vim'
Plug 'turbio/bracey.vim'
Plug 'tjdevries/coc-zsh'
Plug 'ryanoasis/vim-devicons'

call plug#end()

set encoding=UTF-8
set nobomb

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

" Line length guide
set colorcolumn=80

" Indent setting
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

" mouse setting
set mouse=a
set ttymouse=xterm2


if !has('gui_running')
  set t_Co=256
endif

" Syntax Highlighting
if has('syntax')
  syntax on
endif

au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "norm g`\"" |
    \ endif

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme onedark

" No background color for transparency
hi Normal guibg=NONE ctermbg=NONE

autocmd FileType vim setlocal shiftwidth=2 tabstop=2

" skip over closing parenthesis
"inoremap <expr> <Tab> stridx('])}"', getline('.')[col('.')-1])==-1 ? "\t" : "\<Right>"

" termdebug setting
packadd termdebug
let g:termdebug_wide=1

" shortcut for buffers and bufferline
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

nmap <Leader>h :bprevious<CR>
nmap <Leader>l :bnext<CR>

nmap <leader>qq :bp <BAR> bd #<CR>

" shortcut for split window
nnoremap <Leader>vs :rightbelow vnew<CR>

" new buffer [No Name]
nnoremap <Leader>n :enew<CR>

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"===================
" Coc.nvim settings
"===================

" Extensions for install
let g:coc_global_extensions = [
    \ 'coc-cmake', 'coc-clangd', 'coc-vimlsp', 'coc-rust-analyzer',
    \ 'coc-html', 'coc-json', 'coc-eslint', 'coc-tsserver', 'coc-prettier',
    \ 'coc-css', 'coc-stylelint', 'coc-emmet', 'coc-sh', 'coc-snippets'
    \ ]

" Coc Configs
call coc#config('coc.preferences.formatOnSaveFiletypes', [
    \ "html", "javascript", "css", "markdown", "rust"
    \ ])

call coc#config('languageserver', {
    \ "haskell": {
    \   "command": "haskell-language-server-wrapper",
    \   "args": ["--lsp"],
    \   "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
    \   "filetypes": ["haskell", "lhaskell"]
    \ }})

call coc#config('clangd.semanticHighlighting', v:true)
call coc#config('clangd.arguments', ["-header-insertion=never"])

call coc#config('prettier.tabWidth', 4)

" for scrolling popup
nnoremap <expr> <c-d> <SID>scroll_cursor_popup(1) ? '<esc>' : '<c-d>'
nnoremap <expr> <c-u> <SID>scroll_cursor_popup(0) ? '<esc>' : '<c-u>'

function s:find_cursor_popup(...)
  let radius = get(a:000, 0, 2)
  let srow = screenrow()
  let scol = screencol()

  " it's necessary to test entire rect, as some popup might be quite small
  for r in range(srow - radius, srow + radius)
    for c in range(scol - radius, scol + radius)
      let winid = popup_locate(r, c)
      if winid != 0
        return winid
      endif
    endfor
  endfor

  return 0
endfunction

function s:scroll_cursor_popup(down)
  let winid = s:find_cursor_popup()
  if winid == 0
    return 0
  endif

  let pp = popup_getpos(winid)
  call popup_setoptions( winid, {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )

  return 1
endfunction

set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=number

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
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
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

