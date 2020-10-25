# Keychain needs to be installed.
(( ${+commands[keychain]} )) || {
    #print 'error: keychain not found' >&2
    return 1
}

_keychain_async_callback() {
    eval "$(<&$1)"

    zle -F "$1"
    exec {1}<&-
}

# If there is a pending task cancel it.
if [[ -n "$_keychain_async_fd" ]] && { true <&$_keychain_async_fd } 2>/dev/null; then
    # Close the file descriptor and remove the handler.
    exec {_keychain_async_fd}<&-
    zle -F $_keychain_async_fd
fi

# Fork a process to run keychain and open a pipe to read from it.
exec {_keychain_async_fd}< <(
    keychain --quiet --confhost --noask --eval id_rsa --agents gpg,ssh
)

zle -F "$_keychain_async_fd" _keychain_async_callback

