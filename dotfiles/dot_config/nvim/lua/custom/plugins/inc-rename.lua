-- Incremental Rename
return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',
  keys = {
    {
      '<leader>cr',
      function()
        return ':IncRename ' .. vim.fn.expand '<cword>'
      end,
      desc = '[C]ode Incremental [R]ename',
      mode = 'n',
      noremap = true,
      expr = true,
    },
  },
  config = true,
}
