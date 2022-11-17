let g:python3_env = trim(system('pyenv prefix py3nvim'))
let g:python3_host_prog = g:python3_env . '/bin/python'

"
" Configure vim-plug
call plug#begin()
" Look and feel
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

source ~/.config/nvim/plugins/navigation.vim
source ~/.config/nvim/plugins/autocomplete.vim
source ~/.config/nvim/plugins/lint.vim
source ~/.config/nvim/plugins/syntax.vim
source ~/.config/nvim/plugins/git.vim

" Text navigation/editing/selecting
Plug 'preservim/nerdcommenter'      " <leader>c<space> to toggle comment
Plug 'Valloric/MatchTagAlways'      " higlight matching HTML tags
Plug 'tpope/vim-surround'           " select/change parens etc
Plug 'tpope/vim-repeat'
Plug 'AndrewRadev/splitjoin.vim'    " gS to split one-liner into multiple lines

" Misc
Plug 'tpope/vim-rails'
Plug 'honza/vim-snippets'           " some default snippets
call plug#end()

doautocmd User PlugLoaded

set backspace=indent,eol,start
set number
set ruler
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set laststatus=2  " always show statusline
set ignorecase
set smartcase
set gdefault
set hidden
set showmatch
set matchtime=2
set switchbuf=usetab
set wildmenu
set nojoinspaces
set tildeop  " make ~ into a command (so you can do eg ~aw)
set hlsearch
set noincsearch
set list
set listchars=tab:▸\ ,eol:¬,trail:\ ,extends:»,precedes:«
" always show gutter
set signcolumn=yes
set showbreak=↪  " show a line has been wrapped
set noshowmode   " lightline shows this already
runtime macros/matchit.vim
set autoread
set cc=80
set mouse=a

set completeopt=menu,menuone,noselect

set background=dark
set termguicolors
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_invert_selection=0
colorscheme gruvbox
highlight! link FloatBorder Normal
highlight! link NormalFloat Normal

let g:lightline = {
      \ 'colorscheme': 'gruvbox' ,
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'gitbranch' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ 'mode_map': {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
        \ },
      \ }

" mapping to remove highlight after search
nnoremap <silent> <leader><space> :noh<cr>
" reselect last pasted text, preserving visual mode that was used originally
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" fold current tag
nnoremap <leader>ft Vatzf
" add 'in next ()' text object
vnoremap <silent> in( :<C-U>normal! f(vi(<cr>
onoremap <silent> in( :<C-U>normal! f(vi(<cr>

if $SPIN
  let g:clipboard = {'copy': {'+': 'pbcopy', '*': 'pbcopy'}, 'paste': {'+': 'pbpaste', '*': 'pbpaste'}, 'name': 'pbcopy', 'cache_enabled': 1}
endif
" ctrl-c copies to system clipboard
vnoremap <C-C> "+y
" <leader>cf copies path of current file to system clipboard
nnoremap <silent><leader>cf :let @+ = expand("%")<cr>
nnoremap <silent><leader>cF :let @+ = expand("%:p")<cr>

" tab in normal mode rotates through windows forward, shift-tab backwards
nnoremap <Tab> <C-w>w
nnoremap <S-Tab> <C-w>W

" :Qa quits all buffers in all windows
command! Qa :windo qa

" ctrl-g always shows full path
nnoremap <C-G> 3<C-G>

" The only things I used from vim-unimpaired; [<space> to open line above
nmap [<Space> :exe 'put!=nr2char(10)'<CR>
nmap ]<Space> :exe 'put =nr2char(10)'<CR>

" saveas in current directory
command! -nargs=* -complete=file Lsaveas saveas %:h/<args>

" sensible navigation in command mode
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g>  <C-c>

let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_trailing_comma = 1

au BufRead,BufNewFile *.md set filetype=markdown textwidth=80 formatoptions=t1
let g:vim_json_conceal = 0
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Join commented lines
set formatoptions+=j

" let g:indentLine_char = "│"
" let g:indentLine_color_term = 238
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_use_treesitter_scope = v:true

" convert from foo.bar to foo['bar']
nmap <leader>p ysaw'ysa']hx

