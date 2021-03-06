.. http://www.lassosoft.com/Language-Guide-String-Operations
.. _strings:

*******
Strings
*******

Text in Lasso is stored and manipulated using the :type:`string` type or the
``string_…`` methods. This chapter details the operators and methods that can
manipulate string values.

.. tip::
   The :type:`string` type is often used in conjunction with the :type:`bytes`
   type to convert binary data between different character encodings, such as
   UTF-8 and ISO-8859-1. See the :ref:`byte-streams` chapter for more
   information about the :type:`bytes` type.


String Objects
==============

Text processing is a central function of Lasso. Many Lasso methods are dedicated
to outputting and manipulating text. Lasso is used to format text-based HTML
pages or XML data for output. Lasso is also used to process and manipulate
text-based HTML form inputs and URLs.

Because of this focus on text processing, the :type:`string` type is the primary
type of data in Lasso. The result of all expressions are converted to strings
before they are output into the HTML page or XML data being served.

The following are operations that can be performed directly on strings:

#. Operators can be used to perform string calculations::

      'The' + ' ' + 'String'
      // => The String

#. String member methods can manipulate the current string value::

      'the string'->titlecase&;
      // => The String

#. String member methods can return new strings based on the value of the
   current string::

      'The String'->sub(5, 6)
      // => String

#. String member methods can test the attributes of strings::

      'The String'->contains('the')
      // => true

Each of these methods is described in detail in the sections that follow. This
chapter contains a description and examples of using operators and methods to
manipulate strings.


Unicode Characters
------------------

Lasso supports the processing of Unicode characters in all :type:`string`
methods. The escape sequence ``\u…`` can be used with 4 hexadecimal digits (or
``\U…`` with 8 or ``\x…`` with 2) to specify a Unicode character in a string by
its code point, e.g. ``\u002F`` represents a "/" character, ``\U00000020``
represents a space, and ``\x42`` represents a capital letter "B". These types of
escape sequences can be used for any code point, e.g. ``\u4E26`` represents
the Traditional Chinese character |4E26|.

.. |4E26| unicode:: U+4E26

Lasso also supports common escape sequences including ``"\r"`` for a return
character, ``"\n"`` for a newline character, ``"\r\n"`` for a Windows
return/newline, ``"\f"`` for a form-feed character, ``"\t"`` for a tab, and
``"\v"`` for a vertical-tab. See the table :ref:`literals-string-escape` for the
full list.


Converting Values to Strings
============================

Expressions that produce a value will convert that value to the :type:`string`
type automatically, or they can be explicitly converted using the `string`
creator method as well as the ``asString`` member method every object has.

.. method:: string(obj::any)
.. method:: string(obj::bytes, enc::string= ?)

   Converts a value to type :type:`string`. Requires one value which is the data
   to be converted. An optional second parameter can be used when converting
   byte streams in order to specify which character set should be used to
   translate the byte stream to a string, defaulting to "UTF-8".


Automatic String Conversion
---------------------------

Integer and decimal values are converted to strings automatically if they are
used as a parameter to a string operator. If either of the parameters to the
operator is a string then the other parameter is converted to a string
automatically. The following example shows how the integer ``123`` is
automatically converted to a string because the other parameter of the ``+``
operator is the string ``'String'``::

   'String ' + 123
   // => String 123

The following example shows how a variable that contains the integer ``123`` is
automatically converted to a string for the expression::

   local(number) = 123
   'String ' + #number + '\n' + #number->type

   // =>
   // String 123
   // integer

Array, map, and pair values are converted to strings automatically when they are
output to a web page or included as part of an auto-collect block. The value
they return is intended for the developer to be able to see the contents of the
complex type and is not intended to be displayed to site visitors. ::

   array('One', 'Two', 'Three')
   // => array(One, Two, Three)

   map('Key1'="Value1", 'Key2'="Value2")
   // => map(Key1 = Value1, Key2 = Value2)

   pair('name'='value')
   // => (name = value)

The parameters sent to the ``string_…`` methods are automatically converted to
strings. The following example shows the result of calling `string_length` on an
integer::

   string_length(21)
   // => 2


Explicitly Convert a Value to a String Object
---------------------------------------------

Integer and decimal values can be converted to string objects using the `string`
creator method. The value of the new string is the same as the value of the
integer or decimal value when it is output using the `~null->toString` method.

The following example shows a math calculation where the integer result ``579``.
The next line shows the same calculation with string parameters and the result
of ``123456``. ::

   123 + 456
   // => 579

   string(123) + string(456)
   // => 123456

Boolean values can also be converted to a string object using the `string`
creator method. The value will always be either the string "true" or the string
"false". The following example shows a conditional result converted to type
:type:`string`::

   string('dog' == 'cat')
   // => false

String member methods can be used on any value by first converting that value to
a string using either the `string` creator method or the ``asString`` member
method every object has. The following example shows how to use the
`string->size` member method on an integer by first converting it to a string
object::

   21->asString->size
   // => 2

   string(21)->size
   // => 2

Byte streams being converted to strings can include the character set to be used
to export the data in the byte stream. By default byte streams are assumed to
contain UTF-8 character data. The following example code would translate a byte
stream contained in a variable named "myByteStream" using the ISO-8859-1
encoding to interpret the character data. This is analogous to using the
`bytes->exportString` method which is described in more detail in the
:ref:`byte-streams` chapter::

   string(#myByteStream, 'ISO-8859-1')


String Inspection Methods
=========================

The :type:`string` type has many member methods that return information about
the value of the string object, which are documented below. (Information about
regular expressions and the :type:`regexp` type is found in the
:ref:`regular-expressions` chapter.)

.. type:: string

.. member:: string->size()

   Returns the number of characters in the string.

.. member:: string->length()

   .. deprecated:: 9.0
      Use `string->size` instead.

.. member: string->sub(pos::integer)
.. member:: string->sub(position::integer, size::integer= ?)
.. member: string->substring(start::integer)
.. member:: string->substring(start::integer, size::integer= ?)

   Returns a portion of the string. The starting point is specified by the first
   parameter and the number of characters to return is specified by the second.
   If the second parameter is not specified, all characters from the specified
   starting position to the end of the string are returned.

.. member:: string->charName(position::integer)
.. member:: string->charType(position::integer)

   Returns the Unicode name or type for a character in the string. Requires a
   parameter specifying the position of the character to inspect.

.. member: string->integer()
.. member:: string->integer(position::integer= ?)

   Returns the Unicode integer value for a character in the string. Requires a
   parameter specifying the position of the character to inspect, defaulting to
   the first character.

.. member:: string->digit(position::integer, base::integer)

   Returns the integer value of a character in the string. Requires a parameter
   specifying the position of the character to inspect and a parameter
   specifying the base or radix. If the specified character is a digit for the
   specified radix, it will return the integer value for that digit, otherwise
   it returns "-1". (Remember that when integers are converted to strings, they
   default to displaying in base 10.) The radix or base can be any value from
   "2" to "36".

.. member:: string->charDigitValue(position::integer)::integer

   Returns the integer value of a character in the string. Requires a parameter
   specifying the position of the character to inspect. If the specified
   character is not a digit, it will return "-1".

.. member:: string->getNumericValue(position::integer)::decimal

   Returns the decimal value of a character in the string. Requires a parameter
   specifying the position of the character to inspect. If the specified
   character is not a digit, it will return the decimal "-123456789.0".

.. member: string->isAlnum()
.. member:: string->isAlnum(position::integer= ?)

   Returns "true" if the character at the specified position is alphanumeric,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isAlpha()
.. member:: string->isAlpha(position::integer= ?)

   Returns "true" if the character at the specified position is alphabetic,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isUAlphabetic()
.. member:: string->isUAlphabetic(position::integer= ?)

   Returns "true" if the character at the specified position has the Unicode
   alphabetic property, defaulting to the first character. Otherwise it will
   return "false".

.. member: string->isBase()
.. member:: string->isBase(position::integer= ?)

   Returns "true" if the character at the specified position is a base Unicode
   character, defaulting to the first character. Otherwise it will return
   "false".

.. member: string->isBlank()
.. member:: string->isBlank(position::integer= ?)

   Returns "true" if the character at the specified position is a space or tab,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isCntrl()
.. member:: string->isCntrl(position::integer= ?)

   Returns "true" if the character at the specified position is a control
   character, defaulting to the first character. Otherwise it will return
   "false".

.. member: string->isDigit()
.. member:: string->isDigit(position::integer= ?)

   Returns "true" if the character at the specified position is a base 10 digit,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isXDigit()
.. member:: string->isXDigit(position::integer= ?)

   Returns "true" if the character at the specified position is a hexadecimal
   digit, defaulting to the first character. Otherwise it will return "false".

.. member: string->isGraph()
.. member:: string->isGraph(position::integer= ?)

   Returns "true" if the character at the specified position is printable and
   not whitespace, defaulting to the first character. Otherwise it will return
   "false".

.. member: string->isLower()
.. member:: string->isLower(position::integer= ?)

   Returns "true" if the character at the specified position is lowercase,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isULowercase()
.. member:: string->isULowercase(position::integer= ?)

   Returns "true" if the character at the specified position has the Unicode
   lowercase property, defaulting to the first character. Otherwise it will
   return "false".

.. member: string->isPrint()
.. member:: string->isPrint(position::integer= ?)

   Returns "true" if the character at the specified position is printable,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isPunct()
.. member:: string->isPunct(position::integer= ?)

   Returns "true" if the character at the specified position is punctuation,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isSpace()
.. member:: string->isSpace(position::integer= ?)

   Returns "true" if the character at the specified position is whitespace,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isTitle()
.. member:: string->isTitle(position::integer= ?)

   Returns "true" if the character at the specified position is in the Unicode
   category "Letter, Titlecase", defaulting to the first character. Otherwise it
   will return "false".

.. member: string->isUpper()
.. member:: string->isUpper(position::integer= ?)

   Returns "true" if the character at the specified position is uppercase,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isUUppercase()
.. member:: string->isUUppercase(position::integer= ?)

   Returns "true" if the character at the specified position has the Unicode
   uppercase property, defaulting to the first character. Otherwise it will
   return "false".

.. member: string->isWhitespace()
.. member:: string->isWhitespace(position::integer= ?)

   Returns "true" if the character at the specified position is whitespace,
   defaulting to the first character. Otherwise it will return "false".

.. member: string->isUWhitespace()
.. member:: string->isUWhitespace(position::integer= ?)

   Returns "true" if the character at the specified position has the Unicode
   whitespace property, defaulting to the first character. Otherwise it will
   return "false".

.. member:: string->find(find::string, offset::integer, -case::boolean= ?)
.. member:: string->find(find::string, offset::integer, length::integer)
.. member:: string->find(find::string, offset::integer, length::integer, \
      patOffset::integer, patLength::integer, case::boolean)
.. member:: string->find(find::string, \
      -offset::integer= ?, \
      -length::integer= ?, \
      -patOffset::integer= ?, \
      -patLength::integer= ?, \
      -case::boolean= ?)

   Searches the base string for the specified string pattern, returning the
   position where the pattern first begins in the base string or "0" if the
   pattern cannot be found. The comparison is not case-sensitive unless the
   ``-case`` parameter is passed.

   The ``-offset`` and ``-length`` parameters can specify a portion of the base
   string within which to look for the match, with the former specifying the
   position to begin the search and the latter specifying the number of
   characters to search. (If ``-length`` is not specified, the method will
   search to the end of the base string.) The ``-patOffset`` and ``-patLength``
   parameters can specify that only a portion of the pattern should be used for
   matching; they behave similarly for the string pattern as the ``-offset`` and
   ``-length`` parameters do for the base string.

.. member:: string->findLast(find::string, \
      offset::integer= ?, \
      -length::integer= ?, \
      -patOffset::integer= ?, \
      -patLength::integer= ?, \
      -case::boolean= ?)

   Similar to `string->find` except that it returns the starting position of the
   *last* match found in the base string.

.. member:: string->contains(find::string, -case::boolean= ?)
.. member:: string->contains(find::regexp, -ignoreCase::boolean= ?)

   Returns "true" if the specified string pattern or regular expression matches
   within the base string. Otherwise it will return "false".

   By default, string matching is not case-sensitive unless an optional
   ``-case`` parameter is passed to the method, but regular expression matching
   is case-sensitive unless an optional ``-ignoreCase`` parameter is passed to
   the method.

.. member:: string->get(position::integer)

   Returns the character at the specified position in the base string.

.. member:: string->equals(find::string, case::boolean)
.. member:: string->equals(find::string, -case::boolean= ?)

   Similar to the ``==`` equality operator. Returns "true" if the specified
   string pattern is equivalent to the base string. The comparison is not
   case-sensitive unless the ``-case`` parameter is passed.

.. member:: string->compare(find::string, -case::boolean= ?)
.. member:: string->compare(find::string, offset::integer, \
      length::integer= ?, \
      patOffset::integer= ?, \
      patLength::integer= ?, \
      -case::boolean= ?)

   Compares the specified string pattern to the base string and returns "0" if
   they are equal, "1" if the characters in the base string are bitwise greater
   than the parameter, and "-1" if the characters in the base string are bitwise
   less than the parameter. The comparison is not case-sensitive unless the
   ``-case`` parameter is passed.

   Optionally, the comparison can be made on smaller portions of the base string
   by passing the ``offset`` and ``length`` parameters, and smaller portions of
   the string pattern by passing the ``patOffset`` and ``patLength`` parameters.

.. member:: string->beginsWith(find::string, case::boolean)
.. member:: string->beginsWith(find::string, -case::boolean= ?)

   Returns "true" if the specified string pattern matches the beginning of the
   base string, otherwise it will return "false". The comparison is not
   case-sensitive unless the ``-case`` parameter is passed.

.. member:: string->endsWith(find::string, case::boolean)
.. member:: string->endsWith(find::string, -case::boolean= ?)

   Returns "true" if the specified string pattern matches the end of the base
   string, otherwise it will return "false". The comparison is not
   case-sensitive unless the ``-case`` parameter is passed.

.. member:: string->getPropertyValue(position::integer, property::integer)::integer

   Returns the Unicode property value for the character at the position
   specified in the first parameter and the Unicode property specified in the
   second parameter. Unicode properties are defined in the `Unicode Character
   Database`_ (UCD) and `Unicode Technical Reports`_ (UTR).

   Lasso defines many methods that return values for these Unicode property
   names, corresponding to this `list of properties`_ in the ICU sources. All of
   these methods have the ``UCHAR_`` prefix, e.g. `UCHAR_UPPERCASE`.

.. member:: string->hasBinaryProperty(position::integer, property::integer)::boolean

   Returns "true" if the character at the position specified in the first
   parameter has the Unicode property specified in the second parameter,
   otherwise it returns "false".


Find the Size of a String
-------------------------

The following example returns the number of characters in a string::

   'Ralph is a red rhinoceros'->size
   // => 25


Check for Lowercase Characters
------------------------------

The following example inspects each character in a string and counts the number
of lowercase letters it contains::

   local(num_lcase) = 0
   local(my_string) = 'Ralph is a red rhinoceros'

   loop(#my_string->size) => {
      #my_string->isLower(loop_count) ? #num_lcase++
   }
   #num_lcase

   // => 20


Check the Beginning of a String
-------------------------------

The following example checks to see if a string begins with "https:". If so, it
displays "secure", otherwise it displays "insecure"::

   local(url) = 'https://secure.example.com'
   #url->beginsWith('https:') ? 'secure' | 'insecure'

   // => secure


Find a Substring
----------------

This example uses the `string->find` method to find and output each position in
a string where there is an apostrophe::

   local(my_string) = "Don't, it's not worth it!"
   local(position)  = 0

   while(#position < #my_string->size) => {^
      #position = #my_string->find(`'`, #position + 1)
      if(0 == #position) => {
         loop_abort
      }
      #position + '\n'
   ^}

   // =>
   // 4
   // 10


Extract a Substring
-------------------

The following example pulls the substring "red" out of the base string::

   local(my_string) = 'Ralph is a red rhinoceros'
   #my_string->sub(12, 3)

   // => red


Extract a Specified Character Position
--------------------------------------

The following example uses `string->get` to return the last character in a
string::

   local(my_string) = 'Ralph is a red rhinoceros'
   #my_string->get(#my_string->size)

   // => s


String Manipulation Methods
===========================

The :type:`string` type includes many member methods that can modify or
manipulate a string object in-place, which are documented below. These methods
do not return a value, and instead modify the value of the string object.

.. member:: string->append(s::string)
.. member:: string->append(obj::any)

   Concatenates a single parameter to the end of the base string, after
   converting it to a string if necessary. It modifies the string object
   in-place, not returning any value.

.. member:: string->appendChar(i::integer)

   Concatenates a single character to the end of the base string, specified by
   its Unicode integer value in base 10. It modifies the string object in-place,
   not returning any value.

.. member: string->remove()
.. member: string->remove(position::integer= ?)
.. member: string->remove(position::integer, num::integer)
.. member:: string->remove(position::integer= ?, num::integer= ?)

   Removes one or more characters from the base string starting at the specified
   position, defaulting to the first character. A second parameter can specify
   the number of characters to remove, defaulting to removing all the characters
   from the starting position. It modifies the string object in-place, not
   returning any value.

.. member:: string->normalize()
.. member:: string->decompose()

   Transforms the string into either its normalized or decomposed form. It
   modifies the string object in-place, not returning any value. For more
   information on normalizing Unicode strings, see the `Unicode Normalization
   FAQ`_ and `Unicode Standard Annex #15`_.

.. member:: string->foldCase()

   Converts the characters in the string to allow for case-insensitive
   comparisons. It modifies the string object in-place, not returning any value.

.. member:: string->trim()

   Removes any whitespace from the beginning and end of the string. It modifies
   the string object in-place, not returning any value.

.. member:: string->reverse()

   Changes the string object to the value of the base string in reverse order.
   It modifies the string object in-place, not returning any value.

.. member:: string->toLower(position::integer)

   Changes the character at the specified position to lowercase if possible. It
   modifies the string object in-place, not returning any value.

.. member:: string->toUpper(position::integer)

   Changes the character at the specified position to uppercase if possible. It
   modifies the string object in-place, not returning any value.

.. member:: string->toTitle(position::integer)

   Changes the character at the specified position to title case if possible. It
   modifies the string object in-place, not returning any value.

.. member:: string->lowercase()

   Changes every possible character in the string to lowercase. It modifies the
   string object in-place, not returning any value.

.. member:: string->uppercase()

   Changes every possible character in the string to uppercase. It modifies the
   string object in-place, not returning any value.

.. member:: string->titlecase()
.. member:: string->titlecase(language::string, country::string)

   Changes every possible word in the string to title case. It can be called
   with a language code for the first parameter and a country code for the
   second to specify a locale to be used when performing this operation. It
   modifies the string object in-place, not returning any value.

.. member:: string->padLeading(tosize::integer, with::string= ?)

   If the base string is smaller in size than the first parameter specifying the
   target size of the string, it changes the base string by prepending a
   character to its beginning until it reaches the specified size. The character
   used for prepending defaults to a space, but can be set with an optional
   second parameter. It modifies the string object in-place, not returning any
   value.

.. member:: string->padTrailing(tosize::integer, with::string= ?)

   If the base string is smaller in size than the first parameter specifying the
   target size of the string, it changes the base string by appending a
   character to its end until it reaches the specified size. The character used
   for appending defaults to a space, but can be set with an optional second
   parameter. It modifies the string object in-place, not returning any value.

.. member:: string->removeLeading(find::string)
.. member:: string->removeLeading(find::regexp)

   Removes all substrings that match the string pattern or regular expression
   specified in the parameter from the beginning of the base string. It keeps
   removing until the beginning of the base string no longer matches the
   specified pattern. It modifies the string object in-place, not returning any
   value.

.. member:: string->removeTrailing(find::string)

   Removes all substrings that match the string pattern specified in the
   parameter from the end of the base string. It keeps removing until the end of
   the string no longer matches the specified pattern. It modifies the string
   object in-place, not returning any value.

.. member:: string->merge(where::integer, what::string, offset::integer= ?, length::integer= ?)

   Merges a specified string into the base string. It requires the first
   parameter to specify the position in the base string for the merge to take
   place and a second parameter specifying the string to merge into the base
   string. It modifies the string object in-place, not returning any value.

   Optionally, a third parameter can specify the starting position of the passed
   string to be used in the merge and a fourth can specify the number of
   characters after the offset to be merged from the passed string.

.. member:: string->replace(find::string, replace::string, -case::boolean= ?)
.. member:: string->replace(find::regexp, replace= ?, ignoreCase= ?)

   Replaces all substrings found in the base string that match the string
   pattern or regular expression specified in the first parameter with the
   replacement string specified in the second parameter. For regular expression
   matches, the replacement string can optionally be specified as a separate
   parameter, or it will use the replacement string of the :type:`regexp`
   object. It modifies the string object in-place, not returning any value.

   When using a string pattern for matching, the method defaults to
   case-insensitive matching unless otherwise specified by the third parameter.
   When using a regular expression, the default is the reverse: it uses
   case-sensitive matching unless otherwise specified by the third parameter.


Append Data to a String
-----------------------

This example uses the `string->append` method to add a trailing slash to a
directory path if one does not already exist::

   local(dir_path) = '/var/lasso/home'

   if(not #dir_path->endsWith('/')) => {
      #dir_path->append('/')
   }
   #dir_path

   // => /var/lasso/home/


Remove Whitespace Around a String
---------------------------------

This example uses the `string->trim` method to remove whitespace from the
beginning and end of a string::

   local(my_string) = '\n    Ralph the Ringed Rhino   \n\n'
   #my_string->trim
   #my_string

   // => Ralph the Ringed Rhino


Ensure All Characters are Lowercase
-----------------------------------

This example converts all the characters in a string to lowercase::

   local(my_string) = 'Ralph the Ringed Rhino races red radishes in THE RINK.'
   #my_string->lowercase
   #my_string

   // => ralph the ringed rhino races red radishes in the rink.


Remove a Pattern from the End of a String
-----------------------------------------

This example removes all the trailing commas from a string::

   local(my_string) = 'First, Second, Fifth,,,'
   #my_string->removeTrailing(',')
   #my_string

   // => First, Second, Fifth


String Encoding Methods
=======================

.. member:: string->hash()

   Returns a simple hash of the string object.

.. member:: string->unescape()

   Returns the value of the string object with any escape sequences (a sequence
   beginning with a backslash) replaced with their literal Unicode equivalents.
   This is the same escape process used by Lasso for non-ticked string literals.

.. member:: string->encodeHtml()
.. member:: string->encodeHtml(linebreaks::boolean, ignorechars::boolean)

   Returns the value of the string object with any reserved, illegal, or
   extended ASCII characters converted to their equivalent HTML entity.

   This replacement can be modified by passing two boolean parameters. If the
   first parameter is set to "true", line breaks are encoded. If the second
   parameter is set to "true", the following characters are not encoded: ``" & '
   < >`` (double quotation mark, ampersand, single quotation mark, less than or
   left angle bracket, and greater than or right angle bracket, respectively).

.. member:: string->decodeHtml()

   Returns the value of the string object with any HTML entities converted to
   their Unicode equivalent. This is the opposite of the `string->encodeHtml`
   method.

.. member:: string->encodeXml()

   Returns the value of the string object with any reserved or illegal XML
   characters encoded into their equivalent XML entity.

.. member:: string->decodeXml()

   Returns the value of the string object with any XML entities converted to
   their Unicode equivalent. This is the opposite of the `string->encodeXml`
   method.

.. member:: string->encodeHtmlToXml()

   Returns the value of the string object with any HTML character entity
   references converted to their equivalent numeric character reference.

.. member: string->asBytes()
.. member:: string->asBytes(encoding::string= ?)

   Returns the value of the string object as a bytes object. By default, UTF-8
   encoding is used for this conversion, but any encoding can be specified as a
   string parameter to this method.

.. member:: string->encodeSql()

   Returns the value of the string object with any illegal characters for MySQL
   data sources properly escaped.

.. member:: string->encodeSql92()

   Returns the value of the string object with any illegal characters for
   SQL-92--compliant data sources properly escaped. Not for use with MySQL.

.. member:: string->encodeUrl()::bytes

   Returns a byte stream of the string object with any illegal characters for
   URLs properly escaped. See `bytes->encodeUrl`.


Convert Escape Sequences
------------------------

The following example creates a string with escape sequences using a ticked
string literal so that Lasso won't automatically unescape them. It then outputs
the string before calling `string->unescape` and then shows the result of
calling `string->unescape`::

   local(my_string) = `Chinese Character: \u4E26`
   #my_string + '\n'
   #my_string->unescape

   // =>
   // Chinese Character: \u4E26
   // Chinese Character: 並


Encode HTML Entities
--------------------

The following example uses `string->encodeHtml` to return a string with the HTML
reserved characters encoded as entities::

   local(my_string) = '<>&'
   #my_string->encodeHtml

   // => &lt;&gt;&amp;


Encode for Use in MySQL
-----------------------

The following example returns a string whose quotes have been encoded for use in
a MySQL SQL statement::

   local(my_string) = "Don't forget to encode"
   #my_string->encodeSql

   // => Don\'t forget to encode


String Iteration Methods
========================

.. member:: string->forEachCharacter()

   Executes a given capture block once for every character in the base string.
   The character can be accessed in the capture block through the special local
   variable ``#1``.

.. member:: string->forEachWordBreak()

   Executes a given capture block once for every word in the base string. The
   word can be accessed in the capture block through the special local variable
   ``#1``.

.. member:: string->forEachLineBreak()

   Executes a given capture block once for every substring that would be
   generated by splitting the base string on a line break. Every line break
   character is recognized: ``"\r"``, ``"\n"``, and ``"\r\n"``. Each of the
   substrings can be accessed in the capture block through the special local
   variable ``#1``.

.. member:: string->forEachMatch(exp::string)
.. member:: string->forEachMatch(exp::regexp)

   Executes a given capture block once for every match in the base string.
   Matches can be specified as either :type:`string` or
   :type:`regexp` objects. The match can be accessed in the capture block
   through the special local variable ``#1``.

.. member:: string->eachCharacter()

   Returns an ``eacher`` that can be used in conjunction with query expressions
   to inspect and perform complex operations on every character in the base
   string.

.. member:: string->eachWordBreak()

   Returns an ``eacher`` that can be used in conjunction with query expressions
   to inspect and perform complex operations on every word in the base string.

.. member:: string->eachLineBreak()

   Returns an ``eacher`` that can be used in conjunction with query expressions
   to inspect and perform complex operations on every line in the base string.

.. member:: string->eachMatch(exp::string)
.. member:: string->eachMatch(exp::regexp)

   Returns an ``eacher`` that can be used in conjunction with query expressions
   to inspect and perform complex operations on every specified match in the
   base string. Matches can be specified as either :type:`string` or
   :type:`regexp` objects.


Iterate Over Lines
------------------

The following example takes a string with multiple lines and runs the lines of
the string together with slashes, storing the result in the variable
"quoted_poem". It removes the trailing slash at the end and then displays the
variable "quoted_poem" in quotes. ::

   local(poem) = '\
   An old silent pond...
   A frog jumps into the pond,
   Splash! Silence again.'

   local(quoted_poem) = ''
   #poem->forEachLineBreak => {
      #quoted_poem->append(#1 + '/')
   }
   #quoted_poem->removeTrailing('/')
   '"' + #quoted_poem + '"'

   // => "An old silent pond.../A frog jumps into the pond,/Splash! Silence again."


Iterate Over Words
------------------

The following example takes a string and inspects each word using a query
expression. If the word starts with the letter "r" then it will transform it to
uppercase. The query expression selects each word, allowing us to create a
staticarray of words. ::

   local(my_string) = 'Ralph is a red rhinoceros.'
   (
      with word in #my_string->eachWordBreak
      select (#word->beginsWith('r') ? #word->uppercase& | #word)
   )->asStaticArray

   // => staticarray(RALPH, is, a, RED, RHINOCEROS.)


Iterate Over a Specified Regular Expression Match
-------------------------------------------------

The following example uses `string->eachMatch` with a :type:`regexp` object to
find every vowel in a string, where the local variable "vowels" is used to count
the number of each vowel in the string. ::

   local(my_string) = 'ralph is a red rhinoceros.'
   local(vowels)    = map('a'=0, 'e'=0, 'i'=0, 'o'=0, 'u'=0)

   with letter in #my_string->eachMatch(regexp(`[aeiouAEIOU]`))
   do #vowels->find(#letter)++
   #vowels

   // => map(a = 2, e = 2, i = 2, o = 2, u = 0)


String Export Methods
=====================

.. member:: string->split(find::string)

   Returns an array with elements created by breaking up the base string on the
   specified string. If an empty string is specified, each element of the array
   will be a single character from the base string.

.. member:: string->values()

   Returns an array where each element is one character from the base string.

.. member:: string->keys()

   Returns a :type:`generateSeries` from 1 to the number of characters in the
   base string, or an empty :type:`generateSeries` if the base string is empty.


Split a String Into an Array
----------------------------

The following example creates an array by splitting a string on a comma::

   local(my_string) = '1,3,9,f,g'
   #my_string->split(',')

   // => array(1, 3, 9, f, g)

.. _Unicode Character Database: http://www.unicode.org/ucd/
.. _Unicode Technical Reports: http://www.unicode.org/reports/
.. _list of properties: http://icu-project.org/apiref/icu4c-latest/uchar_8h.html#enum-members
.. _Unicode Normalization FAQ: http://www.unicode.org/faq/normalization.html
.. _Unicode Standard Annex #15: http://www.unicode.org/reports/tr15/
