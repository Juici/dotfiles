#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# Freeze TTY settings.
builtin ttyctl -f

# Access internal hash tables for special shell parameters.
# eg. commands, functions, builtins, etc.
builtin zmodload zsh/parameter

# Load zsh builtins for common file access commands.
builtin zmodload -mF zsh/files b:ln b:mkdir b:mv b:rm b:zf_\*

typeset -gA Juici ZINIT

Juici[debug]=0

Juici[config_dir]="${${(%):-%x}:h}"
Juici[cache_dir]="${XDG_CACHE_HOME:-"${HOME}/.cache"}/zsh"
Juici[state_dir]="${XDG_STATE_HOME:-"${HOME}/.local/state"}/zsh"

Juici[lib_dir]="${Juici[config_dir]}/lib"
Juici[functions_dir]="${Juici[config_dir]}/functions"
Juici[plugins_dir]="${Juici[config_dir]}/plugins"

ZINIT[HOME_DIR]="${XDG_DATA_HOME:-"${HOME}/.local/share"}/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"
ZINIT[MODULE_DIR]="${ZINIT[HOME_DIR]}/module"

# Create cache and state directories if necessary.
[[ -d "${Juici[cache_dir]}" ]] || builtin mkdir -p "${Juici[cache_dir]}"
[[ -d "${Juici[state_dir]}" ]] || builtin mkdir -p "${Juici[state_dir]}"

# Load Zpmod.
if [[ -f "${ZINIT[MODULE_DIR]}/Src/zdharma_continuum/zinit.so" ]]; then
    module_path+=( "${ZINIT[MODULE_DIR]}/Src" )
    builtin zmodload zdharma_continuum/zinit
fi

# Add functions to `fpath`.
fpath+=( "${Juici[functions_dir]}" )

# Load library files before zinit.
() {
    local file
    for file in ${Juici[lib_dir]}/*.zsh(.N); do
        builtin source "$file"
    done
}

# Install Zinit. [[[

# Install Zinit if missing.
[[ ! -d "${ZINIT[BIN_DIR]}/.git" ]] && {
    .pp-path() {
        builtin print -- "\e[1;33m${(D)1}\e[0m"
    }

    .stop-loading() {
        +log-warn 'Cannot continue loading configs'
    }

    if [[ ! -v commands[git] ]]; then
        +log-error 'Missing git executable'
        .stop-loading
        return
    fi

    builtin mkdir -p "${ZINIT[BIN_DIR]:h}"
    +log-operation "Installing Zinit plugin manager at $(.pp-path ${ZINIT[BIN_DIR]})..."
    command git clone https://github.com/Juici/zinit.git "${ZINIT[BIN_DIR]}"

    if [[ ! -d "${ZINIT[BIN_DIR]}/.git" ]]; then
        +log-error "Failed to install Zinit"
        .stop-loading
        return
    fi

    +log-info "Successfully installed Zinit"
} always {
    unfunction .pp-path
    unfunction .stop-loading
}

# ]]]

# Load Zinit.
builtin source "${ZINIT[BIN_DIR]}/zinit.zsh"
builtin autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit annexes.
zinit light-mode for \
    zdharma-continuum/zinit-annex-binary-symlink

# Load configs.
() {
    local config
    for config in ${Juici[config_dir]}/conf.d/*.zsh(.Non); do
        builtin source "$config"
    done
}
