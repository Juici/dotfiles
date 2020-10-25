# Setup {{{

# Substitute colours in prompt.
setopt prompt_subst

# Load colors module.
autoload -Uz colors
colors

# Load gitstatus plugin and start daemon.
zinit ice wait lucid atload'gitstatus_stop "gitprompt" && gitstatus_start "gitprompt"'
zinit load romkatv/gitstatus

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' stagedstr '1' # Boolean value.
zstyle ':vcs_info:*' unstagedstr '1' # Boolean value.
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 7

# VCS format strings.
# %R - top repo directory
# %b - branch
# %i - revision
# %a - action
# %m - misc
# %c - stagedstr
# %u - unstagedstr
zstyle ':vcs_info:*:*' formats '%R' '%b' '%i' '%m' '%c' '%u'
zstyle ':vcs_info:*:*' actionformats '%R' '%b' '%i' '%m' '%c' '%u' '%a'

# }}}

# Prompt {{{

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
    local path_space='${${prompt_vcs_info[info]:-${prompt_cmd_elapsed:-}}:+ }'
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
    local vcs_info="\${prompt_vcs_info[info]:+${vcs_space}}\${prompt_vcs_info[info]}"

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

# Timer {{{

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

# }}}

# VCS {{{

-prompt-async-vcs-info() {
    local wd=$1

    builtin cd -q $wd

    local -A info

    # Execute gitstatus query if function loaded.
    if command -v gitstatus_query >/dev/null; then
        gitstatus_query 'gitprompt'
    else
        VCS_STATUS_RESULT='norepo-sync'
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
            info[unstaged]=$(( VCS_STATUS_HAS_UNSTAGED == 1 )) # Ignore unknown = -1.
            info[untracked]=$(( VCS_STATUS_HAS_UNTRACKED == 1 )) # Ignore unknown = -1.
            ;;
        norepo-sync)
            # Check other VCS.
            vcs_info

            info[root]="$vcs_info_msg_0_"
            info[branch]="$vcs_info_msg_1_"
            info[revision]="$vcs_info_msg_2_"
            info[action]="$vcs_info_msg_6_"
            info[misc]="$vcs_info_msg_3_"
            info[staged]=$(( vcs_info_msg_4_ ))
            info[unstaged]=$(( vcs_info_msg_5_ ))
            info[untracked]=0
            ;;
    esac

    info[pwd]="$PWD"

    builtin print -r -- "${(@kvq)info}"
}

-prompt-async-tasks() {
    # If there is a pending task cancel it.
    if [[ -n "$_prompt_async_fd" ]] && { true <&$_prompt_async_fd } 2>/dev/null; then
        # Close the file descriptor and remove the handler.
        exec {_prompt_async_fd}<&-
        zle -F $_prompt_async_fd
    fi

    typeset -gA prompt_vcs_info

    # No longer within the VCS tree.
    if [[ -n ${prompt_vcs_info[root]} ]] && [[ "$PWD" != "${prompt_vcs_info[root]}"* ]]; then
        prompt_vcs_info[root]=''
        prompt_vcs_info[info]=''
    fi

    # Fork a process to fetch VCS info and open a pipe to read from it.
    exec {_prompt_async_fd}< <(
        # Fetch and print VCS info.
        -prompt-async-vcs-info "$PWD"
    )

    # When the file descriptor is readable, run the callback handler.
    zle -F "$_prompt_async_fd" -prompt-async-callback
}

-prompt-async-callback() {
    typeset -gA prompt_vcs_info

    # Read from file descriptor.
    local read_in="$(<&$1)"

    # Remove the handler and close the file descriptor.
    zle -F "$1"
    exec {1}<&-

    local -A info

    # Parse output (z) and unquote as array (Q@).
    info=( "${(Q@)${(z)read_in}}" )

    # Check if the path has changed since the job started, if so abort.
    [[ "${info[pwd]}" != "$PWD" ]] && return

    prompt_vcs_info[root]="${info[root]}"
    prompt_vcs_info[pwd]="${info[pwd]}"

    if [[ -n "${prompt_vcs_info[root]}" ]]; then
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

        prompt_vcs_info[info]="[${branch}${action}${misc}${staged}${unstaged}${untracked}]"
    else
        prompt_vcs_info[info]=''
    fi

    zle && zle .reset-prompt
}

# }}}

# }}}
