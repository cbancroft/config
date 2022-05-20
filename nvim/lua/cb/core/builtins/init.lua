local M = {}

local builtins = {
  'cb.core.which-key',
  'cb.core.gitsigns',
  'cb.core.cmp',
  'cb.core.dap',
  'cb.core.terminal',
  'cb.core.telescope',
  'cb.core.treesitter',
  'cb.core.nvimtree',
  'cb.core.project',
  'cb.core.bufferline',
  'cb.core.autopairs',
  'cb.core.comment',
  'cb.core.notify',
  'cb.core.lualine',
  'cb.core.alpha',
}

function M.config(config)
  for _, builtin_path in ipairs(builtins) do
    print('Loading builtin ' .. builtin_path)
    local builtin = require(builtin_path)
    builtin.config(config)
  end
end

return M
