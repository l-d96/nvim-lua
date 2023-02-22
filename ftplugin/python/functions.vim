hi Message guifg=orange

function! NextChunk()
    execute "normal! j"
    while !(getline(line(".")) =~ '^#') || (getline(line(".")-1) =~ '^#')
        if line(".") == line("$")
            echohl Message | echom "End of file" | echohl None
            break
        endif
        execute "normal! j"
    endwhile
endfunction


function! PrevChunk()
    execute "normal! k"
    while !(getline(line(".")) =~ '^#') || (getline(line(".")-1) =~ '^#')
        if line(".") == 1
            echohl Message | echom "Beginning of file" | echohl None
            break
        endif
        execute "normal! k"
    endwhile
endfunction
