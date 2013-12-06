.. _math:

****
Math
****

Numbers in Lasso are stored and manipulated using the :type:`decimal` and
:type:`integer` types. This chapter details the operators and methods that can
be used to manipulate decimal and integer values and to perform mathematical
operations. Each of these methods is described in detail in the sections that
follow; however, the Lasso Reference is the primary documentation source for
Lasso operators and methods.


Creating Integer Objects
========================

The :type:`integer` type represents whole number values. Basically, zero and any
positive or negative number that does not contain a decimal point is an integer
value in Lasso. Examples include ``-123`` or ``456``. Integer objects may also
be expressed in hexadecimal notation such as ``0x1A`` or ``0xff``.

.. type:: integer
.. method:: integer()
.. method:: integer(obj::any)

   The creator method for integer converts any object to an integer. If the type
   for the object being converted does not easily represent an integer, then the
   integer zero will be returned.


Explicit Integer Conversion
---------------------------

Strings that contain numeric data can be converted to integer objects using the
`integer` creator method. The string must start with a numeric value. In the
following examples the integer ``123`` is the result of each explicit
conversion. Only the first integer found in the string ``'123 and then 456'`` is
recognized::

   integer('123')
   // => 123

   integer('123 and then 456')
   // => 123

Decimals that are converted to an integer are rounded to the nearest integer::

   integer(123.0)
   // => 123

   integer(123.999)
   // => 124


Formatting Integer Objects
==========================

Integer objects can be formatted for display using the `integer->asString`
method detailed below.

.. note::
   In Lasso 9, integers and decimals have no state, so they cannot carry around
   their formatting information. The `integer->asString` method in Lasso 9 is
   used to replace the functionality of Lasso 8's ``integer->setFormat`` method.

.. member:: integer->asString(p0::string, p1::string, p2::string)
.. member:: integer->asString(\
      -hexadecimal::boolean= ?, \
      -padding::integer= ?, \
      -padChar::string= ?, \
      -padRight::boolean= ?, \
      -groupChar::string= ?\
   )

   Returns a string representation of the integer value formatted as specified
   by the parameters passed to the method. If no parameters are passed to the
   method, the string will be the integer value output in base 10.

   :param boolean -hexadecimal:
      If set to "true", the integer will output in hexadecimal notation.
   :param integer -padding:
      Specifies the desired length for the output. If the formatted number is
      less than this length then the number is padded.
   :param string -padChar:
      Specifies the character to insert if padding is required. Defaults to a
      space.
   :param boolean -padRight:
      Set to "true" to pad the right side of the output. By default, padding is
      appended to the left side of the output.
   :param string -groupChar:
      Specifies the character to use for thousands grouping. Defaults to empty.


Format an Integer as a Hexadecimal Value
----------------------------------------

The following example will create a variable with an integer value and then
output that value in base 16::

   local(my_int) = 255
   #my_int->asString(-hexadecimal)

   // => 0xff


Integer Bitwise Methods
=======================

Bitwise operations can be performed with Lasso's integer objects. These
operations can be used to examine and manipulate binary data. They can also be
used for general purpose binary set operations.

Integer literals in Lasso can be specified using hexadecimal notation. This can
greatly aid in constructing literals for use with the bitwise operation. For
example, ``0xff`` is the integer literal ``255``.

.. member:: integer->bitAnd(p0::integer)

   Performs a bitwise "and" operation between each bit in the base integer and
   the integer parameter, returning the result.

.. member:: integer->bitOr(p0::integer)

   Performs a bitwise "or" operation between each bit in the base integer and
   the integer parameter, returning the result.

.. member:: integer->bitXOr(p0::integer)

   Performs a bitwise "exclusive or" operation between each bit in the base
   integer and the integer parameter, returning the result.

.. member:: integer->bitNot()

   Returns the result of flipping every bit in the base integer.

.. member:: integer->bitShiftLeft(p0::integer)

   Returns the result of shifting the bits in the base integer left by the
   number specified in the integer parameter.

.. member:: integer->bitShiftRight(p0::integer)

   Returns the result of shifting the bits in the base integer right by the
   number specified in the integer parameter.

.. member:: integer->bitClear(p0::integer)

   Returns the result of clearing the bit specified in the integer parameter.

.. member:: integer->bitFlip(p0::integer)

   Returns the result of flipping the bit specified in the integer parameter.

.. member:: integer->bitSet(p0::integer)

   Returns the result of setting the bit specified in the integer parameter.

.. member:: integer->bitTest(p0::integer)

   Returns "true" if the bit specified in the integer parameter is 1, otherwise
   returns "false".

.. note::
   In previous versions of Lasso, these bit methods modified the integer
   in-place. In Lasso 9, integers are by-value objects and are immutable, so it
   is not possible to change their value in-place.


Perform a Bitwise Or
--------------------

In the following example the boolean "or" of ``0x02`` and ``0x04`` is calculated
and returned in hexadecimal notation::

   local(bit_set) = 0x02
   #bit_set->bitOr(0x04)->asString(-hexadecimal)

   // => 0x6


Shift Bits to the Left
----------------------

In the following example, ``0x02`` is shifted left by three places and output in
hexadecimal notation::

   local(bit_set) = 0x02
   #bit_set = #bit_set->bitShiftLeft(3)
   #bit_set->asString(-hexadecimal)

   // => 0x10


Set and Test a Specified Bit
----------------------------

In the following example, the second bit of an integer is set and then tested::

   local(bit_set) = 0
   #bit_set = #bit_set->bitSet(2)
   #bit_set->bitTest(2)

   // => true


Creating Decimal Objects
========================

The :type:`decimal` type represents real or floating point numbers. Basically,
0.0 or any positive or negative number that contains a decimal point is a
decimal object in Lasso. Examples include ``-123.0`` and ``456.789``. Decimal
values can also be written in exponential notation such as ``1.23e2`` which is
equivalent to ``1.23`` times ``10^2`` or ``123.0``.

.. type:: decimal
.. method:: decimal()
.. method:: decimal(p0::integer)
.. method:: decimal(p0::decimal)
.. method:: decimal(p0::string)
.. method:: decimal(b::bytes)
.. method:: decimal(n::null)
.. method:: decimal(n::void)

   The creator methods for the :type:`decimal` type converts :type:`integer`,
   :type:`string`, :type:`bytes`, :type:`null`, and :type:`void` objects to a
   decimal value.

   The precision of a decimal value when converted to a string is always
   displayed as six decimal places even though the actual precision of the
   number may vary based on the size of the number and its internal
   representation. The output precision of decimal numbers can be controlled
   using the `decimal->asString` method described later in this chapter.


Implicit Decimal Conversion
---------------------------

Integer values are converted to decimal values automatically if they are used as
a parameter to an arithmetical operator in conjunction with a decimal value. The
following example shows how the integer ``123`` is automatically converted to a
decimal value because the other parameter of the ``+`` operator is the decimal
value ``456.0``::

   456.0 + 123
   // => 579.0

The following example shows how a variable with a value of "123" is
automatically converted to a decimal value::

   local(number) = 123
   456.0 + #number

   // => 579.0


Explicit Decimal Conversion
---------------------------

Strings containing numeric data can be converted to the :type:`decimal` type
using the `decimal` creator method. The string must start with a numeric value.
In the following examples the number ``123.0`` is the result of each explicit
conversion. Only the first decimal value found in the string ``'123 and then
456'`` is recognized::

   decimal('123')
   // => 123.0

   decimal('123.0')
   // => 123.0

   decimal('123 and then 456')
   // => 123.0

Integers that are converted to decimals simply have a decimal point appended.
The value of the number does not change. ::

   decimal(123)
   // => 123.0


Formatting Decimal Objects
==========================

Decimal objects can be formatted for display using the `decimal->asString`
method detailed below.

.. note::
   In Lasso 9, integers and decimals have no state, so they cannot carry around
   their formatting information. The `decimal->asString` method in Lasso 9 is
   used to replace the functionality of Lasso 8's ``decimal->setFormat`` method.

.. member:: decimal->asString(p0::string, p1::string, p2::string)
.. member:: decimal->asString(\
      -decimalChar::string= ?, \
      -groupChar::string= ?, \
      -precision::integer= ?, \
      -scientific::boolean= ?, \
      -padding::integer= ?, \
      -padChar::string= ?, \
      -padRight::boolean= ?\
   )

   Returns a string representation of the decimal value formatted as specified
   by the parameters passed to the method. If no parameters are passed to the
   method, the string will be the decimal value with six places of precision.

   :param string -decimalChar:
      The character that should be used for the decimal point. It defaults to a
      period.
   :param string -groupChar:
      The character that should be used for thousands grouping. Defaults to an
      empty string.
   :param integer -precision:
      The number of places after the decimal point that should be output. The
      default is 6.
   :param boolean -scientific:
      Set to "true" to force output in exponential notation. The default is
      "false", so decimals are only output in exponential notation if required.
   :param integer -padding:
      Specifies the desired length for the output. If the formatted number is
      less than this length then the number is padded.
   :param string -padChar:
      Specifies the character that will be inserted if padding is required.
      Defaults to a space.
   :param boolean -padRight:
      Set to "true" to pad the right side of the output. By default, padding is
      prepended to the left side of the output.


Format a Decimal Number as U.S. Currency
----------------------------------------

The following example outputs a decimal value as if it were U.S. currency by
setting the precision to "2". For readability, it also sets a comma as the
grouping character. ::

   local(dollar_amt) = 1234.56
   #dollar_amt->asString(-precision=2, -groupChar=',')

   // => 1,234.56


Arithmetical Operations
=======================

The easiest way to manipulate integer and decimal objects is to use arithmetical
operators. The sections below detail all the operators that can be used with
integer and decimal values. See the :ref:`operators` chapter for further
documentation of how these operators are used.


Basic Arithmetical Operators
----------------------------

Each basic operator takes two parameters, one to its left and the other to its
right. If either of the parameters is a decimal then the result will be a
decimal value. Some of the operators can also be used to perform string
operations. If either of the parameters is a string value then the string
operation defined by the operator will be performed rather than the arithmetical
operation.

.. tabularcolumns:: |l|l|L|

.. _math-operators:

.. table:: Arithmetical Operators

   ======== ============== =====================================================
   Operator Name           Description
   ======== ============== =====================================================
   ``+``    Addition       Adds two parameters.
   ``-``    Subtraction    Subtracts the right parameter from the left
                           parameter.
   ``*``    Multiplication Multiplies two parameters.
   ``/``    Division       Divides the left parameter by the right parameter.
   ``%``    Modulo         Produces the remainder of dividing the left parameter
                           by the right parameter.
   ======== ============== =====================================================


Using Arithmetical Operators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Two numbers can be added using the ``+`` operator. The output will be a decimal
value if either of the parameters are a decimal value. ::

   100 + 50
   // => 150

   100 + -12.5
   // => 87.500000

The difference between two numbers can be calculated using the ``-`` operator.
The output will be a decimal value if either of the parameters are a decimal
value. Note that in the second instance, when subtracting a negative number, the
two ``-`` operators must be separated by a space so as not to be confused with
the ``--`` operator. ::

   100 - 50
   // => 50

   100 - -12.5
   // => 112.500000

Two numbers can be multiplied using the ``*`` operator. The output will be a
decimal value if either of the parameters are a decimal value. ::

   100 * 50
   // => 5000

   100 * -12.5
   // => -1250.000000


Arithmetical Assignment Operators
---------------------------------

Each of the operators takes two parameters, one to its left and the other to its
right. The first parameter must be a variable that holds an integer, decimal, or
string. The second parameter can be an integer, decimal, or string literal. The
result of the operation is calculated and then stored back in the variable
specified as the left-hand parameter.

.. tabularcolumns:: |l|l|L|

.. _math-assignment-operators:

.. table:: Arithmetical Assignment Operators

   ======== =============== ====================================================
   Operator Name            Description
   ======== =============== ====================================================
   ``=``    Assign          Assigns the right parameter to the variable
                            designated by the left parameter.
   ``+=``   Add-assign      Adds the right parameter to the value of the left
                            parameter and assigns the result to the variable
                            designated by the left parameter.
   ``-=``   Subtract-assign Subtracts the right parameter from the value of the
                            left parameter and assigns the result to the
                            variable designated by the left parameter.
   ``*=``   Multiply-assign Multiplies the value of the left parameter by the
                            value of the right parameter and assigns the result
                            to the variable designated by the left parameter.
   ``/=``   Divide-assign   Divides the value of the left parameter by the value
                            of the right parameter and assigns the result to the
                            variable designated by the left parameter.
   ``%=``   Modulo-assign   Assigns the value of the left parameter modulo the
                            right parameter to the variable designated by the
                            left parameter.
   ======== =============== ====================================================


Using Arithmetical Assignment Operators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A variable can be assigned a new value using the assignment operator (``=``).
The following example shows how to define an integer variable and then set it to
a new value, which is then output::

   local(my_variable) = 100
   #my_variable = 123456
   #my_variable

   // => 123456

A variable can be used as a collector by adding new values using the ``+=``
operator. The following example shows how to define an integer variable and then
add several values to it, then output the final value::

   local(my_variable) = 100
   #my_variable += 123
   #my_variable += -456
   #my_variable

   // => -233


Arithmetical Equality Operators
-------------------------------

Each of the arithmetical equality operators takes two parameters, one on its
left and one on its right.

.. tabularcolumns:: |l|l|L|

.. _math-equality-operators:

.. table:: Arithmetical Equality Operators

   ======== ================ ===================================================
   Operator Name             Description
   ======== ================ ===================================================
   ``==``   Equal            Returns "true" if the parameters are equal.
   ``!=``   Not equal        Returns "true" if the parameters are not equal.
   ``<``    Less             Returns "true" if the left parameter is less than
                             the right parameter.
   ``<=``   Less or equal    Returns "true" if the left parameter is less than
                             or equal to the right parameter.
   ``>``    Greater          Returns "true" if the left parameter is greater
                             than the right parameter.
   ``>=``   Greater or equal Returns "true" if the left parameter is greater
                             than or equal to the right parameter.
   ======== ================ ===================================================


Using Arithmetical Equality Operators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Two numbers can be compared for equality using the equality (``==``) and
inequality (``!=``) operators. The result is a boolean "true" or "false".
Integers are automatically converted to decimal values when compared with
decimals. ::

   100 == 123
   // => false

   100.0 != -123.0
   // => true

   100 == 100.0
   // => true

   100.0 != -123
   // => true

Numbers can be compared using the relative equality operators (``<``, ``<=``,
``>``, ``>=``). The result is a boolean "true" or "false". ::

   -37 > 0
   // => false

   100 < 1000.0
   // => true


Basic Math Methods
==================

Lasso contains many methods that can be used to perform mathematical functions.
The functionality of some of these methods overlaps the functionality of the
mathematical operators. It is recommended that you use the equivalent operator
when one is available.

.. method:: math_abs(value)

   Returns the absolute value of the parameter.

.. method:: math_add(value, ...)

   Returns the sum of all parameters.

.. method:: math_ceil(value)

   Returns the next integer greater than the parameter.

.. method:: math_convertEuro(value, euroTo::string)

   Converts between the Euro and other European Union currencies.

.. method:: math_div(value, ...)

   Divides each of the parameters in order from left to right.

.. method:: math_floor(value)

   Returns the next integer less than the parameter.

.. method:: math_max(value, ...)

   Returns the maximum of all parameters.

.. method:: math_min(value, ...)

   Returns the minimum of all parameters.

.. method:: math_mod(value, factor)

   Returns the value of the first parameter modulo the second parameter.

.. method:: math_mult(value, ...)

   Returns the product of multiplying each of the parameters together.

.. method:: math_random()::decimal
.. method:: math_random(upper::integer, lower=0)::integer
.. method:: math_random(upper::decimal, lower=0.0)::decimal
.. method:: math_random(-upper, -lower)::integer

   If called with no parameters, returns a random number between 0.0 and 1.0.
   This method can also take two parameters, with the first as the upper bound
   for the random number, and the second as the lower bound. If the first
   parameter is an integer, an integer will be returned, and if it is a decimal,
   then a decimal will be returned.

   This method can also be called with ``-upper`` and ``-lower`` keyword
   parameters and will then return an integer value regardless of the types of
   the objects passed as parameters.

   When returning integer values `math_random` will return a maximum 32-bit
   value. The range of returned integers is approximately between
   +/- 2,000,000,000.

.. method:: math_rint(value)

   Returns a decimal value rounded to the nearest integer.

.. method:: math_roman(value)

   Returns a string representing the number passed in as a Roman numeral.

.. method:: math_round(value, factor)

   Rounds the first parameter to the precision specified by the second
   parameter.


Using Basic Math Methods
------------------------

The following are all examples of using basic math methods to calculate the
results of various mathematical operations::

   math_add(1, 2, 3, 4, 5)
   // => 15

   math_add(1.0, 100.0)
   // => 101.000000

   math_sub(10, 5)
   // => 5

   math_div(10, 9)
   // => 1

   math_div(10, 8.0)
   // => 1.250000

   math_max(100, 200)
   // => 200


Round to an Integer
-------------------

Decimals can be rounded to an integer using the `integer` creator method, the
`math_floor` method to round to the next lowest integer, or the `math_ceil`
method to round to the next highest integer::

   integer(37.6)
   // => 38

   math_floor(37.6)
   // => 37

   math_ceil(37.6)
   // => 38


Round to Nearest Integer
------------------------

Decimals can be rounded to the nearest integer using the `math_rint` method.
This method rounds the decimal, but does not convert it to an integer::

   math_rint(37.6)
   // => 38.000000


Round to a Specified Precision
------------------------------

Numbers can be rounded to arbitrary precision using the `math_round` method with
a decimal parameter. The second parameter should be of the form ``0.01``,
``0.0001``, ``0.000001``, etc. ::

   math_round(3.1415926, 0.0001)
   // => 3.141600

   math_round(3.1415926, 0.001)
   // => 3.142000

   math_round(3.1415926, 0.01)
   // => 3.140000

   math_round(3.1415926, 0.1)
   // => 3.100000

Numbers can be rounded to an even multiple of another number using the
`math_round` method with an integer parameter. The integer parameter should be a
power of 10. ::

   math_round(1463, 1000)
   // => 1000.000000

   math_round(1463, 100)
   // => 1500.000000

   math_round(1463, 10)
   // => 1460.000000

.. note::
   If a rounded result needs to be shown to the user but the actual value stored
   in a variable does not need to be rounded, then either the
   `integer->asString` or `decimal->asString` method can be used to alter how
   the number is displayed. See the documentation of these methods earlier in
   the chapter for more information.


Return a Random Integer Value
-----------------------------

In the following example a random number between ``1`` and ``100`` is returned.
The random number will be different each time the page is loaded. ::

   math_random(100, 1)
   // => 55


Return a Random Decimal Value
-----------------------------

In the following example a random decimal number between ``0.0`` and ``1.0`` is
returned. The random number will be different each time the page is loaded. ::

   math_random(1.0, 0.0)
   // => 0.532773


Return a Random Hex Color Value
-------------------------------

In the following example a random hexadecimal color code is returned. The random
number will be different each time the page is loaded. The range is from ``0``
to ``255`` to return two-digit hexadecimal values between ``00`` and ``FF``. ::

   [local(color) = "#" +
      math_random(255,0)->asString(-hexadecimal, -padding=2, -padChar="0") +
      math_random(255,0)->asString(-hexadecimal, -padding=2, -padChar="0") +
      math_random(255,0)->asString(-hexadecimal, -padding=2, -padChar="0")
   ]
   <span style="color: [#color];">Color</span>

   <!--
   // => <span style="color: #e64b32;">Color</span>
   -->


Trigonometry and Advanced Math Methods
======================================

Lasso provides a number of methods for calculating square roots, logarithms, and
exponents, and performing trigonometric functions.

.. method:: math_acos(value)

   Arc Cosine. Returns the value of taking the arc cosine of the passed
   parameter. The return value is in radians between "0" and "π".

.. method:: math_asin(value)

   Arc Sine. Returns the value of taking the arc sine of the passed parameter.
   The return value is in radians between "-π/2" and "π/2".

.. method:: math_atan(value)

   Arc Tangent. Returns the value of taking the arc tangent of the passed
   parameter. The return value is in radians between "-π/2" and "π/2".

.. method:: math_atan2(value, factor)

   Arc Tangent of a Quotient. Returns the value of taking the angle in radians
   between the x-axis and coordinates passed to it. The return value is in
   radians between "-π" and "π".

.. method:: math_cos(value)

   Cosine. Returns the value of taking the cosine of the passed parameter.

.. method:: math_sin(value)

   Sine. Returns the value of taking the sine of the passed parameter.

.. method:: math_tan(value)

   Tangent. Returns the value of taking the tangent of the passed parameter.

.. method:: math_exp(value)

   Natural Exponent. Returns the value of taking *e* raised to the specified
   power.

.. method:: math_ln(value)
.. method:: math_log(value)

   Natural Logarithm. Returns the value of taking the natural log of the passed
   parameter.

.. method:: math_log10(value)

   Base 10 Logarithm. Returns the value of taking the base 10 log of the passed
   parameter.

.. method:: math_pow(value, factor)

   Exponent. Returns the value of taking the first parameter and raising it to
   the value of the second parameter.

.. method:: math_sqrt(value)

   Square Root. Returns the positive square root of the passed parameter. The
   parameter passed to this method must be positive.


Using Advanced Math Methods
---------------------------

The following are examples of using some of these advanced math methods to
calculate various mathematical operations::

   math_pow(3, 3)
   // => 27

   math_sqrt(100.0)
   // => 10.000000

   math_acos(-1.0)
   // => 3.141593

   math_exp(math_log(5))
   // => 5.000000
