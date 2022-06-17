local plugins = {
  -- Packer can manage itself as an optional plugin
  { "wbthomason/packer.nvim" },
  -- LSP extensions
  { "neovim/nvim-lspconfig" },
  -- Able to stow LSP settings into JSON
  { "tamago324/nlsp-settings.nvim" },
  -- Nice formatting and extensions for many languages
  { "jose-elias-alvarez/null-ls.nvim", },
  -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  { "antoinemadec/FixCursorHold.nvim" },
  -- Automatically install LSPs for us
  { "williamboman/nvim-lsp-installer", },
  {
    "lunarvim/onedarker.nvim",
    config = function()
      pcall(function()
        if cb and cb.colorscheme == "onedarker" then
          require("onedarker").setup()
          cb.builtin.lualine.options.theme = "onedarker"
        end
      end)
    end,
    disable = cb.colorscheme ~= "onedarker",
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("cb.core.notify").setup()
    end,
    requires = { "nvim-telescope/telescope.nvim" },
    disable = not cb.builtin.notify.active or not cb.builtin.telescope.active,
  },
  -- Structured Logging
  { "Tastyep/structlog.nvim" },

  -- Nice popups
  { "nvim-lua/popup.nvim" },

  -- Nvim stdlib
  { "nvim-lua/plenary.nvim" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("cb.core.telescope").setup()
    end,
    disable = not cb.builtin.telescope.active,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    run = "make",
    disable = not cb.builtin.telescope.active,
  },
  -- Install nvim-cmp, and buffer source as a dependency
  {
    "hrsh7th/nvim-cmp",
    config = function()
      if cb.builtin.cmp then
        require("cb.core.cmp").setup()
      end
    end,
    requires = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
  },
  { "rafamadriz/friendly-snippets", },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local utils = require "cb.utils"
      local paths = {
        utils.join_paths(get_runtime_dir(), "site", "pack", "packer", "start", "friendly-snippets"),
      }
      local user_snippets = utils.join_paths(get_config_dir(), "snippets")
      if utils.is_directory(user_snippets) then
        paths[#paths + 1] = user_snippets
      end
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = paths,
      }
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },
  { "hrsh7th/cmp-nvim-lsp", },
  { "saadparwaiz1/cmp_luasnip", },
  { "hrsh7th/cmp-buffer", },
  { "hrsh7th/cmp-path", },
  {
    -- NOTE: Temporary fix till folke comes back
    "max397574/lua-dev.nvim",
    module = "lua-dev",
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    -- event = "InsertEnter",
    config = function()
      require("cb.core.autopairs").setup()
    end,
    disable = not cb.builtin.autopairs.active,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    -- run = ":TSUpdate",
    config = function()
      require("cb.core.treesitter").setup()
    end,
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects'
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
  },

  -- NvimTree
  {
    "kyazdani42/nvim-tree.lua",
    -- event = "BufWinOpen",
    -- cmd = "NvimTreeToggle",
    config = function()
      require("cb.core.nvimtree").setup()
    end,
    disable = not cb.builtin.nvimtree.active,
  },

  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("cb.core.gitsigns").setup()
    end,
    event = "BufRead",
    disable = not cb.builtin.gitsigns.active,
  },

  -- Whichkey
  {
    "max397574/which-key.nvim",
    config = function()
      require("cb.core.which-key").setup()
    end,
    event = "BufWinEnter",
    disable = not cb.builtin.which_key.active,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function()
      require("cb.core.comment").setup()
    end,
    disable = not cb.builtin.comment.active,
  },

  -- project.nvim
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("cb.core.project").setup()
    end,
    disable = not cb.builtin.project.active,
  },

  -- Icons
  {
    "kyazdani42/nvim-web-devicons",
    disable = not cb.use_icons,
  },

  -- Status Line and Bufferline
  {
    -- "hoob3rt/lualine.nvim",
    "nvim-lualine/lualine.nvim",
    -- "Lunarvim/lualine.nvim",
    config = function()
      require("cb.core.lualine").setup()
    end,
    disable = not cb.builtin.lualine.active,
  },

  {
    "akinsho/bufferline.nvim",
    config = function()
      require("cb.core.bufferline").setup()
    end,
    branch = "main",
    event = "BufWinEnter",
    disable = not cb.builtin.bufferline.active,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    -- event = "BufWinEnter",
    config = function()
      require("cb.core.dap").setup()
    end,
    disable = not cb.builtin.dap.active,
  },

  -- Debugger management
  {
    "Pocco81/dap-buddy.nvim",
    branch = "dev",
    -- event = "BufWinEnter",
    -- event = "BufRead",
    disable = not cb.builtin.dap.active,
  },

  -- alpha
  {
    "goolord/alpha-nvim",
    config = function()
      require("cb.core.alpha").setup()
    end,
    disable = not cb.builtin.alpha.active,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    event = "BufWinEnter",
    branch = "main",
    config = function()
      require("cb.core.terminal").setup()
    end,
    disable = not cb.builtin.terminal.active,
  },

  -- SchemaStore
  {
    "b0o/schemastore.nvim",
  },

  -- Need that surround goodness
  {
    'tpope/vim-surround',
    keys = { 'c', 'd', 'y' }
  },

  -- Neogit
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    config = function()
      require('cb.core.neogit').setup()
    end
  }
}

for _, entry in ipairs(plugins) do
  entry['lock'] = true
end

return plugins
