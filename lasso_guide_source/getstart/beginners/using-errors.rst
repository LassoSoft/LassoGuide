.. _using-errors:

****************************
Throwing and Handling Errors
****************************

When Lasso code encounters a problem, it throws an error. Part of learning to
code well is knowing when you should have your code explicitly throw an error,
and learning when you should be able to gracefully handle an error that has been
thrown.

Let's continue with our ongoing code example. Currently we accept any integer
value for the hour. It could be -5 or 42. Since a 24-hour clock runs from 0-23,
we should probably make sure that our ``time_of_day`` type only accepts those
values.

.. note::
   For detailed documentation on error handling in Lasso be sure to read
   :ref:`the Error Handling chapter <error-handling>` in the Language Guide.


Throwing an Invalid Value Error
===============================

The code below updates our ``time_of_day`` custom data type to ensure that it
is always passed a valid hour. Before these changes, the following code samples
would both "work"::

   // creator method with invalid data
   time_of_day(77)

   // setter method for "hour" data member
   time_of_day->hour(89)

With the updated code below, both of these examples will now fail, throwing an
error about invalid values.

::
   
   define time_of_day => type {
      data public hour::integer
      
      data private time_info = map(
         `morning`   = map('greeting' = "Good Morning!"  , "bgcolor" = "lightyellow"),
         `afternoon` = map('greeting' = "Good Afternoon!", "bgcolor" = "lightblue"),
         `evening`   = map('greeting' = "Good Evening!"  , "bgcolor" = "lightgray")
      )

      public onCreate(datetime::date=date) => .onCreate(datetime->hour)
      public onCreate(hour::integer) => {
         .hour = #hour
      }

      public hour=(rhs::integer) => {
         if(#rhs < 0 or #rhs > 23) => {
            fail(error_code_invalidParameter, error_msg_invalidParameter + ': hour must be between 0 and 23')
         }

         .'hour' = #rhs
         return #rhs
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

This new type definition has two changes.

The biggest is the addtion of the ``time_of_day->hour=`` method. The code starts
with ``public hour=(rhs::integer) => {``. This method overrides the current
public setter method for the hour data member. All setter methods end with an
equal sign in their name and take at least one parameter which is the new value
to use. This is the method that would get called with the following code::

   local(example) = time_of_day
   #example->hour = 9      // Calling the setter method

In this example, "9" would be the value in the ``#rhs`` local variable sent to
the setter. This new setter method first checks that the value is between 0 and
23 before proceding. If the value is not between that time, it calls ``fail``
with an error code and an error message. The code can be any integer value. We
are using ``error_code_invalidParameter`` which is a method that returns the
integer value that Lasso has set as the standard for use when a bad value in a
parameter is encountered. The error message can be any string, and we're using
``error_msg_invalidParameter`` to get the standard error message for a bad value
in a parameter and then concatenate on a message that's a little more specific
to help programmers fix their code.

The other change we made is harder to notice. In the ``onCreate(hour::integer)``
method, we changed the code from ``.'hour' = #hour`` to ``.hour = #hour``. This
small change (removing the quotes around ".hour") has the code use the new
public setter method instead of setting the data member directly. (The new
setter method must still set the data member directly. If it didn't, we would be
stuck in an infinite loop as it kept calling itself.)


Basic Error Handling
====================

Occaisonally there are times when we know that code we write might fail, and we
want to gracefully handle the error. In these cases, we wrap the code that could
fail in a ``protect`` block and use either ``handle`` or ``handle_error`` to
deal with any cleanup.

We're going to update our page code with a bit of a contrieved example. In the
new code, I'm going to create a ``time_of_day`` object based on a random number
between 0 and 25. This will fail for 24 and 25, so I'm going to wrap the code in
a ``protect`` block and have it default to midnight (0) if there are any errors.

::

   
   <?lasso
      local(time_of_day)
      protect => {
         handle_error => {
            #time_of_day = time_of_day(0)
         }

         #time_of_day = time_of_day(math_random(0, 25))
      }
   ?>
   <html>
      <body style="background-color: [#time_of_day->bgcolor]">
         [#time_of_day->greeting] I am an HTML document.
      </body>
   </html>

The code that's wrapped inside the ``protect`` block is not only the code that
may fail, but also the code that runs if there's an error (the ``handle_error``
block). It's important that any ``handle_error`` or ``handle`` code be written
above the code that may fail, otherwise those handlers will not be registered to
be called when a problem occurs.

And that's the basics of creating and handling errors. To learn more, please
read :ref:`the Error Handling chapter <error-handling>` in the Language Guide.

:ref:`Next Tutorial: Inspecting Browser Request Data <using-web-request>`