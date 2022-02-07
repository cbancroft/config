---------------------------------------------------------
-- Import Lua Stuff
---------------------------------------------------------
MAP = vim.api.nvim_set_keymap
MAP_DEFAULTS = { noremap = true, silent = true }
CMD = vim.cmd
NOP = '<nop>'
R = function(name)
  package.loaded[name] = nil
  local status, pkg = pcall(require, name)
  if not status then
    return nil
  end
  return require(name)
end

function mapn(...)
  MAP('n', ...)
end
function mapnl(binding, ...)
  MAP('n', '<leader>' .. binding, ...)
end

R 'cbancroft.settings'
R 'cbancroft.plugins'
R 'cbancroft.keymaps'
R 'cbancroft.lsp'

-- CMD [[colorscheme tokyonight]]
CMD [[colorscheme kanagawa]]
