local map = require('cbancroft.utils').map

-- session
map('n', '<leader>sl', '<cmd>silent RestoreSession<cr>')
map('n', '<leader>ss', '<cmd>SaveSession<cr>')
map(
  'n',
  '<leader>si',
  '<cmd>lua require("cbancroft.utils").log("Session name: " .. require("auto-session-library").current_session_name())<cr>'
)
