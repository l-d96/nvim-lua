-- this toggles virtual text into floating
-- window.
vim.g.virtual_active = false
function _G.toggle_diagnostics()
  if vim.g.virtual_active then
    vim.g.virtual_active = false
    vim.diagnostic.config({virtual_text = false})
  else
    vim.g.virtual_active = true
    vim.diagnostic.config({virtual_text = true})
  end
end

-- This toggles diagnostics altogehter
vim.g.diagnostic_visible = true
function _G.hide_diagnostics()
    if vim.g.diagnostic_visible then
        vim.g.diagnostic_visible = false
        vim.diagnostic.disable()
    else
        vim.g.diagnostic_visible = true
        vim.diagnostic.enable()
    end
end


-- This will switch between virtual text and floating window diagnostic
vim.cmd([[augroup LSP
    autocmd!
    autocmd CursorHold * lua if not vim.g.virtual_active and vim.g.diagnostic_visible then vim.diagnostic.open_float(0, {scope = "cursor", focusable = false}) end
augroup END]])

vim.cmd(':command! Diagnostics :call v:lua.hide_diagnostics()')
vim.cmd(':command! Virtual :call v:lua.toggle_diagnostics()')
-- vim.api.nvim_set_keymap('n', '<leader>vt', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>tt', ':call v:lua.hide_diagnostics()<CR>',  {noremap = true, silent = true})
