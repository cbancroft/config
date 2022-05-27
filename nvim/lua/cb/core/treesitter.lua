local M = {}


M.config = function()
  cb.builtin.treesitter = {
    on_config_done = nil,
    ensure_installed = {}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = {},
    matchup = {
      enable = false, -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      additional_vim_regex_highlighting = false,
      disable = { "latex" },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
      config = {
        -- Languages that have a single comment style
        typescript = "// %s",
        css = "/* %s */",
        scss = "/* %s */",
        html = "<!-- %s -->",
        svelte = "<!-- %s -->",
        vue = "<!-- %s -->",
        json = "",
      },
    },
    indent = { enable = true, disable = { "yaml", "python" } },
    autotag = { enable = false },
    textobjects = {
      swap = {
        enable = false,
        -- swap_next = textobj_swap_keymaps,
      },
      -- move = textobj_move_keymaps,
      select = {
        enable = true,
        -- keymaps = textobj_sel_keymaps,
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
      }
    },
    textsubjects = {
      enable = true,
      keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    playground = {
      enable = false,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    rainbow = {
      enable = false,
      extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
      max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
  }
end

M.setup = function()
  -- avoid running in headless mode since it's harder to detect failures
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end

  local opts = vim.deepcopy(cb.builtin.treesitter)

  treesitter_configs.setup(opts)

  if cb.builtin.treesitter.on_config_done then
    cb.builtin.treesitter.on_config_done(treesitter_configs)
  end
end

return M
