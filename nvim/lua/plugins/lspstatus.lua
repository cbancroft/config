local lsps = require 'lsp-status'
lsps.status()
lsps.register_progress()
lsps.config {
  indicator_errors = '✗',
  indicator_warnings = '⚠',
  indicator_info = '',
  indicator_hint = '',
  indicator_ok = '✔',
  current_function = true,
  diagnostics = false,
  select_symbol = nil,
  update_interval = 100,
  status_symbol = ' 🇻',
}
