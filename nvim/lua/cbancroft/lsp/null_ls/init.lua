local M = {}

local nls = R 'null-ls'
local nls_utils = R 'null-ls.utils'
local b = nls.builtins
local function with_diagnostics_code(builtin)
  return builtin.with {
    diagnostics_format = "#{m} [#{c}]"
  }
end

local function with_root_file(builtin, file)
  return builtin.with {
    condition = function(utils)
      return utils.root_has_file(file)
    end
  }
end

local sources = {
  -- Formatting
  b.formatting.prettierd,
  b.formatting.shfmt,
  b.formatting.fixjson,
  b.formatting.black.with { extra_args = { "--fast" } },
  b.formatting.isort,
  with_root_file(b.formatting.stylua, "stylua.toml"),

  -- Diagnostics
  b.diagnostics.write_good,
  b.diagnostics.flake8,
  b.diagnostics.tsc,
  with_root_file(b.diagnostics.selene, "selene.toml"),
  with_diagnostics_code(b.diagnostics.shellcheck),

  -- Code Actions
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,

  -- Hover
  -- b.hover.dictionary,
}

function M.setup(opts)
  nls.setup {
    debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = opts.on_attach,
    root_dir = nls_utils.root_pattern ".git",
  }
end

return M
