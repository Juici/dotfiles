# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# Config [[[

# Load required modules.
zmodload zsh/datetime
zmodload zsh/zutil

# Load required functions.
autoload -Uz @async-task vcs_info add-zsh-hook

# Substitute colours in prompt.
setopt prompt_subst

# Create a hashtable to store variables without polluting scope.
typeset -gA Prompt

Prompt[aid]="${$}-${RANDOM}${RANDOM}"

# Icons.
case "$TERM" in
    (linux|tmux)
        Prompt+=(
            i-prompt    '>'
            i-dot       '∙'
            i-ellipsis  '...'
            i-branch    ''
        )
        ;;
    (*)
        Prompt+=(
            i-prompt    '❯'
            i-dot       '∙'
            i-ellipsis  '…'
            i-branch    ' '
        )
        ;;
esac

# Control sequences for shell integration with terminal.
Prompt+=(
    pre-ps1     $'%{\e]133;A;k=i;click_events=1;aid='"${Prompt[aid]}"$'\a\e]133;P;k=i\a%}'
    post-ps1    $'%{\e]133;B\a%}'

    pre-ps2     $'%{\e]133;A;k=s;click_events=1;aid='"${Prompt[aid]}"$'\a\e]133;P;k=s\a%}'
    post-ps2    $'%{\e]133;B\a%}'

    # pre-exec    $'%{\e]133;C;cmdline=%1v\a%}'
    # post-exec   $'%{\e]133;D;%?;aid='"${Prompt[aid]}"$'\a%}'
)

() {
    local -i10 shlvl=$(( SHLVL > 0 ? SHLVL : 1 ))
    local char="${Prompt[i-prompt]}"

    # Repeat prompt character for shell level.
    Prompt[shlvl-prompt]="${(pl:$shlvl::$char:)}"
}

# ]]]

# VCS info [[[

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
zstyle ':vcs_info:*' enable git svn
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
    local -i10 n=$1

    # `vcs_info_msg_6_` carries the 'has untracked' state, it defaults to `0`.
    if (( n == 6 )); then
        # Untracked files are marked by lines starting '??', so we filter on
        # those lines.
        local -a untracked
        untracked=( "${(@M)${(@f)"$(git status --porcelain --no-ahead-behind --no-renames --ignore-submodules=all --untracked-files=all 2>/dev/null)"}##'??'*}" )

        # If there are untracked files update the message.
        if (( ${#untracked} > 0 )); then
            # Override the message.
            hook_com[message]='1'
            # Set `ret` to non-zero so that our message is used.
            ret=1
        fi
    fi
}

.prompt-async-vcsinfo() {
    # If it looks like we are no longer within the VCS tree, then clear the VCS info from the prompt.
    if [[ -n "${Prompt[vcs_root]}" ]] && [[ "$PWD" != "${Prompt[vcs_root]}"* ]]; then
        Prompt[vcs_root]=
        Prompt[vcs_info]=
    fi

    @async-task →prompt-async-vcsinfo-callback <(
        # Sanity check the path is an existing directory, since it may have been removed.
        [[ -d "$PWD" ]] || return 1

        # Fetch VCS info.
        vcs_info >&2

        local -A info=(
            pwd         "$PWD"
            timestamp   "$EPOCHREALTIME"

            root        "$vcs_info_msg_0_"
            branch      "$vcs_info_msg_1_"

            revision    "$vcs_info_msg_2_"
            action      "$vcs_info_msg_7_"
            misc        "$vcs_info_msg_3_"

            staged      "$vcs_info_msg_4_"
            unstaged    "$vcs_info_msg_5_"
            untracked   "$vcs_info_msg_6_"
        )

        builtin print -rn -- "${(@kvq)info}"
    )
}

→prompt-async-vcsinfo-callback() {
    local output=$1

    local -A info=( "${(@Q)${(@z)output}}" )

    # Ignore out of order info.
    (( info[timestamp] > Prompt[timestamp] )) || return

    # If the working directory has changed, ignore.
    [[ "${info[pwd]}" = "$PWD" ]] || return

    Prompt[vcs_root]="${info[root]}"
    Prompt[vcs_pwd]="${info[pwd]}"

    if [[ -n "${info[root]}" ]]; then
        local branch="${info[branch]}" state __status

        # Use branch, tag, or revision.
        if (( ${#branch} > 32 )); then
            # Trim long branch names.
            branch="${branch:0:$(( 32 - ${#Prompt[i-ellipsis]} ))}${Prompt[i-ellipsis]}"
        elif [[ -z "$branch" ]]; then
            branch="${info[revision]:0:9}"
        fi
        branch=" on %B%F{magenta}${Prompt[i-branch]}${(V)branch}%f%b"

        [[ -n ${info[action]} ]] && state=" %B%F{yellow}(${(V)info[action]})%f%b"

        (( info[unstaged] )) && __status+='!'
        (( info[staged] )) && __status+='+'
        (( info[untracked] )) && __status+='?'
        __status="${__status:+" %B%F{red}[${__status}]%f%b"}"

        Prompt[vcs_info]="${branch}${state}${__status}"
    else
        Prompt[vcs_info]=
    fi

    [[ -o zle ]] && zle reset-prompt
}

# ]]]

# Functions [[[

.prompt-format-duration() {
    local -i10 end_secs=$1 end_nanos=$2 start_secs=$3 start_nanos=$4 \
        dsecs dnanos days hours mins secs millis micros nanos

    ((
        dsecs = end_secs - start_secs,
        dnanos = end_nanos - start_nanos
    ))

    if (( dnanos < 0 )); then
        ((
            dsecs -= 1,
            dnanos += 1000000000
        ))
    fi

    ((
        nanos = dnanos % 1000,
        dnanos /= 1000,
        micros = dnanos % 1000,
        dnanos /= 1000,
        millis = dnanos,

        secs = dsecs % 60,
        dsecs /= 60,
        mins = dsecs % 60,
        dsecs /= 60,
        hours = dsecs % 24,
        dsecs /= 24,
        days = dsecs
    ))

    local result

    (( days > 0 )) && result+="${days}d"
    (( hours > 0 )) && result+="${hours}h"
    (( mins > 0 )) && result+="${mins}m"

    if (( days == 0 )); then
        (( secs > 0 )) && result+="${secs}s"

        if (( (hours | mins) == 0 )); then
            (( millis > 0 )) && result+="${millis}ms"

            if (( secs == 0 )); then
                (( micros > 0 )) && result+="${micros}µs"
                (( millis == 0 && nanos > 0 )) && result+="${nanos}ns"
            fi
        fi
    fi

    print -rn -- "$result"
}

.prompt-username() {
    local user="$USERNAME"
    local -i10 is_root is_ssh

    ((
        is_root = EUID == 0,
        is_ssh = ${+SSH_TTY} || ${+SSH_CLIENT} || ${+SSH_CONNECTION}
    ))

    # If not root and not an ssh connection: check if the user differs from the login user.
    # Otherwise don't show the user in the prompt.
    (( is_root || is_ssh )) || [[ -z "$LOGNAME" || "$user" != "$LOGNAME" ]] || return

    (( is_root )) && user="%B%F{red}${user}%f%b" || user="%B%F{yellow}${user}%f%b"
    (( is_ssh )) && user+='%B%F{cyan}@%m%f%b'

    print -rn -- "$user in "
}

# ]]]

# Hooks [[[

→prompt-preexec() {
    builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # builtin print -rn -- "${(%)Prompt[pre-exec]}"
    builtin print -rn -- $'\e]133;C;'"${(q)1}"$'\a'

    Prompt[cmd_duration]=
    Prompt[cmd_start]="${epochtime[@]}"
}

→prompt-precmd() {
    builtin emulate -LR zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    local -a time=( "${epochtime[@]}" )
    local -i10 cmd_status=$status

    if [[ -n "${Prompt[cmd_start]}" ]]; then
        # builtin print -rn -- "${(%)Prompt[post-exec]}"
        builtin print -rn -- $'\e]133;D;'"${cmd_status};aid=${Prompt[aid]}"$'\a'

        Prompt[cmd_duration]="$(.prompt-format-duration "${time[@]}" "${(z)Prompt[cmd_start]}")"
        Prompt[cmd_start]=
    else
        Prompt[cmd_duration]=
    fi

    .prompt-async-vcsinfo
}

add-zsh-hook preexec →prompt-preexec
add-zsh-hook precmd →prompt-precmd

# Handle prompt click events.
→prompt-onclick-sgr1006() {
    local b

    # TODO: Parse and handle click.
    #
    # https://github.com/kovidgoyal/kitty/blob/a0b73b4c19586488a38cf082b170361773a11040/kitty/mouse.c#L519
    # https://github.com/kovidgoyal/kitty/blob/a0b73b4c19586488a38cf082b170361773a11040/kitty/mouse.c#L94
    #
    # https://github.com/kovidgoyal/kitty/blob/a0b73b4c19586488a38cf082b170361773a11040/shell-integration/zsh/kitty-integration#L56

    # Read bytes until a CSI dispach byte (0x40..=0x7e).
    while
        read -k b

        (( #b < 0x40 || #b > 0x7e ))
    do :; done
}

zle -N →prompt-onclick-sgr1006
bindkey '\e[<' →prompt-onclick-sgr1006

# ]]]

# Prompts [[[

.prompt-format-prompt() {
    local -i10 shlvl=$(( SHLVL > 0 ? SHLVL : 1 ))
    local user directory duration jobs prompt

    user="$(.prompt-username)"

    directory='%B%F{blue}%~%f%b'
    duration="${Prompt[cmd_duration]:+" took %B%F{yellow}${Prompt[cmd_duration]}%f%b"}"

    jobs='%(1j.%B%F{yellow}*%j%f%b .)'
    prompt="%B%F{%(?.green.red)}${Prompt[shlvl-prompt]}%f%b "

    builtin print -rnl -- "${user}${directory}${Prompt[vcs_info]}${duration}" "${jobs}${prompt}"
}

PS1='${Prompt[pre-ps1]}$(.prompt-format-prompt)${Prompt[post-ps1]}'
PS2='${Prompt[pre-ps2]}%F{8}${Prompt[i-dot]}%f ${Prompt[post-ps2]}'
PS3='%B%F{blue}${Prompt[i-prompt]}%f%b '
PS4='%F{8}+ %N%F{0}:%F{8}%i > %f'

RPS1=
RPS2=
ZLE_RPROMPT_INDENT=0

# Spelling correction prompt.
SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Un%u%bo, %B%Uy%u%bes, %B%Ua%u%bbort, %B%Ue%u%bdit]? "

# ]]]
