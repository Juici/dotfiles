import os
import subprocess


def on_resize(boss, window, data):
    pass


def on_focus_change(boss, window, data):
    focused = data['focused']

    # If the window is unfocused hide the dropdown.
    if not focused:
        tdrop_kitty = os.path.expanduser('~/.local/bin/tdrop-kitty')
        subprocess.run([tdrop_kitty, '--hide'])


def on_close(boss, window, data):
    pass
