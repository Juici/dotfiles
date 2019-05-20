# {{{ Prompt

# Substitute colours in prompt.
setopt prompt_subst

# Load colors module.
autoload -Uz colors
colors

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
# %a - action
# %b - branch
# %m - misc
# %c - stagedstr
# %u - unstagedstr
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' '%R' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' '%R' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:svn*:*' formats '[%b%m%c%u] ' '%R' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:svn*:*' actionformats '[%b|%a%m%c%u] ' '%R' # default ' (%s)-[%b|%a]%c%u-'

# Include untracked files in unstagedstr.
+vi-git-untracked() {
    emulate -L zsh
    if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
        hook_com[unstaged]+="%F{blue}●%f"
    fi
}

# Anonymous function to avoid leaking variables.
() {
    # Check for tmux by looking at $TERM, because $TMUX won't be propagated to any
    # nested sudo shells but $TERM will.
    local TMUXING=$([[ "$TERM" == *tmux* ]] && echo tmux)
    if [[ ( -n "$TMUXING" ) && ( -n "$TMUX" ) ]]; then
        # In a a tmux session created in a non-root or root shell.
        local LVL=$(($SHLVL - 1))
    else
        # Either in a root shell created inside a non-root tmux session,
        # or not in a tmux session.
        local LVL=$SHLVL
    fi
    if (( $EUID == 0 )); then
        local SUFFIX="%F{yellow}%n$(printf '\u276f%.0s' {1..$LVL})%f"
    else
        local SUFFIX="%F{red}$(printf '\u276f%.0s' {1..$LVL})%f"
    fi
    export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%B%1~%b%F{yellow}%B%(1j.*.)%(?..!)%b%f %B${SUFFIX}%b "
    if [[ -n "$TMUXING" ]]; then
        # Outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
        # prompt still gets corrupted even if we add an extra space to compensate.
        export ZLE_RPROMPT_INDENT=0
    fi
}

RPROMPT_BASE='${prompt_vcs_info[branch]}%F{blue}%~%f'

export RPROMPT="$RPROMPT_BASE"
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# }}}

# {{{ Hooks

autoload -Uz add-zsh-hook

-prompt-preexec() {
    # Record start time of command.
    prompt_record_start_time
}
add-zsh-hook preexec -prompt-preexec

-prompt-precmd() {
    # Perform long tasks async to prevent blocking.
    prompt_async_tasks

    # Report the execution time of previous command.
    prompt_report_start_time
}
add-zsh-hook precmd -prompt-precmd

# }}}

# {{{ Functions

typeset -gF SECONDS
prompt_record_start_time() {
    emulate -L zsh
    ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

prompt_report_start_time() {
    emulate -L zsh
    if (( $+ZSH_START_TIME )); then
        local DELTA=$(($SECONDS - $ZSH_START_TIME))
        local DAYS=$((~~($DELTA / 86400)))
        local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
        local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
        local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
        local ELAPSED=''
        (( $DAYS > 0)) && ELAPSED="${DAYS}d"
        (( $HOURS > 0 )) && ELAPSED="${ELAPSED}${HOURS}h"
        (( $MINUTES > 0 )) && ELAPSED="${ELAPSED}${MINUTES}m"
        if [[ -z "$ELAPSED" ]]; then
            SECS="$(print -f "%.2f" $SECS)s"
        elif (( $DAYS )); then
            SECS=''
        else
            SECS="$((~~$SECS))s"
        fi
        ELAPSED="${ELAPSED}${SECS}"
        export RPROMPT="%F{cyan}%{$__VARS[ITALIC_ON]%}${ELAPSED}%{$__VARS[ITALIC_OFF]%}%f $RPROMPT_BASE"
        unset ZSH_START_TIME
    else
        export RPROMPT="$RPROMPT_BASE"
    fi
}

prompt_async_vcs_info() {
    vcs_info

    local -A info
    info[pwd]=$PWD
    info[top]=$vcs_info_msg_1_
    info[branch]=$vcs_info_msg_0_

    builtin print -r -- "${(@kvq)info}"
}

prompt_async_tasks() {
    # Initialise async worker.
    if (( ! ${prompt_async_init:-0} )); then
        async_start_worker 'prompt' -u -n
        async_register_callback 'prompt' prompt_async_callback
        typeset -g prompt_async_init=1
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
    async_job 'prompt' prompt_async_vcs_info
}

prompt_async_callback() {
    local job=$1 code=$2 stdout=$3 exec_time=$4 stderr=$5 next_pending=$6
    local do_render=0

    case $job in
        \[async])
            # Code 1: corrupted worker output.
            # Code 2: dead worker.
            if (( $code == 2 )); then
                # The worker died unexpectedly.
                typeset -g prompt_async_init=0
            fi
            ;;
        prompt_async_vcs_info)
            local -A info
            typeset -gA prompt_vcs_info

            # Parse output (z) and unquote as array (Q@).
            info=("${(Q@)${(z)stdout}}")

            if [[ ${info[pwd]} != $PWD ]]; then
                # The path has changed since the job started, abort.
                return
            fi

            # Check if git toplevel has changed.
            if [[ ${info[top]} == ${prompt_vcs_info[top]} ]]; then
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
        (( do_render )) && typeset -g prompt_async_render_requested=1
        return
    fi

    if (( ${prompt_async_render_requested:-$do_render} == 1 )); then
        zle .reset-prompt
    fi
    unset prompt_async_render_requested
}

# }}}
