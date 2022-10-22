local M = {}

local whichkey = require 'which-key'

local keymap = vim.api.nvim_set_keymap
local buf_keymap = vim.api.nvim_buf_set_keymap

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- Key Mappings
  buf_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>', opts)
  keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>', opts)

  -- whichkey
  local keymap_l = {
    l = {
      name = 'Code',
      a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action' },
      d = { '<cmd>Telescope diagnostics<cr>', 'Diagnostics' },
      F = { '<cmd>Lspsaga lsp_finder<cr>', 'Finder' },
      i = { '<cmd>LspInfo<cr>', 'Lsp Info' },
      n = { '<cmd>Lspsaga rename<cr>', 'Rename' },
      r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
      R = { '<cmd>Trouble lsp_references<cr>', 'Trouble References' },
      t = { '<cmd>TroubleToggle<cr>', 'Rename' },
    },
  }
  if client.server_capabilities.documentFormattingProvider then
    keymap_l.l.f = { '<cmd>lua vim.lsp.buf.format()<cr>', 'Format Document' }
  end

  local keymap_g = {
    name = 'Goto',
    d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Definition' },
    D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Declaration' },
    s = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Signature Help' },
    I = { '<cmd>Telescope lsp_implementations<cr>', 'Goto Implementation' },
    t = { '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Goto Type Definition' },
  }
  whichkey.register(keymap_l, { buffer = bufnr, prefix = '<leader>' })
  whichkey.register(keymap_g, { buffer = bufnr, prefix = 'g' })
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
