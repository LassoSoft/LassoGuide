.. http://www.lassosoft.com/Language-Guide-Operators
.. _operators:

*********
Operators
*********

An :dfn:`operator` is a special symbol which, combined with one or more
operands, performs an operation using those operands and, generally, produces a
value.

Lasso supports the standard arithmetic operators and logical operators as well
as numerous other useful operations. Operators can be :dfn:`unary`, taking only
one operand, :dfn:`binary` requiring two operands, or :dfn:`ternary`, in the
case of the conditional operator, requiring up to three operands.

Lasso permits the behavior of some operators to be controlled by the operand
objects themselves. This is accomplished in an object by having it implement a
method whose name matches the symbol for that operator. For example, a type that
needed to support addition would implement a method named ``+`` which accepts
one parameter and returns the resulting value.


.. _operators-assignment:

Assignment Operators
====================

Assignment places the result of an expression into a destination. The
destination must be a local or thread variable, or it must be an
appropriately named method call. Lasso supports two types of assignment, one
that produces the assigned value (``:=``) and one that does not (``=``). ::

   // "dest" assigned value of expression
   dest = expression

   // "dest" assigned value of expression, "dest" produced
   dest := expression
   // => // Produces a reference to "dest"

The second assignment type, which produces the left-hand operand, is
right-associative so that multiple assignments can be lined up. The following
assigns the value of "1" to "dst1", "dst2" and "dst3" and also produces "1"::

   dst1 := dst2 := dst3 := 1
   // => 1

Locals and vars can be assigned using the access syntax for either variable
type. ::

   // local "l" assigned expression
   #l = expression

   // local "l" assigned expression
   local(l) = expression

   // var "v" assigned expression
   $v = expression

   // var "v" assigned expression
   var(v) = expression

Variables and data members are the only elements to which values can truly be
assigned, but Lasso permits methods to be created that mimic the act of
assignment. This is done by naming the method with a "=" character at the end.
For example, a method that wanted to accept assignment for ``foo`` would be
named ``foo=``. Such a method must accept at least one parameter and must return
the assigned value as if it were being called in the role of assign-produce
(``:=``). Methods that permit such assignment are useful as "setters" and let an
object control how the assignment is ultimately made. See the :ref:`types`
chapter for more detail on creating setter methods.


Arithmetic Operators
====================

Arithmetic usually refers to mathematical operations using integer or decimal
numbers. However, an arithmetic operator can be applied to any object that
supports the operation.


Addition, Subtraction, Multiplication, Division, Modulus
--------------------------------------------------------

These operators are all binary, requiring two operands. All of these operators
can be implemented by a type containing the properly named method. Only the
left-hand operand's method is called. None of these operators should modify
either operand, but must return a new object. The examples that follow show the
use of each operator::

   op1 + op2
   // => // Returns the value of adding op2 to op1

   op1 - op2
   // => // Returns the value of subtracting opt2 from op1

   op1 * op2
   // => // Returns the value of multiplying op1 by op2

   op1 / op2
   // => // Returns the value of dividing op1 by op2

   op1 % op2
   // => // Returns the value of the remainder from dividing op1 by op2 (modulo operation)

   (: 10 + 3, 10 - 3, 10 * 3, 10 / 3, 10 % 3 )
   // => staticarray(13, 7, 30, 3, 1)


Arithmetic Assignment
---------------------

While the standard arithmetic operators use their operands to produce a new
value, Lasso supports syntax for applying the arithmetic operator *to* one of
the operands. The following operators perform their operation and assign the
result to the left-hand side operand. Only the left-hand operand can be assigned
to and not every expression is capable of being assigned to, as described in the
section on :ref:`assignment operators <operators-assignment>`. These assignment
expressions do not produce a value. ::

   // Equivalent to op1 = op1 + op2
   op1 += op2

   // Equivalent to op1 = op1 - op2
   op1 -= op2

   // Equivalent to op1 = op1 * op2
   op1 *= op2

   // Equivalent to op1 = op1 / op2
   op1 /= op2

   // Equivalent to op1 = op1 % op2
   op1 %= op2

During parsing, these operators are expanded to their regular arithmetic and
assignment operations, so a type does not need to do anything to support them
aside from implementing the assignment operator method and the appropriate
arithmetic operator method.


Pre / Post Increment and Decrement
----------------------------------

There is a common need to "advance" an object in a bi-directional manner.
Usually this is done using integers as counters, though the concept can be
applied elsewhere. Lasso supports the increment and decrement operators (``++``
and ``--``) in both pre and post modes.

Pre-incrementing and pre-decrementing an object will add or subtract "1" from
the object and then produce that object as a result. Post-incrementing and
post-decrementing an object first copies that object, then adds or subtracts "1"
from the original operand, then produces the copied object as a result. ::

   // Pre-increment "op"
   ++op
   // => // Produces the newly incremented "op"

   // Pre-Decrement "op"
   --op
   // => // Produces the newly decremented "op"

   // Post-Increment "op"
   op++
   // => // Produces a copy of "op" before incrementing

   // Post-Decrement "op"
   op--
   // => // Produces a copy of "op" before decrementing

These increment/decrement operators are translated into regular arithmetic
method calls with "1" as the method parameter. This means that if a type is
intended to be used with the increment (``++``) and decrement (``--``)
operators, all that's necessary is to implement ``+`` and ``-`` which will be
called with "1" as the parameter.


Positive and Negative
---------------------

Lasso supports the unary operators which are usually intended to change the sign
of an integer or decimal number. These operators can be applied to any object
that supports them. When applied, these operators will produce a new object,
leaving the single operand unchanged. ::

   +op1
   // => // Produces a new object whose value is positive op1

   -op1
   // => // Produces a new object whose value is negative op1

Types can implement this operator by defining a method named ``+`` or ``-`` that
accepts zero parameters. When unary ``+`` or ``-`` is applied to :type:`integer`
or :type:`decimal` literals, no method call is generated. Instead, the positive
or negative number is created from the beginning.


.. _operators-boolean:

Boolean Operators
=================

:dfn:`Boolean` describes the values "true" and "false". Lasso supports several
operators that either treat their operands as boolean values and/or produce
boolean values. These operators are broken down into several categories.

.. note::
   In Lasso, most objects will be treated as "true", but the following objects
   and values will be treated as "false": the :type:`integer` "0", the
   :type:`decimal` "0.0", and the types :type:`null` and :type:`void`. An empty
   :type:`string` also evaluates to "false", but this functionality is
   deprecated; change your code to call `string->size` to check for empty
   strings. All other objects and values are assumed to be "true".


Logical
-------

There are three :dfn:`logical operators`. The first is the unary operator "not".
This operator treats its single operand as a boolean value and produces the
opposite of that value. The "not" operator turns a "true" into a "false" and a
"false" into a "true". Though the operand can be of any type, this operator
always produces a "true" or "false" value. The "not" operator can take one of
two forms: an exclamation mark (``!``) or the ``not`` keyword. ::

   !true
   // => false

   not false
   // => true

The other two logical operators are logical "and" and logical "or", and they
also can take two forms: double ampersands (``&&``) or the ``and`` keyword for
logical "and", and double pipes (``||``) or the ``or`` keyword for logical "or".

These binary operators treat their first operand as a boolean value and perform
their operation based on that value. Logical "and" inspects its first operand,
and if it is "true", produces its second operand. If the first operand is
"false", logical "and" will produce the value "false". Logical "or" inspects its
first operand, and if it is "true", produces that first operand. If the first
operand is "false", logical "or" will produce the second operand. ::

   op1 && op2
   // => // Returns "false" if either op1 or op2 evaluates to "false" else opt2

   op1 || op2
   // => // Returns op1 if it evaluates to "true" else op2

These operators perform shortcut evaluation, meaning that if the result of the
operation is determined before the second operand is evaluated, then the second
operand will not be evaluated. Also note that the behavior of the logical
operators cannot be defined by the operand objects.


.. _operators-equality:

Equality
--------

The :dfn:`equality operators` are used to determine if one object is logically
equivalent to another. These operators are split into positive and negative
equality tests as well as strict and non-strict equality tests. A positive
equality test checks if one object *is equal to* another object while a negative
equality test checks if an object *is not equal to* another. Strict equality
testing further tests the types of the operand objects. If the right-hand
operand is not an instance of the type of the left-hand operand, then the
equality test fails. These operators all produce either a "true" or "false"
value. ::

   op1 == op2
   // => // Produces "true" if op1 is equal to op2 else false

   op1 != op2
   // => // Produces "true" if op1 is not equal to op2 else false

   op1 === op2
   // => // Produces "true" if op1 is both equal to and the same type as op2 else false

   op1 !== op2
   // => // Produces "true" if op1 is not equal to or not the same type as op2 else false

   (: 3 == 3.0, 3 != 3.0, 3 === 3.0, 3 !== 3.0 )
   // => staticarray(true, false, false, true)

If an object is to be tested for equality against another, its type must
implement a method named ``onCompare``. The ``onCompare`` method is
automatically called at runtime to perform equality checks. It is only called on
the left-hand operand, and this method must accept one parameter, which is the
right-hand operand. When called, it indicates whether the left-hand operand is
less than, equal to, or greater than the right-hand operand by returning either
an integer less than zero, zero, or greater than zero, respectively. The act of
checking the object types in the case of strict equality testing is
automatically performed by the runtime, so a type need not account for that
scenario in its own implementation of ``onCompare``.


Relative Equality
-----------------

The :dfn:`relative equality operators` indicate whether an object is less than,
greater than, or possibly equal to another object. These operators all produce
either a "true" or "false" value. ::

   op1 < op2
   // => // Produces "true" if op1 less than op2 else "false"

   op1 > op2
   // => // Produces "true" if op1 greater than op2 else "false"

   op1 <= op2
   // => // Produces "true" if op1 less than or equal to op2 else "false"

   op1 >= op2
   // => // Produces "true" if op1 greater than or equal to op2 else "false"

Types control how equality checks behave by implementing the ``onCompare``
method as described above in the section on :ref:`equality operators
<operators-equality>`. Because ``onCompare`` is required to return an integer
value (either zero, less than zero, or greater than zero), it can handle all
possible types of equality tests.


Containment
-----------

There are two :dfn:`containment operators` used to test if an object "contains"
another object. One checks for positive containment (``>>``) and the other for
negative containment (``!>>``). Both are binary operators and both produce
either a "true" or "false" value. ::

   op1 >> op2
   // => // Produces "true" if op2 is contained within op1 else false

   op1 !>> op2
   // => // Produces "true" if op2 is not contained within op1 else false

In order to support containment testing, a type must implement a method named
``contains``. This method must accept one parameter, which is the right-hand
operand, and must return a boolean "true" or "false". Only the left-hand operand
will have its ``contains`` method called.

Containment testing only logically applies to certain types of objects. For
example, it makes no sense to ask what an integer object contains, because it is
scalar, consisting of only one value. Containment testing is primarily done on
container types such as :type:`array` or :type:`map`. Objects of those types can
contain any number of other arbitrary objects, so it makes sense to query them
for their contents.


Conditional
-----------

The :dfn:`conditional operator` allows the construction of an if/then/else
scenario in which an expression is tested and depending on its boolean value,
either the "then" or the "else" expressions will be executed and their values
produced as the result of the operator. The "then" and "else" can consist of
only one expression. The "else" portion of a conditional operator may be
omitted. In such a case, if the condition is "false", a "void" object will be
produced.

The conditional operator uses the two "?" and "|" characters. The "?" follows
the test condition and the "|" delimits the "then" and "else" expressions. A
conditional operator with no "else" will have no delimiting "|" character. ::

   test ? expression1 | expression2
   // => // Produces expression1 if test is "true" else expression2

   test ? expression
   // => // Produces expression if test is "true" else void


Grouping
========

Sub-expressions can be grouped together by surrounding them with parentheses.
This can be used to alter the normal precedence of some operations. All
sub-expressions in parentheses are evaluated before the expressions surrounding
them. The first example below shows how multiplication normally occurs before
addition. The second example applies parentheses to have the addition take
precedence. ::

   2 * 5 + 7
   // => 17

   2 * (5 + 7)
   // => 24


.. _operators-invocation:

Invocation
==========

Parentheses can be applied to some expressions in order to :dfn:`invoke` the
value. Invoking can have different results for different objects. By default,
most objects return a copy of themselves when they are invoked. Methods, when
invoked, execute the method, returning its value.

Invoking an object by applying parentheses is always equivalent to directly
calling the method named ``invoke``. The following examples invoke a local
variable and a thread variable with no parameters::

   #lv()
   // => // Produces the value of invoking the object stored in the local "lv"

   $tv->invoke
   // => // Produces the value of invoking the object stored in the var "tv"

Parameters may be given to an ``invoke``. The following invokes ``#lv`` with
three parameters::

   #lv(1, 'two', 3)
   // => // Produces the value of invoking the object stored in the local "lv" with those parameters

See the :ref:`types` chapter for more information on the :ref:`invoke
<types-invoke>` callback.

It is also possible to dynamically generate parameters and programmatically pass
them into an invocation. By first adding the parameters to an array named
"my_params" and including a colon after the opening parenthesis of the
invocation statement, the following example results in an equivalent invocation
as the previous. ::

   local(my_params) = array(1, 'two', 3)
   #lv(: #my_params )
   // => // Produces the value of invoking the object stored in the local "lv" with those parameters

This form is useful for passing a set of values from an object of any type
supporting :trait:`trait_forEach` to a method that accepts a rest parameter. ::

   define printArgs(...) => with i in #rest do stdoutnl(#i)
   printArgs(: #my_params )

   // =>
   // 1
   // two
   // 3

The concept behind invocation is somewhat abstract, but it permits objects and
methods to operate as :dfn:`function objects`. This is an object that can be
called upon to do an operation with zero or more parameters and produce a value.
For example, a sorting routine might employ such an object to handle the actual
comparisons between two objects, invoking the object each time it is required,
while the routine handles only the shifting of the objects during the sort.

This technique would permit the sorting routine to be customized for a wide
variety of object types as well as ascending and descending directions by just
switching out the objects designated to handle each permutation while keeping
the internal operations identical.


Target
======

To :dfn:`target` means to access a particular member method or data member from
an object. The target operator (``->``) is a binary operator accepting the
target object as the left-hand operand and the method name as the right-hand
operand. Targeting a member method always executes that method, passing along
any given parameters. ::

   #lv->meth()
   // => // Produces the value of calling meth() on the object stored in #lv with no parameters

   #lv->meth
   // => // Same as the first example, showing parentheses are optional

   #lv->meth(40)
   // => // Produces the value of calling meth() on the object stored in #lv with 1 parameter

   #lv->meth(40, 'sample')
   // => // Produces the value of calling meth() on the object stored in #lv with 2 parameters

Accessing a data member is accomplished through a similar syntax, but by
surrounding the name in single quotes. A data member can only be accessed from
within the type in which the data member is defined. When accessing a data
member, it is an error to have any value except for ``self`` as the left-hand
operand, and the right-hand operand must be single-quoted. ::

   self->'dMem'
   // => // Produces the value stored in the "dMem" data member

As it is very common to access data and methods using the current "self", Lasso
provides a shortcut syntax for accessing members within "self" or inherited
members. Using a period (``.``) before the member name will target the current
"self". Using two periods (``..``) before the member name will target inherited
members, skipping the current "self" and searching for the member starting from
the parent of the type that defined the currently executing member method. Two
periods can only be used for methods, as only "self" can access data members. ::

   .'dMem'
   // => // Produces the value stored in the "dMem" data member (same as self->'dMem')

   .meth(1, 2)
   // => // Produces the value of calling self->meth(1, 2)

   ..meth(3, 4)
   // => // Produces the value of calling inherited->meth(3, 4)


Re-target
=========

The :dfn:`re-target` operation allows the same target object to be used for
multiple method calls. The re-target operator (``&``) is placed between the
individual method calls. Re-target is only ever used in the context of a member
method call using the target operator (``->``). The target object of the last
target operator is used as the object for the re-targeted member call. For each
method call, the ``&`` is placed following the method name, parameters and
givenBlock (if present).

The re-target operator can be used to string two or more methods together. The
return value of the final method will be produced by this type of re-target. ::

   object->meth & meth2
   // => // Execute meth on the object then execute meth2 and produce its value

   object->meth(1, 2) & meth2()
   // => // Execute meth on the object then execute meth2 and produce its value

Re-target can also be used to change the produced value of a member method call
to be that of the target object. This is done by having a trailing ``&`` at the
end of a method call. ::

   targetObject->meth(1, 2) &;
   // => // Execute meth, but produce targetObject


Formatting Re-target
--------------------

When stringing several method calls together, formatting over multiple lines can
help with readability. It is important, however, to keep the ``&`` on the same
line as the *next* method call. This holds only for cases that have a next
method and for method call expressions that are not ultimately parenthesized.

The following example illustrates this formatting principle::

   targetObject->meth(5, 7)
   & meth2()
   & meth3(90) &;
   // => execute meth, meth2, meth3, and then produce targetObject


Escape Method
=============

To :dfn:`escape` a method is to allow a method to be searched for by name and
returned to the caller. The caller can later use that method, executing it by
applying parentheses as described in the section on :ref:`invocation
<operators-invocation>`. This makes it easy for methods to be treated as regular
values and to be used as callbacks. It is an error if the method that is being
escaped is not defined.

Both member methods and unbound methods can be escaped. There are two escape
method operators, one for member methods and one for unbound methods. Escaping a
member method uses the binary escape operator (``->\``), while escaping an
unbound method uses the unary escape operator (``\``). ::

   #lv->\meth
   // => // Produces a reference to the member method "meth" of the object in local "lv"

   \meth
   // => // Produces a reference to the unbound method "meth"

When a member method is escaped, the resulting value is bound to that target
object. This ensures that when the resulting value/method is invoked, that the
current "self" will be the object from which the method was escaped.
Additionally, if there is more than one method defined under the given name, all
of the methods are retrieved. This permits multiple dispatch to be used with an
escaped method.

The right-hand method name operand can come from the result of any expression.
When using such a dynamic method name, the expression must be surrounded in
parentheses to disambiguate. ::

   #lv->\(meth + 'name')
   // => // Produces a reference to the member method defined by concatenating "name" with the value of "meth"

Though the escape operators are used to find methods by name, the object
produced by the operators is a :dfn:`memberstream`. This object manages the
finding of the desired method, the potential bundling of the target object (in
the case of ``->\``), and the execution of the method when the memberstream is
invoked.


Additional Syntax
=================

There are several other operator-like syntax elements that will be described in
detail in later sections of this document. Many of them apply in limited
situations or special contexts and so are beyond the scope of this chapter.

.. seealso::

   -  **Association Operator** ``=>``
      See :ref:`methods`, :ref:`types`
   -  **Keywords** ``return``, ``yield``, etc.
      See :ref:`captures`, :ref:`methods`
   -  **Captures/Code blocks** ``{ }``, ``{^ ^}``
      See :ref:`conditional-logic`, :ref:`captures`, :ref:`methods`
