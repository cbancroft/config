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
		},

		g = {
			name = 'Git',
			s = { '<cmd>Neogit<CR>', 'Status'},
		},
	}

	whichkey.setup(conf)
	whichkey.register(mappings, opts)
end

return M
		
