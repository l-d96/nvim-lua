local M = {}

local configure = {
    'css';
    'javascript';
    'html';
}

function M.setup()
    require'colorizer'.setup(configure)
end

return M
