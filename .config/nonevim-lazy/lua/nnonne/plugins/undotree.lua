return {
  "mbbill/undotree",
  config = function()
    vim.cmd("packadd nvim.undotree")
    vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Toggle Undotree" })
  end,
}
