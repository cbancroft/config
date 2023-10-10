local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	term_mode = { silent = True },
}

local mode_adapter = {
	insert_mode = 'i',
	normal_mode = 'n',
	term_mode = 't',
	visual_mode = 'v',
	visual_block_mode = 'x',
	command_mode = 'c',
}

local defaults = {
	-- @usage keymappings for insert mode
	insert_mode = {
		-- Easy quit insert mode
		['hh'] = '<ESC>',
		['kk'] = '<ESC>',
		-- Move current line with Alt-j/k
		['<A-j>'] = '<Esc>:m .+1<CR>==gi',
		['<A-k>'] = '<Esc>:m .-2<CR>==gi',
	},

	-- @usege keymappings for normal mode
	normal_mode = {
		-- Better window movement
		["<C-Up>"] = "<C-w>k",
		["<C-Down>"] = "<C-w>j",
		["<C-Left>"] = "<C-w>h",
		["<C-Right>"] = "<C-w>l",

		-- Resize with arrows
		["<C-S-Up>"] = ":resize -2<cr>",
		["<C-S-Down>"] = ":resize +2<cr>",
		["<C-S-Left>"] = ":vertical resize -2<cr>",
		["<C-S-Right>"] = ":vertical resize +2<cr>",

		-- Tab switch buffers
		["<S-l>"] = ":BufferLineCycleNext<cr>",
		["<S-h>"] = ":BufferLineCyclePrev<cr>",

		-- Move the current line/block with Alt-j/k
		["<A-j>"] = ":m .+1<cr>==",
		["<A-k>"] = ":m .-2<cr>==",

		-- Center search results
		["n"] = "nzz",
		["N"] = "Nzz",

		-- Quickfix
		["]q"] = ":cnext<cr>",
		["[q"] = ":cprev<cr>",
		["<C-q>"] = ":call QuickFixToggle()<cr>"
	},
	
	-- @usage keymappings for terminal mode
	term_mode = {
		-- Terminal window navigation
		["<C-h>"] = "<C-\\><C-N><C-w>h",
		["<C-j>"] = "<C-\\><C-N><C-w>j",
		["<C-k>"] = "<C-\\><C-N><C-w>k",
		["<C-l>"] = "<C-\\><C-N><C-w>l",
	},

	-- @usage keymappings for visual mode
	visual_mode = {
		-- Better indentation
		["<"] = "<gv",
		[">"] = ">gv",
	}
}
-- -- Better escape using hh in insert and terminal mode
-- keymap('i', 'hh', '<ESC>', default_opts)
-- keymap('t', 'hh', '<C-\\><C-n>', default_opts)
--
-- -- Center search results
-- keymap('n', 'n', 'nzz', default_opts)
-- keymap('n', 'N', 'Nzz', default_opts)
--
-- -- Visual line wraps
-- keymap('n', 'j', "v:count == 0 ? 'gk' : 'k'", expr_opts)
-- keymap('n', 'k', "v:count == 0 ? 'gj' : 'j'", expr_opts)
--
-- -- Better Indent
-- keymap('v', '<', '<gv', default_opts)
-- keymap('v', '>', '>gv', default_opts)
--
-- -- Paste over currently selected text without yanking it
-- keymap('v', 'p', '"_dP', default_opts)
--
-- -- Switch buffer
-- keymap('n', '<S-h>', ':bprevious<CR>', default_opts)
-- keymap('n', '<S-l>', ':bnext<CR>', default_opts)
--
-- -- Cancel search highlighting with ESC
-- keymap('n', '<ESC>', ":nohlsearch<Bar>:echo<CR>", default_opts)
--
-- -- Move selected line/block of text in visual mode
-- keymap('x', 'K', ':move <-2<CR>gv-gv', default_opts)
-- keymap('x', 'J', ':move >+1<CR>gv-gv', default_opts)
--
-- -- Resizing panes
-- keymap('n', '<Left>', ':vertical resize +1<CR>', default_opts)
-- keymap('n', '<Right>', ':vertical resize -1<CR>', default_opts)
-- keymap('n', '<Up>', ':resize -1<CR>', default_opts)
-- keymap('n', '<Down>', ':resize +1<CR>', default_opts)
--
--
