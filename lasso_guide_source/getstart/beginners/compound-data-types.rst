.. _using-compound-data-types:

*************************
Using Compound Data Types
*************************

As our code gets more and more complex, we may decide that it's a good idea to
store related values together. For example, we may decide we want to bundle
together the greetings and store them all in one place. We can do this using a
compound data type.

Compound data types are values that can hold multiple different values. In the
example on the previous page, we store an integer of the current hour into one
variable and a string of the greeting we are going to use in another. We could,
however, store them in the same variable by using a compound data type.

.. note::
   For more information on various compound data types available in Lasso, see
   the :ref:`containers` chapter.


Using an Array
==============

One compound data type we could use is an :type:`array`. Arrays allow storing as
many items as you want inside one array. You can even store an array inside
another array.

Values in an array are stored and retrieved by their position in the array
(called their index). The first item in an array has an index of "1", the second
an index of "2", and so on.

Let's take a look at how to create and get values out of an array with an
updated version of our ongoing example::

   <?lasso
      local(hour) = date->hour
      local(all_greetings) = array("Good Morning!", "Good Afternoon!", "Good Evening!")
      local(greeting)

      if(#hour >= 5 and #hour < 12)
         #greeting = #all_greetings->get(1)
      else(#hour >= 12 && #hour < 17)
         #greeting = #all_greetings->get(2)
      else
         #greeting = #all_greetings->get(3)
      /if
   ?>
   <html>
      <body>[#greeting] I am an HTML document.</body>
   </html>

Notice how we set the initial values for the array and store the array in the
local variable "all_greetings" by calling `array` with a comma-separated list
of values. In our example, the values are all strings, but the values don't have
to all be the same type, you could mix strings and integers, for example.

We retrieve values from the array by calling `array->get` and passing it the
index we are looking for. For example, when we want "Good Morning!", the code
above passes "1" (``#all_greetings->get(1)``). This is another example of
calling a member method on an object. We stored an ``array`` object into the
"all_greetings" variable and then interacted with it using that object's method
named "get".

If we wanted to add things to the end of the array, we could do so by passing
the value we want to add to the `array->insert` method. For the array object
stored in the "all_greetings" variable, it would look like this::

   #all_greeting->insert("G'day, mate!")

(See the section on the :ref:`array <containers-array>` type for more detail and
other :type:`array` methods.)


Using a Map
===========

An array stores items by position, but sometimes it's useful to store items by
an arbitrary key, and that's where the ``map`` compound data type is useful.

Below is our example again, this time modified to use a map to store all the
greetings::

   <?lasso
      local(hour) = date->hour
      local(all_greetings) = map(
         `morning`   = "Good Morning!",
         `afternoon` = "Good Afternoon!",
         `evening`   = "Good Evening!"
      )
      local(greeting)

      if(#hour >= 5 and #hour < 12)
         #greeting = #all_greetings->find('morning')
      else(#hour >= 12 && #hour < 17)
         #greeting = #all_greetings->find('afternoon')
      else
         #greeting = #all_greetings->find('evening')
      /if
   ?>
   <html>
      <body>[#greeting] I am an HTML document.</body>
   </html>

We create a map much the same way an array is created, with a comma-separated
list of values, but with a map we specify the index (key) as well. To get an
item out of a map, use the `map->find` method passing in the key whose value you
wish to retrieve. As with arrays, there's a `map->insert` method that allows you
to insert new key/values into the map. (See the section on the
:ref:`map <containers-map>` type for more information.)

.. note::
   While arrays have a defined order, maps do not. Getting an element out of a
   map by index does not have a well-defined result. There is no first, second,
   or *n*\ th element in a map, so don't create code that relies on map order,
   as it could change.


Using a Map of Maps
===================

It is a common scenario where using nested compound data types makes sense.
Let's expand our example to change the background color of our web page
depending on the time of day. We'll add the color information to our existing
map::

   <?lasso
      local(hour) = date->hour
      local(time_info) = map(
         `morning`   = map('greeting' = "Good Morning!"  , "bgcolor" = "lightyellow"),
         `afternoon` = map('greeting' = "Good Afternoon!", "bgcolor" = "lightblue"),
         `evening`   = map('greeting' = "Good Evening!"  , "bgcolor" = "lightgray")
      )
      local(time_of_day)

      if(#hour >= 5 and #hour < 12)
         #time_of_day = #time_info->find('morning')
      else(#hour >= 12 && #hour < 17)
         #time_of_day = #time_info->find('afternoon')
      else
         #time_of_day = #time_info->find('evening')
      /if
   ?>
   <html>
      <body style="background-color: [#time_of_day->find('bgcolor')]">
         [#time_of_day->find('greeting')] I am an HTML document.
      </body>
   </html>

The variable "time_info" holds a map where each key in the map is associated
with another map. This means that when we look up the key for the variable
"time_of_day", it is set to a map with a "greeting" key and a "bgcolor" key. We
then use the map stored in "time_of_day" to get the background color and the
greeting for the current time of day. For extra credit, change this solution to
use an array of maps instead.

Next Tutorial: :ref:`define-your-methods`
