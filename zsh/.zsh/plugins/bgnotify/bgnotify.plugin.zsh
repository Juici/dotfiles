# Setup and Requirements {{{

# Must be running in interactive mode.
[[ -o interactive ]] || return

# Must have a display server.
(( $+DISPLAY )) || return

# Must be a local (non ssh) session.
(( ! ( $+SSH_CLIENT || $+SSH_CONNECTION || $+SSH_TTY ) )) || return

# Requires xdotool.
if (( ! ${+commands[xdotool]} )); then
    print 'error: xdotool not found' >&2
    return
fi
# Requires notify-send (libnotify).
if (( ! ${+commands[notify-send]} )); then
    print 'error: notify-send (libnotify) not found' >&2
    return
fi

# Load zsh modules and functions.
zmodload zsh/datetime || {
    print 'error: failed to load zsh/datetime' >&2
    return
}
autoload -Uz add-zsh-hook || {
    print 'error: failed to load add-zsh-hook' >&2
    return
}

# }}}


# Settings
typeset -gF BGNOTIFY_THRESHOLD=30    # Threshold time in seconds.
typeset -gi BGNOTIFY_TIMEOUT=5000    # Notification timeout is milliseconds.
typeset -gaU BGNOTIFY_IGNORE=(
    # editors
    'vim'
    'nvim'
    'nano'

    # pagers
    'less'
    'more'
    'man'

    # other
    'watch'
    'git commit'
    'tig'
    'top'
    'htop'
    'ssh'
)


# Get the id of the active window.
_bgnotify_active_window_id() {
    xdotool getactivewindow
}

# Send a background notification.
_bgnotify_send() {
    local summary=$1 body=$2 exit_status=$3

    local urgency='normal'
    (( exit_status != 0 )) && urgency='critical'

    local timeout=$BGNOTIFY_TIMEOUT

    notify-send "$summary" "$body" --app-name=zsh "--urgency=$urgency" "--expire-time=$timeout"
}

# Pretty-print elapsed time.
_bgnotify_format_time() {
    local delta=${1:-0}

    local days=$((~~($delta / 86400)))
    local hours=$((~~(($delta - $days * 86400) / 3600)))
    local minutes=$((~~(($delta - $days * 86400 - $hours * 3600) / 60)))
    local secs=$(($delta - $days * 86400 - $hours * 3600 - $minutes * 60))
    local elapsed=''
    (( $days > 0)) && elapsed="${days}d"
    (( $hours > 0 )) && elapsed="${elapsed}${hours}h"
    (( $minutes > 0 )) && elapsed="${elapsed}${minutes}m"
    if [[ -z "$elapsed" ]]; then
        secs="$(print -f "%.2f" $secs)s"
    elif (( $days > 0 )); then
        secs=''
    else
        secs="$((~~$secs))s"
    fi
    elapsed="${elapsed}${secs}"

    print -- "$elapsed"
}

typeset -gA _bgnotify

-bgnotify-start() {
    _bgnotify[timestamp]=$EPOCHREALTIME
    _bgnotify[window_id]=$(_bgnotify_active_window_id)
    _bgnotify[command]=$1
}

-bgnotify-end() {
    (( ${+_bgnotify[command]} )) || return

    local prev_status=$?
    local prev_cmd=${_bgnotify[command]}

    # TODO: Check if in ignore list.

    # Trim command message to 30 characters.
    (( $#prev_cmd > 30 )) && prev_cmd="${prev_cmd:0:27}..."

    local threshold=$BGNOTIFY_THRESHOLD
    local delta=$(( $EPOCHREALTIME - ${_bgnotify[timestamp]} ))

    if (( $delta >= $threshold && $(_bgnotify_active_window_id) != ${_bgnotify[window_id]} )); then
        local elapsed=$(_bgnotify_format_time $delta)

        if (( prev_status == 0 )); then
            _bgnotify_send "Command Succeeded" "Command '$prev_cmd' succeeded after $elapsed" "$prev_status"
        else
            _bgnotify_send "Command Failed" "Command '$prev_cmd' failed (exit code $prev_status) after $elapsed" "$prev_status"
        fi
    fi

    unset _bgnotify[command]
}

add-zsh-hook preexec -bgnotify-start
add-zsh-hook precmd -bgnotify-end
