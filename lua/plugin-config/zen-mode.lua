local M = {}

local configure = {
    window = {
        backdrop = 0.90, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 120, -- width of the Zen window
        height = 1, -- height of the Zen window
    }
}

function M.setup()
    require('zen-mode').setup(configure)
end

return M
