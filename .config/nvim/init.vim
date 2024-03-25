set encoding=utf-8
set helplang=ja,en
set showcmd     " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set autowrite       " Automatically save before commands like :next and :make
set hidden      " Hide buffers when they are abandoned
set number
set expandtab
set tabstop=4
set shiftwidth=4
set wrapscan
set formatoptions+=mMj
set relativenumber
set updatetime=300
"ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2
"コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
"検索結果をハイライト表示する
set hlsearch
"暗い背景色に合わせた配色にする
set background=dark
set clipboard+=unnamed

colorscheme desert

"誤字修正
ab appned append

"矢印キーで画面上の１行単位で移動するように
map <Up> gk
map <Down> gj

"Shift + 矢印キーでウィンドウサイズ変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

"jjでESC
inoremap <silent> jj <ESC>

"w!! でsudoで保存
cabbr w!! w !sudo tee > /dev/null %

"Kでヘルプを引く
set keywordprg=:help

"矩形選択モードでなにもないところにもカーソルが移動できる
set virtualedit=block


"全角スペース　可視化
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif


"ruby, vue, jsはインデント２
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html syntax sync fromstart

"neovimでカーソルを戻す
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

"neovim用python
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/opt/homebrew/bin/python3'

"vimgrep時にQuickfix自動起動
autocmd QuickFixCmdPost *grep* cwindow


nnoremap <silent> <C-t> :cn<CR>

"vimplug==============================================
call plug#begin('~/.vim/plugged')
" Add or remove your Bundles here:
Plug 'tpope/vim-fugitive'
Plug 'rhysd/clever-f.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'



"tcomment_vim
"gcc でコメントアウト切り替え
Plug 'tomtom/tcomment_vim'

"行末の半角スペースを可視化
Plug 'bronson/vim-trailing-whitespace'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


"lightline
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ],
      \             [ 'gitbranch' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
if !has('gui_running')
      set t_Co=256
endif

"Quickrun
Plug 'thinca/vim-quickrun'
let g:quickrun_config = {
  \ 'python': { 'command': '/usr/local/opt/python@3.11/libexec/bin/python' }
  \ }
nnoremap <silent> <F5> :QuickRun -mode n<CR>
vnoremap <silent> <F5> :QuickRun -mode v<CR>

"spelunker
Plug 'kamykn/spelunker.vim'
set nospell

"vim-vue-plugin
"Plug 'posva/vim-vue'
"Plug 'leafoftree/vim-vue-plugin'
"autocmd FileType vue syntax sync fromstart


"coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}




"vim-operator-surround
"https://rhysd.hatenablog.com/entry/2014/12/08/082825
Plug 'rhysd/vim-operator-surround'
Plug 'kana/vim-operator-user'
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

"defx
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-git'
nnoremap <silent><C-f> :<C-u>Defx<CR>

"denite
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'

"telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>

Plug 'nvim-tree/nvim-web-devicons'
Plug 'kristijanhusak/defx-icons'

Plug 'monaqa/dial.nvim'

"dial
"+と -でインクリメント、デクリメント
nnoremap + <Plug>(dial-increment)
nnoremap - <Plug>(dial-decrement)
vnoremap + <Plug>(dial-increment)
nnoremap - <Plug>(dial-decrement)
nmap g+ g<Plug>(dial-increment)
nmap g- g<Plug>(dial-decrement)
vmap g+ g<Plug>(dial-increment)
vmap g- g<Plug>(dial-decrement)

" startify
Plug 'mhinz/vim-startify'
let g:startify_files_number = 7
let g:startify_lists = [
            \ { 'type': 'files', 'header': ['♻  最近使ったファイル:'] },
            \ { 'type': 'dir', 'header': ['♲  最近更新されたファイル(カレントディレクトリ下):'. getcwd()] },
            \ { 'type': 'sessions',  'header': ['⚑  セッション:']       },
            \ { 'type': 'bookmarks', 'header': ['☺  ブックマーク:']      },
            \ ]
let g:startify_bookmarks = [{'c': '~/.config/nvim/init.vim'}, {'z': '~/.zshrc'}]
let s:version = matchstr(execute('version'), 'NVIM v\zs[^\n]*')
let g:startify_custom_header = [
            \ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
            \ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
            \ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
            \ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
            \ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
            \ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝     '.s:version,
            \]

Plug 'tiagovla/tokyodark.nvim'
call plug#end()
"vimplug==end========================================================

"colorscheme tokyodark
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
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

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

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

"denite
call denite#custom#var('file/rec', 'command',
	\ ['rg', '--files', '--glob', '!.git', '--color', 'never'])
call denite#custom#option('default', {
    \ 'split': 'floating',
    \ })

"defx
call defx#custom#option('_', {
      \ 'split': 'vertical',
      \ 'winwidth': 40,
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 1,
      \ 'buffer_name': 'exlorer',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ 'columns': 'indent:git:icons:indent:filename:mark',
      \ })

autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
      nnoremap <silent><buffer><expr> <CR>
      \ defx#is_directory() ?
      \ defx#is_opened_tree() ?
      \ defx#do_action('close_tree') :
      \ defx#do_action('open_tree') :
      \ defx#do_action('drop')
      " 【o】 ファイルを開く
      nnoremap <silent><buffer><expr> o
      \ defx#do_action('open')
      " 【s】 ウィンドウを水平分割してファイルを開く
      nnoremap <silent><buffer><expr> s
      \ defx#do_action('open', 'split')
      " 【v】 ウィンドウを垂直分割してファイルを開く
      nnoremap <silent><buffer><expr> v
      \ defx#do_action('open', 'vsplit')
      " 【t】 新しいタブでファイルを開く
      nnoremap <silent><buffer><expr> t
      \ defx#do_action('open', 'tabnew')
      " 【c】 ファイルをコピーする
      nnoremap <silent><buffer><expr> c
      \ defx#do_action('copy')
      " 【m】 ファイルを移動する
      nnoremap <silent><buffer><expr> m
      \ defx#do_action('move')
      " 【p】 ファイルを貼り付ける
      nnoremap <silent><buffer><expr> p
      \ defx#do_action('paste')
      " 【n】 新しいファイルを作成する
      nnoremap <silent><buffer><expr> n
      \ defx#do_action('new_file')
      " 【N】 新しいディレクトリを作成する
      nnoremap <silent><buffer><expr> N
      \ defx#do_action('new_directory')
      " 【d】 ファイルを削除する
      nnoremap <silent><buffer><expr> d
      \ defx#do_action('remove')
      " 【r】 ファイル名を変更する
      nnoremap <silent><buffer><expr> r
      \ defx#do_action('rename')
      " 【t】 ツリーを表示/非表示する
      nnoremap <silent><buffer><expr> t
      \ defx#do_action('open_or_close_tree')
      " 【x】 ファイルを実行する
      nnoremap <silent><buffer><expr> x
      \ defx#do_action('execute_system')
      " 【yy】 ファイル/ディレクトリのパスをコピーする
      nnoremap <silent><buffer><expr> yy
      \ defx#do_action('yank_path')
      " 【.】 隠しファイルを表示/非表示する
      nnoremap <silent><buffer><expr> .
      \ defx#do_action('toggle_ignored_files')
      " 【..】 親ディレクトリに移動する
      nnoremap <silent><buffer><expr> ..
      \ defx#do_action('cd', ['..'])
      " 【~】 ホームディレクトリに移動する
      nnoremap <silent><buffer><expr> ~
      \ defx#do_action('cd')
      " 【ESC】 / 【q】 defx.nvimを終了する
      nnoremap <silent><buffer><expr> <Esc> 
      \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> q
      \ defx#do_action('quit')
      " 【j】 カーソルを下に移動する
      nnoremap <silent><buffer><expr> j
      \ line('.') == line('$') ? 'gg' : 'j'
      " 【k】 カーソルを上に移動する
      nnoremap <silent><buffer><expr> k
      \ line('.') == 1 ? 'G' : 'k'
      " 【cd】 Neovim上のカレントディレクトリを変更する
      nnoremap <silent><buffer><expr> cd
      \ defx#do_action('change_vim_cwd')
  endfunction


syntax on

" vimdiffの色設定
highlight DiffAdd    cterm=bold ctermbg=22
highlight DiffDelete cterm=bold ctermbg=52
highlight DiffChange cterm=bold ctermbg=17
highlight DiffText   cterm=bold ctermbg=19

" gitgutterの背景色
highlight SignColumn ctermbg=none

highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
