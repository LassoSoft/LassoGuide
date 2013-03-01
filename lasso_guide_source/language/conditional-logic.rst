.. _conditional-logic:
.. http://www.lassosoft.com/Language-Guide-Conditional-Logic

*****************
Conditional Logic
*****************

Conditional logic makes a program tick.

Sections of code can be skipped or repeated multiple times. Code can be
executed in every repetition of a loop or every several repetitions.
Complex decision trees can be created which execute code only under very
specific conditions. Lasso supports a variety of operations for
performing conditional logic.

-  `If/Else Conditional`_ tests one or more conditions selectively
   executing code
-  `Match Conditional`_ compares a value to one or more choices
   selectively executing code
-  `Looping`_ repeatedly executing based on a condition

If/Else Conditional
===================

An if/else conditional is a special construct that allows code to be
executed only if a particular expression results to true. The if/else
conditional differs from the conditional operator in that it permits
multiple condition tests as well as multiple lines of code within the
condition bodies (the conditional operator allows only single
expressions). The if/else conditional supports one default "else" which
will execute if none of the condition expressions are true.

The if/else conditional can take two forms. The following example shows
the first form. The "..." in the example shows where the body
expressions for that particular condition would occur.

::

   if (expression)
     ...
   else (expression)
     ...
   else
     ...
   /if

Each expression is evaluated in order and the first value which is not
false will have its corresponding condition body executed. Once
completed, no further conditions will be tested and execution will
resume at the end of the if/else conditional.

The second form operates like the first, but permits the if/else to be
used with the association/givenBlock syntax.

::

   if (expression) => {
     ...
   else (expression)
     ...
   else
     ...
   }

Either form is accepted. An if/else conditional produces no value.

Match Conditional
=================

A match conditional allows code to be selectively executed based upon
the logical equivalence of two or more objects. Match conditionals are
given an initial test value and a series of case values and condition
bodies. The initial value is tested against each case value using
onCompare. The first case value that matches the initial test value will
have its condition body executed. Each case can have more than one value
to be tested against. If no case values match, then the default case, if
present, has its condition body executed.

Like the if/else conditional, a match conditional has two forms. The
following example shows the first form with several case values and a
default case.

::

   match (expression)
   case (c1, c2)
     ...
   case(c3)
     ...
   case
     ...
   /match

The second form uses the association/givenBlock syntax. Either form is
accepted.

::

   match (expression) => {
   case (c1, c2)
     ...
   case(c3)
     ...
   case
     ...
   }

Looping
=======

Lasso offers several operations that loop, executing a body of code
repeatedly, based upon some criteria. This criteria can be a boolean
true/false expression, a number counting to a pre-defined point, or the
count of the number of elements in a composite object. Each method of
looping supports skipping to the top of the next iteration, aborting the
loop process entirely and retrieving the current count of the number of
loops that have occurred. A looping operation does not produce a value.

Each of these looping operations support the two forms shown for if/else
and match. Most examples are shown in both froms. In each example, "..."
is used to indicate where body code would be placed.

While Loop
----------

A while loop executes its body as long as its test expression is true.
The test expression is evaluated before the beginning of each loop.

::

   while (expression)
     ...
   /while
   while (expression) => {
     ...
   }

Counting Loop
-------------

A counting loop loops from one integer number to another, either
counting up or down each iteration, until the counter reaches the end
value. The most common usage of a counting loop is to give it a number
indicating how many times it is to execute its body. Other usages
involve giving the counting loop a specific beginning number, a specific
ending number, and an increment value, by which the counter will be
incremented for each iteration.

In the following example, the body will be executed 5 times.

::

   loop(5)
     ...
   /loop
   loop(5) => {
     ...
   }

Counting loops also support providing an explicit beginning and an
ending value for the counter. This is done by providing the to, from and
by parameters, or by providing ``-to``, ``-from`` and ``-by`` keyword
parameters. Either method is accepted.

::

   loop(5, -10, 10)
     ...
   /loop
   // => loop to 5 starting from -10 incrementing by 10
   loop(-to=5, -from= -10, -by=10)
     ...
   /loop
   // => loop to 5 starting from -10 incrementing by 10

In the case of using integer parameters, the order is significant. In
the case of using keywords, either the ``-from`` or ``-by`` may be omitted and
all keywords may be supplied in any order.

Iterate
-------

An iterate loop is applied to objects that contain other objects, such
as arrays or maps. Iterate will execute the body once for each element
contained in such an object. Iterate makes the individual elements
available through the **loop_value** method. When iterating objects
that store their elements associatively as keys and values, iterate
makes the key value available through the **loop_key** method.

The following example creates a staticarray and iterates its contents.

::

   local(lv = staticarray(2, 4, 6, 8, 10))
   iterate(#lv)
     loop_value
     // => the current value from #lv
   /iterate

   iterate(#lv) => {
     ...
   }

Loop_abort
----------

The **loop_abort** method can be used within the body of any of the
looping operations mentioned in this chapter. When loop_abort is
called, all loopings will cease and execution will begin following the
looping operation.

Loop_continue
--------------

The **loop_continue** method can be used within the body of a looping
operation to cause the current loop to cease executing. Looping begins
again at the top with the testing of the loop condition.

Loop_count
-----------

All of the loop operations keep track of the current loop number.
The **loop_count** method can be called to retrieve this number. For
while and iterate, the loop count always begins with 1 on the first
loop, advancing for each loop thereafter.

In a counting loop, the loop count begins with the loop's from value and
advances either forward or backward depending on how the loop was
constructed.

*Note: Query Expressions do not support loop_abort, loop_continue or
loop_count.*
