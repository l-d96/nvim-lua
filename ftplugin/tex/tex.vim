"" LaTeX
" use detex and wc to count how many words have been written
nnoremap <buffer><silent> <localleader>wc :echo "Word count: ".system("detex ".@%." \| wc -w")[:-2]." words"<CR>
" Use texdoc as keywordprogram to look up documentation of a word
nnoremap <buffer><silent> K :!texdoc <cword><CR>:redraw!<CR>
" open the pdf
nnoremap <buffer><silent> <localleader>o :!xdg-open %:r.pdf &<CR>:redraw!<CR>
" invoke help from ArteLaTeX
nnoremap <buffer><silent> <localleader>h :!xdg-open /home/ld/Documents/Manuali/Latex/ArteLaTeX.pdf &<CR>:redraw!<CR>
" symbols table
nnoremap <buffer><silent> <localleader>H :!xdg-open /home/ld/Documents/Manuali/Latex/symbols.pdf &<CR>:redraw!<CR>
" LSP
"setlocal omnifunc=v:lua.vim.lsp.omnifunc
let b:SuperTabContextTextMemberPatterns = ['\\', '{']
