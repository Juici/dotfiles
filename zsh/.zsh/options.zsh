# Improved directory navigation.
setopt auto_cd
setopt auto_pushd
setopt pushd_minus
setopt pushd_ignore_dups
setopt pushd_silent

#setopt auto_param_slash

# Don't clobber files with > redirect.
setopt no_clobber

# Disabled ^S and ^Q.
setopt no_flow_control

# Allow comments in interactive shell.
setopt interactive_comments

# Don't beep in linux console.
if [[ "$TERM" = 'linux' ]]; then
    setopt nobeep
fi

# Characters considered as part of words for forward-word and backward-word
# widgets.
#WORDCHARS='_-.*?~&!#$%^'
WORDCHARS='_-.*?~&!#$%^(){}[]<>'

# Autocorrection {{{

# Correct commands.
setopt correct
#setopt correct_all

# Correct ignore.
CORRECT_IGNORE='_*'         # Ignore completion functions.
CORRECT_IGNORE_FILE='.*'    # Ignore hidden files.

# Nocorrect aliases.
() {
    local -aU cmds=(
        sudo
        cp
        mv
        rm
        mkdir
        man
    )

    local cmd
    for cmd in $cmds; do
        # Check that command exists, to prevent creating fake aliases.
        (( ${+commands[$cmd]} )) && alias $cmd="nocorrect $cmd"
    done
}

# }}}
