local M = {}

-- Custom Actions
local transform_mod = require('telescope.actions.mt').transform_mod
local nvb_actions = transform_mod {
	file_path = function (prompt_bufnr)
		-- Get the selected entry and full file path
		local content = require('telescope.actions.state').get_selected_entry()
		local full_path = content.cwd .. require('plenary.path').path.sep .. content.value

		-- Yank to the unnamed register
		vim.fn.setreg('"', full_path)

		-- Close the popup
		require('utils').info 'File path yanked'
		require('telescope.actions').close(prompt_bufnr)
	end,
}
function M.setup()
	local actions = require 'telescope.actions'
	local telescope = require 'telescope'


	-- Custom Previewer
	local previewers = require 'telescope.previewers'
	local Job = require 'plenary.job'
	local preview_maker = function(filepath, bufnr, opts)
		filepath = vim.fn.expand(filepath)
		Job:new({
			command = 'file',
			args = {'--mime-type', '-b', filepath},
			on_exit = function (j)
				local mime_type = vim.split(j:result()[1], '/')[1]

				if mime_type == 'text' then
					-- Check file size
					vim.loop.fs_stat(filepath, function (_, stat)
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
					vim.schedule(function ()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY FILE'})
					end)
				end
			end,
			})
			:sync()
	end

	telescope.setup {
		defaults = {
			buffer_previewer_maker = preview_maker,
			mappings = {
				i = {
				},
			},
		},
		extensions = {
			repo = {
				list = {
					search_dirs = {
						'~/git',
						'~/workplace/'
					}
				}
			}
		},
		pickers = {
			find_files = {
				theme = 'ivy',
				mappings = {
					n = {
						['y'] = nvb_actions.file_path,
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
						['y'] = nvb_actions.file_path,
					},
					i = {
						['<C-y>'] = nvb_actions.file_path
					}
				}
			}
		}
	}

	telescope.load_extension 'fzf'
	telescope.load_extension 'project'
	telescope.load_extension 'repo'
	telescope.load_extension 'file_browser'
	telescope.load_extension 'projects'
end

return M
