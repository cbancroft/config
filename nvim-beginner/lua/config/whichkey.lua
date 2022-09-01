local M = {}

function M.setup()
	local whichkey = require 'which-key'

	local conf = {
		window = {
			border = 'single', -- none, single, double, shadow
			position = 'bottom', -- bottom, top
		},
	}

	local opts = {
		mode = 'n',
		prefix = '<leader>',
		buffer = nil, -- Global mappings. Specify a buffer for local mappings
		silent = true,
		noremap = true,
		nowait = false
	}

	local mappings = {
		['w'] = { '<cmd>update!<CR>', 'Save'},
		['q'] = { '<cmd>q!<CR>', 'Quit'},

		b = {
			name = 'Buffer',
			c = { '<cmd>bd!<CR>', 'Close current buffer'},
			D = { '<cmd>%bd|e#|bd#<CR>', 'Delete all buffers'},
		},

		z = {
			name = 'Packer',
			c = { '<cmd>PackerCompile<CR>', 'Compile' },
			i = { '<cmd>PackerInstall<CR>', 'Install' },
			s = { '<cmd>PackerSync<CR>', 'Sync' },
			S = { '<cmd>PackerStatus<CR>', 'Status' },
			u = { '<cmd>PackerUpdate<CR>', 'Update' },
			r = { '<cmd>lua reload_config()<CR>', 'Reload config' }
		},

		f = {
			name = 'Find',
			f = { '<cmd>Telescope find_files<cr>', 'Files'},
			F = { '<cmd>Telescope git_files<cr>', 'Git Files'},
			d = { '<cmd>lua require("utils.finder").find_dotfiles()<cr>', 'Dotfiles'},
			b = { '<cmd>Telescope buffers<cr>', 'Buffers'},
			o = { '<cmd>Telescope oldfiles<cr>', 'Old Files'},
			g = { '<cmd>Telescope live_grep<cr>', 'Live grep'},
			c = { '<cmd>Telescope commands<cr>', 'Commands'},
			r = { '<cmd>Telescope file_browser<cr>', 'Browser'},
			w = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Current Buffer'},
			e = { '<cmd>NvimTreeToggle<cr>', 'Explorer' },
		},
		
		g = {
			name = 'Git',
			s = { '<cmd>Neogit<CR>', 'Status'},
		},

		p = {
			name = 'Project',
			p = { '<cmd>Telescope projects<cr>', 'List'},
			s = { '<cmd>Telescope repo list<cr>', 'Search' },
		}
	}

	whichkey.setup(conf)
	whichkey.register(mappings, opts)
end

return M
		
