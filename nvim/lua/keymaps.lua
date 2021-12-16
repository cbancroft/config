---------------------------------------------------------------
-- Keymaps configuration: neovim and plugins
---------------------------------------------------------------

local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local cmd = vim.cmd
local NOP = "<nop>"

local function mapn(...)
  map("n", ...)
end
local function mapnl(binding, ...)
  map("n", "<leader>" .. binding, ...)
end

---------------------------------------------------------------
-- Neovim shortcuts
---------------------------------------------------------------

-- clear search highlighting
map("n", "<leader>c", ":nohl<CR>", default_opts)

-- map Esc to kk
map("i", "kk", "<Esc>", { noremap = true })

-- Don't use hjkl for nav
map("", "h", NOP, { noremap = true })
map("", "j", NOP, { noremap = true })
map("", "k", NOP, { noremap = true })
map("", "l", NOP, { noremap = true })

-- fast saving with <leader> and s
map("n", "<leader>s", ":w<CR>", default_opts)
map("i", "<leader>s", "<C-c>:w<CR>", default_opts)

-- move around splits using Ctrl + {up, down, left, right}
map("n", "<C-Left>", "<C-w>h", default_opts)
map("n", "<C-Down>", "<C-w>j", default_opts)
map("n", "<C-Up>", "<C-w>k", default_opts)
map("n", "<C-Right>", "<C-w>l", default_opts)

-- close all windows and exit from neovim
map("n", "<leader>q", ":qa!<CR>", default_opts)

---------------------------------------------------------------
-- Applications & Plugins shortcuts:
---------------------------------------------------------------
-- open terminal
map("n", "<C-t>", ":Term<CR>", { noremap = true })

-- nvim-tree
map("n", "<C-n>", ":NvimTreeToggle<CR>", default_opts) -- open/close
map("n", "<leader>r", ":NvimTreeRefresh<CR>", default_opts) -- refresh
map("n", "<leader>n", ":NvimTreeFindFile<CR>", default_opts) -- search file

-- Vista tag-viewer
map("n", "<C-m>", ":Vista!!<CR>", default_opts) -- open/close




