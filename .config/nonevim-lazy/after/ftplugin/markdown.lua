local set = vim.opt_local

-- set.linebreak = true
-- set.wrap = false
-- set.textwidth = 80
-- set.colorcolumn = "80"

-- local color1_bg = "#d8647e"
-- local color2_bg = "#7fa563"
-- local color3_bg = "#b4d4cf"
-- local color4_bg = "#e0a363"
-- local color5_bg = "#7e98e8"
-- local color6_bg = "#c3c3d5"
-- local color_fg = "#141415"

local color1_bg = "#3D3839"
local color2_bg = "#585253"
local color3_bg = "#757071"
local color4_bg = "#8E8E8E"
local color5_bg = "#A6A6A6"
local color6_bg = "#BBBBBB"
local color_fg = "#191919"

local highlights = {
  Headline1Bg = { fg = color_fg, bg = color1_bg },
  Headline2Bg = { fg = color_fg, bg = color2_bg },
  Headline3Bg = { fg = color_fg, bg = color3_bg },
  Headline4Bg = { fg = color_fg, bg = color4_bg },
  Headline5Bg = { fg = color_fg, bg = color5_bg },
  Headline6Bg = { fg = color_fg, bg = color6_bg },
  Headline1Fg = { fg = color1_bg, bold = true },
  Headline2Fg = { fg = color2_bg, bold = true },
  Headline3Fg = { fg = color3_bg, bold = true },
  Headline4Fg = { fg = color4_bg, bold = true },
  Headline5Fg = { fg = color5_bg, bold = true },
  Headline6Fg = { fg = color6_bg, bold = true },
}

for name, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, name, opts)
end
