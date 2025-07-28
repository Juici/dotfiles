#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# Setup [[[

# Freeze TTY settings. 
builtin ttyctl -f

# Access internal hash tables for special shell parameters.
# eg. commands, functions, builtins, etc.
zmodload zsh/parameter

# Load zsh builtins for common file access commands.
zmodload -mF zsh/files b:ln b:mkdir b:mv b:rm b:zf_\*

# Create a hashtable to store global variables without polluting scope.
typeset -gA Juici

Juici[debug]=0

Juici[config_dir]="${${(%):-%x}:h}"
Juici[cache_dir]="${XDG_CACHE_HOME:-"${HOME}/.cache"}/zsh"
Juici[state_dir]="${XDG_STATE_HOME:-"${HOME}/.local/state"}/zsh"

Juici[lib_dir]="${Juici[config_dir]}/lib"
Juici[functions_dir]="${Juici[config_dir]}/functions"
Juici[plugins_dir]="${Juici[config_dir]}/plugins"
Juici[zpmod_dir]="${Juici[config_dir]}/zpmod"

# Declare $ZINIT global hashtable.
typeset -gA ZINIT

ZINIT[HOME_DIR]="${XDG_DATA_HOME:-"${HOME}/.local/share"}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"
ZPFX="${ZINIT[HOME_DIR]}/polaris"

# Create cache and state directories if necessary.
[[ -d "${Juici[cache_dir]}" ]] || builtin mkdir -p "${Juici[cache_dir]}"
[[ -d "${Juici[state_dir]}" ]] || builtin mkdir -p "${Juici[state_dir]}"

# Load Zpmod.
if [[ -f "${Juici[zpmod_dir]}/Src/zi/zpmod.so" ]]; then
    module_path+=( "${Juici[zpmod_dir]}/Src" )
    zmodload zi/zpmod
fi

# Add functions to `fpath`.
fpath+=( "${Juici[functions_dir]}" )

# Load library files.
() {
    local file
    for file in ${Juici[lib_dir]}/*.zsh(.N); do
        builtin source "$file"
    done
}

# ]]]

# Load Zinit and Zpmod [[[

{
    .pp-path() {
        builtin print -- "\e[1;33m${(D)1}\e[0m"
    }

    .maybe-continue() {
        +log-warn 'Errors may occur if loading continues'

        # Prompt the user if they want to exit the shell.
        local yesno prompt="$(+log-operation 'Proceed with loading configs? [y/N] ')"
        builtin read -sk 1 "yesno?${prompt}"
        builtin print

        case "$yesno" in
            ([yY])
                +log-info -1 'Proceeding with loading configs...'
                return 0
                ;;
            (*)
                # Default to no.
                +log-info -1 'Stopped loading configs'
                return 1
                ;;
        esac
    }

    .maybe-build-zpmod() {
        local module_dir=$1 old_pwd=$PWD

        # Zsh version must be at least 5.8.1 for zpmod.
        autoload -Uz is-at-least && is-at-least 5.8.1 || return 1

        # Make must be available.
        [[ -v commands[make] ]] || return 1

        +log-warn 'zpmod has not been built'

        # Prompt the user if they want to build zpmod.
        local yesno prompt="$(+log-operation 'Proceed with building zpmod? [y/N] ')"
        builtin read -sk 1 "yesno?${prompt}"
        builtin print

        case "$yesno" in
            ([yY])
                ;;
            (*)
                # Default to no.
                +log-info -1 'zpmod will not be built'
                return 1
                ;;
        esac

        {
            # Change directory to build zpmod.
            builtin cd "$module_dir" || return 1

            +log-info -1 "Building zpmod at $(.pp-path $module_dir)..."

            if [[ -f "$module_dir/Makefile" ]]; then
                +log-debug 'make clean'
                command make clean
            fi

            +log-debug 'configure'
            "$module_dir/configure" --enable-cflags='-g -Wall -Wextra -O3' --disable-gdbm --without-tcsetpgrp --quiet

            local cores=$(command nproc 2>/dev/null || command sysctl -n hw.ncpu 2>/dev/null || command getconf _NPROCESSORS_ONLN 2>/dev/null || print 1)

            +log-debug 'make'
            if command make --jobs="$cores" && [[ -f "$module_dir/Src/zi/zpmod.so" ]]; then
                command cp -f "$module_dir/Src/zi/zpmod.so"  "$module_dir/Src/zi/zpmod.bundle"
                +log-info 'Successfully built zpmod'
                return 0
            else
                +log-error 'Failed to build zpmod'
                return 1
            fi
        } always {
            # Restore current directory.
            builtin cd "$old_pwd"
        }
    }

    if [[ ! -v commands[git] ]]; then
        +log-error 'Missing git executable'
        .maybe-continue || return
    fi

    # Install Zinit if missing.
    if [[ ! -d "${ZINIT[BIN_DIR]}/.git" ]]; then
        builtin mkdir -p "${ZINIT[BIN_DIR]:h}"
        +log-operation "Installing Zinit plugin manager at $(.pp-path ${ZINIT[BIN_DIR]})..."
        command git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"

        if [[ -d "${ZINIT[BIN_DIR]}/.git" ]]; then
            +log-info "Successfully installed Zinit"
        else
            +log-error "Failed to install Zinit"
            .maybe-continue || return
        fi
    fi

    # Build zpmod if not built.
    if [[ ! -f "${Juici[zpmod_dir]}/Src/zi/zpmod.so" ]]; then
        .maybe-build-zpmod "${Juici[zpmod_dir]}"

        # Load Zpmod.
        if [[ -f "${Juici[zpmod_dir]}/Src/zi/zpmod.so" ]]; then
            module_path+=( "${Juici[zpmod_dir]}/Src" )
            zmodload zi/zpmod
        fi
    fi
} always {
    unfunction .pp-path
    unfunction .maybe-continue
    unfunction .maybe-build-zpmod
}

# Load Zinit.
builtin source "${ZINIT[BIN_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit annexes.
zinit light-mode for \
    zdharma-continuum/zinit-annex-binary-symlink

# ]]]

# Load configs [[[

() {
    local config
    for config in ${Juici[config_dir]}/conf.d/*.zsh(.Non); do
        builtin source "$config"
    done
}

# ]]]
