return {
  "zenbones-theme/zenbones.nvim",
  dependencies = "rktjmp/lush.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.zenwritten_compat = 1
    vim.cmd.colorscheme('darker-zenwritten')
  end
}
