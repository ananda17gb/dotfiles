local colors_name = "darker-zenwritten"
vim.g.colors_name = colors_name

local lush = require("lush")
local hsluv = lush.hsluv
local util = require("zenbones.util")

local bg = "dark"

local palette = util.palette_extend({
  bg = hsluv "#000000",
}, bg)

local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

lush(base_specs)

require("zenbones.term").apply_colors(palette)
