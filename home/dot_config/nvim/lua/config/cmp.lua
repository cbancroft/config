local M = {}

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

function M.setup()
	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
	end

	local luasnip = require 'luasnip'
	local cmp = require 'cmp'

	cmp.setup {
		completion = { completeopt = 'menu,menuone,noinsert', keyword_length = 1 },
		experimental = { native_menu = false, ghost_text = false },
		snippet = {
			expand = function(args)
				require('luasnip').lsp_expand(args.body)
			end
		},
		formatting = {
			format = function(entry, vim_item)
				-- Kind icons
				vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
				vim_item.menu = ({
					nvim_lsp = '[LSP]',
					buffer = "[Buffer]",
					luasnip = "[Snip]",
					nvim_lua = '[Lua]',
					treesitter = '[Treesitter]',
					path = '[Path]',
					nvim_lsp_signature_help = '[Signature]',
				})[entry.source.name]
				return vim_item
			end,
		},
		mapping = {
			['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
			['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
			['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
			['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
			['<C-e>'] = cmp.mapping { i = cmp.mapping.close(), c = cmp.mapping.close() },
			['<C-j>'] = cmp.mapping(function(fallback)
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, {'i', 's', 'c'}),
			['<C-k>'] = cmp.mapping(function(fallback)
				if luasnip.expand_or_jumpable(-1) then
					luasnip.expand_or_jump(-1)
				else
					fallback()
				end
			end, {'i', 's', 'c'}),
			['<C-y>'] = cmp.mapping {
				i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
				c = function(fallback)
					if cmp.visible() then
						cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
					else
						fallback()
					end
				end
			},
		},

		sources = {
			{ name = 'nvim_lsp_signature_help' },
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
			{ name = 'nvim_lua' },
			-- { name = 'treesitter' },
			{ name = 'path' },
			{ name = 'buffer' },
		},

		window = {
			documentation = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
			},
		}
	}

	-- Use buffer source for '/'
	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' },
		},
	})

	-- Use cmdline and path sources for ':'
	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
			{name = 'path'},
			}, {
				{ name = 'cmdline' },
		}),
	})

	local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
	cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } } )
end

return M
