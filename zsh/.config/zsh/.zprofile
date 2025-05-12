#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

# If not an interactive shell, then source base level configs. These are configs
# from "$ZDOTDIR/conf.d", that start with 0, eg. "00-foo.zsh", "01-bar.zsh".
[[ -o interactive ]] || () {
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

    local file

    # Add functions to `fpath`.
    fpath+=( "${Juici[functions_dir]}" )

    # Load library files.
    for file in ${config_dir}/lib/*.zsh(.N); do
        builtin source "$file"
    done

    # Load base level configs.
    for conf in ${config_dir}/conf.d/0[[:digit:]]#-*.zsh(.Non); do
        builtin source "$file"
    done
}
