-- Set completeopt to have a better completion experience
local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end
local snip_status_ok, luasnip = pcall(require, 'luasnip')
if not snip_status_ok then
  return
end

local v = vim
local WIDE_HEIGHT = 100
local kind_icons = {
  Text = '',
  Method = 'm',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}
cmp.setup {
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-t>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),
    ['(<C-space>'] = cmp.mapping {
      i = cmp.mapping.complete(),
      c = function(_)
        if cmp.visible() then
          if not cmp.confirm { select = true } then
            return
          end
        else
          cmp.complete()
        end
      end,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own.
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find '^_+'
        local _, entry2_under = entry2.completion_item.label:find '^_+'
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  completion = {
    completeopt = 'menu,menuone,preview,noinsert',
    --completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  documentation = {
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    winhighlight = 'NormalFloat:NormalFloat,FloatBorder:NormalFloat',
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, item)
      -- Icons
      item.kind = string.format('%s', kind_icons[item.kind])
      item.menu = ({
        nvim_lsp = '[LSP]',
        nvim_lua = '[NVIM_LUA]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return item
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5, max_item_count = 5 },
    { name = 'calc' },
    { name = 'emoji' },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = False,
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

cmp.setup.cmdline(':', {
  completion = {
    autocomplete = false,
  },
  sources = cmp.config.sources({
    {
      name = 'path',
    },
  }, {
    {
      name = 'cmdline',
      --max_item_count = 20,
      keyword_length = 4,
    },
  }),
})

vim.cmd [[
  augroup CmpZsh
    au!
    autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
  augroup END
]]
