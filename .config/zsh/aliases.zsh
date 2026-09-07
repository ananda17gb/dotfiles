alias n="~/.config/kitty/scripts/kitty_nvim.sh"
alias v="~/.config/kitty/scripts/kitty_nvim.sh"

alias nzsh="n $ZDOTDIR/.zshrc"
alias szsh="source $ZDOTDIR/.zshrc"

alias df="duf"
alias ls="eza -l -F --icons --smart-group"
alias du="dua i"
alias find="fd"
alias grep="rg --color=auto"
alias cat="bat"
alias y="yazi"
alias mpv="nice -n 19 env MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE=1 mpv"
alias celluloid="env DRI_PRIME=0 celluloid"
alias lg="lazygit"
alias cal="cal -y -m"

### zim-utility ###

if (( ${+commands[aria2c]} )); then
    alias get='aria2c --max-connection-per-server=5 --continue'
elif (( ${+commands[axel]} )); then
    alias get='axel --num-connections=5 --alternate'
elif (( ${+commands[wget]} )); then
    alias get='wget --continue --progress=bar --timestamping'
elif (( ${+commands[curl]} )); then
    alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi


if (( ${+commands[safe-rm]} && ! ${+commands[safe-rmdir]} )); then
    alias rm=safe-rm
fi
