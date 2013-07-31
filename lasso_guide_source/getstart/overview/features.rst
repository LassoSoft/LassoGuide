.. _overview-lasso-features:

**************************
Lasso Programming Features
**************************

The Lasso programming language has a number of great features that make coding
in it enjoyable. This tutorial will scatch the surface on some of the best
features while also give you an introduction into defining methods, types, and
traits. (For detailed information, read the appropriate section in
:ref:`the Lasso Langauge Guide. <lasso-language-guide-index>`)


Type Constraints
================

Lasso allows programmers to specify that a variable they create can only store
objects of a specific type or trait. The following example creates a local
variable that can only store integer values::

   local(myInt::integer) = 5
   #myInt = 8
   #myInt = '44'
   // => Throws an error since we are trying to assign a string.

This sytax works for constraining thread variables too.


Methods
=======
   
Defining your own methods in Lasso is extremely easy. The following example
returns the time of day (morning, afternoon, or evening) given a specified
hour::

   define time_of_day(hour::integer) => {
      // Check to make sure the hour value is valid
      fail_if(#hour < 0 or #hour > 23.
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

The first line contains the ``define`` keyword followed by the name for the
method followed by the parameter list in parenthesis followed by the associate
operator ("=>") and an open brace. All the code between that open brace and its
matching closing brace is the capture associated with the method and excuted
when the method is called.

We start by making sure that the hour that is passed to us is a valid hour. If
it is, then the code that determines the time of day will run and return the
proper value.

Notice the type constraint in the method definition's signature that constrains
hour to be an integer object. This enables a really handy feature in Lasso
called "multiple dispatch". Let's say we want a similar function that takes in a
``date`` object. No need for a different name, instead we can define the method
like this::

   define time_of_day(datetime::date=date) => time_of_day(#datetime->hour)

This defines a second method also with the name of "time_of_day", but it takes
in a ``date`` object and returns the value of calling the ``time_of_day`` method
that takes an integer, passing it the hour of the date object. This method
definition doesn't have a capture associated with it. If you are going to just
return the value of an expression, you can just put that expression to the right
of the associate operator. It's equivalent to this code::

   define time_of_day(datetime::date=date) => {
      return time_of_day(#datetime->hour)
   }

Besides multiple dispatch, methods can also have optional parameters and named
parameters. See :ref:`the chapter on Methods <methods>` for more information.


Types
=====

Lasso is an object-oriented language and comes with a bunch of core types
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
name, then the associate operator, next the ``type`` keyword and then the braces
for the capture containing the definition code.This starts with two data
sections that define three data members for the type. Two member methods are
then defined using the access level keyword ``public`` instead of the ``define``
keyword. The "onCreate" methods are a special for types — they define type
creator methods that are used to create intances of your type. The following
code would use that ``person->onCreate`` method to create an object of type
``person``::

   person('Sean', 'Stephens')  // "middle" is defined as an optional parameter

Types in Lasso also have single inheritance and can implement and import traits.
For more information, read :ref:`the Types chapter <types>` of the Language
Guide.


Traits
======

Traits are a great way to package up and make available reusable code for types.
If there is functionality that needs to be shared by different types, package it
in a trait instead of creating a different implementation for each type.

Defining traits is similar to defining types. The following example slightly
modifies the ``trait_positionallyKeyed`` definition::

   define ex_trait_positionallyKeyed => trait {
      import trait_doubleEnded

      require size()::integer, get(key::integer)
      
      provide
         first()  => (.size > 0? .get(1) | null),
         second() => (.size > 1? .get(2) | null),
         last()   => (.size > 0? .get(.size) | null)
   }

The definition starts with the ``define`` keyworkd followed by the name of the
trait followed by the associate operator and then the ``trait`` keyword and an
open brace. There are then three sections that start with their own keyword:

import
   This section can contain a comma-separated list of traits that the current
   trait implements. In this case, because our trait implements a "first" and
   "last" method, it can import ``trait_doubleEnded``.

require
   This section can contain a comma-separated list of method signatures that
   must be implemented by the type wanting to import this trait. In this case it
   requires a "size" method that returns an integer and a "get" method that
   takes a single integer parameter.

provide
   This section can contain a comma-separated list of method definitions. This
   is where the reusable code that types that import this trait will have access
   to.

The upshot of this trait definition is that types that define a "size" method
and a "get" method can import this trait and have the following methods
available as member methods: "first", "second", "last". For more information on
defining and using traits, read :ref:`the Traits chapter <traits>` in the Lasso
Language Guide.


Query Expressions
=================

Query expressions allow programmers to create highly readable code that can do
some complex manipulation of data sets. Here is a quick example::

   local(data_set) = (:42, 11, 72, 13, 14, 88, 92, 35)

   with number in #data_set
   where #number % 2 == 0
   skip 1
   take 3
   sum #number

   // => 174

Every query expression starts with "with *newLocalName in *trait_queriable*".
After this with clause, a query expression can have 0 or more operator clauses
that each start with their own keyword. (We have three: where, skip, take. And
order does matter.) Every query expression ends with one action clause that
specifies what should be done for each iteration. (In this case, we're using the
"sum" action.)

The example above iterates over each element in the staticarray and first tests
to see if it is an even number. It then skips the first even number it finds and
only executes the action on the next three. The end result is that it ends up
summing 72, 14, and 88 together.

The best part about query expressions is that most of the actions are lazily
executed. This means you can store a query expression in a variable, and it will
wait to be executed until the value for the variable is expected. For a better
description, read :ref:`the chapter on Query Expressions <query-expressions>` in
the Lasso Language Guide.

:ref:`Next Tutorial: Embedding Lasso in HTML <overview-embedding-lasso>`