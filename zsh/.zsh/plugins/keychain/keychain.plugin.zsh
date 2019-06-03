# Keychain needs to be installed.
(( ${+commands[keychain]} )) || {
    #print 'error: keychain not found' >&2
    return 1
}

#eval $(keychain --quiet --confhost --noask --eval id_rsa --agents gpg,ssh)

keychain_async_start() {
    keychain --quiet --confhost --noask --eval id_rsa --agents gpg,ssh
}

keychain_start() {
    # Initialise async worker.
    if (( ! ${keychain_async_init:-0} )); then
        async_start_worker 'keychain' -u -n
        async_register_callback 'keychain' keychain_async_callback
        typeset -g keychain_async_init=1
    fi

    # Async start keychain.
    async_job 'keychain' keychain_async_start
}

keychain_async_callback() {
    local job=$1 code=$2 stdout=$3 exec_time=$4 stderr=$5 next_pending=$6

    case $job in
        \[async])
            # Code 1: corrupted worker output.
            # Code 2: dead worker.
            if (( $code == 2 )); then
                # The worker died unexpectedly.
                typeset -g keychain_async_init=0
            fi

            # Fallback.
            eval "$(keychain_async_start)"
            ;;
        keychain_async_start)
            if [[ -n $stderr ]]; then
                print "[keychain_init] $stdout" >&2
                zle && zle .reset-prompt

                # Fallback.
                eval "$(keychain_async_start)"
            else
                eval "$stdout"
            fi

            async_stop_worker 'keychain'
            ;;
    esac
}

keychain_start
