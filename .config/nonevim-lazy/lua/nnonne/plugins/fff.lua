return {
  'dmtrKovalenko/fff',
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  lazy = false, -- the plugin lazy-initialises itself
  config = function()
    require("fff").setup({
      prompt = "(づ｡◕‿‿◕｡)づ ",
      layout = {
        prompt_position = "top",
      },
      lazy_sync = true,
      debug = { enabled = false, show_scores = false },
    })

    vim.keymap.set("n", "<leader>ff", function()
      require("fff").find_files()
    end, { desc = "Find files - FFF" })
    vim.keymap.set("n", "<leader>fg", function()
      require("fff").live_grep()
    end, { desc = "Grep files - FFF" })
    vim.keymap.set("n", "<leader>fz", function()
      require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
    end, { desc = "Grep files - FFF" })
  end
}
