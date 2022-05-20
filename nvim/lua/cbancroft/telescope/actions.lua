local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end
local actions = require("telescope.actions")
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"


local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == 'table' then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local M = {}

function M.edit_config()
  local opts_with_preview, opts_without_preview

  opts_with_preview = {
    prompt_title = "<Dot Files>",
    shorten_path = false,
    cwd = "~/git/config",
    layout_strategy = "flex",

    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },

    attach_mappings = function(_, map)
      map('i', '<c-y>', set_prompt_to_entry_value)
      map('i', '<M-c>', function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          require('telescope.builtin').find_files(opts_without_preview)
        end)
      end)

      return true
    end,
  }

  opts_without_preview = vim.deepcopy(opts_with_preview)
  opts_without_preview.previewer = false

  require("telescope.builtin").find_files(opts_with_preview)
end

function M.fd()
  local opts = themes.get_ivy({hidden = false})
  require("telescope.builtin").fd(opts)
end

function M.work_find(project)
  require("telescope.builtin").find_files {
    prompt_title = "< " .. project .. " >",
    shorten_path = false,
    cwd = "~/work/" .. project,
    sorter = require("telescope").extensions.fzf.native_fzf_sorter(),
    theme = "ivy"
  }
end

return setmetatable({}, {
  __index = function (_, k)
    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end
})

