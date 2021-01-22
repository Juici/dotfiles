"""
A patch to fix ColorDepth not being passed to print_formatted_text.
"""

import prompt_toolkit as pt
import IPython

from IPython import get_ipython
from IPython.terminal.interactiveshell import InteractiveShell, TerminalInteractiveShell

from typing import Optional


def apply_patch():
    ip: Optional[InteractiveShell] = get_ipython()
    if ip is None or not isinstance(ip, TerminalInteractiveShell):
        return

    ip: TerminalInteractiveShell

    # Original function.
    _print_formatted_text = pt.shortcuts.utils.print_formatted_text

    # Hacky wrap of the function to set the `color_depth` argument.
    def print_formatted_text(*args, **kwargs):
        kwargs['color_depth'] = ip.color_depth
        return _print_formatted_text(*args, **kwargs)

    # Replace functions used by IPython with our wrapper function.
    IPython.terminal.prompts.print_formatted_text = print_formatted_text
    IPython.terminal.interactiveshell.print_formatted_text = print_formatted_text


if __name__ == '__main__':
    apply_patch()
