.. _define-your-types:

***********************
Defining Your Own Types
***********************

Lasso is an object-oriented language and comes with many bultin-types. In fact,
we've been using the ``date`` type to get the current hour in our ongoing
example as well as ``integer``, ``string``, ``array``, and ``map`` types. Lasso
also gives programmers the ability to write their own custom data types.

Let's look at the current version of our ongoing example::

   <?lasso
      local(time_info) = map(
         `morning`   = map('greeting' = "Good Morning!"  , "bgcolor" = "lightyellow"),
         `afternoon` = map('greeting' = "Good Afternoon!", "bgcolor" = "lightblue"),
         `evening`   = map('greeting' = "Good Evening!"  , "bgcolor" = "lightgray")
      )
      local(time_of_day) = #time_info->find(time_of_day)
   ?>
   <html>
      <body style="background-color: [#time_of_day->find('bgcolor')]">
         [#time_of_day->find('greeting')] I am an HTML document.
      </body>
   </html>

We have encapsulated the logic of determining whether it is morning, afternoon,
or evening into the method ``time_of_day``, so now we can easily use that logic
anywhere, and, if need be, we can easily change the logic by editing the code in
one place. However, the greeting and background color associated with the time
of day are only on this page. What if we want to be able to have the correct
greeting and background color for the time of day wherever we are. We could copy
the "time_info" map everywhere we want it, but then we're making the code hard
to change in the future. This is where a data type would be handy.

.. note::
   For detailed documentation on creating custom Lasso types be sure to read
   :ref:`the Types chapter <types>` in the Language Guide.


Example Using a Custom Type
===========================

We want the time of day to have more properties then just whether it is morning,
afternoon, or evening — we now want it to also have a greeting and a background
color. Below is an example of creating a custom data type to fulfill this
requirement as well as an updated version of our page to use this custom type::

   // Custom Type in LassoStartup
   define time_of_day => type {
      data public hour::integer
      
      data private time_info = map(
         `morning`   = map('greeting' = "Good Morning!"  , "bgcolor" = "lightyellow"),
         `afternoon` = map('greeting' = "Good Afternoon!", "bgcolor" = "lightblue"),
         `evening`   = map('greeting' = "Good Evening!"  , "bgcolor" = "lightgray")
      )

      public onCreate(datetime::date=date) => .onCreate(datetime->hour)
      public onCreate(hour::integer) => {
         .'hour' = #hour
      }

      public greeting => {
         return .'time_info'->find(.asString)->find('greeting')
      }

      public bgColor => .'time_info'->find(.asString)->find('bgcolor')

      public asString => {
         if(.hour >= 5 and .hour < 12) => {
            return 'morning'
         else(.hour >= 12 && .hour < 17)
            return 'afternoon'
         else
            return 'evening'
         }
      }
   }

   // The Code for the Page
   <?lasso
      local(time_of_day) = time_of_day
   ?>
   <html>
      <body style="background-color: [#time_of_day->bgcolor]">
         [#time_of_day->greeting] I am an HTML document.
      </body>
   </html>

Once again, the code for the page will be in a page in your webroot, but the
code for the type should be in a file residing in the LassoStartup folder of the
Lasso instance's home folder and having a name ending with ".lasso" or ".inc".


Code Walk-through
=================

The code starts with the ``define`` keyword followed by the name of the custom
type we are defining, then the associate operator ("=>"), the ``type`` keyword
to specify this is a type definition, and then an open brace. This line of code
to the matching closing brace at the end is known as the "type definition". This
opening line tells Lasso that we are defining a type named "time_of_day".

There are two basic things defined in the type definition: data members and
methods (sometimes called "member methods" as they are members of the type).

The code above defines two data members: "hour" and "time_info". This is done
using the ``data`` keyword, an optional access level keyword (``public``,
``private``, or ``protected``), and then the name for the data member. Notice
that the "hour" data member has a type constraint specifying that only integer
values can be stored in it. Also notice that I use the assignment operator ("=")
to assign a starting value to "time_info".

The access level keywords are used to specify who has access to retrieve and
store data in the data member through getter and setter methods respectively.
Public data members have getter and setter methods that can be called in any
context. Private data members have getter and setter methods that can only be
called within the type's own member methods. The getter and setter methods for
protected data members can only be called by the type's member methods and by
member methods of any types that inherit from this type. (Type inheritance is
beyond the scope of this tutorial.)

Next come the member method definitions. These are exactly like standard method
definitions, but instead of starting with the ``define`` keyword, they start
with one of the access level keywords (``public``, ``private``, ``protected``).
Just like with data members, this specifies where these methods can be called.
(In our example, all the member methods are ``public`` and may therefore be
called from anywhere.)

First, we use multiple dispatch to create two ``time_of_day->onCreate`` methods
which mirror the two methods we created in the methods tutorial. The first one
may look unusual as it doesn't have any braces. If the method can be written in
a single expression whose value you want to return, then you don't need the
braces. The code above is equivallent to writing::

   public onCreate(datetime::date=date) => {
      return .onCreate(datetime->hour)
   }

The "onCreate" method is a special method for types. They define type creator
methods that are used to create intances of your type (also called "objects").
With the ``time_of_day->onCreate`` methods above, we have defined two different
type creator methods, one that can be called like this::

   time_of_day       // no parameters
   time_of_day(date) // any date object as a parameter

And one that can be called with an integer::

   time_of_day(14)   // any integer parameter for the hour

Note that since a type creator method is always called to create the object, we
could have put the code setting the map for "time_info" inside the "onCreate"
method. Also note that it is best practice to have one "onCreate" method that
does all the setup work that all the other "onCreate" methods call. (Don't
repeat yourself!)

Next are the methods for getting the greeting and the background color — they
simply use the map in the ``item_info`` data member to return the correct value.
As the initial key into the map, they use the value returned by the
``time_of_day->asString`` method.

The ``time_of_day->asString`` method contains the logic for determining if the
hour is morning, afternoon, or evening. We named the method "asString" because
that method name has special significance for Lasso. Lasso implicitly calls this
method if a statement contains nothing but an object or type creator method. For
example::

   time_of_day(15)
   // => afternoon

If we did not define our own "asString" method, the default is to just return
the name of the type, so the above example would return "time_of_day" instead of
"afternoon".

The code on the page starts by instantiating a ``time_of_day`` object with the
current time into a local variable named "time_of_day". It then uses this object
to get the correct background color and greeting on the page by calling the
corresponding member methods using the target operator ("->") followed by the
name of the method.

The result is that we now have a custom type we can use on any page to get the
time of day as well as the appropriate greeting and background color for that
time of day. For in-depth documentation on types, see
:ref:`the Types chapter <types>` in the Language Guide.

:ref:`Next Tutorial: Throwing and Handling Errors <using-errors>`