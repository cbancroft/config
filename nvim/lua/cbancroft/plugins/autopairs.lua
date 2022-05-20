
local M = {}
function M.setup()
  local npairs = require 'nvim-autopairs'
  npairs.setup {
    check_ts = true,
    ts_config = {
      lua = { 'string', 'source' },
    },
    disable_filetype = { 'TelescopePrompt' },
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      offset = 0, -- Offset from pattern match
      end_key = '$',
      keys = 'qwfpbarstgzxcdv',
      check_comma = true,
      highlight = 'PmenuSel',
      highlight_grey = 'LineNr',
    },
  }
  npairs.add_rules(require 'nvim-autopairs.rules.endwise-lua')

end

return M
