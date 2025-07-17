-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Remap leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable nerd font
vim.g.have_nerd_font = true

-- Make all files create with unix line endings
vim.o.fileformat = "unix"
vim.o.fileformats = "unix,dos"

local setft = function(exts, ft)
	local mexts = {}
	for _, ext in ipairs(exts) do
		table.insert(mexts, "*." .. ext)
	end
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = mexts,
		callback = function(_ev)
			vim.bo.filetype = ft
		end,
	})
end

-- Set GLSL file types
setft({ "glsl", "vert", "frag", "geom", "comp" }, "glsl")
-- Set Assembly file types
setft({ "s", "asm" }, "nasm")
-- Set llvmIR file types
setft({ "ll" }, "llvm")
-- Set lalrpop file types
setft({ "lalrpop" }, "lalrpop")
-- Set c header file types
setft({ "h" }, "c")

-- Set crust file types
setft({ "crust", "syn" }, "crust")

-- hyprlang
-- setft({ "hypr", "conf" }, "hyprlang")
-- Check if the file path contains hypr
if string.find(vim.fn.expand("%:p"), "hypr") then
	setft({ "hypr", "conf" }, "hyprlang")
end

-- systemd
setft({ "service", "timer", "socket", "target", "swap", "automount" }, "systemd")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers with relative line numbers
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers

vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = true -- Don't wrap lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 4 -- Tab width
vim.opt.shiftwidth = 4 -- Indent width
vim.opt.softtabstop = 4 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line

-- Search settings
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = true -- Don't highlight search results
vim.opt.incsearch = true -- Show matches as you type

vim.opt.colorcolumn = "100" -- Show column at 100 characters
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- How long to show matching bracket

-- File handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Key timeout duration
vim.opt.ttimeoutlen = 0 -- Key code timeout
vim.opt.autoread = true -- Auto reload files changed outside vim
vim.opt.autowrite = true -- Don't auto save

-- Behavior settings
vim.opt.hidden = true -- Allow hidden buffers
vim.opt.errorbells = false -- No error bells
vim.opt.backspace = "indent,eol,start" -- Better backspace behavior
vim.opt.autochdir = false -- Don't auto change directory
vim.opt.iskeyword:append("-") -- Treat dash as part of word
vim.opt.path:append("**") -- include subdirectories in search
vim.opt.selection = "exclusive" -- Selection behavior
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.modifiable = true -- Allow buffer modifications

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

vim.opt.encoding = "UTF-8" -- Set encoding

-- Set width of number columns
vim.o.numberwidth = 2
vim.o.signcolumn = "auto"

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Set shell to pwsh on windows
if vim.fn.has("win32") == 1 then
	vim.o.shell = "pwsh -NoLogo"
	vim.o.shellcmdflag = "-NoProfile -command"
	vim.o.shellquote = '"'
	vim.o.shellxquote = ""
	--vim.o.shell = 'C:/msys64/msys2_shell.cmd -defterm -here -no-start -mingw64 -shell zsh'
end

-- Set foldmethod to indent
vim.o.foldmethod = "indent"
-- Set foldlevelstart to 99
vim.o.foldlevelstart = 99

-- Hide line numbers in terminal windows
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
