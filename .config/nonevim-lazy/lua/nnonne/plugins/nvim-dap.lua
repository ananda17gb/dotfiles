return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
  },
  keys = {
    { "<leader>Dc", desc = "DAP: Start/Continue Session" },
    { "<leader>Db", desc = "DAP: Toggle Breakpoint" },
    { "<leader>Di", desc = "DAP: Step Into" },
    { "<leader>Do", desc = "DAP: Step Over" },
    { "<leader>Dx", desc = "DAP: Step Out" },
    { "<leader>Dq", desc = "DAP: Stop Debugging" },
    { "<leader>Du", function() require("dapui").toggle({}) end,    desc = "Dap UI" },
    { "<leader>De", function() require("dapui").eval() end,        desc = "Eval",                     mode = { "n", "x" } },
    { "<leader>Ds", function() require("dap").list_sessions() end, desc = "DAP: List/Switch Sessions" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Set up DAP UI auto-open/close listeners
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end

    local map = function(lhs, action, desc)
      vim.keymap.set("n", lhs, function()
        require("dap")[action]()
      end, { desc = desc })
    end
    map("<leader>Dc", "continue", "DAP: Start/Continue Session")
    map("<leader>Db", "toggle_breakpoint", "DAP: Toggle Breakpoint")
    map("<leader>Di", "step_into", "DAP: Step Into")
    map("<leader>Do", "step_over", "DAP: Step Over")
    map("<leader>Dx", "step_out", "DAP: Step Out")
    map("<leader>Dq", "terminate", "DAP: Stop Debugging")
  end
}
