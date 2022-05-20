return {
  leader = ',',
  colorscheme = 'onedarker',
  format_on_save = {
    -- @usage pattern string pattern used for the autocommand
    pattern = '*',
    timeout = 1000,
    filter = require('cb.lsp.handlers').format_filter
  },
  keys = {},
  lsp = {},
  use_icons = true,
  builtin = { },
  plugins = {},
  autocommands = {},
  lang = {},



}
