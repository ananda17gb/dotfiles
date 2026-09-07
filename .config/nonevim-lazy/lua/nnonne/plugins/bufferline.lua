return {
  "akinsho/bufferline.nvim",
  config = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return icon .. count
        end,
        separator_style = "thick",
        sort_by = "insert_after_current",
      },
    })
  end
}
