setw -g alternate-screen on   # Allow programs to use alternate screen.

setw -g allow-rename on       # Allow programs to change window title.
setw -g automatic-rename off  # Don't manage window titles.

set -g renumber-windows on    # Automatically renumber windows.
set -g base-index 1           # Number windows starting at 1, since it is easier to reach.
setw -g pane-base-index 1     # Number panes starting at 1, since it is easier to reach.

set -g set-titles on          # Set terminal title.
set -g set-titles-string "[#S] #T"

# Window appearance.
setw -g window-style 'bg=default,fg=default'
setw -g window-active-style 'bg=default,fg=default'

# Pane appeareance.
setw -g pane-border-style 'fg=brightblack'
setw -g pane-active-border-style 'fg=blue'

# Selection colours.
setw -g mode-style 'fg=#5c6370,bg=#abb2bf'
