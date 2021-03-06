.. http://www.lassosoft.com/Language-Guide-Conditional-Logic
.. _control-flow:

************
Control Flow
************

Control Flow makes a program tick. With it, sections of code can be skipped
or repeated multiple times. Code can be executed in every repetition of a loop
or every several repetitions. Complex decision trees can be created that execute
code only under very specific conditions. Lasso supports a variety of constructs
for performing conditional logic.


Conditional Constructs
======================

Lasso offers two types of conditional constructs, one for general conditionals
and another which trades flexibility for speed and readability.


If/Else Conditional
-------------------

.. index:: if conditional, else keyword

An :dfn:`if/else conditional` is a construct that allows code to be executed
only if a particular expression evaluates as "true". The if/else conditional
differs from the conditional operator in that it permits multiple conditional
tests as well as multiple expressions within the conditional bodies (the
conditional operator allows only a single expression). The if/else conditional
supports one default "else" which will execute if none of the conditional
expressions are "true".

The if/else conditional can take two forms. The following example shows the
first form. The "``// ...``" in the example shows where the body expressions for
that particular condition would occur. ::

   if(expression1)
      // Code here executed if expression1 evaluates to "true"
      // ...
   else(expression2)
      // Code here executed if expression2 evaluates to "true"
      // ...
   else
      // Code here executed if neither expression1 or expression2 evaluates to "true"
      // ...
   /if

Each expression is evaluated in order, and the first value evaluating to "true"
will have its corresponding conditional body executed. Once completed, no
further conditions will be tested and execution will resume at the end of the
if/else conditional.

The second form operates like the first, but permits the if/else to be used with
the association/code block syntax. ::

   if(expression1) => {
      // ...
   else(expression2)
      // ...
   else
      // ...
   }

Either form is accepted. Although an if/else conditional produces no value, the
first form does auto-collection, as will the second if associated with an
auto-collect block (``=> {^ ... ^}``). See the :ref:`captures` chapter for more
information about these different types of code blocks.

There is also a shortcut syntax for the if/else conditional in the form ``test ?
expression1 | expression2``, where the first expression is run if the test is
"true" and the second if the test is "false", described further in the section
:ref:`operators-conditional` of the :ref:`operators` chapter.


Match/Case Conditional
----------------------

.. index:: match conditional, case keyword

A :dfn:`match/case conditional` allows code to be selectively executed based
upon the logical equivalence of two or more objects. The match/case conditional
is given an initial test value and a series of case values and conditional
bodies. The initial value is tested against each case value using the initial
value's ``onCompare`` method. The first case value that matches the initial test
value will have its conditional body executed. Each case can have more than one
value to test against. If no case values match, then the default case, if
present, has its conditional body executed. Using a match/case conditional when
possible allows the compiler to perform optimizations not available with an
if/else conditional, potentially leading to better performance.

Like the if/else conditional, a match/case conditional has two forms. The
following example shows the first form with several case values and a default
case::

   match(expression)
   case(c1, c2)
      // Code here executed if c1 or c2 matches expression
      // ...
   case(c3)
      // Code here executed if c3 matches expression
      // ...
   case
      // Code here executed if neither c1, c2, or c3 matches expression
      // ...
   /match

The second form uses the association/code block syntax::

   match(expression) => {
   case(c1, c2)
      // ...
   case(c3)
      // ...
   case
      // ...
   }

Either form is accepted. Although a match/case conditional produces no value,
the first form does auto-collection, as will the second if associated with an
auto-collect block (``=> {^ ... ^}``). See the :ref:`captures` chapter for more
information about these different types of code blocks.


Loop Constructs
===============

Lasso offers several constructs that execute a body of code repeatedly, or
:dfn:`loop`, based upon some criteria. This criteria can be a boolean
expression, a number counting to a predefined point, or the count of the number
of elements in a composite object. Each method of looping supports skipping to
the top of the next iteration, aborting the loop process entirely, and
retrieving the current count of the number of loops that have occurred.

Each of these loop constructs support the two forms shown for if/else and
match/case. Most examples are shown in both forms. Also, like if/else and
match/case conditionals, loop constructs do not produce a value, but the first
form does auto-collection, as will the second if associated with an auto-collect
block (``=> {^ ... ^}``). See the :ref:`captures` chapter for more information
about these different types of code blocks.


While Loop
----------

.. index:: loop; while

A :dfn:`while loop` executes its body as long as its test expression is "true".
The test expression is evaluated before the beginning of each loop. ::

   // Form 1
   while(expression)
      // Code here executes for as long as "expression" is true
      // ...
   /while

   // Form 2
   while(expression) => {
      // ...
   }


Counting Loop
-------------

.. index:: loop; counting

A :dfn:`counting loop` steps from one integer number to another, either counting
up or down each iteration, until the counter reaches the end value. The most
common usage of a counting loop is to give it a number indicating how many times
it is to execute its body. Other usages involve giving the counting loop a
specific starting number, a specific ending number, and an increment value by
which the counter will be incremented for each iteration.

In the following example, the body will be executed 5 times::

   // Form 1
   loop(5)
      // Code here executed 5 times in a row
      // ...
   /loop

   // Form 2
   loop(5) => {
      // ...
   }

To specify the starting number, ending number, and increment, you can use one of
the following two forms of the counting loop::

   // Loop to 5 starting from -10 incrementing by 10
   loop(5, -10, 10)
      // Code here executed each pass through the loop
      // ...
   /loop

   // Loop to 5 starting from -10 incrementing by 10
   loop(-to=5, -from= -10, -by=10)
      // ...
   /loop

In the case of using unnamed parameters, the order of the integers is
significant. In the case of using keyword parameters, either the ``-from`` or
``-by`` may be omitted, and all keyword parameters may be supplied in any order.


Iterate Loop
------------

.. index:: loop; iterate

An :dfn:`iterate loop` is applied to objects that contain other objects, such as
arrays, maps, or any type that supports :trait:`trait_forEach`. Iterate will
execute the body once for each element contained in such an object. Iterate
makes the individual elements available through the `loop_value` method. When
iterating objects that store their elements associatively as keys and values,
the key is also made available through the `loop_key` method.

The following example creates a staticarray and iterates its contents::

   local(lv) = staticarray(2, 4, 6, 8, 10)

   // Form 1
   iterate(#lv)
      loop_value   // The current value from #lv
   /iterate

   // => 246810

   // Form 2
   iterate(#lv) => {
      // ...
   }


Loop Methods
------------

.. method:: loop_abort()

   Can be used within the body of any of the loop constructs mentioned in this
   chapter. When called, the current loop construct will cease and execution
   will continue at the code following it.

.. method:: loop_continue()

   Can be used within the body of a loop construct to cause the current loop
   to cease executing. Looping begins again at the top with the testing of the
   loop condition if present, and continues with the next iteration if
   applicable.

.. method:: loop_count()

   All of the loop constructs keep track of the current loop number. The
   `loop_count` method can be called to retrieve this number. For while and
   iterate loops, the loop number always begins with "1" on the first loop and
   advances by "1" on each additional iteration. In a counting loop, the loop
   number begins with the loop's "from" value and advances either forward or
   backward depending on how the loop was constructed.

.. note::
   :ref:`Query expressions <query-expressions>` do not support `loop_abort`,
   `loop_continue`, or `loop_count`.

.. method:: loop_key()

   When called within an iterate loop that's iterating a map, returns the key of
   the current map element. Returns "void" if the iterated object is any other
   type.

.. method:: loop_value()

   When called within an iterate loop, returns the current element from the
   object being iterated. Returns the element's value if the iterated object is
   a map.
