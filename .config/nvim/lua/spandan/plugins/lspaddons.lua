-- plugins/lsp.lua
return {
	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- LspAttach Autocmd for setting up keymaps and features per-buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Navigation mappings
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>TD", require("telescope.builtin").lsp_type_definitions, "[T]ype [D]efinition")
					map("<leader>Ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Action mappings
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Highlight references on cursor hold (Neovim 0.11+ compatible)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Toggle inlay hints
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Base capabilities for nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- 1. Setup Clangd using Neovim 0.11 Native API
			vim.lsp.config.clangd = {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					-- Added cc and c++ to the allowed query drivers
					"--query-driver=/**/*gcc,/**/*g++,/**/*clang,/**/*clang++,/**/*cc,/**/*c++",
				},
				root_markers = { "compile_commands.json", "compile_flags.txt", "Makefile", ".git" },
			}
			vim.lsp.enable("clangd")

			-- ==========================================
			-- 🚀 SYNOVIUM LSP INJECTION
			-- ==========================================
			-- Register the .syn file extension
			vim.filetype.add({ extension = { syn = "synovium" } })

			-- Define the custom server
			vim.lsp.config.synovium = {
				-- This assumes you have run `go build -o synovium main.go`
				-- and placed the binary in your PATH (e.g., ~/.local/bin or /usr/local/bin)
				-- Alternatively, use an absolute path: cmd = { "/path/to/your/repo/synovium", "lsp" }
				cmd = { "synovium", "lsp" },
				filetypes = { "synovium" },
				root_markers = { ".git", "main_test.syn" },
				capabilities = capabilities,
			}
			vim.lsp.enable("synovium")
			-- ==========================================

			-- 2. Define Mason-managed servers
			local servers = {
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = { command = "clippy" },
						},
					},
				},
				ts_ls = {},
				elixirls = {
					cmd = { "elixir-ls" },
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
			}

			-- Ensure servers and tools are installed
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
				"prettierd",
				"black",
				"shfmt",
				"goimports-reviser",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- 3. Mason-LspConfig handler using the new 0.11 API
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server_opts = servers[server_name] or {}
						server_opts.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})

						-- Merge settings into the native config table and enable
						vim.lsp.config[server_name] =
							vim.tbl_deep_extend("force", vim.lsp.config[server_name] or {}, server_opts)
						vim.lsp.enable(server_name)
					end,
				},
			})
		end,
	},

	-- Autocompletion Engine Setup
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.set_config({ region_check_events = "InsertEnter", delete_check_events = "InsertLeave" })

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				-- Tiered priority sources to prevent buffer/path from overwhelming LSP
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "crates" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- Additional language support plugins
	{ "fladson/vim-kitty" },
	{ "peterhoeg/vim-qml" },
	{ "norcalli/nvim-colorizer.lua" },
	{ "Dr-42/error-jump.nvim", name = "error-jump" },
	{ "elkowar/yuck.vim" },
	{ "petRUShka/vim-opencl" },

	-- Format on save
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				css = { "prettierd" },
				html = { "prettierd" },
				javascript = { "prettierd" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				python = { "black" },
				sh = { "shfmt" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "prettierd" },
				yaml = { "prettierd" },
				go = { "goimports-reviser", "gofmt" },
			},
		},
	},

	-- Cargo/Crates support
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				cmp = { enabled = true },
			},
		},
	},
}
