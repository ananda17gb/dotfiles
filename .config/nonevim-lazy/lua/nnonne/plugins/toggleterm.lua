return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        else
          return 20
        end
      end,
      direction = "float",
      persist_size = false,
      float_opts = {
        border = "single",
      }
    })

    vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>1ToggleTerm<cr>", { desc = "Toggle floating terminal" })

    local opencode_cmd = "opencode --port"

    -- Create a single, persistent Terminal instance for OpenCode
    local Terminal = require("toggleterm.terminal").Terminal
    local opencode_term = Terminal:new({
      count = 2,
      cmd = opencode_cmd,
      hidden = true,
      direction = "vertical", -- Replicating snacks position='right'
    })

    vim.g.opencode_opts = {
      server = {
        start = function()
          opencode_term:open()
        end,
      },
    }

    -- Keymap to toggle OpenCode terminal
    -- Note: If you use <leader> here, avoid using 't' mode to prevent input lag in terminals
    vim.keymap.set({ "n", "t" }, "<leader>ot", function()
      opencode_term:toggle()
    end, { desc = "Toggle OpenCode" })

    -- Optional: Show the terminal pane upon submitting a prompt
    vim.api.nvim_create_autocmd("User", {
      pattern = { "OpencodeEvent:tui.command.execute" },
      callback = function(args)
        local event = args.data.event
        if event.properties.command == "prompt.submit" then
          -- Open the terminal only if it isn't already visible
          if not opencode_term:is_open() then
            opencode_term:open()
          end
        end
      end,
    })
  end
}
