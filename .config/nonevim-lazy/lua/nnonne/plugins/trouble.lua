return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>xx",
      function()
        require("trouble").toggle({
          mode = "diagnostics",
          filter = {
            {
              severity = vim.diagnostic.severity.ERROR,
              function(item)
                return item.filename:find((vim.uv or vim.loop).cwd(), 1, true)
              end,
            },
          },
        })
      end,
      desc = "Workspace Diagnostics",
    },
  }
}
