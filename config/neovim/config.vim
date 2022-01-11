filetype off

let mapleader=','
set shell=/run/current-system/sw/bin/fish

set viewoptions=folds,options,cursor,unix,slash
set encoding=utf-8

set termguicolors

syntax on
set backspace=2
set laststatus=2
set noshowmode

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set number
set numberwidth=1
set cmdheight=3
set textwidth=0
set linebreak
set showmatch
set matchtime=0
set clipboard=unnamedplus
set cursorline

set incsearch
set ignorecase
set smartcase

nnoremap Q <Nop>
nnoremap gQ <Nop>

:tnoremap <Esc> <C-\><C-n>
