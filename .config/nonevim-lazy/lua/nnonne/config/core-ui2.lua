local M = {}

function M.setup()
  -- source https://www.reddit.com/r/neovim/comments/1sa95g4/no_more_press_enter_with_ui2_with_example/
  require("vim._core.ui2").enable({
    enable = true,
    msg = {
      targets = {
        [""] = "msg",
        empty = "cmd",
        bufwrite = "msg",
        confirm = "cmd",
        emsg = "pager",
        echo = "msg",
        echomsg = "msg",
        echoerr = "pager",
        completion = "cmd",
        list_cmd = "pager",
        lua_error = "pager",
        lua_print = "msg",
        progress = "pager",
        rpc_error = "pager",
        quickfix = "msg",
        search_cmd = "cmd",
        search_count = "cmd",
        shell_cmd = "pager",
        shell_err = "pager",
        shell_out = "pager",
        shell_ret = "msg",
        undo = "msg",
        verbose = "pager",
        wildlist = "cmd",
        wmsg = "msg",
        typed_cmd = "cmd",
      },
      cmd = {
        height = 0.5,
      },
      dialog = {
        height = 0.5,
      },
      msg = {
        height = 0.3,
        timeout = 5000,
      },
      pager = {
        height = 0.5,
      },
    },
  })

  -- require('vim._core.ui2').enable({
  --   enable = true,
  --   msg = {
  --     target = "cmd", -- options: cmd(classic), msg(similar to noice)
  --     pager  = { height = 1 },
  --     msg    = { height = 0.5, timeout = 4500 },
  --     dialog = { height = 0.5 },
  --     cmd    = { height = 0.5 },
  --   },
  -- })
end

return M
