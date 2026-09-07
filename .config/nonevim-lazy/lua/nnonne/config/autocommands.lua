-- Shout out https://oneofone.dev/post/neovim-diagnostics-float/
-- Floating diagnostic
local group = vim.api.nvim_create_augroup("OoO", { clear = true })

local function au(typ, pattern, cmdOrFn)
  if type(cmdOrFn) == "function" then
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
  else
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
  end
end

au({ "CursorHold" }, nil, function()
  local opts = {
    focusable = false,
    scope = "cursor",
    close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
  }
  vim.diagnostic.open_float(nil, opts)
end)

--

local lsp_doc_highlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable mini.indentscope for specific non-code filetypes",
  pattern = {
    "alpha", -- Disables it specifically on your Alpha Dashboard
    "mason",
    "help",
    "trouble",
    "opencode",
    "toggleterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client_id = tonumber(event.data.client_id)
    local client = client_id and vim.lsp.get_client_by_id(client_id)

    -- Check if the active LSP server supports text document highlighting
    if client and client:supports_method("textDocument/documentHighlight") then
      -- group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

      -- Highlight word references when holding the cursor still
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = lsp_doc_highlight,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights immediately when the cursor moves
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = lsp_doc_highlight,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, bg = "#333738" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bg = "#333738" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, underline = true, bg = "#333738" })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("silent !kitty @ set-spacing padding=0")
    end, 100)
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.cmd("silent !kitty @ set-spacing padding=default")
  end,
})
