"""
Custom ipython configuration.
"""

import importlib.util
import os
import sys
from typing import TYPE_CHECKING

from IPython.utils.PyColorize import Theme, theme_table

if TYPE_CHECKING:
    from IPython.terminal.interactiveshell import TerminalInteractiveShell
    from IPython.terminal.ipapp import TerminalIPythonApp

    class Config:
        TerminalInteractiveShell: TerminalInteractiveShell
        TerminalIPythonApp: TerminalIPythonApp

    def get_config() -> Config: ...


config_file = os.path.abspath(__file__)
config_dir = os.path.dirname(config_file)


def load_theme(theme: str) -> Theme:
    if theme.endswith(".py"):
        theme = theme[:-3]

    try:
        return sys.modules[theme].theme
    except KeyError:
        pass

    file_path = os.path.join(config_dir, "themes", f"{theme}.py")
    module_name = f"themes.{theme}"

    spec = importlib.util.spec_from_file_location(module_name, file_path)
    if spec is None:
        raise ImportError("Failed to get module spec", name=module_name, path=file_path)
    if spec.loader is None:
        raise ImportError("Missing loader in module spec", name=module_name, path=file_path)

    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)

    return module.theme


c = get_config()

c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.term_title = False
c.TerminalInteractiveShell.editing_mode = "emacs"

theme = load_theme("onedark")
theme_table[theme.name] = theme

c.TerminalInteractiveShell.colors = theme.name

# c.TerminalInteractiveShell.highlighting_style = style
# if hasattr(style, "overrides"):
#    c.TerminalInteractiveShell.highlighting_style_overrides = style.overrides

c.TerminalIPythonApp.display_banner = False
