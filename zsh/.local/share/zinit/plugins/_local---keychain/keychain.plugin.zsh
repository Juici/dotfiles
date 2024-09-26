() {
    local -a keys
    keys=( $HOME/.ssh/*.pub(.) )
    keys=( "${keys[@]:t:r}" )

    eval "$(keychain --quiet --confhost --noask --eval $keys --agents gpg,ssh)"
}
