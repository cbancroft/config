-- Refactoring Tool
return {
  'ThePrimeagen/refactoring.nvim',
  keys = {
    {
      '<leader>cf',
      function()
        require('refactoring').select_refactor {
          show_success_message = true,
        }
      end,
      mode = 'v',
      noremap = true,
      silent = true,
      expr = false,
      desc = '[C]ode Re[F]actor',
    },
  },
}
