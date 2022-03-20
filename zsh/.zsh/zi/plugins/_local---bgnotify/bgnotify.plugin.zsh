# Setup and Requirements {{{

# Must be running in interactive mode.
[[ -o interactive ]] || return

# Must have a display server.
[[ -v DISPLAY ]] || return

# Must be a local (non ssh) session.
[[ ! ( -v SSH_CLIENT || -v SSH_CONNECTION || -v SSH_TTY ) ]] || return

# Requires wmutils pfw.
if (( ! ${+commands[pfw]} )); then
    print -u2 'bgnotify: pfw (wmutils) not found'
    return 1
fi
# Requires notify-send (libnotify).
if (( ! ${+commands[notify-send]} )); then
    print -u2 'bgnotify: notify-send (libnotify) not found'
    return 1
fi

# Load zsh modules and functions.
zmodload zsh/datetime || {
    print -u2 'bgnotify: failed to load zsh/datetime'
    return 1
}
autoload -Uz add-zsh-hook || {
    print -u2 'bgnotify: failed to load add-zsh-hook'
    return 1
}
autoload -Uz throw || {
    print -u2 'bgnotify: failed to load throw'
    return 1
}

# }}}

typeset -gA BgNotify

# Settings used by the plugin.
typeset -gF BGNOTIFY_THRESHOLD=${BGNOTIFY_THRESHOLD:-30}    # Threshold time in seconds.
typeset -gi BGNOTIFY_TIMEOUT=${BGNOTIFY_TIMEOUT:-5000}      # Notification timeout is milliseconds.
typeset -gaU BGNOTIFY_IGNORE=(
    # Editors.
    'vim'
    'nvim'
    'nano'

    # Pagers.
    'less'
    'more'
    'man'

    # Other blocking commands.
    'watch'
    'git commit'
    'tig'
    'top'
    'htop'
    'ssh'

    # Any commands defined before loading plugin.
    $BGNOTIFY_IGNORE
)

# Get the ID of the active window.
.bgnotify_active_window_id() {
    integer -i 10 window_id
    window_id=$(pfw 2>/dev/null) || throw
    return $window_id
}
functions -M bgnotify_active_window_id 0 0 .bgnotify_active_window_id

# Send a background notification.
.bgnotify_send() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    local summary=$1 body=$2 exit_status=$3

    local urgency='normal'
    (( exit_status != 0 )) && urgency='critical'

    integer -i 10 timeout=$BGNOTIFY_TIMEOUT

    notify-send "$summary" "$body" --app-name=zsh "--urgency=$urgency" "--expire-time=$timeout"
}

→bgnotify_start() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    ((
        BgNotify[window_id] = bgnotify_active_window_id(),
        BgNotify[timestamp] = EPOCHREALTIME
    )) || return 1

    BgNotify[command]="$1"
}

→bgnotify_end() {
    emulate -L zsh
    setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    [[ -v BgNotify[command] ]] || return 0

    {
        local prev_status=$?
        local prev_cmd=${BgNotify[command]}

        # TODO: Check if in ignore list.

        # Trim command message to 30 characters.
        (( ${#prev_cmd} > 30 )) && prev_cmd="${prev_cmd:0:27}..."

        float -F delta
        (( delta = EPOCHREALTIME - BgNotify[timestamp] ))

        if (( delta > BGNOTIFY_THRESHOLD && bgnotify_active_window_id() != BgNotify[window_id] )); then
            local -F secs
            local -i 10 days hours mins

            ((
                secs = delta % 60,
                delta /= 60,
                mins = delta % 60,
                delta /= 60,
                hours = delta % 24,
                days = delta / 24
            ))

            # Construct time elapsed string.
            local elapsed=
            (( days > 0 )) && elapsed="${days}d"
            (( hours > 0 )) && elapsed="${elapsed}${hours}h"
            (( mins > 0 )) && elapsed="${elapsed}${days}m"

            if [[ -z "$elapsed" ]]; then
                elapsed="$(printf '%.2f' $secs)s"
            elif (( days == 0 )); then
                elapsed="${elapsed}$(( secs | 0 ))s"
            fi

            if (( prev_status == 0 )); then
                .bgnotify_send "Command Succeeded" "Command '$prev_cmd' succeeded after $elapsed" "$prev_status"
            else
                .bgnotify_send "Command Failed" "Command '$prev_cmd' failed (exit code $prev_status) after $elapsed" "$prev_status"
            fi
        fi
    } always {
        unset 'BgNotify[command]'
    }
}

add-zsh-hook preexec →bgnotify_start
add-zsh-hook precmd →bgnotify_end
