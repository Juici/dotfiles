"""
Custom ipython configuration.
"""

# import os
# import sys

# import IPython

c = get_config()

c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.term_title = False
c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.highlighting_style = 'onedark'

c.TerminalIPythonApp.display_banner = False
