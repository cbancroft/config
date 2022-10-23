local M = {}



function M.setup()
	require('nvim-treesitter.configs').setup {
		-- A list of parser names, or 'all'
		ensure_installed = 'all',

		-- Phpdoc does not install properly on my macbook
		ignore_install = { 'phpdoc' },

		-- Install languages synchronously
		sync_install = false,

		highlight = {
			-- 'false' will disable the whole extension
			enable = true,
			additional_vim_regex_highlighting = false,
		},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = 'gnn',
				node_incremental = 'grn',
				scope_incremental = 'grc',
				node_decremental = 'grm',
			},
		},

		indent = { enable = true },

		-- vim-matchup
		matchup = {
			enable = true,
		},

		endwise = {
			enable = true,
		},
		-- nvim-treesitter-textobjects
		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					-- Capture groups defined in textobjects.scm
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},

			swap = {
				enable = true,
				swap_next = {
					['<leader>rx'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>rX'] = '@parameter.inner',
				},
			},

			move = {
				enable = true,
				set_jumps = true, -- Set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},

		}
	}
end

return M
