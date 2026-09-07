return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature" },
        ["<CR>"] = { "select_and_accept", "fallback" },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = {
          menu = { auto_show = true },
          list = {
            selection = { preselect = false }
          }
        },
      },
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = false,
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        trigger = {
          show_on_accept_on_trigger_character = false,
        },
        list = {
          selection = {
            auto_insert = false,
          },
        },
        menu = {
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label",     gap = 2 },
              { "kind_icon", gap = 1, "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            -- border = "none",
            max_width = math.floor(vim.o.columns * 0.4),
            max_height = math.floor(vim.o.lines * 0.5),
          },
        },
        ghost_text = {
          enabled = false,
          show_with_menu = false
        }
      },
      snippets = { preset = "mini_snippets" },
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        providers = {
          -- lsp = {
          --   fallbacks = { "buffer", "path" },
          -- },
          -- snippets = {
          --   name = "Snippets",
          --   module = "blink.cmp.sources.snippets",
          --   min_keyword_length = 3,
          --   opts = {
          --   },
          -- },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })
  end
}
