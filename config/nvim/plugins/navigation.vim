" File/project/buffer/window navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua'
Plug 'danro/rename.vim'             " :rename to move file
Plug 'qpkorr/vim-bufkill'
Plug 'wesQ3/vim-windowswap'         " <leader>ww to yank and paste window
Plug 'milkypostman/vim-togglelist'  " <leader>l to toggle locationlist
Plug 'kyazdani42/nvim-tree.lua'

nmap <silent> <C-n> :NvimTreeToggle<CR>
nmap <leader>nf :NvimTreeFindFile<CR>
nmap <leader>nF :NvimTreeFindFileToggle<CR>

lua <<EOF
  function navigation_setup()
    require("nvim-tree").setup()

    fzf = require('fzf-lua')
    vim.keymap.set('n', '<leader>t', fzf.files)
    vim.keymap.set('n', '<leader>o', fzf.buffers)
    vim.keymap.set('n', '<leader>gm', fzf.oldfiles)
    vim.keymap.set('n', '<leader>gh', fzf.command_history)
    vim.keymap.set('n', '<leader>gs', fzf.git_status)
    vim.keymap.set('n', '<leader>gc', fzf.git_bcommits)
    vim.keymap.set('n', '<leader>gb', fzf.git_branches)
    vim.keymap.set('n', '<leader>gt', fzf.btags)
    vim.keymap.set('n', '<leader>gg', fzf.grep_cword)
    vim.keymap.set('n', '<leader>rg', fzf.grep)
    vim.keymap.set('n', '<leader>dd', fzf.diagnostics_document)
    vim.keymap.set('n', '<leader>dw', fzf.diagnostics_document)
    vim.keymap.set('n', '<leader>gr', fzf.lsp_references)
  end
EOF

augroup NavigationSetup
  autocmd User PlugLoaded ++nested lua navigation_setup()
augroup end
