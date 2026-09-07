return {
  "bullets-vim/bullets.vim",
  event = "VeryLazy",
  config = function()
    vim.g.bullets_delete_last_bullet_if_empty = 2
  end
}
