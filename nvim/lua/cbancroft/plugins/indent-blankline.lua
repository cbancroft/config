-----------------------------------------------------------
-- Indent line configuration file
-----------------------------------------------------------
local M = {}

-- Plugin: indent-blankline
-- https://github.com/lukas-reineke/indent-blankline.nvim
function M.setup()

require('indent_blankline').setup {
  char = '▏',
  show_first_indent_level = false,
  show_trailing_blankline_indent = false,
  filetype_exclude = {
    'help',
    'git',
    'markdown',
    'text',
    'terminal',
    'lspinfo',
    'packer',
  },
  buftype_exclude = {
    'terminal',
    'nofile',
  },
}
end

return M
