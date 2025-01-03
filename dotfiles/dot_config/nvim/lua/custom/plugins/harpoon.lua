-- Project/File marks
function key(key, fn, desc)
  vim.keymap.set('n', '<leader>h' .. key, fn, { desc = desc })
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    menu = {
      width = 120,
    },
  },
  config = function(_, opts)
    local harpoon = require 'harpoon'
    harpoon:setup(opts)
    require('which-key').add {
      { '<leader>h', group = '[H]arpoon' },
    }
    key('a', function()
      harpoon:list():append()
    end, '[H]arpoon [A]ppend')

    key('h', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, '[H]arpoon s[H]ow UI')

    key('n', function()
      harpoon:list():select(1)
    end, '[H]arpoon Select 1')

    key('e', function()
      harpoon:list():select(2)
    end, '[H]arpoon Select 2')

    key('i', function()
      harpoon:list():select(3)
    end, '[H]arpoon Select 3')

    key('o', function()
      harpoon:list():select(4)
    end, '[H]arpoon Select 4')

    key('t', function()
      harpoon:list():next()
    end, '[H]arpoon Nex[T]')

    key('s', function()
      harpoon:list():prev()
    end, '[H]arpoon La[S]t')
  end,
}
