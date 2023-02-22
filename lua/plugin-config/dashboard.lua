local M = {}

local function configure()
    local home = os.getenv('HOME')
    local db = require('dashboard')
    -- db.preview_command = 'cat | lolcat'
    -- db.preview_file_path = home .. '/.config/nvim/static/neovim.txt'
    -- db.preview_file_height = 9
    -- db.preview_file_width = 55
    db.session_directory = home .. '/.cache/nvim/sessions'
    db.default_banner = {
        '',
        '',
        ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
        ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
        ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
        ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
        ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
        ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
        ''
    }
    db.custom_footer = function()
        local date = os.date()
        return {"Welcome back! Today is ", date}
    end
    db.custom_center = {
        {
            icon = '  ',
            desc = 'New file                                       ',
            shortcut = '',
            action ="enew | lua require'lualine'.setup()"},
        {
            icon = '  ',
            desc = 'Recently opened session                 ',
            shortcut = 'SPC s l',
            action ='SessionLoad'},
        {
            icon = '  ',
            desc = 'Recently opened files                   ',
            action =  'Telescope oldfiles',
            shortcut = 'SPC f h'},
        {
            icon = '  ',
            desc = 'Find  File                              ',
            action = 'Telescope find_files find_command=rg,--hidden,--files',
            shortcut = 'SPC f f'},
        {
            icon = '  ',
            desc = 'Find  word                              ',
            action = 'Telescope live_grep',
            shortcut = 'SPC f w'},
        {
            icon = '  ',
            desc = 'Project Browser                         ',
            action =  'Telescope find_files cwd=' .. home .. '/Desktop/Projects',
            shortcut = 'SPC f p'},
        {
            icon = '  ',
            desc = 'Open Personal Scripts                   ',
            action = 'Telescope find_files cwd=' .. home .. '/.scripts',
            shortcut = 'SPC f s'},
        {
            icon = '  ',
            desc = 'Open Personal Wikis                     ',
            action = 'lua require"plugins.wiki-picker".wiki_picker()',
            shortcut = 'SPC w s'},
      }
end

function M.setup()
    configure()
end

return M
