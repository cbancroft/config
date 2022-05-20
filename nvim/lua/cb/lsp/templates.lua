local M = {}

local utils = require 'cb.utils'
local lsp_utils = require 'cb.lsp.utils'

local ftplugin_dir = cb.lsp.templates_dir

local join_paths = utils.join_paths

function M.remove_template_files()
  for _, file in ipairs(vim.fn.glob(ftplugin_dir .. '/*.lua', 1, 1)) do
    vim.fn.delete(file)
  end
end

local skipped_filetypes = cb.lsp.automatic_configuration.skipped_filetypes
local skipped_servers = cb.lsp.automatic_configuration.skipped_servers

function M.generate_ftplugin(server_name, dir)
  if vim.tbl_contains(skipped_servers, server_name) then
    return
  end

  -- Get the supported filetypes and remove any ignored
  local filetypes = vim.tbl_filter(function(ft)
    return not vim.tbl_contains(skipped_filetypes, ft)
  end, lsp_utils.get_supported_filetypes(server_name) or {})

  if not filetypes then
    return
  end

  for _, filetype in ipairs(filetypes) do
    local filename = join_paths(dir, filetype .. '.lua')
    local setup_cmd = string.format([[require('cb.lsp.manager').setup(%q)]], server_name)
    utils.write_file(filename, setup_cmd .. '\n', 'a')
  end
end

-- Generate ftplugin files based on list of server names
-- Generated in the runtimepath/site/after/ftplugin/template.lua
function M.generate_templates(server_names)
  server_names = server_names or {}

  M.remove_template_files()

  if vim.tbl_isempty(server_names) then
    local available_servers = require'nvim-lsp-installer.servers'.get_available_servers()

    for _, server in pairs(available_servers) do
      table.insert(server_names, server.name)
    end
    table.sort(server_names)
  end

  if not utils.is_directory(cb.lsp.templates_dir) then
    vim.fn.mkdir(ftplugin_dir, 'p')
  end

  for _, server in ipairs(server_names) do
    M.generate_ftplugin(server, ftplugin_dir)
  end

end

return M
