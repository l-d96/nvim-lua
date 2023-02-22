"" Python
compiler pyunit
" " Set folding in Python files
" setlocal foldmethod=indent foldlevel=50
" set dictionary for autocompletion
setlocal dictionary=/home/ld/.config/nvim/words/python/complete-dict
" terminal commands
nnoremap <buffer><silent> <localleader>ph :call Redir("!pydoc ".expand("<cword>"))<CR>
vnoremap <buffer><silent> <localleader>ph :<C-U>call Redir("!pydoc ".Get_visual_selection())<CR>
nnoremap <buffer><silent> <localleader>pp :call SendCmd('print('.expand("<cword>").')'."\n")<CR>
vnoremap <buffer><silent> <localleader>pp :call SendCmd('print('.Get_visual_selection().')'."\n")<CR>

command! Notebook !/home/ld/.miniconda3/bin/jupytext --update --to notebook %
nnoremap <buffer><silent> <localleader>jn :Notebook<CR>

nnoremap <silent><buffer> <C-down> :call NextChunk()<CR>
nnoremap <silent><buffer> <C-up> :call PrevChunk()<CR>

nnoremap <silent><buffer> <localleader><CR> :call DownLine_noIndent()<CR>

nnoremap <buffer><silent> <leader><CR> :call SendDownLine_Python()<CR>
vnoremap <buffer><silent> <leader><CR> :<C-U>call DownSelection_nonewline()<CR>
if exists(':GuiFont') || exists('g:GtkGuiLoaded')
    nnoremap <buffer><silent> <C-ENTER> :call SendDownLine_Python()<CR>
    vnoremap <buffer><silent> <C-ENTER> :<C-U>call DownSelection_nonewline()<CR>
endif
let b:SuperTabContextTextMemberPatterns = ['\.', '@']
