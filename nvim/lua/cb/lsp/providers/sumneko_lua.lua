local library = {}
local path = vim.split(package.path, ';')

table.insert(path, 'lua/?.lua')
table.insert(path, 'lua/?/init.lua')

local function add(lib)
  for _, p in pairs(vim.fn.expand(lib, false, true)) do
    p = vim.loop.fs_realpath(p)
    if p then
      library[p] = true
    end
  end
end

add '$VIMRUNTIME'
add(get_config_dir())

-- add plugins
-- if you're not using packer, then you might need to change the paths below
add(join_paths(get_runtime_dir(), 'site', 'pack', 'packer', 'opt', '*'))
add(join_paths(get_runtime_dir(), 'site', 'pack', 'packer', 'start', '*'))

local opts = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "cb", "packer_plugins" },
      },
      workspace = {
        library = library,
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

local lua_dev_loaded, lua_dev = pcall(require, "lua-dev")
if not lua_dev_loaded then
  return opts
end

local dev_opts = {
  library = {
    vimruntime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = { "plenary.nvim" },
  },
  lspconfig = opts,
}

return lua_dev.setup(dev_opts)

