# Setup {{{

# Create a hashtable to store global variables without polluting scope.
typeset -gA Juici

Juici[rc]="$HOME/.zshrc"
Juici[rc_local]="$HOME/.zshrc.local"
Juici[dot_zsh]="$HOME/.zsh"

# Load zsh builtins for common file access commands.
zmodload zsh/files

# }}}

# Load ZI {{{

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

    if (( ! ${+commands[git]} )); then
        print -Pu2 -- '%F{red}%Berror%b%f: no %F{green}%Bgit%b%f available, cannot proceed'
        .maybe_continue || return
    fi

    # Declare $ZI global.
    typeset -gA ZI

    ZI[HOME_DIR]="${Juici[dot_zsh]}/zi"
    ZI[BIN_DIR]="${ZI[HOME_DIR]}/bin"

    # Load ZI zpmod.
    if [[ -d "${ZI[HOME_DIR]}/zmodules/zpmod" ]]; then
        module_path+=( "${ZI[HOME_DIR]}/zmodules/zpmod/Src" )
        zmodload zi/zpmod
    fi

    # Install ZI if missing.
    if [[ ! -d "${ZI[BIN_DIR]}/.git" ]]; then
        print -Pr -- "installing %F{cyan}%B(z-shell/zi)%b%f %F{yellow}%Bplugin manager%b%f at %F{magenta}%B${ZI[BIN_DIR]}%b%f"
        git clone --progress https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}"

        if [[ -d "${ZI[BIN_DIR]}" ]]; then
            print -P -- "successfully installed at %F{green}%B%b%f"
        else
            print -Pr -- "%F{red}%Berror%b%f: something went wrong, failed to install ZI at %F{magenta}%B${ZI[BIN_DIR]}%b%f"
            .maybe_continue || return
        fi
    fi
} always {
    unfunction .maybe_continue
}

# Load ZI.
source "${ZI[BIN_DIR]}/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi light-mode for \
    z-shell/z-a-meta-plugins \
    z-shell/z-a-bin-gem-node \
    @annexes

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
