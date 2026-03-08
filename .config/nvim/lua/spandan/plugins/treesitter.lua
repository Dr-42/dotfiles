return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	priority = 1000,
	build = ":TSUpdate",

	config = function()
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

		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").synovium = {
					install_info = {
						path = "/home/spandan/Projects/probe/tree-sitter-synovium",
						-- optional entries:
						queries = "/home/spandan/Projects/probe/tree-sitter-synovium/queries", -- also install queries from given directory
					},
				}
			end,
		})

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
