# Enable status bar and update every 5 seconds.
set -g status on
set -g status-interval 5
# Status bar foreground and background colours.
set -g status-style 'bg=#21252b,fg=white'

# Status left.
set -g status-left '#[bg=#{?client_prefix,magenta,green},fg=black] #S #[bg=default,fg=default] '
set -g status-left-length 20

# Status right.
set -g status-right "#[bg=colour8,fg=white] $USER@#h #[bg=#{?client_prefix,magenta,green},fg=black] %H:%M | %d/%m/%Y "
set -g status-right-length 50

# Windows on status bar.
setw -g window-status-separator ' '
setw -g window-status-format '#[bg=brightblack,fg=blue] #I#{?window_flags,#{window_flags},} #[fg=white]#W '
setw -g window-status-current-format '#[bg=white,fg=brightred] #I#{?window_flags,#{window_flags},} #[fg=black]#W '

# Command and message style.
set -g message-style 'bg=#21252b,fg=white'
set -g message-command-style 'bg=#21252b,fg=magenta'
