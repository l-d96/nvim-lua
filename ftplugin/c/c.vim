"" C
packadd termdebug
nnoremap <buffer> <silent> <localleader>x :!./%:r.out<CR>
nnoremap <buffer> <silent> <localleader>c :make %<CR>:!./%:r.out<CR>
nnoremap <buffer><silent> <M-CR> <ESC>A;<ESC>
inoremap <buffer><silent> <M-CR> <ESC>A;
let b:SuperTabContextTextMemberPatterns = ['#']
