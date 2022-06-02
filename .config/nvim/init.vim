set number relativenumber
set nohlsearch

call plug#begin()

Plug 'github/copilot.vim' , { 'branch' : 'release' }

Plug 'preservim/nerdtree'

Plug 'vim-airline/vim-airline'
Plug 'dylanaraps/wal.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

colorscheme wal

nnoremap <C-n> :NERDTreeToggle<CR>
