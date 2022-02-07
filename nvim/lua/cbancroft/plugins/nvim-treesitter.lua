-----------------------------------------------------------
-- Treesitter configuration file
-----------------------------------------------------------

-- Plugin: nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'python', 'javascript', 'lua', 'java' },
  highlight = {
    enable = { 'c', 'cpp', 'python', 'javascript', 'lua', 'java' },

    custom_captures = {
      -- Highlight the @foo.bar capture group with the 'Identifier' highlight group
      ['foo.bar'] = 'Identifier',
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    disable = { 'cpp', 'lua' },
    keymaps = {
      init_selection = '<M-w>', -- maps in normal mode to init the node/scope selection
      node_incremental = '<M-w>', -- increment to the upper named parent
      node_decremental = '<M-C-w>', -- decrement to the previous node
      scope_incremental = '<M-e>', -- increment to the upper scope (as defined in locals.scm)
    },
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

    select = {
      enable = true, -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
      keymaps = {
        -- You can use the capture groups defined here:
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/c/textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['as'] = '@statement.outer',
        ['is'] = '@statement.inner',
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
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
