-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- https://github.com/wbthomason/packer.nvim

-- For information about installed plugins see the README
--- neovim-lua/README.md
--- https://github.com/brainfucksec/neovim-lua#readme

-- Ensure that packer.nvim is installed
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

local cmd = vim.cmd
cmd([[packadd packer.nvim]])

local packer = require("packer")

-- Add packages
return packer.startup(function()
  -- packer can manage itself
  use("wbthomason/packer.nvim")

  -- file explorer
  use("kyazdani42/nvim-tree.lua")

  -- indent line
  use("lukas-reineke/indent-blankline.nvim")

  -- autopair
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  })

  -- icons
  use("kyazdani42/nvim-web-devicons")

  -- tagviewer
  use("liuchengxu/vista.vim")

  -- treesitter interface
  use("nvim-treesitter/nvim-treesitter")

  -- colorschemes
  use("tanvirtin/monokai.nvim")
  use("folke/tokyonight.nvim")
  use({ "rose-pine/neovim", as = "rose-pine" })

  -- LSP
  use({ "neovim/nvim-lspconfig", "williamboman/nvim-lsp-installer" })
  use("jose-elias-alvarez/null-ls.nvim")

  -- autocomplete
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
    },
  })

  -- statusline
  use({
    "famiu/feline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  -- git labels
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end,
  })

  -- dashboard
  use({
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      require("alpha").setup(require("alpha.themes.dashboard").opts)
    end,
  })
end)
