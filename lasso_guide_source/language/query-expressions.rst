.. _query-expressions:
.. http://www.lassosoft.com/Language-Guide-Query-Expressions

*****************
Query Expressions
*****************

**Query expressions** allow the elements in arrays and other types of
sequences to be easily iterated, filtered, and manipulated using a
natural syntax which is reminiscent of SQL.

A query expression can take each element in a sequence, manipulate it
and produce a new sequence. Query expressions let a developer drill down
into nested sequences. For example, a query expression could iterate
over each line in a block of text, then each word, then each character,
all in one expression. Query expressions provide a variety of useful
operations, such as *order by, sum, average* and *group by*.

-  `Anatomy of a Query Expression`_ describes the structure of all
   query expressions.
-  `The With Clause`_ describes how each query expression begins.
-  `Actions`_ describes how the result of a query expression can be
   used.
-  `Operations`_ describes the various operations for filtering or
   sorting elements.
-  `Making An Object Queriable`_ shows how to add query support to your
   own objects.

Anatomy of a Query Expression
=============================

Every query expression consists of three parts.

-  The **with** clause specifies the variable name used to hold each
   element during evaluation, as well as the source of the data for the
   expression. One or more with clauses are required for every query
   expression. Multiple with clauses are utilized to dig down into
   nested sequences.

-  A series of optional operations allow the elements to be filtered or
   sorted, a number of elements to be skipped, etc. Operators include
   **where, let, skip, take, order by** and **group by**.

-  An action tells Lasso what to do with the elements selected by the
   expression. Actions include **do, select, sum, average, min and
   max**.

Whitespace, including line breaks, is insignificant within the clauses
of a query expression. Syntactically, a query expression will begin with
the word *with* and will end when terminated by an *action*.

Query expressions can be treated as objects. This means they can be
assigned to variables and used repeatedly, and can be passed as
parameters. Unless otherwise noted, query expressions are evaluated in a
lazy manner. This means that creating the query expression does not
execute it. It is only when something else attempts to draw elements
from the query expression that it begins to generate results.

All local variables available at the location of a query expression's
creation are available within the query expresion itself. However, new
variables introduced by a query expression clause will not be available
outside of the query expression that introduces them.

The With Clause
---------------

The ``with`` clause always begins with the word with followed by a
variable name which is created as a local variable available only within
the current query expression. Then follows the word in and then the
source data type, which is any type that supports the trait
``trait_queriable``, such as an ``array`` or a ``list``. Note that when declaring
the variable at the beginning of the with clause, the variable name is
given by itself, without the # character, just as if the local were
being defined using the standard local construct.

::

   with variable_name in source

Multiple subsequent with clauses can follow the first. When this occurs,
the second with word can optionally be replaced by a comma. Multiple
with clauses indicate a nesting of iterations. The following two example
snippets are equivalent.

::

   with variable_name in source
   with another_name in #variable_name

::

   with variable_name in source,
   another_name in #variable_name

Actions
=======

An action clause defines the result of a query expression. Actions
permit a sequence to be transformed into a new sequence, or permit
sequence elements to be used to compute an aggregate, or permit an
arbitrary block of code to be executed for each resulting element.

Select
------

A ``select`` clause permits a new sequence to be generated based upon
the source sequence. A ``select`` clause consists of the word
*select* followed by a single expression. The expression is evaluated
once for each element from the source sequence that makes its way
through the query expression. The result of the select's expression will
be an element going in to the new sequence.

The following example computes the square of each element in the source
array. The select clause expression performs the math to compute the
square, the result of which becomes an element in the resulting
sequence.

::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   select #n * #n

When the query expression above is evaluated, the result will be the
numbers: *1, 4, 9, 16, 25, 36, 49, 64, 81*.

One query expression can be utilized in another. In the next example,
the query expression is assigned to a variable. That variable is used in
a subsequent query expression. The first query expresion is not
evaluated until the second query expression is evaluated.

::

   local(qe = 
     with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
     select #n * #n
   )
   with newN in #qe
   select #newN * #newN

The resulting sequence from the above would be the numbers: *1, 16, 81,
256, 625, 1296, 2401, 4096, 6561*.

Do
--

A ``do`` clause permits a block of code to be executed for each element
that makes its way through the query expression. A do clause consists of
the word *do* followed by either a single expression or a code block
using either the regular curly bracketed form **{ }** or the auto-collect
curly bracketed form **{^ ^}**. If the code associated with a do consists of
more than one expression, the code must be surrounded by curly brackets.

The following examples show how the query expression do clause can be
used to manipulate the elements in the source array. Both query
expressions operate identically.

::

   local(ary = array('the', 'quick', 'brown', 'fox', 'jumped', 'the', 'shark'))
   
   with n in #ary
   do #n->upperCase

   with n in #ary
   do {
     #n->upperCase
   }

It is important to note that when using do the query is immediately
evaluated and that the query expression produces no result value. All
other query expression actions are evaluated lazily, only as needed, and
produce a result value dependent on the action in question.

The block of code given to a ``do`` remains attached to the surrounding
method context such that one could return or yield or access and create
local variables.

Sum
---

A ``sum`` clause is useful when adding all of the resulting query
expression elements together. A ``sum`` clause consists of the word
*sum* followed by a single expression. The result of the expression
will be the value used in the summation. The sum is performed using the
+ operator, so each element in the sequence must support the addition
operator for the sum to succeed. The result of a query expression using
sum will be a single value.

The following example uses a sum clause to add together each element
from the initial sequence, the resulting value being the integer 45.

::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   sum #n

Average
-------

An ``average`` clause produces the average of each element that makes
its way through the query expression. As expected, using average will
take the sum of each element and then divide that value by the number of
elements. As with sum, average produces a single result value.

::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   average #n

The result of the example above is the number 5.

Min & Max
---------

The ``min`` and ``max`` clauses produce only the smallest and largest
values from the sequence, respectively. The standard < and > operators
are used to find the result value.

::

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   min #n

   with n in array(1, 2, 3, 4, 5, 6, 7, 8, 9)
   max #n

The result of the first expression is the integer *1*. The result of the
second expression is the integer *9*.

Operations
==========

In a query expression, an operation is an optional clause that effects
the how the query expression behaves by removing elements from the
sequence, by ordering the elements in a certain manner, or by
introducing new variables.

Where
-----

A ``where`` operation lets elements be included or excluded from further
consideration based upon a boolean expression. A where operation will
generally run a test on the current element. If the test expression
results in false, the element is discarded and the next element is
selected and operated upon. If the test expression results in true, the
query expression proceeds with the next operation or action in the
expression.

A where operation is composed of the word *where* followed by a single
expression. The result of the expression should be boolean true or
false.

The following example performs a query expression using the numbers in
an array. The where operation filters out all even numbers, leaving only
odd numbers for the rest of the query expression. The local variable n
holds each number in turn as the expression is evaluated.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     where #n % 2 != 0 // ignore even numbers
   select #n

Multiple where operations can be utilized in a query expression. Using
multiple with operations is essentially the same as combining the
expressions using the && logical *and* operator. The following two
snippets are equivalent, though the third is not.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     where #n % 2 != 0 // ignore even numbers
     where #n % 3 != 0 // ignore numbers evenly divisible by 3
   select #n

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     where #n % 2 != 0 && #n % 3 != 0
   select #n

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     where #n % 2 != 0 || #n % 3 != 0
   select #n

Let
---

A ``let`` operation introduces a new variable into the query expression.
Usually, this is done when evaluating an expression whose value will be
be used repeatedly further throughout the query expression. For example,
a ``let`` operation may evaluate an expression based upon the current
iteration variable, assigning the result to a new variable, and then
using both further within the query.

Variables introduced within a ``let`` operation have the same scope as those
introduced in a with clause. That is, they exist only within the query
expression.

A let operation consists of the word *let* followed by a new variable
name, the = assignment operator, and then an expression, the result of
which the new variable will be assigned.

The following example snippet assigns the square of the current
iteration value to a new variable using a ``let`` operation.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     let n2 = #n * #n
   select #n2

The next example snippet uses both ``where`` and ``let`` together.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     let n2 = #n * #n // square the current value
     where #n2 % 2 != 0 // discard even values using the new variable
   select #n2

Skip
----

A ``skip`` operation permits a specified number of values from the
source sequence to be skipped. A ``skip`` operation consists of the word
*skip* followed by either a literal integer, or an expression which
will evaluate to an integer.

The following example snippet skips the first 5 elements from the source
container. Only the 6th element and beyond are sent to the remaining
portion of the query expression.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     skip 5
   select #n

Take
----

A ``take`` operation permits only a certain number of elements to be
iterated upon. Elements beyond the specified value are ignored and not
sent to the remainder of the query expression. A ``take`` operation consists
of the word *take* followed by a literal integer or an expression which
will evaluate to an integer.

The following example snippet takes only the first 5 elements from the
data source. The remaining elements are ignored.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     take 5
   select #n

``skip`` and ``take`` can be utilized together to limit the elements over which
a query expression will operate to a specific range. The order in which
``skip`` and ``take`` are specified is significant. Generally, ``skip`` is specified
before ``take``, though this is not a requirement.

The following example snippet skips the first 3 elements, takes only the
next 4 and leaves the rest ignored. This results in only the numbers 3,
4, 5 & 6 for the rest of the query expression.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     skip 3
     take 4
   select #n

The next example snippet shows how the ordering of ``skip`` and ``take`` are
important. This query expression takes only the first 4 elements of the
series, though the first 3 of them are skipped. The query after that
would produce the same result, but uses ``skip`` and ``take`` in the reverse
order.

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     take 4
     skip 3
   select #n

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     skip 3
     take 1
   select #n

In both of the above examples, only the value 3 is sent to the rest of
the query.

Order by
--------

Query expressions permit the elements of a series to be ordered in an
arbitrary manner by utilizing an ``order by`` operation. This is done by
using the words *order by* and then an expression, the result of which
is used as the value by which the particular element will be ordered.
This can be followed optionally by a direction indicator, which is the
word *descending* or *ascending*. When a direction is not indicated,
*ascending* order is assumed. Further ordering criteria can be
specified by following the initial order by expression with a comma, and
then the next ordering expression and optional direction indicator.

The following example snippet orders the elements in the array using the
default ascending order. The next, in descending order.

::

   with n in array(9, 2, 1, 3, 5, 4, 6, 7, 0, 8)
     order by #n
   select #n

::

   with n in array(9, 2, 1, 3, 5, 4, 6, 7, 0, 8)
     order by #n descending
   select #n

The expression provided to order by can be any arbitrary expression.
This permits elements to be ordered in any manner as desired by the
developer. For example, a series of string objects could be ordered
based upon their lengths, or elements could be randomly ordered based
upon a random number generated for this purpose.

::

   with n in array('the', 'quick', 'brown', 'fox', 'jumped', 'the', 'shark')
     order by #n->size
   select #n

::

   with n in array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
     order by integer_random(0, 99)
   select #n

In the next example snippet, a series of user objects, represented by
their first and last names, could be ordered in an alphabetical
manner.

::

   with n in array('Krinn'='Jones', 'Ármarinn'='Hammershaimb',
       'Kjarni'='Jones', 'Halbjörg'='Skywalker',
       'Björg'='Riley', 'Hjörtur'='Hammershaimb')
     order by #n->second, #n->first
   select #n

Group by
--------

A ``group by`` clause permits similar elements to be grouped together by
a particular key expression and represented as a single object called a
*queriable_grouping*. This new object can be further utilized
throughout the query expression. A queriable_grouping object maintains
a reference to each of the original elements within the group. It also
possesses a ->key() method which produces the value by which the
particular elements were mutually grouped.

A group by consists of three elements: the object going into the group,
the key by which the objects are grouped, and a new local variable name.
This new variable name will be introduced into the query expression for
further use and will be a ``queriable_grouping`` object. It has the
following form.

::

   group new_object_expression by key_expression into new_local_name

A group by operation makes most sense when used with other operations
and actions. The following example takes a series of users, represented
by first and last name, and performs a query expression over them.

::

   with n in array('Jones'='Krinn', 'Hammershaimb'='Ármarinn',
       'Jones'='Kjarni', 'Skywalker'='Halbjörg',
       'Riley'='Björg', 'Hammershaimb'='Hjörtur')
     let swapped = pair(#n->second, #n->first)
     group #swapped by #n->first into g
     let key = #g->key
     order by #key
   select pair(#key, #g)

The example above example breaks down into 6 steps:

#. Begin the query expression using #n as the variable to hold each
   initial element from the source array. There are 6 elements in the
   source array, so #n will start off pointing to the first element. Once
   the query expression completes its first iteration, #n will point to the
   second element and the query will perform another iteration, and so on,
   until the end of the array is reached.

   ::

      with n in array('Jones'='Krinn', 'Hammershaimb'='Ármarinn',
          'Jones'='Kjarni', 'Skywalker'='Halbjörg', 'Riley'='Björg',
          'Hammershaimb'='Hjörtur')

#. Create a new pair containing the swapped last and first names. Name
   this #swapped.

   ::

      let swapped = pair(#n->second, #n->first)

#. Group each of the new user pairs by last name. #n->second is used as
   the key. It still contains the original last name. From this point
   forward, no previously introduced variables are available. Only #g
   exists now. It will contain each ``queriable_grouping`` object generated by
   the group by clause at this step (3).

   ::

      group #swapped by #n->first into g

#. Access the grouping key for the current value of #g. Save it into #key.

   ::

      let key = #g->key

#. Order/sort the resulting grouping objects by #key, which contains the
   last name. Thus, all of the resulting group objects will come out of the
   query expression ordered alphabetically by last name.

   ::

      order by #key

#. Finally, create a new pair containing #key and the grouping object
   and select that, making the new pair one of the new elements in the
   result of the query expression.

   ::

      select pair(#key, #g)

The result of the example query expression looks as so. Notice how the
results for 'Hammershaimb' and 'Jones' each contain both of the users in
those groups.

::

   (Hammershaimb = (Ármarinn = Hammershaimb), (Hjörtur = Hammershaimb)),
   (Jones = (Krinn = Jones), (Kjarni = Jones)),
   (Riley = (Björg = Riley)),
   (Skywalker = (Halbjörg = Skywalker))

Making an Object Queriable
==========================

An object can be utilized in the with clause of a query expression if it
has the trait ``trait_queriable``. For this, an object must implement the
method ``->forEach()``. This method is always called with a givenBlock.
Within the ``->forEach()`` method, the object being queried should invoke
the givenBlock, passing it each available element in turn.

The following example implements a user list object. This object can be
used in queries. For the sake of this example, it permits iteration over
a fixed list of users, which it provides to the query one by one.

::

   // define the user_list type
   define user_list => type {
     trait { import trait_queriable }

     public forEach() => {
       local(gb = givenBlock)

       // provide the 6 users one at a time
       #gb->invoke('Krinn'='Jones')
       #gb->invoke('Ármarinn'='Hammershaimb')
       #gb->invoke('Kjarni'='Jones')
       #gb->invoke('Halbjörg'='Skywalker')
       #gb->invoke('Björg'='Riley')
       #gb->invoke('Hjörtur'='Hammershaimb')

     }
   }

   // create a user_list object
   local(ul = user_list)

   // use it in a query
   with user in #ul
   select #user->first
 
Above, the example code creates a ``user_list`` object and then uses it in
a simple query expression. The result of the expression is the sequence
of names: *Krinn, Ármarinn, Kjarni, Halbjörg, Björg, Hjörtur*.
