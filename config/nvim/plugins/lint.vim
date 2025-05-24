" Linting
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/lsp-colors.nvim'
Plug 'nvim-lua/plenary.nvim'

lua <<EOF
function lint_setup()
    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


  local nvim_lsp = require'lspconfig'
  -- vim.lsp.set_log_level("debug")
  local find_ancestor = function(startpath, file)
    return nvim_lsp.util.search_ancestors(startpath, function(path)
      if nvim_lsp.util.path.exists(nvim_lsp.util.path.join(path, file)) then
        return path
      end
    end)
  end

  local configs = require 'lspconfig.configs'

  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = ''
    })
  end

  sign({name = 'DiagnosticSignError', text = '✘'})
  sign({name = 'DiagnosticSignWarn', text = '▲'})
  sign({name = 'DiagnosticSignHint', text = '⚑'})
  sign({name = 'DiagnosticSignInfo', text = ''})

  vim.keymap.set(
    "", "<leader>dl", function()
      local new_config = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = 'Toggle diagnostic virtual_lines' }
  )
  vim.diagnostic.config({
    virtual_lines = { current_line = true },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  -- open definition in other window if not the same buffer
  -- this code is copied from the default response in vim.lsp.buf.get_locations
  -- and modified to open in a new window.
  -- it's passed in as the on_list function to the definition method
  local open_in_new_win = function(options)
      local title = options.title or 'LSP'
      local items = options.items
      local context = options.context
      if #items == 1 then
        local item = items[1]
        local b = item.bufnr or vim.fn.bufadd(item.filename)

        -- Save position in jumplist
        vim.cmd("normal! m'")
        -- Push a new item into tagstack
        local tagstack = { { tagname = tagname, from = from } }
        vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, 't')

        vim.bo[b].buflisted = true
        local w = vim.api.nvim_get_current_win()

        -- if buffer is not in current window, switch and open buffer
        if vim.api.nvim_win_get_buf(w) ~= b then
          vim.api.nvim_command("wincmd w")
          w = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(w, b)
        end

        vim.api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
        vim._with({ win = w }, function()
          -- Open folds under the cursor
          vim.cmd('normal! zv')
        end)
        return
      else
        vim.fn.setqflist({}, ' ', { title = title, items = items })
        vim.cmd('botright copen')
      end
    end

  local setkey = function(key, func, desc)
    vim.keymap.set('n', key, func, { noremap=true, silent=true, desc =desc })
  end
  setkey('<space>e', vim.diagnostic.open_float, "diagnostic.open_float")
  setkey('<space>q', vim.diagnostic.setloclist, "diagnostic.setloclist")

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local setkey = function(key, func, desc)
      vim.keymap.set('n', key, func, { noremap=true, silent=true, buffer=bufnr, desc =desc })
    end
    setkey('gD', vim.lsp.buf.declaration, "lsp.declaration")
    setkey('gd', function() 
      vim.lsp.buf.definition( { on_list = open_in_new_win } )
    end, "lsp.definition")
    setkey('<space>wa', vim.lsp.buf.add_workspace_folder, "lsp.add_workspace_folder")
    setkey('<space>wr', vim.lsp.buf.remove_workspace_folder, "lsp.remove_workspace_folder")
    setkey('<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "lsp.list_workspace_folders")
    setkey('<space>D', vim.lsp.buf.type_definition, "lsp.type_definition")
    setkey('<space>f', function() 
      vim.lsp.buf.format { async = true }
    end, "lsp.formatting")
  end

  nvim_lsp.pylsp.setup{
    cmd = { vim.g.python3_env .. "/bin/pylsp" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      pylsp = {
        plugins = {
          pylsp_mypy = { enabled = true },
          jedi_completion = { fuzzy = true },
          jedi_definition = { enabled = true, follow_builtin_definitions = false, follow_builtin_imports = false },
          ruff = { enabled = false },
        },
      },
    },
  }
  nvim_lsp.ruff.setup {
    cmd = { vim.g.python3_env .. "/bin/ruff", "server", "--preview"},
    on_attach = on_attach,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      }
    }
  }
  nvim_lsp.ruby_lsp.setup{
    capabilities = capabilities,
    on_attach = on_attach,
  }
  nvim_lsp.sorbet.setup{
    cmd = {'bundle', 'exec', 'srb', 'tc', '--lsp'},
    capabilities = capabilities
  }
  -- nvim_lsp.solargraph.setup{
  --   capabilities = capabilities,
  --   on_attach = on_attach,
  -- }
end

EOF

augroup LintSetup
  autocmd User PlugLoaded ++nested lua lint_setup()
augroup end

