---------------------------------------------------------------
-- Neovim Settings
---------------------------------------------------------------

---------------------------------------------------------------
-- API Aliases
---------------------------------------------------------------
local cmd = vim.cmd -- execute Vim commands
local exec = vim.api.nvim_exec -- execute Vimscript
local fn = vim.fn -- call Vm functions
local g = vim.g -- global vars
local opt = vim.opt -- global/buffer/window scoped options

---------------------------------------------------------------
-- General
---------------------------------------------------------------
g.mapleader = "," -- Use comma as leader
opt.mouse = "a" -- Yes to mouse support
opt.clipboard = "unnamedplus" -- copy/paste using system keyboard
opt.swapfile = false -- no swappy!

---------------------------------------------------------------
-- Neovim UI
---------------------------------------------------------------
opt.number = true -- show line numbers
opt.showmatch = true -- highlight matching parens
opt.foldmethod = "marker" -- enable folding (default 'foldmarker')
opt.colorcolumn = "80" -- line length marker at 80 columns
opt.splitright = true -- vertical split to right
opt.splitbelow = true -- horizontal split to bottom
opt.ignorecase = true -- ignore case when searching
opt.linebreak = true -- wrap on word boundary
opt.guifont = "JetBrainsMono NF 11"
opt.wrap = false -- don't wrap on load
opt.cursorline = true -- highlight current line
opt.scrolloff = 1 -- when scrolling, keep cursor 1 lines away from screen border
opt.sidescrolloff = 2 -- Keep 2 columns visible on left/right sides

-- highlight on yank
cmd([[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
    augroup end
]])

cmd([[
    augroup code_stuff
    autocmd!
    autocmd BufWritePre *.lua,*.cpp,*.c,*.h,*.hpp,*.cxx,*.cc Neoformat
    autocmd BufWritePre * :%s/\s\+$//e
    augroup END
 ]])

---------------------------------------------------------------
-- Memory/CPU
---------------------------------------------------------------
opt.hidden = true -- enable background buffers
opt.history = 100 -- remember n lines in history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240 -- max column count for syntax highlight

---------------------------------------------------------------
-- Colorscheme
---------------------------------------------------------------
opt.termguicolors = true -- enable 24-bit RGB

--to Show whitespace, MUST be inserted BEFORE the colorscheme command
cmd("autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=grey")

---------------------------------------------------------------
-- Tabs, indent
---------------------------------------------------------------
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 4 -- shift 4 spaces when tabbing
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- autoindent new lines
opt.autoindent = true

-- no autocommenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])

-- remove line length marker for certain files
cmd([[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]])

-- 2 space tabs for selected filetypes
cmd([[
    autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]])

-- json
cmd([[ au BufEnter *.json set ai expandtab shiftwidth=2 tabstop=2 sta fo=croql ]])

---------------------------------------------------------------
-- Autocomplete
---------------------------------------------------------------
-- insert mode completion options
opt.completeopt = "menuone,noselect"

---------------------------------------------------------------
-- Terminal
---------------------------------------------------------------
-- open a terminal pane on the right using :Term
cmd([[command Term :botright vsplit term://$SHELL]])

-- Terminal visual tweaks
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
cmd([[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]])

---------------------------------------------------------------
-- Startup
---------------------------------------------------------------
-- disable builtin plugins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- disable nvim intro
opt.shortmess:append("sI")

-- Jump to the last position when reopening file
cmd([[
  if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  endif
]])
