# {{{ Environment

# Set history file.
export HISTFILE="$HOME/.zsh_history"

# Set history size.
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE

# Filter some commands from history.
export HISTIGNORE='&:[ ]*:exit:ls:bg:fg:history:clear'

# }}}

# {{{ Options

setopt extended_history         # record timestamp of command in HISTFILE
setopt hist_expire_dups_first   # delete duplicates first when HISTFILE exceeds HISTSIZE
setopt hist_find_no_dups        # ignore duplicated commands
setopt hist_ignore_dups         # ignore duplicated commands
setopt hist_ignore_space        # ignore commands that start with space
setopt hist_verify              # show command history expansion before running it
setopt inc_append_history       # add commands to HISTFILE in order of execution
setopt share_history            # share command history data

# }}}
