local M = {}

local function configure()
    local dap_breakpoint = {
        error = {
            text = "",
            texthl = "LspDiagnosticsSignError",
            linehl = "",
            numhl = "",
        },
        rejected = {
          text = "",
          texthl = "LspDiagnosticsSignHint",
          linehl = "",
          numhl = "",
        },
        conditional = {
          text = "",
          texthl = "LspDiagnosticsSignError",
          linehl = "",
          numhl = "",
        },
        log = {
          text = "",
          texthl = "LspDiagnosticsSignError",
          linehl = "",
          numhl = "",
        }
    }
    vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
    vim.fn.sign_define("DapBreakpointCondition", dap_breakpoint.conditional)
    vim.fn.sign_define("DapLogPoint", dap_breakpoint.log)
    vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
end


local function configure_exts()
    local dap, dapui = require "dap", require "dapui"
    dapui.setup {} -- use default
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

function M.setup()
    configure() -- Configuration
    configure_exts() -- Extensions
    require('mason-nvim-dap').setup_handlers()
    require("lazy.config.dap.keymaps") -- Keymaps
end

return M
