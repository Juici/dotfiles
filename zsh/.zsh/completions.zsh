# {{{ Plugins

# Zsh completion functions.
zplugin ice blockf
zplugin light zsh-users/zsh-completions

# Rust completions
zplugin ice id-as'local/rust-completions' blockf
zplugin light $LOCAL_PLUGINS/rust

# Python pip completions.
zplugin ice svn as'completion' pick'_pip'
zplugin snippet OMZ::plugins/pip

# }}}

# {{{ Options

# Options.
setopt no_menu_complete     # do not auto select first entry
setopt auto_menu            # show completion menu on tab press
setopt complete_in_word
setopt always_to_end

# Do nothing when no completion match exists.
setopt no_nomatch

# }}}

# {{{ Zstyle

# Navigatable completion menu.
zstyle ':completion:*:*:*:*:*' menu select

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Colour completions using default `ls` colours, this is overridden later.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

if [[ "$OSTYPE" = solaris* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
else
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
fi

# }}}
