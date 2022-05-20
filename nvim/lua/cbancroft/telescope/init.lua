local M = {}

local transform_mod = R 'telescope.actions.mt'.transform_mod
local nvb_actions = transform_mod {
  file_path = function(prompt_bufnr)
    -- Get selected entry and the file full path
    local content = R 'telescope.actions.state'.get_selected_entry()
    local full_path = content.cwd .. require 'plenary.path'.path.sep .. content.value

    -- Yank the path to unnamed and clipboard register
    vim.fn.setreg('+', full_path)

    -- Close the group
    require 'cbancroft.utils'.info "File path is yanked "
    require 'telescope.actions'.close(prompt_bufnr)
  end
}

function M.setup()
  local telescope = R 'telescope'
  local actions = require 'telescope.actions'
  local previewers = R 'telescope.previewers'
  local Job = R 'plenary.job'

  local preview_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job:new({
      command = "file",
      args = { "--mime-type", "-b", filepath },
      on_exit = function(j)
        local mime_type = vim.split(j:result()[1], "/")[1]

        if mime_type == "text" then
          -- Check file size
          vim.loop.fs_stat(filepath, function(_, stat)
            if not stat then
              return
            end
            if stat.size > 500000 then
              return
            else
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
          end)
        else
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY FILE" })
          end)
        end
      end,
    }):sync()
  end

  telescope.setup {
    defaults = {
      buffer_previewer_maker = preview_maker,
      prompt_prefix = ' ',
      selection_caret = ' ',
      path_display = { 'smart' },

      mappings = {
        i = {
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,

          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,

          ['<C-c>'] = actions.close,

          ['<Down>'] = actions.move_selection_next,
          ['<Up>'] = actions.move_selection_previous,

          ['<CR>'] = actions.select_default,
          ['<C-x>'] = actions.select_horizontal,
          ['<C-v>'] = actions.select_vertical,
          ['<C-t>'] = actions.select_tab,

          ['<C-u>'] = actions.preview_scrolling_up,
          ['<C-d>'] = actions.preview_scrolling_down,

          ['<PageUp>'] = actions.results_scrolling_up,
          ['<PageDown>'] = actions.results_scrolling_down,

          ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
          ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
          ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          ['<C-l>'] = actions.complete_tag,
          ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
        },
        n = {
          ['<esc>'] = actions.close,
          ['<CR>'] = actions.select_default,
          ['<C-x>'] = actions.select_horizontal,
          ['<C-v>'] = actions.select_vertical,
          ['<C-t>'] = actions.select_tab,

          ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
          ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
          ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

          ['j'] = actions.move_selection_next,
          ['k'] = actions.move_selection_previous,
          ['H'] = actions.move_to_top,
          ['M'] = actions.move_to_middle,
          ['L'] = actions.move_to_bottom,

          ['<Down>'] = actions.move_selection_next,
          ['<Up>'] = actions.move_selection_previous,
          ['gg'] = actions.move_to_top,
          ['G'] = actions.move_to_bottom,

          ['<C-u>'] = actions.preview_scrolling_up,
          ['<C-d>'] = actions.preview_scrolling_down,

          ['<PageUp>'] = actions.results_scrolling_up,
          ['<PageDown>'] = actions.results_scrolling_down,

          ['?'] = actions.which_key,
        },
      },
    },
    pickers = {
      find_files = {
        theme = 'ivy',
        mappings = {
          n = {
            y = nvb_actions.file_path
          },
          i = {
            ['<C-y>'] = nvb_actions.file_path
          }
        }
      },
      git_files = {
        theme = 'dropdown',
        mappings = {
          n = {
            y = nvb_actions.file_path
          },
          i = {
            ['<C-y>'] = nvb_actions.file_path
          }
        }
      }
    },
  }
  telescope.load_extension 'fzf'
  telescope.load_extension 'project' -- telescope-project.nvim
  telescope.load_extension 'repo'
  telescope.load_extension 'file_browser'
  telescope.load_extension 'projects' -- project.nvim
  telescope.load_extension "git_worktree"
end

M.switch_projects = function()
  require('telescope.builtin').find_files {
    prompt_title = '< Switch Project >',
    cwd = '$HOME/work/',
  }
end

return M
