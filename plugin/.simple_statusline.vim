if exists("g:adwaita_darker") && g:adwaita_darker == v:true
    hi User1 gui=bold guifg=#fd971f guibg=#1c1c1c
    hi User2 gui=bold guifg=#A6e22e guibg=#1c1c1c
    hi User3 gui=italic guifg=#7E8E91 guibg=#1c1c1c
    hi User4 gui=bold guifg=#ae81ff guibg=#1c1c1c
else
    hi User1 gui=bold guifg=#fd971f guibg=#303030
    hi User2 gui=bold guifg=#A6e22e guibg=#303030
    hi User3 gui=italic guifg=#7E8E91 guibg=#303030
    hi User4 gui=bold guifg=#ae81ff guibg=#303030
endif


" Display Git branching
function! Branches()
    let branch = FugitiveStatusline()
    if branch ==# ""
        let status  = ""
    else
        let status = "   ".substitute(branch, '^.*(\(.*\)).*$', '\1', '')."  "
    endif

    return status
endfunction

" This function checks if spell is active,
" and show it on the statusline
function! Spelling()
    if &spell
        let status = "(".&spelllang.") "
    else
        let status = ""
    endif

    return status
endfunction

function! TreeSitter()
    let scope = nvim_treesitter#statusline()
    if scope ==# "" || scope ==# "null"
        let status = ""
    else
        let status = " " . scope . "   "
    endif

    return status
endfunction

function! CurDir()
    return b:netrw_curdir
endfunction

" for netrw
augroup netrw
    autocmd!
    autocmd BufAdd * if &filetype ==# "netrw" | let &l:statusline=" %{CurDir()} %r%m" | endif
augroup END


set statusline=%t\%h%m%r%3*%{Spelling()}%*%1*%{Branches()}%*%=%<%2*%{TreeSitter()}%*%-14.(%l,%c%V%)\ %P
