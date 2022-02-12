# Global Vars {{{

# Create a hashtable to store global variables without polluting scope.
declare -gA Juici

Juici[RC]="$HOME/.zshrc"
Juici[RC_LOCAL]="$HOME/.zshrc.local"
Juici[DOT_ZSH]="$HOME/.zsh"
Juici[PLUGINS]="${Juici[DOT_ZSH]}/plugins"
Juici[CONFIGS]="${Juici[DOT_ZSH]}/configs"

# }}}

# Load ZI {{{

maybe_exit() {
    print -P -- '%F{yellow}%Bwarning%b%f: errors may occur if loading continues'

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

if (( ! ${+commands[git]} )); then
    print -P -- '%F{red}%Berror%b%f: no %F{green}%Bgit%b%f available, cannot proceed'
    maybe_exit
fi

# Declare $ZI global.
declare -gA ZI

ZI[HOME_DIR]="$HOME/.zi"
ZI[BIN_DIR]="${ZI[HOME_DIR]}/bin"

# Install ZI if missing.
if [[ ! -d "${ZI[BIN_DIR]}/.git" ]]; then
    # Get the download-progress bar tool
    if (( ${+commands[curl]} )); then
        command mkdir -p /tmp/zi
        cd /tmp/zi || return
        command curl -fsSLO https://raw.githubusercontent.com/z-shell/zi/main/lib/zsh/git-process-output.zsh &&
            command chmod a+x /tmp/zi/git-process-output.zsh
    elif (( ${+commands[wget]} )); then
        command mkdir -p /tmp/zi
        cd /tmp/zi || return
        command wget -q https://raw.githubusercontent.com/z-shell/zi/main/lib/zsh/git-process-output.zsh &&
            command chmod a+x /tmp/zi/git-process-output.zsh
    fi

    print -P -- "installing %F{cyan}%B(z-shell/zi)%b%f %F{yellow}%Bplugin manager%b%f at %F{magenta}%B${ZI[BIN_DIR]}%b%f"

    { command git clone --progress https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}" 2>&1 |
        { /tmp/zi/git-process-output.zsh || cat; }; } 2>/dev/null

    if [[ -d "${ZI[BIN_DIR]}" ]]; then
        print -P -- "successfully installed at %F{green}%B%b%f"
    else
        print -P -- "%F{red}%Berror%b%f: something went wrong, failed to install ZI at %F{magenta}%B${ZI[BIN_DIR]}%b%f"
        maybe_exit
    fi
fi

unfunction maybe_exit

# Load ZI.
source "${ZI[BIN_DIR]}/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi light-mode for \
    z-shell/z-a-meta-plugins \
    @annexes

zicompinit

# }}}

# Initialise {{{

setopt extended_glob

# Async workers.
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
