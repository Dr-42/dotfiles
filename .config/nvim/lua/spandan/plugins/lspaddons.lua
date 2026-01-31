-- plugins/lsp.lua
return {
	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- nvim-cmp integration for LSP completion
			"hrsh7th/cmp-nvim-lsp",

			-- Neodev for better Lua development experience
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- This function gets run when an LSP attaches to a particular buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					map("<leader>TD", require("telescope.builtin").lsp_type_definitions, "[T]ype [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					map("<leader>Ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- Go to declaration.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Hover documentation.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Signature help.
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

					-- Workspace management.
					map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
					map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
					map("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist Folders")

					-- Highlight references on cursor hold.
					local client = vim.lsp.get_client_by_id(event.data.client_id)
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

					-- Toggle inlay hints.
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end

					-- Create a local format command.
					vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
						vim.lsp.buf.format({ async = true })
					end, { desc = "Format current buffer with LSP" })
				end,
			})

			-- Set up capabilities with nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Define server configurations.
			local servers = {
				clangd = {
					capabilities = {
						textDocument = {
							completion = {
								completionItem = {
									snippetSupport = true,
									resolveSupport = {
										properties = { "documentation", "detail", "additionalTextEdits" },
									},
								},
							},
						},
					},
				},
				rust_analyzer = {},
				ts_ls = {
					-- Settings merged from both files for comprehensive TS/Vue support
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
								languages = { "vue" },
							},
						},
					},
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				elixirls = {
					cmd = { "elixir-ls" },
				},
				-- asm_lsp = {
				-- 	cmd = { "asm-lsp" },
				-- 	filetypes = { "asm", "s", "S" },
				-- },
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { disable = { "missing-fields", "incomplete-signature-doc" } },
						},
					},
				},
			}

			-- Ensure servers are installed by Mason.
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"prettierd",
				"black",
				"shfmt",
				"goimports-reviser",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Configure servers with lspconfig.
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
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
					["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous item
					["<C-j>"] = cmp.mapping.select_next_item(), -- Next item
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- Show completion
					["<C-e>"] = cmp.mapping.abort(), -- Close completion
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
				}),
				-- Order of sources matters.
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "crates" },
				}),
			})
		end,
	},

	-- Rust-specific tooling
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		ft = { "rust" },
	},

	-- Haskell tools
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^4",
		lazy = false,
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
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

	-- Flutter tools
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
		config = true, -- Using default config
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
