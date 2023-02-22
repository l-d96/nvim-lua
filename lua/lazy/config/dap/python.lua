local M = {}

function M.setup(_)
  require("dap-python").setup(os.getenv("HOME") .. '/.venv/neovim/bin/python')
end

return M
