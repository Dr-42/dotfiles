-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	local vmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("v", keys, func, { buffer = bufnr, desc = desc })
	end

	if client.server_capabilities.inlayHintProvider then
		vim.g.inlay_hints_visible = true
		vim.lsp.inlay_hint.enable(true)
	else
		print("no inlay hints available")
	end

	-- vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
	--   config = config or {}
	--   config.focus_id = ctx.method
	--   if not (result and result.contents) then
	--     return
	--   end
	--   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
	--   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
	--   -- Set encoding to utf-8
	--   if vim.tbl_isempty(markdown_lines) then
	--     return
	--   end
	--   return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
	-- end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	vmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>TD", vim.lsp.buf.type_definition, "[T]ype [D]efinition")
	nmap("<leader>Ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols ")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format({
			tabSize = 4,
			insertSpaces = false,
			trimTrailingWhitespace = true,
			insertFinalNewline = true,
		})
	end, { desc = "Format current buffer with LSP" })
end

local servers = {
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	ts_ls = {},
	clangd = {},
	rust_analyzer = {},
	lua_ls = {
		disable = { "missing-fields", "incomplete-signature-doc" },
	},
	elixirls = {},
}

local clangd_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	return capabilities
end

return { -- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			dependencies = {},
			config = function()
				require("mason").setup()
			end,
		},
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
	},
	config = function()
		require("lspconfig").clangd.setup({
			on_attach = on_attach,
			capabilities = clangd_capabilities(),
			cmd = {
				"clangd",
			},
			inlay_hints = {
				enabled = true,
			},
			-- current working directory
			root_dir = function()
				return vim.loop.cwd()
			end,
		})

		require("lspconfig").asm_lsp.setup({
			command = {
				"asm-lsp",
			},
			filetypes = {
				"asm",
				"s",
				"S",
			},
			-- current working directory
			root_dir = function()
				return vim.loop.cwd()
			end,
		})

		require("lspconfig").elixirls.setup({
			cmd = {
				"elixir-ls",
			},
			-- current working directory
			root_dir = function()
				return vim.loop.cwd()
			end,
		})

		-- Setup neovim lua configuration
		require("neodev").setup()
		--
		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})

		-- nvim-cmp setup
		local cmp = require("cmp")
		require("luasnip").config.set_config({
			history = true,
			region_check_events = "InsertEnter",
			delete_check_events = "InsertLeave",
		})
		require("luasnip.loaders.from_vscode").lazy_load() -- loads friendly-snippets, etc.

		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<C-j>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-k>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "crates" },
				{ name = "cmp_zotcite" },
			},
		})

		-- rust setup

		local opts = {
			tools = {
				runnables = {
					use_telescope = true,
				},
				inlay_hints = {
					auto = true,
					show_parameter_hints = true,
					parameter_hints_prefix = "",
					other_hints_prefix = "",
				},
			},

			-- all the opts to send to nvim-lspconfig
			-- these override the defaults set by rust-tools.nvim
			-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
			server = {
				-- on_attach is a callback called when the language server attachs to the buffer
				on_attach = on_attach,
				settings = {
					-- to enable rust-analyzer settings visit:
					-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
					["rust-analyzer"] = {
						-- enable clippy on save
						checkOnSave = {
							command = "clippy",
							allTargets = false,
						},
					},
				},
			},
		}

		require("rust-tools").setup(opts)

		-- Vue
		require("lspconfig").ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
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
					tsserver = {
						useSyntaxServer = false,
					},
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
		})

		require("lspconfig").volar.setup({
			init_options = {
				vue = {
					hybridMode = false,
				},
			},
			settings = {
				typescript = {
					inlayHints = {
						enumMemberValues = {
							enabled = true,
						},
						functionLikeReturnTypes = {
							enabled = true,
						},
						propertyDeclarationTypes = {
							enabled = true,
						},
						parameterTypes = {
							enabled = true,
							suppressWhenArgumentMatchesName = true,
						},
						variableTypes = {
							enabled = true,
						},
					},
				},
			},
		})
	end,
}
