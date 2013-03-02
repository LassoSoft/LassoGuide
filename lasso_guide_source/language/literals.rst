.. _literals:
.. http://www.lassosoft.com/Language-Guide-Literals

********
Literals
********

A **literal** is an object with its own "special" syntax, allowing it 
to be directly inserted into code. Lasso supports ``string``,
``boolean``, ``integer``, ``decimal``, ``tag`` and ``staticarray`` 
literals.

The method for using these literals is straightforward. For example, an
integer literal is expressed, as one might expect, by simply using the
numeric value in the source text. 23 is an example of an integer
literal.

-  `String Literals`_ describes the syntax used to represent string
   objects.
-  `Boolean Literals`_ describes the literals for true and false.
-  `Integer Literals`_ describes the syntax used to create integer
   objects.
-  `Decimal Literals`_ describes the syntax used to create decimal
   objects.
-  `Tag Literals`_ describes how type names are expressed.
-  `Staticarray Literals`_ describes the shortcut for "staticarray"
   object creation.
-  `Comments`_ describes the various methods for adding comments to
   code.

String Literals
===============

All strings in Lasso are Unicode strings. This means that a string can
contain any of the characters available in Unicode. Lasso supports two
kinds of string literals: quoted and ticked. Quoted strings can contain
escape sequences, while ticked strings cannot. Both quoted and ticked
strings literals can contain line breaks, and produce the same type of 
string objects. The differences between the two types of literals are 
handled entirely during parsing.

Quoted Strings
--------------

The first kind of string literal is a series of zero or more characters
surrounded by either single or double quotes. If a string literal begins
with a single quote, then it must end with a single quote. The same
holds for a string literal that begins with a double quote; it must end
with a double quote.

::

   'This is a string literal'
   "This is also a string literal"

Within this type of string literal, the **backslash** character 
``[\\0x5C]`` is interpreted as an escape character. This means that the
backslash, when encountered in a string literal changes the meaning of
the immediately following character(s). For example, a backslash is
required in order to create a string literal that contains the quote
character that surrounds the string.

::

   'This is a \'string literal\' with quotes'
   "This is also a \"string literal\" with quotes"

Note that a backslash is not required in order to insert the alternate
quote type into a string literal. For example, a single quoted string
can contain a double quote without having to be escaped.

A backslash is also required in order to insert a literal backslash into
a string. In order to embed a backslash into a string, two backslashes
must be used.

::

   'This string literal has a backslash \\ in it'

A backslash followed by an end of line (a literal line feed or carriage
return or carriage return/line feed pair) will cause that end of line
and all following literal whitespace to be removed from the resulting
string. The string resumes starting with the first encountered
non-whitespace character. This sort of escape sequence can be useful for
preserving the visual formatting of a string literal while removing the
characters used to achieve that formatting from the resulting string.

::

   'This string \
          had a break in it'
   // => This string had a break in it

The backslash can also be used to insert Unicode characters represented
either by hex code, or by character name. Where the Unicode character
name is used, the name must be the official Unicode name for that
character, enclosed between a set of colons.
Additionally, it is an error to use an unrecognized character name.

Also supported are a series of commonly used escape sequences. The
following table shows all of the permissible escape sequences.

Table 1: Supported Escape Sequences
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

================== ================= ======================
Sequence           Value             Description
================== ================= ======================
``\xhh``           Unicode character 1-2 hex digits
``\uhhhh``         Unicode character 4 hex digits
``\Uhhhhhhhh``     Unicode character 8 hex digits
``\ooo``           Unicode character 1-3 octal digits
``\:NAME:``        Unicode character Unicode character name
``\a``             0x07              Bell
``\b``             0x08              Backspace
``\e``             0x1B              Escape
``\f``             0x0C              Form feed
``\n``             0x0A              Line feed
``\r``             0x0D              Carriage return
``\t``             0x09              Tab
``\v``             0x0B              Vertical tab
``\"``             0x22              Quotation mark
``\'``             0x27              Apostrophe
``\?``             0x3F              Question mark
``\\``             0x5C              Backslash
``\<end of line>`` none              Escape whitespace
================== ================= ======================

Ticked Strings
--------------

A ticked string is a series of zero or more characters surrounded by a
pair of **backticks** [\` 0x60]. Within a ticked string, the backslash
character holds no special meaning. Ticked strings do not recognize any
escape sequences, and this can make them useful particularly when using
regular expressions which often require many backslashes. When using
regular quoted strings, the backslash would normally have to be itself
escaped, while with ticked strings, it does not. The caveat for this is
that a literal backtick character can not appear within a ticked string.

::

   `This is a ticked string`
   `A ticked string can contain 'single quotes', "double quotes", 
   \backslash characters\ and more - anything except backticks!`

Boolean Literals
================

A boolean is an object which is either "true" or "false". Lasso supports
the creation of these objects by using the word **true** or
**false** directly in the source code.

::

   true
   false

Integer Literals
================

An integer is a whole number. Integers can be positive or negative and
Lasso puts no limit on the size of an integer. Integers consist of the
digits 0 through 9 and can be written directly into the source code.

::

   1
   -4
   +937
   11801705635790

Integers can also be written using hexadecimal notation. Hexadecimal
integers begin with a zero followed by upper or lower case "x" followed
by one or more hexadecimal digits 0-9 and A-F. Either upper or lower
case letters are permitted. A hexadecimal integer literal is always
interpreted as a positive integer.

::

   0x1
   0x04
   0x3A9
   0x11F018BE6

Both numeric and hexadecimal integer literals produce the same integer
type with the same set of member methods.

Decimal Literals
================

A decimal is a fractional number. Decimal numbers contain a "decimal
point" and thus they are called "decimals". Lasso supports 64-bit
decimals. This gives Lasso's decimal numbers a range from approximately
negative to positive 2x10^300 and with precision down to 2x10^-300. A
decimal literal begins with an optional - or + followed by zero or more
digits, a decimal point, one or more additional digits, and ending with
an optional exponent. A decimal exponent begins with an upper or lower
case E, followed by an optional - or + followed by one or more digits.
Lasso also supports decimal literals for NaN (not a number) as well and
positive and negative infinity. Note that case is irrelevant when using
the NaN and infinity literals. Examples follow of various decimal
literals.

::

   .1
   -.89
   1.0
   -93.42e-4
   +93.42e4
   NaN
   infinity
   -infinity

Tag Literals
============

A tag is an object that uniquely represents a particular string of
characters. Unlike strings, tags can not be modified. Tags are used to
represent type and method names as well as variable names. A tag can
begin with an underscore or A-Z, followed by zero or more underscores,
A-Z, 0-9 or period characters. Tags can not contain spaces.

Tags are commonly used when applying type constraints to methods, data
members and variables, though they have other purposes as well.

A tag literal consists of two colons :: followed by the tag characters.

::

   ::name
   // => tag object representing "name"

In Lasso, tags are used in many different locations. For example, when
asking an object what type it is, it will reply with a tag object
representing its name. Since there will be only one tag object for every
individual name, comparing tags for equality is very fast.

Staticarray Literals
====================

Lasso's **staticarray** object type is an efficient, non-resizable
container for holding any object type. This object is used in many
places in Lasso and it's not unlikely that a Lasso programmer will come
into contact with one. Staticarrays are created in the same way as any
object, but Lasso supports a "shortcut" syntax to produce staticarrays.
This expression begins with an open parenthesis immediately followed by
a colon and then zero or more comma delimited expressions, ending with
the closing parenthesis.

::

   (: 1, 2, 'hello')
   // => a staticarray containing 1, 2 and "hello"

Comments
========

Lasso supports three types of comments:

-  `single line comments`_
-  `block comments`_
-  `doc comments`_

Single line and block comments are ignored, having no effect on the
execution of any nearby code. Doc comments are saved with any associated
methods, types or traits, as explained below.

Single Line Comments
--------------------

A single line comment begins with two forward slashes ``//``. The comment
runs until the end of the line, which is either a carriage return, line
feed or a carriage return/line feed pair.

::

   local(n = 123) // this is the first comment
   // this is another comment
   #n += 456

Block Comments
--------------

A block comment permits a large section of code to the commented. Block
comments begin with the characters ``/*`` and ends with ``*/``. Any
characters, as well as multiple lines, are permitted within the opening
and closing.

::

   local(n = 123)
   /* this is a block comment
   it has multiple lines */
   #n += 456

Block comments cannot be nested.

Doc Comments
------------

A doc comment permits a bit of documentation to be associated with
either a type, trait or method. This comment is not processed by Lasso
in any way, but is saved as-is. A doc comment begins with the characters
``/**!`` and runs until a closing ``*/`` sequence. Any characters can appear
within a doc comment, and a doc comment can consist of multiple lines.

Doc comments can only appear in the following locations:

-  Immediately before a type definition
-  Immediately before a trait definition
-  Immediately before a method definition; either inside or outside of a
   type definition
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
        Doc comment for the type's method xyz()
     */
     public xyz() => { ... }
   }

   /**!
      This doc comment is associated with this trait
   */
   define tBar => trait {
     /**!
        Doc comment for the trait's method doIt()
     */
     provide doIt() => { ... }
   }
