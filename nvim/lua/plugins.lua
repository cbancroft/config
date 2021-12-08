return require('packer').startup(function()
  -- let packer manage itself
  use 'wbthomason/packer.nvim'

  -- aesthetics
  use 'lokesh-krishna/moonfly.nvim'
  use 'kyazdani42/nvim-web-devicons'
    
  -- syntax highlighting
  use 'ajouellette/sway-vim-syntax'
  use 'fladson/vim-kitty'
  use 'neoclide/jsonc.vim'

  -- Completion
  use 'hrsh7th/nvim-compe'

  -- writing
  use 'reedes/vim-pencil'
  use 'folke/zen-mode.nvim'
  use 'folke/twilight.nvim'
  use 'windwp/nvim-autopairs'

  -- additional ui elements
  use 'shadmansaleh/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'kyazdani42/nvim-tree.lua'

  -- telescope and dependencies
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'https://github.com/glepnir/lspsaga.nvim'

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'

  use {'glepnir/galaxyline.nvim', branch = 'main'}
  end)
