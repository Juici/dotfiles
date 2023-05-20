setopt auto_cd              # use cd by typing directory name
setopt auto_list            # automatically list choices on ambiguous completion
setopt auto_pushd           # make cd push the old directory onto the stack
setopt pushd_ignore_dups    # don't push duplicate directories onto the stack
setopt pushd_minus          # swap the meaning of `cd +1` and `cd -1`
setopt pushd_silent

setopt bang_hist            # treat the `!` character
setopt interactive_comments # allow comments in interactive shell
setopt multios              # implicit tees or cats for multiple redirections

#setopt auto_param_slash

# Don't clobber files with > redirect.
setopt no_clobber

# Disabled ^S and ^Q.
setopt no_flow_control

# Don't beep in linux console.
[[ "$TERM" = 'linux' ]] && setopt no_beep

# Characters considered as part of words for forward-word and backward-word
# widgets.
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
