local telescope = R 'cbancroft.plugins.telescope'
local tele_map = telescope.map_tele
local M = {}

function install_additional_lsps()
  if not configs.rst then
    default_config = {
      cmd = { 'rst-lsp-serve', '--log-file', vim.fn.expand '~/.cache/nvim/rst-lsp.log' },
      filetypes = { 'rst' },
      root_dir = function(fname)
        return nvim_lsp.util.root_pattern('conf.py', '.git')(fname)
      end,
      flags = {
        allow_incremental_sync = true,
      },
      on_init = function(client)
        if not client.config.flags then
          client.config.flags = {}
        end
        if not client.config.settings then
          client.config.settings = {}
        end
        if not client.config.settings.rst_lsp then
          client.config.settings.rst_lsp = {}
        end
        client.config.flags.allow_incremental_sync = true

        client.config.settings.rst_lsp.conf_path = client.config.root_dir .. '/conf.py'
      end
      settings = {},
    },
  },
  end
end
M.setup = function()
  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  local config = {
    -- Enable Virtual Text
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })
  install_additional_lsps()
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded"})<CR>', opts)

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>cf', '<cmd>Neoformat', opts)
  vim.keymap.set('n', '<leader>f', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>lI', R('cbancroft.lsp.handlers').implementation, opts)
  vim.keymap.set('n', '<leader>ll', '<cmd>LspRestart<CR>', opts)

  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

  tele_map('<leader>la', 'lsp_code_actions', nil, true)
  tele_map('<leader>gr', 'lsp_references', nil, true)
  tele_map('<leader>gI', 'lsp_implementations', nil, true)
  tele_map('<leader>ld', 'lsp_document_symbols', { ignore_filename = true }, true)
  tele_map('<leader>lw', 'lsp_dynamic_workspace_symbols', { ignore_filename = true }, true)

  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

M.implementation = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, 'textDocument/implementation', params, function(err, result, ctx, config)
    local bufnr = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    vim.lsp.handlers['textDocument/implementation'](err, result, ctx, config)
    vim.cmd [[normal! zz]]
  end)
end

M.on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local capabilties = vim.lsp.protocol.make_client_capabilities()

cmp_nvim_lsp = R 'cmp_nvim_lsp'

if not cmp_nvim_lsp then
  return M
end

M.capabilties = cmp_nvim_lsp.update_capabilities(capabilities)

return M
