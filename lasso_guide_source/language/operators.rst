.. _operators:
.. http://www.lassosoft.com/Language-Guide-Operators

*********
Operators
*********

An **operator** is a special symbol which, combined with one or more
**operands**, performs an operation using those operands and, generally,
produces a value.

Lasso supports the standard arithmetic operators and logical operators
as well as numerous other useful operations. Operators can be **unary**,
taking only one operand, **binary** requiring two operands, or
**ternary**, in the case of the **condition** operator, requiring up to
three operands.

Lasso permits the behavior of some operators to be controlled by the
operand objects themselves. This is accomplished in an object by having
it implement a method whose name matches the symbol for that operator.
For example, a type that needed to support addition would implement a
method named ``+`` which accepts one parameter and returns the resulting
value.

-  `Assignment`_ how data moves around
-  `Arithmetic`_ the various arithmetic operators available in Lasso
-  `Boolean & Logical`_ the boolean logic operators and the condition
   operator
-  `Grouping`_ how parentheses are applied to sub-expressions
-  `Invoke`_ describes how parentheses are applied to "invoke" any
   object
-  `Target and Re-target`_ the ``->`` and ``&`` operators, including the
   ``.`` and ``..`` shortcuts
-  `Escape Method`_ how methods can be searched for
-  `Additional Syntax`_ elements described in later sections

Assignment
==========

Assignment places the result of an expression into a destination
location. The destination must be a local or thread variable, or it must
be an appropriately named method call. Lasso supports two types of
assignment, one that produces the assigned value and one that does not.

::

   dest = expression
   // => "dest" assigned value of expression
   dest := expression
   // => "dest" assigned value of expression, "dest" produced

The second assignment type, which produces the left-hand operand, is
right-associative so that multiple assignments can be lined up. The
following assigns the value of 1 to dst1, dst2 and dst3.

::

   dst1 := dst2 := dst3 := 1

Locals and vars can be assigned using the access syntax for either
variable type.

::

   #l = expression
   // => local "l" assigned expression
   local(l) = expression
   // => local "l" assigned expression
   $v = expression
   // => var "v" assigned expression
   var(v) = expression
   // => var "v" assigned expression

Variables and data members are the only elements to which values can
truly be assigned, but Lasso permits methods to be created which mimic
the act of assignment. This is done by naming the method with a ``=``
character at the end. For example, a method that wanted to accept
assignment for ``foo`` would be named ``foo=``. Such a method must accept at
least one parameter and must return the assigned value as if it were
being called in the role of ``:=``. Methods which permit such assignment
are useful as "setters" and let an object control how the assignment is
ultimately made.

Arithmetic
==========

Arithmetic usually refers to operations of mathematics using integers or
decimal numbers. An arithmetic operator can be applied to any object
which supports that operation.

Addition, Subtraction, Multiplication, Division, Modulo
-------------------------------------------------------

These operators are all binary, requiring two operands. All of these
operators can be implemented by a type containing the properly named
method. Only the left-hand operand's method is called. None of these
operators should modify either operand. All of these operators must
return a new object.

::

   op1 + op2
   // => op1 plus op2
   op1 - op2
   // => op1 minus op2
   op1 * op2
   // => op1 multiplied by op2
   op1 / op2
   // => op1 divided by op2
   op1 % op2
   // => the remainder of op1 divided by op2

Assignment Variants
-------------------

While the standard arithmetic operators use their operands to produce a
new value, Lasso supports the syntax for applying the arithmetic
operator **to** one of the operands. The following operators perform
their operation and assign the result to the left-hand side operand.
Only the left-hand operand can be assigned to and not every expression
is capable of being assigned to, as described in **Assignment** above.
These assignment expressions do not produce a value.

::

   op1 += op2
   // => op1 = op1 + op2
   op1 -= op2
   // => op1 = op1 - op2
   op1 *= op2
   // => op1 = op1 * op2
   op1 /= op2
   // => op1 = op1 / op2
   op1 %= op2
   // => op1 = op1 % op2

During parsing, these operators are expanded to their regular arithmetic
operations, so a type does not need to do anything to support them aside
from implementing the appropriate arithmetic operator method.

Pre & Post Increment & Decrement
--------------------------------

There is a common need to increment or "advance" an object in a
bi-directional manner. Usually this is done with integers being used as
counters, though the concept can be applied elsewhere. Lasso supports
the increment and decrement operators ``++`` and ``--`` in both pre and
post modes.

Pre-incrementing and pre-decrementing an object will add or subtract 1
from the object and then produce that object as a result.
Post-incrementing and post-decrementing an object first copies that
object, then adds or subtracts 1 from the original operand, then
produces the copy object as a result.

::

   ++op
   // => pre-increment op
   --op
   // => pre-decrement op
   op++
   // => post-increment op
   op--
   // => post-decrement op

These increment/decrement operators are translated into regular
arithmetic method calls with 1 as the method parameter. This means that
if a type intends to be used with the ``++`` and ``--`` operators, it should not
implement a method with a name such as "++", but instead should
implement "+" and "-" where it will be called with 1 as a parameter.

Positive & Negative
-------------------

Lasso supports the unary operators usually intended to change the sign
of an integer or decimal number. These operators can be applied to any
object which supports them. When applied, these operators will produce a
new object, leaving the single operand unchanged.

::

   +op1
   // => positive op1
   -op1
   // => negative op1

Types can implement this operator by defining a method named "+" or "-"
which accepts zero parameters. When unary ``+`` or ``-`` is applied to integer
or decimal literals, no method call is generated. Instead, the positive
or negative number is created from the beginning.

Boolean & Logical
=================

**Boolean** describes the values true and false. Lasso supports several
operators which either treat their operands as boolean values and/or
produce boolean values. These operators are broken down into several
categories.

Logical Operators
-----------------

There are three logical operators. The first is the unary operator
**not**. This operator treats its single operand as a boolean value and
produces the opposite of that value. Not turns a true into a false and a
false into a true. Most objects will be treated as true, but the
following objects and values will be treated as false: the integer 0,
the decimal 0.0 and the types null and void. All other objects are
assumed to be true. Though the operand can be of any type, this operator
always produces a true or false value.

::

   !op1
   // => not op1

The other two logical operators are **logical and** and **logical or**.
These binary operators treat their first operand as a boolean value and
perform their operation based on that value.

Logical *and* inspects its first operand, and if it is true, produces
its second operand. If the first operand is false, logical *and* will
produce the value false.

Logical *or* inspects its first operand, and if it is true, produces
that first operand. If the first operand is false, logical *or* will
produce the second operand.

::

   op1 && op2
   // => op1 and op2
   op1 || op2
   // => op1 or op2

The behavior of the logical operators can not be modified by the operand
objects. These operators perform short-cut evaluation, meaning that if
the result of the operation is determined before the second operand is
evaluated, then the second operand will not be evaluated.

Equality Operators
------------------

Equality operators are used to determine if one object is logically
equivalent to another. These operators are split into positive and
negative equality tests as well as strict and non-strict equality tests.
A positive equality test checks if an object **is equal to** another
object, while a negative equality test checks if an object **is not
equal to** another. Strict equality testing further tests the types of
the operand objects. If the right-hand operand is not an instance of the
type of the left-hand operand, then the equality test fails. These
operators all produce either a true or false value.

::

   op1 == op2
   // => op1 is equal to op2
   op1 != op2
   // => op1 is not equal to op2
   op1 === op2
   // => op1 is strictly equal to op2
   op1 !== op2
   // => op1 is not strictly equal to op2

If a type is to be equality tested against another, it must implement
the method named "onCompare". onCompare is automatically called at
run-time to perform equality checks. onCompare is only called on the
left-hand operand and this method must accept one parameter, which is
the right-hand operand. onCompare indicates whether the left-hand
operand is less-than, equal to, or greater than the right-hand operand
by returning either integer zero, less then zero or greater then zero,
respectively. The act of checking the object types in the case of strict
equality testing is automatically performed by the runtime, so a type
need not bother with that scenario in its own implementation of
onCompare.

Relative Equality Operators
---------------------------

Relative equality indicates if an object is less than or greater than,
and possibly equal to another object. These operators all produce either
a true or false value.

::

   op1 < op2
   // => op1 less than op2
   op1 > op2
   // => op1 greater than op2
   op1 <= op2
   // => op1 less than or equal to op2
   op1 >= op2
   // => op1 greater than or equal to op2

Types can control how equality checks behave by implementing the
onCompare method as described above in **Equality Operators**. Because
onCompare is required to return an integer value (either zero, less than
zero, or greater than zero), that single method can handle all of the
possible types of equality tests.

Containment Operators
---------------------

There are two operators used to test if an object "contains" another
object. One checks for positive containment and the other for negative
containment. Both are binary operators and both produce either a true or
false value.

::

   op1 >> op2
   // => op1 contains op2
   op1 !>> op2
   // => op1 does not contain op2

In order to support contains testing, a type must implement a method
named "contains". This method must accept one parameter, which is the
right-hand operand. Only the left-hand operand will have its contains
method called. The contains method must return a boolean true or false.

Contains testing only logically applies to certain types of objects. For
example, it makes no sense to ask what an integer object contains,
because it is scalar, consisting of only one value. Contains testing is
primarily done on objects such as arrays or maps. Those object can
contain any number of other arbitrary objects, so it makes sense to at
times need to query them for their contents.

Conditional Operator
--------------------

The **conditional operator** allows the construction of an if/then/else
scenario in which an expression is tested and depending on its boolean
value either the "then" or the "else" expressions will be executed and
their values produced as the result of the operator. The "then" and
"else" can consist of only one expression. The "else" portion of a
conditional operator may be omitted. In such a case, if the condition is
false, a void object will be produced.

The conditional operator uses the two characters  ``?``  and ``\|``. The
``?`` follows the test condition and the ``\|`` delim its the "then" and
"else" expressions. A conditional operator with no "else" will have no
delimiting ``\|`` character.

::

   test ? expression1 | expression2
   // => if test is true expression1, else expression2
   test ? expression
   // => if test is true expression, else void

Grouping
========

Sub-expressions can be grouped together by surrounding them with
parentheses. This can be used to alter the normal precedence of some
operations. All sub-expressions in parentheses are evaluated before the
expressions surrounding them. The first example below shows how
multiplication normally occurs before addition. The second example
applies parentheses to alter the outcome.

::

   2 * 5 + 7
   // => 17
   2 * (5 + 7)
   // => 24

Invoke
======

Parentheses can be applied to some expressions in order to
**invoke** the value. Invoking can have different results for different
objects. By default, most objects return a copy of themselves when they
are invoked. Methods, when invoked, execute the method, returning its
value.

Invoking an object by applying parentheses is always equivalent to
directly calling the method named "invoke". The following examples
invoke a local variable and a thread variable with no parameters.

::

   #lv()
   // => local variable "lv" invoked
   $tv()
   // => thread variable "tv" invoked

Parameters may be given in an invoke. The following invokes #lv with
three parameters.

::

   #lv(1, 'two', 3)
   // => local "lv" invoked with parameters

The concept behind **invoke** is somewhat abstract, but it permits
objects and methods to operate as "function objects". This is an object
that can be called upon to do "a thing" with zero or more parameters and
produce a value. For example, a sorting routine might employ such an
object to handle the actual comparisons between two objects, invoking
the object each time it is required, while the routine handles only the
shifting of the objects during the sort.

This technique would permit the sorting routine to be customized for a
wide variety of object types as well as ascending and descending
directions by just switching out the objects designated to handle each
permutation while keeping the internal operations identical.

Target and Re-target
====================

To **target** means to access a particular member method or data member
from an object. The target operator is a binary operator accepting the
target object as the left-hand operand and the method name as the
right-hand operand. The target operator uses the characters ``->``.
Targeting a member method always executes that method, passing along any
given parameters.

::

   #lv->meth()
   // => call method "meth" from object #lv, no parameters
   #lv->meth
   // => same as above, no parameters, no parentheses
   #lv->meth(40)
   // => call method "meth" from object #lv, 1 parameter
   #lv->meth(40, 'sample')
   // => call method "meth" from object #lv, 2 parameters

Accessing a data member is accomplished through a similar syntax but by
surrounding the name in single quotes. A data member can only be
accessed from within the type in which the data member is defined. When
accessing a data member, it is an error to have any value except for
``self`` as the left-hand operand, and the right-hand operand must be
quoted.

::

   self->'dMem'
   // => access data member "dMem"

As it is very common to access data and methods using the current
**self**, Lasso provides a shortcut syntax for accessing self or
inherited members. Using a period "." before the member name will target
the current self. Using two periods ".." before the member name will
target inherited members, skipping the current self and searching for
the member starting from the parent of the type which defined the
currently executing member method. Two periods ".." can only be used for
methods, as only self can access data members.

::

   .'dMem'
   // => same as self->'dMem'
   .meth(1, 2)
   // => same as self->meth(1, 2)
   ..meth(3, 4)
   // => same as inherited->meth(3, 4)

Re-target
---------

The re-target operator "&" allows the same target object to be used for
multiple method calls. The "&" symbol is placed in-between the
individual method calls. Re-target is only ever used in the context of a
member method call using the target operator "->". The target object of
the last "->" is used as the self for the re-targetted member call. For
each method call, the "&" is placed following the method name,
parameters and givenBlock (if present).

The re-target operator can be used to string two or more methods
together. The return value of the final method will be produced by this
type of re-target.

::

   'astrng'->meth & meth2
   // => execute meth, execute meth2, return its value
   'bstrng'->meth(1, 2) & meth2()
   // => execute meth, execute meth2, return its value

Re-target can also be used to change the result value of a method call
expression to be that of the target object. This is done by having a
trailing "&" at the end of a method call.

::

   targetObject->meth(1, 2) &
   // => execute meth, return targetObject

Formatting Re-target
--------------------

When stringing several method calls together, formatting over multiple
lines can help with readability. It is important to keep the "&" on the
same line as the **next** method call. This holds only for cases that
have a next method and method call expressions which are not ultimately
parenthesized.

The following example illustrates this formatting principle.

::

   targetObject->meth(5, 7)
   & meth2()
   & meth3(90) &
   // => execute meth, meth2, meth3, return targetObject

Escape Method
=============

Escaping a method allows a method to be searched for by name and
returned to the caller. The caller can later use that method, executing
it by applying parentheses as described in **Invoke**. This makes it
easy for methods to be treated as regular values and to be used as
callbacks. It is an error if the method that is being escaped is not
defined.

Both member methods and unbound methods can be escaped. There are two
escape method operators, one for member methods and one for unbound
methods. Escaping a member method uses a binary operator ``->\``.
Escaping an unbound method uses unary ``\``.

::

   #lv->\meth
   // => finds the method "meth" in local "lv"
   \meth
   // => finds the unbound method "meth"

When a member method is escaped, the resulting value is bound to that
target object. This insures that when the resulting value/method is
invoked, that the current self will be the object from which the method
was escaped. Additionally, if there is more than one method defined
under the given name, all of the methods are retrieved. This permits
multiple-dispatch to be used with an escaped method.

The right-hand method name operand can come from the result of any
expression. When using such a dynamic method name, the expression can be
surrounded in parentheses, to disambiguate.

::

   #lv->\(meth + 'name')
   // => finds method named accordingly

Though the escape operators are used to find methods by name, the object
produced by the operators is a **memberstream**. This object manages the
finding of the desired method, the potential bundling of the target
object (in the case of ``->\``), and the execution of the method when the
memberstream is invoked. See the section Built-in Data Types for more
information.

Additional Syntax
=================

There are several other operator-like syntax elements that will be
described in detail in later sections of this document. Many of them
apply in limited situations or special contexts and so are beyond the
scope of this chapter, but the following gives pointers to the
appropriate sections, where more information can be found.

**Association Operator** ``=>`` See :ref:`Methods<methods>`, :ref:`Types<types>`

**Keywords** ``return``, ``yield``, etc. See :ref:`Methods<methods>`

**Captures/Codeblocks** ``{ }`` ``{^ ^}`` See :ref:`Captures<captures>`, :ref:`Methods<methods>`
