-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers with relative line numbers
vim.o.relativenumber = true
vim.o.number = true

-- Set tabstop to 4 spaces
vim.o.tabstop = 4

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
  vim.o.shell = 'pwsh'
  --vim.o.shell = 'C:/msys64/msys2_shell.cmd -defterm -here -no-start -mingw64 -shell zsh'
end
