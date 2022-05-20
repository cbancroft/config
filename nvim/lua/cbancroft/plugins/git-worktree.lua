local M = {}

function M.setup()
local worktree = require 'git-worktree'

worktree.setup {
  change_directory_command = 'tcd',
}
end

return M
