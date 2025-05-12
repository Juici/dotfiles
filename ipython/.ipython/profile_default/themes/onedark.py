"""
OneDark pygments style.
"""

from IPython.utils.PyColorize import Theme
from pygments.token import Token

__all__ = ["theme"]

red = "#e06c75"
dark_red = "#be5046"
green = "#98c379"
yellow = "#e5c07b"
dark_yellow = "#d19a66"
blue = "#61afef"
purple = "#c678dd"
cyan = "#56b6c2"
white = "#abb2bf"
black = "#282c34"

visual_black = "none"
comment_grey = "#5c6370"
gutter_fg_grey = "#4b5263"
cursor_grey = "#2c323c"
visual_grey = "#3e4452"
menu_grey = "#3e4452"
special_grey = "#3b4048"

prompt_green = "#6fa449"

theme = Theme(
    "onedark",
    None,
    {
        # Basic.
        Token.Text: white,
        Token.Whitespace: special_grey,
        Token.Escape: "",
        Token.Error: red,
        Token.Other: "",
        # Keywords.
        Token.Keyword: purple,
        Token.Keyword.Constant: yellow,
        Token.Keyword.Declaration: red,
        Token.Keyword.Namespace: red,
        Token.Keyword.Pseudo: "",
        Token.Keyword.Reserved: "",
        Token.Keyword.Type: red,
        # Identifiers.
        Token.Name: white,
        Token.Name.Attribute: yellow,
        Token.Name.Builtin: blue,
        Token.Name.Builtin.Pseudo: "",
        Token.Name.Class: blue,
        Token.Name.Constant: cyan,
        Token.Name.Decorator: "",
        Token.Name.Entity: yellow,
        Token.Name.Exception: red,
        Token.Name.Function: blue,
        Token.Name.Function.Magic: "",
        Token.Name.Property: "",
        Token.Name.Label: "",
        Token.Name.Namespace: blue,
        Token.Name.Other: yellow,
        Token.Name.Tag: purple,
        Token.Name.Variable: "",
        Token.Name.Variable.Class: "",
        Token.Name.Variable.Global: "",
        Token.Name.Variable.Instance: "",
        Token.Name.Variable.Magic: "",
        # Literals.
        Token.Literal: dark_yellow,
        Token.Literal.Date: "",
        # Strings.
        Token.String: green,
        Token.String.Affix: "",
        Token.String.Backtick: "",
        Token.String.Char: "",
        Token.String.Delimiter: "",
        Token.String.Doc: "",
        Token.String.Double: "",
        Token.String.Escape: yellow,
        Token.String.Heredoc: "",
        Token.String.Interpol: blue,
        Token.String.Other: "",
        Token.String.Regex: "",
        Token.String.Single: "",
        Token.String.Symbol: "",
        # Numbers.
        Token.Number: dark_yellow,
        Token.Number.Bin: "",
        Token.Number.Float: "",
        Token.Number.Hex: "",
        Token.Number.Integer: "",
        Token.Number.Integer.Long: "",
        Token.Number.Oct: "",
        # Operators.
        Token.Operator: purple,
        Token.Operator.Word: "",
        # Punctuation.
        Token.Punctuation: white,
        # Comments.
        Token.Comment: f"italic {comment_grey}",
        Token.Comment.Hashbang: f"noitalic {yellow}",
        Token.Comment.Multiline: "",
        Token.Comment.Preproc: "",
        Token.Comment.PreprocFile: "",
        Token.Comment.Single: "",
        Token.Comment.Special: f"noitalic {comment_grey}",
        # General.
        Token.Generic: "",
        Token.Generic.Deleted: red,
        Token.Generic.Emph: "italic",
        Token.Generic.Error: red,
        Token.Generic.Heading: green,
        Token.Generic.Inserted: "",
        Token.Generic.Output: "",
        Token.Generic.Prompt: "",
        Token.Generic.Strong: "bold",
        Token.Generic.Subheading: green,
        Token.Generic.Traceback: "",
        # Prompt.
        Token.Prompt: prompt_green,
        Token.PromptNum: f"bold {green}",
        Token.OutPrompt: dark_red,
        Token.OutPromptNum: f"bold {red}",
    },
)

# TODO: Custom Theme class to handle adding more to pygments style.

# class OneDarkStyle(Style):
#     """
#     OneDark colour scheme for pygments.
#     """

#     background_color = None

#     highlight_color = f"bg:{visual_grey} {visual_black}"

#     line_number_color = gutter_fg_grey
#     line_number_background_color = None

#     line_number_special_color = white
#     line_number_special_background_color = None
