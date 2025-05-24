" Look and feel
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

lua <<EOF
function look_and_feel_setup()

  require("ibl").setup {
    scope = { enabled = false } ,
  }

  vim.opt.list = true
  vim.opt.listchars = { tab = "▸ ", eol = "¬", trail = "·", extends = "»", precedes = "«" } 
  vim.opt.signcolumn = "yes"  -- always show gutter
  vim.opt.showbreak = "↪"     -- show a line has been wrapped
  vim.opt.showmode = false    -- lightline shows this already
  vim.opt.colorcolumn = "80"

  vim.o.winborder = 'rounded'

  vim.opt.background = "dark"
  vim.opt.termguicolors = true
  vim.g.gruvbox_contrast_dark = "hard"
  vim.g.gruvbox_invert_selection = 0
  vim.cmd "colorscheme gruvbox"
  -- fix inverted statusline in nvim 0.11+
  vim.cmd "hi StatusLine cterm=NONE gui=NONE"
  vim.cmd "hi StatusLineNC cterm=NONE gui=NONE"
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

  vim.g.lightline = {
     colorscheme = 'gruvbox',
     active = {
       left = { { 'mode', 'paste' },
                 { 'readonly', 'relativepath', 'modified' } },
       right = { { 'lineinfo' },
                  { 'percent' },
                  { 'gitbranch' } }
     },
     inactive = {
       left = { { 'filename', 'modified' } },
       right = { { 'lineinfo' }, {'percent'} }
     },
     component_function = {
       gitbranch = 'FugitiveHead',
     },
     mode_map = {
       n = 'N',
       i = 'I',
       R = 'R',
       v = 'V',
       V = 'VL',
       ["\22"] = 'VB', -- ctrl-v
       c = 'C',
       s = 'S',
       S = 'SL',
       ["\19"] = 'SB', -- ctrl-s
       t = 'T',
       },
     }
  end
EOF

augroup LintSetup
  autocmd User PlugLoaded ++nested lua look_and_feel_setup()
augroup end

