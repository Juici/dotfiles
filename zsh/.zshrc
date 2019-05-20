# {{{ Global Vars

# Create a hash table for globally stashing variables without polluting main
# scope.
typeset -A __VARS

__VARS[ITALIC_ON]="${terminfo[sitm]}"
__VARS[ITALIC_OFF]="${terminfo[ritm]}"

# }}}

# {{{ Load zplugin

__VARS[ZPLG_HOME]="${ZDOTDIR:-$HOME}/.zplugin"

# Load zsh compile module.
module_path+=( "${__VARS[ZPLG_HOME]}/bin/zmodules/Src" )
zmodload -s zdharma/zplugin || echo 'error: zdharma/zplugin module not found' >&2

__VARS[ZPLG]="${__VARS[ZPLG_HOME]}/bin/zplugin.zsh"

# Install zplugin if missing.
if [[ ! -f "${__VARS[ZPLG]}" ]]; then
    if (( ${+commands[curl]} )); then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
    else
        print 'error: curl not found' >&2
        exit 1
    fi
fi

source "${__VARS[ZPLG]}"
autoload -Uz _zplugin
(( $+_comps )) && _comps[zplugin]=_zplugin

# }}}

# {{{ Initialise

setopt extended_glob

typeset -g LOCAL_PLUGINS="$HOME/.zsh/plugins"

# Async workers.
zplugin light mafredri/zsh-async

# }}}

# {{{ Load Modules

# Anonymous function to avoid leaking variables.
() {
    local DOT_ZSH="$HOME/.zsh"

    if [[ -d "$DOT_ZSH" ]]; then
        local file
        local -aU files

        files=(
            'colors'
            'completions'
            'prompt'
            'history'
            'options'
            'keybinds'
            'aliases'
            'exports'
            'functions'
            'hash'
            'path'
            'hooks'
            'plugins'
        )

        for file in $files[@]; do
            file_path="$DOT_ZSH/$file.zsh"
            [[ -f "$file_path" ]] && source "$file_path"
        done
    fi
}

# }}}

# {{{ Finalise

# Load local overrides.
LOCAL_RC="$HOME/.zshrc.local"
[[ -f "$LOCAL_RC" ]] && source "$LOCAL_RC"

# }}}
