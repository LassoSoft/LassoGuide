.. http://www.lassosoft.com/Language-Guide-Literals
.. _literals:

********
Literals
********

A :dfn:`literal` is an object with its own special syntax that allows it to be
inserted directly into code. Lasso supports :type:`string`, :type:`boolean`,
:type:`integer`, :type:`decimal`, :type:`tag` and :type:`staticarray` literals.

The method for expressing these literals is straightforward. For example, an
integer literal is expressed, as one would expect, by simply using the numeral
in the source text. ``23`` is an example of an integer literal.


String Literals
===============

All strings in Lasso are Unicode strings. This means that a string can contain
any of the characters available in Unicode. Lasso supports two kinds of string
literals: quoted and ticked. Quoted strings can contain escape sequences, while
ticked strings cannot. Both quoted and ticked string literals can contain line
breaks, and produce the same type of string objects. The differences between the
two types of literals are handled entirely during parsing.


Quoted Strings
--------------

The first kind of string literal is a :dfn:`quoted string`, which is a series of
zero or more characters surrounded by either single or double quotes. If a
string literal begins with a single quote, then it must end with a single quote.
The same holds for a string literal that begins with a double quote; it must end
with a double quote. ::

   'This is a string literal'
   "This is also a string literal"

Within this type of string literal, the backslash character (``\x5C``) is
interpreted as an escape character. This means that when a backslash is
encountered in a string literal, it changes the meaning of the immediately
following character(s). For example, a backslash is required in order to create
a string literal that contains the quote character that surrounds the string. ::

   'This is a \'string literal\' with quotes'
   "This is also a \"string literal\" with quotes"

Note that a backslash is not required in order to insert the alternate quote
type into a string literal. For example, a double-quoted string can contain a
single quote without having to escape it. ::

   "Escaping this single quote isn't required"

A backslash is also required in order to insert a literal backslash into a
string. In order to embed a backslash into a string, two backslashes must be
used. ::

   'This string literal has a backslash \\ in it'

A backslash followed by an end of line (a literal line feed or carriage return
or carriage return/line feed pair) will cause that end of line and all following
literal whitespace to be removed from the resulting string. The string resumes
starting with the first encountered non-whitespace character. This sort of
escape sequence can be useful for preserving the visual formatting of a string
literal while removing the characters used to achieve that formatting from the
resulting string. ::

   'This string \
          had a break in it'
   // => This string had a break in it

The backslash can also be used to insert Unicode characters represented either
by hex code, or by character name. Where the Unicode character name is used, the
name must be the official Unicode name for that character, enclosed between a
set of colons. Additionally, it is an error to use an unrecognized character
name.

Also supported are a series of commonly used escape sequences. The following
table shows all of the permissible escape sequences.

.. tabularcolumns:: |l|l|L|

.. _literals-string-escape:

.. table:: Supported String Escape Sequences

   ================== ================= ========================================
   Escape Sequence    Value             Description
   ================== ================= ========================================
   ``\xhh``           Unicode character 1--2 hex digits
   ``\uhhhh``         Unicode character 4 hex digits
   ``\Uhhhhhhhh``     Unicode character 8 hex digits
   ``\ooo``           Unicode character 1--3 octal digits
   ``\:NAME:``        Unicode character Unicode character name
   ``\a``             0x07              Bell
   ``\b``             0x08              Backspace
   ``\e``             0x1B              Escape
   ``\f``             0x0C              Form feed
   ``\n``             0x0A              Line feed
   ``\r``             0x0D              Carriage return
   ``\t``             0x09              Tab
   ``\v``             0x0B              Vertical tab
   ``\"``             0x22              Double quote
   ``\'``             0x27              Single quote
   ``\?``             0x3F              Question mark
   ``\\``             0x5C              Backslash
   ``\<end of line>`` none              Escaped whitespace
   ================== ================= ========================================


Ticked Strings
--------------

A :dfn:`ticked string` is a series of zero or more characters surrounded by a
pair of backticks (``\x60``). Within a ticked string, the backslash character
holds no special meaning. Ticked strings do not recognize any escape sequences,
and this can make them particularly useful when using regular expressions which
often require many backslashes. (Using regular quoted strings, the backslashes
would themselves have to be doubled.) The caveat for this is that a literal
backtick character cannot appear within a ticked string. ::

   `This is a ticked string`
   `A ticked string can contain 'single quotes', "double quotes",
   \backslash characters\ and more - anything except backticks!`


Boolean Literals
================

.. index:: boolean literal, true, false

A :dfn:`boolean` is an object that is either "true" or "false". Lasso supports
the creation of these objects by using the word ``true`` or ``false`` directly
in the source code. ::

   true
   false


Integer Literals
================

An :dfn:`integer` is a whole number. Integers can be positive or negative and
Lasso puts no limit on the size of an integer. Integers consist of the digits 0
through 9 and can be written directly into the source code. ::

   1
   -4
   +937
   11801705635790

Integers can also be written using hexadecimal notation. Hexadecimal integers
begin with a zero followed by an upper or lowercase "x" followed by one or more
hexadecimal digits (0--9 and A--F). Either upper or lowercase letters are
permitted. A hexadecimal integer literal is always interpreted as a positive
integer. ::

   0x1
   0x04
   0x3A9
   0x11F018BE6

Both numeric and hexadecimal integer literals produce the same :type:`integer`
type with the same set of member methods.

See the :ref:`math` chapter for more information on the :type:`integer` type.


Decimal Literals
================

A :dfn:`decimal` is a fractional number. Decimal numbers contain a decimal point
and therefore are called "decimals". Lasso supports 64-bit decimals. This gives
Lasso's decimal numbers a range from approximately negative to positive 2x10^300
and with precision down to 2x10^-300. A decimal literal begins with an optional
"-" or "+" character followed by zero or more digits, a decimal point, one or
more additional digits, and ending with an optional exponent. A decimal exponent
begins with an upper or lowercase "E", followed by an optional "-" or "+"
character followed by one or more digits. Lasso also supports decimal literals
for "NaN" (not a number) as well and positive and negative "infinity". (Note
that case is irrelevant when using the ``NaN`` and ``infinity`` literals.) ::

   .1
   -.89
   1.0
   -93.42e-4
   +93.42e4
   NaN
   infinity
   -infinity

See the :ref:`math` chapter for more information on the :type:`decimal` type.


.. _literals-tag:

Tag Literals
============

.. index:: tag literal

A :dfn:`tag` is an object that uniquely represents a particular string of
characters. Unlike strings, tags cannot be modified. Tags are used to represent
type and method names as well as variable names. A tag should begin with a
letter or underscore, followed by zero or more letters, numbers, underscores, or
period characters. Tags cannot contain spaces.

Tags are commonly used when applying type constraints to methods, data members,
and variables; though they have other purposes as well.

A tag literal consists of two colons followed by the tag's characters. ::

   // Creates a tag object representing "name"
   ::name

In Lasso, tags are used in many different locations. For example, when asking an
object what type it is, it will reply with a tag object representing its name.
Since there will be only one tag object for every individual name, comparing
tags for equality is very fast.


Staticarray Literals
====================

Lasso's :dfn:`staticarray` type is an efficient, non-resizable container for
holding any series of object types which is used in many places in Lasso.
Staticarrays are created in the same way as any object, but Lasso supports a
"shortcut" syntax to produce staticarrays. This expression begins with an open
parenthesis immediately followed by a colon, then zero or more comma-delimited
expressions, ending with the closing parenthesis. ::

   // Creates a staticarray containing 1, 2, and "hello"
   (: 1, 2, 'hello')

See the :ref:`containers` chapter for more information on the
:type:`staticarray` type.


Series Literals
===============

.. index::
   single: series literal
   see: range; series literal

Lasso's :type:`generateSeries` type is a quick and efficient way to create a
:dfn:`series` or :dfn:`range` for use with query expressions. The object created
has a starting integer and ending integer for the series separated by the word
"to". An optional integer specifying the step size, which defaults to 1, can
be added after the word "by". ::

   0 to 10 by 2
   // => 0, 2, 4, 6, 8, 10


Comments
========

.. index:: comment

Lasso supports three types of comments: single line comments, block comments,
and doc comments. Single line and block comments are ignored, having no effect
on the execution of any nearby code. Doc comments are saved with the adjacent
method, type, or trait, as explained below.


Single Line Comments
--------------------

A :dfn:`single line comment` begins with two forward slashes (``//``). The
comment runs until the end of the line, which is either a carriage return, line
feed, or a carriage return/line feed pair. ::

   local(n = 123) // This is the first comment
   // This is another comment
   #n += 456

Note that when embedding Lasso code between a set of delimiters, a closing
delimiter on the same line as a single line comment will be skipped by the Lasso
parser.

Block Comments
--------------

A :dfn:`block comment` permits a large section of code to be commented. Any
characters, as well as multiple lines, are permitted between the opening
delimiter (``/*``) and closing delimiter (``*/``). Block comments cannot be
nested. ::

   local(n = 123)
   /* this is a block comment
   it has multiple lines */
   #n += 456


Doc Comments
------------

A :dfn:`doc comment` permits a block of documentation to be associated with
either a type, trait, or method. This comment is not processed by Lasso in any
way, but is saved as-is with the object. A doc comment begins with the opening
doc comment delimiter (``/**!``) and runs until a closing delimiter (``*/``).
Any characters can appear within a doc comment, and a doc comment can consist of
multiple lines.

Doc comments can only appear in the following locations:

-  Immediately before a type definition
-  Immediately before a trait definition
-  Immediately before a member or unbound method definition
-  Immediately before a trait's provide or require section

::

   /**!
       This doc comment is associated with this method
   */
   define foo->xyz() => { ... }

   /**!
       This doc comment is associated with this type definition
   */
   define foo => type {
      /**!
          Doc comment for the type's xyz() method
      */
      public xyz() => { ... }
   }

   /**!
       This doc comment is associated with this trait
   */
   define tBar => trait {
      /**!
          Doc comment for the trait's doIt() method
      */
      provide doIt() => { ... }
   }

Doc comments for a type can be set and retrieved programatically using the
`tag->docComment` method, as long as Lasso is run with the
:envvar:`LASSO9_RETAIN_COMMENTS` variable enabled.

.. code-block:: none

   $> env LASSO9_RETAIN_COMMENTS=1 lasso9 -s "::array->docComment"
   /**!
   An array is an object that can hold multiple values…

   $> env LASSO9_RETAIN_COMMENTS=1 lasso9 -s "
   ::boolean->docComment = 'Boolean objects are either true or false.'
   ::boolean->docComment
   "
   Boolean objects are either true or false.
