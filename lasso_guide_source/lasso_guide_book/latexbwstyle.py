# -*- coding: utf-8 -*-
"""
    latexbwstyle.py
    ~~~~~~~~~~~~~

    Modified version of the bw style included with pygments.

    :copyright: Copyright 2006-2013 by the Pygments team, see AUTHORS.
    :license: BSD, see LICENSE for details.
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Operator, Generic


class LatexBWStyle(Style):

    background_color = "#ffffff"
    default_style = ""

    styles = {
        Comment:                   "italic",
        Comment.Preproc:           "noitalic",

        Keyword:                   "bold",
        Keyword.Pseudo:            "nobold",
        Keyword.Type:              "nobold",

        Operator.Word:             "bold",

        Name.Class:                "bold",
        Name.Namespace:            "bold",
        Name.Exception:            "bold",
        Name.Entity:               "bold",
        Name.Tag:                  "bold",

        String:                    "noitalic",
        String.Interpol:           "bold",
        String.Escape:             "bold",

        Generic.Heading:           "bold",
        Generic.Subheading:        "bold",
        Generic.Emph:              "italic",
        Generic.Strong:            "bold",
        Generic.Prompt:            "bold",

        Error:                     "border:#FF0000"
    }
