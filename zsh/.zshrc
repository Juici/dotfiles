# Global Vars {{{

# Create a hash table for globally stashing variables without polluting main
# scope.
typeset -gAH __JUICI

# }}}

# Load zplugin {{{

# Declare $ZPLGM global.
typeset -gAH ZPLGM

ZPLGM[HOME_DIR]="$HOME/.zplugin"

# Load zsh compile module.
module_path+=( "${ZPLGM[HOME_DIR]}/bin/zmodules/Src" )
zmodload -s zdharma/zplugin || echo 'error: zdharma/zplugin module not found' >&2

ZPLGM[ZERO]="${ZPLGM[HOME_DIR]}/bin/zplugin.zsh"

# Install zplugin if missing.
if [[ ! -f "${ZPLGM[ZERO]}" ]]; then
    if (( ${+commands[curl]} )); then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
    else
        print 'error: could not install zplugin: curl not found' >&2
        print 'zplugin must be installed manually, or curl must be installed' >&2

        print ''
        print 'errors may occur if loading continues'

        # Anonymous function to avoid leaking variables.
        () {
            # Prompt the user if they want to exit the shell.
            # Gives the user time to read the error and the option continue.
            local yesno
            read -k 1 'yesno?Do you wish to continue? [Y/n]'

            case $yesno in
                [yY])
                    # Do nothing on yes.
                    ;;
                *)
                    # Exit shell by default.
                    exit 1
                    ;;
            esac
        }
    fi
fi

# Load zplugin.
source "${ZPLGM[ZERO]}"
autoload -Uz _zplugin
(( $+_comps )) && _comps[zplugin]=_zplugin

# }}}

# Initialise {{{

setopt extended_glob

typeset -g LOCAL_PLUGINS="$HOME/.zsh/plugins"

# Async workers.
zplugin light mafredri/zsh-async

# }}}

# Load Modules {{{

# Anonymous function to avoid leaking variables.
() {
    local DOT_ZSH="$HOME/.zsh"

    if [[ -d "$DOT_ZSH" ]]; then
        local -aU files

        # List of possible files to load.
        # Arranged in order to prevent conflicts.
        files=(
            'colors'
            'path'
            'completions'
            'prompt'
            'history'
            'options'
            'keybinds'
            'aliases'
            'exports'
            'functions'
            'hash'
            'hooks'
            'programs'
            'plugins'
        )

        local file file_path
        for file in $files[@]; do
            file_path="$DOT_ZSH/$file.zsh"
            [[ -f "$file_path" ]] && source "$file_path"
            # TODO: Look into sourcing each file in its own scope.
        done
    fi
}

# }}}

# Finalise {{{

# Load local overrides.
LOCAL_RC="$HOME/.zshrc.local"
[[ -f "$LOCAL_RC" ]] && source "$LOCAL_RC"

# }}}
