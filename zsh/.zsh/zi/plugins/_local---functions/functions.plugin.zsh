# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# According to the Zsh Plugin Standard:
# https://github.com/z-shell/zi/wiki/Zsh-Plugin-Standard

emulate -L zsh
setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h} to get plugin's directory

if [[ $PMSPEC != *f* ]] {
    fpath+=( "${0:h}/functions" )
}

autoload -Uz bar tw parseoffset jump diffp

compdef _diff diffp

alias j='jump'

@zsh-plugin-run-on-unload 'unalias j'

# Use alternate vim marks [[[ and ]]] as the original ones can
# confuse nested substitutions, e.g.: ${${${VAR}}}

# vim:ft=zsh:tw=120:sw=4:sts=4:et:foldmarker=[[[,]]]
