return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
    },
    inlay_hints = {
      enabled = true,
      exclude = { "vue" },
    },
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace",
            },
            doc = {
              privateName = { "^_" },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      },
      vtsls = {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        settings = {
          javascript = {
            checkJs = true,
            suggest = {
              autoImports = true,
              completeFunctionCalls = true,
            },
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
          typescript = {
            suggest = {
              autoImports = true,
              completeFunctionCalls = true,
            },
            preferences = {
              importModuleSpecifier = "non-relative",
            },
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
        },
      },
      prisma_ls = {
        filetypes = { "prisma" },
      },
      tailwindcss = {
        filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      html = {},
      cssls = {
        filetypes = { "css", "scss", "less" },
      },
      jsonls = {
        filetypes = { "json", "jsonc" },
      },
      eslint = {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      groovyls = {
        filetypes = { "groovy" },
        enabled = vim.fn.executable("groovy-language-server") == 1,
      },
      gradle_ls = {
        filetypes = { "groovy", "gradle" },
        enabled = vim.fn.executable("gradle-language-server") == 1,
      },
    },
  },
  config = function(_, opts)
    local blink = require("blink.cmp")

    -- 1. Setup Diagnostics
    vim.diagnostic.config(opts.diagnostics)

    -- 2. Base Capabilities via blink.cmp
    local capabilities = blink.get_lsp_capabilities({
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    })

    -- 3. Set global defaults using vim.lsp.config('*', ...)
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- 4. Global LSP Keymaps & Inlay Hints via LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local map_opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, map_opts)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, map_opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, map_opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, map_opts)

        if opts.inlay_hints.enabled and client and client.server_capabilities.inlayHintProvider then
          local ft = vim.bo[ev.buf].filetype
          if not vim.tbl_contains(opts.inlay_hints.exclude or {}, ft) then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end
      end,
    })

    -- 5. Register server configurations and enable them natively
    for server, server_opts in pairs(opts.servers) do
      if server_opts and server_opts.enabled ~= false then
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
    end
  end,
}
