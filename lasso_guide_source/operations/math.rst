.. _math:

.. direct from book

****
Math
****

Numbers in Lasso are stored and manipulated using the decimal and
integer data types. This chapter details the symbols and tags that can
be used to manipulate decimal and integer values and to perform
mathematical operations.

-  `Overview`_ provides an introduction to the decimal and integer data
   types and how to cast values to and from other data types.
-  `Math Symbols`_ describes the symbols that can be used to create
   mathematical expressions.
-  `Decimal Member Tags`_ describes the member tags that can be used
   with the decimal data type.
-  `Integer Member Tags`_ describes the member tags that can be used
   with the integer data type.
-  `Math Tags`_ describes the substitution and process tags that can be
   used with numeric values.

Overview
========

Mathematical operations and number formatting can be performed in Lasso
using a variety of different methods on integer and decimal values.
There are three types of operations that can be performed:

-  `Symbols`_ can be used to perform mathematical calculations within
   Lasso tags or to perform assignment operations within LassoScripts.
-  `Member Tags`_ can be used to format decimal or integer values or to
   perform bit manipulations.
-  `Substitution Tags`_ can be used to perform advanced calculations.

Each of these methods is described in detail in the sections that
follow. This guide contains a description of every symbol and tag and
many examples of their use. The Lasso Reference is the primary
documentation source for Lasso symbols and tags. It contains a full
description of each symbol and tag including details about each
parameter.

Integer Data Type
-----------------

The integer data type represents whole number values. Basically, any
positive or negative number which does not contain a decimal point is an
integer value in Lasso. Examples include ``-123`` or ``456``. Integer
values may also contain hexadecimal values such as ``0x1A`` or ``0xff``.

Spaces must be specified between the ``+`` and ``-`` symbols and the
parameters, otherwise the second parameter of the symbol might be
mistaken for an integer literal.

.. _math-operations-table-1:

.. table:: Table 1: Integer Data Type

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``[Integer]``|Casts a value to type integer.                    |
    +-------------+--------------------------------------------------+

**Examples of explicit integer casting:**

-  Strings which contain numeric data can be cast to the integer data
   type using the ``[Integer]`` tag. The string must start with a
   numeric value. In the following examples the number ``123`` is the
   result of each explicit casting. Only the first integer found in the
   string ``123`` and then ``456`` is recognized.

   ::

       [Integer: '123'] -> 123
       [Integer: '123 and then 456'] -> 123

-  Decimals which are cast to the integer data type are rounded to the
   nearest integer.

   ::

       [Integer: 123.0] -> 123
       [Integer: 123.999] -> 124

Decimal Data Type
-----------------

The decimal data type represents real or floating point numbers.
Basically, any positive or negative number which contains a decimal
point is a decimal value in Lasso. Examples include ``-123.0`` and
``456.789``. Decimal values can also be written in exponential notation
as in ``1.23e2`` which is equivalent to ``1.23`` times ``102`` or
``123.0``.

Spaces must be specified between the ``+`` and ``-`` symbols and the
parameters, otherwise the second parameter of the symbol might be
mistaken for a decimal literal.

.. _math-operations-table-2:

.. table:: Table 2: Decimal Data Type

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``[Decimal]``|Casts a value to type decimal.                    |
    +-------------+--------------------------------------------------+

The precision of decimal numbers is always displayed as six decimal
places even though the actual precision of the number may vary based on
the size of the number and its internal representation. The output
precision of decimal numbers can be controlled using the
``[Decimal->Format]`` tag described later in this chapter.

**Examples of implicit decimal casting:**

-  Integer values are cast to decimal values automatically if they are
   used as a parameter to a mathematical symbol. If either of the
   parameters to the symbol is a decimal value then the other parameter
   is cast to a decimal value automatically. The following example shows
   how the integer ``123`` is automatically cast to a decimal value
   because the other parameter of the ``+`` symbol is the decimal value
   ``456.0``.

   ::

       [456.0 + 123] -> 579.0
        

   The following example shows how a variable with a value of ``123`` is
   automatically cast to a decimal value.

   ::

       [Variable: 'Number'=123]
       [456.0 + (Variable: 'Number')] -> 579.0

**Examples of explicit decimal casting:**

-  Strings which contain numeric data can be cast to the decimal data
   type using the ``[Decimal]`` tag. The string must start with a
   numeric value. In the following examples the number ``123.0`` is the
   result of each explicit casting. Only the first decimal value found
   in the string ``123`` and then ``456`` is recognized.

   ::

       [Decimal: '123'] -> 123.0
       [Decimal: '123.0'] -> 123.0
       [Decimal: '123 and then 456'] -> 123.0

-  Integers which are cast to the decimal data type simply have a
   decimal point appended. The value of the number does not change.

   ::

       [Decimal: 123] -> 123.0
        

Mathematical Symbols
====================

The easiest way to manipulate integer and decimal values is to use the
mathematical symbols. :ref:`Table 3: Mathematical Symbols
<math-operations-table-3>` details all the symbols that can be used with
integer and decimal values.

.. _math-operations-table-3:

.. table:: Table 3: Mathematical Symbols

    +------+--------------------------------------------------+
    |Symbol|Description                                       |
    +======+==================================================+
    |``+`` |Adds two numbers. This symbol should always be    |
    |      |separated from its parameters by a space.         |
    +------+--------------------------------------------------+
    |``-`` |Subtracts the right parameter from the left       |
    |      |parameter. This symbol should always be separated |
    |      |from its parameters by a space.                   |
    +------+--------------------------------------------------+
    |``*`` |Multiplies two numbers.                           |
    +------+--------------------------------------------------+
    |``/`` |Divides the left parameter by the right parameter.|
    +------+--------------------------------------------------+
    |``%`` |Modulus. Calculates the left parameter modulo the |
    |      |right number. Both parameters must be integers.   |
    +------+--------------------------------------------------+

Each of the mathematical symbols takes two parameters. If either of the
parameters is a decimal value then the result will be a decimal value.
Many of the symbols can also be used to perform string operations. If
either of the parameters is a string value then the string operation
defined by the symbol will be performed rather than the mathematical
operation.

.. Note:: Full documentation and examples for each of the mathematical
    symbols can be found in the Lasso Reference.

**Examples of using the mathematical symbols:**

-  Two numbers can be added using the ``+`` symbol. The output will be a
   decimal value if either of the parameters are a decimal value. Note
   that the symbol ``+`` is separated from its parameters by spaces and
   negative values used as the second parameter should be surrounded by
   parentheses.

   ::

       [100 + 50] -> 150
       [100 + (-12.5)] -> 87.5

-  The difference between numbers can be calculated using the ``-``
   symbol. The output will be a decimal value if either of the
   parameters are a decimal value.

   ::

       [100 - 50] -> 50
       [100 - (-12.5)] -> 112.5

-  Two numbers can be multiplied using the ``*`` symbol. The output will
   be a decimal value if either of the parameters are a decimal value.

   ::

       [100 * 50] -> 5000
       [100 * (-12.5)] -> -1250.0

.. _math-operations-table-4:

.. table:: Table 4: Mathematical Assignment Symbols

    +------+--------------------------------------------------+
    |Symbol|Description                                       |
    +======+==================================================+
    |``=`` |Assigns the right parameter to the variable       |
    |      |designated by the left parameter.                 |
    +------+--------------------------------------------------+
    |``+=``|Adds the right parameter to the value of the left |
    |      |parameter and assigns the result to the variable  |
    |      |designated by the left parameter.                 |
    +------+--------------------------------------------------+
    |``-=``|Subtracts the right parameter from the value of   |
    |      |the left parameter and assigns the result to the  |
    |      |variable designated by the left parameter.        |
    +------+--------------------------------------------------+
    |``*=``|Multiplies the value of the left parameter by the |
    |      |value of the right parameter and assigns the      |
    |      |result to the variable designated by the left     |
    |      |parameter.                                        |
    +------+--------------------------------------------------+
    |``/=``|Divides the value of the left parameter by the    |
    |      |value of the right parameter and assigns the      |
    |      |result to the variable designated by the left     |
    |      |parameter.                                        |
    +------+--------------------------------------------------+
    |``%=``|Modulus. Assigns the value of the left parameter  |
    |      |modulo the right parameter to the left            |
    |      |parameter. Both parameters must be integers.      |
    +------+--------------------------------------------------+

Each of the symbols takes two parameters. The first parameter must be a
variable that holds an integer or decimal value. The second parameter
can be any integer or decimal value. The result of the operation is
calculated and then stored back in the variable specified as the first
operator.

.. Note:: Full documentation and examples for each of the mathematical
    symbols can be found in the Lasso Reference.

**Examples of using the mathematical assignment symbols:**

-  A variable can be assigned a new value using the ``=`` symbol. The
   following example shows how to define an integer variable and then
   set it to a new value. The new value is output.

   ::

       <?LassoScript
           Variable: 'IntegerVariable'= 100;
           $IntegerVariable = 123456;
           $IntegerVariable;
       ?>
       
       -> 123456

-  A variable can be used as a collector by adding new values using
   the ``+=`` symbol. The following example shows how to define an
   integer variable and then add several values to it. The final value
   is output.

   ::

       <?LassoScript
           Variable: 'IntegerVariab'e= 0;
           $IntegerVariable += 123;
           $IntegerVariable += (-456);
           $IntegerVariable;
       ?>
       
       -> -333

.. _math-operations-table-5:

.. table:: Table 5: Mathematical Comparison Symbols

    +------+--------------------------------------------------+
    |Symbol|Description                                       |
    +======+==================================================+
    |``==``|Returns ``True`` if the parameters are equal.     |
    +------+--------------------------------------------------+
    |``!=``|Returns ``True`` if the parameters are not equal. |
    +------+--------------------------------------------------+
    |``<`` |Returns ``True`` if the left parameter is less    |
    |      |than the right parameter.                         |
    +------+--------------------------------------------------+
    |``<=``|Returns ``True`` if the left parameter is less    |
    |      |than or equal to the right parameter.             |
    +------+--------------------------------------------------+
    |``>`` |Returns ``True`` if the left parameter is greater |
    |      |than the right parameter.                         |
    +------+--------------------------------------------------+
    |``>=``|Returns ``True`` if the left parameter is greater |
    |      |than or equal to the right parameter.             |
    +------+--------------------------------------------------+

Each of the mathematical symbols takes two parameters. If either of the
parameters is a decimal value then the result will be a decimal value.
Many of the symbols can also be used to perform string operations. If
either of the parameters is a string value then the string operation
defined by the symbol will be performed rather than the mathematical
operation.

.. Note:: Full documentation and examples for each of the mathematical
    symbols can be found in the Lasso Reference.

**Examples of using the mathematical comparison symbols:**

-  Two numbers can be compared for equality using the ``==`` symbol and
   ``!=`` symbol. The result is a boolean ``True`` or ``False``.
   Integers are automatically cast to decimal values when compared.

   ::

       [100 == 123] -> False
       [100.0 != (-123.0)] -> True
       [100 ==100.0] -> True
       [100.0 != (-123)] -> False

-  Numbers can be ordered using the ``<``, ``<=``, ``>``, and ``<=``
   symbols. The result is a boolean ``True`` or ``False``.

   ::

       [-37 > 0] -> False
       [100 < 1000.0] -> True

Decimal Member Tags
===================

The decimal data type includes one member tag that can be used to format
decimal values.

.. _math-operations-table-6:

.. table:: Table 6: Decimal Member Tag

    +------------------------+--------------------------------------------------+
    |Tag                     |Description                                       |
    +========================+==================================================+
    |``[Decimal->SetFormat]``|Specifies the format in which the decimal value   |
    |                        |will be output when cast to string or displayed to|
    |                        |a visitor.                                        |
    +------------------------+--------------------------------------------------+

.. Note:: Full documentation and examples for this tag can be found in
    the Lasso Reference.

Decimal Format
--------------

The ``[Decimal->SetFormat]`` tag can be used to change the output format
of a variable. When the variable is next cast to data type string or
output to the Lasso page it will be formatted according to the
preferences set in the last call to ``[Decimal->SetFormat]`` for the
variable. If the ``[Decimal->SetFormat]`` tag is called with no
parameters it resets the formatting to the default. The tag takes the
following parameters.

.. _math-operations-table-7:

.. table:: Table 7: [Decimal->SetFormat] Parameters

    +----------------+--------------------------------------------------+
    |Keyword         |Description                                       |
    +================+==================================================+
    |``-Precision``  |The number of decimal points of precision that    |
    |                |should be output. Defaults to ``6``.              |
    +----------------+--------------------------------------------------+
    |``-DecimalChar``|The character which should be used for the decimal|
    |                |point. Defaults to a period.                      |
    +----------------+--------------------------------------------------+
    |``-GroupChar``  |The character which should be used for thousands  |
    |                |grouping. Defaults to empty.                      |
    +----------------+--------------------------------------------------+
    |``-Scientific`` |Set to ``True`` to force output in exponential    |
    |                |notation. Defaults to ``False`` so decimals are   |
    |                |only output in exponential notation if required.  |
    +----------------+--------------------------------------------------+
    |``-Padding``    |Specifies the desired length for the output. If   |
    |                |the formatted number is less than this length then|
    |                |the number is padded.                             |
    +----------------+--------------------------------------------------+
    |``-PadChar``    |Specifies the character that will be inserted if  |
    |                |padding is required. Defaults to a space.         |
    +----------------+--------------------------------------------------+
    |``-PadRight``   |Set to ``True`` to pad the right side of the      |
    |                |output. By default, padding is appended to the    |
    |                |left side of the output.                          |
    +----------------+--------------------------------------------------+

**To format a decimal number as US currency:**

Create a variable that will hold the dollar amount, ``DollarVariable``.
Use ``[Decimal->SetFormat]`` to set the ``-Precision`` to ``2`` and the
``-GroupChar`` to comma.

::

    [Variable: 'DollarVariable' = 0.0]
    [$DollarVariable->(SetFormat: -Precision=2, -GroupChar=',')]
    <br>$[$DollarVariable]

    [Variable: 'DollarVariable' = $DollarVariable + 1000]
    [$DollarVariable->(SetFormat: -Precision=2, -GroupChar=',')]
    <br>$[$DollarVariable]

    [Variable: 'DollarVariable' = $DollarVariable / 8]
    [$DollarVariable->(SetFormat: -Precision=2, -GroupChar=',')]
    <br>$[$DollarVariable]

    -> <br>$0.00
    <br>$1,000.00
    <br>$12.50

Integer Member Tags
===================

The integer data type includes many member tags that can be used to
format or perform bit operations on integer values. The available member
tags are listed in :ref:`Table 8: Integer Member Tags <math-operations-table-8>`.

.. _math-operations-table-8:

.. table:: Table 8: Integer Member Tags

    +----------------------------+--------------------------------------------------+
    |Tag                         |Description                                       |
    +============================+==================================================+
    |``[Integer->SetFormat]``    |Specifies the format in which the integer value   |
    |                            |will be output when cast to string or displayed to|
    |                            |a visitor.                                        |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitAnd]``       |Performs a bitwise And operation between each bit |
    |                            |in the base integer and the integer parameter.    |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitOr]``        |Performs a bitwise ``Or`` operation between each  |
    |                            |bit in the base integer and the integer parameter.|
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitXOr]``       |Performs a bitwise ``Exclusive-Or`` operation     |
    |                            |between each bit in the base integer and the      |
    |                            |integer parameter.                                |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitNot]``       |Flips every bit in the base integer.              |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitShiftLeft]`` |Shifts the bits in the base integer left by the   |
    |                            |number specified in the integer parameter.        |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitShiftRight]``|Shifts the bits in the base integer right by the  |
    |                            |number specified in the integer parameter.        |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitClear]``     |Clears the bit specified in the integer parameter.|
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitFlip]``      |Flips the bit specified in the integer parameter. |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitSet]``       |Sets the bit specified in the integer parameter.  |
    +----------------------------+--------------------------------------------------+
    |``[Integer->BitTest]``      |Returns ``true`` if the bit specified in the      |
    |                            |integer parameter is true.                        |
    +----------------------------+--------------------------------------------------+

.. Note:: Full documentation and examples for each of the integer member
    tags can be found in the Lasso Reference.

Integer Format
--------------

The ``[Integer->SetFormat]`` tag can be used to change the output format
of a variable. When the variable is next cast to data type string or
output to the Lasso page it will be formatted according to the
preferences set in the last call to ``[Integer->SetFormat]`` for the
variable. If the ``[Integer->SetFormat]`` tag is called with no
parameters it resets the formatting to the default. The tag takes the
following parameters.

.. _math-operations-table-9:

.. table:: Table 9: [Integer->SetFormat] Parameters

    +----------------+--------------------------------------------------+
    |Keyword         |Description                                       |
    +================+==================================================+
    |``-Hexadecimal``|If set to ``True``, the integer will output in    |
    |                |hexadecimal notation.                             |
    +----------------+--------------------------------------------------+
    |``-Padding``    |Specifies the desired length for the output. If   |
    |                |the formatted number is less than this length then|
    |                |the number is padded.                             |
    +----------------+--------------------------------------------------+
    |``-PadChar``    |Specifies the character that will be inserted if  |
    |                |padding is required. Defaults to a space.         |
    +----------------+--------------------------------------------------+
    |``-PadRight``   |Set to ``True`` to pad the right side of the      |
    |                |output. By default, padding is appended to the    |
    |                |left side of the output.                          |
    +----------------+--------------------------------------------------+

**To format an integer as a hexadecimal value:**

Create a variable that will hold the value, ``HexVariable``. Use
``[Integer->SetFormat]`` to set ``-Hexadecimal`` to ``True``.

::

    [Variable: 'HexVariable' = 255]
    [$HexVariable->(SetFormat: -Hexadecimal=True)]
    <br>[$HexVariable]

    [Variable: 'HexVariable' = $HexVariable / 5]
    [$HexVariable->(SetFormat: -Hexadecimal=True)]
    <br>[$HexVariable]

    -> <br>0xff
    <br>0x33

Bit Operations
--------------

Bit operations can be performed within Lasso’s 64-bit integer values.
These operations can be used to examine and manipulate binary data. They
can also be used for general purpose binary set operations.

Integer literals in Lasso can be specified using hexadecimal notation.
This can greatly aid in constructing literals for use with the bit
operation. For example, ``0xff`` is the integer literal ``255``. The
``[Integer->SetFormat]`` tag with a parameter of ``-Hexadecimal=True``
can be used to output hexadecimal values.

The bit operations are divided into three categories.

-  The ``[Integer->BitAnd]``, ``[Integer->BitOr]``, and
   ``[Integer->BitXOr]`` tags are used to combine two integer values
   using the specified boolean operation. In the following example the
   boolean ``Or`` of ``0x02`` and ``0x04`` is calculated and returned in
   hexadecimal notation.

   ::

       [Var: 'BitSet'=0x02]
       [$BitSet->(SetFormat: -Hexadecimal=True]
       [$BitSet->(BitOr: 0x04]
       [$BitSet]

       -> 0x06

-  The ``[Integer->BitShiftLeft]``, ``[Integer->BitShiftRight]``, and
   ``[Integer->BitNot]`` tags are used to modify the base integer value
   in place. In the following example, ``0x02`` is shifted left by three
   places and output in hexadecimal notation.

   ::

       [Var: 'BitSet'=0x02]
       [$BitSet->(SetFormat: -Hexadecimal=True]
       [$BitSet->(BitShift: 3]
       [$BitSet]

       -> 0x10

-  The ``[Integer->BitSet]``, ``[Integer->BitClear]``,
   ``[Integer->BitFlip]``, and ``[Integer->BitTest]`` tags are used to
   manipulate or test individual bits from an integer value. In the
   following example, the second bit an integer is set and then tested.

   ::

       [Var: 'BitSet'=0]
       [$BitSet->(BitSet: 2)]
       [$BitSet->(BitTest 2)]

       -> True

Math Tags
=========

Lasso contains many substitution tags that can be used to perform
mathematical functions. The functionality of many of these tags overlaps
the functionality of the mathematical symbols. It is recommended that
you use the equivalent symbol when one is available.

Additional tags detailed in the section on :ref:`Trigonometry and Advanced
Math <trigonometry-and-advanced-math>`.

.. _math-operations-table-10:

.. table:: Table 10: Math Tags

    +----------------------+--------------------------------------------------+
    |Tag                   |Description                                       |
    +======================+==================================================+
    |``[Math_Abs]``        |Absolute value. Requires one parameter.           |
    +----------------------+--------------------------------------------------+
    |``[Math_Add]``        |Addition. Returns sum of multiple parameters.     |
    +----------------------+--------------------------------------------------+
    |``[Math_Ceil]``       |Ceiling. Returns the next higher integer. Requires|
    |                      |one parameter.                                    |
    +----------------------+--------------------------------------------------+
    |``[Math_ConvertEuro]``|Converts between the Euro and other European Union|
    |                      |currencies.                                       |
    +----------------------+--------------------------------------------------+
    |``[Math_Div]``        |Division. Divides each of multiple parameters in  |
    |                      |order from left to right.                         |
    +----------------------+--------------------------------------------------+
    |``[Math_Floor]``      |Floor. Returns the next lower integer. Requires   |
    |                      |one parameter.                                    |
    +----------------------+--------------------------------------------------+
    |``[Math_Max]``        |Maximum of all parameters.                        |
    +----------------------+--------------------------------------------------+
    |``[Math_Min]``        |Minimum of all parameters.                        |
    +----------------------+--------------------------------------------------+
    |``[Math_Mod]``        |Modulo. Requires two parameters. Returns the value|
    |                      |of the first parameter modulo the second          |
    |                      |parameter.                                        |
    +----------------------+--------------------------------------------------+
    |``[Math_Mult]``       |Multiplication. Returns the value of multiple     |
    |                      |parameters multiplied together.                   |
    +----------------------+--------------------------------------------------+
    |``[Math_Random]``     |Returns a random number.                          |
    +----------------------+--------------------------------------------------+
    |``[Math_RInt]``       |Rounds to nearest integer. Requires one parameter |
    +----------------------+--------------------------------------------------+
    |``[Math_Roman]``      |Converts a number into roman numerals. Requires   |
    |                      |one positive integer parameter.                   |
    +----------------------+--------------------------------------------------+
    |``[Math_Round]``      |Rounds a number with specified precision. Requires|
    |                      |two parameters. The first value is rounded to the |
    |                      |same precision as the second value.               |
    +----------------------+--------------------------------------------------+
    |``[Math_Sub]``        |Subtraction. Subtracts each of multiple parameters|
    |                      |in order from left to right.                      |
    +----------------------+--------------------------------------------------+

.. Note:: Full documentation and examples for each of the math tags can
    be found in the Lasso Reference.

If all the parameters to a mathematical substitution tag are integers
then the result will be an integer. If any of the parameter to a
mathematical substitution tag is a decimal then the result will be a
decimal value and will be returned with six decimal points of precision.

In the following example the same calculation is performed with integer
and decimal parameters to show how the results vary. The integer example
returns ``0`` since ``0.125`` rounds down to zero when cast to an
integer.

::

    [Math_Div: 1, 8] -> 0
    [Math_Div: 1.0, 8] -> 0.125000

**Examples of using math substitution tags:**

The following are all examples of using math substitution tags to
calculate the results of various mathematical operations.

::

    [Math_Add: 1, 2, 3, 4, 5] -> 15
    [Math_Add: 1.0, 100.0] -> 101.0
    [Math_Sub: 10, 5] -> 5
    [Math_Div: 10, 9] -> 11
    [Math_Div: 10, 8.0] -> 12.5
    [Math_Max: 100, 200] -> 200

Rounding Numbers
----------------

Lasso provides a number of different methods for rounding numbers:

-  Numbers can be rounded to integer using the ``[Math_RInt]`` tag to
   round to the nearest integer, the ``[Math_Floor]`` tag to round to
   the next lowest integer, or the ``[Math_Ceil]`` tag to found to the
   next highest integer.

   ::

       [Math_RInt: 37.6] -> 38
       [Math_Floor: 37.6] -> 37
       [Math_Ceil: 37.6] -> 38

-  Numbers can be rounded to arbitrary precision using the
   ``[Math_Round]`` tag with a decimal parameter. The second parameter
   should be of the form ``0.01``, ``0.0001``, ``0.000001,`` etc.

   ::

       [Math_Round: 3.1415926, 0.0001] -> 3.1416
       [Math_Round: 3.1415926, 0.001] -> 3.142
       [Math_Round: 3.1415926, 0.01] -> 3.14
       [Math_Round: 3.1415926, 0.1] -> 3.1

-  Numbers can be rounded to an even multiple of another number using
   the ``[Math_Round]`` tag with an integer parameter. The integer
   parameter should be an even power of ``10``.

   ::

       [Math_Round: 1463, 1000] -> 1000
       [Math_Round: 1463, 100] -> 1500
       [Math_Round: 1463, 10] -> 1460

-  If a rounded result needs to be shown to the user, but the actual
   value stored in a variable does not need to be rounded then either
   the ``[Integer->SetFormat]`` or ``[Decimal->SetFormat]`` tags can be
   used to alter how the number is displayed. See the documentation of
   these tags earlier in the chapter for more information.

Random Numbers
--------------

The ``[Math_Random]`` tag can be used to return a random number in a
given range. The result can optionally be returned in hexadecimal
notation (for use in HTML color variables).

.. Note:: When returning integer values ``[Math_Random]`` will return a
    maximum 32-bit value. The range of returned integers is
    approximately between ``+/- 2,000,000,000``.

.. _math-operations-table-11:

.. table:: Table 11: [Math_Random] Parameters

    +--------+--------------------------------------------------+
    |Keyword |Description                                       |
    +========+==================================================+
    |``-Min``|Minimum value to be returned.                     |
    +--------+--------------------------------------------------+
    |``-Max``|Maximum value to be returned. For integer results |
    |        |should be one greater than maximum desired value. |
    +--------+--------------------------------------------------+
    |``-Hex``|If specified, returns the result in hexadecimal   |
    |        |notation.                                         |
    +--------+--------------------------------------------------+

**To return a random integer value:**

In the following example a random number between ``1`` and ``99`` is
returned. The random number will be different each time the page is
loaded.

::

    [Math_Random: -Min=1, -Max=100]

    -> 55 

**To return a random decimal value:**

In the following example a random decimal number between ``0.0`` and
``1.0`` is returned. The random number will be different each time the
page is loaded.

::

    [Math_Random: -Min=0.0, -Max=1.0]

    -> 0.55342

**To return a random color value:**

In the following example a random hexadecimal color code is returned.
The random number will be different each time the page is loaded. The
range is from ``16`` to ``256`` to return two-digit hexadecimal values
between ``10`` and ``FF``.

::

    <font color="#[Math_Random: -Min=16, -Max=256, -Hex][Math_Random: -Min=16, -Max=256, -Hex][Math_Random: -Min=16,
    -Max=256, -Hex]">Color</font>

    -> <font color="#1010FF">Color</font>

.. _trigonometry-and-advanced-math:

Trigonometry and Advanced Math
------------------------------

Lasso provides a number of tags for performing trigonometric functions,
square roots, logarighthms, and calculating exponents.

.. _math-operations-table-12:

.. table:: Table 12: Trigonmetric and Advanced Math Tags

    +----------------+--------------------------------------------------+
    |Tag             |Description                                       |
    +================+==================================================+
    |``[Math_ACos]`` |Arc Cosine. Requires one parameter. The return    |
    |                |value is in radians between ``0`` and ``π``.      |
    +----------------+--------------------------------------------------+
    |``[Math_ASin]`` |Arc Sine. Requires one parameter. The return value|
    |                |is in radians between ``-π/2`` and ``π/2``.       |
    +----------------+--------------------------------------------------+
    |``[Math_ATan]`` |Arc Tangent. Requires one parameter. The return   |
    |                |value is in radians between ``-π/2`` and ``π/2``. |
    +----------------+--------------------------------------------------+
    |``[Math_ATan2]``|Arc Tangent of a Quotient. Requires two           |
    |                |parameters. The return value is in radians between|
    |                |``-π`` and ``π``.                                 |
    +----------------+--------------------------------------------------+
    |``[Math_Cos]``  |Cosine. Requires one parameter.                   |
    +----------------+--------------------------------------------------+
    |``[Math_Exp]``  |Natural Exponent. Requires one parameter. Returns |
    |                |``e`` raised to the specified power.              |
    +----------------+--------------------------------------------------+
    |``[Math_Ln]``   |Natural Logarithm. Requires one parameter. Also   |
    |                |``[Math_Log]``.                                   |
    +----------------+--------------------------------------------------+
    |``[Math_Log10]``|Base 10 Logarithm. Requires one parameter.        |
    +----------------+--------------------------------------------------+
    |``[Math_Pow]``  |Exponent. Requires two parameters: a base and an  |
    |                |exponent. Returns the base raised to the exponent.|
    +----------------+--------------------------------------------------+
    |``[Math_Sin]``  |Sine. Requires one parameter.                     |
    +----------------+--------------------------------------------------+
    |``[Math_Sqrt]`` |Square Root. Requires one positive parameter.     |
    +----------------+--------------------------------------------------+
    |``[Math_Tan]``  |Tangent. Requires one parameter.                  |
    +----------------+--------------------------------------------------+

**Examples of using advanced math substitution tags:**

The following are all examples of using math substitution tags to
calculate the results of various mathematical operations.

::

    [Math_Pow: 3, 3] -> 27
    [Math_Sqrt: 100.0] -> 10.0

Locale Formatting
=================

Lasso can format currency, percentages, and scientific values according
to the rules of any country or locale. The tags in :ref:`Table 13:
Locale Formatting Tags <math-operations-table-13>` are used for this
purpose. Each tag accepts an optional language code and country code
which specifies the locale to use for the formatting.

The default language is ``en`` for English and country ``US`` for the
United States. A list of valid language and country codes can be found
linked from the ICU reference Web site:

`http://www.icu-project.org/userguide/locale.html <http://www.icu-project.org/userguide/locale.html>`_

.. _math-operations-table-13:

.. table:: Table 13: Locale Formatting Tags

    +-------------------+--------------------------------------------------+
    |Tag                |Description                                       |
    +===================+==================================================+
    |``[Currency]``     |Formats a number as currency. Requires one        |
    |                   |parameter, the currency amount to format. The     |
    |                   |second parameter specifies the language and the   |
    |                   |third paramter specifies the country for the      |
    |                   |desired locale.                                   |
    +-------------------+--------------------------------------------------+
    |``[Percent]``      |Formats a number as a percentage. Requires one    |
    |                   |parameter, the currency amount to format. The     |
    |                   |second parameter specifies the language and the   |
    |                   |third paramter specifies the country for the      |
    |                   |desired locale.                                   |
    +-------------------+--------------------------------------------------+
    |``[Scientific]``   |Formats a number using scientific                 |
    |                   |notation. Requires one parameter, the currency    |
    |                   |amount to format. The second parameter specifies  |
    |                   |the language and the third paramter specifies the |
    |                   |country for the desired locale.                   |
    +-------------------+--------------------------------------------------+
    |``[Locale_Format]``|Formats a number. Requires one parameter, the     |
    |                   |decimal amount to format. The second parameter    |
    |                   |specifies the language and the third paramter     |
    |                   |specifies the country for the desired locale.     |
    +-------------------+--------------------------------------------------+
