" Linting
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/lsp-colors.nvim'
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvimtools/none-ls.nvim'

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

  local lsp_lines = require("lsp_lines")
  lsp_lines.setup()
  vim.keymap.set(
    "", "<leader>dl", lsp_lines.toggle, { desc = "Toggle lsp_lines" }
  )
  vim.diagnostic.config({
    virtual_text = false, -- built-in virtual text displays at end of line
    virtual_lines = { only_current_line = true },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  local null_ls = require("null-ls")

  null_ls.setup({
      sources = {
          null_ls.builtins.diagnostics.mypy.with({
            extra_args = function(params)
              if find_ancestor(params.bufname, 'mypy.ini') then
                return {"--config-file", nvim_lsp.util.path.join(anc, 'mypy.ini'), '--show-absolute-path'}
              elseif find_ancestor(params.bufname, 'pyproject.toml') then
                return {"--config-file", nvim_lsp.util.path.join(anc, 'pyproject.toml'), '--show-absolute-path'}
              end
            end
          }),
  --         -- require("null-ls").builtins.diagnostics.rubocop,
  --         conditional(function(utils)
  --             return utils.root_has_file("Gemfile")
  --                     and null_ls.builtins.formatting.rubocop.with({
  --                         command = "bundle",
  --                         args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.diagnostics.rubocop._opts.args),
  --                     })
  --                 or null_ls.builtins.diagnostics.rubocop
  --         end),
      },
  --  debug = true,
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded"
    }
  )
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded"
    }
  )

  -- open definition in other window if not the same buffer
  local util = require('vim.lsp.util')
  util.jump_to_location = function(location, offset_encoding, reuse_win)
    if offset_encoding == nil then
      vim.notify_once(
        'jump_to_location must be called with valid offset encoding',
        vim.log.levels.WARN
      )
    end
    vim.api.nvim_command("wincmd w")
    return util.show_document(location, offset_encoding, { reuse_win = true, focus = true })
  end

  require('lspconfig.ui.windows').default_options.border = 'single'

  local setkey = function(key, func, desc)
    vim.keymap.set('n', key, func, { noremap=true, silent=true, desc =desc })
  end
  setkey('<space>e', vim.diagnostic.open_float, "diagnostic.open_float")
  setkey('[d', vim.diagnostic.goto_prev, "diagnostic.goto_prev")
  setkey(']d', vim.diagnostic.goto_next, "diagnostic.goto_next")
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
    setkey('gd', vim.lsp.buf.definition, "lsp.definition")
    setkey('K', vim.lsp.buf.hover, "lsp.hover")
    setkey('gi', vim.lsp.buf.implementation, "lsp.implementation")
    setkey('<C-k>', vim.lsp.buf.signature_help, "lsp.signature_help")
    setkey('<space>wa', vim.lsp.buf.add_workspace_folder, "lsp.add_workspace_folder")
    setkey('<space>wr', vim.lsp.buf.remove_workspace_folder, "lsp.remove_workspace_folder")
    setkey('<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "lsp.list_workspace_folders")
    setkey('<space>D', vim.lsp.buf.type_definition, "lsp.type_definition")
    setkey('<space>rn', vim.lsp.buf.rename, "lsp.rename")
    setkey('<space>ca', vim.lsp.buf.code_action, "lsp.code_action")
    setkey('gr', vim.lsp.buf.references, "lsp.references")
    setkey('<space>f', function() 
      vim.lsp.buf.format { async = true }
    end, "lsp.formatting")
  end

  nvim_lsp.jedi_language_server.setup{
    cmd = { vim.g.python3_env .. "/bin/jedi-language-server" },

    capabilities = capabilities,
    on_attach = on_attach,
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

