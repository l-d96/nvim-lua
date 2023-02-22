local M = {}

local configure = {
    filetype_exclude = {'vimwiki', 'text', 'markdown', 'dashboard', 'startify', 'csv', 'nerdtree', 'netrw', 'help', 'rdoc', 'NvimTree', 'calendar', 'keymenu', 'packer', 'mason'},
    buftype_exclude = {'terminal'},
    max_indent_increase = 1,
    show_current_context = true,
    show_current_context_start = false
}

function M.setup()
    require'indent_blankline'.setup(configure)
end

return M
