local api = vim.api
local g = vim.g
local opt = vim.opt

-- Remap leader and local leader to <Space>
api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true})
g.mapleader = " "
g.maplocalleader = " "

opt.termguicolors = true -- Enable colors in the terminal
opt.hlsearch = true -- Set highlight on search
opt.number = true -- Make line numbers default
opt.relativenumber = true -- Make relative numbering the default
opt.mouse = "a" -- Enable mouse mode
opt.breakindent = true -- Enable indent breaking
opt.undofile = true -- Save undo history
opt.ignorecase = true -- Case insensitive searches
opt.smartcase = true -- Ignore case insensitivity if capital in query
opt.updatetime = 250 -- Decrease update time
opt.signcolumn = "yes" -- Always show sign column
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.timeoutlen = 300 -- Time in ms to wait for a mapped key sequence to complete
opt.showmode = false
opt.laststatus = 3 -- Global status bar

opt.wildignorecase = true -- Case insensitive file find searching
opt.wildignore:append '**/node_modules/**'
opt.wildignore:append '**/.git/*'
opt.wildignore:append '**/build/*'

-- Highlight on yank
vim.cmd [[
	augroup YankHighlight
		autocmd!
		autocmd TextYankPost * silent! lua vim.highlight.on_yank()
	augroup end
]]

-- Better search
opt.path:remove '/usr/include'
opt.path:append '**'

-- Treesitter folding
vim.cmd [[
	set foldlevel=20
	set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
]]
