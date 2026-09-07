vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_tohtml_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1

vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
vim.g.bullets_enable_in_empty_buffers = 0

vim.g.no_plugin_maps = true -- nvim treesitter textobjects


-- With this option set to true, the plugin will not start automatically. Instead, you'll need to manually initialize it by calling require('cord').setup().
vim.g.cord_defer_startup = true

local opt = vim.opt

-- source https://www.reddit.com/r/neovim/comments/1sa95g4/no_more_press_enter_with_ui2_with_example/
-- opt.cmdheight = 0

-- https://github.com/neovim/neovim/discussions/28010#discussioncomment-9877494
opt.clipboard = "unnamedplus" -- Sync with system clipboard
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

opt.winborder = "single"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2  -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true    -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true  -- Use spaces instead of tabs
opt.autoindent = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
-- vim.opt.colorcolumn = "100"
-- vim.opt.textwidth = 0
vim.opt.linebreak = false
vim.opt.wrap = false
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true     -- Ignore case
opt.inccommand = "split"  -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3        -- global statusline
opt.list = false          -- Show some invisible characters (tabs...
opt.mouse = "a"           -- Enable mouse mode
opt.number = true         -- Print line number
opt.pumblend = 10         -- Popup blend
opt.pumheight = 10        -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false         -- Disable the default ruler
opt.scrolloff = 8         -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true     -- Round indent
opt.shiftwidth = 2        -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false      -- Dont show mode since we have a statusline
opt.sidescrolloff = 8     -- Columns of context
opt.signcolumn = "yes:2"  -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true      -- Don't ignore case with capitals
opt.smartindent = true    -- Insert indents automatically
opt.smarttab = true
opt.smoothscroll = true
opt.spelllang = { "en", "id" }
opt.spell = false
opt.splitbelow = true    -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true    -- Put new windows right of current
opt.tabstop = 2          -- Number of spaces tabs count for
opt.softtabstop = 2      -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 500
opt.ttimeoutlen = 50
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.showcmd = true
opt.swapfile = false
opt.backup = false
opt.undolevels = 10000
opt.undoreload = 10000
opt.updatetime = 300               -- Save swap file and trigger CursorHold
opt.virtualedit = "block"          -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width
opt.hlsearch = true
opt.incsearch = true
opt.background = "dark"
opt.foldenable = true
opt.foldcolumn = "0"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkon400-blinkoff400"

vim.lsp.handlers["$/progress"] = function() end -- to remove lsp progress
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  local default_config = {
    border = "single", -- You can keep your border style here
    timeout = 5000,    -- Your desired timeout
  }
  return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", default_config, config or {}))
end
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  local default_config = {
    border = "single",
    timeout = 5000,
  }
  return vim.lsp.handlers.signatureHelp(err, result, ctx, vim.tbl_extend("force", default_config, config or {}))
end
