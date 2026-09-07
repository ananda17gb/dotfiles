#!/usr/bin/env bash

reload_foot_live() {
    local foot_theme="$HOME/.config/foot/colorscheme/current-theme.ini"

    if [[ ! -f $foot_theme ]] || ! pgrep -x foot >/dev/null; then
        return 0
    fi

    local foot_osc
    foot_osc=$(awk -F= '
        function color(value) { return "#" value }
        /^foreground=/ { printf "\033]10;%s\007", color($2) }
        /^background=/ { printf "\033]11;%s\007", color($2) }
        /^cursor=/ { split($2, parts, " "); printf "\033]12;%s\007", color(parts[2]) }
        /^selection-background=/ { printf "\033]17;%s\007", color($2) }
        /^selection-foreground=/ { printf "\033]19;%s\007", color($2) }
        /^regular[0-7]=/ { split($1, parts, "regular"); printf "\033]4;%d;%s\007", parts[2], color($2) }
        /^bright[0-7]=/ { split($1, parts, "bright"); printf "\033]4;%d;%s\007", parts[2] + 8, color($2) }
    ' "$foot_theme")

    for foot_pid in $(pgrep -x foot); do
        for child_pid in $(pgrep -P "$foot_pid"); do
            tty=$(readlink "/proc/$child_pid/fd/1" 2>/dev/null)
            [[ $tty == /dev/pts/* ]] && printf '%b' "$foot_osc" >"$tty"
        done
    done
}

THEME=$(echo -e "Gruvbox\nVague" | fuzzel --dmenu -p "Select Theme: " --lines 2 --width 20)

if [[ -z "$THEME" ]]; then
    exit 0
fi

case "$THEME" in
    "Gruvbox")
        echo "light" >"$HOME/.config/theme_state"

        ln -sf "$HOME/.config/foot/colorscheme/gruvbox.ini" "$HOME/.config/foot/colorscheme/current-theme.ini"

        ln -sf "$HOME/.config/kitty/colorscheme/gruvbox.conf" "$HOME/.config/kitty/colorscheme/current-theme.conf"

        ln -sf "$HOME/.config/fuzzel/colorscheme/gruvbox.ini" "$HOME/.config/fuzzel/colorscheme/current-theme.ini"

        ln -sf "$HOME/.config/yazi/colorscheme/gruvbox.toml" "$HOME/.config/yazi/theme.toml"

        pkexec env HOME="$HOME" /home/nnonne/.config/mango/scripts/background-changer.sh /home/nnonne/dotfiles/wallpapers/storebyariver.jpg

        ln -sf /home/nnonne/dotfiles/wallpapers/storebyariver.jpg /home/nnonne/.config/net.imput.helium/Default/background.jpg

        ;;

    "Vague")
        echo "dark" >"$HOME/.config/theme_state"

        ln -sf "$HOME/.config/foot/colorscheme/vague.ini" "$HOME/.config/foot/colorscheme/current-theme.ini"

        ln -sf "$HOME/.config/kitty/colorscheme/vague.conf" "$HOME/.config/kitty/colorscheme/current-theme.conf"

        ln -sf "$HOME/.config/fuzzel/colorscheme/vague.ini" "$HOME/.config/fuzzel/colorscheme/current-theme.ini"

        ln -sf "$HOME/.config/yazi/colorscheme/vague.toml" "$HOME/.config/yazi/theme.toml"

        pkexec env HOME="$HOME" /home/nnonne/.config/mango/scripts/background-changer.sh /home/nnonne/dotfiles/wallpapers/sidewalk-night.jpg

        ln -sf /home/nnonne/dotfiles/wallpapers/sidewalk-night.jpg /home/nnonne/.config/net.imput.helium/Default/background.jpg

        ;;
esac

reload_foot_live

if pgrep -x nvim >/dev/null; then
    pkill -USR1 -x nvim
fi

if pgrep -x kitty >/dev/null; then
    pkill -USR1 -x kitty
fi

pkill wbg
wbg -s ~/.config/mango/wallpaper.png >/dev/null 2>&1 &
