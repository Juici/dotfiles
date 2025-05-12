#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

setopt append_history           # Allow multiple sessions to append to one history.
setopt extended_history         # Show timestamp in history.
setopt hist_expire_dups_first   # Delete duplicates first when trimming history.
setopt hist_find_no_dups        # Do not display a previously found command.
setopt hist_ignore_dups         # Do not record a command that was just recorded.
setopt hist_ignore_space        # Do not record a command that start with space.
setopt hist_reduce_blanks       # Remove superfluous blanks form history lines.
setopt hist_verify              # Show command history expansion before running it.
setopt inc_append_history       # Add commands to HISTFILE in order of execution.
setopt share_history            # Share command history data.

# Set history file.
HISTFILE="${Juici[state_dir]}/history"

# Set history size.
HISTSIZE=100000
HISTFILESIZE=$HISTSIZE
SAVEHIST=$HISTSIZE

# Filter some commands from saved history.
HISTORY_IGNORE='(([bf]g|exit)(|[[:space:]]*)|cd ..)'

# →history-filter-add-history() {
#     builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
#     builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

#     # Strip leading and trailing whitespace from the line.
#     local line="${${1##[[:space:]]##}%%[[:space:]]##}"
#     # Split the line using zsh parsing rules.
#     local -a cmd=( "${(@z)line}" )

#     # If the first word is 'builtin' skip the word.
#     [[ "${cmd[1]}" = 'builtin' ]] && cmd[1]=()

#     case "${cmd[1]}" in
#         (exit|bg|fg)
#             return 2
#             ;;
#         (cd)
#             [[ "${cmd[2]}" = '..' ]] && return 2
#             ;;
#     esac

#     return 0
# }

# autoload -Uz add-zsh-hook

# add-zsh-hook zshaddhistory →history-filter-add-history