---------------------------------------------------------------
-- Telescope
---------------------------------------------------------------
local telescope = require("telescope")
local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

local function mapnl(binding, ...)
	map("n", "<leader>" .. binding, ...)
end

telescope.load_extension("git_worktree")

-- Find files using Telescope command line sugar
mapnl("ff", "<cmd>Telescope find_files<cr>", default_opts)
mapnl("fg", "<cmd>Telescope live_grep<cr>", default_opts)
mapnl("fb", "<cmd>Telescope buffers<cr>", default_opts)
mapnl("fh", "<cmd>Telescope help_tags<cr>", default_opts)
mapnl("gw", "<cmd>lua require'telescope'.extensions.git_worktree.git_worktrees()<cr>", default_opts)
mapnl("gm", "<cmd>lua require'telescope'.extensions.git_worktree.create_git_worktree()<cr>", default_opts)
