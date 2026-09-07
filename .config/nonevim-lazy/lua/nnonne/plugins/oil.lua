return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "nvim-mini/mini.nvim", "JezerM/oil-lsp-diagnostics.nvim", "refractalize/oil-git-status.nvim", "malewicz1337/oil-git.nvim" },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      require("oil").setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
          -- "permissions",
          -- "size",
          -- { "mtime", format = "%u%d%m%H%M" },
          "diagnostics",
          "icon",
        },
        -- Buffer-local options to use for oil buffers
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = "yes:2",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = false,
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = false,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        -- Oil will automatically delete hidden buffers after this delay
        -- You can set the delay to false to disable cleanup entirely
        -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          -- Enable or disable LSP file operations
          enabled = true,
          -- Time to wait for LSP file operations to complete before skipping
          timeout_ms = 1000,
          -- Set to true to autosave buffers that are updated with LSP willRenameFiles
          -- Set to "unmodified" to only save unmodified buffers
          autosave_changes = false,
        },
        -- Constrain the cursor to the editable parts of the oil buffer
        -- Set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = "editable",
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<Right>"] = "actions.select",
          ["<S-l>"] = "actions.select",
          ["P"] = "actions.preview",
          ["q"] = "actions.close",
          ["<C-n>"] = "actions.preview_scroll_down",
          ["<C-p>"] = "actions.preview_scroll_up",
          ["<C-l>"] = "actions.preview_scroll_right",
          ["<C-h>"] = "actions.preview_scroll_left",
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-r>"] = "actions.refresh",
          ["cc"] = "actions.yank_entry",
          ["-"] = { "actions.parent", mode = "n" },
          ["<Left>"] = { "actions.parent", mode = "n" },
          ["<S-h>"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
          ["<leader>yf"] = {
            desc = "Copy actual physical file to system clipboard",
            callback = function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()

              if not entry then
                vim.notify("No file under cursor", vim.log.levels.WARN)
                return
              end

              local dir = oil.get_current_dir()
              local full_path = vim.fn.expand(dir .. entry.name)

              -- Detect OS and use the appropriate system clipboard command
              local cmd = {}
              if vim.fn.executable("wl-copy") == 1 then
                -- Linux Wayland: requires wl-clipboard
                -- The mime type "text/uri-list" tells the system clipboard this is a file reference
                cmd = { "wl-copy", "--type", "text/uri-list", "file://" .. full_path }
              elseif vim.fn.executable("xclip") == 1 then
                -- Linux X11: requires xclip
                cmd = { "xclip", "-selection", "clipboard", "-t", "text/uri-list", "-i" }
                -- xclip needs the path piped via stdin, handle it with an inline shell execution
                local file_url = "file://" .. full_path
                vim.fn.system(
                  string.format("echo -n '%s' | xclip -selection clipboard -t text/uri-list", file_url)
                )
                vim.notify("Copied physical file: " .. entry.name, vim.log.levels.INFO)
                return
              else
                vim.notify(
                  "No compatible system clipboard utility found (xclip/wl-copy required on Linux)",
                  vim.log.levels.ERROR
                )
                return
              end

              -- Execute command for macOS or Wayland
              vim.fn.jobstart(cmd, {
                on_exit = function(_, exit_code)
                  if exit_code == 0 then
                    vim.notify("Copied physical file: " .. entry.name, vim.log.levels.INFO)
                  else
                    vim.notify("Failed to copy file to system clipboard", vim.log.levels.ERROR)
                  end
                end,
              })
            end,
          },
          ["gd"] = {
            desc = "Jump straight to system Downloads folder",
            callback = function()
              require("oil").open(vim.fn.expand("~/Downloads"))
            end,
          },
          ["."] = {
            desc = "Snap Oil to the active file's directory",
            callback = function()
              -- 1. Get the window ID of the file sitting behind the Oil float
              local prev_win = vim.api.nvim_eval("win_getid(winnr('#'))")
              if prev_win == 0 then
                return
              end

              -- 2. Grab the buffer name (file path) from that window
              local prev_buf = vim.api.nvim_win_get_buf(prev_win)
              local current_file = vim.api.nvim_buf_get_name(prev_buf)

              -- 3. If it's a valid file, open its parent directory in Oil
              if current_file ~= "" and vim.api.nvim_buf_get_option(prev_buf, "buftype") == "" then
                local target_dir = vim.fn.fnamemodify(current_file, ":h")
                require("oil").open(target_dir)
              else
                vim.notify("Previous buffer is not a valid file", vim.log.levels.WARN)
              end
            end,
          },
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            local m = name:match("^%.")
            return m ~= nil
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
          -- Sort file names with numbers in a more intuitive order for humans.
          -- Can be "fast", true, or false. "fast" will turn it off for large directories.
          natural_order = "fast",
          -- Sort file and directory names case insensitive
          case_insensitive = false,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { "type", "asc" },
            { "name", "asc" },
          },
          -- Customize the highlight group for the file name
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        -- Extra arguments to pass to SCP when moving/copying files over SSH
        extra_scp_args = {},
        -- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
        extra_s3_args = {},
        -- EXPERIMENTAL support for performing file operations with git
        git = {
          -- Return true to automatically git add/mv/rm files
          add = function(path)
            return false
          end,
          mv = function(src_path, dest_path)
            return false
          end,
          rm = function(path)
            return false
          end,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 0,
          -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0.3,
          max_height = 0.4,
          border = "solid",
          win_options = {
            winblend = 0,
          },
          -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = nil,
          -- preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = "right",
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
        -- Configuration for the file preview window
        preview_win = {
          -- Whether the preview window is automatically updated when the cursor is moved
          update_on_cursor_moved = true,
          -- How to open the preview window "load"|"scratch"|"fast_scratch"
          preview_method = "fast_scratch",
          -- A function that returns true to disable preview on a file e.g. to avoid lag
          disable_preview = function(filename)
            local stat = vim.uv.fs_stat(filename)
            if stat and stat.size > 1024 * 1024 then
              return true
            end
            return false
          end,
          -- Window-local options to use for preview window buffers
          win_options = {
            wrap = true,
            signcolumn = "yes:2",
            number = true,
            relativenumber = false,
          },
        },
        -- Configuration for the floating action confirmation window
        confirmation = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
          max_width = 0.5,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
          max_height = 0.5,
          -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
          min_height = { 5, 0.1 },
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = nil,
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating progress window
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = nil,
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating SSH window
        ssh = {
          border = nil,
        },
        -- Configuration for the floating keymaps help window
        keymaps_help = {
          border = nil,
        },
      })

      require("oil-git-status").setup()

      require("oil-git").setup({
        show_ignored_files = true,
        show_ignored_directories = true,
        show_branch = true,
      })

      require("oil-lsp-diagnostics").setup()

      vim.keymap.set("n", "<leader>e", function()
        require("oil").toggle_float()
      end, { desc = "Open parent directory" })
    end
  }
}
