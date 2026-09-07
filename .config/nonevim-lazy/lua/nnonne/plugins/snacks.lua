return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
      notify = true,                           -- show notification when big file detected
      size = 1.5 * 1024 * 1024,                -- 1.5MB
      line_length = 1000,                      -- average line length (useful for minified files)
      -- Enable or disable features when big file detected
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.completion = false
        vim.b.minianimate_disable = true
        vim.b.minihipatterns_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
  },
}
