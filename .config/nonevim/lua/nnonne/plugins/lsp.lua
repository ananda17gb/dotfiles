-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/lsp.lua
local M = {}

local pack = require("nnonne.commands.pack")
-- local mason_utils = require("nnonne.commands.mason")
local lsp_tools = require("nnonne.plugins.lsp-manager")

function M.setup()
  pack.add({
    -- "mason.nvim",
    "conform.nvim",
    "nvim-lint",
    "nvim-lspconfig",
    -- "mason-lspconfig.nvim",
    "import.nvim",
    "telescope.nvim",
    "workspace-diagnostics.nvim",
    "lazydev.nvim",
    "blink.cmp"
  })

  -- require("mason").setup({})
  -- require("mason-lspconfig").setup({})

  vim.lsp.config("*", {
    on_attach = function(client, bufnr)
      if client.name == "harper_ls" then
        return
      end

      pcall(function()
        if client:supports_method("textDocument/diagnostic") then
          return
        else
          require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
        end
      end)
    end,
  })


  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snipvtslspetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.lsp.config("*", { capabilities = capabilities })

  -- local function get_typescript_server_path()
  --   -- Look into mise's standard installations directory
  --   local global_ts_path = vim.fn.expand("~/.local/share/mise/installs/npm-typescript")
  --   local match = vim.fn.glob(global_ts_path .. "/*/lib/node_modules/typescript/lib")
  --   if match ~= "" then
  --     return match
  --   end
  --   return nil
  -- end
  -- local function get_typescript_server_path()
  --   -- 1. Check local project workspace first
  --   local root = vim.fs.dirname(vim.fs.find({ "package.json", ".git" }, { upward = true })[1] or "")
  --   local local_ts = root .. "/node_modules/typescript/lib"
  --   if vim.fn.isdirectory(local_ts) == 1 then
  --     return local_ts
  --   end
  --
  --   -- 2. Mise aube store path for npm:typescript
  --   local mise_ts = vim.fn.expand(
  --     "~/.local/share/mise/installs/npm-typescript/latest/node_modules/.aube/typescript@7.0.2/node_modules/typescript/lib")
  --   if vim.fn.isdirectory(mise_ts) == 1 then
  --     return mise_ts
  --   end
  --
  --   -- 3. Dynamic search in mise as a fallback if the version changes (e.g. not 7.0.2)
  --   local matches = vim.fn.glob(
  --     vim.fn.expand("~/.local/share/mise/installs/npm-typescript/**/node_modules/typescript/lib"), false, true)
  --   if #matches > 0 then
  --     return matches[1]
  --   end
  --
  --   return nil
  -- end
  -- local ts_path = get_typescript_server_path()
  -- -- Override ts_ls explicitly
  -- vim.lsp.config("ts_ls", {
  --   init_options = {
  --     hostInfo = "neovim",
  --     tsserver = {
  --       path = ts_path,
  --       fallbackPath = ts_path,
  --     }
  --   }
  -- })
  -- -- Override ts_ls explicitly to inject the initialization option
  -- vim.lsp.config("ts_ls", {
  --   init_options = {
  --     hostInfo = "neovim",
  --     tsserver = {
  --       path = get_typescript_server_path()
  --     }
  --   }
  -- })

  vim.lsp.config("vtsls", {
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
      },
    },
  })

  vim.lsp.config("sqls", {
    on_attach = function(client, bufnr)
      -- Disable sqls formatting capabilities to prevent AST crashes
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      -- Optional: bind sqls buffer commands if you use sqllinks/connections
      require('sqls').on_attach(client, bufnr)
    end,
  })

  vim.lsp.config("lua_ls", {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = {
          globals = { "vim" },
        },
        format = {
          enable = true, -- This is default, but ensures lua_ls formatting is awake!
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          }
        },
        completion = {
          callSnippet = "Replace",
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false }
      },
    },
  })

  vim.lsp.config("harper_ls", {
    filetypes = { "markdown" },
  })

  local ft_scope = {
    astro       = { "astro" },
    pylsp       = { "python" },
    ruff        = { "python" },
    bashls      = { "sh", "bash", "zsh" },
    cssls       = { "css", "scss", "less" },
    eslint      = { "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
    gradle_ls   = { "groovy", "gradle" },
    groovyls    = { "groovy" },
    html        = { "html" },
    jsonls      = { "json", "jsonc" },
    tailwindcss = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
    -- ts_ls       = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    vtsls       = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    yamlls      = { "yaml" },
    clangd      = { "c", "cpp" },
    biome       = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
    marksman    = { "markdown" },
    tombi       = { "toml" },
    lua_ls      = { "lua" },
    prismals    = { "prisma" },
    sqls        = { "sql" },
  }

  for server, fts in pairs(ft_scope) do
    vim.lsp.config(server, { filetypes = fts })
  end

  vim.lsp.enable(lsp_tools.lsp_names())

  require("import").setup({
    picker = "telescope",
  })

  vim.keymap.set("n", "<leader>i", function()
    require("import").pick()
  end, { desc = "Import" })

  require("conform").setup({
    format_after_save = {
      timeout_ms = 2500,
      lsp_fallback = true,
    },
    formatters_by_ft = vim.tbl_extend("force", lsp_tools.formatters_by_ft(), { lua = {} }),
    formatters = {
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
      prettier = {
        -- Pass default flags or prevent requiring a config file
        args = { "--stdin-filepath", "$FILENAME" },
      },
    }
  })


  -- Trigger nvim-lint automatically on save, read, and leaving insert mode
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function()
      local lint = require("lint")
      local ft = vim.bo.filetype

      -- 1. Check if the linters for this filetype are wrapped in a function
      if type(lint.linters_by_ft[ft]) == "function" then
        -- 2. Force evaluate the function to get the actual table of linters,
        --    then temporarily pass it to try_lint
        local linters = lint.linters_by_ft[ft]()
        lint.try_lint(linters)
      else
        -- 3. If it's a regular table (like markdown), run normally
        lint.try_lint()
      end
    end,
  })


  -- mason_utils.setup_install_defaults_command(lsp_tools.tools)

  vim.lsp.inlay_hint.is_enabled()
end

return M
