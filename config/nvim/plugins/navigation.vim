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

  -- browse directories with fzf then open in nvim-tree
  local fzf_dirs = function(opts)
    local fzf_lua = require'fzf-lua'
    opts = opts or {}
    opts.prompt = "Directories> "
    opts.fn_transform = function(x)
      return fzf_lua.utils.ansi_codes.magenta(x)
    end
    opts.actions = {
      ['default'] = function(selected)
        local tree = require('nvim-tree.api').tree
        tree.open()
        tree.find_file(selected[1])
        -- require('nvim-tree.api').api.node.open.edit()

      end
    }
    fzf_lua.fzf_exec("fd --type d", opts)
  end

  function navigation_setup()
    require("nvim-tree").setup()

    fzf = require('fzf-lua')
    fzf.setup({
      fzf_opts = {
        ['--layout'] = 'default',
      },
      previewers = {
        git_diff = {
          pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        }
      },
      lsp = {
        symbols = {
          fzf_opts = { ["--nth"] = "2" }, -- don't match on symbol type
          regex_filter = "^%[[FCM][^o].*" -- only show Functions, Classes and Methods (and not Modules)
        }
      }
    })
    vim.keymap.set('n', '<leader>t', fzf.files, {desc = "fzf.files"})
    vim.keymap.set('n', '<leader>o', fzf.buffers, {desc = "fzf.buffers"})
    vim.keymap.set('n', '<leader>gd', fzf_dirs, {desc = "fzf.dirs"})
    vim.keymap.set('n', '<leader>gm', fzf.oldfiles, {desc = "fzf.oldfiles"})
    vim.keymap.set('n', '<leader>gh', fzf.command_history, {desc = "fzf.command_history"})
    vim.keymap.set('n', '<leader>gs', fzf.git_status, {desc = "fzf.git_status"})
    vim.keymap.set('n', '<leader>gc', fzf.git_bcommits, {desc = "fzf.git_bcommits"})
    vim.keymap.set('n', '<leader>gb', fzf.git_branches, {desc = "fzf.git_branches"})
    vim.keymap.set('n', '<leader>st', fzf.git_stash, {desc = "fzf.git_stash"})
    vim.keymap.set('n', '<leader>gt', fzf.btags, {desc = "fzf.btags"})
    vim.keymap.set('n', '<leader>gg', fzf.grep_cword, {desc = "fzf.grep_cword"})
    vim.keymap.set('n', '<leader>rg', fzf.grep, {desc = "fzf.grep"})
    vim.keymap.set('n', '<leader>ds', fzf.lsp_document_symbols, {desc = "fzf.lsp_document_symbols"})
    vim.keymap.set('n', '<leader>dd', fzf.diagnostics_document, {desc = "fzf.diagnostics_document"})
    vim.keymap.set('n', '<leader>dw', fzf.diagnostics_workspace, {desc = "fzf.diagnostics_workspace"})
    vim.keymap.set('n', '<leader>dw', fzf.diagnostics_workspace, {desc = "fzf.diagnostics_workspace"})
    vim.keymap.set('n', '<leader>gr', fzf.lsp_references, {desc = "fzf.lsp_references"})
    vim.keymap.set('n', '<leader>r', fzf.resume, {desc = "fzf.resume"})
  end
EOF

augroup NavigationSetup
  autocmd User PlugLoaded ++nested lua navigation_setup()
augroup end
