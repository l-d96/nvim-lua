"" Markdown
" compile to beamer (presentation)
nnoremap <buffer><silent> <localleader>b :make -o beamer %<CR>
" compile to html
nnoremap <buffer><silent> <localleader>h :make -o html %<CR>
" open the result
nnoremap <buffer><silent> <localleader>o :!xdg-open %:r.pdf &<CR>:redraw!<CR>
