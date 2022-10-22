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
				return require('packer.util').float { border = 'rounded' }
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
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
			vim.cmd [[packadd packer.nvim]]
		end
		vim.cmd [[
			augroup packer_user_config
			autocmd!
			autocmd BufWritePost plugins.lua source <afile> | PackerCompile
			augroup end
			]]
	end

	-- Plugins
	local function plugins(use)
		use { 'wbthomason/packer.nvim' }

		-- Load only when required
		use { 'nvim-lua/plenary.nvim', module = 'plenary' }

		-- Notification
		use {
			'rcarriga/nvim-notify',
			event = 'VimEnter',
			config = function()
				vim.notify = require 'notify'
			end,
		}
		-- Colorscheme
		use {
			'catppuccin/nvim',
			as = 'catppuccin',
			config = function()
				vim.g.catppuccin_flavour = 'mocha'
				require 'catppuccin'.setup {
					dim_inactive = {
						enabled = true,
						shade = 'dark',
						percentage = 0.15,
					},
					integrations = {
						cmp = true,
						gitsigns = true,
						nvimtree = true,
						telescope = true,
						treesitter = true,
						treesitter_context = true,
						hop = true,
						markdown = true,
						neogit = true,
						which_key = true,
						lsp_saga = true,
					}
				}
				vim.api.nvim_command 'colorscheme catppuccin'
			end,
		}

		use 'navarasu/onedark.nvim'
		use 'folke/tokyonight.nvim'
		use 'EdenEast/nightfox.nvim'
		use 'shaunsingh/nord.nvim'
		use 'rebelot/kanagawa.nvim'
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
			cmd = 'Neogit',
			config = function()
				require('config.neogit').setup()
			end,
		}

		use {
			'lewis6991/gitsigns.nvim',
			event = 'BufReadPre',
			wants = 'plenary.nvim',
			requires = { 'nvim-lua/plenary.nvim' },
			config = function()
				require('config.gitsigns').setup()
			end,
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
			end,
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
			after = 'nvim-treesitter',
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
				print 'Loading treesitter'
				require('config.treesitter').setup()
			end,
			requires = {
				{ 'nvim-treesitter/nvim-treesitter-textobjects' },
				{ 'nvim-treesitter/playground'}
			},
		}

		-- FZF
		use { 'junegunn/fzf' }
		use { 'junegunn/fzf.vim' }
		use {
			'ibhagwan/fzf-lua',
			requires = { 'kyazdani42/nvim-web-devicons' },
		}

		-- Better netrw
		use { 'tpope/vim-vinegar' }

		use {
			'kyazdani42/nvim-tree.lua',
			requires = {
				'kyazdani42/nvim-web-devicons',
			},
			cmd = { 'NvimTreeToggle', 'NvimTreeClose' },
			config = function()
				require('config.nvimtree').setup()
			end,
		}

		-- User interface
		use {
			'stevearc/dressing.nvim',
			event = 'BufEnter',
			config = function()
				require('dressing').setup {
					select = {
						backend = { 'telescope', 'fzf', 'builtin' },
					},
				}
			end,
		}

		use {
			'nvim-telescope/telescope.nvim',
			opt = true,
			config = function()
				require('config.telescope').setup()
			end,
			cmd = { 'Telescope' },
			module = 'telescope',
			keys = { '<leader>f', '<leader>p' },
			wants = {
				'plenary.nvim',
				'popup.nvim',
				'telescope-fzf-native.nvim',
				'telescope-project.nvim',
				'telescope-repo.nvim',
				'telescope-file-browser.nvim',
				'project.nvim',
			},
			requires = {
				'nvim-lua/popup.nvim',
				'nvim-lua/plenary.nvim',
				{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
				'nvim-telescope/telescope-project.nvim',
				'cljoly/telescope-repo.nvim',
				'nvim-telescope/telescope-file-browser.nvim',
				{
					'ahmedkhalf/project.nvim',
					config = function()
						require('project_nvim').setup {}
					end,
				},
			},
		}

		-- Buffer line
		use {
			'akinsho/nvim-bufferline.lua',
			event = 'BufReadPre',
			wants = 'nvim-web-devicons',
			config = function()
				require('config.bufferline').setup()
			end,
		}

		use { 'andymass/vim-matchup', event = 'CursorMoved' }
		use { 'wellle/targets.vim', event = 'CursorMoved' }
		use { 'unblevable/quick-scope', event = 'CursorMoved' }
		use { 'chaoren/vim-wordmotion', opt = true, fn = { '<Plug>WordMotion_w' } }

		-- CMP Completion
		use {
			'hrsh7th/nvim-cmp',
			event = 'InsertEnter',
			opt = true,
			config = function()
				require('config.cmp').setup()
			end,
			wants = { 'LuaSnip' },
			requires = {
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-nvim-lua',
				'ray-x/cmp-treesitter',
				'hrsh7th/cmp-cmdline',
				'saadparwaiz1/cmp_luasnip',
				-- 'hrsh7th/cmp-calc',
				-- 'f3fora/cmp-spell',
				-- 'hrsh7th/cmp-emoji',
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-nvim-lsp-signature-help',
				{
					'L3MON4D3/LuaSnip',
					wants = 'friendly-snippets',
					config = function()
						require('config.luasnip').setup()
					end,
				},
				'rafamadriz/friendly-snippets',
			},
		}

		-- Auto pairs
		use {
			'windwp/nvim-autopairs',
			wants = 'nvim-treesitter',
			module = { 'nvim-autopairs.completion.cmp', 'nvim-autopairs' },
			config = function()
				require('config.autopairs').setup()
			end,
		}

		-- Auto tags
		use {
			'windwp/nvim-ts-autotag',
			wants = 'nvim-treesitter',
			event = 'InsertEnter',
			config = function()
				require('nvim-ts-autotag').setup { enable = true }
			end,
		}

		-- Endwise
		use {
			'RRethy/nvim-treesitter-endwise',
			wants = 'nvim-treesitter',
			event = 'InsertEnter',
		}

		-- LSP
		use {
			'neovim/nvim-lspconfig',
			opt = true,
			event = 'BufReadPre',
			wants = {
				'cmp-nvim-lsp',
				'nvim-lsp-installer',
				'neodev.nvim',
				'vim-illuminate',
				'null-ls.nvim',
				'schemastore.nvim',
			},
			config = function()
				require('neodev').setup()
				require('config.lsp').setup()
			end,
			requires = {
				'williamboman/nvim-lsp-installer',
				'folke/neodev.nvim',
				'RRethy/vim-illuminate',
				'jose-elias-alvarez/null-ls.nvim',
				{
					'j-hui/fidget.nvim',
					config = function()
						require('fidget').setup {}
					end,
				},
				'b0o/schemastore.nvim',
			},
		}

		use {
			'folke/trouble.nvim',
			event = 'BufReadPre',
			wants = 'nvim-web-devicons',
			cmd = { 'TroubleToggle', 'Trouble' },
			config = function()
				require('trouble').setup {
					use_diagnostic_signs = true,
				}
			end,
		}

		use {
			'tami5/lspsaga.nvim',
			event = 'VimEnter',
			cmd = { 'LspSaga' },
			config = function()
				require('lspsaga').setup {}
			end,
		}

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
