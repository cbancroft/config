-- Git Blame
return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  opts = {
    enabled = false, -- Only enabled by keybind
    date_format = '%m/%d/%y %H:%M:%S',
  },
  config = function(_, opts)
    require('gitblame').setup(opts)
    vim.keymap.set('n', '<leader>gb', ':GitBlameToggle<CR>', { desc = '[G]it [B]lame Toggle' })
  end,
}
