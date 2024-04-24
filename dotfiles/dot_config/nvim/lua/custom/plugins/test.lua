-- Unit testing
return {
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>bTc', '<cmd>TestClass<cr>', desc = '[D]ebug [T]est [C]lass' },
      { '<leader>bTf', '<cmd>TestFile<cr>', desc = '[D]ebug [T]est [F]ile' },
      { '<leader>bTl', '<cmd>TestLast<cr>', desc = '[D]ebug [T]est [L]ast' },
      { '<leader>bTn', '<cmd>TestNearest<cr>', desc = '[D]ebug [T]est [N]earest' },
      { '<leader>bTs', '<cmd>TestSuite<cr>', desc = '[D]ebug [T]est [S]uite' },
      { '<leader>bTv', '<cmd>TestVisit<cr>', desc = '[D]ebug [T]est [V]isit' },
    },
    config = function()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#neovim#term_position'] = 'belowright'
      vim.g['test#neovim#preserve_screen'] = 1
      vim.g['test#python#runner'] = 'pytest'
    end,
  },
  {
    'nvim-neotest/neotest',
    keys = {
      { '<leader>btF', ':lua require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"})<cr>', desc = 'De[B]ug [t]est [F]ile' },
      { '<leader>btL', ':lua require("neotest").run.run_last({strategy = "dap"})<cr>', desc = 'De[B]ug [t]est [L]ast' },
      { '<leader>bta', ':lua require("neotest").run.attach()<cr>', desc = 'De[B]ug [t]est [A]ttach' },
      { '<leader>btf', ':lua require("neotest").run.run({vim.fn.expand("%")})<cr>', desc = 'De[B]ug [t]est [F]ile (nodebug)' },
      { '<leader>btl', ':lua require("neotest").run.run_last()<cr>', desc = 'De[B]ug [t]est [L]ast (nodebug)' },
      { '<leader>btn', ':lua require("neotest").run.run()<cr>', desc = 'De[B]ug [t]est [N]earest (nodebug)' },
      { '<leader>btN', ':lua require("neotest").run.run({strategy = "dap"})<cr>', desc = 'De[B]ug [t]est [N]earest' },
      { '<leader>bto', ':lua require("neotest").output.open({ enter = true })<cr>', desc = 'De[B]ug [t]est [O]utput' },
      { '<leader>bts', ':lua require("neotest").run.stop()<cr>', desc = 'De[B]ug [t]est [S]top' },
      { '<leader>btS', ':lua require("neotest").summary.toggle()<cr>', desc = 'De[B]ug [t]est [S]ummary' },
    },
    dependencies = {
      'vim-test/vim-test',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-vim-test',
    },
    config = function()
      local opts = {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
            runner = 'unittest',
          },
          require 'neotest-plenary',
          require 'neotest-vim-test' {
            ignore_file_types = { 'python', 'vim', 'lua' },
          },
        },
        -- overseer.nvim
        consumers = {
          overseer = require 'neotest.consumers.overseer',
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
      require('neotest').setup(opts)
    end,
  },
  {
    'stevearc/overseer.nvim',
    keys = {
      { '<leader>boR', '<cmd>OverseerRunCmd<cr>', desc = 'Run Command' },
      { '<leader>boa', '<cmd>OverseerTaskAction<cr>', desc = 'Task Action' },
      { '<leader>bor', '<cmd>OverseerRun<cr>', desc = 'Run' },
      { '<leader>bot', '<cmd>OverseerToggle<cr>', desc = 'Toggle' },
    },
    config = true,
  },
}
