-- File Explorer
return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Nice icons
  },
  opts = {
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
    view = {
      number = true,
      relativenumber = true,
    },
    filters = {
      dotfiles = true,
      custom = {
        'node_modules/.*',
      },
    },
  },
  config = function(_, opts)
    -- Disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require('nvim-tree').setup(opts)

    require('which-key').add {
      { '<leader>e', group = '[E]xplorer', hidden = true },
    }
    vim.keymap.set('n', '<leader>ee', ':NvimTreeToggle<CR>', { desc = '[E]xplorer Toggl[E]' })
    vim.keymap.set('n', '<leader>es', ':NvimTreeFocus<CR>', { desc = '[E]xplorer Focu[S]' })
    vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFile<CR>', { desc = '[E]xplorer [F]ind Current File' })
  end,
}
