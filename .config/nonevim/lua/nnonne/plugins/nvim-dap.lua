local M = {}

local lazy = require("nnonne.utils.lazy")
local pack = require("nnonne.commands.pack")

local function with_dap(fn)
  lazy.load_once('dap', pack.pluglist({ 'nvim-dap' }), function() end)
  fn()
end

function M.setup()
  vim.keymap.set("n", "<leader>Dc", function()
    require("dap").continue()
  end, { desc = "DAP: Start/Continue Session" })

  vim.keymap.set("n", "<leader>Db", function()
    require("dap").toggle_breakpoint()
  end, { desc = "DAP: Toggle Breakpoint" })

  vim.keymap.set("n", "<leader>Di", function()
    require("dap").step_into()
  end, { desc = "DAP: Step Into" })

  vim.keymap.set("n", "<leader>Do", function()
    require("dap").step_over()
  end, { desc = "DAP: Step Over" })

  vim.keymap.set("n", "<leader>Dx", function()
    require("dap").step_out()
  end, { desc = "DAP: Step Out" })

  vim.keymap.set("n", "<leader>Dq", function()
    require("dap").terminate()
  end, { desc = "DAP: Stop Debugging" })
end

return M
