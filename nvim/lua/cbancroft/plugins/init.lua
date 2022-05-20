----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- https://github.com/wbthomason/packer.nvim
local config = require('cbancroft.config')
local mypacker = require('cbancroft.packer')
local packer = mypacker.packer
local use = packer.use

return packer.startup(function()
  use {
    'wbthomason/packer.nvim',
    'lewis6991/impatient.nvim',
    'nathom/filetype.nvim',
    'nvim-lua/plenary.nvim',
  }

  -- initialize theming
  require('cbancroft.theme.plugins').init(use, config)

  use {
    'rcarriga/nvim-notify',
    config = function()
      require('cbancroft.plugins.notify')
    end,
    after = config.theme,
    disable = vim.tbl_contains(config.disable_plugins, 'notify')
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require 'cbancroft.plugins.nvim-tree'
    end,
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeToggle',
    },
    event = 'VimEnter'
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require 'cbancroft.lsp'.setup()
    end,
    event = 'BufWinEnter',
    requires = {
      { 'b0o/SchemaStore.nvim' },
      { 'williamboman/nvim-lsp-installer' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        -- config = function()
        --   require 'cbancroft.lsp.null_ls'.setup()
        -- end,
        disable = vim.tbl_contains(config.disable_plugins, 'null-ls'),
        -- after = 'nvim-lspconfig'
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      -- {
      --   'ray-x/lsp_signature.nvim',
      --   config = function()
      --     require 'cbancroft.plugins.lsp-signature'
      --   end,
      --   after = 'nvim-lspconfig',
      --   disable = vim.tbl_contains(config.disable_plugins, 'lsp_signature')
      -- },
    },
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    config = [[ R'cbancroft.cmp'.setup() ]],
    event = 'InsertEnter',
    disable = vim.tbl_contains(config.disable_plugins, 'nvim-cmp'),
    requires = {
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'ray-x/cmp-treesitter', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      {
        'L3MON4D3/LuaSnip',
        wants = 'friendly-snippets',
        config = [[ R'cbancroft.snip'.setup() ]],
        requires = {
          'rafamadriz/friendly-snippets',
        }
      },
      {
        'windwp/nvim-autopairs',
        config = function()
          require 'cbancroft.plugins.autopairs'.setup()
        end,
        after = 'nvim-cmp'
      },
      'folke/lua-dev.nvim',
      'RRethy/vim-illuminate',
      'jose-elias-alvarez/null-ls.nvim',
      {
        'j-hui/fidget.nvim',
        config = [[ require'fidget'.setup {} ]]
      },
      'b0o/schemastore.nvim'
    },
  }

  use {
    'tpope/vim-fugitive',
    opt = true,
    cmd = { 'Git', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit' },
    requires = { 'tpope/vim-rhubarb' },
    disable = vim.tbl_contains(config.disable_plugins, 'fugitive')
  }

  -- git labels
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    opt = true,
    event = 'BufWinEnter',
    wants = 'plenary.nvim',
    config = [[ R'cbancroft.plugins.gitsigns'.setup() ]],
    disable = vim.tbl_contains(config.disable_plugins, 'gitsigns')
  }

  -- Floating terminal
  use {
    'voldikss/vim-floaterm',
    opt = true,
    event = 'BufWinEnter',
    config = function()
      require 'cbancroft.plugins.terminal'
    end,
    disable = vim.tbl_contains(config.disable_plugins, 'terminal')
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    config = [[ R'cbancroft.telescope'.setup()]],
    event = 'BufWinEnter',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
      },
      'nvim-telescope/telescope-project.nvim',
      'cljoly/telescope-repo.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      {
        'ahmedkhalf/project.nvim',
        config = [[ R'project_nvim'.setup {} ]]
      },
      {
        'ThePrimeagen/git-worktree.nvim',
        requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function() R 'cbancroft.plugins.git-worktree'.setup() end,
      }

    },
    disable = vim.tbl_contains(config.disable_plugins, 'telescope'),
  }

  -- dashboard
  use {
    'goolord/alpha-nvim',
    config = [[ R'cbancroft.plugins.alpha-nvim'.setup() ]],
  }

  -- Session Management
  use {
    'rmagatti/auto-session',
    config = function()
      require 'cbancroft.plugins.auto-session'
    end,
    disable = vim.tbl_contains(config.disable_plugins, 'auto-session')
  }

  -- Treesitter Related
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-endwise',
      'windwp/nvim-ts-autotag',
    },
    config = [[R'cbancroft.plugins.nvim-treesitter'.setup()]],
    disable = vim.tbl_contains(config.disable_plugins, 'treesitter')
  }

  -- Better Comment
  use {
    'numToStr/Comment.nvim',
    event = 'BufWinEnter',
    config = function()
      require 'cbancroft.plugins.comments'
    end,
    disable = vim.tbl_contains(config.disable_plugins, 'comment-nvim')
  }

  -- Todo Highlights
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require 'cbancroft.plugins.todo-comments'
    end,
    event = 'BufWinEnter',
    disable = vim.tbl_contains(config.disable_plugins, 'todo-comments')
  }

  -- Git
  use {
    'TimUntersberger/neogit',
    cmd = 'Neogit', -- Only load when we run neogit
    requires = 'nvim-lua/plenary.nvim',
    config = [[ R'cbancroft.plugins.neogit'.setup() ]],
  }

  -- WhichKey
  use {
    'folke/which-key.nvim',
    event = "VimEnter",
    config = [[ R('cbancroft.plugins.which-key').setup() ]]
  }

  -- IndentLine
  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = [[ R'cbancroft.plugins.indent-blankline'.setup() ]],
  }

  -- Better icons
  use {
    'kyazdani42/nvim-web-devicons',
    opt = true,
  }

  -- Status Line
  use {
    'nvim-lualine/lualine.nvim',
    after = config.theme,
    config = [[ R'cbancroft.plugins.lualine'.setup() ]],
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
  }

  use {
    'SmiteshP/nvim-gps',
    requires = 'nvim-treesitter/nvim-treesitter',
    module = 'nvim-gps',
    wants = 'nvim-treesitter',
    config = [[ R'cbancroft.plugins.gps'.setup() ]],
  }

  -- Better Surround
  use { 'tpope/vim-surround', event = 'InsertEnter' }

  use {
    'sainnhe/everforest',
    config = [[ vim.cmd 'colorscheme everforest' ]]
  }

  -- Buffer line
  use {
    'akinsho/nvim-bufferline.lua',
    event = 'BufWinEnter',
    wants = 'nvim-web-devicons',
    config = [[ R'cbancroft.plugins.bufferline'.setup() ]],
  }
  --- For doing Lua formatting
  use { 'tami5/lspsaga.nvim',
    cmd = { 'Lspsaga' },
    config = [[ require'lspsaga'.setup {} ]]
  }
  use {
    'kkoomen/vim-doge',
    run = ':call doge#install()',
    config = [[ R('cbancroft.plugins.doge').setup()]],
    event = 'VimEnter',
    disable = true,
  }
  use 'moll/vim-bbye'
  -- trouble.nvim
  use {
    'folke/trouble.nvim',
    event = 'BufReadPre',
    wants = 'nvim-web-devicons',
    cmd = { 'TroubleToggle', 'Trouble' },
    config = function()
      require 'trouble'.setup { use_diagnostic_signs = true }
    end
  }
  use { 'ajouellette/sway-vim-syntax', disable = true }



  use {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup {}
    end,
    disable = true,
  }
  use {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {}
    end,
    disable = true,
  }

  use {
    'simrat39/rust-tools.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'rust-lang/rust.vim', 'neovim/nvim-lspconfig', },
    module = 'rust-tools',
    ft = { 'rust' },
    wants = { 'nvim-lspconfig' },
    config = [[ R'rust-tools'.setup({}) ]],
  }

  if config.add_plugins and not vim.tbl_isempty(config.add_plugins) then
    for _, plugin in pairs(config.add_plugins) do
      use(plugin)
    end
  end

  if mypacker.first_install then
    packer.sync()
  end
end)
