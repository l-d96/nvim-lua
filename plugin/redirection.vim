" redirect the output of a Vim or external command into a scratch buffer
function! Redir(cmd)
    if a:cmd =~ '^!'
        execute "let output = system('" . substitute(a:cmd, '^!', '', '') . "')"
    else
        redir => output
        execute a:cmd
        redir END
    endif
    new
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile filetype=help
    call setline(1, split(output, "\n"))
    put! = a:cmd
    put = '----'
    nnoremap <buffer><silent> q :q<CR>
endfunction

function! Get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    call cursor(line_end, column_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! Get_visual_selection_nonewline()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    call cursor(line_end, column_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    let no_newline = []
    for el in lines
        if el != ''
            let no_newline += [el]
        endif
    endfor

    if len(no_newline) == 0
        return ''
    endif

    return join(no_newline, "\n")
endfunction

augroup nofile
    autocmd!
    autocmd BufEnter * if &buftype ==# "nofile" | nnoremap <buffer><silent> q :q<CR> | endif
augroup END

" command for Redir
command! -nargs=1 Redir silent call Redir(<f-args>)
