return {
  "knubie/vim-kitty-navigator",
  event = "VeryLazy",
  config = function()
    if os.getenv("TERM") == "xterm-kitty" or os.getenv("KITTY_WINDOW_ID") then
    else
      vim.g.loaded_kitty_navigator = 1
      vim.keymap.set("n", "<C-h>", "<C-w>h")
      vim.keymap.set("n", "<C-j>", "<C-w>j")
      vim.keymap.set("n", "<C-k>", "<C-w>k")
      vim.keymap.set("n", "<C-l>", "<C-w>l")
    end
  end
}
