#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

setopt correct              # Auto correct commands.
setopt extended_glob        # Extended globbing.
setopt auto_cd              # Use cd by typing directory name.
setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_pushd           # Make cd push the old directory onto the stack.
setopt pushd_ignore_dups    # Don't push duplicate directories onto the stack.
setopt pushd_minus          # Swap the meaning of `cd +1` and `cd -1`.
setopt pushd_silent

setopt bang_hist            # Treat the `!` character.
setopt interactive_comments # Allow comments in interactive shell.
setopt multios              # Implicit tees or cats for multiple redirections.

setopt no_clobber           # Don't clobber files with > redirect.
setopt no_flow_control      # Disable ^S and ^Q.

# Don't beep in linux console.
[[ "$TERM" = 'linux' ]] && setopt no_beep

# Characters considered as part of words for forward-word and backward-word widgets.
WORDCHARS='_-.*?~&!#$%^(){}[]<>'

# Pattern for commands to ignore during spelling correction.
CORRECT_IGNORE='(_*|sudo|cp|mv|mkdir|rm|man)'
# Pattern for files to ignore during spelling correction.
CORRECT_IGNORE_FILE='.*'
