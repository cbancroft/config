local M = {}
local keymap = vim.keymap.set

local function signature_help(client, bufnr)
  local trigger_chars = client.server_capabilities.signatureHelpProvider.triggerCharacters
  for _, char in ipairs(trigger_chars) do
    vim.keymap.set('i', char, function()
      vim.defer_fn(function()
        pcall(vim.lsp.buf.signature_help)
      end, 0)
      return char
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        expr = true,
      })
  end
end
local function keymappings(client, bufnum)
  print 'Registering LSP Keymaps'
  local whichkey = R 'which-key'

  -- Key Mappings
  keymap('n', 'K', vim.lsp.buf.hover, { buffer = bufnum, silent = true, desc = 'LSP Hover' })
  keymap('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnum, silent = true, desc = 'Goto previous diagnostic' })
  keymap('n', ']d', vim.diagnostic.goto_next, { buffer = bufnum, silent = true, desc = 'Goto next diagnostic' })
  keymap('n', '[e', function()
    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  end, { buffer = bufnum, desc = 'Goto previous error' })
  keymap('n', ']e', function()
    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  end, { buffer = bufnum, desc = 'Goto next error' })

  -- Whichkey
  local keymap_l = {
    l = {
      name = 'Code',
      R = { '<cmd>Trouble lsp_references<cr>', 'Trouble references'},
      a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Code Actions" },
      d = { '<cmd>Telescope diagnostics<CR>', "Line Diagnostics" },
      F = { '<cmd>Lspsaga lsp_finder<CR>', 'Finder'},
      r = { '<cmd>lua vim.lsp.buf.rename()<CR>', "Rename field under cursor" },
      i = { '<cmd>LspInfo<CR>', "LSP Info" },
      u = { '<Cmd>Telescope lsp_references<CR>', 'References' },
      o = {
        '<Cmd>Telescope lsp_document_symbols<CR>',
        'Document Symbols',
      },
      q = { '<Cmd>lua vim.diagnostic.setloclist()<CR>', 'Issues to LocList' },
      e = { '<Cmd>lua vim.diagnostic.enable()<CR>', 'Enable Diagnostics' },
      x = { '<Cmd>lua vim.diagnostic.disable()<CR>', 'Disable Diagnostics' },
      s = { '<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'Show Signature' },
      t = { '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Jump to Type Definition Under Cursor' },
      T = { '<cmd>TroubleToggle<cr>', 'Trouble'},
      l = { '<Cmd>LspRestart<CR>', 'Restart the LSP' },
      f = { '<Cmd>lua vim.lsp.buf.format()<CR>', 'Format this buffer' }
    },
  }
  if client.server_capabilities.document_formatting then
    keymap_l.l.f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format File' }
  end
  local keymap_g = {
    name = "Goto",
    d = { '<cmd>lua vim.lsp.buf.definition()<CR>', "Goto Definition" },
    D = { '<cmd>lua vim.lsp.buf.declarations()<CR>', "Goto Declaration" },
    s = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', "Signature Help" },
    I = { '<cmd>lua vim.lsp.buf.implementation()<CR>', "Got Implementation" },
    t = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', "Goto Type Definition" },
  }
  whichkey.register(keymap_l, { buffer = bufnum, prefix = '<leader>' })
  whichkey.register(keymap_g, { buffer = bufnum, prefix = 'g' })
end

function M.setup(client, bufnum)
  keymappings(client, bufnum)
  -- signature_help(client, bufnum)
end

return M
