.. http://www.lassosoft.com/Language-Guide-Variables
.. _variables:

*********
Variables
*********

A :dfn:`variable` is a construct for saving and referencing the result of an
expression. A variable points to an object and permits that object to be saved
and used repeatedly later.

There are two types of variables: local variables and thread variables. The type
of the variable defines its scope and the rules about using it. Each variable is
given a name, and that name is used to access the variable's value. An object
which a variable points to can be changed, or reassigned, as described in the
:ref:`operators` chapter.


Variable Names
==============

Lasso variable names should begin with a letter or an underscore followed by a
letter, then zero or more letters, numbers, underscores or period characters.
Variable names are case-insensitive, so a variable named "rhino" can also be
accessed with "RhINo" as well.


Local Variables
===============

Each capture runs with its own set of variables. These are called :dfn:`local
variables` or :dfn:`locals`, and they are the most commonly used type of
variable. Locals begin and end within the capture in which they are defined,
though the objects they point to may exist beyond that point. Nested captures
also have access to any locals defined in their parent capture before their own
definition.

A local must be defined before it can be used. When a variable is defined, it is
generally done so along with an initial value to be assigned to that variable.
If an initial value is omitted, the variable will have the default value of
"null". Multiple locals can be defined at one time, either with or without
default values, using the following syntax examples::

   // Defines local "name" set to the value of the expression
   local(name = expression)

   // Defines locals "name" without a value and "b" set to 1
   local(name, b = 1)

A local can be accessed using two different methods. In the first method, the
local variable may or may not have previously been defined. If the local has not
been defined, then it is defined and assigned a value of "null". Regardless,
the value of the variable is produced as the result. This is only the case when
one variable name is used and when it is not accompanied by an initial value. ::

   local(name)
   // => the value of "name", potentially creating "name"

Local variables can also be accessed using the "#" character before the name.
This is the preferred method for accessing local variables. ::

   #name
   // => the value of "name"

When using this method, the local variable must have already been defined or it
is considered an error. This error-checking is done at the time the code is
parsed, meaning that the local definition must *physically* precede the "#"
access point within the source code.

The set of local variables for each capture is determined as the code is
compiled and cannot be modified at runtime, unlike thread variables which can be
given names dynamically.


Parameter Pseudo-locals
-----------------------

Lasso permits the parameter values given to a method to be accessed by position,
using the local variable symbol "#" followed by an integer value. The integer
value corresponds to the position of the desired parameter value, beginning with
"1". For example, in a method given two parameters, the first would be available
using ``#1`` and the second would be available using ``#2``.

See the :ref:`methods` chapter for information on methods and method parameters.


.. _variables-thread:

Thread Variables
================

:dfn:`Thread variables`, or :dfn:`vars`, are variables that are shared and
accessible outside of any particular capture, yet are restricted to the
currently executing thread. Each thread maintains its own set of vars. Vars are
useful for maintaining program states that go beyond the operation of any one
method.

Vars are created in a manner similar to locals, but instead use the ``var``
declaration. ::

   // Defines var "name" set to the value of the expression
   var(name = expression)

   // Defines vars "name" without a value and "b" set to 1
   var(name, b = 1)

A var created without an initial value will be given the default value of
"null".

Vars can be created using an expression value for a name, unlike locals which
require a fixed literal name. This expression must result in a string or a tag
object. That value is used as the variable's name. ::

   // Defines var with name of nameExpr
   var(nameExpr = expression)

.. note::
   Because a literal variable name can resemble a method call with no parameters,
   if the variable name is intended to be the result of a method call, then that
   call should be given empty parentheses ``()`` to disambiguate. ::

      // Defines var with the name of what nameCall() returns
      var(nameCall() = expression)

A var can be accessed using two methods, similar to that of local variables.
First, the var may simply be referenced using the ``var`` construct along with
the var's name. The var may or may not have previously been defined. If the var
has not been defined, then it is defined and assigned a value of "null". The
value of the variable is produced as the result. This is only the case when one
variable name is used and when it is not accompanied by an initial value. ::

   var(name)
   // => the value of "name", potentially creating "name"

Vars can also be accessed using the "$" character before the name. When using
this method, an error is returned if the var has not been previously defined. ::

   $name
   // => the value of "name"


.. _variables-type-constraints:

Type Constraints
================

A :dfn:`type constraint` can be applied to a local or thread variable in order
to ensure that the value of the variable is always an object of a particular
type. For example, a local variable could be constrained to always hold a string
object. If an attempt was made to assign to that variable a non-string object,
such as an integer, the assignment would fail.

Lasso is a dynamically typed language, and, by default, variables can hold any
type of object. Type constraints permit a developer to restrict variables to
hold only particular object types in order to ensure that the code operating on
those variables is working with valid inputs.

Type constraints are applied when a local or thread variable is first defined.
This is done by supplying a :ref:`tag literal <literals-tag>`, which consists of
two colons (``::``) and then the name of the type to which the variable will be
constrained, immediately following the variable name. The following example
applies type constraints to a local and a var::

   local(lname::integer = 0)
   var(vname::string = '')

In the above example, "lname" is constrained to hold only integers, and "vname"
is constrained to hold only strings. The next example shows valid and invalid
usage of the two variables::

   #lname = 400
   // Valid: 400 is an integer

   #lname = 'hello'
   // FAILURE: #lname can only hold integers

   $vname = 940
   // FAILURE: $vname can only hold strings

   local(lname = 'hello')
   // FAILURE: #lname can only hold integers

When applying a type constraint in a variable declaration, it is required that a
default value be provided. ::

   local(lname::integer, x, y, z)
   // FAILURE: #lname requires default value


.. _variables-decompositional:

Decompositional Assignment
==========================

Lasso will "decompose" the right-hand value (RHS or rvalue) of an assignment
when the left-hand side (LHS) is a local declaration containing just a list of
variable names. This supports wildcards (the ``_`` character) as well as nested
name lists. Any type that supports :trait:`trait_forEach` can be used like this
on the RHS.

The following examples should help clarify::

   local(one, two, three, four) = (:1, 2, 3, 4, 5, 6)

   #one
   // => 1
   #two
   // => 2
   #three
   // => 3
   #four
   // => 4

   local(_, two, _, four) = (:1, 2, 3, 4, 5, 6)

   #two
   // => 2
   #four
   // => 4

   local(_, two, _, four) = 1 to 100 by 3

   #two
   // => 4
   #four
   // => 10

   local(one, _, three, (_, four)) = array('a', 'b', 'c', array('d', 'e'))

   #one #three #four
   // => ace

   local(wanted, _, w2) = 'ABCDEFGH'

   #wanted
   // => A
   #w2
   // => C

Note that the local must include more than one element, and none of the elements
can be assigned values. ::

   local(x) = #foo
   // Unchanged, works as expected

   local(x, _) = #foo
   // Fine, grabs first #foo

   local(x = 1, _) = #foo
   // FAILURE: x cannot have value

Also note that assign-produce (``:=``) cannot be used with decompositional
assignment, and that quoted variable names are not permitted.
