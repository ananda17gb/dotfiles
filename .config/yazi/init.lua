Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

-- -- Vague
-- 	return ui.Line({
-- 		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
-- 		":",
-- 		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
-- 		" ",
-- 	})

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("white"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("white"),
		" ",
	})
end, 500, Status.RIGHT)

function Linemode:custom_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%u%d%m%H%M", time)
	else
		time = os.date("%u%d%m%y", time)
	end

	return string.format("%s", time)
end


require('spot'):setup {
  metadata_section = {
    enable = true,
    hash_cmd = 'xxhsum', -- other hashing commands may be slower
    hash_filesize_limit = 150, -- in MB, set 0 to disable
    relative_time = true, -- 2026-01-01 or n days ago
    time_format = '%Y-%m-%d %H:%M', -- https://www.man7.org/linux/man-pages/man3/strftime.3.html
    show_compression = true, ---@type boolean
  },
  plugins_section = {
    enable = true,
  },
  style = {
    color = {
      metadata = true,
      title = 'green',
      key = 'reset',
      value = 'blue',
      selected = 'blue',
    },
    size = {
      height = 20, -- unused when auto_resize is set to true
      width = 60, -- unused when auto_resize is set to true
      auto_resize = true,
      min_width = 60,
      max_width = 80,
      min_height = 20,
      max_height = 40,
    },
    max_key_length = 25,
    key_indent_size = 2,
  },
}

require("starship"):setup({
  -- Hide flags (such as filter, find and search). This can be beneficial for starship themes
  -- which are intended to go across the entire width of the terminal.
	hide_flags = true,
  -- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
	flags_after_prompt = true,
  -- Custom starship configuration file to use
	config_file = "~/.config/yazi/starship.toml", -- Default: nil
  -- Whether to enable support for starship's right prompt (i.e. `starship prompt --right`).
	show_right_prompt = false,
  -- Whether to hide the count widget, in case you want only your right prompt to show up. Only has
  -- an effect when `show_right_prompt = true`
  hide_count = false,
  -- Separator to place between the right prompt and the count widget. Use `count_separator = ""`
  -- to have no space between the widgets.
  count_separator = " ",
})

require("mime-ext.local"):setup {
	-- Expand the default filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
		-- ...
	},

	-- Expand the default extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		-- ...
	},

	-- Empty the default filename and extension databases,
	-- use only the custom ones configured with `with_files` and `with_exts`
	custom_only = false,

	-- If the MIME type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime.local` plugin, which uses `file(1)`
	fallback_file1 = false,
}

require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

require("full-border"):setup({
	type = ui.Border.PLAIN,
})

require("confirm-quit"):setup()
