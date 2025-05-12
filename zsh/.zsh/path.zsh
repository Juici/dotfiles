# Sourced by both `.zprofile` and `.zshrc`.
# Must be agnostic to source environment.

# Paths.
declare -gU cdpath fpath mailpath manpath path

declare -gUT INFOPATH infopath
declare -gUT GOPATH gopath

# Set GOPATH.
gopath=(
    $HOME/go
)

# Paths to look for executable files.
path=(
    $HOME/.local/bin
    $HOME/.zsh/bin
    $HOME/.cargo/bin
    ${^gopath}/bin
    /usr/local/{,s}bin
    /usr/{,s}bin
    /{,s}bin
    $path
)

# Paths to look for man pages.
manpath=(
    $HOME/.local/share/man
    /usr/local/share/man
    /usr/share/man
    $manpath
)

# Paths to look for info pages.
infopath=(
    $HOME/.local/share/info
    /usr/local/share/info
    /usr/share/info
    $infopath
)
