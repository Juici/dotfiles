# Global Vars {{{

# Create a hashtable to store global variables without polluting scope.
typeset -gA Juici

Juici[RC]="$HOME/.zshrc"
Juici[RC_LOCAL]="$HOME/.zshrc.local"
Juici[DOT_ZSH]="$HOME/.zsh"
Juici[PLUGINS]="${Juici[DOT_ZSH]}/plugins"

# }}}

# Load zinit {{{

# Declare $ZINIT global.
typeset -gA ZINIT

ZINIT[HOME_DIR]="$HOME/.zinit"

# Load zsh compile module.
module_path+=( "${ZINIT[HOME_DIR]}/bin/zmodules/Src" )
zmodload -s zdharma/zplugin || echo 'error: zdharma/zplugin module not found' >&2

ZINIT[ZERO]="${ZINIT[HOME_DIR]}/bin/zinit.zsh"

# Install zinit if missing.
if [[ ! -f "${ZINIT[ZERO]}" ]]; then
    if (( ${+commands[curl]} )); then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
    else
        print 'error: could not install zinit: curl not found' >&2
        print 'zinit must be installed manually, or curl must be installed' >&2

        print ''
        print 'errors may occur if loading continues'

        # Anonymous function to avoid leaking variables.
        () {
            # Prompt the user if they want to exit the shell.
            # Gives the user time to read the error and the option continue.
            local yesno
            read -k 1 'yesno?Do you wish to continue? [y/N]'

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

# Load zinit.
source "${ZINIT[ZERO]}"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# }}}

# Initialise {{{

setopt extended_glob

# Async workers.
#zinit light Juici/zsh-async
#zinit light mafredri/zsh-async

# }}}

# Load Modules {{{

# Anonymous function to avoid leaking variables.
() {
    if [[ -d "${Juici[DOT_ZSH]}" ]]; then
        local -aU files

        # List of possible files to load.
        # Arranged in order to prevent conflicts.
        files=(
            'path'
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
            'hooks'
            'programs'
            'plugins'
        )

        local file file_path
        for file in ${files[@]}; do
            # Source file.
            file_path="${Juici[DOT_ZSH]}/${file}.zsh"
            [[ -f "$file_path" ]] && source "$file_path"

            # Source local overrides.
            file_path="${Juici[DOT_ZSH]}/${file}.local.zsh"
            [[ -f "$file_path" ]] && source "$file_path"
        done
    fi
}

# }}}

# Finalise {{{

# Load local overrides.
[[ -f "${Juici[RC_LOCAL]}" ]] && source "${Juici[RC_LOCAL]}"

# }}}
