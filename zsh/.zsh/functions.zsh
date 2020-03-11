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

battery() {
    emulate -L zsh

    local battery='/sys/class/power_supply/BAT1'

    local -F bnow bfull bdesign

    let "bnow = $(<$battery/energy_now)"
    let "bfull = $(<$battery/energy_full)"
    let "bdesign = $(<$battery/energy_full_design)"

    local -F pbat phealth

    let "pbat = 100 * bnow / bfull"
    let "phealth = 100 * bfull / bdesign"

    printf 'Battery: %.1f%% (Health: %.1f%%)\n' $pbat $phealth
}

