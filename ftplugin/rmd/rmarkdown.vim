"" Rmarkdown properties and commands
" print header
if line("$") == 1 && getline(1) == ""
    read /home/ld/Templates/Rmarkdown/rmarkdown.Rmd | 1d | execute "normal! G5k"
    read!date +'\%d/\%m/\%Y'
    execute "normal! Idate: "
    execute "normal! ggjA"
endif

""" R commands and properties
" lookup program
"setlocal keywordprg=Rdoc
setlocal nowrap
" only with Nvim-R
let R_rconsole_width = 54
let R_min_editor_width = 18
let R_objbr_place = 'script,below'
let R_rmdchunk = '``'
let R_openpdf = 1
let R_pdfviewer = "evince"
nmap <buffer><silent> <C-up> <Plug>RPreviousRChunk
nmap <buffer><silent> <C-down> <Plug>RNextRChunk
nmap <buffer><silent> <localleader>sr <Plug>RSaveClose

" for python integration
inoremap <buffer><silent> `p ```{python}<CR>```<up><ESC>f}i
nmap <buffer><silent> <localleader>sr <Plug>RSaveClose
nmap <buffer><silent> <leader><CR> <Plug>RDSendLine
vmap <buffer><silent> <leader><CR> <Plug>RDSendSelection
" for GUI instance
if exists(':GuiFont')
    vmap <buffer><silent> <C-ENTER> <Plug>RDSendSelection
    nmap <buffer><silent> <C-ENTER> <Plug>RDSendLine
    imap <buffer><silent> <C-ENTER> <C-o><Plug>RSendLine
    let R_assign_map = '<M-->'
    execute "inoremap <buffer><silent> <M-.> <ESC>a %>% "
endif                                                 
let b:SuperTabContextTextMemberPatterns = ['\.', '\$', ':', '@']
" LSP
"setlocal omnifunc=v:lua.vim.lsp.omnifunc
"" terminal commands
"nnoremap <buffer><silent> <localleader>ss :call SendCmd("save.image(\".RData\")\n")<CR>
"nnoremap <buffer><silent> <localleader>aa :call SendCmd('source("'.expand("%").'")'."\n")<CR>
"nnoremap <buffer><silent> <localleader>rr :call SendCmd('system("clear")'."\n")<CR>
"nnoremap <buffer><silent> <localleader>rm :call SendCmd('rm(list=ls())'."\n")<CR>
"nnoremap <buffer><silent> <localleader>rt :call SendCmd('rm('.expand("<cword>").')'."\n")<CR>
"nnoremap <buffer><silent> <localleader>ls :call SendCmd('ls()'."\n")<CR>
"nnoremap <buffer><silent> <localleader>pp :call SendCmd('print('.expand("<cword>").')'."\n")<CR>
"vnoremap <buffer><silent> <localleader>pp :call SendCmd('print('.Get_visual_selection().')'."\n")<CR>
"nnoremap <buffer><silent> <localleader>h :call Redir("!Rdoc ".expand("<cword>"))<CR>
"vnoremap <buffer><silent> <localleader>h :<C-U>call Redir("!Rdoc ".Get_visual_selection())<CR>
"nnoremap <buffer><silent> <localleader>e :call Redir('!Rscript -e "example(\"'.expand("<cword>").'\")"')<CR>
"inoremap <buffer><silent> <a--> <C-r>=' <- '<CR>
" LSP
"setlocal omnifunc=v:lua.vim.lsp.omnifunc
"" lookup program
"setlocal keywordprg=Rdoc
"" open the pdf for rmarkdown
"nnoremap <buffer><silent> <localleader>o :!zathura %:r.pdf &<CR>:redraw!<CR>
"" terminal commands
"nnoremap <buffer><silent> <localleader>ss :call SendCmd("save.image(\".RData\")\n")<CR>
"nnoremap <buffer><silent> <localleader>aa :call SendCmd('source("'.expand("%").'")'."\n")<CR>
"nnoremap <buffer><silent> <localleader>rr :call SendCmd('system("clear")'."\n")<CR>
"nnoremap <buffer><silent> <localleader>rm :call SendCmd('rm(list=ls())'."\n")<CR>
"nnoremap <buffer><silent> <localleader>ls :call SendCmd('ls()'."\n")<CR>
"nnoremap <buffer><silent> <localleader>pp :call SendCmd('print('.expand("<cword>").')'."\n")<CR>
"vnoremap <buffer><silent> <localleader>pp :call SendCmd('print('.Get_visual_selection().')'."\n")<CR>
"nnoremap <buffer><silent> <localleader>h :call Redir("!Rdoc ".expand("<cword>"))<CR>
"vnoremap <buffer><silent> <localleader>h :<C-U>call Redir("!Rdoc ".Get_visual_selection())<CR>
"nnoremap <buffer><silent> <localleader>e :call Redir('!Rscript -e "example(\"'.expand("<cword>").'\")"')<CR>
"inoremap <buffer><silent> <a--> <C-r>=' <- '<CR>
