-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Remap leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make all files create with unix line endings
vim.o.fileformat = 'unix'
vim.o.fileformats = 'unix,dos'

local setft = function(exts, ft)
	local mexts = {}
	for _, ext in ipairs(exts) do
		table.insert(mexts, "*." .. ext)
	end
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = mexts,
		callback = function(_ev)
			vim.bo.filetype = ft
		end
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
setft({ "hypr", "conf" }, "hyprlang")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers with relative line numbers
vim.o.relativenumber = true
vim.o.number = true

-- Set tabstop to 4 spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Set width of number columns
vim.o.numberwidth = 2
vim.o.signcolumn = 'auto'

-- Enable mouse mode
vim.o.mouse = 'a'

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
vim.o.completeopt = 'menuone,noselect'

-- Set shell to pwsh on windows
if vim.fn.has 'win32' == 1 then
	vim.o.shell = 'pwsh -NoLogo'
	vim.o.shellcmdflag = '-NoProfile -command'
	vim.o.shellquote = '\"'
	vim.o.shellxquote = ''
	--vim.o.shell = 'C:/msys64/msys2_shell.cmd -defterm -here -no-start -mingw64 -shell zsh'
end

-- Set foldmethod to indent
vim.o.foldmethod = 'indent'
-- Set foldlevelstart to 99
vim.o.foldlevelstart = 99

-- Hide line numbers in terminal windows
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]
