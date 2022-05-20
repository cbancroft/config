local M = {}

local in_headless = #vim.api.nvim_list_uis() == 0

function M.run_pre_update()
  print 'Starting pre-update hook'
end

function M.run_pre_reload()
  print 'Starting post-update hook'
end

function M.run_on_packer_complete()
  vim.api.nvim_exec_autocmds('User', {pattern = 'PackerComplete'})

  vim.g.color_name = cb.colorscheme
  pcall(vim.cmd, 'colorscheme ' .. cb.colorscheme)

  if M._reload_triggered then
    M._reload_triggered = nil
  end
end

function M.run_post_reload()
  M.reset_cache()
  M._reload_triggered = true
end

function M.reset_cache()
  local impatient = _G.__luacache
  if impatient then
    impatient.clear_cache()
  end

  local cb_modules = {}
  for module, _ in pairs(package.loaded) do
    if module:match 'cb.core' or module:match 'cb.lsp' then
      package.loaded[module] = nil
      table.insert(cb_modules, module)
    end
  end
  require('cb.lsp.templates').generate_templates()
end

function M.run_post_update()

  M.reset_cache()

  require('cb.plugin-loader').sync_core_plugins()

  if not in_headless then
    vim.schedule(function()
      if package.loaded['nvim-treesitter'] then
        vim.cmd [[ TSUpdateSync ]]
      end
      vim.notify('Update complete', vim.log.levels.INFO)
    end)
  end
end

return M
