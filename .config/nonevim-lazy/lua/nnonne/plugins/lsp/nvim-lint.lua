return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost" },
  config = function()
    local lint = require("lint")

    -- Helper to safely get the binary name/string from a linter spec
    local function get_linter_cmd(name)
      local linter = lint.linters[name]
      if not linter then
        return name
      end
      if type(linter) == "function" then
        linter = linter()
      end
      if type(linter) == "table" then
        if type(linter.cmd) == "function" then
          return linter.cmd()
        end
        return linter.cmd or name
      end
      return name
    end

    -- Helper to select the first available executable linter
    local function first_available(linters)
      for _, name in ipairs(linters) do
        local cmd = get_linter_cmd(name)
        if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
          return { name }
        end
      end
      return {}
    end
    lint.linters_by_ft = {
      javascript = first_available({ "eslint", "eslint_d", }),
      typescript = first_available({ "eslint", "eslint_d", }),
    }

    -- Sandboxing state (default: false / bare execution)
    local use_sandbox = false

    ---@param linter lint.Linter
    ---@return lint.Linter
    local function systemd_run(linter)
      local cwd = vim.fn.getcwd()
      local args = {
        "--user",
        "--collect",
        "--same-dir",
        "--quiet",
        "--pipe",
        "-p", "PrivateUsers=true",
        "-p", "ProtectSystem=true",
        "-p", "PrivateNetwork=true",
        "-p", string.format("BindReadOnlyPaths='%s':'%s'", cwd, cwd),
        "-E", "PATH=" .. (vim.env.PATH or os.getenv("PATH") or ""),
        linter.cmd,
      }
      linter.cmd = "systemd-run"
      vim.list_extend(args, linter.args or {})
      linter.args = args
      return linter
    end

    local function run_linter()
      if use_sandbox then
        lint.try_lint(nil, { wrap_linter = systemd_run })
      else
        lint.try_lint()
      end
    end

    -- User command to toggle sandboxing on the fly
    vim.api.nvim_create_user_command("WrapLint", function()
      use_sandbox = not use_sandbox
      vim.notify(
        "Linter Sandboxing (systemd-run): " .. (use_sandbox and "ENABLED" or "DISABLED"),
        vim.log.levels.INFO
      )
      run_linter()
    end, { desc = "Toggle systemd-run sandboxing for nvim-lint" })

    -- Autocommands
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = run_linter,
    })
  end,
}
