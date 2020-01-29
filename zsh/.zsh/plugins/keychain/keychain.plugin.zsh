# Keychain needs to be installed.
(( ${+commands[keychain]} )) || {
    #print 'error: keychain not found' >&2
    return 1
}

eval $(keychain --quiet --confhost --noask --eval id_rsa --agents gpg,ssh)

