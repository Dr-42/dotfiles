require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  -- Fidget
  use { 'j-hui/fidget.nvim', as = 'fidget' }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use {
    'folke/noice.nvim',
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Colorschemes
  use({ 'projekt0n/github-nvim-theme' })
  use { "catppuccin/nvim", as = "catppuccin" }          -- Colorscheme
  use { "bluz71/vim-nightfly-colors", as = "nightfly" } -- Colorscheme
  use { "folke/tokyonight.nvim", as = "tokyonight" }    -- Colorscheme
  use { "Shatur/neovim-ayu", as = "ayu" }               -- Colorscheme
  use { "yorickpeterse/vim-paper", as = "paper" }       -- Colorscheme
  use { 'rose-pine/neovim', as = 'rose-pine' }          -- Colorscheme

  use 'kyazdani42/nvim-web-devicons'                    -- Icons
  use 'nvim-lualine/lualine.nvim'                       -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim'             -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim'                           -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth'                                -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- File Broswer
  use { "nvim-telescope/telescope-file-browser.nvim" }

  -- NerdTree
  use { "preservim/nerdtree" }

  -- DAP
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }
  use { "theHamsta/nvim-dap-virtual-text" }
  use { "nvim-telescope/telescope-dap.nvim" }

  -- Copilot
  -- use { 'github/copilot.vim' }
  use { "zbirenbaum/copilot.lua" }

  -- Startup nvim
  use {
    "startup-nvim/startup.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      -- ignore git and node_modules
      require "startup".setup {
        theme = "dashboard",
      }
    end
  }

  -- Rust
  use("simrat39/rust-tools.nvim")

  -- Flutter
  use {
    "akinsho/flutter-tools.nvim",
    requires = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = true,
  }

  -- Kitty
  use { "fladson/vim-kitty" }
  -- Qt QML
  use { "peterhoeg/vim-qml" }

  -- Autoformat
  use("elentok/format-on-save.nvim")

  -- Show colors from hex codes
  use("norcalli/nvim-colorizer.lua")

  use { "Dr-42/error-jump.nvim", as = "error-jump" }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end
end)
