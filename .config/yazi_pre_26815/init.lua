require("git"):setup({
	order = 1500,
})

require("confirm-quit"):setup()

require("recycle-bin"):setup({
	trash_dir = "/home/nnonne/.local/share/Trash",
})

require("gvfs"):setup({
	input_position = { "center", y = 0, w = 60 },
})

require("starship"):setup({
	hide_flags = true,
	flags_after_prompt = true,
	config_file = "~/.config/yazi/starship.toml", -- Default: nil
	show_right_prompt = false,
	hide_count = false,
	count_separator = " ",
})

require("full-border"):setup({
	type = ui.Border.PLAIN,
})

require("spot"):setup({
	metadata_section = {
		enable = true,
		hash_cmd = "xxhsum",
		hash_filesize_limit = 150,
		relative_time = true,
		time_format = "%Y-%m-%d %H:%M",
		show_compression = "size",
	},
	plugins_section = {
		enable = true,
	},
	style = {
		section = "green",
		key = "reset",
		value = "blue",
		selected = "blue",
		colorize_metadata = true,
		height = 20,
		width = 60,
		key_length = 15,
	},
})

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
