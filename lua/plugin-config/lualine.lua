-- lualine settings
local function transform_line(line)
    local line = line:gsub('%s*[%[%(%{].*$', '')
    line = line:gsub('%s*:%s*$', '')
    return line
end

local function TreeSitter()
    local scope = require'nvim-treesitter'.statusline({indicator_size=50, transform_fn = transform_line})
    local status
    if scope == "" or scope == "null" then
        status = ""
    else
        status = "</> " .. scope
    end
    return status
end

local function Spelling()
    local status
    if vim.opt.spell._value then
        status =  "暈" .. vim.opt.spelllang._value
    else
        status = ""
    end
    return status
end

local function Branch()
    local branch = " " .. vim.b.gitsigns_head
    return branch
end

local function FileName()
    local bufnr = vim.fn.bufnr()
    local file = vim.fn.bufname(bufnr)
    local statusline = vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
    local modified = vim.fn.getbufvar(bufnr, '&modified')
    local modifiable = vim.fn.getbufvar(bufnr, '&modifiable')
    local readonly = vim.fn.getbufvar(bufnr, '&readonly')
    local terminal_filetype = vim.bo.filetype

    if terminal_filetype == "terminal" then
        statusline = '' .. ' ' .. statusline:gsub('^.*:', '')
    elseif modified == 1 then
        statusline = statusline .. ' ' .. ''
    elseif modifiable ~= 1 then
        statusline = statusline .. ' ' .. ''
    elseif readonly == 1 then
        statusline = statusline .. ' ' .. ''
    end

    return statusline
end

local terminal = { sections = { lualine_a = {FileName} }, inactive_sections = {lualine_a = {FileName}}, filetypes = {'terminal'} }
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
        'dashboard',
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {FileName},
    lualine_b = {Branch, 'diff', 'diagnostics'},
    lualine_c = {},
    lualine_x = {TreeSitter, Spelling, 'filetype'},
    -- lualine_y = {wpm.wpm, wpm.historic_graph, 'progress'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {FileName},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {'quickfix', 'fzf', 'nvim-tree', 'man', terminal}
}
