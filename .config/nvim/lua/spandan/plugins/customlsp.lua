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

	{ "Dr-42/error-jump.nvim", name = "error-jump" },

	-- Yuck for eww
	{ "elkowar/yuck.vim" },
	-- Autoformat
	{
		"elentok/format-on-save.nvim",
		config = function()
			local formatters = require("format-on-save.formatters")
			require("format-on-save").setup({
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
					vue = formatters.vue - language - server,
					elixir = formatters.lsp,

					go = {
						formatters.shell({
							cmd = { "goimports-reviser", "-rm-unused", "-set-alias", "-format", "%" },
							tempfile = function()
								return vim.fn.expand("%") .. ".formatter-temp"
							end,
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
		end,
	},
	-- Cargo plugins
	{
		"saecki/crates.nvim",
		config = function()
			require("crates").setup({
				completion = {
					cmp = {
						enabled = true,
					},
					crates = {
						enabled = true, -- disabled by default
						max_results = 8, -- The maximum number of search results to display
						min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
					},
				},
			})
		end,
	},

	-- Opencl
	{ "petRUShka/vim-opencl" },
	-- Vue
  {
  local vue_language_server_path = '/path/to/@vue/language-server'
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = tsserver_filetypes,
}

local ts_ls_config = {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,
}

-- If you are on most recent `nvim-lspconfig`
local vue_ls_config = {}
  }
}
