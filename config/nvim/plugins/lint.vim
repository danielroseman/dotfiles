" Linting
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/lsp-colors.nvim'
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

lua <<EOF
function lint_setup()
    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


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
    virtual_text = false,
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
          require("null-ls").builtins.diagnostics.mypy.with({
            extra_args = function(params)
              local anc = find_ancestor(params.bufname, 'mypy.ini')
              return anc and {"--config-file", nvim_lsp.util.path.join(anc, 'mypy.ini')}
            end
          }),
          require("null-ls").builtins.diagnostics.flake8.with({
            cwd = function(params)
              return find_ancestor(params.bufname, 'requirements.txt')
            end
          })
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
      debug = true,
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
    setkey('<space>f', vim.lsp.buf.formatting, "lsp.formatting")
  end

  if not configs.ruby_lsp then
   configs.ruby_lsp = {
     default_config = {
       cmd = {'bundle', 'exec', 'ruby-lsp'};
       filetypes = {'ruby'};
       -- root_dir = function(fname)
         -- local root = find_ancestor(fname, 'Gemfile')
       -- end;
       root_dir = nvim_lsp.util.root_pattern('Gemfile');
       -- on_new_config = function(new_config, root_dir)
         -- local in_gemfile = os.execute("grep ruby-lsp " .. root_dir .. "/Gemfile")
         -- if in_gemfile then
           -- new_config.cmd = {'bundle', 'exec', 'ruby-lsp'}
         -- else
           -- new_config.autostart = false
         -- end
       -- end;
       settings = {};
       on_attach = on_attach;
       capabilities = capabilities
     };
   }
  end

  nvim_lsp.jedi_language_server.setup{
    cmd = { "/Users/danielroseman/.pyenv/virtualenvs/py3nvim/bin/jedi-language-server" },
    capabilities = capabilities,
    on_attach = on_attach,
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

