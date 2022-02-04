---------------------------------------------------------------
-- Telescope
---------------------------------------------------------------
local telescope = require 'telescope'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local themes = require 'telescope.themes'

telescope.load_extension 'git_worktree'
local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == 'table' then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end
local map_options = {
  noremap = true,
  silent = true,
}

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
  if not string.find(key, 'leader') then
    key = '<leader>' .. key
  end

  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = 'n'
  local rhs = string.format("<cmd>lua R('plugins.telescope')['%s']()<CR>", f, map_key)

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

local M = {}

function M.edit_config()
  local opts_with_preview, opts_without_preview

  opts_with_preview = {
    prompt_title = '~ dotfiles ~',
    shorten_path = false,
    cwd = '~/git/config',

    layout_strategy = 'flex',
    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },

    attach_mappings = function(_, map)
      map('i', '<c-y>', set_prompt_to_entry_value)
      map('i', '<M-c>', function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          require('telescope.builtin').find_files(opts_without_preview)
        end)
      end)

      return true
    end,
  }

  opts_without_preview = vim.deepcopy(opts_with_preview)
  opts_without_preview.previewer = false

  require('telescope.builtin').find_files(opts_with_preview)
end

function M.arcos_find()
  require('telescope.builtin').find_files {
    prompt_title = '~ arcos ~',
    shorten_path = false,
    cwd = '~/work/arcos',
    sorter = require('telescope').extensions.fzf.native_fzf_sorter(),
    layout_strategy = 'horizontal',

    layout_config = {
      width = 0.25,
      preview_width = 0.65,
    },
  }
end

function M.bracketer_find()
  require('telescope.builtin').find_files {
    prompt_title = '~ arcos ~',
    shorten_path = false,
    cwd = '~/work/arcos/snoopy/wip/cbracketer/',
    layout_strategy = 'horizontal',

    layout_config = {
      width = 0.25,
      preview_width = 0.65,
    },
  }
end

function M.fd()
  local opts = themes.get_ivy { hidden = false }
  require('telescope.builtin').fd(opts)
end

function M.builtin()
  require('telescope.builtin').builtin()
end

function M.git_files()
  local path = vim.fn.expand '%:h'
  if path == '' then
    path = nil
  end

  local width = 0.25

  local opts = themes.get_dropdown {
    winblend = 5,
    previewer = false,
    shorten_path = false,

    cwd = path,

    layout_config = {
      width = width,
    },
  }

  require('telescope.builtin').git_files(opts)
end

function M.lsp_code_actions()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }

  require('telescope.builtin').lsp_code_actions(opts)
end

function M.live_grep()
  require('telescope.builtin').live_grep {
    previewer = false,
    fzf_separator = '|>',
  }
end

function M.project_search()
  require('telescope.builtin').find_files {
    previewer = false,
    layout_stratey = 'vertical',
    cwd = require('lspconfig.util').root_pattern '.git'(vim.fn.expand '%:p'),
  }
end

function M.buffers()
  require('telescope.builtin').buffers {
    shorten_path = false,
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

function M.search_all_files()
  require('telescope.builtin').find_files {
    find_command = { 'rg', '--no-ignore', '--files' },
  }
end

function M.installed_plugins()
  require('telescope.builtin').find_files {
    cwd = vim.fn.stdpath 'data' .. '/site/pack/packer/start/',
  }
end

function M.file_browser()
  local opts

  opts = {
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    layout_config = {
      prompt_position = 'top',
    },
    attach_mappings = function(prompt_bufnr, map)
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      local modify_cwd = function(new_cwd)
        current_picker.cwd = new_cwd
        current_picker:refresh(opts.new_finder(new_cwd), { reset_prompt = true })
      end

      map('i', '-', function()
        modify_cwd(current_picker.cwd .. '/..')
      end)

      map('i', '~', function(opt2)
        modify_cwd(vim.fn.expand '~')
      end)

      local modify_depth = function(mod)
        return function()
          opts.depth = opts.depth + mod

          local this_picker = action_state.get_current_picker(prompt_bufnr)
          this_picker:refresh(opts.new_finder(current_picker.cwd), { reset_prompt = true })
        end
      end

      map('i', '<M-=>', modify_depth(1))
      map('i', '<M-+>', modify_depth(-1))

      map('n', 'yy', function()
        local entry = action_state.get_selected_entry()
        vim.fn.setreg('+', entry.value)
      end)

      return true
    end,
  }

  require('telescope.builtin').file_browser(opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }

  require('telescope.builtin').git_status(opts)
end

function M.git_commits()
  require('telescope.builtin').git_commits {
    win_blend = 5,
  }
end

function M.lsp_references()
  require('telescope.builtin').lsp_references {
    layout_strategy = 'vertical',
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    ignore_filename = false,
  }
end

function M.lsp_implementations()
  require('telescope.builtin').lsp_implementations {
    layout_strategy = 'vertical',
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    ignore_filename = false,
  }
end

-- Find files using Telescope command line sugar
map_tele('ff', 'curbuf')
map_tele('fc', 'edit_config')
map_tele('ft', 'git_files')
map_tele('fg', 'live_grep')
map_tele('fo', 'oldfiles')
map_tele('fp', 'project_search')
map_tele('fe', 'file_browser')
map_tele('fb', 'buffers')
map_tele('fh', 'help_tags')
map_tele('fwn', 'arcos_find')
map_tele('fwe', 'bracketer_find')
map_tele('fI', 'installed_plugins')

map_tele('gs', 'git_status')
map_tele('gc', 'git_commits')

mapnl('gw', "<cmd>lua require'telescope'.extensions.git_worktree.git_worktrees()<cr>", map_options)
mapnl('gm', "<cmd>lua require'telescope'.extensions.git_worktree.create_git_worktree()<cr>", map_options)

map_tele('fi', 'search_all_files')
map_tele('wt', 'treesitter')

M.map_tele = map_tele
return setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end,
})
