" Highlight groups
" {{{
hi Warning guifg=red
hi Message guifg=orange
" }}}

" Variables
" {{{

" id of terminal job
let t:term_id = -1
" id of terminal buffer
let t:term_buf = -1
" New terminal window ratio size
let g:window_ratio_vert = 0.35
let g:window_ratio_hor = 0.3
" when to switch from vertical to horizontal
let g:switch_to_horizontal = 100

"}}}

" Functions
"{{{

" create horizontal terminal
function! s:HorTerm(cmd)
    " if terminal does not exist, create it, with specified proportions
    if t:term_buf ==# -1
        exec float2nr(nvim_list_uis()[0].height*g:window_ratio_hor).'new | call termopen("' . a:cmd . '")'
        " determine terminal id and buffer
        let t:term_id = b:terminal_job_id
        let t:term_buf = bufnr()
        " ESC goes to normal mode, but only for this kind of terminal
        tnoremap <buffer><silent> <ESC> <C-\><C-n>
        let &filetype = 'terminal'
        " fix terminal height
        setlocal winfixheight
        setlocal nocursorline
        " jump to original window
        exec "wincmd p | stopinsert"
    else
        " if it exists, open current iteration
        exec 'sbuffer +resize'.float2nr(nvim_list_uis()[0].height*g:window_ratio_hor).' '.t:term_buf
        " fix terminal height
        setlocal winfixheight
        setlocal nocursorline
        exec "normal! G"
        " jump to original window
        exec "wincmd p | stopinsert"
    endif
endfunction

" same, but vertical
function! s:VertTerm(cmd)
    if t:term_buf ==# -1
        exec float2nr(nvim_list_uis()[0].width*g:window_ratio_vert)."vnew \| call termopen(\"" . a:cmd . "\")"
        let t:term_id = b:terminal_job_id
        let t:term_buf = bufnr()
        tnoremap <buffer><silent> <ESC> <C-\><C-n>
        let &filetype = 'terminal'
        " fix terminal width
        setlocal winfixwidth
        setlocal nocursorline
        " jump to original window
        exec "wincmd p | stopinsert"
    else
        exec 'vert sbuffer '.t:term_buf.' | vertical resize'.float2nr(nvim_list_uis()[0].width*g:window_ratio_vert)
        " fix terminal width
        setlocal winfixwidth
        setlocal nocursorline
        exec "normal! G"
        " jump to original window
        exec "wincmd p | stopinsert"
    endif
endfunction

" create terminal
function! CreateTerm(layout, cmd)
    " if window's open, send warning
    let l:winbuf = bufwinnr(t:term_buf)
    if l:winbuf != -1
        echohl Warning | echom "A terminal is already open!" | echohl None
        return
    endif

    " else create it
    if a:layout ==# "vert"
        call <SID>VertTerm(a:cmd)
    else
        call <SID>HorTerm(a:cmd)
    endif
endfunction

" create terminal dynamically
function! CreateTermDynamic(cmd)
    " if window's open, send warning
    let l:winbuf = bufwinnr(t:term_buf)
    if l:winbuf != -1
        echohl Warning | echom "A terminal is already open!" | echohl None
        return
    endif

    " else create it
    if nvim_list_uis()[0].width >= g:switch_to_horizontal
        call <SID>VertTerm(a:cmd)
    else
        call <SID>HorTerm(a:cmd)
    endif
endfunction

" kill the terminal
function! KillTerm()
    if t:term_id ==# -1
        echohl Warning | echom "No terminal active!" | echohl None
    else
        call chanclose(t:term_id)
        exec 'bd! '.t:term_buf
        let t:term_id = -1
        let t:term_buf = -1
        echohl Message | echom "Terminal Killed" | echohl None
    endif
endfunction

" toggle presence of terminal window (without killing process)
function! ToggleTerm()
    if t:term_id ==# -1
        call CreateTermDynamic(<SID>Interpreter())
    else
        let win_numb = bufwinnr(t:term_buf)
        if win_numb ==# -1
            if nvim_list_uis()[0].width >= g:switch_to_horizontal
                exec 'vert sbuffer '.t:term_buf.' | vertical resize'.float2nr(nvim_list_uis()[0].width*g:window_ratio_vert)
                " fix terminal width
                setlocal winfixwidth
                setlocal nocursorline
                exec "normal! G"
                " jump to original window
                exec "wincmd p | stopinsert"
            else
                exec 'sbuffer +resize'.float2nr(nvim_list_uis()[0].height*g:window_ratio_hor).' '.t:term_buf
                " fix terminal height
                setlocal winfixheight
                setlocal nocursorline
                exec "normal! G"
                " jump to original window
                exec "wincmd p | stopinsert"
            endif
        else
            execute win_numb . " wincmd q"
        endif
    endif
endfunction

" send a command to the terminal
function! SendCmd(cmd)
    if t:term_id ==# -1
        echohl Warning | echom "No terminal active!" | echohl None
    else
        call chansend(t:term_id, a:cmd)
    endif
endfunction

function! ShowLastLine()
    execute bufwinnr(t:term_buf) . "wincmd w"
    execute "normal! G"
    execute "wincmd p"
    stopinsert
endfunction

" send current line to the terminal
function! CurrentLine()
    call SendCmd(getline(".")."\n")
    if bufwinnr(t:term_buf) != -1
        call ShowLastLine()
    endif
endfunction

" send current selection to the terminal
function! CurrentSel()
    call SendCmd(Get_visual_selection()."\n")
    if bufwinnr(t:term_buf) != -1
        call ShowLastLine()
    endif
endfunction

function! CurrentSel_nonewline()
    if (getline("'>") =~ "^    ") || (getline("'>") == '')
        let cmd = Get_visual_selection_nonewline()."\n\n"
    else
        let cmd = Get_visual_selection_nonewline()."\n"
    endif
    call SendCmd(cmd)
    if bufwinnr(t:term_buf) != -1
        call ShowLastLine()
    endif
endfunction

function! DownLine()
    if t:term_id ==# -1
        echohl Warning | echom "No terminal active!" | echohl None
    else
        call CurrentLine()
        execute "normal! j"
    endif
endfunction

function! DownSelection()
    if t:term_id ==# -1
        stopinsert
        echohl Warning | echom "No terminal active!" | echohl None
    else
        call CurrentSel()
        execute "normal! j"
    endif
endfunction

function! DownSelection_nonewline()
    if t:term_id ==# -1
        stopinsert
        echohl Warning | echom "No terminal active!" | echohl None
    else
        call CurrentSel_nonewline()
        execute "normal! j"
    endif
endfunction

function! SendDownLine_Python()
    if t:term_id ==# -1
        echohl Warning | echom "No terminal active!" | echohl None
    elseif ! (getline(".") =~ "^    ") && ! (getline(".") =~ ":$")
        call DownLine()
    else
        call DownLine()
        while 1
            while getline(".") == "" && line(".") != line("$")
                execute "normal! j"
            endwhile

            if getline(".") != "" && ! (getline(".") =~ "^    ")
                call SendCmd("\n")
                break
            endif

            if line(".") == line("$")
                if getline(".") != ""
                    call CurrentLine()
                endif
                call SendCmd("\n")
                break
            endif

            call DownLine()

        endwhile
    endif
endfunction

" send current line to the terminal, stripped of indentation
function! CurrentLine_noIndent()
    call SendCmd(trim(getline("."))."\n")
    if bufwinnr(t:term_buf) != -1
        call ShowLastLine()
    endif
endfunction

function! DownLine_noIndent()
    if t:term_id ==# -1
        echohl Warning | echom "No terminal active!" | echohl None
    else
        call CurrentLine_noIndent()
        execute "normal! j"
    endif
endfunction

" Depending on the file, return a different interpreter
" to be opened with CreateTerm
function! s:Interpreter()
    if &filetype ==# "python" && expand("%:e") ==# "ipynb"
        let interpreter = "ipython --no-autoindent"
    elseif &filetype ==# "python"
        let interpreter = "python"
    elseif &filetype ==# "r" || &filetype ==# "rmd"
        let interpreter = "R"
    elseif &filetype ==# "lua"
        let interpreter = "lua"
    elseif &filetype ==# "perl"
        let interpreter = "perl -de0"
    elseif &filetype ==# "ps1"
        let interpreter = "pwsh"
    elseif &filetype ==# "javascript"
        let interpreter = "node"
    else
        let interpreter = "bash --norc"
    endif

    return interpreter
endfunction

" This is for debugging capabilities
function! s:Debugger()
    if &filetype ==# "python"
        let debugger = "python -m pdb ".expand("%")
    elseif &filetype ==# "c"
        let debugger = "gdb ".expand("%:r").".out"
    else
        echohl Message | echom "No debugger specified for this filetype. Running bash" | echohl None
        call wait(2000, 0)
        let debugger = "bash"
    endif

    return debugger
endfunction
"}}}

" autcmd
" {{{
" Define actions for terminal buffer
augroup terminal_buffer
    autocmd!

    " When you open new tab, set t:term_id and buf to -1
    autocmd TabNew * let t:term_id=-1
    autocmd TabNew * let t:term_buf=-1

    " when move to terminal window, enter into insert mode
    autocmd TermOpen,BufEnter * if &buftype ==# "terminal" | startinsert | endif

    " close terminal window (but not process)
    autocmd TermOpen,BufEnter * if &buftype ==# "terminal" | nnoremap <buffer><silent> <C-\><C-q> :q<CR> | endif
    autocmd TermOpen,BufEnter * if &buftype ==# "terminal" | tnoremap <buffer><silent> <C-\><C-q> <C-\><C-n>:q<CR> | endif

    " Don't show row numbers in terminal
    autocmd TermOpen * if &buftype ==# "terminal" | setlocal nonumber norelativenumber | endif
    " modify statusline
    autocmd TermOpen * if &buftype ==# "terminal" | let &l:statusline="\ %t" | endif
    " Set the buffer to not be listed in bufferlist
    autocmd TermOpen * if &buftype ==# "terminal" | setlocal nobuflisted | endif

augroup END

"}}}

" remaps
" {{{

nnoremap <silent> <Plug>CreateHorTerm :call CreateTerm("hor", <SID>Interpreter())<CR>
nnoremap <silent> <Plug>CreateVertTerm :call CreateTerm("vert", <SID>Interpreter())<CR>
nnoremap <silent> <Plug>CreateDynamicTerm :call CreateTermDynamic(<SID>Interpreter())<CR>
nnoremap <silent> <Plug>CreateDynamicCons :call CreateTermDynamic("bash")<CR>
nnoremap <silent> <Plug>CreateDynamicDebugger :call CreateTermDynamic(<SID>Debugger())<CR>
nnoremap <silent> <Plug>ToggleTerminal :call ToggleTerm()<CR>
nnoremap <silent> <Plug>KillTerminal :call KillTerm()<CR>
nnoremap <silent> <Plug>SendLine :call CurrentLine()<CR>
vnoremap <silent> <Plug>SendSelection :<C-U>call CurrentSel()<CR>
nnoremap <silent> <Plug>SendDownLine :call DownLine()<CR>
noremap <silent> <Plug>ClearTerm :call SendCmd("")<CR>
vnoremap <silent> <Plug>SendDownSelection :<C-U>call DownSelection()<CR>
"}}}
