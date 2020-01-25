jump() {
    emulate -L zsh

    # No argument.
    if (( $# == 0 )); then
        print 'jump: no argument' >&2
        return 1
    fi

    local target=$@

    if (( ! ${+nameddirs[$target]} )); then
        print "jump: invalid target: $target" >&2
        return 1
    fi

    cd "${nameddirs[$target]}"
}

