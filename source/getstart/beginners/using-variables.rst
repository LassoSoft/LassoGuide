.. _using-variables:

***************
Using Variables
***************

You wouldn't be able to get very far in programming without using variables.
Variables allow programmers to create a named reference to data they want to
reference later.

In Lasso, variables come in two flavors: local and thread. The main difference
between these two types of variables is the scope they operate in (meaning where
you can reference them after they are created). In general, local variables can
only be referenced inside the method they were created in or on the same page
they were created in while thread variables can be referenced anywhere. (This
description is not strictly accurate, but more of a general guideline for our
purposes in this tutorial.)


Using Variable For date->hour
=============================

Here is our original example from the previous page::

   <html>
      <body>
      [if(date->hour >= 5 and date->hour < 12)]
         Good Morning! I am an HTML document.
      [else(date->hour >= 12 && date->hour < 17)]
         Good Afternoon! I am an HTML document.
      [else]
         Good Evening! I am an HTML document.
      [/if]
      </body>
   </html>

If you notice, we call the ``date->hour`` method a number of times. Each time we
are getting a different result. It may be that it is returning the same value,
but it's a new copy of that value each time. It would be more efficient to get
that value once, store it in a variable, and reference that value when needed::

   <html>
      <body>
      [local(hour) = date->hour]
      [if(#hour >= 5 and #hour < 12)]
         Good Morning! I am an HTML document.
      [else(#hour >= 12 && #hour < 17)]
         Good Afternoon! I am an HTML document.
      [else]
         Good Evening! I am an HTML document.
      [/if]
      </body>
   </html>

The example above first stores the value of ``date->hour`` in a local variable
named "hour" and then references that value using ``#hour`` in the ``if`` and
``else`` statements. One of the other benefits here is that if I want to use a
different value, I only have to change one ``date->hour`` to the new value I
want to use. In general, it is a good idea to use a variable if you are going to
reference the same value more than once.


Using a Variable for the Greeting
=================================

Another good use for variables is to help us separate view code from logic code.
It is best practice to separate logic code from view code to keep the code easy
to read and easy to update and maintain. In our example, what happens if we need
to change "I am an HTML document": we have to make the changes in three places!
If the change involves more logic code, that means the same group of code has to
be written in three places. If a change is needed to that group of code, we have
to make sure we make the same change in all three places. This leads to a
maintenance nightmare.

Let's look at how we can use a variable to keep our code clean and maintainable.
In the example below, I'm going to put the logic code first and then follow it
up with the view code to create the HTML document. The logic code will be
delimited by the ``<?lasso ... ?>`` delimiter instead of the ``[ ... ]``
delimiter::

   <?lasso
      local(hour) = date->hour
      local(greeting)

      if(#hour >= 5 and #hour < 12)
         #greeting = "Good Morning!"
      else(#hour >= 12 && #hour < 17)
         #greeting = "Good Afternoon!"
      else
         #greeting = "Good Evening!"
      /if
   ?>
   <html>
      <body>[#greeting] I am an HTML document.</body>
   </html>

Now I have added a variable named "greeting" that gets set to a string with the
proper greeting using our logic from before. I then use the "greeting" variable
in the view code to have the HTML document display the proper greeting.

.. seealso::
   For detailed documentation on variables, see the :ref:`variables` chapter.
