.. _regular-expressions:

*******************
Regular Expressions
*******************

The regular expression type in Lasso allows for powerful search and replace
operations on strings and byte streams. This chapter details how the regular
expression type works and other Lasso methods that use regular expressions.


Regular Expression Structure
============================

A :dfn:`regular expression` is a pattern that describes a sequence of characters
that you want to search for in a target (or input) string. Regular expressions
consist of letters or digits that simply match themselves, wildcards that match
any character in a class such as whitespace or digits, and combining symbols
that expand wildcards to match several characters rather than just one. Lasso
uses the `ICU Regular Expressions package`_ for its support of regular
expressions.

.. note::
   Full documentation of regular expression methodology is outside the scope of
   this guide. Consult a standard reference on regular expressions for more
   information about how to use this flexible technology.


Basic Matchers
--------------

The simplest regular expression is just a pattern containing letters or digits.
The regular expression :regexp:`bird` is said to match the string "bird". The
regular expression :regexp:`123` matches the string "123". The regular
expression is matched against an input string by comparing each character in the
regular expression to each character in the input string, one after another.
Regular expressions are normally case-sensitive so the regular expression
:regexp:`John` would not match the string "john".

Unicode characters within a regular expression work the same as any other
character. The escape sequence ``\u2FB0`` with the four-digit hex value for a
Unicode character can also be used in place of any actual character (within
regular expressions or any Lasso strings). The escape sequence ``\u2FB0``
represents a Chinese character.

Regular expressions can also match part of a string. The regular expression
:regexp:`bird` is found starting at position 3 in the string "A bird in the
hand".

A regular expression can contain wildcards that match one of a set of
characters. ``[Jj]`` is a wildcard which matches either an uppercase "J" or a
lowercase "j". The regular expression :regexp:`[Jj]ohn` will match either the
string "John" or the string "john". The wildcard ``[aeiou]`` matches any
lowercase vowel. The wildcard ``[a-z]`` matches any lowercase roman letter. The
wildcard ``[0-9]`` matches any arabic digit. The wildcard ``[a-zA-Z]`` matches
any uppercase or lowercase roman letter. If a Unicode character is used in a
character range then any characters between the hex value for the two characters
are matched. The wildcard ``[\u2FB0-\u2FBF]`` will match 16 different Chinese
characters.

The period (``.``) is a special wildcard that matches any single character. The
regular expression :regexp:`..` would match any two-character string including
"be", "12", or even "|nbsp| |nbsp|" (two spaces). The period will match any
ASCII or Unicode character including punctuation or most whitespace characters.
It will not match return or newline characters.

.. |nbsp| unicode:: 0xA0
   :trim:

A number of other predefined wildcards are available. The predefined wildcards
are all preceded by a backslash (``\``).

Many of the predefined wildcards come in pairs. The wildcard ``\s`` matches any
whitespace character including tabs, spaces, returns, or newlines. The wildcard
``\S`` matches any non-whitespace character. The wildcard ``\w`` matches any
alphanumeric character or underscore. The "w" is said to stand for "word" since
these are all characters that may appear within a word. The wildcard ``\W``
matches non-word characters. The wildcard ``\d`` matches any arabic digit and
the wildcard ``\D`` matches any non-digit. For example, the regular expression
:regexp:`\\w\\w\\w` would match any three-character word such as "cat" or "dog".
The regular expression :regexp:`\\d\\d\\d-\\d\\d\\d\\d-\\d\\d\\d\\d` would match
a standard North American phone number in the form "360-555-1212".

The predefined wildcards only work on standard ASCII strings. There is a special
pair of wildcards ``\p`` and ``\P`` that allow different characters in a Unicode
string to be matched. The wildcard is specified as ``\p{Property}``. A list of
properties can be found in the table below. For example the wildcard ``\p{L}``
matches any Unicode letter character, the wildcard ``\p{N}`` matches any Unicode
digit, and the wildcard ``\p{P}`` matches any Unicode punctuation characters.
The ``\P{Property}`` wildcard is the opposite. ``\P{L}`` matches any Unicode
character that is not a letter.

Many characters have special meanings in regular expressions including ``[ ] ( )
{ } . * + ? ^ $ \ |``. In order to match one of these characters literally it is
necessary to use a backslash in front of it. For example ``\[`` matches a
literal opening square bracket rather than starting a character range.

It is important to remember that double- or single-quoted string literals use a
backslash for escape sequences, so you must use a double backslash to use the
predefined wildcards and to escape special characters. You can avoid having to
use a double backslash by specifying the regular expression using ticked string
literals. However, the use of ticked string literals makes it difficult to match
common escape sequences such as returns (``\r``) or newlines (``\n``). It is
recommended that you use ticked string literals for all of your regular
expressions until you need one of these escape sequences, and then that you
concatenate in a non-ticked string literal for these sequences. For example, the
following string concatenation would create a regular expression that matches a
letter followed by a tab followed by a digit::

   local(my_regexp) = `\w` + "\t" + `\d`


Basic Matching Strings
^^^^^^^^^^^^^^^^^^^^^^

Below is a listing of basic matchers and a brief definition. Matches are
case-sensitive by default. Be sure to note whether quoted or ticked string
literals are being used.

```.```
   Period matches any single character except a line break.

```[ ]```
   Character class. Matches any character contained between the square brackets.

```[^ ]```
   Character exception class. Matches any character that is not contained
   between the square brackets.

```[a-z]```
   Lowercase character range. Matches any character between the two specified.

```[A-Z]```
   Uppercase character range.

```[a-zA-Z]```
   Combination character range matching any letter.

```[0-9]```
   Numeric character range.

``"\t"``
   Matches a tab character.

``"\r"``
   Matches a return character.

``"\n"``
   Matches a newline character.

```"```
   Matches a double quote.

```'```
   Matches a single quote.

```\x##```
   Matches a single ISO-8859-1 character. The number signs should be replaced
   with the 2-digit hex value for the character.

```\u####```
   Matches a single Unicode character. The number signs should be replaced with
   the 4-digit hex value (code point) for the Unicode character.

```\p{ }```
   Matches a single Unicode character with the stated property. (The available
   properties are listed next.)

```\P{ }```
   Matches a single Unicode character that does not have the stated property.
   (The available properties are listed next.)

```\w```
   Matches an alphanumeric "word" character, including underscores.

```\W```
   Matches a non-alphanumeric character (whitespace or punctuation).

```\s```
   Matches a blank, whitespace character. Equivalent to ``[\t\n\f\r\p{Z}]``.

```\S```
   Matches a non-blank, non-whitespace character.

```\d```
   Matches a digit character. Equivalent to ``[0-9]``.

```\D```
   Matches a non-digit character.

```\```
   Escapes the next character. This allows any symbol to be specified as a
   matching character including the reserved characters ``[ ] ( ) { } . * + ? ^
   $ \ |``.

The following table lists the property symbols that can be used with the ``\p``
and ``\P`` wildcards. The main symbol (e.g. ``\p{L}``) will match all of the
characters that are matched by each of the variants.

.. tabularcolumns:: llll

.. _regular-expressions-unicode:

.. table:: Unicode Property Symbols

   +--------+------------------------------+----------+------------------------+
   | Symbol | Property                     | Variants | Description            |
   +========+==============================+==========+========================+
   | ``L``  | letter                       | ``Lu``   | Uppercase Letter       |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Ll``   | Lowercase Letter       |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Lt``   | Titlecase Letter       |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Lm``   | Modifier Letter        |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Lo``   | Other Letter           |
   +--------+------------------------------+----------+------------------------+
   | ``N``  | number                       | ``Nd``   | Decimal Digit Number   |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Nl``   | Letter Number          |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``No``   | Other Number           |
   +--------+------------------------------+----------+------------------------+
   | ``P``  | punctuation character        | ``Pc``   | Connector Punctuation  |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Pd``   | Dash Punctuation       |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Ps``   | Open Punctuation       |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Pe``   | Close Punctuation      |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Pi``   | Initial Punctuation    |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Pf``   | Final Punctuation      |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Po``   | Other Punctuation      |
   +--------+------------------------------+----------+------------------------+
   | ``S``  | symbol                       | ``Sm``   | Math Symbol            |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Sc``   | Currency Symbol        |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Sk``   | Modifier Symbol        |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``So``   | Other Symbol           |
   +--------+------------------------------+----------+------------------------+
   | ``Z``  | separator                    | ``Zs``   | Space Separator        |
   |        | (typically whitespace)       |          |                        |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Zl``   | Line Separator         |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Zp``   | Paragraph Separator    |
   +--------+------------------------------+----------+------------------------+
   | ``M``  | mark                         | ``Mn``   | Non-Spacing Mark       |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Mc``   | Spacing Combining Mark |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Me``   | Enclosing Mark         |
   +--------+------------------------------+----------+------------------------+
   | ``C``  | "other" character            | ``Cc``   | Control                |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Cf``   | Format                 |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Cs``   | Surrogate              |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Co``   | Private Use            |
   +--------+------------------------------+----------+------------------------+
   |        |                              | ``Cn``   | Not Assigned           |
   +--------+------------------------------+----------+------------------------+


Combining Symbols
-----------------

Combining symbols allow wildcards to be expanded to match entire substrings
rather than individual characters. For example, the wildcard ``[a-z]`` matches
one lowercase letter and needs to be repeated three times to match a three
letter word :regexp:`[a-z][a-z][a-z]`. Instead, the combining symbol ``{3}`` can
be used to specify that the preceding wildcard should be repeated three times
``[a-z]{3}``.

The combining symbol ``+`` matches one or more repetitions of the preceding
matcher. The expression ``[a-z]+`` matches any string of lowercase letters. This
expression matches the strings "a", "green", or "international". It does not
match "$1,544,897.00" because that string does not contain any lowercase
letters.

The combining symbol ``+`` can be used with the ``.`` wildcard to match any
string of one or more characters (``.+``), with the wildcard ``\w`` to match any
word (``\w+``), or with the wildcard ``\s`` to match one or more whitespace
characters (``\s+``). The ``+`` symbol can also be used with a simple letter to
match one or more repetitions of the letter. The regular expression
:regexp:`Me+t` matches both the string "Met" and the string "Meet", not to
mention "Meeeeeet".

The combining symbol ``*`` matches zero or more repetitions of the preceding
matcher. The ``*`` symbol can be used with the generic wildcard ``.`` to match
any string of characters (``.*``). The ``*`` symbol can be used with the
whitespace wildcard ``\s`` to match a string of whitespace characters. For
example, the expression :regexp:`\\s*cat\\s*` will match the string "cat", but
also the string "|nbsp| cat |nbsp|".

Braces are used to designate a specific number of repetitions of the preceding
wildcard. When the braces contain a single number they designate that the
preceding wildcard should be matched exactly that number of times. For example,
``[a-z]{3}`` matches any three lowercase letters. When the braces contain two
numbers they allow for any number of repetitions from the lower number to the
upper number. The pattern ``[a-z]{3,5}`` matches any three to five lowercase
letters. If the second number is omitted then the braces function similarly to a
``+``, e.g. ``[a-z]{3,}`` matches any string of lowercase letters with a length
of 3 or longer.

The symbol ``?`` on its own makes the preceding matcher optional. For example,
the expression :regexp:`mee?t` will match either the string "met" or "meet"
since the second "e" is optional, but it won't match "meeeet".

When used after a ``+``, ``*``, or braces the ``?`` makes the match non-greedy.
Normally, a subexpression will match as much of the input string as possible.
The expression :regexp:`<.*>` will match a string that begins and ends with
angle brackets. It will match the entire string ``"<b>Bold Text</b>"``. With the
non-greedy option the expression :regexp:`<.*?>` will match the shortest string
possible. It will now match just the first part of the string ``"<b>"`` and a
second application of the expression will match the last part of the string
``"</b>"``.

``+``
   Matches 1 or more repetitions of the preceding symbol.

``*``
   Matches 0 or more repetitions of the preceding symbol.

``?``
   Makes the preceding symbol optional.

``{n}``
   Braces. Matches "n" repetitions of the preceding symbol.

``{n,}``
   Matches at least "n" repetitions of the preceding symbol.

``{n,m}``
   Matches at least "n", but no more than "m" repetitions of the preceding
   symbol.

``+?``
   Non-greedy variant of the plus sign; matches the shortest string possible.

``*?``
   Non-greedy variant of the asterisk; matches the shortest string possible.

``{ }?``
      Non-greedy variant of braces; matches the shortest string possible.


Groupings
---------

Groupings have two purposes in regular expressions: they allow portions of a
regular expression to be designated as groups that can be used in a replacement
pattern, and they allow more complex regular expressions to be built up from
simple regular expressions.

Parentheses are used to designate a portion of a regular expression as a
replacement group. Most regular expressions are used to perform find/replace
operations so this is an essential part of designing a pattern. Note that if
parentheses are meant to be a literal part of the pattern then they need to be
escaped as ``\(`` and ``\)``. The regular expression :regexp:`<b>(.*?)</b>`
matches an HTML bold tag. The contents of the tag are designated as a group. If
this regular expression is applied to the string ``"<b>Bold Text</b>"`` then the
pattern matches the entire string and "Bold Text" is designated as the first
group.

Similarly, a phone number could be matched by the regular expression
:regexp:`\((\d{3})\) (\d{3})-(\d{4})` with three groups. The first group
represents the area code (note that the parentheses appear in both escaped form
``\( \)`` to match literal opening and closing parentheses and normal form ``(
)`` to designated a grouping). The second group represents the prefix and the
third group the subscriber number. When the regular expression is applied to the
string "(360) 555-1212" then the pattern matches the entire string and generates
the groups "360", "555", and "1212".

Parentheses can also be used to create a subexpression that does not generate a
replacement group using ``(?:)``. This form can be used to create subexpressions
that function much like very complex wildcards. For example, the expression
:regexp:`(?:blue)+` will match one or more repetitions of the subexpression
"blue". It will match the strings "blue", "blueblue" or "blueblueblueblue".

The ``|`` symbol can be used to specify alternation. It is most useful when used
with subexpressions. The expression :regexp:`(?:blue)|(?:red)` will match either
the word "blue" or the word "red".

``( )``
   Grouping for output. Defines a numbered group for output. Up to nine groups
   can be defined.

``(?: )``
   Grouping without output. Can be used to create a logical grouping that should
   not be assigned to an output.

``|``
   Alternation. Matches either the characters before or the characters after the
   symbol. May appear within a group to limit the alternation boundary.


Replacement Expressions
-----------------------

When regular expressions are used for find/replace operations the replacement
expression can contain placeholders into which the defined groups from the
search expression are substituted. The placeholder ``$0`` represents the entire
matched string. The placeholders ``$1`` through ``$9`` represent the first nine
groupings as defined by parentheses in the regular expression.

The regular expression :regexp:`<b>(.*?)</b>` from above matches an HTML bold
tag with the contents of the tag designated as a group. The replacement
expression :regexp:`<em>$1</em>` will essentially replace the bold tags with
emphasis tags, without disrupting the contents of the tags. For example the
string ``"<b>Bold Text</b>"`` would result in ``"<em>Bold Text</em>"`` after a
find/replace operation.

The phone number expression :regexp:`\((\d{3})\) (\d{3})-(\d{4})` from above
matches a phone number and creates three groups for the parts of the phone
number. The replacement expression :regexp:`$1-$2-$3` would rewrite the phone
number to be in a more standard format. For example, the string "(360) 555-1212"
would result in "360-555-1212" after a find/replace operation.

``$0``--``$9``
   Names a group in the replace string. ``$0`` represents the entire matched
   string. Up to nine groups can be specified using the digits 1 through 9.

.. tip::
   To place a literal ``$`` in a replacement string, escape it as ``\$``.


Advanced Expressions
--------------------

The ICU library also supports a number of more advanced symbols for special
purposes. Some of these symbols are listed in the following table, but a
reference on regular expressions should be consulted for full documentation of
these symbols and other advanced concepts. A list of regular expression flags
follows.

``(?# )``
   Regular expression comment. The contents are not interpreted as part of the
   regular expression.

``(?i)``
   Sets a flag to make the remainder of the regular expression case-insensitive.
   Similar to specifying ``-ignoreCase``.

``(?-i)``
   Sets the remainder of the regular expression to be case-sensitive (the
   default).

``(?i: )``
   The contents of this group will be matched case-insensitive and the group
   will not be added to the output.

``(?-i: )``
   The contents of this group will be matched case-sensitive and the group will
   not be added to the output.

``(?= )``
   Positive lookahead assertion. The contents are matched following the current
   position, but not added to the output pattern.

``(?! )``
   Negative lookahead assertion. The same as above, but the content must not
   match following the current position.

``(?<= )``
   Positive lookbehind assertion. The contents are matched preceding the current
   position, but not added to the output pattern. The length of possible strings
   matched by lookbehinds cannot be unbounded (no ``*`` or ``+`` operators).

``(?<! )``
   Negative lookbehind assertion. The same as above, but the contents must not
   match preceding the current position.

```\b```
   Matches the boundary between a word and a space. Does not properly interpret
   Unicode characters. The transition between any regular ASCII character
   (matched by ``\w``) and a Unicode character is seen as a word boundary.

```\B```
   Matches a boundary not between a word and a space.

```\A```
   Matches the beginning of the input.

```\Z```
   Matches the end of the input.

```^```
   Matches the beginning of the input, or the line if the ``m`` flag is set.

```$```
   Matches the end of the input, or the line if the ``m`` flag is set.


Regular Expression Flags
^^^^^^^^^^^^^^^^^^^^^^^^

``i``
   Sets matching to be case-insensitive.

``x``
   Allows whitespace in comments and patterns.

``s``
   Allows the ``.`` character to also match line break characters.

``m``
   Allows the characters ``^`` and ``$`` to match the start and end of lines,
   respectively. By default these will only match at the start and end of the
   input.

``w``
   Changes the behavior of ``\b`` so that word boundaries are defined according
   to `Unicode Standard Annex #29`_.


Regexp Type
===========

The :type:`regexp` type allows a regular expression to be defined once and then
reused many times. It facilitates simple search operations, splitting strings,
and interactive find/replace operations.

The :type:`regexp` type has some advantages over the ``string_…`` methods that
perform regular expression operations. Performance can be increased by creating
a regular expression once and then reusing it multiple times. The type has a
number of member methods that allow access to the stored regular expressions and
input and output of strings, performing find/replace operations, or acting as
components in an interactive find/replace operation. These are described below.


Creating Regular Expression Objects
-----------------------------------

.. type:: regexp
.. method:: regexp(find::string, replace::string, input::string, ignorecase::boolean)
.. method:: regexp(\
      find::string, \
      replace::string= ?, \
      input::string= ?, \
      -ignoreCase::boolean= ?)
.. method:: regexp(\
      -find::string, \
      -replace::string= ?, \
      -input::string= ?, \
      -ignoreCase::boolean= ?)

   The `regexp` creator method creates a reusable regular expression. A `regexp`
   object must be initialized with a string regular expression pattern as either
   the first parameter or as the argument of a ``-find`` keyword parameter. The
   type will also store a replacement pattern, and input string passed as either
   the second and third parameters or specified with the ``-replace`` or
   ``-input`` keyword parameter, respectively. These can be overridden with
   particular member methods. The type also has an ``-ignoreCase`` option which
   controls whether regular expressions are applied with case sensitivity or
   not.

   A regular expression can be created that explicitly specifies the find
   pattern, replacement pattern, input string, and optionally with the
   ``-ignoreCase`` option. Using a fully qualified regular expression that is
   output to the page (rather than being stored in a variable) is an easy way to
   perform a quick find/replace operation. ::

      regexp(`[aeiou]`, 'x', 'The quick brown fox jumped over the lazy dog.')->replaceAll
      // => Thx qxxck brxwn fxx jxmpxd xvxr thx lxzy dxg.

   However, a regular expression will usually be stored in a variable and then
   later run against an input string. The following code stores a regular
   expression with a find and replace pattern into the variable "my_regexp". The
   following section :ref:`regular-expressions-simple` will show how this
   regular expression can be applied to strings. ::

      local(my_regexp) = regexp(-find=`[aeiou]`, -replace=`x`, -ignoreCase)

.. member:: regexp->findPattern()

   Returns the find pattern.

.. member:: regexp->replacePattern()

   Returns the replacement pattern.

.. member:: regexp->input()

   Returns the input string.

.. member:: regexp->ignoreCase()

   Returns "true" if the ``-ignoreCase`` flag has been set, otherwise returns
   "false".

.. member:: regexp->groupCount()

   Returns an integer specifying how many groups were found in the find pattern.

.. member:: regexp->output()

   Returns the output string.

For example, the regular expression above can be inspected by the following
code. The group count is "0" since the find expression does not contain any
groups (designated by parentheses)::

   'FindPattern: ' + #my_regexp->findPattern + '\n'
   'ReplacePattern: ' + #my_regexp->replacePattern + '\n'
   'IgnoreCase: ' + #my_regexp->ignoreCase + '\n'
   'GroupCount: ' + #my_regexp->groupCount + '\n'

   // =>
   // FindPattern: [aeiou]
   // ReplacePattern: x
   // IgnoreCase: true
   // GroupCount: 0


.. _regular-expressions-simple:

Simple Find/Replace and Split Methods
-------------------------------------

The :type:`regexp` type provides two member methods that perform a find/replace
on an input string and one method that splits an input string into an array.
These methods are documented with examples below, and are shortcuts for longer
operations that can be performed using the interactive methods described in the
next section.

.. member:: regexp->replaceAll(replace::string)
.. member:: regexp->replaceAll(-input= ?, -find= ?, -replace= ?, -ignoreCase= ?)

   The first listed incarnation of this method allows you to change the
   replacement string. The second will replace all occurrences of the current
   find pattern with the current replacement pattern. The ``-input`` parameter
   specifies what string should be operated on. If no input is provided then the
   input stored in the regular expression object is used. If desired, new
   ``-find`` and ``-replace`` patterns can also be specified within this method
   along with the ``-ignoreCase`` flag.

.. member:: regexp->replaceFirst(-input= ?, -find= ?, -replace= ?, -ignoreCase= ?)

   Replaces the first occurrence of the current find pattern with the current
   replacement pattern. The ``-input`` parameter specifies what string should be
   operated on. If no input is provided then the input stored in the regular
   expression object is used. If desired, new ``-find`` and ``-replace``
   patterns can also be specified within this method along with the
   ``-ignoreCase`` flag.

.. member:: regexp->split(-input= ?, -find= ?, -replace= ?, -ignoreCase= ?)

   Splits the string using the regular expression as a delimiter and returns a
   staticarray of substrings. The ``-input`` parameter specifies what string
   should be operated on. If no input is provided then the input stored in the
   regular expression object is used. If desired, new ``-find`` and ``-replace``
   patterns can also be specified within this method along with the
   ``-ignoreCase`` flag.


Use the Same Regular Expression on Multiple Inputs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The same regular expression can be used on multiple inputs by first creating the
regular expression using one of the `regexp` creator methods and then calling
`regexp->replaceAll` with a new ``-input`` as many times as necessary. Since the
regular expression is only created once this technique can be considerably
faster than using the `string_replaceRegExp` method repeatedly. ::

   local(my_regexp) = regexp(-find=`[aeiou]`, -replace=`x`, -ignoreCase)
   #my_regexp->replaceAll(-input='The quick brown fox jumped over the lazy dog.')
   #my_regexp->replaceAll(-input='Lasso Server')

   // =>
   // Thx qxxck brxwn fxx jxmpxd xvxr thx lxzy dxg.
   // Lxssx Sxrvxr

The replace pattern can also be changed if necessary. The following code changes
both the input and replace patterns each time the regular expression is used::

   local(my_regexp) = regexp(-find=`[aeiou]`, -replace=`x`, -ignoreCase)
   #my_regexp->replaceAll(-input='The quick brown fox jumped over the lazy dog.', -replace=`y`)
   #my_regexp->replaceAll(-input='Lasso Server', -replace=`z`)

   // =>
   // Thy qyyck brywn fyx jympyd yvyr thy lyzy dyg.
   // Lzssz Szrvzr

The replacement pattern can reference groups from the input using ``$1`` through
``$9``. The following example uses a regular expression to clean up the
formatting on a couple of telephone numbers::

   local(my_regexp) = regexp(`\((\d{3})\) (\d{3})-(\d{4})`, `$1-$2-$3`)
   #my_regexp->replaceAll(-input='(360) 555-1212')
   #my_regexp->replaceAll(-input='(800) 555-1212')

   // =>
   // 360-555-1212
   // 800-555-1212


Split a String Using a Regular Expression
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `regexp->split` method can be used to split a string using a regular
expression as the delimiter. This allows strings to be split into parts using
sophisticated criteria. For example, rather than splitting a string on a comma,
the "and" before the last item can be taken into account. Or, rather than
splitting a string on space, the string can be split into words taking
punctuation and other whitespace into account.

The same regular expression from the example above can be used to split a string
into substrings. In this case the string will be split on vowels, generating a
staticarray with elements containing only consonants or spaces::

   local(my_regexp) = regexp(-find=`[aeiou]`, -replace=`x`, -ignoreCase)

   #my_regexp->split(-input='The quick brown fox jumped over the lazy dog.')
   // => staticarray(Th,  q, , ck br, wn f, x j, mp, d , v, r th,  l, zy d, g.)

The ``-find`` pattern can be modified in-place within the `regexp->split` method
to split the string on a different regular expression. In this example the
string is split on any one of one or more non-word characters. This splits the
string into words not including any whitespace or punctuation. ::

   #my_regexp->split(-find=`\W+`, -input='The quick brown fox jumped over the lazy dog.')
   // => staticarray(The, quick, brown, fox, jumped, over, the, lazy, dog)

If the ``-find`` expression contains groups then they will be returned in the
array in between the split elements. For example, surrounding the ``-find``
pattern above with parentheses will result in an array of alternating word
elements and whitespace/punctuation elements. ::

   #my_regexp->split(-find=`(\W+)`, -input='The quick brown fox jumped over the lazy dog.')
   // => staticarray(The,  , quick,  , brown,  , fox,  , jumped,  , over,  , the,  , lazy,  , dog, .)


Interactive Find/Replace Methods
--------------------------------

The :type:`regexp` type provides a collection of member methods that make
interactive find/replace operations possible. Interactive in this case means
that Lasso code can intervene in each replacement as it happens. Rather than
performing a simple one-shot find/replace like those shown in the last section,
it is possible to programmatically determine the replacement strings using
database searches or any logic.

The order of operations of an interactive find/replace operation is as follows:

#. The regular expression object is initialized with a ``-find`` pattern and
   ``-input`` string. In this example the find pattern will match each word in
   the input string in turn::

      local(my_regexp) = regexp(
         -find=`\w+`,
         -input='The quick brown fox jumped over the lazy dog.',
         -ignoreCase
      )

#. A ``while`` loop is used to advance the regular expression match with
   `regexp->find`. Each time through the loop the pattern is advanced one match
   forward. If there are no further matches then the method returns "false" and
   the loop is exited::

      while(#my_regexp->find) => {
         // ...
      }

#. Within the ``while`` loop the `regexp->matchString` method is used to inspect
   the current match. If the find pattern had groups then they could be
   inspected here by passing an integer parameter to `regexp->matchString`::

      local(match) = #my_regexp->matchString

#. The match is manipulated. For this example the match string will be reversed
   using the `string->reverse` method. This will reverse the word "lazy" to be
   "yzal"::

      #match->reverse

#. The modified match string is now appended to the output string using the
   `regexp->appendReplacement` method. This method will automatically append any
   parts of the input string that weren't matched (the spaces between the
   words)::

      #my_regexp->appendReplacement(#match)

#. After the ``while`` loop the `regexp->appendTail` method is used to append
   the unmatched end of the input string to the output (the period at the end of
   the example input)::

      #my_regexp->appendTail

#. Finally, the output string from the regular expression object is displayed::

      #my_regexp->output
      // => ehT kciuq nworb xof depmuj revo eht yzal god.

This same basic order of operation is used for any interactive find/replace
operation. The power of this methodology comes in the fourth step where the
replacement string can be generated using any code necessary, rather than
needing to be a simple replacement pattern.

.. member: regexp->find()
.. member:: regexp->find(position::integer= ?)

   Advances the regular expression one match in the input string. Returns "true"
   if the regular expression was able to find another match, otherwise returns
   "false". Defaults to checking from the start of the input string (or from the
   end of the most recent match), but you can optionally pass an integer
   parameter to set the position in the input string at which to start the
   search.

.. member: regexp->matchString()
.. member:: regexp->matchString(group::integer= ?)

   Returns a string containing the last pattern match. Optional integer
   parameter specifies a group from the find pattern to return (defaults to
   returning the entire pattern match).

.. member: regexp->matchPosition()
.. member:: regexp->matchPosition(group::integer= ?)

   Returns a pair containing the start position and length of the last pattern
   match. Optional integer parameter specifies a group from the find pattern to
   return (defaults to returning information about the entire pattern match).

.. member:: regexp->appendReplacement(pattern::string)

   Performs a replace operation on the current pattern match and appends the
   result onto the output string. Requires a single parameter specifying the
   replacement pattern including group placeholders ``$0``--``$9``.
   Automatically appends any unmatched runs from the input string.

.. member:: regexp->appendTail()

   The final step in an interactive find/replace operation. This method appends
   the final unmatched run from the input string into the output string.

.. member:: regexp->reset(-input= ?, -find= ?, -replace= ?, -ignoreCase= ?)

   Resets the object. If called with no parameters, the input string is set to
   the output string. Accepts optional ``-find``, ``-replace``, ``-input``, and
   ``-ignoreCase`` parameters.

.. member: regexp->matches()
.. member:: regexp->matches(position::integer= ?)

   Returns "true" if the pattern matches the entire input string. Optional
   integer parameter sets the position in the input string at which to start the
   search.

.. member: regexp->matchesStart()
.. member:: regexp->matchesStart(position::integer= ?)

   Returns "true" if the pattern matches a substring of the input string.
   Defaults to checking the start of the input string. Optional integer
   parameter sets the position in the input string at which to start the search.


Perform an Interactive Find/Replace Operation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This example searches for variable names with a dollar sign in an input string
and replaces them with variable values. An interactive find/replace operation is
used so that the existence of each variable can be checked dynamically as the
string is processed.

The string has several words replaced by variable references and each
replacement is defined with a replacement word in a map. ::

   local(my_string)    = 'The quick $color fox $verb over the lazy $animal.'
   local(replacements) = map(
      'color'  = "red",
      'verb'   = "soared",
      'animal' = "ocelot"
   )

A regular expression is initialized with the input string and a pattern that
looks for words beginning with a dollar sign. The word itself is defined as a
group within the find pattern. A ``while`` loop uses `regexp->find` to advance
through all the matches in the input string. The method `regexp->matchString`
with a parameter of "1" returns the map key for each match. If this key exists
then its value is substituted back into output string using
`regexp->appendReplacement`, otherwise, the full match is substituted back into
the output string with the replacement pattern ``$0``. Finally, any remaining
unmatched input string is appended to the end of the output string using
`regexp->appendTail`. ::

   local(my_regexp) = regexp(-find=`\$(\w+)`, -input=#my_string, -ignoreCase)
   while(#my_regexp->find) => {
      #my_regexp->appendReplacement(
         #replacements->find(#my_regexp->matchString(1)) or `$0`
      )
   }
   #my_regexp->appendTail

After the operation has completed the output string is displayed::

   #my_regexp->output
   // => The quick red fox soared over the lazy ocelot.


String Methods Taking Regular Expressions
=========================================

The `string_findRegExp` and `string_replaceRegExp` methods can be used to
perform regular expression find and replace routines on text strings.

.. method:: string_findRegExp(input, -find::string, -ignoreCase= ?)

   Takes two parameters: a string value and a ``-find`` keyword parameter.
   Returns an array with each instance of the ``-find`` regular expression in
   the string parameter. Optional ``-ignoreCase`` parameter uses
   case-insensitive patterns.

.. method:: string_replaceRegExp(\
      input, \
      -find::string, \
      -replace::string, \
      -ignoreCase= ?, \
      -replaceOnlyOne= ?)

   Takes three parameters: a string value, a ``-find`` keyword parameter, and a
   ``-replace`` keyword parameter. Returns an array with each instance of the
   ``-find`` regular expression replaced by the value of the ``-replace`` string
   parameter. Optional ``-ignoreCase`` parameter uses case-insensitive
   parameters. Optional ``-replaceOnlyOne`` parameter replaces only the first
   pattern match.


Matching Patterns Using string_findRegExp
-----------------------------------------

The `string_findRegExp` method returns an array of items that match the
specified regular expression within the string. The array contains the full
matched string in the first element, followed by each of the matched
subexpressions in subsequent elements.

In the following example, every email address in a string is returned in an
array::

   string_findRegExp(
      'Send email to address@example.com.',
      -find=`\w+@\w+\.\w+`
   )

   // => array(address@example.com)

In the following example, every email address in a string is returned in an
array and subexpressions are used to divide the username and domain name
portions of the email address. The result is an array with the entire match
string, then each of the subexpressions. ::

   string_findRegExp(
      'Send email to address@example.com.',
      -find=`(\w+)@(\w+\.\w+)`
   )

   // => array(address@example.com, address, example.com)

In the following example, every word in the source is returned in an array. The
first character of each word is separated as a subexpression. The returned array
contains 16 elements, one for each word in the source string and one for the
first character subexpression of each word in the source string. ::

   string_findRegExp(
      `The quick brown fox jumped over a lazy dog.`,
      -find=`(\w)\w*`
   )

   // => array(The, T, quick, q, brown, b, fox, f, jumped, j, over, o, a, a, lazy, l, dog, d)

The resulting array can be divided into two arrays using the following code.
This code loops through the array (stored in ``result_array``) and places the
odd elements in the array ``word_array`` and the even elements in the array
``char_array``. ::

   local(word_array, char_array) = (: array, array)
   local(result_array) = string_findRegExp(
      `The quick brown fox jumped over a lazy dog.`,
      -find=`(\w)\w*`
   )
   with key in #result_array->keys
   let value = #result_array->get(#key)
   do {
      if(#key % 2 == 0) => {
         #char_array->insert(#value)
      else
         #word_array->insert(#value)
      }
   }

   #word_array
   // => array(The, quick, brown, fox, jumped, over, a, lazy, dog)

   #char_array
   // => array(T, q, b, f, j, o, a, l, d)

In the following example, every phone number in a string is returned in an
array. The ``\d`` symbol is used to match individual digits and the ``{3}``
symbol is used to specify that three repetitions must be present. The
parentheses are escaped ``\(`` and ``\)`` so they aren't treated as grouping
characters. ::

   string_findRegExp(
      'Phone (800) 555-1212 for information.',
      -find=`\(\d{3}\) \d{3}-\d{4}`
   )

   // => array((800) 555-1212)

In the following example, only words contained between HTML bold tags are
returned. Positive lookahead and lookbehind assertions are used to find the
contents of the tags without the tags themselves. Note that the pattern inside
the assertions uses a non-greedy modifier. ::

   string_findRegExp(
      'This is some <b>sample text</b>!',
      -find=`(?<=<b>).+?(?=</b>)`
   )

   // => array(sample text)


Replacing Values Using string_replaceRegExp
-------------------------------------------

In the following example, every occurrence of the world "Blue" in the string is
replaced by the HTML code ``<span style="color: blue;">Blue</span>`` so that the
word "Blue" appears in blue on the web page. The ``-find`` parameter is
specified so either a lowercase or uppercase "b" will be matched. The
``-replace`` parameter references ``$1`` to insert the actual value matched into
the output. ::

   string_replaceRegExp(
      'Blue Lake sure is blue today.',
      -find=`([Bb]lue)`,
      -replace=`<span style="color: blue;">$1</span>`
   )

   // => <span style="color: blue;">Blue</span> Lake sure is <span style="color: blue;">blue</span> today.

In the following example, every email address is replaced by an HTML anchor tag
that links to the same email address. The ``\w`` symbol is used to match any
alphanumeric characters or underscores. The at sign (``@``) matches itself. The
period must be escaped (``\.``) in order to match an actual period and not just
any character. This pattern matches any email address of the format
:samp:`{name}@{example.com}`::

   string_replaceRegExp(
      'Send email to address@example.com.',
      -find=`(\w+@\w+\.\w+)`,
      -replace=`<a href="mailto:$1">$1</a>`
   )

   // => Send email to <a href="mailto:address@example.com">address@example.com</a>.

.. _ICU Regular Expressions package: http://userguide.icu-project.org/strings/regexp
.. _Unicode Standard Annex #29: http://www.unicode.org/reports/tr29/
