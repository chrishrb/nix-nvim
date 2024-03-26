local status_ok, plugin = pcall(require, "nixCatsUtils.lazyCat")
if not status_ok then return end

local plugins = {
  -----------------------------------------------------------------------------
  -- Look & feel
  -----------------------------------------------------------------------------
  {
    "catppuccin/nvim",
    config = function() require("chrishrb.plugins.config.colorscheme") end,
    lazy = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function() require("chrishrb.plugins.config.lualine") end,
    event = "VimEnter",
  },
  {
    "kdheepak/tabline.nvim",
    config = function() require("chrishrb.plugins.config.tabline") end,
    event = "VimEnter",
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons"
    },
    config = function() require("chrishrb.plugins.config.alpha") end,
    event = "VimEnter",
  },
  -- Icons for nvim-tree
  { "kyazdani42/nvim-web-devicons" },

  -----------------------------------------------------------------------------
  -- Navigation
  -----------------------------------------------------------------------------
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function() require("chrishrb.plugins.config.nvim-tree") end,
    event = "BufEnter",
  },

  {
    "folke/which-key.nvim",
    config = function() require("chrishrb.plugins.config.whichkey") end,
    cmd = "WhichKey",
    event = "VeryLazy",
  },

  -----------------------------------------------------------------------------
  -- LSP
  -----------------------------------------------------------------------------
  { -- language server installer
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        enabled = require("nixCatsUtils.lazyCat").lazyAdd(true, false),
      },
      {
        "williamboman/mason-lspconfig.nvim",
        enabled = require("nixCatsUtils.lazyCat").lazyAdd(true, false),
      },

      -- java and json language server
      "mfussenegger/nvim-jdtls",
      -- get documentation when pressing K
      {
        "lewis6991/hover.nvim",
        config = function() require("chrishrb.plugins.config.hover") end,
      },
      -- for formatters and linters
      "jose-elias-alvarez/null-ls.nvim",
      -- winbar
      "SmiteshP/nvim-navic",
    },
  },
  { -- show diagnostics of current document/workspace
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = true,
    event = "BufEnter",
  },

  -----------------------------------------------------------------------------
  -- DAP (Debugger)
  -----------------------------------------------------------------------------
  -- TODO
  -- { -- debugging with nvim
  --   "mfussenegger/nvim-dap", -- debugger
  --   dependencies = {
  --     "rcarriga/nvim-dap-ui", -- ui for debugger
  --     "jayp0521/mason-nvim-dap.nvim", -- mason adapter for dap
  --     "theHamsta/nvim-dap-virtual-text", -- show line visual
  --   },
  --   config = function() require("chrishrb.plugins.config.dap") end,
  -- },

  -----------------------------------------------------------------------------
  -- Completions
  -----------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer", -- Buffer completions
      "hrsh7th/cmp-path", -- Path completions
      "hrsh7th/cmp-cmdline", -- Cmdline completions
      "hrsh7th/cmp-nvim-lsp", -- LSP completions
      "hrsh7th/cmp-nvim-lsp-document-symbol", -- For textDocument/documentSymbol

      -- Snippets
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      {
        'L3MON4D3/LuaSnip',  --snippet engine
        name = 'luasnip',
        config = function () require("chrishrb.plugins.config.snippet") end,
      },
      "rafamadriz/friendly-snippets", -- a bunch of snippets to

      -- Misc
      "lukas-reineke/cmp-under-comparator", -- Tweak completion order
      "f3fora/cmp-spell",
    },
    config = function() require("chrishrb.plugins.config.cmp") end,
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("chrishrb.plugins.config.copilot")
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = require('nixCatsUtils.lazyCat').lazyAdd(':TSUpdate'),
    config = function() require("chrishrb.plugins.config.treesitter") end,
    dependencies = {
      -- autoclose and rename html tags
      "windwp/nvim-ts-autotag",
    },
    event = "User FileOpened",
  },

  -----------------------------------------------------------------------------
  -- Telescope
  -----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    config = function() require("chrishrb.plugins.config.telescope") end,
    event = "BufEnter",
  },

  -----------------------------------------------------------------------------
  -- Syntax, Languages & Code
  -----------------------------------------------------------------------------
  { -- Autopairs, integrates with both cmp and treesitter
    "windwp/nvim-autopairs",
    config = true,
    event = "InsertEnter",
  },
  { -- change surround e.g. ys{motion}{char}, ds{char}, cs{target}{replacement}
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to `main` branch for the latest features
    event = "BufEnter",
    config = true,
  },
  { -- indent line
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("chrishrb.plugins.config.indentline")
    end,
    main = "ibl",
    event = "VeryLazy",
  },

  { -- comment in/out with gc and gcc
    "terrortylor/nvim-comment",
    config = function() require("chrishrb.plugins.config.comment") end,
    event = "BufEnter",
  },

  -- rust tools
  -- { "simrat39/rust-tools.nvim" },

  -- go tools
  -- { "ray-x/go.nvim" },

  -----------------------------------------------------------------------------
  -- Git
  -----------------------------------------------------------------------------
  { -- show changed lines in vim
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("chrishrb.plugins.config.gitsigns") end,
    event = "BufReadPre",
  },
  { -- basic git
    "tpope/vim-fugitive",
    cmd = "Git",
    event = "VeryLazy",
  },

  -----------------------------------------------------------------------------
  -- Tmux
  -----------------------------------------------------------------------------
  { -- tmux navigation
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = false, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end,
    lazy = false,
  },

  -----------------------------------------------------------------------------
  -- Misc
  -----------------------------------------------------------------------------
  -- Useful lua functions used in lots of plugins
  { "nvim-lua/plenary.nvim" },
  { -- delete all bufs except the one you are working
    "vim-scripts/BufOnly.vim",
    event = "BufEnter",
  },
  { -- delete buffers without closing your window or messing up your layout
    "moll/vim-bbye",
    event = "VeryLazy",
  },
  { -- project management with  vim
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
    config = function() require("chrishrb.plugins.config.project") end,
  },
  { -- creates automatically missing directories, like mkdir -p
    "jghauser/mkdir.nvim",
    event = "BufEnter",
  },
  { -- disable certain features if opening big files
    "lunarvim/bigfile.nvim",
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },
  {
    "chrishrb/gx.nvim",
    -- dir = "~/jam-dev/home/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }} },
    cmd = { "Browse" },
    init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = true,
  },
}

-- nixCats specific lazy setup
local pluginList = nil
local nixLazyPath = nil
if require('nixCatsUtils').isNixCats then
  local allPlugins = require("nixCats").pawsible.allPlugins
  -- it is called pluginList because we only need to pass in the names
  pluginList = require('nixCatsUtils.lazyCat').mergePluginTables( allPlugins.start, allPlugins.opt)
  -- it wasnt detecting these because the names are slightly different.
  -- when that happens, add them to the list, then also specify name in the lazySpec
  pluginList[ [[LuaSnip]] ] = ""
  nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]
end

local opts = {
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
}

plugin.setup(pluginList, nixLazyPath, plugins, opts)
