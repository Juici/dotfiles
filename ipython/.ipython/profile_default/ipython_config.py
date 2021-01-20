"""
Custom ipython configuration.
"""

from traitlets.config.loader import Config

import os
import sys
import importlib

# import IPython

config_file = os.path.abspath(__file__)
config_dir = os.path.dirname(config_file)


def import_style(style: str):
    if style.endswith('.py'):
        style = style[:-3]

    try:
        return sys.modules[style]
    except KeyError:
        pass

    file_path = os.path.join(config_dir, 'styles', f'{style}.py')
    module_name = f'styles.{style}'

    spec = importlib.util.spec_from_file_location(module_name, file_path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)

    return module.Style


# pylint: disable=E0602
c: Config = get_config()

c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.term_title = False
c.TerminalInteractiveShell.editing_mode = 'emacs'
c.TerminalInteractiveShell.highlighting_style = import_style('onedark')

c.TerminalIPythonApp.display_banner = False
