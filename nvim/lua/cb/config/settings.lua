local M = {}
local join_paths = require('cb.utils').join_paths

function M.load_default_options()
  local default_options = {
    backup = false, -- Dont create a backup file
    clipboard = 'unnamedplus', -- Use the system clipboard
    cmdheight = 2, -- More space for the command line
    colorcolumn = '99999', -- Fixes indentline?
    completeopt = { 'menuone', 'noselect'},
    conceallevel = 0, -- Want `` visible in markdown files
    fileencoding = 'utf-8',
    foldmethod = 'manual', -- Folding, set to expr for treesitter folding
    foldexpr = '', -- Set to "nvim_treesitter#foldexpr()" for treesitter folding
    guifont = 'JetBrainsMono NF 11',
    hidden = true, -- required to keep multiple buffers and open multiple buffers
    hlsearch = true,
    ignorecase = true, -- Ignore case in search patterns
    mouse = 'a', -- allow mouse to be used
    pumheight = 10, -- pop up menu height
    showmode = false, -- we don't need to see the mode anymore, its in the lualine
    showtabline = 2, -- Always show tabs
    smartcase = true, -- Smart case
    smartindent = true, -- Make indenting smart again
    splitbelow = true, -- force all hsplits to go below current window
    splitright = true, -- force all vsplits to go to right of current window
    swapfile = false, -- no swapfile
    termguicolors = true, -- Set term gui colors
    timeoutlen = 250, -- time to wait for a mapped sequence to complete (ms)
    title = true, -- Set the title of the window to the value of the titlestring
    undodir = join_paths(get_cache_dir(), 'undo'), -- Set the undo dir
    undofile = true, -- Enable persistent undo
    updatetime = 300, -- Faster completion
    writebackup = false,
    expandtab = true, -- tabs to spaces
    shiftwidth = 2,
    tabstop = 2,
    cursorline = true,
    number = true,
    relativenumber = true,
    numberwidth = 4,
    signcolumn = 'yes', -- Always show the sign column
    wrap = false,
    spell = false,
    spelllang = 'en',
    shadafile = join_paths(get_cache_dir(), 'cb.shada'),
    scrolloff = 8, -- Minimal number of screen lines to keep above/below cursor
    sidescrolloff = 8, -- Minimal number of screen lines to keep left/right of cursor
  }

  vim.opt.shortmess:append 'c' -- don't show redundant messages from ins-completion-menu
  vim.opt.shortmess:append 'I' -- don't show default intro message
  vim.opt.whichwrap:append '<,>,[,],h,l'

  for k, v in pairs(default_options) do
    vim.opt[k] = v
  end
end

M.load_headless_options = function()
  vim.opt.shortmess = "" -- try to prevent echom from cutting messages off or prompting
  vim.opt.more = false -- don't pause listing when screen is filled
  vim.opt.cmdheight = 9999 -- helps avoiding |hit-enter| prompts.
  vim.opt.columns = 9999 -- set the widest screen possible
  vim.opt.swapfile = false -- don't use a swap file
end

M.load_options = function()
  if #vim.api.nvim_list_uis() == 0 then
    M.load_headless_options()
    return
  end
  M.load_default_options()
end

return M

