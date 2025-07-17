local M = {}

local open_link = function()
	-- vi"gx<Esc>
	vim.cmd.normal('vi"gx')
end

function M.keymaps()
	-- Keymaps for better default experience
	-- See `:help vim.keymap.set()`
	vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

	-- Remap for dealing with word wrap
	vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
	vim.keymap.set("n", "<up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set("n", "<down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

	-- See `:help telescope.builtin`
	vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
	vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<leader>/", function()
		-- You can pass additional configuration to telescope to change theme, layout, etc.
		require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer]" })

	vim.keymap.set("n", "<leader><esc>", require("notify").dismiss, { desc = "[ ] Close all notifications" })

	vim.keymap.set("n", "<leader>lg", require("telescope.builtin").live_grep, { desc = "[L]ive [G]rep" })

	vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

	vim.keymap.set("n", "<leader>fo", ":Oil<CR>", { desc = "[F]ile [O]perator" })
	vim.keymap.set("n", "<leader>fh", ":Telescope file_browser<CR>", { desc = "[F]ile [B]rowser" })
	vim.keymap.set("n", "<leader>fb", ":NvimTreeRefresh | NvimTreeToggle<CR>", { desc = "[F]ile [H]eader" })

	-- Keymaps for better tab management
	vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "[T]ab [N]ew" })
	vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })

	vim.keymap.set("n", "<leader>es", require("error-jump").jump_to_error, { desc = "[E]rror [S]ource" })
	vim.keymap.set("n", "<leader>en", require("error-jump").next_error, { desc = "[E]rror [N]ext" })
	vim.keymap.set("n", "<leader>eN", require("error-jump").next_error, { desc = "[E]rror [N]previous" })
	vim.keymap.set("n", "<leader>ec", require("error-jump").compile, { desc = "[E]rror [C]ompile" })

	-- Diagnostic keymaps
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

	vim.keymap.set("n", "<leader>pb", require("telescope.builtin").buffers, { desc = "[P]ick [B]uffer" })
	vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "[G]it [F]iles" })
	vim.keymap.set("n", "<leader>G", ":Git<CR>", { desc = "[G]it" })

	-- Return to normal mode from terminal
	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })

	-- Pane navigation
	vim.keymap.set("n", "<leader>P<up>", ":split<CR><C-w><up>", { desc = "[P]ane [U]p" })
	vim.keymap.set("n", "<leader>P<down>", ":split<CR><C-w><down>", { desc = "[P]ane [D]own" })
	vim.keymap.set("n", "<leader>P<left>", ":vsplit<CR><C-w><left>", { desc = "[P]ane [L]eft" })
	vim.keymap.set("n", "<leader>P<right>", ":vsplit<CR><C-w><right>", { desc = "[P]ane [R]ight" })

	vim.keymap.set("n", "<leader>Pk", ":split<CR><C-w><up>", { desc = "[P]ane [U]p" })
	vim.keymap.set("n", "<leader>Pj", ":split<CR><C-w><down>", { desc = "[P]ane [D]own" })
	vim.keymap.set("n", "<leader>Ph", ":vsplit<CR><C-w><left>", { desc = "[P]ane [L]eft" })
	vim.keymap.set("n", "<leader>Pl", ":vsplit<CR><C-w><right>", { desc = "[P]ane [R]ight" })
	vim.keymap.set("n", "<leader>pc", "<C-w>c", { desc = "[P]ane [C]lose" })

	vim.keymap.set("n", "<C-up>", "<C-w><up>", { desc = "[P]ane [U]p" })
	vim.keymap.set("n", "<C-down>", "<C-w><down>", { desc = "[P]ane [D]own" })
	vim.keymap.set("n", "<C-left>", "<C-w><left>", { desc = "[P]ane [L]eft" })
	vim.keymap.set("n", "<C-right>", "<C-w><right>", { desc = "[P]ane [R]ight" })

	vim.keymap.set("n", "<C-k>", "<C-w><up>", { desc = "[P]ane [U]p" })
	vim.keymap.set("n", "<C-j>", "<C-w><down>", { desc = "[P]ane [D]own" })
	vim.keymap.set("n", "<C-h>", "<C-w><left>", { desc = "[P]ane [L]eft" })
	vim.keymap.set("n", "<C-l>", "<C-w><right>", { desc = "[P]ane [R]ight" })

	vim.keymap.set("n", "<leader>n", ":bnext<CR>", { desc = "[N]ext buffer" })
	vim.keymap.set("n", "<leader>N", ":bprevious<CR>", { desc = "[N]Previous buffer" })

	vim.keymap.set("n", "<leader>mp", require("mpv").toggle_player, { desc = "[M]usic [P]layer" })
	vim.keymap.set("n", "<leader>ol", open_link, { desc = "[O]pen [L]ink" })

	vim.keymap.set(
		"n",
		"<leader>chg",
		require("spandan.plugins.custom.c_utils").create_guard,
		{ desc = "[C] [H]eader [G]uard" }
	)
	vim.keymap.set(
		"n",
		"<leader>chi",
		require("spandan.plugins.custom.c_utils").create_implementation,
		{ desc = "[C] [H]eader [I]mplementation" }
	)
	vim.keymap.set(
		"n",
		"<leader>chd",
		require("spandan.plugins.custom.c_utils").goto_implementation,
		{ desc = "[C] [H]eader [D]efinition" }
	)
	vim.keymap.set(
		"n",
		"<leader>rt",
		require("spandan.plugins.custom.c_utils").reset_nvim_tabs,
		{ desc = "[R]eset [T]abs" }
	)

	vim.keymap.set("n", "<leader>wso", require("project-manager").open_projects, { desc = "[W]ork[S]pace [O]pen" })
	vim.keymap.set("n", "<leader>wsp", function()
		require("project-manager").open_project_by_key("probe")
	end, { desc = "[W]ork[S]pace [P]robe" })
	vim.keymap.set("n", "<leader>wst", function()
		require("project-manager").open_project_by_key("third_party")
	end, { desc = "[W]ork[S]pace [T]hird Party" })

	-- Zotero integration maps
	-- The defaults are kept as is
	vim.keymap.set("n", "<leader>z", "<Nop>", { desc = "[Z]otero" })
	vim.keymap.set("n", "<leader>zc", function()
		--!pandoc <current-file> -s -o <output-file> -F zotref.py --citeproc --csl <zotero-citation-style>
		-- Current file is the current buffer's file name
		-- Ouput file is taken from vim input
		-- Zotero citation style is a csl file. If multiple are present in the current dir, the first one is used
		local current_file = vim.fn.expand("%")
		-- Escape special characters
		current_file = vim.fn.shellescape(current_file)

		local output_file = vim.fn.input("Enter output file: ")
		local csl_files = vim.fn.glob("*.csl")
		local zotero_citation_style = csl_files
		local cmd = "!pandoc "
			.. current_file
			.. " -s -o "
			.. output_file
			.. " -F zotref.py --pdf-engine xelatex --citeproc --csl "
			.. zotero_citation_style
		vim.cmd(cmd)
	end, { desc = "[Z]otero [C]ompile" })
end

return M
