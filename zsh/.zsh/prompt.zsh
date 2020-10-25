# Prompt {{{

# Substitute colours in prompt.
setopt prompt_subst

# Load colors module.
autoload -Uz colors
colors

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}●%f' # default 'S'
zstyle ':vcs_info:*' unstagedstr '%F{red}●%f' # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:git+set-message:*' hooks git-untracked

# VCS format strings.
# %a - action
# %b - branch
# %m - misc
# %c - stagedstr
# %u - unstagedstr
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u]' '%R' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u]' '%R' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:svn*:*' formats '[%b%m%c%u]' '%R' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:svn*:*' actionformats '[%b|%a%m%c%u]' '%R' # default ' (%s)-[%b|%a]%c%u-'

# Include untracked files in unstagedstr.
+vi-git-untracked() {
    emulate -L zsh
    if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
        hook_com[unstaged]+='%F{blue}●%f'
    fi
}

# Anonymous function to avoid leaking variables.
() {
    # Left Prompt.

    # Set the prompt suffix character.
    local suffix_char
    case "$TERM" in
        linux|tmux)
            suffix_char='>'
            ;;
        *)
            suffix_char='\u276f'
            ;;
    esac

    # Check for tmux by looking at $TERM, because $TMUX won't be propagated to any
    # nested sudo shells but $TERM will.
    local tmuxing
    [[ "$TERM" = *tmux* ]] && tmuxing='tmux'

    integer lvl
    if [[ ( -n "$tmuxing" ) && ( -n "$TMUX" ) ]]; then
        # In a a tmux session created in a non-root or root shell.
        lvl=$(( SHLVL - 1 ))
    else
        # Either in a root shell created inside a non-root tmux session,
        # or not in a tmux session.
        lvl=$SHLVL
    fi

    # Repeat the suffix character to represent shell level.
    local suffix_chars="$(printf "${suffix_char}%.0s" {1..$lvl})"
    # Suffix with extra information for root.
    #
    # Displays in bold yellow with username for privileged shells.
    # Displays in bold red for regular shells.
    #
    # '%(!.true.false)' - tennary expression on if the shell is running with
    #                     privileges.
    local suffix="%B%(!.%F{yellow}%n.%F{red})${suffix_chars}%f%b"

    # Prompt expansion:
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

    # Login info, displayed when in an SSH session.
    #
    # Display 'user@host' in green and ':' in bold.
    #
    # '%n' - username
    # '%m' - hostname up to first .
    local ssh_info='%F{green}%n@%m%f%B:%b'

    # Current working directory info.
    #
    # Display name of current working directory in bold blue.
    #
    # '%1~' - last part of current path, ie. the directory name
    local wd='%F{blue}%B%1~%b%f'

    # Running jobs and exit status.
    #
    # Display if there are running jobs and if the exit status of the last
    # command was non-zero.
    #
    # '%(1j.*.)' - '*' if the numer of running jobs is at least 1
    # '%(?..!)' - '!' if the exit status is not 0
    #
    # Conditional substrings:
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts
    local status_info='%F{yellow}%B%(1j.*.)%(?..!)%b%f'

    # Export PS1.
    export PS1="${SSH_TTY:+${ssh_info}}${wd}${status_info} ${suffix} "

    # Right Prompt

    # Space before full_path, if vcs_info or elapsed_time present.
    local path_space='${${prompt_vcs_info[branch]:-${prompt_cmd_elapsed:-}}:+ }'
    # Space before vcs_info, if elapsed_time present.
    local vcs_space='${${prompt_cmd_elapsed:-}:+ }'

    # The full path, displayed in the right prompt.
    #
    # Not displayed if terminal width is less than 80 columns.
    # Trimmed from left side to fit within a quarter of the terminal width.
    #
    # Adds a space before if VCS info is displayed.
    local full_path="%-80(l.${path_space}%F{blue}%\$(( COLUMNS / 4 ))<...<%~%<<%f.)"

    # VCS branch info, set by async precmd callback.
    local vcs_info="\${prompt_vcs_info[branch]:+${vcs_space}}\${prompt_vcs_info[branch]}"

    local italic_on='' italic_off=''
    if (( ${+terminfo[sitm]} && ${+terminfo[ritm]} )); then
        italic_on="%{${terminfo[sitm]}%}"
        italic_off="%{${terminfo[ritm]}%}"
    fi

    # Time taken for previous command.
    local elapsed_time="%F{cyan}${italic_on}\${prompt_cmd_elapsed}${italic_off}%f"

    export RPROMPT="${elapsed_time}${vcs_info}${full_path}"
    export ZLE_RPROMPT_INDENT=0
}

export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# }}}

# Hooks {{{

autoload -Uz add-zsh-hook

-prompt-preexec() {
    # Record start time of command.
    -prompt-record-start-time
}
add-zsh-hook preexec -prompt-preexec

-prompt-precmd() {
    # Perform long tasks async to prevent blocking.
    -prompt-async-tasks

    # Report the execution time of previous command.
    -prompt-report-start-time
}
add-zsh-hook precmd -prompt-precmd

# }}}

# Functions {{{

typeset -gF SECONDS
-prompt-record-start-time() {
    emulate -L zsh

    # Set command start time.
    prompt_cmd_elapsed=''
    prompt_cmd_start="$SECONDS"
}

-prompt-report-start-time() {
    emulate -L zsh

    # If command start time was set, calculate elapsed time.
    if (( $+prompt_cmd_start )); then
        local -F delta secs
        integer days hours mins

        # Delta time for command in seconds.
        delta=$(( SECONDS - prompt_cmd_start ))

        # Days as an integer.
        days=$(( delta / 86400 ))
        delta=$(( delta - (days * 86400) ))

        # Hours as an integer.
        hours=$(( delta / 3600 ))
        delta=$(( delta - (hours * 3600) ))

        # Minutes as an integer.
        mins=$(( delta / 60 ))
        delta=$(( delta - (mins * 60) ))

        # Seconds as a floating point.
        secs=$(( delta ))

        # Construct time elapsed string.
        local elapsed=''
        (( days > 0 )) && elapsed="${days}d"
        (( hours > 0 )) && elapsed="${elapsed}${hours}d"
        (( mins > 0 )) && elapsed="${elapsed}${days}d"

        if [[ -z "$elapsed" ]]; then
            elapsed="$(printf '%.2f' $secs)s"
        elif (( days == 0 )); then
            integer int_secs=$(( secs ))
            elapsed="${elapsed}${int_secs}s"
        fi

        prompt_cmd_elapsed="$elapsed"
        unset prompt_cmd_start
    else
        prompt_cmd_elapsed=''
    fi
}

-prompt-async-vcs-info() {
    vcs_info

    local -A info
    info[pwd]=$PWD
    info[top]=$vcs_info_msg_1_
    info[branch]=$vcs_info_msg_0_

    builtin print -r -- "${(@kvq)info}"
}

-prompt-async-tasks() {
    # Initialise async worker.
    if (( ! ${prompt_async_init:-0} )); then
        async_start_worker 'prompt' -u -n
        async_register_callback 'prompt' -prompt-async-callback
        integer -g prompt_async_init=1
    fi

    # Update current working directory of the async worker.
    async_worker_eval 'prompt' "builtin cd -q $PWD"

    typeset -gA prompt_vcs_info

    if [[ $PWD != ${prompt_vcs_info[pwd]}* ]]; then
        # Stop running async jobs.
        async_flush_jobs 'prompt'

        prompt_vcs_info[top]=''
        prompt_vcs_info[branch]=''
    fi

    # Async vcs_info.
    async_job 'prompt' -prompt-async-vcs-info
}

-prompt-async-callback() {
    local job=$1 code=$2 stdout=$3 exec_time=$4 stderr=$5 next_pending=$6
    integer do_render=0

    case $job in
        \[async])
            # Code 1: corrupted worker output.
            # Code 2: dead worker.
            if (( $code == 2 )); then
                # The worker died unexpectedly.
                integer -g prompt_async_init=0
            fi
            ;;
        -prompt-async-vcs-info)
            local -A info
            typeset -gA prompt_vcs_info

            # Parse output (z) and unquote as array (Q@).
            info=("${(Q@)${(z)stdout}}")

            if [[ ${info[pwd]} != $PWD ]]; then
                # The path has changed since the job started, abort.
                return
            fi

            # Check if git toplevel has changed.
            if [[ ${info[top]} = ${prompt_vcs_info[top]} ]]; then
                # If stored pwd is part of $PWD: $PWD is shorter and likelier to
                # be toplevel, so update pwd.
                if [[ ${prompt_vcs_info[pwd]} = ${PWD}* ]]; then
                    prompt_vcs_info[pwd]=$PWD
                fi
            else
                # Store $PWD to detect if we (maybe) left the git path.
                prompt_vcs_info[pwd]=$PWD
            fi

            prompt_vcs_info[top]=${info[top]}
            prompt_vcs_info[branch]=${info[branch]}

            do_render=1
            ;;
    esac

    if (( next_pending )); then
        (( do_render )) && integer -g prompt_async_render_requested=1
        return
    fi

    if (( ${prompt_async_render_requested:-$do_render} == 1 )); then
        zle .reset-prompt
    fi
    unset prompt_async_render_requested
}

# }}}
