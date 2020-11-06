#/bin/sh

DOT_TMUX="$(dirname $(realpath "$0"))"

load_modules() {
    local dir="$1"

    if [ -d "$dir" ]; then
        local module
        for module in $dir/*.tmux; do
            tmux source -q "$module"
        done
    fi
}

init() {
    tmux set -s @dot-tmux "$DOT_TMUX"

    load_modules "$DOT_TMUX/modules"
}

init
