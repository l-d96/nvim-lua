-- key-menu settings
vim.o.timeoutlen = 700
require 'key-menu'.set('n', '<Space>')
require 'key-menu'.set('n', '\\')
vim.api.nvim_set_hl(0, 'KeyMenuFloatBorder', {fg="grey40"})

