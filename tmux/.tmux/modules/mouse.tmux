# Enable mouse support.
#
# Mouse can be used to select panes, select windows (on the status bar) and
# resize panes.
set -g mouse on

# Start copy mode when scrolling up and exit when scrolling down to bottom.
# The "#{mouse_any_flag}" check just sends scrolls to any program running that
# has mouse support (like vim).
bind -T root -n WheelUpPane \
  if -Ft= "#{mouse_any_flag}" \
    "send-keys -M" \
    " \
      if -Ft= '#{alternate_on}' \
        \"send-keys -t= up\" \
        \" \
          if -Ft= '#{pane_in_mode}' \
            'send-keys -M' \
            'copy-mode -e -t= ; send-keys -M' \
        \" \
    "

# Enable sending scroll-downs to the moused-over-pane.
bind -T root -n WheelDownPane \
  if -Ft= "#{mouse_any_flag}" \
    "send-keys -M" \
    " \
      if -Ft= '#{alternate_on}' \
        \"send-keys -t= down\" \
        \"send-keys -M\" \
    "

# Mouse wheel options must be set seperately for copy-mode than from root.
bind -T copy-mode WheelUpPane send-keys -N 3 -X scroll-up
bind -T copy-mode WheelDownPane send-keys -N 3-X scroll-down
bind -T copy-mode-vi WheelUpPane send-keys -N 3 -X scroll-up
bind -T copy-mode-vi WheelDownPane send-keys -N 3 -X scroll-down
