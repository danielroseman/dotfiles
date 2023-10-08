" Syntax
Plug 'tpope/vim-sleuth'            " detect indent based on other files
Plug 'cespare/vim-toml'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'omnisyle/nvim-hidesig'

lua <<EOF
function syntax_setup()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "python", "lua", "ruby", "vim", "json" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    highlight = {
      enable = true,
      disable = { "json" }
    },
    endwise = {
      enable = true,
    },
    hidesig = {
      enable = true,
      opacity = 0.5,
      delay = 200,
    },
    textobjects = {
      lsp_interop = {
        enable = true,
        border = 'rounded',
        peek_definition_code = {
          ["<leader>df"] = "@function.outer",
          ["<leader>dF"] = "@class.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]b"] = "@block.outer",
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[b"] = "@block.outer",
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
    textsubjects = {
      enable = true,
      prev_selection = ',', -- (Optional) keymap to select the previous selection
      keymaps = {
          ['.'] = 'textsubjects-smart',
          [';'] = 'textsubjects-container-outer',
          ['i;'] = 'textsubjects-container-inner',
      },
    },
  }

end
EOF

augroup SyntaxSetup
  autocmd User PlugLoaded ++nested lua syntax_setup()
augroup end
