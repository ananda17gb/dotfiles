return {
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
    },
    ft = { "markdown", "html", },
    config = function()
      local backend = "kitty"
      local term = os.getenv("TERM") or ""
      local term_program = os.getenv("TERM_PROGRAM") or ""

      if term_program:lower() == "kitty" or term:lower():match("kitty") then
        backend = "kitty"
      elseif term:lower():match("foot") then
        backend = "sixel"
      end

      require("image").setup({
        backend = backend,
        processor = "magick_cli",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            only_render_image_at_cursor_mode = "popup", -- or "inline"
            floating_windows = false,                   -- if true, images will be rendered in floating markdown windows
            filetypes = { "markdown", "vimwiki" },      -- markdown extensions (ie. quarto) can go here
          },
          asciidoc = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = "popup",
            floating_windows = false,
            filetypes = { "asciidoc", "adoc" },
          },
          neorg = {
            enabled = true,
            filetypes = { "norg" },
          },
          rst = {
            enabled = true,
          },
          typst = {
            enabled = true,
            filetypes = { "typst" },
          },
          html = {
            enabled = true,
            only_render_image_at_cursor = true,
            only_render_image_at_cursor_mode = "popup", -- or "inline"
            filetypes = { "html", "xhtml", "htm", "markdown" },
          },
          css = {
            enabled = false,
          },
        },
      })
    end
  },
  {
    "hmdfrds/focal.nvim",
    event = "VeryLazy",
    dependencies = {
      "3rd/image.nvim", -- optional if using chafa backend
    },
    opts = {
      -- See Configuration below
    },
  }
}
