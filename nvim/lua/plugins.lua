-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- https://github.com/wbthomason/packer.nvim

-- For information about installed plugins see the README
--- neovim-lua/README.md
--- https://github.com/brainfucksec/neovim-lua#readme

-- Ensure that packer.nvim is installedlocal execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
end

local cmd = vim.cmd
cmd [[packadd packer.nvim]]

-- Recompile things whenever we rewrite the plugins.lua file
vim.api.nvim_exec(
  [[
augroup Packer
  autocmd!
  autocmd BufWritePost plugins.lua PackerCompile
  augroup END
]],
  false
)
local packer = require 'packer'

-- Add packages
return packer.startup(function(use)
  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  -- file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- for file icons
    },
    config = [[ R'plugins.nvim-tree' ]],
  }

  -- indent line
  use { 'lukas-reineke/indent-blankline.nvim', config = [[ R'plugins.indent-blankline' ]] }

  -- autopair
  -- use {
  --  'windwp/nvim-autopairs',
  --  config = [[ R'plugins.autopairs' ]],
  --}

  -- icons
  use 'kyazdani42/nvim-web-devicons'

  -- floaterm
  use 'voldikss/vim-floaterm'

  -- treesitter interface
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[R'plugins.nvim-treesitter']] }
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- colorschemes
  use 'tanvirtin/monokai.nvim'
  use 'folke/tokyonight.nvim'
  use { 'rose-pine/neovim', as = 'rose-pine' }
  use 'Mofiqul/vscode.nvim'
  use 'rafamadriz/neon'
  use 'Th3Whit3Wolf/space-nvim'
  use 'RRethy/nvim-base16'
  use 'andersevenrud/nordic.nvim'
  use 'sainnhe/gruvbox-material'
  use 'NTBBloodbath/doom-one.nvim'
  use 'rmehri01/onenord.nvim'
  use 'rebelot/kanagawa.nvim'

  -- LSP
  use { -- A collection of common configs for Neovim's built-in LSP client
    'neovim/nvim-lspconfig',
    config = [[R('plugins/nvim-lspconfig')]],
  }
  -- Installs LSP servers for us
  use { 'williamboman/nvim-lsp-installer', config = [[ R('plugins/nvim-lspinstaller') ]] }

  use { -- VSCode like icons for neovim completion topics
    'onsails/lspkind-nvim',
    config = [[ R'plugins/lspkind' ]],
  }

  use { -- Utility functions for getting diagnostic status and progress messages from LSP
    'nvim-lua/lsp-status.nvim',
    config = [[ R'plugins/lspstatus' ]],
  }

  --- For doing Lua formatting
  -- use({ "jose-elias-alvarez/null-ls.nvim", config = [[ require'plugins.null-ls' ]] })

  -- autocomplete
  --[==[
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
    },
    config = [[ R'plugins/cmp' ]],
  }
--]==]

  -- CoQ
  use {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    config = [[ R'plugins/coq' ]],
    requires = {
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
      { 'ms-jpq/coq.thirdparty', branch = '3p' },
    },
  }
  use { 'ajouellette/sway-vim-syntax' }

  use { -- Snippet Engine for Neovim written in Lua.
    'L3MON4D3/LuaSnip',
    requires = {
      -- Snippets collection for different languages
      'rafamadriz/friendly-snippets',
    },
    config = [[ R'plugins.luasnip' ]],
  }

  -- statusline
  -- use {
  --   'famiu/feline.nvim',
  --   requires = { 'kyazdani42/nvim-web-devicons' },
  --   config = [[ R'plugins.feline' ]],
  --  }

  use {
    'nvim-lualine/lualine.nvim',
    require = { 'kyazdani42/nvim-web-devicons' },
    config = [[ R'plugins.lualine' ]],
  }

  -- git labels
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = [[ R'plugins.gitsigns' ]],
  }

  -- dashboard
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = [[ R'plugins.alpha-nvim' ]],
  }

  -- bufferline goodness
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[R'plugins.bufferline']],
  }
  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = [[ R'plugins.telescope' ]],
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', config = [[ R'plugins.telescope-fzf' ]] }
  use {
    'nvim-telescope/telescope-file-browser.nvim',
    config = function()
      require('telescope').load_extension 'file_browser'
    end,
  }

  -- Worktrees from primeagen
  use {
    'ThePrimeagen/git-worktree.nvim',
    requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = [[ R'plugins.git-worktree' ]],
  }
  use 'sbdchd/neoformat'

  use { 'folke/which-key.nvim', config = [[ R'plugins.which-key' ]] }
  use { 'liuchengxu/vista.vim', config = [[ R'plugins.vista' ]] }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-commentary' }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
