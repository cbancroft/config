---------------------------------------------------------
-- Import Lua Stuff
---------------------------------------------------------
MAP = vim.api.nvim_set_keymap
MAP_DEFAULTS = { noremap = true, silent = true }
CMD = vim.cmd
NOP = '<nop>'
R = function(name)
  package.loaded[name] = nil
  return require(name)
end

function mapn(...)
  MAP('n', ...)
end
function mapnl(binding, ...)
  MAP('n', '<leader>' .. binding, ...)
end

R 'settings'
R 'plugins'
R 'keymaps'

-- CMD [[colorscheme tokyonight]]
CMD [[colorscheme kanagawa]]
