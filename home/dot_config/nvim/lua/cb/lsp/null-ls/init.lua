local M = {}

local nls = require 'null-ls'
local nls_utils = require 'null-ls.utils'
local b = nls.builtins

local with_diagnostics_code = function(builtin)
	return builtin.with {
		diagnostics_format = '#{m} [#{c}]'
	}
end

local with_root_file = function(builtin, file)
	return builtin.with {
		condition = function(utils)
			return utils.root_has_file(file)
		end,
	}
end

local with_file = function(builtin, file)
	return builtin.with {
		condition = function(utils)
			return utils.has_file(file)
		end,
	}
end


local sources = {
	-- b.formatting.prettierd,
	-- b.formatting.shfmt,
	-- b.formatting.fixjson,
	b.formatting.black.with { extra_args = { '--fast' } },
	b.formatting.isort,
	with_root_file(b.formatting.stylua, 'stylua.toml'),

	-- diagnostics
	b.diagnostics.write_good,
	b.diagnostics.flake8,
	-- b.diagnostics.tsc,
	with_root_file(b.diagnostics.selene, 'selene.toml'),
	with_diagnostics_code(b.diagnostics.shellcheck),

	-- code actions
	b.code_actions.gitsigns,
	b.code_actions.gitrebase,

	-- hover
	b.hover.dictionary
}


function M.setup(opts)
	nls.setup {
		on_init = function(new_client, _)
			new_client.offset_encoding = 'utf-16'
		end,
		debounce = 150,
		save_after_format = false,
		sources = sources,
		on_attach = opts.on_attach,
		root_dir = nls_utils.root_pattern '.git'
	}
end

return M
