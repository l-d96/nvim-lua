local M = {}

M.pickers = require'telescope.pickers'
M.finders = require("telescope.finders")
M.sorters = require('telescope.sorters')
M.actions = require'telescope.actions'
M.action_state = require'telescope.actions.state'
M.previewer = require'telescope.previewers'

M.home = os.getenv("HOME")

M.config = {
    projectsFolder = M.home .. "/Documents/Wikis", --full path without ~
    maxDepth = 3,
    ignoreFolders = { 'node_modules', '.git', 'mathjax', 'favicons', 'Datasets', 'templates', 'html', 'diary', 'images'},
    rootWikiFolder = '_wiki',
    -- wikiConfig = { syntax='markdown', ext='.md' }
}

M.vimwiki_list_orig = {}
M.updateVimwikiList = function (folders)
    local new_list = vim.fn.copy(M.vimwiki_list_orig)
    for _, f in ipairs(folders) do
        local item = {
            path = M.config.projectsFolder..'/'..f,
            path_html = M.config.projectsFolder .. '/html/' .. f,
            template_path = M.config.projectsFolder .. '/templates',
            template_ext = 'html',
            template_default = 'default',
            nested_syntaxes = {python = 'python', r = 'r'}
        }
        table.insert(new_list, item)
    end
    vim.g.vimwiki_list = new_list
    vim.api.nvim_call_function('vimwiki#vars#init',{})

    return folders
end

-- function to search project folders for root wiki folders (returns system list)
M.searchForWikis = function ()
    local command = 'find ' .. M.config.projectsFolder ..
        ' -maxdepth ' .. M.config.maxDepth
    if #M.config.ignoreFolders > 0 then command = command .. " \\(" end
    for _, f in ipairs(M.config.ignoreFolders) do
        command = command .. " -path '*/"..f.."/*' -prune"
        if next(M.config.ignoreFolders,_) == nil then
            command = command .. " \\) -o"
        else
            command = command .. " -o"
        end
    end
    command = command .. ' -type d -name "*' .. M.config.rootWikiFolder .. '"'
    command = command .. ' -print | '
    command = command .. ' sed s#' .. M.config.projectsFolder .. '/##'
    local list = vim.api.nvim_call_function('systemlist', {command})
    return list
end

M.enter =  function (prompt_bufnr)
    local selected = M.action_state.get_selected_entry()
    if selected then
        local cmd = 'edit! ' .. selected.value
        M.actions.close(prompt_bufnr)
        vim.cmd(cmd)
    else
        M.actions.close(prompt_bufnr)
    end
end

M.wiki_picker = function()
    opts = {
        prompt_title = "Pick a Wiki",
        finder = M.finders.new_table({
            results = M.updateVimwikiList(M.searchForWikis()),
            entry_maker = function(item)
                return {
                    value = M.config.projectsFolder .. '/' .. item .. '/index.wiki',
                    ordinal = item,
                    display = item,
                }
              end
        }),
        sorter = M.sorters.get_generic_fuzzy_sorter({}),
        previewer = M.previewer.new_buffer_previewer {
            title = "Index preview",
            define_preview = function(self, entry, status)
                return require('telescope.config').values.buffer_previewer_maker(entry.value, self.state.bufnr)
            end
        },
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", M.enter)
            map("n", "<CR>", M.enter)
            return true
        end,
    }
    M.picker = M.pickers.new(opts)
    M.picker:find()
end

return M
-- M.wiki_picker()
