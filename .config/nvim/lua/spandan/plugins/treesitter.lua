return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	priority = 1000,
	build = ":TSUpdate",

	config = function()
		-- 1. Inject Synovium directly into the parsers table
		require("nvim-treesitter.parsers").synovium = {
			install_info = {
				url = vim.fn.expand("~/Projects/probe/tree-sitter/synovium"),
				files = { "src/parser.c" },
			},
		}

		-- 2. Tell Neovim about your custom filetypes
		vim.filetype.add({
			extension = {
				syn = "synovium",
				synovium = "synovium",
				bend = "bend",
			},
		})

		-- Link the filetypes to their parsers
		vim.treesitter.language.register("synovium", { "synovium" })
		vim.treesitter.language.register("bend", { "bend" })

		-- 3. Install missing standard parsers automatically
		local ts = require("nvim-treesitter")
		local required_parsers = {
			"c",
			"cpp",
			"go",
			"lua",
			"python",
			"rust",
			"typescript",
			"vimdoc",
			"vim",
			"markdown",
			"markdown_inline",
		}

		local installed = ts.get_installed()
		local missing = vim.iter(required_parsers)
			:filter(function(p)
				return not vim.tbl_contains(installed, p)
			end)
			:totable()

		if #missing > 0 then
			ts.install(missing)
		end

		-- 4. Enable highlighting using native Neovim APIs
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				-- pcall safely attempts to start treesitter.
				-- If a parser doesn't exist for the filetype, it silently falls back to standard regex syntax.
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
