syntax enable
set noerrorbells
set number
set autoindent
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set smartcase
set noswapfile
set incsearch
set hlsearch
set whichwrap+=<,>,[,]
set noshowmode
set cmdheight=1
set laststatus=1

" Clear highlighted search with Ctrl+L
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" If 
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set rtp +=~/.config/nvim

call plug#begin()
Plug 'luochen1990/rainbow'
Plug 'AndrewRadev/tagalong.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ryanoasis/vim-devicons'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='fruit_punch'

Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'

" Plug 'neoclide/coc.nvim'
"let g:coc_global_extensions = ['coc-json', 'coc-python', 'coc-html', 'coc-snippets', 'coc-clangd', 'coc-highlight', 'coc-explorer', 'coc-actions', 'coc-sh']
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

call plug#end()

" Set number & gitgutter colorscheme
highlight LineNr ctermfg=grey
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4
