-----------------------------------------------------------
-- Treesitter configuration file
-----------------------------------------------------------
local M = {}

-- Plugin: nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
function M.setup()
  print 'Running treesitter setup'
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'python', 'javascript', 'lua', 'java',
      'bash', 'cmake', 'dot', 'http', 'json', 'json5', 'ledger', 'ninja', 'norg', 'proto',
      'rst', 'rust', 'scss', 'toml', 'vim', 'vue', 'yaml', },
    sync_install = false,
    highlight = {
      enable = true,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      -- additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn', -- maps in normal mode to init the node/scope selection
        node_incremental = 'grn', -- increment to the upper named parent
        node_decremental = 'grc', -- decrement to the previous node
        scope_incremental = 'grm', -- increment to the upper scope (as defined in locals.scm)
      },
    },
    indent = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },

      smart_rename = {
        enable = false,
        keymaps = {
          -- mapping to rename reference under cursor
          smart_rename = 'grr',
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = 'gnd',
          list_definitions = 'gnD',
          list_definitions_toc = 'gO',
          goto_next_usage = '<a-*>',
          goto_previous_usage = '<a-#>',
        },
      },
    },
    context_commentstring = {
      enable = true,

      -- With Comment.nvim, we don't need to run this on the autocmd.
      -- Only run it in pre-hook
      enable_autocmd = false,

      config = {
        c = '// %s',
        lua = '-- %s',
      },
    },
    textobjects = {
      move = {
        enable = true,
        set_jumps = true,

        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>rx'] = "@parameter.inner",
        },
        swap_previous = {
          ['<leader>rX'] = "@parameter.inner"
        }
      },
      select = {
        enable = true, -- you can also use a table with list of langs here (e.g. )

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined here:
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/c/textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
          ['as'] = '@statement.outer',
          ['is'] = '@statement.inner',
          ['aC'] = '@class.outer',
          ['iC'] = '@class.inner',
          ['ac'] = '@conditional.outer',
          ['ic'] = '@conditional.inner',
        },
      },
      lsp_interop = {
        enable = true,
        border = 'none',
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dF'] = '@class.outer',
        },
      },
    },
    endwise = {
      enable = true,
    },
  }
end

return M
