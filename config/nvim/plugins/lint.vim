" Linting
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/lsp-colors.nvim'
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
Plug 'folke/trouble.nvim'
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

  require("lsp_lines").setup()
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

  require("trouble").setup {}
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

  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  end
  vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
  vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)

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

