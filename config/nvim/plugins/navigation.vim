" File/project/buffer/window navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua'
Plug 'danro/rename.vim'             " :rename to move file
Plug 'qpkorr/vim-bufkill'
Plug 'wesQ3/vim-windowswap'         " <leader>ww to yank and paste window
Plug 'milkypostman/vim-togglelist'  " <leader>l to toggle locationlist
Plug 'kyazdani42/nvim-tree.lua'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

nmap <silent> <C-n> :Neotree float<CR>
nmap <leader>nf :Neotree float reveal<CR>
" nmap <leader>nF :NvimTreeFindFileToggle<CR>

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
        local api = require('nvim-tree.api')
        api.tree.open()
        api.tree.find_file(selected[1])
        api.node.open.edit()
      end
    }
    fzf_lua.fzf_exec("fd --type d", opts)
  end

  function navigation_setup()
    local HEIGHT_RATIO = 0.8
    local WIDTH_RATIO = 0.5
    require("nvim-tree").setup({
      view = {
        adaptive_size = true,
        float = {
          enable = true,
          open_win_config = function()

            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      }
    })

    fzf = require('fzf-lua')
    fzf.setup({
      git = {
        bcommits = {
          actions = {
            ["ctrl-y"] = function(selected, opts)
              local sha = selected[1]:match('%S+')
              vim.cmd('e ' .. vim.fn.FugitiveFind(sha))
            end
          },
          preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
        branches = {
          cmd = "git branch --color --sort=-authordate"
        },
        status = {
          preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        }
      },
      lsp = {
        symbols = {
          fzf_opts = {
            ["--nth"] = "1", -- don't match on symbol type
          },
          -- regex_filter = "^%[[FCM][^o].*" -- only show Functions, Classes and Methods (and not Modules)
        }
      },
      buffers = {
        fzf_opts = {  ["--delimiter"] = " ", ["--with-nth"] = "-1.." }, -- hide buffer number
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
    vim.keymap.set('n', '<leader>gl', fzf.git_commits, {desc = "fzf.git_commits"})
    vim.keymap.set('n', '<leader>st', fzf.git_stash, {desc = "fzf.git_stash"})
    vim.keymap.set('n', '<leader>gt', fzf.btags, {desc = "fzf.btags"})
    vim.keymap.set('n', '<leader>gg', fzf.grep_cword, {desc = "fzf.grep_cword"})
    vim.keymap.set('n', '<leader>rg', fzf.grep, {desc = "fzf.grep"})
    vim.keymap.set('n', '<leader>ds', fzf.lsp_document_symbols, {desc = "fzf.lsp_document_symbols"})
    vim.keymap.set('n', '<leader>ws', fzf.lsp_workspace_symbols, {desc = "fzf.lsp_workspace_symbols"})
    vim.keymap.set('n', '<leader>dd', fzf.diagnostics_document, {desc = "fzf.diagnostics_document"})
    vim.keymap.set('n', '<leader>dw', fzf.diagnostics_workspace, {desc = "fzf.diagnostics_workspace"})
    vim.keymap.set('n', '<leader>dw', fzf.diagnostics_workspace, {desc = "fzf.diagnostics_workspace"})
    vim.keymap.set('n', '<leader>gr', fzf.lsp_references, {desc = "fzf.lsp_references"})
    vim.keymap.set('n', '<leader>r', fzf.resume, {desc = "fzf.resume"})
    vim.keymap.set('n', '<leader>jj', fzf.jumps, {desc = "fzf.jumps"})
    vim.keymap.set('n', '<leader>kk', fzf.keymaps, {desc = "fzf.keymaps"})
  end
EOF

augroup NavigationSetup
  autocmd User PlugLoaded ++nested lua navigation_setup()
augroup end
