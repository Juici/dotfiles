# Enable 256 colour support.
set -g default-terminal 'tmux-256color'
set -s default-terminal 'tmux-256color'
set -ag terminal-overrides ',xterm-256color:Tc,xterm-kitty:Tc'

# Don't wait for escape sequences after seeing `Ctrl+\`.
set -s escape-time 10

# Enable focus events.
set -g focus-events on

# Enable xterm keys.
setw -g xterm-keys on

# Set history size limit.
set -g history-limit 4096

# Add ':' to the default list (' -_@') of word separators.
set -ag word-separators :
