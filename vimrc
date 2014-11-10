" Configure vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'gregsexton/MatchTag'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-fugitive'
Bundle 'UltiSnips'
Bundle 'The-NERD-Commenter'
Bundle 'surround.vim'
Bundle 'kevinw/pyflakes-vim'
Bundle 'bufkill.vim'
Bundle 'repeat.vim'
Bundle 'vim-indent-object'
Bundle 'danielroseman/pygd-vim'
Bundle 'Tagbar'
Bundle 'jwhitley/vim-matchit'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
"Bundle 'Valloric/YouCompleteMe'
Bundle 'mileszs/ack.vim'
Bundle 'tpope/vim-rails'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'
Bundle 'rodjek/vim-puppet'
Bundle 'milkypostman/vim-togglelist'
Bundle 'rking/ag.vim'
Bundle 'ConradIrwin/vim-bracketed-paste'
Bundle 'elzr/vim-json'
filetype plugin indent on
syntax on

let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1, 'c': 1}

"let g:solarized_termtrans=1
"let g:solarized_termcolors=16
set t_Co=16
set background=dark
colorscheme solarized
set cc=80
set mouse=a
" for trailing spaces
"hi specialkey guibg=black ctermbg=red
" fix bracket highlighting - not needed with solarized scheme
"highlight MatchParen cterm=bold ctermfg=8 ctermbg=0
"hi ColorColumn ctermbg=blue
" change cursor shape when switching between normal and insert
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

set number
set ruler
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" always show statusline
set laststatus=2
"set undofile
set ignorecase
set smartcase
set gdefault
set hidden
set showmatch
set matchtime=2
set switchbuf=usetab
set nojoinspaces
" make ~ into a command (so you can do eg ~aw)
set tildeop
set hlsearch
set list
set listchars=tab:▸\ ,eol:¬,trail:\ ,extends:»,precedes:«
" mapping to remove highlight after search
nnoremap <silent> <leader><space> :noh<cr>
" reselect last pasted text, preserving visual mode that was used originally
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" fold current tag
nnoremap <leader>ft Vatzf
" add 'in next ()' text object
vnoremap <silent> in( :<C-U>normal! f(vi(<cr>
onoremap <silent> in( :<C-U>normal! f(vi(<cr>

vnoremap <C-C> "+y

"tab in normal mode switches windows
nnoremap <Tab> <C-w>w

"ctrl-g always shows full path
nnoremap <C-G> 3<C-G>

" configure ctrlp
let g:ctrlp_working_path_mode = ''
let g:ctrlp_map = '<leader>t'
nnoremap <leader>o :CtrlPBuffer<cr>
nnoremap <leader>y :CtrlPClearCache<cr>

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

"autocmd FileType python set ft=python.django sw=2 " For SnipMate
autocmd FileType python set tw=0 " no textwrap until I can write a proper formatexpr
"noremap <leader>d <S-o>import pdb;pdb.set_trace()<Esc>
nmap <silent> <leader>d <Plug>DashSearch

noremap gD ?\(def\<bar>class\) <c-r>=expand('<cword>')<cr>\><cr>

nmap <leader>g :TagbarToggle<CR>

"au Filetype html,xml,xsl,htmldjango source ~/.vim/scripts/closetag.vim
" make HTMl defaults sensible - no annoying smartindent
au Filetype html,xml,xsl,htmldjango set nosi indentexpr= autoindent shiftwidth=2 expandtab tw=0
au BufRead,BufNewFile *.json set filetype=json
" au FileType json nmap <expr> <leader>jt :py cb=vim.current.buffer;import json;d=json.dumps(eval(''.join(cb)),indent=4);cb[:]=d.split('\n')
au FileType json map <leader>jt  <Esc>:%!/usr/bin/python -mjson.tool<CR>
au FileType json set foldmethod=indent
set foldlevelstart=20
au Filetype yaml set autoindent

au FileType svn set nonumber nolist
"let g:Tlist_Ctags_Cmd='/usr/local/bin/ctags'
"let Tlist_Sort_Type='name'
"let Tlist_GainFocus_On_ToggleOpen=1
"nmap <silent> <F5> :TlistToggle<CR>
"vnoremap <S-F5> :!python<CR>
nmap <silent> <C-n> :NERDTreeToggle<CR>
"nmap <silent> <S-F6> :NERDTreeToggle<CR><C-w><Right>:NERDTreeFind<CR>
"nmap ; :
"let NERDTreeIgnore=['\~$', '\.pyc']
set wildignore+=*.jpg,*.gif,*.pyc,*/core/static/javascript,*/core/static/styles/trogedit,*/google3/education/glearn/google3,READONLY,*/core/static/third_party,
" convert from foo.bar to foo['bar']
nmap <leader>p ysaw'ysa']hx
"let g:ackprg="ack-grep\\ -H\\ --nocolor\\ --nogroup"

" if we're in a virtualenv, set up paths for goto file and omnicomplete
if $VIRTUAL_ENV != ''
let s:cwd = getcwd()
cd $VIRTUAL_ENV
let $DJANGO_SETTINGS_MODULE=$VIRTUAL_ENV . '/' . findfile('settings.py', $VIRTUAL_ENV . '/**2/configs/common')
let &path = &path . "," . $VIRTUAL_ENV . '/' . finddir('apps', $VIRTUAL_ENV . '/**2')
let &path = &path . "," . $VIRTUAL_ENV . '/' . finddir('site-packages', $VIRTUAL_ENV . '/**2')
let &path = &path . "," . $VIRTUAL_ENV . '/' . finddir('ext', $VIRTUAL_ENV . '/**2')
let &path = &path . "," . $VIRTUAL_ENV . '/' . finddir('templates', $VIRTUAL_ENV . '/**2')
let &path = &path . "," . $VIRTUAL_ENV
execute "cd " . s:cwd
endif

let g:gov_base = matchstr(getcwd(), '\.*\/govuk\/\([^/]*\).*\zs.*\ze\1')
if g:gov_base != ''
  set stl=%<(%{g:gov_base})\ %f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
endif

" tell surround.vim about Django block tags
let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1%}\n\r\n{% endblock %}\n"
let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1%}\n\r\n{% endif %}\n"
let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1%}\n\r\n{% endwith %}\n"
let g:surround_{char2nr("c")} = "{% comment\1 \r..*\r &\1%}\n\r\n{% endcomment %}\n"
let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1%}\n\r\n{% endfor %}\n"


" quick function to find all top-level functions and classes in Python files
function! FindFunctionsAndClasses()
  lvimgrep /^class\|^def/ %
  lopen
endfunction
nnoremap <silent> <leader>f :call FindFunctionsAndClasses()<CR>

