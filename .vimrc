"   ██    ██ ██ ███    ███ ██████   ██████
"   ██    ██ ██ ████  ████ ██   ██ ██
"   ██    ██ ██ ██ ████ ██ ██████  ██
"    ██  ██  ██ ██  ██  ██ ██   ██ ██
"██   ████   ██ ██      ██ ██   ██  ██████
"This configuration file comes with ABSOLUTELY NO WARRANTY,
"to the extent permitted by applicable law.


"---------GENERAL SETTINGS------------

"Set compatibility to Vim only.
set nocompatible
set nolist
set rnu

"Helps force plug-ins to load correctly when it is turned back on below.
filetype on

" Turn on syntax highlighting.
syntax on

" For plug-ins to load correctly.
filetype plugin indent on

" Turn off modelines
set modelines=0

" Automatically wrap text that extends beyond the screen length.
set wrap

" Uncomment below to set the max textwidth. Use a value corresponding to the width of your screen.
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5

" Fixes common backspace problems
set backspace=indent,eol,start

" Speed up scrolling in Vim
set ttyfast

" Status bar
set laststatus=2

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Show line numbers
set number

" Set status line display
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

" Encoding
set encoding=utf-8

" Highlight matching search patterns
set hlsearch

" Enable incremental search
set incsearch

" Include matching uppercase words with lowercase search term
set ignorecase

" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100


" ---------------PLUGINS--------------------
"
"Plugin autoinstalling
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"Syntax highlighting and autocompletion
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
Plug 'sheerun/vim-polyglot'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'derekwyatt/vim-fswitch', { 'for': ['c', 'cpp', 'objc'] }
Plug 'jparise/vim-graphql'
Plug 'gcmt/wildfire.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'lilydjwg/colorizer'
Plug 'tpope/vim-eunuch'
Plug 'lambdalisue/suda.vim'
Plug 'neomake/neomake'
Plug 'ternjs/tern_for_vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'dense-analysis/ale'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'tpope/vim-surround'
Plug 'moll/vim-node'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'kana/vim-textobj-user' | Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'https://github.com/leafgarland/typescript-vim'
Plug 'https://github.com/Quramy/vim-js-pretty-template'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'https://github.com/Quramy/tsuquyomi'
Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'editorconfig/editorconfig-vim'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/vim-js-pretty-template'
Plug 'mbbill/undotree'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"File search and navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'christoomey/vim-tmux-navigator'
Plug 'matze/vim-move'

"Editor interface and theming
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'yggdroot/indentline'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mhinz/vim-startify'

"Debugging, refactoring and version control
Plug 'puremourning/vimspector'

call plug#end()

"---------- PLUGIN VARIABLES---------------
"
let g:suda_smart_edit = 1
let g:airline_powerline_fonts = 1
let g:coc_global_extensions = [ 'coc-tsserver' ]
autocmd VimEnter * NERDTree 
autocmd VimEnter * NERDTreeToggle
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
colorscheme gruvbox
set bg=dark

"-----------Coc----------
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

"-----------NAVIGATION KEYMAPS-------------
"
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <C-n> :NERDTreeToggle <CR>
vmap <C-v> <Esc>"+gp
"Misc
:imap ii <Esc>
:map H b
:map L w
:noremap e b
:noremap w e
noremap <TAB> w
map <S-TAB> b
nmap <C-a> \\A
map <SPACE> <Plug>(wildfire-fuel)

nmap <C-t> :tab sball <CR>
nmap <C-q> :tabclose <CR>
:nmap J :tabn <CR>
:nmap K :tabp <CR>
:imap ,ii <Esc>

nnoremap <f12> :%s/<c-r><c-w>//g<c-f>$F/i
vnoremap <C-n> :norm

"Search shortcuts
let mapleader = ","
noremap <leader>w :w<cr>
noremap <leader>gs :CocSearch
noremap <leader>fs :Files<cr>
noremap <leader><cr> <cr><c-w>h:q<cr>

command! -nargs=0 Sw w !tuxclocker  

" Vim's auto indentation feature does not work properly with text copied from outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

command! -nargs=0 Prettier :CocCommand prettier.formatFile

let g:NERDTreeIgnore = ['^node_modules$']
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n
let g:VM_maps["Select Cursor Down"] = '<C-j>'      " start selecting down
let g:VM_maps["Select Cursor Up"]   = '<C-k>'        " start selecting up
let b:ale_fixers = ['prettier', 'eslint']
let NERDTreeShowHidden = 1
let NERDTreeCustomOpenArgs = {'file': {'reuse':'all', 'where':'t', 'keepopen':0, 'stay':0}}
let NERDTreeMapCustomOpen = 't'

let g:user_emmet_leader_key=','
let g:user_emmet_settings = {
\  'variables': {'lang': 'ja'},
\  'html': {
\    'default_attributes': {
\      'option': {'value': v:null},
\      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
\    },
\    'snippets': {
\      'html:5': "<!DOCTYPE html>\n"
\              ."<html lang=\"${lang}\">\n"
\              ."<head>\n"
\              ."\t<meta charset=\"${charset}\">\n"
\              ."\t<title></title>\n"
\              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
\              ."</head>\n"
\              ."<body>\n\t${child}|\n</body>\n"
\              ."</html>",
\    },
\  },
\}

let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
autocmd FileType typescript JsPreTmpl html
autocmd FileType typescript syn clear foldBraces