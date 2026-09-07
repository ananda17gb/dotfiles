-- Clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

-- Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Smart search + centered (fixes duplicate mapping warning)
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Better Up/Down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Move Lines
vim.keymap.set("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Join lines & keep cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Buffers
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-M-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-M-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bd", function()
  MiniBufremove.delete()
end, { desc = "Close Buffer" })

-- vim.keymap.set("n", "<leader>bd", function()
-- 	local current_buf = vim.api.nvim_get_current_buf()
-- 	local valid_buffers = vim.fn.getbufinfo({ buflisted = 1 })
--
-- 	if #valid_buffers <= 1 then
-- 		local scratch = vim.api.nvim_create_buf(true, false)
-- 		vim.api.nvim_set_current_buf(scratch)
-- 		pcall(vim.api.nvim_buf_delete, current_buf, { force = true })
-- 	else
-- 		vim.cmd("bnext")
-- 		pcall(vim.api.nvim_buf_delete, current_buf, { force = true })
-- 	end
-- end, { desc = "Close Buffer" })

-- Windows
vim.keymap.set("n", "<leader>wh", "<C-W>s", { remap = true, desc = "Split Window Below" })
vim.keymap.set("n", "<leader>wv", "<C-W>v", { remap = true, desc = "Split Window Right" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { remap = true, desc = "Delete Window" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize split sizes" })
vim.keymap.set("n", "<leader>wz", "<C-w>_<C-w>|", { desc = "Toggle Window Zoom" })

-- Window Resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

vim.keymap.set("n", "<leader>gt", function()
  local term = os.getenv("TERM") or ""
  local cwd = vim.fn.getcwd()

  if term == "foot" or os.getenv("FOOT_SERVER_PID") ~= nil then
    local xdg_runtime = os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000"
    local wayland_disp = os.getenv("WAYLAND_DISPLAY") or "wayland-0"
    local socket_path = xdg_runtime .. "/foot-" .. wayland_disp .. ".sock"

    local socket_exists = vim.uv.fs_stat(socket_path)

    if not socket_exists then
      vim.fn.jobstart({ "foot", "--server" }, { detach = true })

      vim.fn.system("sleep 0.2")
    end

    local cmd = "footclient -N -a lazygit_popup -D " .. vim.fn.shellescape(cwd) .. " lazygit"
    vim.fn.system(cmd)
  elseif os.getenv("KITTY_PID") ~= nil then
    local cmd =
        "kitty --class=lazygit_popup -o remember_window_size=no -o initial_window_width=85c -o initial_window_height=28c -d "
        .. vim.fn.shellescape(cwd)
        .. " lazygit &"
    vim.fn.system(cmd)
  else
    print("Not inside Kitty or Foot. Launching basic fallback...")
    vim.cmd("split | terminal lazygit")
  end
end, { desc = "Toggle Lazygit (Context Aware Terminal Popup)" })

-- Toggle Inlay Hints dengan tombol <leader>th
vim.keymap.set('n', '<leader>th', function()
  local current_state = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not current_state, { bufnr = 0 })
  print("Inlay hints: " .. (not current_state and "ON" or "OFF"))
end, { desc = "Toggle LSP Inlay Hints" })
