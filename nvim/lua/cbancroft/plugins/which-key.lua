local M = {}

local nopts = {
  mode = 'n',
  prefix = '<leader>',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local conf = {
  window = {
    border = 'single', -- none, single, double, or shadow
    position = 'bottom', -- bottom, top
  }
}
local keymaps_f = nil -- File search
local keymaps_p = nil -- Project search

if PLUGINS.telescope.enabled then
  keymaps_f = {
    name = 'Find',
    f = { '<Cmd>lua require"cbancroft.utils.finder".find_files()<CR>', 'Files' },
    d = { '<cmd>lua require"cbancroft.utils.finder".find_dotfiles()<cr>', 'Dotfiles' },
    b = { '<Cmd>Telescope buffers<cr>', 'Search buffers' },
    o = { '<Cmd>Telescope oldfiles<CR>', 'Old Files' },
    g = { '<Cmd>Telescope live_grep<CR>', 'Live Grep' },
    c = { '<Cmd>Telescope commands<CR>', 'Commands' },
    r = { '<Cmd>Telescope file_browser<CR>', 'Pop-up File Browser' },
    w = { '<Cmd>Telescope current_buffer_fuzzy_find<CR>', 'Search current buffer' },
    e = { '<Cmd>NvimTreeToggle<CR>', 'Explorer' },
    h = { '<Cmd>Telescope help_tags<CR>', 'Help' },
    m = { '<Cmd>Telescope marks<CR>', 'Marks' },
    s = { '<Cmd>Telescope symbols<CR>', 'Symbols' },
    a = { '<Cmd>xa<CR>', 'Save all & quit' },
    t = { '<Cmd>Telescope<CR>', 'Telescope' },
    l = { '<Cmd>e!<CR>', 'Reload file' },
  }
  keymaps_p = {
    name = 'Project',
    p = { '<cmd>lua require"telescope".extensions.project.project{}<cr>', 'list' },
    s = { '<cmd>Telescope repo list<cr>', 'Search' },
  }
end
if PLUGINS.fzf_lua.enabled then
  -- File
  keymaps_f = {
    name = 'Find',
    f = { '<Cmd>lua require"cbancroft.utils.finder".find_files()<CR>', 'Files' },
    b = { '<Cmd>FzfLua buffers<cr>', 'Search buffers' },
    c = { '<Cmd>FzfLua commands<CR>', 'Commands' },
    g = { '<Cmd>FzfLua live_grep<CR>', 'Live Grep' },
    o = { '<Cmd>FzfLua oldfiles<CR>', 'Old Files' },
    m = { '<Cmd>Telescope marks<CR>', 'Marks' },
    r = { '<Cmd>Telescope frecency<CR>', 'Recent File' },
    s = { '<Cmd>Telescope symbols<CR>', 'Symbols' },
    a = { '<Cmd>xa<CR>', 'Save all & quit' },
    e = { '<Cmd>NvimTreeToggle<CR>', 'Explorer' },
    t = { '<Cmd>Telescope<CR>', 'Telescope' },
    l = { '<Cmd>e!<CR>', 'Reload file' },
  }
end
local mappings = {
  ['s'] = { '<Cmd>update!<CR>', 'Save' },
  ['q'] = { '<Cmd>q!<CR>', 'Quit' },

  -- System
  ['z'] = {
    name = 'System',
    c = { '<Cmd>Telescope colorscheme<cr>', 'Color Scheme' },
    t = { '<Cmd>ToggleTerm<cr>', 'New Terminal' },
    z = { '<cmd>lua require("cbancroft.telescope.actions").edit_config()<cr>', 'Configuration' },
    r = { '<cmd>luafile %<cr>', 'Reload current lua file' },
    m = { '<cmd>messages<cr>', 'Messages' },
    p = { '<cmd>messages clear<cr>', 'Clear Messages' },
    u = { '<cmd>PackerUpdate<cr>', 'Packer Update' },
    R = { '<cmd>Telescope reloader<cr>', 'Reload Module' },
  },

  -- Buffer
  ['b'] = {
    name = 'Buffer',
    a = { '<Cmd>BWipeout other<cr>', 'Delete all buffers' },
    d = { '<Cmd>bd<cr>', 'Delete current buffer' },
    f = { '<Cmd>bd!<cr>', 'Force delete current buffer' },
    l = { '<Cmd>ls<cr>', 'List Buffers' },
    n = { '<Cmd>bn<cr>', 'Next Buffer' },
    p = { '<Cmd>bp<cr>', 'Previous Buffer' },
  },

  f = keymaps_f,
  p = keymaps_p,

  -- Quick Fix
  c = {
    name = 'Quickfix',
    o = { '<Cmd>copen<cr>', 'Open quickfix' },
    c = { '<Cmd>cclose<cr>', 'Close quickfix' },
    n = { '<Cmd>cnext<cr>', 'Next quickfix' },
    p = { '<Cmd>cprev<cr>', 'Previous quickfix' },
    x = { '<Cmd>cex []<cr>', 'Clear quickfix' },
    t = { '<Cmd>BqfAutoToggle<cr>', 'Toggle Preview' },
    r = { 'Reload Neovim Configuration' },
  },

  -- Git
  g = {
    name = 'Source Code',
    a = { '<Cmd>Telescope repo list<CR>', 'All repositories' },
    s = { '<Cmd>Neogit<CR>', 'NeoGit Status' },
    g = { '<Cmd>DogeGenerate<CR>', 'Generate Doc' },
  },

  -- Work Shortcuts
  w = {
    name = 'Work Projects',
    b = { '<Cmd>lua require("cbancroft.telescope.actions").work_find("arcos/snoopy/wip/cbracketer")<CR>', 'Arcos' },
    n = { '<Cmd>lua require("cbancroft.telescope.actions").work_find("arcos")<CR>', 'Arcos' },
    e = { '<Cmd>lua require("cbancroft.telescope.actions").work_find("arep")<CR>', 'AREP' },
    i = { '<Cmd>lua require("cbancroft.telescope.actions").work_find("fleet")<CR>', 'FLEET' },
  },
}
local lsp_mappings = {
  l = {
    name = 'LSP',
    r = { '<Cmd>Lspsaga rename<CR>', 'Rename' },
    u = { '<Cmd>lua require("cbancroft.plugins.telescope").lsp_references()<CR>', 'References' },
    o = {
      '<Cmd>lua require("cbancroft.plugins.telescope").lsp_document_symbols({ignore_filename = true})<CR>',
      'Document Symbols',
    },
    d = { '<Cmd>lua require("cbancroft.plugins.telescope").lsp_definitions()<CR>', 'Definitions' },
    a = { '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Actions' },
    q = { '<Cmd>lua vim.diagnostic.setloclist()<CR>', 'Issues to LocList' },
    I = { '<Cmd>lua require("cbancroft.lsp.handlers").implementation()<CR>', 'Goto implementation' },
    i = { '<Cmd>lua require("cbancroft.plugins.telescope").lsp_implementations()<CR>', '' },
    e = { '<Cmd>lua vim.diagnostic.enable()<CR>', 'Enable Diagnostics' },
    x = { '<Cmd>lua vim.diagnostic.disable()<CR>', 'Disable Diagnostics' },
    s = { '<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'Show Signature' },
    t = { '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Jump to Type Definition Under Cursor' },
    l = { '<Cmd>LspRestart<CR>', 'Restart the LSP' },
    f = { '<Cmd>lua vim.lsp.buf.format()<CR>', 'Format this buffer' }
  },
}
local lsp_mappings_features = {
  {
    'document_formatting',
    { lf = { '<Cmd>lua vim.lsp.buf.formatting()<CR>', 'Format' } },
  },
  {
    'code_lens',
    { ll = { '<Cmd>lua vim.lsp.codelens.refresh()<CR>', 'Codelens Refresh' } },
  },
  {
    'code_lens',
    { ls = { '<Cmd>lua vim.lsp.codelens.run()<CR>', 'Codelens run' } },
  },
}
function M.register_lsp(client, bufnr, local_mappings)
  local wk = require 'which-key'
  wk.register(lsp_mappings, nopts)

  for _, m in pairs(lsp_mappings_features) do
    local cap, key = unpack(m)
    if client.server_capabilities[cap] then
      wk.register(key, nopts)
    end
  end
  local local_opts = vim.deepcopy(nopts)
  local_opts.buffer = bufnr
  local_opts.prefix = ''

  wk.register(local_mappings, local_opts)
end

function M.setup()
  print 'Registering global mappings'
  local wk = require 'which-key'
  wk.setup {
    window = {
      border = 'single', -- none, single, double, or shadow
      position = 'bottom', -- bottom, top
    }
  }
  wk.register { h = { '<Cmd>WhichKeyFloating<CR>', 'This help' } }
  wk.register { ["C-N"] = { 'Toggle Explorer View' } }
  wk.register(mappings, nopts)
end

return M
