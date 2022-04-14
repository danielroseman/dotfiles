" Configure vim-plug
call plug#begin('~/.vim/bundle')
" Look and feel
Plug 'altercation/vim-colors-solarized'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
" File/project/buffer/window navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'danro/rename.vim'             " :rename to move file
Plug 'qpkorr/vim-bufkill'
Plug 'wesQ3/vim-windowswap'         " <leader>ww to yank and paste window
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'milkypostman/vim-togglelist'  " <leader>l to toggle locationlist
" Text navigation/editing/selecting
Plug 'preservim/nerdcommenter'      " <leader>c<space> to toggle comment
Plug 'tpope/vim-endwise'            " auto-insert end tag
Plug 'tpope/vim-unimpaired'         " eg ]<Space> to open line above w/o insert
Plug 'kana/vim-textobj-user'
Plug 'tek/vim-textobj-ruby'         " eg var to select block, vaf for function
Plug 'Valloric/MatchTagAlways'      " higlight matching HTML tags
Plug 'tpope/vim-surround'           " select/change parens etc
Plug 'tpope/vim-repeat'
Plug 'michaeljsmith/vim-indent-object'  " vai to select via indentation
Plug 'bkad/CamelCaseMotion'         " <leader>w to move via camel case
Plug 'ConradIrwin/vim-bracketed-paste'  " automatic :set paste
Plug 'AndrewRadev/splitjoin.vim'    " gS to split one-liner into multiple lines
" Linting
Plug 'w0rp/ale'
Plug 'tpope/vim-rails'
" Syntax
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'google/vim-jsonnet'
Plug 'elixir-lang/vim-elixir'
Plug 'rodjek/vim-puppet'
Plug 'cespare/vim-toml'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tpope/vim-sleuth'
Plug 'Shopify/vim-sorbet'
" Misc
Plug 'tpope/vim-fugitive'           " git commands
Plug 'tpope/vim-rhubarb'            " enables :GBrowse for GitHub
Plug 'airblade/vim-gitgutter'       " gutter column shows git status
Plug 'junegunn/gv.vim'              " :GV to browse commits
Plug 'tpope/vim-dispatch'           " make/test asynchronously - :Dispatch
Plug 'SirVer/UltiSnips'
Plug 'honza/vim-snippets'           " some default snippets
Plug 'rizzatti/funcoo.vim'          " Needed for dash
Plug 'rizzatti/dash.vim'            " Look up current word in Dash
call plug#end()

set backspace=indent,eol,start
set number
set ruler
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" always show statusline
set laststatus=2
set ignorecase
set smartcase
set gdefault
set hidden
set showmatch
set matchtime=2
set switchbuf=usetab
set wildmenu
set nojoinspaces
" make ~ into a command (so you can do eg ~aw)
set tildeop
set hlsearch
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

set background=dark
" set t_Co=16
" colorscheme solarized
" " gutter comes out the wrong color in solarized if t_Co > 16
" hi SignColumn ctermbg=8
" fix bracket highlighting, especially in conjunction with MatchTag
" highlight MatchParen cterm=bold ctermfg=0 ctermbg=10
set termguicolors
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_invert_selection=0
colorscheme gruvbox
hi gitcommitOverflow ctermbg=red
" change cursor shape when switching between normal and insert
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

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

" configure FZF
let $FZF_DEFAULT_COMMAND = 'fd --type f'
" let $FZF_DEFAULT_COMMAND = 'rg --files --sort path --no-ignore-vcs'
" default hide binding of ctrl-/ doesn't work on Mac?
let g:fzf_preview_window = ['right:50%', 'ctrl-h']
nmap <leader>t :Files<CR>
nmap <leader>o :Buffers<CR>
nmap <leader>gm :History<CR>
nmap <leader>gh :History:<CR>
nmap <leader>gs :GFiles?<CR>
nmap <leader>gc :BCommits<CR>
nmap <leader>gt :BTags<CR>
" nmap <leader>gg :call fzf#vim#ag(expand('<cword>'), fzf#vim#with_preview())<CR>
nmap <leader>gg :call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(expand('<cword>')), 1, fzf#vim#with_preview())<CR>
nmap <leader>gb :call fzf#run(fzf#wrap({'source': 'git for-each-ref --format "%(refname:lstrip=2)" --sort="-authordate" refs/heads', 'sink':function('GitCheckout')}))<CR>

command! -nargs=* -complete=file AgC :call fzf#vim#ag_raw(<q-args>, fzf#vim#with_preview())
function! s:open_in_window_1(file)
  call s:open_in_window(1, a:file)
endfunction

function! s:open_in_window_2(file)
  call s:open_in_window(2, a:file)
endfunction

function! s:open_in_window(winno, file)
  if a:winno > winnr('$')
    vs
  endif
  exe a:winno . "winc w"
  exe "e " . a:file[0]
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:open_in_window_1'),
  \ 'ctrl-w': function('s:open_in_window_2'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! GitCheckout(branch_name)
  echo system('git checkout ' . shellescape(a:branch_name))
endfunction

" configure ALE
nmap <leader>ad <Plug>(ale_go_to_definition)
nmap <leader>ar <Plug>(ale_find_references)
let g:ale_ruby_rubocop_executable='bundle'
let g:ale_ruby_sorbet_enable_watchman=1
let g:ale_python_auto_poetry=1
let g:ale_completion_enabled = 1
let g:ale_linters = {
\   'python': ['flake8', 'mypy', 'jedils'],
\}

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

let g:camelcasemotion_key = '<leader>'

" nmap <leader>gt :TagbarToggle<CR>

" change size of iTerm to allow 2 or 3 80-column windows
nmap <leader>w2 <C-W>l<C-W>l:q<CR>:!printf '\e[8;60;186t'<CR><CR><C-W>=
nmap <leader>w3 :!printf '\e[8;60;279t'<CR><CR><C-W>v<C-W>=

" make HTML defaults sensible - no annoying smartindent
au Filetype html,xml,xsl,htmldjango set nosi indentexpr= autoindent shiftwidth=2 expandtab tw=0

autocmd FileType python set tw=0 sw=2 sts=2 " no textwrap until I can write a proper formatexpr
au BufRead,BufNewFile *.json set filetype=json
au FileType json set foldmethod=indent
let g:vim_json_syntax_conceal=0
set foldlevelstart=20
au Filetype yaml set autoindent
au Filetype jsonnet set smartindent
au FileType go set listchars=tab:\ \ ,eol:¬,trail:\ ,extends:»,precedes:«

" autoformat JSON and XML
au FileType json map <leader>jt  <Esc>:%!/usr/bin/python -mjson.tool<CR>
au FileType xml map <leader>xt <Esc>:silent %!xmllint --encode UTF-8 --format -<CR>

" basic skeleton for Ruby files
autocmd BufNewFile *.rb 0r ~/.vim/skeleton.rb

let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_trailing_comma = 1

au BufRead,BufNewFile *.md set filetype=markdown textwidth=80 formatoptions=t1

nmap <silent> <C-n> :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>

nmap <silent> <leader>d <Plug>DashSearch

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Join commented lines
set formatoptions+=j

let g:indentLine_char = "│"
let g:indentLine_color_term = 238

" convert from foo.bar to foo['bar']
nmap <leader>p ysaw'ysa']hx

" tell surround.vim about Django block tags
let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1%}\n\r\n{% endblock %}\n"
let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1%}\n\r\n{% endif %}\n"
let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1%}\n\r\n{% endwith %}\n"
let g:surround_{char2nr("c")} = "{% comment\1 \r..*\r &\1%}\n\r\n{% endcomment %}\n"
let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1%}\n\r\n{% endfor %}\n"

noremap gD ?\(def\<bar>class\) <c-r>=expand('<cword>')<cr>\><cr>
