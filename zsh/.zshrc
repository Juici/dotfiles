# Setup {{{

[[ -o interactive ]] || return

# Create a hashtable to store global variables without polluting scope.
typeset -gA Juici

Juici[rc]="$HOME/.zshrc"
Juici[rc_local]="$HOME/.zshrc.local"
Juici[dot_zsh]="$HOME/.zsh"

# Load zsh builtins for common file access commands.
# Don't override chmod since, the syntax of the zsh builtin differs.
zmodload -F zsh/files -b:chmod

# }}}

# Load Zinit {{{

{
    .maybe_continue() {
        # Prompt the user if they want to exit the shell.
        # Gives the user time to read the error and the option continue.
        local yesno prompt='%F{yellow}%Bwarning%b%f: errors may occur if loading continues, do you wish to continue? [y/N] '
        read -sk 1 "yesno?${(%)prompt}"
        # Add a newline.
        print

        case $yesno in
            [yY])
                print -P -- '%F{yellow}%Bwarning%b%f: continuing loading configs'
                return 0
                ;;
            *)
                # Default to no.
                print -P -- '%F{blue}%Binfo%b%f: stopping loading configs'
                return 1
                ;;
        esac
    }

    .pp_path() {
        local path
        print -D -v path "$1"
        print -Pr -- "%F{magenta}%B${path}%b%f"
    }

    if (( ! ${+commands[git]} )); then
        print -Pu2 -- '%F{red}%Berror%b%f: no %F{green}%Bgit%b%f available, cannot proceed'
        .maybe_continue || return
    fi

    # Declare $ZINIT global.
    typeset -gA ZINIT

    ZINIT[HOME_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
    ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"

    # Install Zinit if missing.
    if [[ ! -d "${ZINIT[BIN_DIR]}/.git" ]]; then
        mkdir -p "${ZINIT[BIN_DIR]:h}"
        print -Pr -- "installing %F{cyan}%B(zdharma-continuum/zinit)%b%f %F{yellow}%Bplugin manager%b%f at $(.pp_path ${ZINIT[BIN_DIR]})"
        git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"

        if [[ -d "${ZINIT[BIN_DIR]}/.git" ]]; then
            print -P -- "%F{green}successfully installed at $(.pp_path ${ZINIT[BIN_DIR]})"
        else
            print -Pr -- "%F{red}%Berror%b%f: something went wrong, failed to install ZI at $(.pp_path ${ZINIT[BIN_DIR]})"
            .maybe_continue || return
        fi
    fi
} always {
    unfunction .maybe_continue
}

# Load ZI zpmod.
if [[ -f "${ZINIT[HOME_DIR]}/module/Src/zi/zpmod.so" ]]; then
    module_path+=( "${ZINIT[HOME_DIR]}/module/Src" )
    zmodload zi/zpmod
fi

# Load Zinit.
source "${ZINIT[BIN_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zi light-mode for \
    z-shell/z-a-meta-plugins \
    zdharma-continuum/zinit-annex-bin-gem-node

# }}}

# Initialise {{{

setopt extended_glob

# Async workers.
#zinit light mafredri/zsh-async

# }}}

# Load Modules {{{

# Anonymous function to avoid leaking variables.
() {
    local dot_zsh=${Juici[dot_zsh]}

    if [[ -d $dot_zsh ]]; then
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
            file_path="$dot_zsh/$file.zsh"
            [[ -f $file_path ]] && source $file_path

            # Source local overrides.
            file_path="$dot_zsh/$file.local.zsh"
            [[ -f $file_path ]] && source $file_path
        done
    fi
}

# }}}

# Finalise {{{

# Load local overrides.
[[ -f ${Juici[rc_local]} ]] && source ${Juici[rc_local]}

# }}}
