# Shortcuts for paths.
#   eg. `cd ~abc`; but also, `jump abc` or `j abc`.
# For a full list, run `hash -d` (alias `d`).

() {
    typeset -AU hashes

    hashes=(
        dotfiles    "${${(%):-%x}:A:h:h:h}"
    )

    local name dir
    for name dir in ${(@kv)hashes}; do
        [[ -d "$dir" ]] && hash -d $name="$dir"
    done
}

