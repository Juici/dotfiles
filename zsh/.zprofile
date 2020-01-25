# Anonymous function to avoid leaking variables.
() {
    local DOT_ZSH="$HOME/.zsh"

    if [[ -d "$DOT_ZSH" ]]; then
        local -aU files

        # List of possible files to load.
        # Arranged in order to prevent conflicts.
        files=(
            'path'
            'exports'
            # 'programs'
        )

        local file file_path
        for file in $files[@]; do
            file_path="$DOT_ZSH/$file.zsh"
            [[ -f "$file_path" ]] && source "$file_path"
        done
    fi
}
