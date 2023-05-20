# Environment {{{

# Set history file.
export HISTFILE="$HOME/.zhistory"

# Set history size.
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE

# Filter some commands from history.
export HISTIGNORE='&:[ ]*:exit:ls:bg:fg:history:clear'

# }}}

# Options {{{

setopt append_history           # allow multiple sessions to append to one history
setopt extended_history         # show timestamp in history
setopt hist_expire_dups_first   # delete duplicates first when trimming history
setopt hist_find_no_dups        # do not display a previously found command
setopt hist_ignore_dups         # do not record a command that was just recorded
setopt hist_ignore_space        # do not record a command that start with space
setopt hist_reduce_blanks       # remove superfluous blanks form history lines
setopt hist_verify              # show command history expansion before running it
setopt inc_append_history       # add commands to HISTFILE in order of execution
setopt share_history            # share command history data

# }}}
