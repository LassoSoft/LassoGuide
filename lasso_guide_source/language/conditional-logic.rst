.. http://www.lassosoft.com/Language-Guide-Conditional-Logic
.. _conditional-logic:

*****************
Conditional Logic
*****************

Conditional logic makes a program tick. Sections of code can be skipped or
repeated multiple times. Code can be executed in every repetition of a loop or
every several repetitions. Complex decision trees can be created which execute
code only under very specific conditions. Lasso supports a variety of operations
for performing conditional logic.


If/Else Conditional
===================

An if/else conditional is a special construct that allows code to be executed
only if a particular expression evaluates as true. The if/else conditional
differs from the conditional operator in that it permits multiple conditional
tests as well as multiple expressions within the conditional bodies (the
conditional operator allows only a single expression). The if/else conditional
supports one default "else" which will execute if none of the conditional
expressions are true.

The if/else conditional can take two forms. The following example shows the
first form. The "// ..." in the example shows where the body expressions for
that particular condition would occur. ::

   if (expression1)
     // Code here executed if expression1 evalutes true
     // ...
   else (expression2)
     // Code here executed if expression2 evalutes true
     // ...
   else
     // Code here executed if neither expression1 or expression2 evalutes true
     // ...
   /if

Each expression is evaluated in order and the first value which is true will
have its corresponding conditional body executed. Once completed, no further
conditions will be tested and execution will resume at the end of the if/else
conditional.

The second form operates like the first, but permits the if/else to be used with
the association/givenBlock syntax. ::

   if (expression1) => {
     // Code here executed if expression1 evalutes true
     // ...
   else (expression2)
     // Code here executed if expression2 evalutes true
     // ...
   else
     // Code here executed if neither expression1 or expression2 evalutes true
     // ...
   }

Either form is accepted. An if/else conditional produces no value, but the first
form does auto-collection as will the second if associated with an auto-collect
block (``=>{^ ... ^}``). See :ref:`the chapter on Captures <captures>` for more
information about the different types of code blocks.


Match Conditional
=================

A match conditional allows code to be selectively executed based upon the
logical equivalence of two or more objects. Match conditionals are given an
initial test value and a series of case values and conditional bodies. The
initial value is tested against each case value using the initial value's
"onCompare" method. The first case value that matches the initial test value
will have its conditional body executed. Each case can have more than one value
to test against. If no case values match, then the default case, if present, has
its conditional body executed.

Like the if/else conditional, a match conditional has two forms. The following
example shows the first form with several case values and a default case::

   match (expression)
   case (c1, c2)
      // Code here executed if c1 or c2 matches expression
      // ...
   case(c3)
      // Code here executed if c3 matches expression
      // ...
   case
      // Code here executed if neither c1, c2, or c3 matches expression
      // ...
   /match

The second form uses the association/givenBlock syntax::

   match (expression) => {
   case (c1, c2)
      // Code here executed if c1 or c2 matches expression
      // ...
   case(c3)
      // Code here executed if c3 matches expression
      // ...
   case
      // Code here executed if neither c1, c2, or c3 matches expression
      // ...
   }

Either form is accepted. A match conditional produces no value, but the first
form does auto-collection as will the second if associated with an auto-collect
block (``=>{^ ... ^}``). See :ref:`the chapter on Captures <captures>` for more
information about the different types of code blocks.


Looping
=======

Lasso offers several operations which loop---executing a body of code
repeatedly---based upon some criteria. This criteria can be a boolean
expression, a number counting to a pre-defined point, or the count of the number
of elements in a composite object. Each method of looping supports skipping to
the top of the next iteration, aborting the loop process entirely, and
retrieving the current count of the number of loops that have occurred.

Each of these looping operations support the two forms shown for if/else and
match. Most examples are shown in both forms. Also, like if/else and match
conditionals, looping operations do not produce a value, but the first form does
auto-collection as will the second if associated with an auto-collect block
(``=>{^ ... ^}``). See :ref:`the chapter on Captures <captures>` for more
information about the different types of code blocks.


While Loop
----------

A while loop executes its body as long as its test expression is true. The test
expression is evaluated before the beginning of each loop. ::

   // Form 1
   while (expression)
      // Code here executes for as long as "expression" is true
      // ...
   /while

   // Form 2
   while (expression) => {
      // Code here executes for as long as "expression" is true
      // ...
   }


Counting Loop
-------------

A counting loop steps from one integer number to another, either counting up or
down each iteration, until the counter reaches the end value. The most common
usage of a counting loop is to give it a number indicating how many times it is
to execute its body. Other usages involve giving the counting loop a specific
starting number, a specific ending number, and an increment value by which the
counter will be incremented for each iteration.

In the following example, the body will be executed 5 times::

   // Form 1
   loop(5)
      // Code here executed 5 times in a row
      // ...
   /loop

   // Form 2
   loop(5) => {
      // Code here executed 5 times in a row
      // ...
   }

To specify the starting number, ending number, and increment, you can use the
following two forms of the ``loop`` method::

   // loop to 5 starting from -10 incrementing by 10
   loop(5, -10, 10)
      // Code here executed each pass through the loop
      // ...
   /loop

   // loop to 5 starting from -10 incrementing by 10
   loop(-to=5, -from= -10, -by=10)
      // Code here executed each pass through the loop
      // ...
   /loop

In the case of using unnamed parameters, the order of the integers is
significant. In the case of using keywords, either the "-from" or "-by" may be
omitted, and all keywords may be supplied in any order.


Iterate
-------

An iterate loop is applied to objects that contain other objects, such as arrays
or maps. Iterate will execute the body once for each element contained in such
an object. Iterate makes the individual elements available through the
``loop_value`` method. When iterating objects that store their elements
associatively as keys and values, iterate makes the key value available through
the ``loop_key`` method.

The following example creates a staticarray and iterates its contents::

   local(lv = staticarray(2, 4, 6, 8, 10))

   // Form 1
   iterate(#lv)
     loop_value   // the current value from #lv
   /iterate
   // => 246810

   // Form 2
   iterate(#lv) => {
      // ...
   }


Loop Operations
---------------

.. method:: loop_abort()

   The ``loop_abort`` method can be used within the body of any of the looping
   operations mentioned in this chapter. When ``loop_abort`` is called, the
   current looping construct will cease and execution will continue at the code
   following it.

.. method:: loop_continue()

   The ``loop_continue`` method can be used within the body of a looping
   operation to cause the current loop to cease executing. Looping begins again
   at the top with the testing of the loop condition if present, and continues
   with the next iteration if applicable.

.. method:: loop_count()

   All of the loop operations keep track of the current loop number. The
   ``loop_count`` method can be called to retrieve this number. For while and
   iterate, the loop number always begins with "1" on the first loop and
   advances by "1" on each additional iteration. In a counting loop, the loop
   number begins with the loop's from value and advances either forward or
   backward depending on how the loop was constructed.

.. note::
   Query Expressions do not support ``loop_abort``, ``loop_continue``, or
   ``loop_count``.
