local config = require 'cbancroft.config'
local icons = require 'cbancroft.theme.plugins'
local u = require 'cbancroft.utils'

require 'notify'.setup(u.merge({
  icons = {
    ERROR = icons.error,
    WARN = icons.warn,
    INFO = icons.info,
    DEBUG = icons.debug,
    TRACE = icons.trace,
  },
  stages = 'slide',
  background_colour = require 'cbancroft.theme.colors'.bg,
}, config.notify or {}))

vim.notify = require 'notify'
require 'cbancroft.plugins.notify.highlights'
