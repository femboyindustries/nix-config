" let g:hoogle_search_count = 20
" au BufNewFile,BufRead *.hs map <silent> <F1> :Hoogle<CR>
" au BufNewFile,BufRead *.hs map <silent> <C-c> :HoogleClose<CR>

nnoremap <C-t>n :NERDTreeFocus<CR>
map <C-t>f :NERDTreeToggle<CR>
map <C-t>s :NERDTreeFind<CR>

" let g:hoogle_fzf_cache_file = '~/.cache/fzf-hoogle/cache.json'
" nnoremap <leader>h :Hoogle <CR>

let g:vimtex_compiler_method = 'tectonic'
