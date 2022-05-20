-- Set completeopt to have a better completion experience
local M = {}
local icons = require 'cbancroft.theme.icons'
vim.o.completeopt = 'menu,menuone,noselect'

function M.setup()
  local luasnip = R 'luasnip'
  local cmp = R 'cmp'
  local lspkind = R 'lspkind'

  print 'Initializing cmp'
  cmp.setup {
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-t>'] = cmp.mapping.scroll_docs(4),
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
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { 'i', 'c' }
      ),
      ['<Tab>'] = cmp.config.disable,
      ['<C-q>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
      },
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
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    completion = {
      completeopt = 'menu,menuone,preview,noinsert',
      keyword_length = 1,
      --completeopt = 'menu,menuone,noinsert',
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    formatting = {
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format('%s %s', icons.kind_icons[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          nvim_lsp = '[lsp]',
          luasnip = '[snip]',
          buffer = '[buf]',
          path = '[path]',
          nvim_lua = '[nvim_api]',
        })[entry.source.name]
        return vim_item

      end
    },
    sources = {
      { name = 'nvim_lsp' },
      -- { name = 'treesitter' },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'buffer', keyword_length = 5, max_item_count = 5 },
      { name = 'nvim_lsp_signature_help' },
      -- { name = 'calc' },
      -- { name = 'emoji' },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
  }

  -- cmp.setup.cmdline(':', {
  --   completion = {
  --     autocomplete = false,
  --   },
  --   sources = cmp.config.sources({
  --     {
  --       name = 'path',
  --     },
  --   }, {
  --     {
  --       name = 'cmdline',
  --       --max_item_count = 20,
  --       keyword_length = 4,
  --     },
  --   }),
  -- })

  vim.cmd [[
  augroup CmpZsh
  au!
  autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
  augroup END
  ]]
  local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
end

return M
