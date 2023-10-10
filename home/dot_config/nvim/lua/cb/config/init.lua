local M = {}

local utils = require'utils'

function M.init()
	if vim.tbl_isempty(CONFIG or {}) then
		CONFIG = vim.deepcopy(require('cb.config.defaults'))
		local home_dir = vim.loop.os_homedir()
		CONFIG.snip_dir = utils.join_paths(home_dir, '.config', 'snippets')
		CONFIG.database = {
			save_location = utils.join_paths(home_dir, '.config', 'cbnvim_db'),
			auto_execute = 1
		}
	end

	require 'cb.keymappings'.load_defaults()
end
