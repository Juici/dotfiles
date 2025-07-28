# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# Keychain command is required.
# (( ${+commands[keychain]} )) || return

→keychain-eval-callback() {
    local keychain_eval=$1

    # Remove the callback function.
    unfunction →keychain-eval-callback

    # Evaluate keychain output.
    builtin eval "${keychain_eval}"
}

autoload -Uz @async-task

@async-task →keychain-eval-callback <(
    keychain \
        --eval \
        --quiet \
        --noask \
        --confallhosts \
        --ignore-missing \
        ${HOME}/.ssh/*.pub(.N:t:r)
)
