local M = {}
local picker = require('plugins.wiki-picker')

M.create_wiki = function()
    local name = vim.fn.input("Name of Wiki: ")
    if name == "" then
        print("No valid name inserted")
        return
    end
    name = '/' .. name .. "_wiki"
    local full_name = picker.config.projectsFolder .. name
    local index = full_name .. '/index.wiki'
    vim.api.nvim_call_function('system', {'mkdir ' .. full_name})
    picker.updateVimwikiList(picker.searchForWikis())
    vim.cmd("edit " .. index)
end

return M
