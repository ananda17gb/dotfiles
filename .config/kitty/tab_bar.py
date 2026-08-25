import os
import kitty.boss as boss_module

_theme_real_path = None

def _get_theme_path():
    global _theme_real_path
    if _theme_real_path is None:
        config_path = os.path.expanduser("~/.config/kitty/colorscheme/current-theme.conf")
        if os.path.exists(config_path):
            _theme_real_path = os.path.realpath(config_path)
        else:
            _theme_real_path = ""
    return _theme_real_path

def _check_active(data, tab):
    # 1. Direct key lookups in data dictionary
    for k in ("tab.is_active", "is_active", "tab.active", "active", "is_focused"):
        val = data.get(k)
        if val is not None:
            return bool(val)

    # 2. Check tab object attribute
    if tab is not None:
        if getattr(tab, "is_active", None) is not None:
            return bool(tab.is_active)

    # 3. Fallback to Kitty Boss comparison
    boss = boss_module.get_boss()
    if boss and boss.active_tab:
        if tab is not None:
            active_id = getattr(boss.active_tab, "id", None) or getattr(boss.active_tab, "tab_id", None)
            current_id = getattr(tab, "id", None) or getattr(tab, "tab_id", None)
            if active_id is not None and current_id is not None:
                return active_id == current_id
            return tab is boss.active_tab
        
        # Check by index if tab object missing
        current_idx = data.get("tab.tab_index") or data.get("index")
        active_idx = getattr(boss.active_tab, "tab_index", None)
        if current_idx is not None and active_idx is not None:
            return current_idx == active_idx

    return False

def draw_title(data):
    fmt = data["fmt"]
    tab = data.get("tab")

    # 1. Detect active state
    is_active = _check_active(data, tab)

    # 2. Resolve Session Name
    session = data.get("session_name") or ""
    if not session:
        boss = boss_module.get_boss()
        if boss and hasattr(boss, "active_os_window_session_name"):
            session = boss.active_os_window_session_name or ""

    # 3. Check first tab
    is_first_tab = False
    if tab is not None:
        idx = getattr(tab, "tab_index", None)
        if idx in (0, 1) or getattr(tab, "is_first", False):
            is_first_tab = True
    if not is_first_tab:
        idx = data.get("tab.tab_index") or data.get("index")
        if idx in (0, 1) or data.get("tab.is_first") or data.get("is_first"):
            is_first_tab = True

    # 4. Extract folder name (pwd)
    cwd = getattr(tab, "active_wd", "") if tab else ""
    if not cwd and tab and hasattr(tab, "active_window") and tab.active_window:
        cwd = getattr(tab.active_window, "cwd", "")

    if cwd:
        cwd = cwd.rstrip("/\\")
        display_title = os.path.basename(cwd) or "/"
    else:
        raw_title = data.get("title") or ""
        command = raw_title.split(" ")[0]
        if command == "sudo":
            try:
                command = "# " + raw_title.split(" ")[1]
            except IndexError:
                command = "# sudo"
        display_title = command.split("/")[-1].split(":")[-1]

    # Add * indicator to active tab
    if is_active:
            display_title = f"* {display_title}"


    layout = data.get("layout_name") or ""
    bell = data.get("bell_symbol") or ""
    progress = data.get("tab.last_focused_progress_percent") or ""
    num_windows = data.get("num_windows") or 0
    progress_percent = data.get("tab.progress_percent") or ""

    layout_short = layout[0].upper() if layout else ""
    layout_display = f"{layout_short}({num_windows})" if layout.lower() == "stack" else layout_short

    # 5. Theme Palette
    real_path = _get_theme_path()
    is_light = "gruvbox" in real_path.lower()

    if is_light:
        bg_style = fmt.bg._f9f5d7
        c_session = fmt.fg.color15
        c_sep = fmt.fg.color7
        c_bell = fmt.fg.color1
        c_prog = fmt.fg.color9
        c_title = fmt.fg.color4 if is_active else fmt.fg.color15
        c_layout = fmt.fg.color13
    else:
        # zenwritten_dark theme colors
        bg_style = fmt.bg._000000
        c_session = fmt.fg.color7      # Clean white/light gray (#BBBBBB)
        c_sep = fmt.fg.color8          # Dark muted gray (#3D3839)
        c_bell = fmt.fg.color1
        c_prog = fmt.fg.color3
        c_title = fmt.fg.color7 if is_active else fmt.fg.color15  # Bright active, muted inactive
        c_layout = fmt.fg.color7 if is_active else fmt.fg.color8

    parts = []

    # 6. Session shown only once on the first tab
    if session and is_first_tab:
        parts.append(bg_style)
        parts.append(c_session)
        parts.append(f"[{session}]")
        parts.append(c_sep)
        parts.append(" | ")

    if bell:
        parts.append(bg_style)
        parts.append(c_bell)
        parts.append(bell)

    if progress:
        parts.append(bg_style)
        parts.append(c_prog)
        parts.append(progress)

    # Folder Name + Asterisk
    parts.append(bg_style)
    parts.append(c_title)
    parts.append(display_title)

    # Layout Indicator
    parts.append(c_layout)
    parts.append(f" [{layout_display}]")

    if progress_percent:
        parts.append(bg_style)
        parts.append(c_prog)
        parts.append(progress_percent)

    parts.append(bg_style)
    parts.append(fmt.fg.tab)

    return "".join(parts)
