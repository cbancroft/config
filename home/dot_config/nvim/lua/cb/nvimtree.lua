local M = {}

function M.setup()
	require'nvim-tree'.setup {
		disable_netrw = true,
		hijack_netrw = true,
		auto_reload_on_write = true,
		view = {
			number = true,
			relativenumber = true,
		},
		filters = {
			custom = {'.git'},
		},
		update_cwd = true,
		respect_buf_cwd = true,
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = false,
		},
	}

end

return M
