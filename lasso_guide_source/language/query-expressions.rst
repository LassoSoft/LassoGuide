.. http://www.lassosoft.com/Language-Guide-Query-Expressions
.. _query-expressions:

*****************
Query Expressions
*****************

:dfn:`Query expressions` allow the elements in arrays and other types of
sequences to be easily iterated, filtered, and manipulated using a natural
language syntax which is reminiscent of SQL.

A query expression can take each element in a sequence, manipulate it, and
produce a new sequence. Query expressions let a developer drill down into nested
sequences. For example, a query expression could iterate over each line in a
block of text, then each word, and then each character; all in one expression.
Query expressions provide a variety of useful operations, such as ``order by``,
``sum``, ``average`` and ``group by``.


Query Expression Structure
==========================

Every query expression consists of three parts.

-  The :dfn:`with clause` specifies the variable name used to hold each element
   during evaluation, as well as the source of the data for the expression. One
   or more with clauses are required for every query expression. Multiple
   with clauses are used to dig down into nested sequences.

-  A series of optional operations allow the elements to be filtered, sorted,
   skipped, etc. Operators include ``where``, ``let``, ``skip``, ``take``,
   ``order by`` and ``group by``.

-  An :dfn:`action` tells Lasso what to do with the elements selected by the
   expression. Actions include ``select``, ``do``, ``sum``, ``average``,
   ``min``, and ``max``.

Whitespace, including line breaks, is insignificant within the clauses of a
query expression. Syntactically, a query expression will begin with the word
``with`` and will end when terminated by an action.

Query expressions can be treated as objects. This means they can be assigned to
variables and used repeatedly, and they can be passed as parameters. Unless
otherwise noted, query expressions are evaluated in a lazy manner. This means
that creating the query expression does not execute it. It is only when
something else attempts to draw elements from the query expression that it
begins to generate results.

All local variables available at the location of a query expression's creation
are available within the query expression itself. However, new variables
introduced by a query expression clause will not be available outside of the
query expression that introduces them.


The With Clause
---------------

The with clause always begins with the word ``with`` followed by a variable name
which is created as a local variable available only within the current query
expression. Next follows the word ``in`` and then the source data element, which
is any object whose type supports the :trait:`trait_queriable` trait, such as an
:type:`array` or a :type:`list`. Note that when declaring the variable at the
beginning of the with clause, the variable name is given by itself, without the
"#" character, just as if the local were being defined using the standard
``local`` syntax. ::

   with variable_name in source

Multiple subsequent with clauses can follow the first. When this occurs, the
second ``with`` word can optionally be replaced by a comma. Multiple with
clauses indicate a nesting of iterations. The following two example snippets are
equivalent::

   with variable_name in source
   with another_name in #variable_name

::

   with variable_name in source,
   another_name in #variable_name


Actions
=======

An :dfn:`action` defines the result of a query expression. Actions permit a
sequence to be transformed into a new sequence, or permit sequence elements to
be used to compute an aggregate, or permit an arbitrary block of code to be
executed for each resulting element.


Select
------

A :dfn:`select` clause permits a new sequence to be generated based upon the
source sequence. A select clause consists of the word ``select`` followed by a
single expression. The expression is evaluated once for each element from the
source sequence that makes its way through the query expression. The result of
the select's expression will be an element going into the new sequence.

The following example computes the square of each element in the source array.
The expression in the select clause performs the math to compute the square, the
result of which becomes an element in the resulting sequence. ::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   select #n * #n
   // => 1, 4, 9, 16, 25, 36, 49, 64, 81

One query expression can be used within another. In the next example, the query
expression is assigned to a variable. That variable is used in a subsequent
query expression. The first query expression is not evaluated until the second
query expression is evaluated. ::

   local(qe =
      with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
      select #n * #n
   )

   with newN in #qe
   select #newN * #newN
   // => 1, 16, 81, 256, 625, 1296, 2401, 4096, 6561


Do
--

A :dfn:`do` clause permits a block of code to be executed for each element that
makes its way through the query expression. A do clause consists of the word
``do`` followed by either a single expression or a capture using either the
regular curly brace form (``{ ... }``) or the auto-collect curly brace form
(``{^ ... ^}``). If the code associated with a do clause consists of more than
one expression, the code must be contained in a capture.

The following examples show how the query expression do clause can be used to
manipulate the elements in the source array. Both query expressions operate
identically. ::

   local(ary = array('the', 'quick', 'brown', 'fox', 'jumped', 'the', 'shark'))

   with n in #ary
   do #n->upperCase

   with n in #ary
   do {
      #n->upperCase
   }

It is important to note that when using ``do`` the query is immediately
evaluated and that the query expression produces no result value. All other
query expression actions are evaluated lazily, only as needed, and produce a
result value dependent on the action in question.

The block of code given to a ``do`` remains attached to the surrounding method
context, such that one could ``return`` or ``yield`` or access and create local
variables.


Sum
---

A :dfn:`sum` clause is useful when adding all of the resulting query expression
elements together. A sum clause consists of the word ``sum`` followed by a
single expression. The result of the expression will be the value used in the
summation. The summation is performed using the ``+`` operator, so each element
in the sequence must support the addition operator for the sum to succeed. The
result of a query expression using a sum clause will be a single value.

The following example uses a sum clause to add together each element from the
initial sequence::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   sum #n
   // => 45


Average
-------

An :dfn:`average` clause produces the average of each element that makes its way
through the query expression. As expected, using ``average`` will take the sum
of each element and then divide that value by the number of elements. As with
``sum``, ``average`` produces a single result value. ::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   average #n
   // => 5


Min and Max
-----------

The :dfn:`min` and :dfn:`max` clauses produce the smallest or largest value from
the sequence, respectively. The standard less than (``<``) and greater than
(``>``) operators are used to find the result value. ::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   min #n
   // => 1

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   max #n
   // => 9


Operations
==========

In a query expression, an :dfn:`operation` is an optional clause that affects
how the query expression behaves by removing elements from the sequence,
ordering the elements in a certain manner, or introducing new variables.


Where
-----

A :dfn:`where` operation lets elements be included or excluded from further
consideration based upon a boolean expression. A where operation will generally
run a test involving the current element. If the test expression results in
"false", the element is discarded and the next element is selected and operated
upon. If the test expression results in "true", the query expression proceeds
with the next operation or action in the expression.

A where operation is composed of the word ``where`` followed by a single
expression. The result of the expression should be boolean "true" or "false".

The following example performs a query expression using the numbers in an array.
The where operation filters out all even numbers, leaving only odd numbers for
the rest of the query expression. The local variable "n" holds each number in
turn as the expression is evaluated. ::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      where #n % 2 != 0 // Ignore even numbers
   select #n
   // => 1, 3, 5, 7, 9

Multiple where operations can be used in a query expression. Using multiple
where operations is essentially the same as combining the expressions using the
logical "and" operator (``&&`` or ``and``). The following two snippets are
equivalent, while the third is not. ::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      where #n % 2 != 0 // Ignore even numbers
      where #n % 3 != 0 // Ignore numbers evenly divisible by 3
   select #n
   // => 1, 5, 7

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      where #n % 2 != 0 && #n % 3 != 0
   select #n
   // => 1, 5, 7

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      where #n % 2 != 0 || #n % 3 != 0
   select #n
   // => 1, 2, 3, 4, 5, 7, 8, 9


Let
---

A :dfn:`let` operation introduces a new variable into the query expression.
Usually, this is done when evaluating an expression whose value will be used
repeatedly further on throughout the query expression. For example, a let
operation may evaluate an expression based upon the current iteration variable,
assigning the result to a new variable, and then using both further within the
query.

Variables introduced with a let operation have the same scope as those
introduced in a with clause. That is, they only exist within the query
expression.

A let operation consists of the word ``let`` followed by a new variable name,
the assignment operator (``=``), and then an expression, the result of which
will be assigned to the new variable.

The following example snippet assigns the square of the current iteration value
to a new variable using a let operation::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      let n2 = #n * #n
   select #n2
   // => 0, 1, 4, 9, 16, 25, 36, 49, 64, 81

The next example snippet uses both ``where`` and ``let`` together::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      let n2 = #n * #n    // Square the current value
      where #n2 % 2 != 0  // Discard even values using the new variable
   select #n2
   // => 1, 9, 25, 49, 81


Skip
----

A :dfn:`skip` operation permits a specified number of values from the source
sequence to be skipped. A skip operation consists of the word ``skip`` followed
by either a literal integer, or an expression that will evaluate to an integer.

The following example snippet skips the first 5 elements from the source
container. Only the 6\ :sup:`th` element and beyond are sent to the remaining
portion of the query expression. ::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      skip 5
   select #n
   // => 5, 6, 7, 8, 9


Take
----

A :dfn:`take` operation permits only a certain number of elements to be iterated
upon. Elements beyond the specified value are ignored and not sent to the
remainder of the query expression. A take operation consists of the word
``take`` followed by a literal integer or an expression that will evaluate to an
integer.

The following example snippet takes only the first 5 elements from the data
source. The remaining elements are ignored. ::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      take 5
   select #n
   // => 0, 1, 2, 3, 4

The ``skip`` and ``take`` can be used together to limit which elements a query
expression will operate over to a specific range. The order in which ``skip``
and ``take`` are specified is significant. (Generally, ``skip`` is specified
before ``take``, though this is not a requirement.)

The following example snippet skips the first 3 elements, takes only the next 4
and leaves the rest ignored. This results in only the numbers 3, 4, 5, and 6 for
the rest of the query expression. ::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      skip 3
      take 4
   select #n
   // => 3, 4, 5, 6

The next example snippets show how the ordering of ``skip`` and ``take`` is
important. This first query expression takes only the first 4 elements of the
series, though the first 3 of them are skipped. The second query produces the
same result, but uses ``skip`` and ``take`` in the reverse order. ::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      take 4
      skip 3
   select #n
   // => 3

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      skip 3
      take 1
   select #n
   // => 3


Order By
--------

Query expressions permit the elements of a series to be ordered in an arbitrary
manner by using an :dfn:`order by` operation. This is done by using the words
``order by`` and then an expression, the result of which is used as the value by
which the particular element will be ordered. This can be followed optionally by
a direction indicator, which is the word ``descending`` or ``ascending``. When a
direction is not indicated, ascending order is assumed. Further ordering
criteria can be specified by following the initial order by expression with a
comma, and then the next ordering expression and optional direction indicator.

The following example orders the elements in the array using the default
ascending order, and the next, in descending order::

   with n in array(9, 2, 1, 3, 5, 4, 6, 7, 0, 8)
      order by #n
   select #n
   // => 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

::

   with n in array(9, 2, 1, 3, 5, 4, 6, 7, 0, 8)
      order by #n descending
   select #n
   // => 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

The expression provided to an order by can be any arbitrary expression. This
permits elements to be ordered in any manner as desired by the developer. For
example, a series of string objects could be ordered based upon their lengths,
or elements could be randomly ordered based upon a random number generated for
this purpose. ::

   with n in array('the', 'quick', 'brown', 'fox', 'jumped', 'the', 'shark')
      order by #n->size
   select #n
   // => the, fox, the, quick, brown, shark, jumped

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
      order by integer_random(0, 99)
   select #n
   // => 9, 8, 6, 5, 2, 1, 7, 0, 4, 3

In the next example snippet, a series of user objects, represented by their
first and last names, could be ordered in an alphabetical manner::

   with n in array('Krinn'='Jones', 'Ármarinn'='Hammershaimb',
         'Kjarni'='Jones', 'Halbjörg'='Skywalker',
         'Björg'='Riley', 'Hjörtur'='Hammershaimb')
      order by #n->second, #n->first
   select #n
   // => (Hjörtur = Hammershaimb), (Ármarinn = Hammershaimb), (Kjarni = Jones), \
   //    (Krinn = Jones), (Björg = Riley), (Halbjörg = Skywalker)


Group By
--------

A :dfn:`group by` operation permits similar elements to be grouped together by a
particular key expression and represented as a single object called a
:dfn:`queriable_grouping`. This new object can be further used throughout the
query expression. A :type:`queriable_grouping` object maintains a reference to
each of the original elements within the group. It also possesses a ``key``
method which produces the value by which the particular elements were mutually
grouped.

A group by consists of three elements: the object going into the group, the key
by which the objects are grouped, and a new local variable name. This new
variable name will be introduced into the query expression for further use and
will be a :type:`queriable_grouping` object. It has the following form::

   group new_object_expression by key_expression into new_local_name

A group by operation makes the most sense when used with other operations and
actions. The following example takes a series of users, represented by a pair
with their last and first name, and performs a query expression over them. ::

   with n in array('Jones'='Krinn', 'Hammershaimb'='Ármarinn',
         'Jones'='Kjarni', 'Skywalker'='Halbjörg',
         'Riley'='Björg', 'Hammershaimb'='Hjörtur')
      let swapped = pair(#n->second, #n->first)
      group #swapped by #n->first into g
      let key = #g->key
      order by #key
   select pair(#key, #g)

   // => // Breaking up the return value for readability
   // (Hammershaimb = (Ármarinn = Hammershaimb), (Hjörtur = Hammershaimb)),
   // (Jones = (Krinn = Jones), (Kjarni = Jones)),
   // (Riley = (Björg = Riley)),
   // (Skywalker = (Halbjörg = Skywalker))

The example above example breaks down into six steps:

#. Begin the query expression using "n" as the variable to hold each initial
   element from the source array. There are 6 elements in the source array, so
   ``#n`` will start off pointing to the first element. Once the query
   expression completes its first iteration, ``#n`` will point to the second
   element and the query will perform another iteration, and so on, until the
   end of the array is reached. ::

      with n in array('Jones'='Krinn', 'Hammershaimb'='Ármarinn',
            'Jones'='Kjarni', 'Skywalker'='Halbjörg', 'Riley'='Björg',
            'Hammershaimb'='Hjörtur')

#. Create a new pair containing the swapped last and first names. Name this
   "swapped". ::

      let swapped = pair(#n->second, #n->first)

#. Group each of the new user pairs by last name: ``#n->first`` is used as the
   key as it still contains the original last name. From this point forward, no
   previously introduced variables are available. Only ``#g`` exists now. It
   will contain each :type:`queriable_grouping` object generated by the group by
   operation at this step. ::

      group #swapped by #n->first into g

#. Access the grouping key for the current value of ``#g``. Save it into
   ``#key``. ::

      let key = #g->key

#. Sort the resulting grouping objects by ``#key``, which contains the last
   name, using ``order by``. Therefore, all of the resulting group objects will
   come out of the query expression ordered alphabetically by last name. ::

      order by #key

#. Finally, create a new pair containing ``#key`` and the grouping object and
   select that, making the new pair one of the new elements in the result of the
   query expression. ::

      select pair(#key, #g)

The result of the example query expression looks as follows. Notice how the
results for ``'Hammershaimb'`` and ``'Jones'`` each contain both of the users in
those groups. ::

   // => // Line breaks added for readability
   // (Hammershaimb = (Ármarinn = Hammershaimb), (Hjörtur = Hammershaimb)),
   // (Jones = (Krinn = Jones), (Kjarni = Jones)),
   // (Riley = (Björg = Riley)),
   // (Skywalker = (Halbjörg = Skywalker))


Making an Object Queriable
==========================

An object can be used as the source of a with clause in a query expression if
its type has implemented and imported the :trait:`trait_queriable` trait. For
this, a type must implement the ``forEach`` member method. This method is always
called with a givenBlock. Within the ``forEach`` member method, the object being
queried should invoke the givenBlock, passing it each available element in turn.

The following example implements a user list type. Objects of this type can be
used in query expressions. For the sake of this example, it permits iteration
over a fixed list of users, which it provides to the query one by one. ::

   // Define the user_list type
   define user_list => type {
      trait { import trait_queriable }

      public forEach() => {
         local(gb = givenBlock)

         // Provide the 6 users one at a time
         #gb->invoke('Krinn'='Jones')
         #gb->invoke('Ármarinn'='Hammershaimb')
         #gb->invoke('Kjarni'='Jones')
         #gb->invoke('Halbjörg'='Skywalker')
         #gb->invoke('Björg'='Riley')
         #gb->invoke('Hjörtur'='Hammershaimb')

      }
   }

   // Create a user_list object
   local(ul = user_list)

   // Use it in a query
   with user in #ul
   select #user->first

   // => Krinn, Ármarinn, Kjarni, Halbjörg, Björg, Hjörtur

Types with one or more iterator methods can be used in a query expression by
exposing each iterator with an :dfn:`eacher`, which is a method that takes an
escaped iterator method and an optional set of initial parameters, and uses the
`eacher` method to return a generator for the iterator.

For example, while a string cannot be iterated upon directly, it has an iterator
`string->forEachCharacter`, which is implemented as an eacher below::

   define string->eachCharacter()::trait_forEach => eacher(self->\forEachCharacter)

A string can then run a query expression on each character by using
`string->eachCharacter`::

   with i in 'Hammershaimb'->eachCharacter
   select #i
   // => H, a, m, m, e, r, s, h, a, i, m, b
