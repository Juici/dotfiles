"""
OneDark pygments style.
"""

from pygments.style import Style
from pygments.token import Text, Whitespace, Escape, Error, Other, Keyword, \
    Name, Literal, String, Number, Operator, Punctuation, Comment, Generic


red = '#e06c75'
dark_red = '#be5046'
green = '#98c379'
yellow = '#e5c07b'
dark_yellow = '#d19a66'
blue = '#61afef'
purple = '#c678dd'
cyan = '#56b6c2'
white = '#abb2bf'
black = '#282c34'

visual_black = 'none'
comment_grey = '#5c6370'
gutter_fg_grey = '#4b5263'
cursor_grey = '#2c323c'
visual_grey = '#3e4452'
menu_grey = '#3e4452'
special_grey = '#3b4048'


class OneDarkStyle(Style):
    """
    OneDark colour scheme for pygments.
    """

    background_color = None

    highlight_color = 'bg:{visual_grey} {visual_black}'

    line_number_color = gutter_fg_grey
    line_number_background_color = None

    line_number_special_color = white
    line_number_special_background_color = None

    styles = {
        Text:                           white,
        Whitespace:                     special_grey,
        Escape:                         '',
        Error:                          red,
        Other:                          '',

        Keyword:                        purple,
        Keyword.Constant:               yellow,
        Keyword.Declaration:            red,
        Keyword.Namespace:              red,
        Keyword.Pseudo:                 '',
        Keyword.Reserved:               '',
        Keyword.Type:                   red,

        Name:                           white,
        Name.Attribute:                 yellow,
        Name.Builtin:                   blue,
        Name.Builtin.Pseudo:            '',
        Name.Class:                     blue,
        Name.Constant:                  cyan,
        Name.Decorator:                 '',
        Name.Entity:                    yellow,
        Name.Exception:                 red,
        Name.Function:                  blue,
        Name.Function.Magic:            '',
        Name.Property:                  '',
        Name.Label:                     '',
        Name.Namespace:                 blue,
        Name.Other:                     yellow,
        Name.Tag:                       purple,
        Name.Variable:                  '',
        Name.Variable.Class:            '',
        Name.Variable.Global:           '',
        Name.Variable.Instance:         '',
        Name.Variable.Magic:            '',

        Literal:                        dark_yellow,
        Literal.Date:                   '',

        String:                         green,
        String.Affix:                   '',
        String.Backtick:                '',
        String.Char:                    '',
        String.Delimiter:               '',
        String.Doc:                     '',
        String.Double:                  '',
        String.Escape:                  yellow,
        String.Heredoc:                 '',
        String.Interpol:                blue,
        String.Other:                   '',
        String.Regex:                   '',
        String.Single:                  '',
        String.Symbol:                  '',

        Number:                         dark_yellow,
        Number.Bin:                     '',
        Number.Float:                   '',
        Number.Hex:                     '',
        Number.Integer:                 '',
        Number.Integer.Long:            '',
        Number.Oct:                     '',

        Operator:                       purple,
        Operator.Word:                  '',

        Punctuation:                    white,

        Comment:                        f'italic {comment_grey}',
        Comment.Hashbang:               f'noitalic {yellow}',
        Comment.Multiline:              '',
        Comment.Preproc:                '',
        Comment.PreprocFile:            '',
        Comment.Single:                 '',
        Comment.Special:                f'noitalic {comment_grey}',

        Generic:                        '',
        Generic.Deleted:                red,
        Generic.Emph:                   'italic',
        Generic.Error:                  red,
        Generic.Heading:                green,
        Generic.Inserted:               '',
        Generic.Output:                 '',
        Generic.Prompt:                 '',
        Generic.Strong:                 'bold',
        Generic.Subheading:             green,
        Generic.Traceback:              '',
    }


# Alias the style.
OnedarkStyle = OneDarkStyle
Style = OneDarkStyle
