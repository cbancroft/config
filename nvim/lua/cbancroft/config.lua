-- Configuration overrides

local config = {
  auto_session = {},
  -- See `:h nvim_open_win` for border options
  border = 'rounded',
  comment_nvim = {},
  diagnostic = {},
  gitsigns = {},

  -- LSP Settings
  lsp = {
    -- True/false or table of filetypes: `{ '.ts', '.js'}`
    format_on_save = true,
    format_timeout = 3000,
    rename_notification = true,
    servers = {
      rust_analyzer = true,

      null_ls = {
        -- Additional sources here
        sources = {}
      }
    }
  },
  -- Default statusline icon
  statusline = {
    main_icon = '★',
  },
  -- Options: 'catppuccin', 'dracula', 'enfocado', 'github', 'gruvbox', 'kanagawa', 'nightfox', 'nord', 'onedark', 'rose-pine',
  theme = 'tokyonight',
  todo_comments = {},
  treesitter = {},
  notify = {},
  nvim_cmp = {},
  nvim_tree = {},
  add_plugins = {
    'ggandor/lightspeed.nvim',
    -- {
    --   'romgrk/barbar.nvim',
    --   requires = { 'kyazdani42/nvim-web-devicons' }
    -- }
  },
  disable_plugins = {

  }



}

local user_servers = vim.tbl_keys(config.lsp.servers)

function config.lsp.can_client_format(client_name)
  if config.lsp.servers[client_name] == true then
    return true
  end

  if vim.tbl_contains(config, client_name) and config.lsp.servers[client_name] then
    return (config.lsp.servers[client_name].format == true)
  end

  return true
end

return config
