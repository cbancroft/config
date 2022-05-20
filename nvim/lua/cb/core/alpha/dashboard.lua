local M = {}

function M.get_sections()
  local header = {
    type = "text",
    val = {
    '                                                    ',
    ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
    ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
    ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
    ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
    ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
    ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
    '                                                    ',
    },
    opts = {
      position = "center",
      hl = "Label",
    },
  }

  local text = require "cb.interface.text"
  local git_utils = require "cb.utils.git"

  local current_branch = 'HEAD'

  local cb_version = 'custom'

  local footer = {
    type = "text",
    val = text.align_center({ width = 0 }, {
      "",
      "lunarvim.org",
      cb_version,
    }, 0.5),
    opts = {
      position = "center",
      hl = "Number",
    },
  }

  local buttons = {
    entries = {
      { ", f", "  Find File", "<CMD>Telescope find_files<CR>" },
      { ", n", "  New File", "<CMD>ene!<CR>" },
      { ", P", "  Recent Projects ", "<CMD>Telescope projects<CR>" },
      { ", s r", "  Recently Used Files", "<CMD>Telescope oldfiles<CR>" },
      { ", s t", "  Find Word", "<CMD>Telescope live_grep<CR>" },
      {
        ", L c",
        "  Configuration",
        "<CMD>edit " .. require("cb.config").get_config_file() .. " <CR>",
      },
    },
  }

  return {
    header = header,
    buttons = buttons,
    footer = footer,
  }
end

return M

