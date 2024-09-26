# Setup {{{

[[ -o interactive ]] || return

# Create a hashtable to store global variables without polluting scope.
typeset -gA Juici

Juici[debug]=0
Juici[rc]="$HOME/.zshrc"
Juici[rc_local]="$HOME/.zshrc.local"
Juici[dot_zsh]="$HOME/.zsh"
Juici[zpmod]="${Juici[dot_zsh]}/zpmod"

# Load zsh builtins for common file access commands.
# Don't override chmod since, the syntax of the zsh builtin differs.
zmodload -F zsh/files -b:chmod

# }}}

# Utils {{{

.log::debug() {
    (( Juici[debug] )) && print -Pr -- "%B%F{8}debug%f:%b $1%f"
}
.log::info() {
    print -Pr -- "%B%F{blue}info%f:%b $1%f"
}
.log::warn() {
    print -Pr -- "%B%F{yellow}warning%f:%b $1%f"
}
.log::error() {
    print -Pru2 -- "%B%F{red}error%f:%b $1%f"
}

# }}}

# Load Zinit {{{

{
    .maybe_continue() {
        # Prompt the user if they want to exit the shell.
        # Gives the user time to read the error and the option continue.
        local yesno prompt='%B%F{yellow}warning%f:%b errors may occur if loading continues, do you wish to continue? [y/N] '
        read -sk 1 "yesno?${(%)prompt}"
        # Add a newline.
        print

        case $yesno in
            [yY])
                .log::warning 'continuing loading configs'
                return 0
                ;;
            *)
                # Default to no.
                .log::info 'stopping loading configs'
                return 1
                ;;
        esac
    }

    .pp_path() {
        local path=$1
        print -Pr -- "%B%F{magenta}${(D)path}%f%b"
    }

    .maybe_build_zpmod() {
        local module_dir=$1 old_pwd=$PWD

        # Verify zsh version is at least 5.8.1.
        autoload -Uz is-at-least
        is-at-least 5.8.1 || return 1

        # Make must be available.
        # (( ${+commands[make] } )) || return 1

        # Prompt the user if they want to build zpmod.
        local yesno prompt='%B%F{blue}info%f:%b zpmod has not been built, do you wish to build it now? [y/N] '
        read -sk 1 "yesno?${(%)prompt}"
        # Add a newline.
        print

        case $yesno in
            [yY])
                ;;
            *)
                # Default to no.
                .log::info 'zpmod will not be built'
                return 1
                ;;
        esac

        {
            # Change directory to build zpmod.
            cd "$module_dir" || return 1

            .log::info "building zpmod at $(.pp_path $module_dir)"

            if [[ -f "$module_dir/Makefile" ]]; then
                .log::debug 'runnning make clean'
                make clean
            fi

            "$module_dir/configure" --enable-cflags='-g -Wall -Wextra -O3' --disable-gdbm --without-tcsetpgrp --quiet
            .log::debug 'runnning make'

            local cores=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
            if command make --jobs="$cores" && [[ -f "$module_dir/Src/zi/zpmod.so" ]]; then
                cp -f "$module_dir/Src/zi/zpmod.so"  "$module_dir/Src/zi/zpmod.bundle"
                .log::info '%F{green}zpmod has been built correctly'
                return 0
            else
                .log::error 'zpmod failed to build correctly'
                return 1
            fi
        } always {
            # Restore current directory.
            cd "$old_pwd"
        }
    }

    if (( ! ${+commands[git]} )); then
        .log::error 'no %B%F{green}git%f%b available, cannot proceed'
        .maybe_continue || return
    fi

    # Declare $ZINIT global.
    typeset -gA ZINIT

    ZINIT[HOME_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
    ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"

    # Install Zinit if missing.
    if [[ ! -d "${ZINIT[BIN_DIR]}/.git" ]]; then
        mkdir -p "${ZINIT[BIN_DIR]:h}"
        .log::info "installing %B%F{cyan}(zdharma-continuum/zinit)%f%b %B%F{yellow}plugin manager%f%b at $(.pp_path ${ZINIT[BIN_DIR]})"
        git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"

        if [[ -d "${ZINIT[BIN_DIR]}/.git" ]]; then
            .log::info "%F{green}successfully installed at $(.pp_path ${ZINIT[BIN_DIR]})"
        else
            .log::error "something went wrong, failed to install Zinit at $(.pp_path ${ZINIT[BIN_DIR]})"
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

zinit light-mode for \
    zdharma-continuum/zinit-annex-meta-plugins \
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
