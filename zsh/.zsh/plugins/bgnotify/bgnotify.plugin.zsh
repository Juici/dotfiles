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

# Get the id of the active window.
bgnotify_active_window_id() {
    xdotool getactivewindow
}

# Send a background notification.
bgnotify() {
    local summary=$1 body=$2
    notify-send "$summary" "$body"
}

# Pretty-print elapsed time.
bgnotify_pp_time() {
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

    print "$elapsed"
}

typeset -gF SECONDS
typeset -gA _bgnotify

-bgnotify-start() {
    _bgnotify[timestamp]=$EPOCHREALTIME
    _bgnotify[window_id]=$(bgnotify_active_window_id)
    _bgnotify[command]=$1
}

-bgnotify-end() {
    (( ${+_bgnotify[command]} )) || return

    local prev_status=$?
    local prev_cmd=${_bgnotify[command]}
    (( $#prev_cmd > 30 )) && prev_cmd="${prev_cmd:0:27}..."

    local threshold=${BGNOTIFY_THRESHOLD:-30}
    local delta=$(( $EPOCHREALTIME - ${_bgnotify[timestamp]} ))

    if (( $delta >= $threshold && $(bgnotify_active_window_id) != ${_bgnotify[window_id]} )); then
        local elapsed=$(bgnotify_pp_time $delta)

        if (( prev_status == 0 )); then
            bgnotify "Command Succeeded" "Command '$prev_cmd' succeeded after $elapsed"
        else
            bgnotify "Command Failed" "Command '$prev_cmd' failed after $elapsed"
        fi
    fi

    unset _bgnotify[command]
}

add-zsh-hook preexec -bgnotify-start
add-zsh-hook precmd -bgnotify-end
