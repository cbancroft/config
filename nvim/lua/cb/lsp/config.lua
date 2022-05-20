local skipped_servers = {
  "angularls",
  "ansiblels",
  "ccls",
  "csharp_ls",
  "cssmodules_ls",
  "denols",
  "ember",
  "emmet_ls",
  "eslint",
  "eslintls",
  "golangci_lint_ls",
  "graphql",
  "jedi_language_server",
  "ltex",
  "ocamlls",
  "phpactor",
  "psalm",
  "pylsp",
  "quick_lint_js",
  "rome",
  "reason_ls",
  "scry",
  "solang",
  "solidity_ls",
  "sorbet",
  "sourcekit",
  "sourcery",
  "spectral",
  "sqlls",
  "sqls",
  "stylelint_lsp",
  "tailwindcss",
  "tflint",
  "verible",
  "vuels",
}

local skipped_filetypes = {'markdown', 'rst', 'plaintext'}

return {
  templates_dir = join_paths(get_runtime_dir(), 'site', 'after', 'ftplugin'),
  diagnostics = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format('%s [%s]', t.message, code):gsub('1. ', '')
        end
        return t.message
      end,
    },
  },
  document_highlight = true,
  code_lens_refresh = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
  },
  peek = {
    max_height = 15,
    max_width = 30,
    context = 10
  },
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_servers_installation = true,
  automatic_configuration = {
    skipped_servers = skipped_servers,
    skipped_filetypes = skipped_filetypes,
  },
  buffer_mappings = {
    normal_mode = {
      ['K'] = { vim.lsp.buf.hover, 'Show Hover'},
      ['gd'] = { vim.lsp.buf.definition, 'Goto definition'},
      ['gD'] = { vim.lsp.buf.declaration, 'Goto Declaration'},
      ['gr'] = { vim.lsp.buf.references, 'Goto References'},
      ['gI'] = { vim.lsp.buf.implementation, 'Goto Implementation'},
      ['gs'] = { vim.lsp.buf.signature_help, 'Show Signature Help'},
      ['gp'] = {
        function()
          require('cb.lsp.peek').Peek 'definition'
        end,
        'Peek Definiton'
      },
      ['gl'] = {
        function()
          local config = cb.lsp.diagnostics.float
          config.scope = 'line'
          vim.diagnostic.open_float(0, config)
        end,
        'Show Signature Help'
      },
    },
    insert_mode = {},
    visual_mode = {}
  },
  null_ls = {
    setup = {},
    config = {},
  }
}
