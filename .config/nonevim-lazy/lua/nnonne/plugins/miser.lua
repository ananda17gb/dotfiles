return {
  "carldaws/miser.nvim",
  event = "VeryLazy",
  config = function()
    require("miser").setup({
      auto_install = false,                                    -- run `mise install` on startup
      auto_format = false,                                     -- format on save (registry first, LSP fallback)
      auto_lsp = false,                                        -- enable LSPs from mise tools
      registry = {},                                           -- override or extend the built-in registry
      task_runner = nil,                                       -- function(cmd_string) -> ... (default: terminal split)
      task_keymaps = { enabled = true, prefix = "<leader>m" }, -- bind <prefix><alias> for tasks with an `alias`
    })
  end,
}
