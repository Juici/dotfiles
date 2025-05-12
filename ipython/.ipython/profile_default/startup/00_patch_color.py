"""
A patch to fix ColorDepth not being passed to print_formatted_text.
"""

from typing import Any

import IPython.terminal.interactiveshell
import IPython.terminal.prompts
import prompt_toolkit as pt
from IPython.core.getipython import get_ipython
from IPython.terminal.interactiveshell import TerminalInteractiveShell


def apply_patch():
    ip = get_ipython()
    if not isinstance(ip, TerminalInteractiveShell):
        return

    # Original function.
    _print_formatted_text = pt.shortcuts.utils.print_formatted_text

    # Hacky wrap of the function to set the `color_depth` argument.
    def print_formatted_text(*args: Any, **kwargs: Any):
        kwargs["color_depth"] = ip.color_depth
        return _print_formatted_text(*args, **kwargs)

    # Replace functions used by IPython with our wrapper function.
    IPython.terminal.prompts.print_formatted_text = print_formatted_text  # type: ignore
    IPython.terminal.interactiveshell.print_formatted_text = print_formatted_text  # type: ignore


if __name__ == "__main__":
    apply_patch()
