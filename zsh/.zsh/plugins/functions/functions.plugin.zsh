# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh tw=120 sw=2 sts=2 et foldmarker=[[[,]]]

# Standardized $0 Handling.
# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Functions directory.
# https://wiki.zshell.dev/community/zsh_plugin_standard#functions-directory
if [[ $PMSPEC != *f* ]] {
  fpath+=( "${0:h}/functions" )
}

# Binaries directory.
# https://wiki.zshell.dev/community/zsh_plugin_standard#binaries-directory
if [[ $PMSPEC != *b* ]] {
  path+=( "${0:h}/bin" )
}

# Standard hash for plugins, to not pollute the namespace.
# https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
typeset -gA Plugins
Plugins[FUNCTIONS_DIR]="${0:h}"

autoload -Uz \
  bar \
  parseoffset \
  tw
