set number relativenumber
set nohlsearch
set tabstop=4 shiftwidth=4 expandtab

let g:airline#extensions#whitespace#enabled = 0
let g:vimspector_enable_mappings='HUMAN'

nnoremap <C-PageDown> :call vimspector#StepInto()<CR>
nnoremap <C-PageUp> :call vimspector#StepOver()<CR>
nnoremap <C-Home> :call vimspector#StepOut()<CR>


call plug#begin()

Plug 'preservim/nerdtree'

Plug 'vim-airline/vim-airline'
Plug 'dylanaraps/wal.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tikhomirov/vim-glsl'

Plug 'tpope/vim-fugitive'
Plug 'puremourning/vimspector'

Plug 'aserowy/tmux.nvim'

call plug#end()

let g:rehash256 = 1
colorscheme wal

nnoremap <C-n> :NERDTreeToggle<CR>
