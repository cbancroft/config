local M = {}

local servers = {
	esbonio = {},
	html = {},
	jdtls = {},
	jsonls = {},
	pyright = {},
	clangd = {
		cmd = { 'clangd', '--offset-encoding=utf-16'},

	},
	-- rust_analyzer = {},
	sumneko_lua = {
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJIT',
					path = vim.split(package.path, ';'),
				},
				diagnostics = {
					globals = { 'vim' },
				},
				workspace = {
					library = {
						[vim.fn.expand '$VIMRUNTIME/lua'] = true,
						[vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
					},
				},
			},
		},
	},
	tsserver = {},
	vimls = {},
}

local function on_attach(client, bufnr)
	-- Enable completion triggered by <C-X><C-O>
	-- See `:help omnifunc` and `:help ins-completion` for more info
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Use LSP as the handler for formatexpr
	-- See `:help formatexpr` for more info
	vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

	-- Configure key mappings
	require('cb.lsp.keymaps').setup(client, bufnr)
	
	-- Configure highlighting
	require('cb.lsp.highlighting').setup(client)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.offset_encoding = 'utf-16'

local opts = {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
}

-- Setup LSP Handlers
require('cb.lsp.handlers').setup()

function M.setup()
	-- null-ls
	local status, nullls = pcall(require, 'cb.lsp.null-ls')
	if status then
		nullls.setup(opts)
	else
		print('Error loading null-ls ' .. nullls)
	end
	require('cb.lsp.installer').setup(servers, opts)
end

return M
