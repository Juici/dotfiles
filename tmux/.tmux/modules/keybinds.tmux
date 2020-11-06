# Set prefix to `Ctrl+\`.
unbind 'C-b'
set -g prefix 'C-\'

# Reload config from file.
unbind 'r'
bind 'r' source-file ~/.tmux.conf \; display-message 'Config reloaded'

# Open new windows and split panes with the path of the current pane.
unbind 'c'
bind 'c' new-window -c '#{pane_current_path}'
unbind '%' # Use `£` instead of `%`, since it's next to `"`.
bind '£' split-window -h -c '#{pane_current_path}'
unbind '"'
bind '"' split-window -v -c '#{pane_current_path}'

# Intuitive window-splitting keys.
bind '|' split-window -h -c '#{pane_current_path}'
bind '\' split-window -h -c '#{pane_current_path}'
bind '-' split-window -v -c '#{pane_current_path}'

# Fast toggle between current and last-used window (normally `prefix-l`).
bind 'C-\' last-window

# Analagous with naked C-l which clears the terminal.
bind 'C-l' clear-history

# Vim-like key bindings for pane navigation (default uses cursor keys).
unbind 'h'
bind 'h' select-pane -L
unbind 'j'
bind 'j' select-pane -D
unbind 'k'
bind 'k' select-pane -U
unbind 'l' # Normally used for last-window.
bind 'l' select-pane -R

# Resizing (mouse also works), combine with Shift for fine-grained control.
unbind 'Left'
bind -r 'Left' resize-pane -L 5
unbind 'Right'
bind -r 'Right' resize-pane -R 5
unbind 'Down'
bind -r 'Down' resize-pane -D 5
unbind 'Up'
bind -r 'Up' resize-pane -U 5
