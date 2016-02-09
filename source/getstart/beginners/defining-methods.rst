.. _defining-methods:

*************************
Defining Your Own Methods
*************************

In the tutorial on variables, we discussed how variables allow for storing a
value that can then be referenced later. But wouldn't it be nice to be able to
store a set of logic code for later re-use? That's where defining your own
methods come in.

.. note::
   For detailed information on method definitions and multiple dispatch, be sure
   to read the :ref:`methods` chapter after reading through this tutorial.


Basic Method Definition
=======================

Here's the latest iteration of our ongoing example::

   <?lasso
      local(hour) = date->hour
      local(time_info) = map(
         `morning`   = map('greeting'="Good Morning!",   'bgcolor'='lightyellow'),
         `afternoon` = map('greeting'="Good Afternoon!", 'bgcolor'='lightblue'),
         `evening`   = map('greeting'="Good Evening!",   'bgcolor'='lightgray')
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

Let's suppose that we had the need to be able to tell the current time of day
(morning, afternoon, evening) on multiple pages. We could repeat our ``if``
statement on those pages, but what if our definition of when evening starts or
ends changes? We would have to find and adjust this logic on all the pages that
have it.

Instead, let's create a method we can call on each of the pages that returns the
current time of day. That way if we need to adjust the time, we only have one
place we need to adjust the code::

   define time_of_day => {
      local(hour) = date->hour

      if(#hour >= 5 and #hour < 12) => {
         return 'morning'
      else(#hour >= 12 && #hour < 17)
         return 'afternoon'
      else
         return 'evening'
      }
   }

The first line contains the ``define`` keyword followed by the name for the
method followed by the association operator (``=>``) and an open brace. All the
code between that open brace and its matching closing brace is associated with
the method and executed when the method is called. The ``return`` statement in a
method tells it to stop executing its code and return the value to the method's
caller. In this case, we'll be returning either "morning", "afternoon", or
"evening".

We could put this method definition inside the ``<?lasso ... ?>`` delimiter on
our page, but then it would be redefined each time that page is called, and if
that page hasn't been called but a different page tried to invoke the method,
Lasso wouldn't be able to find it. For these reasons, it's best to put method
definitions like this in a file whose name ends with either "|dot| lasso" or
"|dot| inc" and place that file in "LassoStartup" in your instance's home
directory. Those files get run when Lasso starts up which means the method will
then be loaded and ready for use on any page.

Our page can then use the method in the following fashion::

   <?lasso
      local(time_info) = map(
         `morning`   = map('greeting'="Good Morning!",   'bgcolor'='lightyellow'),
         `afternoon` = map('greeting'="Good Afternoon!", 'bgcolor'='lightblue'),
         `evening`   = map('greeting'="Good Evening!",   'bgcolor'='lightgray')
      )
      local(time_of_day) = #time_info->find(time_of_day)
   ?>
   <html>
      <body style="background-color: [#time_of_day->find('bgcolor')]">
         [#time_of_day->find('greeting')] I am an HTML document.
      </body>
   </html>


Method Definition with Arguments
================================

There may be times when it would be useful to pass data into a method for it to
work with. For example, instead of using the current time, we may want to modify
our ``time_of_day`` method to take a date object and return the time of day
based on the specified time::

   define time_of_day(datetime) => {
      local(hour) = #datetime->hour

      if(#hour >= 5 and #hour < 12) => {
         return 'morning'
      else(#hour >= 12 && #hour < 17)
         return 'afternoon'
      else
         return 'evening'
      }
   }

Here, in the method signature, we've added "(datetime)" after the method name.
This specifies that the method will now take one parameter (also called an
argument) with the name of "datetime". This parameter is setup as a local
variable in our method which allows us to set the "hour" local variable to the
hour of the date object passed to the method. (If you've made changes to the
startup file, you'll need to restart Lasso for the new definition to load.)

There is one problem, however; our current code for the HTML page won't work
because it doesn't pass any parameters to the ``time_of_day`` method. We could
fix this by changing it to use ``time_of_day(date)``, but a better solution
might be to make the argument an optional parameter by giving it a default
value::

   define time_of_day(datetime=date) => {
   // ... rest of method definition ...

By placing an equals sign after "datetime" followed by an expression we have
made it an optional parameter whose default value is determined by the
expression. In this case, if no parameters are passed to ``time_of_day``, the
"datetime" variable will be set to the current date and time by the `date`
method.


Method Definition and Multiple Dispatch
=======================================

Lasso also has an amazing feature called multiple dispatch. With multiple
dispatch, you can have two methods with the same name but with different
signatures that execute different code. Lasso uses the signatures to figure out
which method to call.

This can be useful in our example because we may want to have one method named
"time_of_day" that returns the time of day based on a date object and another
method named "time_of_day" that returns the time of day based on an integer
passed to it::

   define time_of_day(datetime::date=date) => {
      return time_of_day(#datetime->hour)
   }
   define time_of_day(hour::integer) => {
      if(#hour >= 5 and #hour < 12) => {
         return 'morning'
      else(#hour >= 12 && #hour < 17)
         return 'afternoon'
      else
         return 'evening'
      }
   }

Here I am defining two methods, both with the name "time_of_day". The first
method has a signature of "time_of_day(datetime::date=date)". All that has been
added from the previous definition is the type constraint "::date". This method
can be called without a parameter and "datetime" will default to the current
date and time, but with the type constraint the method can only be called with a
date object. The following method calls will call this method::

   time_of_day          // Can be called with no parameters
   time_of_day(date)    // Any date object will do

The second method has the following signature: "time_of_day(hour::integer)". The
hour parameter has been constrained to only take integer values. Also, there is
no default value for "hour", so a parameter must be provided to call this
method. The following method calls will invoke this method::

   time_of_day(19) // Any integer will do

Notice that all the first method does is return the value of invoking the second
method. Once again, it's better not to have the same code in multiple places.
Now any changes to the logic can again be made in only one place.

For detailed information on method definitions and multiple dispatch, be sure to
read the :ref:`methods` chapter.
