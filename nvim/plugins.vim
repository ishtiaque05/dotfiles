call plug#begin('~/.config/nvim/plugged')

" Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-repeat' | Plug 'tpope/vim-surround'

Plug 'ervandew/supertab'                " tab completion
Plug 'yggdroot/indentline'              " show verticl line at each indent
Plug 'ctrlpvim/ctrlp.vim'               " search for file

Plug 'tpope/vim-commentary'             " comment out target line
Plug 'tpope/vim-endwise'                " auto insert end tag

Plug 'neomake/neomake'                  " style checker
Plug 'davidhalter/jedi-vim'             " autocomplete

Plug 'digitaltoad/vim-jade'             " jade template
Plug 'rust-lang/rust.vim'               " rust
Plug 'mattn/webapi-vim'                 " 
Plug 'tkztmk/vim-vala'                  " vala syntax
Plug 'elixir-lang/vim-elixir'           " elixir
Plug 'andreshazard/vim-freemarker'      " freemarker

Plug 'bling/vim-bufferline'             " bufferline
Plug 'vim-airline/vim-airline'          " airlne
Plug 'vim-airline/vim-airline-themes'   " airline themes

Plug 'airblade/vim-gitgutter'           " git
Plug 'tpope/vim-fugitive'               " git
Plug 'phleet/vim-mercenary'             " mercurial
" Plug 'ludovicchabant/vim-lawrencium'    " mercurial
Plug 'mhinz/vim-signify'                " mercurial sunversion

Plug 'mileszs/ack.vim'                  " search enhance

Plug 'Raimondi/delimitMate'             " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'tfnico/vim-gradle'                " vim gradle support
Plug 'Scuilion/gradle-syntastic-plugin' " vim syntactic

call plug#end()

let g:airline_powerline_fonts = 1
let g:airline_detect_paste    = 1
let g:airline_detect_crypt    = 1

let g:airline#extensions#branch#use_vcscommand = 1
let g:airline#extensions#branch#enabled        = 1
let g:airline#extensions#bufferline#enabled    = 1
let g:airline#extensions#branch#vcs_priority   = ["mercurial", "git"]
let g:airline#extensions#syntastic#enabled     = 1
let g:airline#extensions#whitespace#checks     = ['indent', 'trailing', 'long', 'mixed-indent-file']
let g:airline#extensions#tabline#enabled       = 1

let g:syntastic_java_checkers                  =['javac']
let g:syntastic_java_javac_config_file_enabled = 1

let g:ctrlp_dotfiles = 1

" vinegar settings
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" open NERDTree by default
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTreeToggle | endif

" nmap <silent> <leader>k :NERDTreeToggle<cr> " Toggle NERDTree
" nmap <silent> <leader>l :NERDTreeFind<cr>   " Toggle NERDTree
nmap <silent> <C-p> :FZF<cr>
