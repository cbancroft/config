local library = {}
local path = vim.split(package.path, ';')

table.insert(path, 'lua/?.lua')
table.insert(path, 'lua/?/init.lua')

local function add(lib)
  for _, p in pairs(vim.fn.expand(lib, false, true)) do
    p = vim.loop.fs_realpath(p)
    library[p] = true
  end
end

add '$VIMRUNTIME'
add '~/.config/nvim'

-- add plugins
-- if you're not using packer, then you might need to change the paths below
add '~/.local/share/nvim/site/pack/packer/opt/*'
add '~/.local/share/nvim/site/pack/packer/start/*'
return {
  on_new_config = function(config, root)
    local libs = vim.tbl_deep_extend('force', {}, library)
    libs[root] = nil
    config.settings.Lua.workspace.library = libs
    return config
  end,
  settings = {
    Lua = {
      completion = { callSnippet = 'Both' },

      runtime = {
        version = 'LuaJIT',
        path = lua_runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand '$VIMRUNTIME/lua'] = true,
          [vim.fn.stdpath 'config' .. '/lua'] = true,
        },
      },
      telemetry = { enable = false },
    },
  },
}
