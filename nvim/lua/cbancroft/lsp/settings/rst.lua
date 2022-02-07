return {
  cmd = { 'rst-lsp-serve', '--log-file', vim.fn.expand '~/.cache/nvim/rst-lsp.log', '-v' },
  filetypes = { 'rst' },
  root_dir = function(fname)
    return nvim_lsp.util.root_pattern('conf.py', '.git')(fname)
  end,
  flags = {
    allow_incremental_sync = true,
  },
  on_init = function(client)
    print(vim.inspect(client.config.settings))
    if not client.config.flags then
      client.config.flags = {}
    end
    if not client.config.settings then
      client.config.settings = {}
    end
    if not client.config.settings.rst_lsp then
      client.config.settings.rst_lsp = {}
    end
    client.config.flags.allow_incremental_sync = true

    client.config.settings.rst_lsp.conf_path = client.config.root_dir .. '/conf.py'
  end,
  --[[
      on_new_config = function(new_config, new_root)
        if not new_config.settings then
          new_config.settings = {}
        end
        if not new_config.settings.rst_lsp then
          new_config.settings.rst_lsp = {}
        end
        new_config.flags.allow_incremental_sync = true

        new_config.settings.rst_lsp.conf_path = new_root .. '/conf.py'
      end,
      --]]

  settings = {},
}
