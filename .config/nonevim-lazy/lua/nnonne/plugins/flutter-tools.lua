return {
  'nvim-flutter/flutter-tools.nvim',
  ft = "dart",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  config = function()
    require("flutter-tools").setup({
      ui = {
        border = "rounded",
        notification_style = "native",
      },
      decorations = {
        statusline = {
          app_version = false,
          device = false,
          project_config = false,
        },
      },
      debugger = {
        enabled = true, -- enable nvim-dap integration -- idk have nvim-dap so disabled
        register_configurations = function(paths)
          local dap = require("dap")

          -- Prompt for the device ID before launching
          local device_id = vim.fn.input("Device ID (e.g., emulator-5554): ")
          local extra_args = {}
          if device_id ~= "" then
            extra_args = { "-d", device_id }
          end

          dap.configurations.dart = {
            {
              type = "dart",
              request = "launch",
              name = "Launch Flutter",
              dartSdkPath = paths.dartSdk,
              flutterSdkPath = paths.flutterSdk,
              program = "${workspaceFolder}/lib/main.dart",
              cwd = "${workspaceFolder}",
              args = extra_args, -- Must be a table, not a function
            }
          }
        end,
      },
      root_patterns = { ".git", "pubspec.yaml" },
      widget_guides = { enabled = true },
      closing_tags = {
        highlight = "ErrorMsg",
        prefix = ">",
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "15split",
        focus_on_open = true,
      },
      outline = {
        open_cmd = "30vnew",
        auto_open = false,
      },
      lsp = {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = {},
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
    })
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        vim.lsp.document_color.enable(true, { bufnr = ev.buf })
      end,
    })
    -- Flutter Keymaps
    vim.keymap.set("n", "<leader>Frn", "<Cmd>FlutterRun<CR>", { desc = "Run project" })
    vim.keymap.set("n", "<leader>Fd", "<Cmd>FlutterDebug<CR>", { desc = "Debug project" })
    vim.keymap.set("n", "<leader>Flt", "<Cmd>FlutterLogToggle<CR>", { desc = "Toggle Dev Log" })
    vim.keymap.set("n", "<leader>Flc", "<Cmd>FlutterLogClear<CR>", { desc = "Clear Dev Log" })
    vim.keymap.set("n", "<leader>Frl", "<Cmd>FlutterReload<CR>", { desc = "Hot Reload" })
    vim.keymap.set("n", "<leader>Frr", "<Cmd>FlutterRestart<CR>", { desc = "Hot Restart" })
    vim.keymap.set("n", "<leader>Fq", "<Cmd>FlutterQuit<CR>", { desc = "Quit app" })
    vim.keymap.set("n", "<leader>Fo", "<Cmd>FlutterOutlineToggle<CR>", { desc = "Toggle Outline" })
    vim.keymap.set("n", "<leader>Fs", "<Cmd>FlutterDevices<CR>", { desc = "Select Device" })
    vim.keymap.set("n", "<leader>Fe", "<Cmd>FlutterEmulators<CR>", { desc = "Select Emulator" })
    vim.keymap.set("n", "<leader>Fv", "<Cmd>FlutterDevTools<CR>", { desc = "Open DevTools" })

    -- Pubspec Keymaps
    vim.keymap.set("n", "<leader>Fpg", "<Cmd>FlutterPubGet<CR>", { desc = "Flutter Pub Get" })
    vim.keymap.set("n", "<leader>Fpu", "<Cmd>FlutterPubUpgrade<CR>", { desc = "Flutter Pub Upgrade" })
    vim.keymap.set("n", "<leader>Fpc", function()
      require("toggleterm.terminal").Terminal:new({ cmd = "flutter clean", hidden = true }):toggle()
    end, { desc = "Flutter Clean" })
  end
}
