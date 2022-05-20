local M = {}

-- Color table for highlights
local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

local function separator()
  return '%='
end

local function lsp_client(msg)
  msg = msg or ""
  local buf_clients = vim.lsp.buf_get_clients()
  if next(buf_clients) == nil then
    if type(msg) == 'boolean' or #msg == 0 then
      return ""
    end
    return msg
  end

  local buf_ft = vim.bo.filetype
  local buf_client_names = {}

  -- Add client
  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' then
      table.insert(buf_client_names, client.name)
    end
  end

  -- Add formatter
  local formatters = require 'cbancroft.lsp.null-ls.formatters'
  local supported_formatters = formatters.list_registered(buf_ft)
  vim.list_extend(buf_client_names, supported_formatters)

  -- Add linter
  local linters = require("cbancroft.lsp.null-ls.linters")
  local supported_linters = linters.list_registered(buf_ft)
  vim.list_extend(buf_client_names, supported_linters)

  -- Add hover
  local hovers = require('null-ls.hovers')
  local supported_hovers = hovers.list_registered(buf_ft)
  vim.list_extend(buf_client_names, supported_hovers)

  return '[' .. table.concat(buf_client_names, ', ') .. ']'
end

-- Using fidget.nvim instead
-- local function lsp_progress(_, is_active)
--   if not is_active then
--     return
--   end
--   local messages = vim.lsp.util.get_progress_messages()
--   if #messages == 0 then
--     return ""
--   end
--   local status = {}
--   for _, msg in pairs(messages) do
--     local title = ''
--     if msg.title then
--       title = msg.title
--     end
--     table.insert(status, (msg.percentage or 0) .. '%% ' .. title)
--   end
--   local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
--   local ms = vim.loop.hrtime() / 1000000
--   local frame = math.floor(ms / 120) % #spinners
--   return table.concat(status, "  ") .. ' ' .. spinners[frame + 1]
-- end

function M.setup()
  local gps = require 'nvim-gps'

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local diagnostics = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    sections = { 'error', 'warn' },
    symbols = { error = ' ', warn = ' ' },
    colored = false,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
    'diff',
    colored = false,
    symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
    cond = hide_in_width,
  }

  local mode = {
    'mode',
    fmt = function(str)
      return '-- ' .. str .. ' --'
    end,
  }

  local filetype = {
    'filetype',
    icons_enabled = false,
    icon = nil,
  }

  local branch = {
    'branch',
    icons_enabled = true,
    icon = '',
  }

  local location = {
    'location',
    padding = 0,
  }

  -- cool function for progress
  local progress = function()
    local current_line = vim.fn.line '.'
    local total_lines = vim.fn.line '$'
    local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end

  local spaces = function()
    return 'spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth')
  end

  require 'lualine'.setup {
    options = {
      icons_enabled = true,
      theme = 'auto', -- nord
      component_separators = { left = '', right = '' },
      section_separators = { left = ' ', right = '' },
      -- disabled_filetypes = { 'dashboard', 'NvimTree', 'Outline', 'alpha' },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = {
        'branch',
        'diff',
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
          colored = false,
        },
      },
      lualine_c = {
        { separator },
        { lsp_client, icon = " ", color = { fg = colors.violet, gui = 'bold' } },
        -- { lsp_progress }
        {
          gps.get_location,
          cond = gps.is_available,
          color = { fg = colors.green },
        },
      },
      -- lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = { 'filename', 'encoding', "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  }
end

return M
