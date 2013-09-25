.. _strings:
.. http://www.lassosoft.com/Language-Guide-String-Operations

*******
Strings
*******

Text in Lasso is stored and manipulated using the ``string`` data type or the
``string_…`` methods. This chapter details the symbols and methods that can be
used to manipulate string values.

.. note::
   Information about regular expression can be found in the :ref:`Regular
   Expressions<regular-expressions>` chapter. The string type is often used in
   conjunction with the bytes type to convert binary data between different
   character encodings (UTF-8, ISO-8859-1). See the :ref:`Bytes<bytes>` chapter
   for more information about the bytes type.

Overview
========

Many Lasso methods are dedicated to outputting and manipulating text. Lasso is
used to format text-based HTML pages or XML data for output. Lasso is also used
to process and manipulate text-based HTML form inputs and URLs. Text processing
is a central function of Lasso.

As a result of this focus on text processing, the string data type is the
primary data type in Lasso. When necessary, all values are cast to string before
subsequent tag or symbol processing occurs. All values are cast to string before
they are output into the HTML page or XML data which will be served to the site
visitor.

There are three types of operations that can be performed directly on strings:

#. Symbols can be used to perform string calculations within Lasso methods or to
   perform assignment operations within Lasso code::

      'The' + ' ' + 'String'
      // => The String

#. String methods can be used to manipulate string values or to output portions
   of a string::

      'The String'->sub(5, 6)
      // => String

#. String methods can be used to test the attributes of strings or to modify
   string values::

      string_lowerCase('The String')
      // => the string

Each of these methods is described in detail in the sections that follow. This
guide contains a description and examples of using symbols and methods to
manipulate strings.

Unicode Characters
==================

Lasso 9 supports the processing of Unicode characters in all string methods. The
escape sequence "\\u…" can be used with 4, or 8 hexadecimal digits to embed a
Unicode character in a string. For example "\\u002F" reprsents a "/" character,
"\\u0020" represents a space, and "\\u0042" represents a capital letter "B". The
same type of escape sequence can be used to embed any Unicode character, e.g.
"\\u4E26" represents the Traditional Chinese character |4E26|.

.. |4E26| unicode:: U+4E26

Lasso also supports common escape sequences including "\\r" for a return
character, "\\n" for a new-line character, "\\r\\n" for a Windows return/new-
line, "\\f" for a form-feed character, "\\t" for a tab, and "\\v" for a
vertical-tab. See the :ref:`table of supported escape sequences
<table-supported-escape-sequences>` for the full list.

Casting Values to Strings
=========================

Values can be cast to the string data type automatically in many situations or
they can be cast explicitly using the ``string`` creator method.

.. method:: string(obj::any)
.. method:: string(obj::bytes, enc::string= ?)

   Casts a value to type string. Requires one value which is the data to be cast
   to a string. An optional second parameter can be used when casting byte
   streams to a string and specified what character set should be used to
   translate the byte stream (defaults to UTF-8).

Examples of Automatic String Casting
------------------------------------

Integer and decimal values are cast to strings automatically if they are used as
a parameter to a string symbol. If either of the parameters to the symbol is a
string then the other parameter is cast to a string automatically. The following
example shows how the integer 123 is automatically cast to a string because the
other parameter of the "+" symbol is the string "String"::

   'String ' + 123
   // => String 123

The following example shows how a variable that contains the integer 123 is
automatically cast to a string for the expression::

   local(number) = 123
   'String ' + #number + '\n' + #number->type
   // =>
   // String 123
   // integer

Array, map, and pair values are cast to strings automatically when they are
output to a Web page or as part of an auto-collect capture block. The value they
return is intended for the developer to be able to see the contents of the
complex data type and is not intended to be displayed to site visitors::

   array('One', 'Two', 'Three')
   // => array(One, Two, Three)

   map('Key1'='Value1', 'Key2'='Value2')
   // => map(Key1 = Value1, Key2 = Value2)

   pair('name'='value')
   // => (name = value)

The parameters sent to the ``string_…`` methods are automatically cast to
strings. The following example shows how to use the ``string_length`` method on
a numeric value from a field::

   field('age')
   // => 21

   string_length(field('age'))
   // => 2


Explicitly Cast a Value to a String Object
------------------------------------------

Integer and decimal values can be cast to ``string`` objects using the
``string`` creator method. The value of the new string is the same as the value
of the integer or decimal value when it is output using the ``->toString``
method without any parameters.

The following example shows a math calculation and the integer operation result
579. The next line shows the same calculation with string parameters and the
string symbol result 123456::

   123 + 456
   // => 579

   string(123) + string(456)
   // => 123456

Boolean values can also be cast to a string object using the ``string`` method.
The value will always either be "true" or "false". The following example shows a
conditional result cast to type string::

   string('dog' == 'cat')
   // => false

String member methods can be used on any value by first casting that value to a
string using the ``string`` creator method. The following example shows how to
use the ``string->size`` member method on a numeric value from a field by first
casting the field value to a string object::

   field('age')
   // => 21

   string(field('age'))->size
   // => 2

Byte streams can be cast to strings including the character set which should be
used to export the data in the byte stream. By default byte streams are assumed
to contain UTF-8 character data. For example, the following code would translate
a byte stream contained in a variable by interpreting it as "ISO-8859-1"
character data. This is analogous to using the ``bytes->exportString`` method
which is described in more detail in the chapter on Bytes::

   string(#myByteStream, 'iso-8859-1')


String Inspection Methods
=========================

The ``string`` type has many member methods that return information about the
value of the string object. Many of these metods are documented below.

.. type:: string
.. member:: string->length()
.. member:: string->size()

   Returns the number of characters in the string. The ``string->length`` method
   had been deprecated in favor of simply the ``string->size`` method.

.. member:: string->charName(p0::integer)
   
   This method takes a parameter that specifies the position of the character to
   inspect. It returns the Unicode name for the specified character.

.. member:: string->charType(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect. It returns the Unicode type for the specified character.

.. member:: string->digit(p0::integer, base::integer)

   This method takes a parameter that specifies the position of the character to
   inspect and a parameter that specifies the base or radix. If the specified
   character is a digit for the specified radix, then it returns the integer
   value for that digit. (Remember that when integers are cast as strings, they
   default to displaying in base 10.) The radix or base can be any from 1 to 36.

.. member:: string->sub(pos::integer)
.. member:: string->substring(start::integer)
.. member:: string->sub(p0::integer, p1::integer)
.. member:: string->substring(start::integer, end::integer),

   This method returns a portion of the string, the starting point is specfied
   by the fist parameter and the number of characters to return is specified by
   the second. If the second parameter is not specified, then all characters
   from the specified position to the end of the string are returned.

.. member:: string->integer()
.. member:: string->integer(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character if no position is specified. It
   returns the Unicode integer value of that character.

.. member:: string->charDigitValue(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect. If the specified character is a digit, then it will return an
   integer of the value of the digit. Otherwise it returns "-1".

.. member:: string->getNumericValue(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect. If the specified character is a digit, then it will return a decimal
   of the value of the digit. Otherwise it returns the decimal "-123456789.0".

.. member:: string->isAlnum()
.. member:: string->isAlnum(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   alphanumeric the method will return "true" otherwise it will return "false".

.. member:: string->isAlpha()
.. member:: string->isAlpha(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   alphabetic the method will return "true" otherwise it will return "false".

.. member:: string->isBase()
.. member:: string->isBase(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is a
   base Unicode character the method will return "true" otherwise it will return
   "false".

.. member:: string->isCntrl()
.. member:: string->isCntrl(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is a
   control character then the method will return "true" otherwise it will return
   "false".

.. member:: string->isDigit()
.. member:: string->isDigit(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is a
   base 10 digit then the method will return "true" otherwise it will return
   "false".

.. member:: string->isXDigit()
.. member:: string->isXDigit(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is a
   hexadecimal digit then the method will return "true" otherwise it will return
   "false".

.. member:: string->isLower()
.. member:: string->isLower(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   lowercase the method will return "true" otherwise it will return "false".

.. member:: string->isPrint()
.. member:: string->isPrint(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   printable the method will return "true" otherwise it will return "false".

.. member:: string->isSpace()
.. member:: string->isSpace(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   white space the method will return "true" otherwise it will return "false".

.. member:: string->isTitle()
.. member:: string->isTitle(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is in
   the Unicode category "Letter, Titlecase" then the method will return "true"
   otherwise it will return "false".

.. member:: string->isPunct()
.. member:: string->isPunct(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   punctuation the method will return "true" otherwise it will return "false".

.. member:: string->isGraph()
.. member:: string->isGraph(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   printable and not white space then the method will return "true" otherwise it
   will return "false".

.. member:: string->isBlank()
.. member:: string->isBlank(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is a
   space or tab the method will return "true" otherwise it will return "false".

.. member:: string->isUAlphabetic()
.. member:: string->isUAlphabetic(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character has
   the Unicode alphabetic property then the method will return "true" otherwise
   it will return "false".

.. member:: string->isULowercase()
.. member:: string->isULowercase(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character has
   the Unicode lowercase property then the method will return "true" otherwise
   it will return "false".

.. member:: string->isUpper()
.. member:: string->isUpper(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   uppercased the method will return "true" otherwise it will return "false".

.. member:: string->isUUppercase()
.. member:: string->isUUppercase(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character has
   the Unicode uppercase property then the method will return "true" otherwise
   it will return "false".

.. member:: string->isUWhiteSpace()
.. member:: string->isUWhiteSpace(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character has
   the Unicode white space property then the method will return "true" otherwise
   it will return "false".

.. member:: string->isWhitespace()
.. member:: string->isWhitespace(p0::integer)

   This method takes a parameter that specifies the position of the character to
   inspect, defaulting to the first character. If the specified character is
   white space the method will return "true" otherwise it will return "false".

.. member:: string->find(find::string, offset::integer, length::integer)
.. member:: string->find(find::string, offset::integer, -case::boolean= ?)
.. member:: string->find(find::string, offset::integer, length::integer, patOffset::integer, patLength::integer, case::boolean)
.. member:: string->find(find::string, -offset::integer= ?, -length::integer= ?, -patOffset::integer= ?, -patLength::integer= ?, -case::boolean= ?)

   This method takes a string parameter that specifies a pattern to search the
   string object for and returns the position in the string object where that
   pattern first begins or zero if the pattern can not be found.

   An optional ``-case`` parameter can be used to specify case-sensitive pattern
   matching. The ``-offset`` and ``-length`` parameters can be used to specify a
   portion of the string to look for the match with the former specifying the
   starting position to begin the search and the latter spcifying the number of
   characters to search. (If ``-length`` is not specified, the method will
   search to the end of the string.) The ``-patOffset`` and ``-patLength``
   parameters can be used to specify that only a portion of the pattern should
   be used for matching - they behave similarly for the pattern string as the
   ``-offset`` and ``-length`` parameters do for the base string.

.. member:: string->findLast(find::string, offset::integer= ?, -length::integer= ?, -patOffset::integer= ?, -patLength::integer= ?, -case::boolean= ?)

   This method is similar to ``string->find`` except that it returns the
   starting position of the last match found in the string object.

.. member:: string->contains(find, -case::boolean= ?)
.. member:: string->contains(find::regexp, -ignoreCase::boolean= ?)

   This method takes a parameter that specifies a string or regulare expression
   to match as part of the string object. It returns "true" if it finds a match,
   otherwise "false".

   By default, string matching is not case-sensitive unless the optional
   ``-case`` parameter is passed to the method while regular expression matching
   is case-sensitive unless the optional ``-ignoreCase`` parameter is passed to
   the method.

.. member:: string->get(position::integer)

   This method takes a parameter that specifies the position of the character to
   return.

.. member:: string->equals(find, case::boolean)
.. member:: string->equals(find, -case::boolean= ?)

   This method is similar to the ``==`` comparison operator. It returns true if
   the specified string is equivalent to the base string. This matching will not
   be case-sensitive unless passed the ``-case`` parameter.

.. member:: string->compare(find::string, -case::boolean= ?)
.. member:: string->compare(find::string, offset::integer, length::integer= ?, patOffset::integer= ?, patLength::integer= ?, -case::boolean= ?)

   This method takes a string pattern to compare with the string object and
   returns "0" if they are equal, "1" if the characters in the string are bitwise
   greater than the parameter, and "-1" if the characters in the string are
   bitwise less than the parameter. Comparisons are nto case-sensitive by
   default unless passed the optional ``-case`` parameter.

   Optionally, the comparisson can be made on smaller portions of the string
   object by passing an offset and length parameter and smaller portions of the
   pattern by passing an offset and length parameter for the patern.

.. member:: string->beginsWith(find, case::boolean)
.. member:: string->beginsWith(find::string, -case::boolean= ?)

   This method takes a parameter that specifies a string  to match the beginning
   of the string object. It returns "true" if it matches the beginning,
   otherwise "false".

   By default, string matching is not case-sensitive unless the optional
   ``-case`` parameter is passed to the method.

.. member:: string->endsWith(find, case::boolean)
.. member:: string->endsWith(find::string, -case::boolean= ?)

   This method takes a parameter that specifies a string  to match the end of
   the string object. It returns "true" if it matches the end, otherwise
   "false".

   By default, string matching is not case-sensitive unless the optional
   ``-case`` parameter is passed to the method.

.. member:: string->getPropertyValue(p0::integer, p1::integer)

   This method takes a parameter that specifies the position of the character to
   inspect and a second parameter that specifies a Unicode property. It returns
   the Unicode property value for the indicated character and property. Unicode
   properties are defined in the Unicode Character Database (UCD) and Unicode
   Technical Reports (UTR).

   Lasso defines many methods that return values for these Unicode property
   names. All of these values have the "UCHAR\_" prefix.

.. member:: string->hasBinaryProperty(p0::integer, p1::integer)

   This method takes a parameter that specifies the position of the character to
   inspect and a second parameter that specifies a Unicode property. It returns
   "true" if the specified character has the specified property, otherwise it
   returns "false".


Find the Length of a String
---------------------------

The following example returns the lenth of the string::

   'Ralph is a red rhinoceros'->size()

   // =>
   // 25


Check for Lowercase Characters
------------------------------

The following example inspects each character in a string and counts the number
of lowercase letters it contains::

   local(num_lcase) = 0
   local(my_string) = 'Ralph is a red rhinoceros'

   loop(#my_string->size) => {
      #my_string->isLower(loop_count)
         ? #num_lcase++
   }
   #num_lcase

   // =>
   // 20


Check the Beginning of a String
-------------------------------

The following example checks to see if a string begins with 'https:'. If so, it
displays "secure", otherwise it displays "insecure"::

   local(url) = "https://secure.example.com"
   #url->beginsWith("https:") ? "secure" | "insecure"

   // =>
   // secure


Find a Substring
----------------

This example uses the ``string->find`` method to find and output each position
in a string where there is an apostrophe::

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


Return a Specified Character
----------------------------

The following example uses ``string->get`` to return the last character in a
string::

   local(my_string) = "Ralph is a red rhinoceros"
   #my_string->get(#my_string->length)

   // =>
   // s


Extract a Substring
-------------------

The following example will pull the substring "red" out of the base string::

   local(my_string) = "Ralph is a red rhinoceros"
   #my_string->sub(12,3)

   // =>
   // red


String Manipulation Methods
===========================

The ``string`` type includes many member methods that can be used to modify or
manipulate a string object in place. These methods do not return a value but
modify the value of the string object. Many of these member methods are
documented below.

.. member:: string->append(p0::string)
.. member:: string->append(s)

   This method takes a single parameter that will be cast as a string and then
   concatenated on to the end of the string object. It modifies the string
   object in place, not returning any value.

.. member:: string->appendChar(p0::integer)

   This method takes an integer that is the Unicode integer value in base 10 of
   a character. This character is then concatenated on to the end of the string
   object. It modifies the string object in place, not returning any value.

.. member:: string->remove()
.. member:: string->remove(i::integer)
.. member:: string->remove(p0::integer, p1::integer)

   This method takes a parameter that specifies the position of the first
   character to remove, defaulting to the first character. A second parameter
   can specify the number of characters to remove and defaults to removing all
   the characters from the starting position. It modifies the string object in
   place, not returning any value.

.. member:: string->normalize()

   This method transforms a string object into its normailzed form. It modifies
   the string object in place, not returning any value. For more information on
   normalizing Unicode strings, see
   `<http://unicode.org/faq/normalization.html>`_ and
   `<http://www.unicode.org/reports/tr15/>`_

.. member:: string->foldCase()

   This method converts the characters in the string object to allow for case-
   insensitive comparisons. It modifies the string object in place, not
   returning any value.

.. member:: string->trim()

   This method removes any white space from the beginning and end of a string.
   It modifies the string object in place, not returning any value.

.. member:: string->reverse()

   This method changes the string object to the value of the base string in
   reverse order. It modifies the string object in place, not returning any
   value.

.. member:: string->toTitle(p0::integer)

   This method takes a parameter that specifies the position of the character to
   modify. That character is converted to title case if possible. It modifies
   the string object in place, not returning any value.

.. member:: string->toUpper(p0::integer)

   This method takes a parameter that specifies the position of the character to
   modify. That character is converted to uppercase if possible. It modifies the
   string object in place, not returning any value.

.. member:: string->toLower(p0::integer)

   This method takes a parameter that specifies the position of the character to
   modify. That character is converted to lowercase if possible. It modifies the
   string object in place, not returning any value.

.. member:: string->lowercase()

   This method changes every possible character in a string to lowercase. It
   modifies the string object in place, not returning any value.

.. member:: string->uppercase()

   This method changes every possible character in a string to uppercase. It
   modifies the string object in place, not returning any value.

.. member:: string->titlecase()
.. member:: string->titlecase(p0::string, p1::string)

   This method changes every possible word in a string to title case. It can
   optionally take a language code for the first parameter and a country code
   for the second to specify a locale to be used when completing this operation.
   It modifies the string object in place, not returning any value.

.. member:: string->padLeading(tosize::integer, with::string= ?)

   This method takes a parameter that specifies the length of the string. If the
   base string object is smaller in size, then it changes the string by
   prepending a character to the start of the string until the string is the
   specified size. The character used for prepending defaults to a space, but
   can be set as the optional second parameter. It modifies the string object in
   place, not returning any value.

.. member:: string->padTrailing(tosize::integer, with::string= ?)

   This method takes a parameter that specifies the length of the string. If the
   base string object is smaller in size, then it changes the string by
   appending a character to the start of the string until the string is the
   specified size. The character used for appending defaults to a space, but can
   be set as the optional second parameter. It modifies the string object in
   place, not returning any value.

.. member:: string->merge(where::integer, what::string, offset::integer= ?, length::integer= ?)

   This method merges a specified string into the base string. It requires the
   first parameter to specify the position in the base string for the merge to
   take place and a second parameter that specifies the string to merge into the
   base string. It modifies the string object in place, not returning any value.

   Optionally, a third parameter can specify the starting position of the passed
   string to be used in the merge and a fourth can specify the number of
   characters to after the offset to be merged from the passed string.

.. member:: string->removeLeading(find::string)
.. member:: string->removeLeading(find::regexp)

   This method takes either a string or a regular expression and removes all
   matches specified from the beginning of the string. It keeps removing until
   the beginning of the string no longer matches the specified parameter. It
   modifies the string object in place, not returning any value.

.. member:: string->removeTrailing(find::string)

   This method takes a string and removes all matches specified from the end of
   the string. It keeps removing until the end of the string no longer matches
   the specified parameter. It modifies the string object in place, not
   returning any value.

.. member:: string->replace(find::regexp, replace= ?, ignorecase= ?)
.. member:: string->replace(find::string, replace::string, -case::boolean= ?)

   This method takes either a string or a regular expression and replaces all
   matches specified from the string with the specified replacement. For regular
   expression matches, the replacement string can be specified for this method,
   or it will use the replacement string of the ``regexp`` object. It modifies
   the string object in place, not returning any value.

   When using a regular expression, the method defaults to a case-sensitive
   matching unless otherwise specified by the third parameter. When using a
   string for matching, the default is the reverse: it uses case-insensitive
   matcing unless otherwise specified by the third parameter.


Appending Data to a String
--------------------------

This example uses the ``string->append`` method to add a trailing slash to a
directory path if one does not already exist::

   local(dir_path) = '/var/lasso/home'

   if(not #dir_path->endsWith('/')) => {
      #dir_path->append('/')
   }
   #dir_path

   // =>
   // /var/lasso/home/


Remove White Space Around a String
----------------------------------

This example uses the ``string->trim`` method to remove white space from the
beginning and end of the string and then outputs the string::

   local(my_string) = "\n    Ralph the Ringed Rhino   \n\n"
   #my_string->trim()
   #my_string

   // =>
   // Ralph the Ringed Rhino

Ensure All Characters are Lowercase
-----------------------------------

This example takes a string and converts all the characters to lowercase. It
then outputs the changed string::

   local(my_string) = "Ralph the Ringed Rhino races red radishes in THE RINK."
   #my_string->lowercase()
   #my_string

   // =>
   // ralph the ringed rhino races red radishes in the rink.

Remove a Pattern From the End of a String
-----------------------------------------

This exmaple removes all the trailing commas from the string::

   local(my_string) = "First, Second, Fifth,,,"
   #my_string->removeTrailing(',')
   #my_string

   // =>
   // First, Second, Fifth


String Encoding Methods
=======================

.. member:: string->hash()

   This method returns a simple hash of the string object.

.. member:: string->unescape()

   This method returns a string with any escape sequences in the base string
   object replaced with their literal Unicode equivalents. This is the same
   escape process Lasso does for string literals.

.. member:: string->encodeHtml()
.. member:: string->encodeHtml(p0::boolean, p1::boolean)

   This method returns a string with any reserved, illegal, or extended ASCII
   characters in the base string object converted to their equivalent HTML
   entity. This replacement can be modified by passing two boolean parameters.
   If the first parameter is set to true, then line breaks are encoded. If the
   second parameter is set to true, then the following chracters are not
   encoded: " & ' < > (double quotation mark, ampersand, single quotation mark,
   less than or left angle bracket, and greater than or right angle bracket,
   respectively).

.. member:: string->decodeHtml()
   
   This method returns a string with any HTML entities in the base string object
   converted to their Unicode equivalent. This is the opposite of the
   ``string->encodehtml`` method.

.. member:: string->encodeXml()

   This method returns a string from the base string object with any reserved or
   illegal XML characters encoded into their equivalent XML entity.

.. member:: string->decodeXml()

   This method returns a string from the base string object with any XML
   entities converted to their Unicode equivalent. This is the opposite of the
   ``string->encodeXml`` method.

.. member:: string->encodeHtmlToXml()

   This method returns a string from the base string object with any HTML
   encoding converted to XML encoding.

.. member:: string->asBytes()
.. member:: string->asBytes(encoding::string)

   This method returns the value of the base string as a ``bytes`` object. By
   default, UTF-8 encoding is used for this conversion, but any encoding can be
   specified as a stirng to this method.

.. member:: string->encodesql92()

   This method returns the value of the base string with any illegal characters
   for SQL-92 compliant databases properly escaped. Not for use with MySQL.

.. member:: string->encodesql()

   This method returns the value of the base string with any illegal characters
   for MySQL data sources properly escaped.


Convert Escape Sequences
------------------------

The following example creates a string with escape sequences. In order to do
this, it must escape the backslash since string literals are automatically
unescaped. Because of this it outputs the string before calling
``string->unescape``::

   local(my_string) = "Chinese Character: \\u4E26"
   #my_string + "\n"
   #my_string->unescape

   // =>
   // Chinese Character: \u4E26
   // Chinese Character: 並


Encode HTML Entities
--------------------

The following example uses ``string->encodeHtml`` to return a string with the
special HTML entities encoded::

   local(my_string) = "<>&"
   #my_string->encodeHtml

   // =>
   // &lt;&gt;&amp;


Encode For Use in MySQL
-----------------------

The following example returns a string whose quotes have been encoded for use in
a MySQL SQL statement::
   
   local(my_string) = "Don't forget to encode"
   #my_string->encodesql()

   // =>
   // Don\'t forget to encode


String Iteration Methods
========================

.. member:: string->forEachCharacter()

   This method takes a capture block and executes that block once for every
   character in the base string. That character can be accessed in the capture
   block through the special local variable "#1".

.. member:: string->forEachWordBreak()

   This method takes a capture block and executes that block once for every word
   in the base string. That word can be accessed in the capture block through
   the special local variable "#1".

.. member:: string->forEachLineBreak()

   This method takes a capture block and executes that block once for every
   substring that would be generated by splitting the base string object on a
   line break. Every linebreak is recognized: "\\r", "\\n", and "\\r\\n". Each
   of the substrings can be accessed in the capture block through the special
   local variable "#1".

.. member:: string->forEachMatch(exp::regexp)
.. member:: string->forEachMatch(exp::string)

   This method takes a capture block and executes that block once for every
   specified match in the base string object. Matches can be specified with
   either a ``string`` or ``regexp`` object. That match can be accessed in the
   capture block through the special local variable "#1".

.. member:: string->eachCharacter()

   This method returns an ``eacher`` which can be used in conjuction with query
   expressions to inspect and perform complex operations on every character in
   the base string object.

.. member:: string->eachWordBreak()

   This method returns an ``eacher`` which can be used in conjuction with query
   expressions to inspect and perform complex operations on every word in
   the base string object.

.. member:: string->eachMatch(exp::regexp)
.. member:: string->eachMatch(exp::string)

   This method returns an ``eacher`` which can be used in conjuction with query
   expressions to inspect and perform complex operations on every specified
   match in the base string object. Matches can be specified as either
   ``string`` or ``regexp`` objects.


Iterate Over Lines
------------------

The following example takes a string with multiple lines and runs the lines of
the string together with slashes, storing the result in the variable
"quoted_poem". It removes the trailing slash at the end and then displays the
variable "quoted_poem" in quotes::

   local(quoted_poem) = ''
   #poem->forEachLineBreak => {
       #quoted_poem->append(#1 + '/')
   }
   #quoted_poem->removeTrailing('/')
   '"' + #quoted_poem + '"'

   // =>
   // "Our two souls therefore, which are one,/Though I must go, endure not yet/A breach, but an expansion,/Like gold to airy thinness beat."


Iterate Over Words
------------------

The following example takes a string and inspects each word using a query
expression. If the word starts with the letter "r" then it will transform it to
uppercase. The query expression selects each word allowing us to create a
staticarray of words::

   local(my_string) = "Ralph is a red rhinoceros."
   (
      with word in #my_string->eachWordBreak
      select (#word->beginsWith('r') ? #word->uppercase& | #word)
   )->asStaticArray

   // =>
   // staticarray(RALPH, is, a, RED, RHINOCEROS.)


Iterate Over a Specified Regular Expression Match
-------------------------------------------------

The following example uses ``string->eachMatch`` to find every vowel in a string
and the local variable "vowels" is used to count the number of each vowel in the
string::

   local(my_string) = "ralph is a red rhinoceros."
   local(vowels)    = map("a"=0, "e"=0, "i"=0, "o"=0, "u"=0)
   
   with letter in #my_string->eachMatch(regexp(`[aeiouAEIOU]`))
   do {
      #vowels->find(#letter)++
   }
   #vowels

   // =>
   // map(a = 2, e = 2, i = 2, o = 2, u = 0)


Miscellaneous String Methods
============================

.. member:: string->split(find::string)

   This method returns an array with elements created by breaking up the string
   on the specified string. If an empty string is specified, each element of the
   array is a single character of the string.

.. member:: string->values()

   This method returns an array, each element of which is one character of the
   string.

.. member:: string->keys()

   This method returns a ``generateSeries`` from 1 to the length of the string,
   or an empty ``generateSeries`` if the string is empty.


Split a String Into an Array
----------------------------

The following example creates an array by splitting a string on a comma::

   local(my_string) = "1,3,9,f,g"
   #my_string->split(',')

   // =>
   // array(1, 3, 9, f, g)