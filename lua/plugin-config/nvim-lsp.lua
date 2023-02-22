local M = {}

function M.setup()
    -- disable virtual text by default
    vim.diagnostic.config({virtual_text = false, float = {border='rounded'}})
    -- require('lazy.config.lsp.lsp-completion-signs')
    require('plugin-config.lsp.lsp-diagnostic-signs')
    require('plugin-config.lsp.lsp-keybindings')
    require('plugin-config.lsp.lsp-toggle-diagnostic')
end

M.setup()
