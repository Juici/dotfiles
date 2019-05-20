# Requires interactive terminal bat to be installed.
[[ -o interactive ]] && (( ${+commands[bat]} )) || return

# {{{ Variable Declaration

# Variables
local -a opts
local -A map_syntax
local k v pager

# }}}

# Options.
opts=(
    # Set sane defaults.
    --paging='never'        # No paging by default.
    --italic-text='always'  # Allow italics.

    # Theme and styling.
    --theme='TwoDark'
    --style='changes,header,numbers,grid'
)

# Syntax mapping.
map_syntax=(
    .ignore     gitignore
)

# Pager.
pager='less -RF'

# {{{ Export Variables

for k v in ${(@kvq)map_syntax}; do
    opts+=( --map-syntax="${k}:${v}" )
done

export BAT_PAGER="$pager" # Bat seems to ignore pager set in options.
(( $#opts > 0 )) && export BAT_OPTS="$(print -f '%s\n' -- "${(@q)opts}")"

# }}}

alias batp='bat --paging=always'
