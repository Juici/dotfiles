# Setup {{{

# Substitute colours in prompt.
setopt prompt_subst

# Load colors module.
autoload -Uz colors
colors

# Load gitstatus plugin and start daemon.
zinit ice wait nocd lucid atload'gitstatus_stop "gitprompt" && gitstatus_start "gitprompt"; .prompt_async_tasks'
zinit load romkatv/gitstatus

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' stagedstr '1' # Boolean value.
zstyle ':vcs_info:*' unstagedstr '1' # Boolean value.
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 8

# Hook debug info.
zstyle ':vcs_info:*+*:*' debug false

# VCS format strings.
#
# %R - top repo directory
# %b - branch
# %i - revision
# %m - misc
# %c - has staged
# %u - has unstaged
# 0  - has untracked
# %a - action
#
# By default vcs_info doesn't support untracked files, so we pretend that there
# are none and we will override it with a hook.
zstyle ':vcs_info:*:*' formats '%R' '%b' '%i' '%m' '%c' '%u' '0'
zstyle ':vcs_info:*:*' actionformats '%R' '%b' '%i' '%m' '%c' '%u' '0' '%a'

zstyle ':vcs_info:git+set-message:*' hooks git-untracked

+vi-git-untracked() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    integer n=$1

    # `vcs_info_msg_6_` carries the 'has untracked' state, it defaults to `0`.
    if (( n == 6 )); then
        # Untracked files are marked by lines starting '??', so we filter on
        # those lines.
        local -a untracked
        untracked=( ${(@M)${(@f)"$(git status --porcelain --ignore-submodules=all --untracked-files=all 2>/dev/null)"}##'??'*} )

        # If there are untracked files update the message.
        if (( ${#untracked} > 0 )); then
            # Override the message.
            hook_com[message]='1'
            # Set `ret` to non-zero so that our message is used.
            ret=1
        fi
    fi
}

# }}}

# Prompt {{{

typeset -gA Prompt

# Anonymous function to avoid leaking variables.
() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

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

    # Export PROMPT.
    export PROMPT="${SSH_TTY:+${ssh_info}}${wd}${status_info} ${suffix} "

    # Right Prompt

    # Space before full_path, if vcs_info or cmd_elapsed present.
    local path_space='${${Prompt[vcs_info]:-${Prompt[cmd_elapsed]:-}}:+ }'
    # Space before vcs_info, if cmd_elapsed present.
    local vcs_space='${${Prompt[cmd_elapsed]:-}:+ }'

    # The full path, displayed in the right prompt.
    #
    # Not displayed if terminal width is less than 80 columns.
    # Trimmed from left side to fit within a quarter of the terminal width.
    #
    # Adds a space before if VCS info is displayed.
    local full_path="%-80(l.${path_space}%F{blue}%\$(( COLUMNS / 4 ))<...<%~%<<%f.)"

    # VCS branch info, set by async precmd callback.
    local vcs_info="\${Prompt[vcs_info]:+${vcs_space}}\${Prompt[vcs_info]}"

    local italic_on='' italic_off=''
    if (( ${+terminfo[sitm]} && ${+terminfo[ritm]} )); then
        italic_on="%{${terminfo[sitm]}%}"
        italic_off="%{${terminfo[ritm]}%}"
    fi

    # Time taken for previous command.
    local elapsed_time="%F{cyan}${italic_on}\${Prompt[cmd_elapsed]}${italic_off}%f"

    export RPROMPT="${elapsed_time}${vcs_info}${full_path}"
    export ZLE_RPROMPT_INDENT=0
}

export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# }}}

# Hooks {{{

autoload -Uz add-zsh-hook

→prompt_preexec() {
    # Record start time of command.
    .prompt_record_start_time
}
add-zsh-hook preexec →prompt_preexec

→prompt_precmd() {
    # Perform long tasks async to prevent blocking.
    .prompt_async_tasks

    # Report the execution time of previous command.
    .prompt_report_start_time
}
add-zsh-hook precmd →prompt_precmd

# }}}

# Functions {{{

# Timer {{{

typeset -gF EPOCHREALTIME

.prompt_record_start_time() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Set command start time.
    Prompt[cmd_elapsed]=''
    Prompt[cmd_start]=$EPOCHREALTIME
}

.prompt_report_start_time() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # If command start time was set, calculate elapsed time.
    if [[ -n "${Prompt[cmd_start]}" ]]; then
        float -F delta secs
        integer days hours mins

        # Delta time for command in seconds.
        delta=$(( EPOCHREALTIME - Prompt[cmd_start] ))

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
        (( hours > 0 )) && elapsed="${elapsed}${hours}h"
        (( mins > 0 )) && elapsed="${elapsed}${days}m"

        if [[ -z "$elapsed" ]]; then
            elapsed="$(printf '%.2f' $secs)s"
        elif (( days == 0 )); then
            integer int_secs=$(( secs ))
            elapsed="${elapsed}${int_secs}s"
        fi

        Prompt[cmd_start]=''
        Prompt[cmd_elapsed]="$elapsed"
    else
        Prompt[cmd_elapsed]=''
    fi
}

# }}}

# VCS {{{

.prompt_async_vcs_info() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Change directory to the target.
    if [[ -d "$1" ]]; then
        builtin cd -q $1
    else
        # The path is not an existing directory, it may have been removed.
        return 1
    fi

    # The number of times the gitstatus daemon has crashed this prompt.
    integer gitstatus_crashes=$2

    local -A info

    # Execute gitstatus query if function loaded and gitstatus is not disabled.
    if (( gitstatus_crashes != -1 )) && (( ${+functions[gitstatus_query]} )); then
        # Run the query, if it exits with a failure status the daemon has
        # crashed and needs to be restarted.
        if ! gitstatus_query 'gitprompt' 2>/dev/null; then
            export VCS_STATUS_RESULT='crashed'
        fi
    else
        export VCS_STATUS_RESULT='norepo-sync'
    fi

    case "$VCS_STATUS_RESULT" in
        ok-sync)
            info[root]="$VCS_STATUS_WORKDIR"

            # Branch or tag name.
            if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
                info[branch]="$VCS_STATUS_LOCAL_BRANCH"
            elif [[ -n "$VCS_STATUS_TAG" ]]; then
                info[branch]="$VCS_STATUS_TAG"
            else
                info[branch]=''
            fi

            info[revision]="$VCS_STATUS_COMMIT"
            info[action]="$VCS_STATUS_ACTION"
            info[misc]=''

            info[staged]=$(( VCS_STATUS_HAS_STAGED ))
            info[unstaged]=$(( VCS_STATUS_HAS_UNSTAGED == 1 )) # Ignore unknown (-1).
            info[untracked]=$(( VCS_STATUS_HAS_UNTRACKED == 1 )) # Ignore unknown (-1).
            ;;
        norepo-sync)
            # Check other VCS.
            vcs_info >&2

            info[root]="$vcs_info_msg_0_"
            info[branch]="$vcs_info_msg_1_"

            info[revision]="$vcs_info_msg_2_"
            info[action]="$vcs_info_msg_7_"
            info[misc]="$vcs_info_msg_3_"

            info[staged]=$(( vcs_info_msg_4_ ))
            info[unstaged]=$(( vcs_info_msg_5_ ))
            info[untracked]=$(( vcs_info_msg_6_ ))
            ;;
        crashed)
            info[gitstatus_crashes]=$(( gitstatus_crashes + 1 ))
            ;;
    esac

    info[pwd]="$PWD"

    builtin print -r -- "${(@kvq)info}"
}

.prompt_async_tasks() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # The number of times the gitstatus daemon has crashed this prompt.
    # If gitstatus is disabled this value should be -1.
    #
    # This is to prevent an infinite cycle of restarting the daemon only for it
    # to crash.
    integer gitstatus_crashes=${${Prompt[gitstatus_disabled]:+-1}:-$1}

    # Note: exec doesn't accept variables in the form of associative arrays, so
    #       we have to go through a intermediate variable 'async_fd'.
    integer -i 10 async_fd

    # If there is a pending task cancel it.
    if [[ -n "${Prompt[async_fd]}" ]] && { true <&${Prompt[async_fd]} } 2>/dev/null; then
        # Close the file descriptor.
        async_fd=${Prompt[async_fd]}
        exec {async_fd}<&-

        # Remove the handler.
        zle -F $async_fd
    fi

    # No longer within the VCS tree.
    if [[ -n ${Prompt[vcs_root]} ]] && [[ "$PWD" != "${Prompt[vcs_root]}"* ]]; then
        Prompt[vcs_root]=''
        Prompt[vcs_info]=''
    fi

    # Fork a process to fetch VCS info and open a pipe to read from it.
    exec {async_fd}< <(
        # Fetch and print VCS info.
        .prompt_async_vcs_info "$PWD" $gitstatus_crashes
    )
    Prompt[async_fd]=$async_fd

    # When the file descriptor is readable, run the callback handler.
    zle -F $async_fd →prompt_async_callback
}

→prompt_async_callback() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd no_prompt_vars

    integer async_fd=$1
    # Sanity check for the callback.
    if [[ -z "${Prompt[async_fd]}" ]] || (( async_fd != Prompt[async_fd] )); then
        print 'handler callback for wrong fd' >&2
        return
    fi

    # Read from file descriptor.
    local read_in="$(<&$async_fd)"

    # Remove the handler and close the file descriptor.
    Prompt[async_fd]=''
    zle -F "$async_fd"
    exec {async_fd}<&-

    # Check if data read from file descriptor was empty, if so abort.
    [[ -z "$read_in" ]] && return

    local -A info

    # Parse output (z) and unquote as array (Q@).
    info=( "${(Q@)${(z)read_in}}" )

    integer gitstatus_crashes=${info[gitstatus_crashes]}

    # The gitstatus daemon has crashed and needs restarting.
    if (( gitstatus_crashes > 0 )); then
        integer gitstatus_crash_threshold=3

        # If the daemon has crashed a threshold number of times this prompt,
        # there is probably an underlying issue.
        if (( gitstatus_crashes >= gitstatus_crash_threshold )); then
            # If in ZLE move to first column and clear line. The prompt will be
            # reset when the callback chain finishes.
            #
            # This prevents the message from getting garbled.
            zle && print -n "${terminfo[cr]}${terminfo[el]}"

            # Notify the user of the crashes.
            print -P "%F{red}prompt%f: gitstatus daemon crashed %F{yellow}${gitstatus_crashes}%f times in one prompt cycle"
            print -P '%F{blue}prompt%f: switching to %F{green}vcs_info%f backup'

            # Disable gitstatus for the session.
            Prompt[gitstatus_disabled]=1

            # Retrieve enabled vcs_info backends.
            local -aU vi_enabled_backends
            zstyle -a ':vcs_info:*' enable vi_enabled_backends

            # Add git to array of enabled vcs_info backends.
            vi_enabled_backends+=( git )
            zstyle ':vcs_info:*' enable $vi_enabled_backends
        else
            # Restart the gitstatus daemon.
            gitstatus_stop 'gitprompt' 2>/dev/null
            gitstatus_start 'gitprompt'
        fi

        # Rerun the async prompt tasks, keeping track of number of crashes.
        .prompt_async_tasks $gitstatus_crashes

        return
    fi

    # Check if the path has changed since the job started, if so abort.
    [[ "${info[pwd]}" != "$PWD" ]] && return

    Prompt[vcs_root]="${info[root]}"
    Prompt[vcs_pwd]="${info[pwd]}"

    if [[ -n "${info[root]}" ]]; then
        local branch action='' misc='' staged='' unstaged='' untracked=''

        # Use branch, tag, or revision.
        if [[ -n "${info[branch]}" ]]; then
            branch="${info[branch]}"
        else
            branch="${info[revision]:0:9}"
        fi

        # Trim long branch names.
        (( ${#branch} > 32 )) && branch="${branch:0:12}...${branch:0-12}"

        [[ -n "${info[action]}" ]] && action="|${info[action]}"
        [[ -n "${info[misc]}" ]] && misc="(${info[misc]})"

        (( info[staged] )) && staged="%F{green}●%f"
        (( info[unstaged] )) && unstaged="%F{red}●%f"
        (( info[untracked] )) && untracked="%F{blue}●%f"

        Prompt[vcs_info]="[${branch}${action}${misc}${staged}${unstaged}${untracked}]"
    else
        Prompt[vcs_info]=''
    fi

    setopt prompt_vars
    zle && zle reset-prompt
}

# }}}

# }}}
