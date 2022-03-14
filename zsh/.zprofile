# Anonymous function to avoid leaking variables.
() {
    local dot_zsh="$HOME/.zsh"

    if [[ -d "$dot_zsh" ]]; then
        local -aU files

        # List of possible files to load.
        # Arranged in order to prevent conflicts.
        files=(
            'path'
            'exports'
            # 'programs'
        )

        local file file_path
        for file in ${files[@]}; do
            # Source file.
            file_path="${dot_zsh}/${file}.zsh"
            [[ -f "$file_path" ]] && source "$file_path"

            # Source local overrides.
            file_path="${dot_zsh}/${file}.local.zsh"
            [[ -f "$file_path" ]] && source "$file_path"
        done
    fi
}
