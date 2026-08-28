# =========================================================
# History
# =========================================================

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Don't enter immediate duplicates into the history.
setopt HIST_IGNORE_DUPS

# Remove commands from the history that begin with a space.
setopt HIST_IGNORE_SPACE

setopt HIST_EXPIRE_DUPS_FIRST

# Don't display duplicates when searching the history.
setopt HIST_FIND_NO_DUPS

# Don't execute the command directly upon history expansion.
setopt HIST_VERIFY

# Cause all terminals to share the same history 'session'.
setopt SHARE_HISTORY

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# set to emacs for yazi shell drop to not be vi-mode
bindkey -e

# Prompt for spelling correction of commands.
# setopt CORRECT
# SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? ' # Customize spelling correction prompt.

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Make cd push the old directory to the directory stack.
setopt AUTO_PUSHD

autoload -Uz is-at-least && if is-at-least 5.8; then
    # Don't print the working directory after a cd.
    setopt CD_SILENT
fi

# Don't push multiple copies of the same directory to the stack.
setopt PUSHD_IGNORE_DUPS

# Don't print the directory stack after pushd or popd.
setopt PUSHD_SILENT

# Have pushd without arguments act like `pushd ${HOME}`.
setopt PUSHD_TO_HOME

# Treat `#`, `~`, and `^` as patterns for filename globbing.
setopt EXTENDED_GLOB

# Allow comments starting with `#` in the interactive shell.
setopt INTERACTIVE_COMMENTS

# Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.
setopt NO_CLOBBER

# List jobs in verbose format by default.
setopt LONG_LIST_JOBS

# Prevent background jobs being given a lower priority.
setopt NO_BG_NICE

# Prevent status report of jobs on shell exit.
setopt NO_CHECK_JOBS

# Prevent SIGHUP to jobs on shell exit.
setopt NO_HUP

# =========================================================
# Completion
# =========================================================

source "$ZDOTDIR/completion.zsh"
fpath=(~$ZDOTDIR/plugins/zsh-completions/src $fpath)

# =========================================================
# Fuzzy finder
# =========================================================

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

# =========================================================
# Modular Config Files
# =========================================================

# Initialize
source "$ZDOTDIR/init.zsh"

# Git
source "$ZDOTDIR/git.zsh"

# Flutter (might not needed, currently using mise )
# source "$ZDOTDIR/flutter.zsh"

# fzf configuration
source "$ZDOTDIR/fzf.zsh"

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Custom keybindings
source "$ZDOTDIR/bindings.zsh"

# Plugins and plugin manager
source "$ZDOTDIR/plugins.zsh"

# Prompt/theme
source "$ZDOTDIR/prompt.zsh"

# Functions
source "$ZDOTDIR/functions.zsh"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
