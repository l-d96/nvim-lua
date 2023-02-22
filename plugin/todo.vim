function! s:Set_options()
    " get the current UI settings
    let ui = nvim_list_uis()[0]
    " determine width and height
    let width = float2nr(ui.width*0.5)
    let height = float2nr(ui.height*0.5)
    " Create the floating window
    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': height,
                \ 'anchor': 'NW',
                \ 'col': (ui.width/2) - (width/2),
                \ 'row': ((ui.height-4)/2) - (height/2),
                \ 'style': 'minimal',
                \ 'border': 'rounded',
                \ }
    return opts
endfunction

function! s:CreateTODO()
    let l:header = "# TODO list for project directory '".expand("%:p:h:t")."'\n\n* [ ] "
    put! = l:header
    " Go to the end of file
    normal! Gk$
    startinsert!
endfunction

function! s:LastChecked()
    call cursor(1,1)
    let last_checked = search('\* \[ \]')
    if last_checked > 0
        call cursor(last_checked, 1)
    else
        call cursor("$", 1)
    endif
    normal! $zz
endfunction

function! TODO()
    " add TODO.md in the buffer list. This creates
    " a new file in the current directory (that is
    " the directory of the current buffer) if it doesn't
    " exist yet
    let name = expand("%:p:h")."/TODO.md"
    execute "badd ".name
    let buf = bufnr(name)
    " this variable is buffer-specific; if it is set,
    " TODO specific autocommands are triggered
    call nvim_buf_set_var(buf, 'todo', 1)

    let Colors = g:colors_name
    hi TODOBorder guifg=grey40
    let opts = <SID>Set_options()
    let win = nvim_open_win(buf, 1, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Normal,FloatBorder:TODOBorder')
    call setwinvar(win, '&colorcolumn', '')
    setlocal nobuflisted

    " if TODO.txt is empty, intialize the file
    if line("$") ==# 1 && getline(1) ==# ""
        call <SID>CreateTODO()
    else
        call <SID>LastChecked()
    endif

endfunction

nnoremap <silent> <Plug>SpawnTODO :call TODO()<CR>
command! TODO :call TODO()
