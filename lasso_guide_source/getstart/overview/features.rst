.. _overview-lasso-features:

**************************
Lasso Programming Features
**************************

The Lasso programming language has a number of great features that make coding
in it enjoyable. This tutorial will scratch the surface of some of the best
features of Lasso while also giving an introduction to defining methods, types,
and traits.


Type Constraints
================

Lasso allows programmers to specify that a variable they create can only store
objects of a specific type or trait. The following example creates a local
variable that can only store integer values::

   local(myInt::integer) = 5
   #myInt = 8
   #myInt = '44'
   // => // Throws an error since we are trying to assign a string

This syntax also works for type-constraining thread variables.


Methods
=======

Defining your own methods in Lasso is extremely easy. The following example
returns the time of day ("morning", "afternoon", or "evening") given a specified
hour::

   define time_of_day(hour::integer) => {
      // Check to make sure the hour value is valid
      fail_if(#hour < 0 or #hour > 23,
         error_code_invalidParameter,
         error_msg_invalidParameter + ': hour must be between 0 and 23'
      )

      if(#hour >= 5 and #hour < 12) => {
         return 'morning'
      else(#hour >= 12 && #hour < 17)
         return 'afternoon'
      else
         return 'evening'
      }
   }

The first line contains the ``define`` keyword, followed by the name for the
method and its the parameter list in parentheses (the method signature),
followed by the association operator (``=>``) and an open brace. All the code
between that open brace and its matching closing brace is the capture associated
with the method, which is executed when the method is called.

The method starts by making sure that the hour passed to it is valid. If it is,
then the code that determines the time of day will run and return the proper
value.

Notice that the type constraint in the method definition's signature constrains
``hour`` to be an integer object. This enables a handy feature in Lasso called
"multiple dispatch". Let's say we want a similar function that accepts a
date object. No need for a different method name; instead we can define that
method like this::

   define time_of_day(datetime::date=date) => time_of_day(#datetime->hour)

This defines a second method that also has the name "time_of_day", but accepts a
date object and returns the value of calling the ``time_of_day`` method that
takes an integer, passing it the hour of the date object. This method definition
doesn't have a capture associated with it. If your method is going to just
return the value of an expression, you can put that expression to the right of
the association operator. It's equivalent to this code::

   define time_of_day(datetime::date=date) => {
      return time_of_day(#datetime->hour)
   }

Besides multiple dispatch, methods can also have optional parameters and named
parameters. In the ``time_of_day`` example method that takes a date object, the
``datetime`` parameter is actually optional: the current date and time will be
used if no value is passed. See the :ref:`methods` chapter for more information
on parameter definition and use.


Types
=====

Lasso is an object-oriented language that comes with a number of core types
already defined, but you can also create your own types. Below is a simple type
definition to demonstrate how::

   define person => type {
      data public nameFirst::string
      data
         public nameMiddle::string,
         public nameLast::string

      public onCreate(first::string, last::string, middle::string='') => {
         .'nameFirst'     = #first
         .'nameMiddle'    = #middle
         self->'nameLast' = #last
      }

      public nameFirstLast => self->nameFirst + ' ' + .nameLast
   }

The type definition starts off with the ``define`` keyword followed by the type
name, the association operator, the ``type`` keyword, and finally the braces for
the capture containing the type definition code. The definition starts with two
data sections that define three data members for the type. Two member methods
are then defined using the access level keyword ``public`` instead of the
``define`` keyword. The ``onCreate`` methods are special for types: they define
type creator methods that are automatically called when you create instances of
your type. The following code would use the ``person->onCreate`` method to
create an object of type "person" and then output their first and last name::

   local(cool_dude) = person('Sean', 'Stephens')  // "middle" is defined as an optional parameter
   #cool_dude->nameFirstLast

   // => Sean Stephens

Types in Lasso also have single inheritance and can implement and import traits,
described next. For more information on types, see the :ref:`types` chapter.


Traits
======

Traits are a great way to package up and make available reusable code for types.
If there is functionality that needs to be shared between different types, it
can be packaged up as a trait instead of creating a different implementation for
each type or forcing a complex inheritance scheme.

Defining traits is similar to defining types. The following example is a
slightly modified version of the definition for ``trait_positionallyKeyed``::

   define ex_trait_positionallyKeyed => trait {
      import trait_doubleEnded

      require size()::integer, get(key::integer)

      provide
         first()  => (.size > 0 ? .get(1) | null),
         second() => (.size > 1 ? .get(2) | null),
         last()   => (.size > 0 ? .get(.size) | null)
   }

The definition starts with the ``define`` keyword followed by the name of the
trait, the association operator, the ``trait`` keyword, and then a set of braces
enclosing the trait definition. There are then three sections that start with
their own keyword:

import
   This section can contain a comma-separated list of traits that the current
   trait implements. In this case, because our trait implements a ``first`` and
   ``last`` method, it can import ``trait_doubleEnded`` which allows for types
   that use this trait to also get the methods that ``trait_doubleEnded``
   provides. (Alternatively, if trait A imports trait B but doesn't implement
   trait B's required traits, then any type that imports trait A must also meet
   the requirements for trait B by implementing the missing methods.)

require
   This section can contain a comma-separated list of method signatures that
   must be implemented by any type wanting to import this trait. In this case it
   requires a ``size`` method that returns an integer and a ``get`` method that
   takes a single integer parameter.

provide
   This section can contain a comma-separated list of method definitions. This
   is where the reusable code is defined that types importing this trait will be
   able to access.

The result of this trait definition is that types defining a ``size`` method and
a ``get`` method can import this trait and have the following methods available
as member methods: ``first``, ``second``, ``last``. For more information on
defining and using traits, see the :ref:`traits` chapter.


Query Expressions
=================

Query expressions allow programmers to create highly readable code that can do
complex manipulation of data sets. Here is a quick example::

   local(data_set) = (: 42, 11, 72, 13, 14, 88, 92, 35)

   with number in #data_set
   where #number % 2 == 0
   skip 1
   take 3
   sum #number

   // => 174

Every query expression starts as :samp:`with {newLocalName} in
{trait_queriable}`, where ``newLocalName`` becomes the name of a local variable
only accessible in the query expression, and ``trait_queriable`` is an object
whose type implements and imports ``trait_queriable``, such as the
:type:`staticarray` in the example.

After this initial ``with`` clause, a query expression can have zero or more
operation clauses that each start with their own keyword. The example above uses
three: ``where`` which filters the input using an expression, ``skip`` which
skips a set number of elements, and ``take`` which returns a set number of
elements. Order does matter.

Every query expression ends with one action clause that specifies what should be
done for each iteration. In this case, we're using the ``sum`` action to add
each value in the iteration together. Other actions are ``min``, ``max``,
``average``, and ``select``, which returns a new set of values rather than a
single value; and ``do``, which runs a block of code for each value.

The example above iterates over each element in the staticarray and first tests
to see if it is an even number. It then skips the first even number it finds and
only executes the ``sum`` action on the next three. The end result is that it
adds 72, 14, and 88 together.

The best part about query expressions is that most of the actions are lazily
executed. This means you can store a query expression in a variable, and it will
wait to be executed until the value for the variable is expected. For a more
thorough description, see the :ref:`query-expressions` chapter.

.. only:: html

   Next Topic: :ref:`Serving Lasso <overview-serving-lasso>`
