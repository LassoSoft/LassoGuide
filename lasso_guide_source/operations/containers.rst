.. _containers:

.. priorityQueue
   series
   treemap

**********
Containers
**********

Lasso provides a variety of ordered and unordered compound data types. These
objects contain zero or more other arbitrary objects. Built-in support is
provided for arrays, lists, maps and others.

Ordered Containers
==================

Ordered containers store their elements positioned by the order in which they
are inserted. The elements inserted first into an ordered container will always
be first unless subsequently repositioned.

Pair
----

.. class:: pair

   Pairs are one of the most basic of containers. A pair always contains two
   elements. These are referred to as the 'first' and 'second' elements and are
   accessed through methods of the same name.

Creating Pair Objects
^^^^^^^^^^^^^^^^^^^^^

.. method:: pair()
.. method:: pair(p::pair)
.. method:: pair(f, s)

   A pair is created in one of three ways. First, a zero parameter call to the
   pair method will generate a pair with the first and second values set to
   null. Second, a pair can be created by passing it another pair. This will set
   the first and second values to the values from the parameter pair. Third, a
   pair can be created by specifying the first and second values as parameters
   when calling the pair method.

Using Pair Objects
^^^^^^^^^^^^^^^^^^

.. method:: pair->first()
.. method:: pair->second()

   These methods are used to access the elements of a pair. They return the
   value stored within.

.. method:: pair->first = (f)
.. method:: pair->second = (s)

   These methods permit the elements of a pair to be set.

Array
-----

.. class:: array

   Array objects store zero or more elements and provide random access to those
   elements by position. Positions are 1-based integers. Arrays will grow as
   needed to accommodate new elements. Elements can be inserted and removed from
   arrays at any position, however, inserting an element anywhere but at the end
   of an array results in all subsequent elements being moved down. Thus, arrays
   are best used when inserting or removing only at the end of the array.

Creating Array Objects
^^^^^^^^^^^^^^^^^^^^^^

.. method:: array()
.. method:: array(e, ...)

An array can be created with zero or more parameters. All parameters passed to
the array method will be inserted into the new array.

Using Array Objects
^^^^^^^^^^^^^^^^^^^

.. method:: array->insert(v)
.. method:: array->insert(v, position::integer)

   These methods add  new elements to the array. The first method adds the
   element at the end of the array. The second method permits the position of
   the insert to be specified. Position 1 is at the beginning of the array.
   Positions zero and negative positions will cause the method to fail. A
   position larger than the size of the array will insert the element at the
   end.

.. method:: array->remove()
.. method:: array->remove(position::integer)
.. method:: array->remove(position::integer, count::integer)
.. method:: array->removeAll()
.. method:: array->removeAll(matching)

   These methods remove one of more elements from the array. Remove with no
   parameters removes the last element from the array. Remove with a position
   parameter will remove the element from that location. All subsequent elements
   must then be moved up to fill the slot. A second count parameter can be
   specified to indicate that more that one element should be removed, starting
   from the indicated position.

   The removeAll method with no parameters will remove all elements from the
   array. The second removeAll method takes one parameter. All elements in the
   array to which the parameter compares equally will be removed.

.. method:: array->get(position::integer)
.. method:: array->get(position::integer) = value
.. method:: array->sub(position::integer, count::integer=(self->size - #pos) + 1)

   The get method returns the element located at the indicated position. The
   method will fail if the position is out of range. This method also permits
   the element at the position to be set using assignment.

   The sub method returns a range of elements from the array. The first
   parameter indicates the starting position and the second parameter indicates
   how many of the elements to return.

.. method:: array->first()
.. method:: array->second()
.. method:: array->last()

   These methods return the first, second and last elements from the array,
   respectively. If the array does not have an element for that position, null
   is returned.

.. method:: array->contains(matching)::boolean
.. method:: array->count(matching)::integer
.. method:: array->findPosition(matching, startPosition=1)
.. method:: array->find(matching)

   These methods search the array for elements matching the parameter. The
   contains method returns true if the matching parameter compares equally to
   any contained elements. The count method returns the number of matching
   elements. The findPosition method returns the position at which the next
   matching element can be found. The optional second parameter indicates where
   the search should begin. The find method returns a new array containing all
   of the matched objects.

.. method:: array->size()::integer

   This method returns the number of elements in the array.

.. method:: array->sort(ascending::boolean=true)

   This method performs a sort on the elements. Elements are repositioned in
   either ascending or descending order depending on the given parameter.

.. method:: array->join(delimiter::string='')::string

   This method joins all the elements as strings with the delimiter parameter in
   between each.

Example of joining an array of numbers::

   array(1, 2, 3, 4, 5)->join(', ')
   // => 1, 2, 3, 4, 5

.. method:: array->asStaticArray()::staticarray

   This method returns the array's elements in a new staticarray.

.. method:: array->+(rhs::trait_forEach)::array

   Arrays can be combined with other compound types by using the + operator. A new
   array containing all the elements is returned.

Example of combining an array and a staticarray and a pair into a new array::

   array(1, 2, 3, 4, 5)
   + (:'6','7','8')
   + pair('nine', 'ten')
   // => array(1, 2, 3, 4, 5, 6, 7, 8, nine, ten)

Staticarray
-----------

.. class:: staticarray

   A staticarray is a container object that is not resizable. Staticarrays are
   created with a fixed size. Objects can be reassigned within the staticarray,
   but new positions can not be added or removed. Staticarrays are designed to
   be as efficient as possible both in the time used to create a new object and
   in the memory used for the object itself. The elements of a staticarray are
   accessed randomly, like an array, with 1-based positions.

   Lasso provides a shortcut for creating staticarray objects through the
   ``(:)`` syntax. This syntax begins with an open parenthesis immediately
   followed by a colon. Then follows zero or more elements, finalized by a close
   parenthesis.

Creating Staticarray Objects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Example of creating a few staticarrays::

   (:)
   // empty staticarray
   (:1, 2, 8, 'Hi!', pair(1, 2))
   // staticarray with variety of elements

.. method:: staticarray(...)
.. method:: staticarray_join(count::integer, e)

   The first method creates a new staticarray given zero or more elements. The
   second method, staticarray_join, creates a new staticarray of the given size
   with each element filled by the value given as the second parameter.

Using Staticarray Objects
^^^^^^^^^^^^^^^^^^^^^^^^^

.. method:: staticarray->get(position::integer)
.. method:: staticarray->get(position::integer) = value

   The get method returns the element at the indicated position. This method
   will fail if the position is out of range. The get method also permits the
   element to be reassigned.

.. method:: staticarray->first()
.. method:: staticarray->second()
.. method:: staticarray->last()

   The first, second and last methods return the corresponding element or null
   if there is no element at the position.

.. method:: staticarray->contains(matching)::boolean
.. method:: staticarray->findPosition(matching, startPosition=1)
.. method:: staticarray->find(matching)

   These methods search the staticarray for elements matching the parameter. The
   contains method returns true if the matching parameter compares equally to
   any contained elements. The findPosition method returns the position at which
   the next matching element can be found. The optional second parameter
   indicates where the search should begin. The find method returns a new array
   containing all of the matched objects.

.. method:: staticarray->join(count::integer, o)::staticarray
.. method:: staticarray->join(s::staticarray)::staticarray

   These methods combine the staticarray with other elements to create a new
   staticarray. The first method adds the number indicated by the first
   parameter of the second parameter into the new staticarray. The second method
   combines the staticarray with the parameter to produce a new staticarray
   containing the elements from both.

Example of joining new elements into a new staticarray::

   (:1, 2, 3)->join(5, 'Hi')
   // => staticarray(1, 2, 3, Hi, Hi, Hi, Hi, Hi)

.. method:: staticarray->sub(position::integer, count::integer=(self->size - #pos) + 1)::staticarray

   The sub method returns a range of elements. The first parameter indicates the
   starting position and the second parameter indicates how many of the elements
   to return. The elements are returned as a new staticarray object.

.. method:: staticarray->+(s::staticarray)::staticarray
.. method:: staticarray->+(o)::staticarray

   The + operator can be used with staticarrays to either add one new element or
   all the elements from another staticarray. Either variant will return the
   elements in a new staticarray object.

List
----

.. class:: list

   A list presents a series of objects stored in a linked manner. Elements can
   be efficiently added or removed from a list at the end or the beginning, but
   cannot be added into the middle. Lists do not support random access, so the
   only way to get particular elements from a list is through one of the
   iteration-related methods such as :ref:`query expressions
   <query-expressions>`.

Creating List Objects
^^^^^^^^^^^^^^^^^^^^^

.. method:: list(...)

   The list method creates a new list object using the parameters given as the
   elements for the list.

Using List Objects
^^^^^^^^^^^^^^^^^^

.. method:: list->insertFirst(e)
.. method:: list->insertLast(e)
.. method:: list->insert(e)

   These methods insert new elements into the list. Elements can be inserted at
   the beginning or the ending of the list. The insert method with no parameters
   inserts at the end of the list.

.. method:: list->removeFirst()
.. method:: list->removeLast()
.. method:: list->remove()

   These methods remove elements from the list. Either the first element or the
   last element can be removed. The remove method with no parameters removes the
   last element.

.. method:: list->removeAll()
.. method:: list->removeAll(matching)

   The first removeAll method with no parameters removes every element from the
   list. The second accepts a parameter which is compared against the elements.
   All matching elements are removed from the list.

.. method:: list->first()
.. method:: list->last()

   These methods returns the first and last elements, respectively.

.. method:: list->contains(matching)::boolean

   This method takes one parameter and compares it against the elements in the
   list. It returns true if the list contains a match.

Queue
-----

.. class:: queue

   Queue objects store data in a "first in, first out" (FIFO) manner. Elements
   can effeciently be inserted into the end of the queue (called pushing) and
   removed from the front of the queue (called popping). Queues do not support
   random access, so the only way to get particular elements from a queue is
   through one of the iteration-related methods such as :ref:`query expressions
   <query-expressions>`.

Creating Queue Objects
^^^^^^^^^^^^^^^^^^^^^^

.. method:: queue(...)

   This method creates a queue object using the parameters passed to it as the
   elements of the queue.

Using Queue Objects
^^^^^^^^^^^^^^^^^^^

.. method:: queue->insert(value)
.. method:: queue->insertLast(value)
.. method:: queue->insertFrom(value::trait_foreach)

   These methods insert new elements into the queue. Elements will always be
   inserted at the end of the queue. The ``queue->insertFrom`` method allows
   for multiple elements to be inserted into the queue by taking an object that
   implements ``trait_forEach``.

.. method:: queue->first()
.. method:: queue->get()

   These methods return the first element in the queue. The ``queue->get``
   method additionally removes the element from the queue.

.. method:: queue->size()

   This method returns the number of elements in the queue.

.. method:: queue->remove()
.. method:: queue->removeFirst()

   These methods remove the first element in the queue.

.. method:: queue->unspool(n::integer= ?)

   This method returns a staticarray of the elements in the queue and removing
   them from the queue. The number of elements to return and remove can be
   specified as an integer parameter to this method.


Stack
-----

.. class:: stack

   Stack objects store data in a "last in, first out" (LIFO) manner. Elements
   can effeciently be inserted onto the beginning of the stack (called pushing)
   and removed from the top of the queue (called popping). Stacks do not support
   random access, so the only way to get particular elements from a stack is
   through one of the iteration-related methods such as :ref:`query expressions
   <query-expressions>`.

Creating Stack Objects
^^^^^^^^^^^^^^^^^^^^^^

.. method:: stack(...)

   This method creates a stack object using the parameters passed to it as the
   elements of the stack.

Using Stack Objects
^^^^^^^^^^^^^^^^^^^

.. method:: stack->insert(value)
.. method:: stack->insertFirst(value)

   These methods insert new elements into the stack. Elements will always be
   inserted at the beginning of the stack.

.. method:: stack->first()
.. method:: stack->get()

   These methods return the first element in the stack. (This is the most
   recently inserted element.) The ``stack->get`` method additionally removes
   the element from the stack.

.. method:: stack->size()

   This method returns the number of elements in the stack.

.. method:: stack->remove()
.. method:: stack->removeFirst()

   These methods remove the first element in the stack. (This is the most
   recently inserted element.)


Unordered Containers
====================

Unordered containers store their elements in a manner where there is no position
based ordering. Lasso supports two unordered container types: map and set. Maps
provide access to the elements via separate keys. Sets store only the elements
themselves.

Map
---

.. class:: map

   Maps are used to store values along with associated keys. An element can
   later be found given the key value it was inserted with. New elements can be
   inserted or removed freely from a map. Only one element can be stored for any
   given key and inserting a duplicate key will replace any existing element.

   The keys used in a map can be of any type, provided that type has a suitable
   onCompare method. Keys must compare themselves consistently such that if ``A
   < B`` then always ``B >= A``. Most Lasso builtin types, such as strings,
   integers and decimals, fit this criteria.

Creating Map Objects
^^^^^^^^^^^^^^^^^^^^

.. method:: map(...)

   A map is created with zero or more key/value pair parameters. Any non-pair
   parameters given are inserted as a key with a null value.

Example of creating a map with a series of parameters using string based keys::

   local(myMap = map(
      'C' = 247,
      'L' = 'Hi!',
      'G' = 97.401,
      'N' = array(4, 5, 6)
   )

Using Map Objects
^^^^^^^^^^^^^^^^^

.. method:: map->insert(p::pair)

   This method inserts a new key/value pair into the map. Any already existing
   duplicate key is replaced.

.. method:: map->remove(key)
.. method:: map->removeAll()

   The first method, remove, removed the indicated key/value from the map. If
   the key does not exist in the map then no action is taken. The second method,
   removeAll, removes all of the key/values from the map.

.. method:: map->get(key)
.. method:: map->get(key) = value
.. method:: map->find(key)
.. method:: map->contains(key)::boolean

   These methods get particular elements from the map or test that a key is
   contained within the map. The get method finds the element within the map
   associated with the key and returns the value. If the key is not found the
   method will fail. The find method will search for the key within the map and
   return the value if it exists. If the key is not found the method will return
   void. The contains method returns true if the matching parameter compares
   equally to any contained elements.

.. method:: map->size()::integer

   This method returns the number of elements contained within the map.

Set
---

.. class:: set

   A set contains a within it only unique elements. Each element is itself a
   key. Sets support quickly determining if an object is contained within in.
   Elements within a set must be able to onCompare themselves just as described
   for map keys.

Creating Set Objects
^^^^^^^^^^^^^^^^^^^^

.. method:: set(...)

   A set is created with zero or more elements parameters. The element values are
   inserted into the set.

Using Set Objects
^^^^^^^^^^^^^^^^^

.. method:: set->find(k)
.. method:: set->get(k)
.. method:: set->contains(k)::boolean

   These methods find the given key within the set. The find method will return
   the key if it is found. It returns void if the key is not within the set. The
   get method will return the key, but will fail if the key is not contained
   within the set. The contains method returns true if the key is in the set.

.. method:: set->insert(k)

   This method inserts the key into the set. Any duplicate key value is
   replaced.

.. method:: set->remove(k)
.. method:: set->removeAll()

   The remove method removes the indicated key from the set. If the key is not
   contained within the set then no action is taken. The removeAll method
   removes all keys from the set.
