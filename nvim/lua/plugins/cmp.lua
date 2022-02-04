-- Set completeopt to have a better completion experience
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
local v = vim
local WIDE_HEIGHT = 100

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append 'c'

cmp.setup {
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-t>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),
    ['(<C-space>'] = cmp.mapping {
      i = cmp.mapping.complete(),
      c = function(
        _ --[[fallback]]
      )
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
    maxwidth = math.floor(WIDE_HEIGHT * (v.o.columns / 100)),
    maxheight = math.floor(WIDE_HEIGHT * (v.o.lines / 100)),
  },
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      max_width = 50,
    },
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
