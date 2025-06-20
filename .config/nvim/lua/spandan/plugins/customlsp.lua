return {
  -- Rust
  { "simrat39/rust-tools.nvim" },
  { "MrcJkb/haskell-tools.nvim" },

  -- Kitty
  { "fladson/vim-kitty" },
  -- Qt QML
  { "peterhoeg/vim-qml" },
  -- Show colors from hex codes
  { "norcalli/nvim-colorizer.lua" },

  { "Dr-42/error-jump.nvim",      name = "error-jump" },

  -- Yuck for eww
  { "elkowar/yuck.vim" },
  -- Autoformat
  {
    "elentok/format-on-save.nvim",
    config = function()
      local formatters = require("format-on-save.formatters")
      require('format-on-save').setup({
        exclude_path_patterns = {
          "/node_modules/",
          ".local/share/nvim/lazy",
        },
        formatter_by_ft = {
          css = formatters.prettierd,
          html = formatters.lsp,
          java = formatters.lsp,
          javascript = formatters.lsp,
          json = formatters.lsp,
          lua = formatters.lsp,
          markdown = formatters.prettierd,
          openscad = formatters.lsp,
          python = formatters.black,
          rust = formatters.lsp,
          scad = formatters.lsp,
          scss = formatters.lsp,
          sh = formatters.shfmt,
          terraform = formatters.lsp,
          typescript = formatters.prettierd,
          typescriptreact = formatters.prettierd,
          yaml = formatters.lsp,
          vue = formatters.volar,
          elixir = formatters.lsp,

          go = {
            formatters.shell({
              cmd = { "goimports-reviser", "-rm-unused", "-set-alias", "-format", "%" },
              tempfile = function()
                return vim.fn.expand("%") .. '.formatter-temp'
              end
            }),
            formatters.shell({ cmd = { "gofmt" } }),
          },
          --   c = {
          --     formatters.shell({
          --       cmd = { "clang-format", "-style=file" },
          --       tempfile = function()
          --         return vim.fn.expand("%") .. '.formatter-temp'
          --       end
          --     }),
          --     formatters.shell({ cmd = { "clang-format" } }),
          --   },
          --   cpp = {
          --     formatters.shell({
          --       cmd = { "clang-format", "-style=file" },
          --       tempfile = function()
          --         return vim.fn.expand("%") .. '.formatter-temp'
          --       end
          --     }),
          --     formatters.shell({ cmd = { "clang-format" } }),
          --   },
        },
      })
    end
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      require("flutter-tools").setup {
        ui = {
          -- the border type to use for all floating windows, the same options/formats
          -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
          border = "rounded",
          -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
          -- please note that this option is eventually going to be deprecated and users will need to
          -- depend on plugins like `nvim-notify` instead.
          notification_style = 'native',
        },
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = false,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = false,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = false,
          }
        },
        debugger = {          -- integrate with nvim dap + install dart code debugger
          enabled = true,
          run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
          register_configurations = function(paths)
            require("dap").configurations.dart = {
            }
          end,
        },
        -- flutter_path = "<full/path/if/needed>",     -- <-- this takes priority over the lookup
        flutter_lookup_cmd = nil,                   -- example "dirname $(which flutter)" or "asdf where flutter"
        root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
        fvm = false,                                -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
        widget_guides = {
          enabled = false,
        },
        closing_tags = {
          highlight = "ErrorMsg", -- highlight for the closing tag
          prefix = ">",           -- character to use for close tag e.g. > Widget
          enabled = true          -- set to false to disable
        },
        dev_log = {
          enabled = true,
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = "tabedit",  -- command to use to open the log buffer
        },
        dev_tools = {
          autostart = false,         -- autostart devtools server if not detected
          auto_open_browser = false, -- Automatically opens devtools in the browser
        },
        outline = {
          open_cmd = "30vnew", -- command to use to open the outline buffer
          auto_open = false    -- if true this will open the outline automatically when it is first populated
        },
        lsp = {
          color = { -- show the derived colours for dart variables
            enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = false, -- highlight the background
            background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
            virtual_text_str = "■", -- the virtual text character to highlight
          },
          -- on_attach = my_custom_on_attach,
          -- capabilities = my_custom_capabilities -- e.g. lsp_status capabilities
          --- OR you can specify a function to deactivate or change or control how the config is created
          -- capabilities = function(config)
          --   config.specificThingIDontWant = false
          --   return config
          -- end,
          -- see the link below for details on each option:
          -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = { "$HOME/sdks/flutter" },
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true,      -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          }
        }
      }
    end
  },
  -- Cargo plugins
  {
    'saecki/crates.nvim',
    config = function()
      require('crates').setup {
        completion = {
          cmp = {
            enabled = true,
          },
          crates = {
            enabled = true,  -- disabled by default
            max_results = 8, -- The maximum number of search results to display
            min_chars = 3,   -- The minimum number of charaters to type before completions begin appearing
          }
        }
      }
    end,
  },

  -- Opencl
  { 'petRUShka/vim-opencl' },
}
