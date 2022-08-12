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
		},
	}
end

return M
