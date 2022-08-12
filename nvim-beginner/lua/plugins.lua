local M = {}


function M.setup()
	-- First time installation
	local packer_bootstrap = false

	-- packer.nvim configuration
	local conf = {
		profile = {
			enable = true,
			threshold = 0, -- The amount of time in ms that a plugins load time must exceed for it to be included in the profile
		},
		display = {
			open_fn = function()
				return require('packer.util').float { border = "rounded" }
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system {
				'git',
				'clone',
				'--depth',
				'1',
				'https://github.com/wbthomason/packer.nvim',
				install_path,
			}
			vim.cmd [[packadd packer.nvim]]
		end
		vim.cmd([[
			augroup packer_user_config
			autocmd!
			autocmd BufWritePost plugins.lua source <afile> | PackerCompile
			augroup end
		]])
	end

	-- Plugins
	local function plugins(use)
		use { 'wbthomason/packer.nvim' }

		-- Load only when required
		use { 'nvim-lua/plenary.nvim', module = 'plenary' }

		-- Colorscheme
		use {
			'catppuccin/nvim',
			as = 'catppuccin',
			config = function()
				vim.g.catppuccin_flavour = 'mocha'
				vim.cmd 'colorscheme catppuccin'
			end,
		}

		-- Startup screen
		use {
			'goolord/alpha-nvim',
			config = function()
				require('config.alpha').setup()
			end,
		}

		-- Git
		use {
			'TimUntersberger/neogit',
			requires = 'nvim-lua/plenary.nvim',
			cmd = 'Neogit',
			config = function()
				require('config.neogit').setup()
			end
		}

		-- Whichkey
		use {
			'folke/which-key.nvim',
			event = 'VimEnter',
			config = function()
				require('config.whichkey').setup()
			end,
		}

		-- IndentLine
		use {
			'lukas-reineke/indent-blankline.nvim',
			event = 'BufReadPre',
			config = function()
				require('config.indentblankline').setup()
			end
		}

		-- Better icons
		use {
			'kyazdani42/nvim-web-devicons',
			module = 'nvim-web-devicons',
			config = function()
				require('nvim-web-devicons').setup { default = true }
			end,
		}

		-- Better comment
		use {
			'numToStr/Comment.nvim',
			opt = true,
			keys = { 'gc', 'gcc', 'gbc' },
			config = function()
				require('Comment').setup {}
			end,
		}

		-- Easy Hopping
		use {
			'phaazon/hop.nvim',
			cmd = { 'HopWord', 'HopChar1' },
			config = function()
				require('hop').setup {}
			end,
		}

		-- Easy motion
		use {
			'ggandor/lightspeed.nvim',
			keys = { 's', 'S', 'f', 'F', 't', 'T' },
			config = function()
				require('lightspeed').setup {}
			end,
		}

		-- Markdown
		use {
			'iamcco/markdown-preview.nvim',
			run = function()
				vim.fn['mkdp#util#install']()
			end,
			ft = 'markdown',
			cmd = { 'MarkdownPreview' },
		}

		-- Lualine
		use {
			'nvim-lualine/lualine.nvim',
			event = 'VimEnter',
			config = function()
				require('config.lualine').setup()
			end,
			requires = { 'nvim-web-devicons' },
		}

		-- LSP GPS
		use {
			'SmiteshP/nvim-gps',
			requires = 'nvim-treesitter/nvim-treesitter',
			module = 'nvim-gps',
			config = function()
				require('nvim-gps').setup()
			end,
		}

		-- Treesitter
		use {
			'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			config = function()
				require('config.treesitter').setup()
			end,
		}

		-- FZF
		use { 'junegunn/fzf' }
		use { 'junegunn/fzf.vim' }

		if packer_bootstrap then
			print 'Restarting Neovim required after installation!'
			require('packer').sync()
		end
	end

	packer_init()

	local packer = require 'packer'
	packer.init(conf)
	packer.startup(plugins)
end

return M

