local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

return {
	entry = function()
		local cwd = get_cwd()
		if cwd:find("^trash://") or cwd:lower():find("trash") then
			ya.emit("remove", { permanently = true })
		end
	end,
}
