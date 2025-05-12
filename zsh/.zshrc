# Setup {{{

[[ -o interactive ]] || return

# Create a hashtable to store global variables without polluting scope.
typeset -gA Juici

Juici[debug]=0
Juici[rc]="$HOME/.zshrc"
Juici[rc_local]="$HOME/.zshrc.local"
Juici[dot_zsh]="$HOME/.zsh"
Juici[zpmod]="${Juici[dot_zsh]}/zpmod"
Juici[plugins]="${Juici[dot_zsh]}/plugins"

# Declare $ZINIT global hashtable.
typeset -gA ZINIT

ZINIT[HOME_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"

# Load zsh builtins for common file access commands.
# Don't override chmod since, the syntax of the zsh builtin differs.
zmodload -F zsh/files -b:chmod

# }}}

# Utils {{{

+log-debug() {
    (( Juici[debug] )) || return

    builtin print -- "\e[1;33m[DEBUG\e[2m:${functrace[1]}\e[0;1;33m]\e[0m ${1}\e[0m"
}

+log-operation() {
    builtin print -- "\e[1;34m::\e[39m ${1}\e[0m"
}

+log-info() {
    local depth=0 msg="$1" color prefix

    if (( $# > 1 )); then
        (( depth = $1 ))
        msg="$2"
    fi

    if (( depth > 0 )); then
        color='1;34'
        prefix="${(pl:${depth}:)} ->"
    else
        color='1;32'
        prefix='==>'
    fi

    builtin print -- "\e[${color}m${prefix}\e[0m ${msg}\e[0m"
}

+log-warn() {
    local depth=0 msg="$1" color='1;33' prefix

    if (( $# > 1 )); then
        (( depth = $1 ))
        msg="$2"
    fi

    if (( depth > 0 )); then
        prefix="${(pl:${depth}:)} -> WARNING:"
    else
        prefix='==> WARNING:'
    fi

    builtin print -- "\e[${color}m${prefix}\e[0m ${msg}\e[0m"
}

+log-error() {
    local depth=0 msg="$1" color='1;31' prefix

    if (( $# > 1 )); then
        (( depth = $1 ))
        msg="$2"
    fi

    if (( depth > 0 )); then
        prefix="${(pl:${depth}:)} -> ERROR:"
    else
        prefix='==> ERROR:'
    fi

    builtin print -- "\e[${color}m${prefix}\e[0m ${msg}\e[0m"
}

# }}}

# Load Zinit {{{

{
    .maybe_continue() {
        +log-warn 'Errors may occur if loading continues'

        # Prompt the user if they want to exit the shell.
        local yesno prompt="$(+log-operation 'Proceed with loading configs? [y/N] ')"
        read -sk 1 "yesno?${prompt}"
        print

        case "$yesno" in
            [yY])
                +log-info 1 'Proceeding with loading configs...'
                return 0
                ;;
            *)
                # Default to no.
                +log-info 1 'Stopped loading configs'
                return 1
                ;;
        esac
    }

    .pp_path() {
        print -- "\e[1;33m${(D)path}\e[0m"
    }

    .maybe_build_zpmod() {
        local module_dir=$1 old_pwd=$PWD

        # Verify zsh version is at least 5.8.1.
        autoload -Uz is-at-least
        is-at-least 5.8.1 || return 1

        # Make must be available.
        # (( ${+commands[make] } )) || return 1

        +log-warn 'zpmod has not been built'

        # Prompt the user if they want to build zpmod.
        local yesno prompt="$(+log-operation 'Proceed with building zpmod? [y/N] ')"
        read -sk 1 "yesno?${prompt}"
        print

        case "$yesno" in
            [yY])
                ;;
            *)
                # Default to no.
                +log-info 1 'zpmod will not be built'
                return 1
                ;;
        esac

        {
            # Change directory to build zpmod.
            cd "$module_dir" || return 1

            +log-info 1 "Building zpmod at $(.pp_path $module_dir)..."

            if [[ -f "$module_dir/Makefile" ]]; then
                +log-debug 'make clean'
                make clean
            fi

            "$module_dir/configure" --enable-cflags='-g -Wall -Wextra -O3' --disable-gdbm --without-tcsetpgrp --quiet
            +log-debug 'make'

            local cores=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
            if command make --jobs="$cores" && [[ -f "$module_dir/Src/zi/zpmod.so" ]]; then
                cp -f "$module_dir/Src/zi/zpmod.so"  "$module_dir/Src/zi/zpmod.bundle"
                +log-info 'Successfully built zpmod'
                return 0
            else
                +log-error 'Failed to build zpmod'
                return 1
            fi
        } always {
            # Restore current directory.
            cd "$old_pwd"
        }
    }

    if (( ! ${+commands[git]} )); then
        +log-error 'Missing git executable'
        .maybe_continue || return
    fi

    # Install Zinit if missing.
    if [[ ! -d "${ZINIT[BIN_DIR]}/.git" ]]; then
        mkdir -p "${ZINIT[BIN_DIR]:h}"
        +log-operation "Installing Zinit plugin manager at $(.pp_path ${ZINIT[BIN_DIR]})..."
        git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"

        if [[ -d "${ZINIT[BIN_DIR]}/.git" ]]; then
            +log-info "Successfully installed Zinit"
        else
            +log-error "Failed to install Zinit"
            .maybe_continue || return
        fi
    fi

    # Build zpmod if not built.
    if [[ ! -f "${Juici[zpmod]}/Src/zi/zpmod.so" ]]; then
        .maybe_build_zpmod "${Juici[zpmod]}"
    fi
} always {
    unfunction .maybe_continue
    unfunction .pp_path
    unfunction .maybe_build_zpmod
}

# Load zpmod.
if [[ -f "${Juici[zpmod]}/Src/zi/zpmod.so" ]]; then
    module_path+=( "${Juici[zpmod]}/Src" )
    zmodload zi/zpmod
fi

# Load Zinit.
source "${ZINIT[BIN_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit annexes.
zinit light-mode for \
    zdharma-continuum/zinit-annex-binary-symlink

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

    if [[ -d "$dot_zsh" ]]; then
        local -aU files

        # List of possible files to load.
        # Arranged in order to prevent conflicts.
        files=(
            'path'
            'history'
            'options'
            'colors'
            'completions'
            'prompt'
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
        for file in "${files[@]}"; do
            # Source file.
            file_path="${dot_zsh}/${file}.zsh"
            [[ -f "$file_path" ]] && source "$file_path"

            # Source local overrides.
            file_path="${dot_zsh}/${file}.local.zsh"
            [[ -f "$file_path" ]] && source "$file_path"
        done
    fi
}

# }}}

# Finalise {{{

# Load local overrides.
[[ -f ${Juici[rc_local]} ]] && source ${Juici[rc_local]}

# }}}
