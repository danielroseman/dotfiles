" File/project/buffer/window navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'danro/rename.vim'             " :rename to move file
Plug 'qpkorr/vim-bufkill'
Plug 'wesQ3/vim-windowswap'         " <leader>ww to yank and paste window
Plug 'milkypostman/vim-togglelist'  " <leader>l to toggle locationlist
Plug 'kyazdani42/nvim-tree.lua'

nmap <silent> <C-n> :NvimTreeToggle<CR>
nmap <leader>nf :NvimTreeFindFile<CR>
nmap <leader>nF :NvimTreeFindFileToggle<CR>

" configure FZF
let $FZF_DEFAULT_COMMAND = 'fd --type f'
" default hide binding of ctrl-/ doesn't work on Mac?
let g:fzf_preview_window = ['right:50%', 'ctrl-h']
nmap <leader>t :Files<CR>
nmap <leader>o :Buffers<CR>
nmap <leader>gm :History<CR>
nmap <leader>gh :History:<CR>
nmap <leader>gs :GFiles?<CR>
nmap <leader>gc :BCommits<CR>
nmap <leader>gt :BTags<CR>
nmap <leader>gg :call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(expand('<cword>')), 1, fzf#vim#with_preview())<CR>
nmap <leader>gb :call fzf#run(fzf#wrap({'source': 'git for-each-ref --format "%(refname:lstrip=2)" --sort="-authordate" refs/heads', 'sink':function('GitCheckout')}))<CR>

function! GitCheckout(branch_name)
  echo system('git checkout ' . shellescape(a:branch_name))
endfunction

lua <<EOF
  function navigation_setup()
    require("nvim-tree").setup()
  end
EOF

augroup NavigationSetup
  autocmd User PlugLoaded ++nested lua navigation_setup()
augroup end
