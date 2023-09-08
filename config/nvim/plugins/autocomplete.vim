" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'

lua <<EOF
function autocomplete_setup()
  local snippy = require('snippy')
  snippy.setup({
      mappings = {
          is = {
              ['<Tab>'] = 'expand_or_advance',
              ['<S-Tab>'] = 'previous',
          },
          nx = {
              ['<leader>x'] = 'cut_text',
          },
      },
  })

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        snippy.expand_snippet(args.body)
      end,
    },
    enabled = function()
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      end
      if vim.api.nvim_buf_get_option(0, 'filetype') == 'gitcommit' then
        return false
      end
      local context = require("cmp.config.context")
      if context.in_treesitter_capture("comment")==true or context.in_syntax_group("Comment") then
        return false
      else
        return true
      end
    end,
    formatting = {
      format = function(entry, vim_item)
        -- Source
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          ultisnips = "[UltiSnips]",
          nvim_lua = "[Lua]",
        })[entry.source.name]
      return vim_item
    end},
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snippy.can_expand_or_advance() then
          snippy.expand_or_advance()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snippy.can_jump(-1) then
          snippy.previous()
        else
          fallback()
        end
      end, { "i", "s" }),
      ['<C-J>'] = cmp.mapping(function(fallback)
        vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
      end)
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'snippy' },
      -- { name = 'ultisnips' },
      -- { name = 'nvim_lsp_signature_help' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Copilot setup: disable mapping as it is managed through cmp
  -- vim.keymap.set('i', '<C-[>', 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })
  -- disable copilot keymapping
  -- vim.g.copilot_no_mappings = true
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  --   vim.keymap.set(
  --    "i",
  --    "<Plug>(vimrc:copilot-dummy-map)",
  --    'copilot#Accept("")',
  --    { silent = true, expr = true, desc = "Copilot dummy accept" }
  -- )

end

EOF

augroup AutocompleteSetup
  autocmd User PlugLoaded ++nested lua autocomplete_setup()
augroup end

