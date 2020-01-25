# Sourced by both `.zprofile` and `.zshrc`.
# Must be agnostic to source environment.

# Paths.
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# Get a copy of the system PATH.
local -aU system_path
system_path=($path)

# Set GOPATH.
typeset -gUT GOPATH gopath
gopath=(
    $HOME/go
)

# Configure PATH.
path=(
    $HOME/bin
    $HOME/.zsh/bin
    $HOME/.cargo/bin
    ${^gopath}/bin
    $HOME/.local/bin
    $HOME/.node_modules/bin
    /bin
    /usr/bin
    /usr/local/bin
    /usr/local/sbin
    $system_path
)

infopath=(
    /usr/local/share/info
    /usr/share/info
    $infopath
)
