set encoding=UTF-8
"set autoindent
"set cindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set number
set ruler
set title
set wrap
set cursorline
set linebreak
set showmatch
set mouse=a
set showcmd
set hidden
"set showtabline=2
set belloff=all

set background=dark

let mapleader="`"

set laststatus=2
"set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\

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

if (has("termguicolors"))
    set termguicolors
endif

" Plugins with VimPlug
call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-pathogen'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'tag': '*'}
Plug 'Raimondi/delimitMate'
"Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'bling/vim-bufferline'
Plug 'joshdick/onedark.vim'
"Plug 'morhetz/gruvbox'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mattn/emmet-vim'
Plug 'junegunn/rainbow_parentheses.vim', {'on': 'RainbowParentheses'}
Plug 'liuchengxu/vista.vim'
"Plug 'WolfgangMehner/bash-support'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'rhysd/vim-clang-format'
"Plug 'kana/vim-operator-user'
Plug 'easymotion/vim-easymotion'

call plug#end()

set background=dark
colorscheme onedark

" No background color for transparency
hi Normal guibg=NONE ctermbg=NONE

" termdebug setting
packadd termdebug
let g:termdebug_wide=1

" airline setting
let g:airline_theme='bubblegum'

let g:airline#extensions#tabline#enabled = 1

let g:airline_powerline_fonts = 1

" Vista.vim setting
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

" RainbowParenthesis
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['{', '}'], ['[', ']']]
autocmd VimEnter * RainbowParentheses

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

" Emmet-vim Plugin setting
let g:user_emmet_leader_key = ','

" NERDTree Plugin setting
map <C-n> :NERDTreeToggle<CR>
map <C-f> :NERDTreeFind<CR>

let NERDTreeMapJumpNextSibling = "<Leader>j"
let NERDTreeMapJumpPrevSibling = "<Leader>k"

let NERDTreeShowHidden=1
let g:NERDTreeWinPos = "right"

" NERDCommenter Plugin setting
let g:NERDCreateDefaultMappings = 0
let g:NERDDefaultAlign = 'left'

nmap <Leader>/ <Plug>NERDCommenterToggle
xmap <Leader>/ <Plug>NERDCommenterToggle

" delimitMate setting
let delimitMate_expand_cr=1

" vim-clang-format setting
let g:clang_format#detect_style_file = 1
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" auto-enabling auto-formating
autocmd FileType c,cpp ClangFormatAutoEnable

"===================
" Coc.nvim settings
"===================

" User Settings
let g:coc_global_extentions = [
    \ 'coc-cmake', 'coc-clangd', 'coc-vimlsp', 'coc-rust-analyzer',
    \ 'coc-json', 'coc-eslint', 'coc-tsserver', 'coc-prettier', 'coc-css'
    \ ]

"let g:coc_user_config =

call coc#config('languageserver', {
    \ "haskell": {
    \     "command": "haskell-language-server-wrapper",
    \     "args": ["--lsp"],
    \     "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
    \     "filetypes": ["haskell", "lhaskell"]
    \ }})

call coc#config('clangd.semanticHighlighting', v:true)

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
  call popup_setoptions( winid,
        \ {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )

  return 1
endfunction

" initial settings
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

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
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
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

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

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

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

