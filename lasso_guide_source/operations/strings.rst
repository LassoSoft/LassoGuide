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
vertical-tab.

Casting Values to Strings
=========================

Values can be cast to the string data type automatically in many situations or
they can be cast explicitly using the ``string`` creator method.

.. class:: string
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
output to a Web page or as part of an autocollect capture block. The value they
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