return {
  'MagicDuck/grug-far.nvim',
  -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
  -- additional lazy config to defer loading is not really needed...
  cmd = { "GrugFar" },
  config = function()
    local grug = require('grug-far')
    -- optional setup call to override plugin options
    -- alternatively you can set options with vim.g.grug_far = { ... }
    grug.setup({
      -- options, see Configuration section below
      -- there are no required options atm
    });

    vim.keymap.set("n", "<leader>Ss", function()
      vim.cmd("GrugFar")
    end, { desc = "Search/replace project" })

    vim.keymap.set("n", "<leader>Sc", function()
      grug.open({ prefills = { paths = vim.fn.expand("%") } })
    end, { desc = "Search/replace current file" })

    vim.keymap.set("x", "<leader>Sx", function()
      grug.open({ visualSelectionUsage = "operate-within-range" })
    end, { desc = "Search/replace in selection" })
  end
}
