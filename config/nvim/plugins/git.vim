Plug 'tpope/vim-fugitive'           " git commands
Plug 'tpope/vim-rhubarb'            " enables :GBrowse for GitHub
Plug 'airblade/vim-gitgutter'       " gutter column shows git status
Plug 'f-person/git-blame.nvim'
Plug 'junegunn/gv.vim'              " :GV to browse commits

let g:gitblame_enabled = 0
nnoremap <silent><leader>bl :GitBlameToggle<CR>
nnoremap <silent><leader>bo :GitBlameOpenCommitURL<CR>

