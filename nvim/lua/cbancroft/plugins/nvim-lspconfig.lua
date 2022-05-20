-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Plugin: nvim-lspconfig
-- for language server setup see: https://github.com/neovim/nvim-lspconfig

local nvim_lsp = require 'lspconfig'

local telescope = require 'cbancroft.plugins.telescope'
local tele_map = telescope.map_tele

local handlers = require 'cbancroft.plugins.lsp-handlers'
-- Options for LSP diagnostic

-- -- uncomment below to enable nerd-font based icons for diagnostics in the
-- -- gutter, see:
-- -- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
local signs = { Error = ' ', Warning = ' ', Hint = ' ', Information = ' ' }
--
for type, icon in pairs(signs) do
  local hl = 'LspDiagnosticsSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
  '   (Text) ',
  '   (Method)',
  '   (Function)',
  '   (Constructor)',
  ' ﴲ  (Field)',
  '[] (Variable)',
  '   (Class)',
  ' ﰮ  (Interface)',
  '   (Module)',
  ' 襁 (Property)',
  '   (Unit)',
  '   (Value)',
  ' 練 (Enum)',
  '   (Keyword)',
  '   (Snippet)',
  '   (Color)',
  '   (File)',
  '   (Reference)',
  '   (Folder)',
  '   (EnumMember)',
  ' ﲀ  (Constant)',
  ' ﳤ  (Struct)',
  '   (Event)',
  '   (Operator)',
  '   (TypeParameter)',
}

-- use LSP diagnostic symbols/signs
vim.api.nvim_command [[ sign define LspDiagnosticsSignError         text=✗ texthl=LspDiagnosticsSignError       linehl= numhl= ]]
vim.api.nvim_command [[ sign define LspDiagnosticsSignWarning       text=⚠ texthl=LspDiagnosticsSignWarning     linehl= numhl= ]]
vim.api.nvim_command [[ sign define LspDiagnosticsSignInformation   text= texthl=LspDiagnosticsSignInformation linehl= numhl= ]]
vim.api.nvim_command [[ sign define LspDiagnosticsSignHint          text= texthl=LspDiagnosticsSignHint        linehl= numhl= ]]

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}
-- Snooty LSP
local configs = require 'lspconfig.configs'

if not configs.snooty then
  configs.snooty = {
    default_config = {
      cmd = { vim.fn.expand '~/.local/bin/snooty', 'language-server' },
      filetypes = { 'rst' },
      root_dir = function(fname)
        return nvim_lsp.util.root_pattern('conf.py', '.git')(fname)
      end,
      settings = {},
    },
  }
end

if not configs.rst then
  configs.rst = {
    default_config = {
      cmd = { 'rst-lsp-serve', '--log-file', vim.fn.expand '~/.cache/nvim/rst-lsp.log', '-v' },
      filetypes = { 'rst' },
      root_dir = function(fname)
        return nvim_lsp.util.root_pattern('conf.py', '.git')(fname)
      end,
      flags = {
        allow_incremental_sync = true,
      },
      on_init = function(client)
        print(vim.inspect(client.config.settings))
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
      end,
      --[[
      on_new_config = function(new_config, new_root)
        if not new_config.settings then
          new_config.settings = {}
        end
        if not new_config.settings.rst_lsp then
          new_config.settings.rst_lsp = {}
        end
        new_config.flags.allow_incremental_sync = true

        new_config.settings.rst_lsp.conf_path = new_root .. '/conf.py'
      end,
      --]]

      settings = {},
    },
  }
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local my_on_attach = function(client, bufnr)
  print 'Attaching!'
  local ftype = vim.api.nvim_buf_get_option(0, 'filetype')

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  local opts = { noremap = true, silent = true }
  local buf_inoremap = function(keys)
    vim.api.nvim_buf_set_keymap(0, 'i', keys[1], keys[2], opts)
  end

  local buf_nnoremap = function(keys)
    vim.api.nvim_buf_set_keymap(0, 'n', keys[1], keys[2], { noremap = true, silent = true })
  end

  -- Mappings.

  buf_inoremap { '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>' }
  buf_nnoremap { '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>' }
  tele_map('<leader>la', 'lsp_code_actions', nil, true)

  buf_nnoremap { 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>' }
  buf_nnoremap { 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>' }
  buf_nnoremap { 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>' }

  buf_nnoremap { '<leader>lI', '<cmd>lua require"plugins.lsp-handlers".implementation()<cr>' }
  buf_nnoremap { '<leader>ll', '<cmd>LspRestart<cr>' }

  tele_map('<leader>gr', 'lsp_references', nil, true)
  tele_map('<leader>gI', 'lsp_implementations', nil, true)
  tele_map('<leader>ld', 'lsp_document_symbols', { ignore_filename = true }, true)
  tele_map('<leader>lw', 'lsp_dynamic_workspace_symbols', { ignore_filename = true }, true)

  buf_nnoremap { '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>' }
  buf_nnoremap { ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>' }
  buf_nnoremap { '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>' }

  if filetype ~= 'lua' then
    buf_nnoremap { 'K', '<cmd>lua vim.lsp.buf.hover()<cr>' }
  end

  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  if client.server_capabilities.document_highlight then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end

  --[[
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  ]]
end

nvim_lsp.rst.setup {
  on_attach = my_on_attach,
  capabilities = capabilities,
}

return {
  on_attach = my_on_attach,
  capabilities = capabilities,
}
