local M = {}
local utils = require 'cb.utils'
local autocmds = require 'cb.core.autocmds'

local function add_lsp_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = 'n',
    insert_mode = 'i',
    visual_mode = 'v',
  }

  if cb.builtin.which_key.active then
    -- Remap using whichkey
    local status_ok, wk = pcall(require, 'which-key')
    if not status_ok then
      return
    end

    for mode_name, mode_char in pairs(mappings) do
      wk.register(cb.lsp.buffer_mappings[mode_name], { mode = mode_char, buffer = bufnr })
    end
  else
    -- Use nvim api
    for mode_name, mode_char in pairs(mappings) do
      for key, remap in pairs(cb.lsp.buffer_mappings[mode_name]) do
        vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], {noremap = true, silent = true })
      end
    end
  end
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

function M.common_on_exit(_, _)
  if cb.lsp.document_highlight then
    pcall(vim.api.nvim_del_augroup_by_name, 'lsp_document_highlight')
  end
  if cb.lsp.code_lens_refresh then
    pcall(vim.api.nvim_del_augroup_by_name, 'lsp_code_lens_refresh')
  end
end

function M.common_on_init(client, bufnr)
  if cb.lsp.on_init_callback then
    cb.lsp.on_init_callback(client, bufnr)
  end
end

function M.common_on_attach(client, bufnr)
  if cb.lsp.on_attach_callback then
    cb.lsp.on_attach_callback(client, bufnr)
  end
  local lu = require 'cb.lsp.utils'
  if cb.lsp.document_highlight then
    lu.setup_document_highlight(client, bufnr)
  end
  if cb.lsp.code_lens_refresh then
    lu.setup_codelens_refresh(client, bufnr)
  end
  add_lsp_buffer_keybindings(bufnr)
end

local function bootstrap_nlsp(opts)
  opts = opts or {}
  local lsp_settings_status_ok, lsp_settings = pcall(require, 'nlspsettings')
  if lsp_settings_status_ok then
    lsp_settings.setup(opts)
  end
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

function M.setup()
  local status_ok, _ = pcall(require, 'lspconfig')
  if not status_ok then
    return
  end

  if cb.use_icons then
    for _, sign in ipairs(cb.lsp.diagnostics.signs.values) do
      vim.fn.sign_define(sign.name, {texthl = sign.name, text = sign.text, numhl = sign.name})
    end
  end

  require 'cb.lsp.handlers'.setup()

  if not utils.is_directory(cb.lsp.templates_dir) then
    require 'cb.lsp.templates'.generate_templates()
  end

  bootstrap_nlsp {
    config_home = utils.join_paths(get_config_dir(), 'lsp-settings'),
    append_default_schemas = true,
  }

  require 'nvim-lsp-installer'.setup {
    install_root_dir = utils.join_paths(vim.call('stdpath', 'data'), 'lsp_servers'),
  }

  require 'cb.lsp.null-ls'.setup()
end

return M
