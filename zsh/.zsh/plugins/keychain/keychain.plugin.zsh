# Keychain needs to be installed.
(( ${+commands[keychain]} )) || {
    #print 'error: keychain not found' >&2
    return 1
}

_keychain_async_callback() {
    # Eval keychain output.
    eval "$(<&$1)"

    # Close the file descriptor and the remove handler.
    exec {1}<&-
    zle -F "$1"

    # Unset the keychain async fd variable.
    unset _keychain_async_fd
}

# If there is a pending task cancel it.
if [[ -n "$_keychain_async_fd" ]] && { true <&$_keychain_async_fd } 2>/dev/null; then
    # Close the file descriptor and remove the handler.
    exec {_keychain_async_fd}<&-
    zle -F $_keychain_async_fd

    # Unset the keychain async fd variable.
    unset _keychain_async_fd
fi

# Fork a process to run keychain and open a pipe to read from it.
exec {_keychain_async_fd}< <(
    keychain --quiet --confhost --noask --eval id_rsa --agents gpg,ssh
)

zle -F "$_keychain_async_fd" _keychain_async_callback

