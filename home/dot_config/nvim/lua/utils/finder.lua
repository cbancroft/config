local M = {}

function M.find_files()
	local opts = {}
	local telescope = require 'telescope.builtin'

	local ok = pcall(telescope.git_files, opts)
	if not ok then
		telescope.find_files(opts)
	end
end

function M.find_dotfiles()
	require('telescope.builtin').find_files {
		prompt_title = '<Dotfiles>',
		cwd = '$HOME/git/config'
	}
end

function M.find_buffers()
	local results = {}
	local buffers = vim.api.nvim_list_bufs()

	for _, buffer in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buffer) then
			local filename = vim.api.nvim_buf_get_name(buffer)
			table.insert(results, filename)
		end
	end

	vim.ui.select(results, { prompt = 'Find buffer:' }, function(selected)
		if selected then
			vim.api.nvim_command('buffer ' .. selected)
		end
	end)
end

return M
