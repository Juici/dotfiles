# Plugins {{{

# Zsh completion functions.
zinit wait lucid blockf for \
    atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# Python pip completions.
zinit wait lucid blockf for \
    as'completion' \
    OMZP::pip/_pip \
    atload'unalias pipreq; unalias pipir' \
    OMZP::pip

# Rust completions.
zinit wait lucid blockf for \
    Juici/zsh-rust-completions

# Pnpm completions.
zinit wait lucid blockf for \
    atclone'./zplug.zsh' \
    atpull'%atclone' \
    g-plane/pnpm-shell-completion

# General completions.
zinit wait lucid blockf for \
    _local/completions

# }}}

# Options {{{

# Options.
setopt no_menu_complete     # do not auto select first entry
setopt auto_menu            # show completion menu on tab press
setopt complete_in_word
setopt always_to_end

# Do nothing when no completion match exists.
setopt no_nomatch

# }}}

# Zstyle {{{

# Navigatable completion menu.
zstyle ':completion:*:*:*:*:*' menu select

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list \
    '' \
    '+m:{[:lower:]}={[:upper:]}' \
    '+m:{[:upper:]}={[:lower:]}' \
    '+m:{_-}={-_}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Colour completions using default `ls` colours, this can be overridden later.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Complete processes.
if [[ "$OSTYPE" = solaris* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
else
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
fi
# Colour processes.
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Don't complete user pollution.
zstyle ':completion:*:*:*:*:users' ignored-patterns \
    avahi bin brltty clamav colord cups daemon dbus dhcpcd dnsmasq flatpak ftp \
    geoclue git gluster http libvirt-qemu mail mpd nm-openconnect nm-openvpn \
    nobody ntp nvidia-persistenced openvpn polkitd postgres qemu rpc rpcuser \
    rtkit saned sddm systemd-bus-proxy systemd-coredump systemd-journal-gateway \
    systemd-journal-remote systemd-network systemd-oom systemd-resolve \
    systemd-timesync tor tss usbmux uuidd
# Unless we really want to.
zstyle ':completion:*' single-ignored show

# }}}
