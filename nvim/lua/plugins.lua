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
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

local cmd = vim.cmd
cmd([[packadd packer.nvim]])

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
local packer = require("packer")

-- Add packages
return packer.startup(function()
	-- packer can manage itself
	use("wbthomason/packer.nvim")

	-- file explorer
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- for file icons
		},
		config = [[ require'plugins.nvim-tree' ]],
	})

	-- indent line
	use({ "lukas-reineke/indent-blankline.nvim", config = [[ require'plugins.indent-blankline' ]] })

	-- autopair
	use({
		"windwp/nvim-autopairs",
		config = [[ require'plugins.autopairs' ]],
	})

	-- icons
	use("kyazdani42/nvim-web-devicons")

	-- tagviewer
	use({ "liuchengxu/vista.vim", config = [[ require'plugins.vista' ]] })

	-- treesitter interface
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = [[require'plugins.nvim-treesitter']] })

	-- colorschemes
	use("tanvirtin/monokai.nvim")
	use("folke/tokyonight.nvim")
	use({ "rose-pine/neovim", as = "rose-pine" })

	-- LSP
	use({ -- A collection of common configs for Neovim's built-in LSP client
		"neovim/nvim-lspconfig",
		config = [[require('plugins/nvim-lspconfig')]],
	})
	-- Installs LSP servers for us
	use({ "williamboman/nvim-lsp-installer", config = [[ require('plugins/nvim-lspinstaller') ]] })

	use({ -- VSCode like icons for neovim completion topics
		"onsails/lspkind-nvim",
		config = [[ require'plugins/lspkind' ]],
	})

	use({ -- Utility functions for getting diagnostic status and progress messages from LSP
		"nvim-lua/lsp-status.nvim",
		config = [[ require'plugins/lspstatus' ]],
	})
	--- For doing Lua formatting
	-- use({ "jose-elias-alvarez/null-ls.nvim", config = [[ require'plugins.null-ls' ]] })

	-- autocomplete
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"saadparwaiz1/cmp_luasnip",
		},
		config = [[ require'plugins/cmp' ]],
	})

	use({ "ajouellette/sway-vim-syntax" })

	use({ -- Snippet Engine for Neovim written in Lua.
		"L3MON4D3/LuaSnip",
		requires = {
			-- Snippets collection for different languages
			"rafamadriz/friendly-snippets",
		},
		config = [[ require'plugins.luasnip' ]],
	})

	-- statusline
	use({
		"famiu/feline.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = [[ require'plugins.feline' ]],
	})

	-- git labels
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = [[ require'plugins.gitsigns' ]],
	})

	-- dashboard
	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = [[ require'plugins.alpha-nvim' ]],
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = [[ require'plugins.telescope' ]],
	})

	-- Worktrees from primeagen
	use({
		"ThePrimeagen/git-worktree.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = [[ require'plugins.git-worktree' ]],
	})
	use("sbdchd/neoformat")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
