-- Remap leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make all files create with unix line endings
vim.o.fileformat = 'unix'
vim.o.fileformats = 'unix,dos'

-- Get GLSL file types
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.vert", "*.frag" },
	callback = function(_ev)
		vim.bo.filetype = "glsl"
	end
})

-- Get Assembly file types
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.s", "*.asm" },
	callback = function(_ev)
		vim.bo.filetype = "nasm"
	end
})

-- Get llvmIR file types
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.ll" },
	callback = function(_ev)
		vim.bo.filetype = "llvm"
	end
})

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers with relative line numbers
vim.o.relativenumber = true
vim.o.number = true

-- Set tabstop to 4 spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

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
vim.wo.signcolumn = 'yes'

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

-- Hide line numbers in terminal windows
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]
