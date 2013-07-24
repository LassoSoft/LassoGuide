.. _using-logic:
.. http://www.lassosoft.com/Tutorial-Using-Logic

***********
Using Logic
***********

Programming logic is used to control the flow of your code. It allows you to
create programs that have different results depending on what inputs the program
is given. It's sort of like a
`"Choose Your Own Adventure" <http://en.wikipedia.org/wiki/Choose_Your_Own_Adventure>`_
book that has different endings depending on what actions you choose for the
character.

.. note::
   For more information on logic expressions, see the chapter on
   :ref:`Conditional Logic <conditional-logic>`


Basic If/Else Statement
=======================

Using our previous example, let's say we wanted to change the text to display
"Good Morning" if a browser retrieves the document in the morning and "Good
Afternoon" when a browser retrieves the documents in the afternoon. The
following code uses an ``if`` statement and an ``else`` statement to accomplish
this::

   <html>
      <body>
      [if(date->hour < 12)]
         Good Morning! I am an HTML document.
      [else]
         Good Afternoon! I am an HTML document.
      [/if]
      </body>
   </html>

The Lasso code checks to see if the current hour is before noon (``date`` uses
24-hour time) and displays "Good Morning!" if it is, otherwise (``else``), it
displays "Good Afternoon!".


Example of If/Else If/Else Statement
====================================

Let's say we want to expand our example to say "Good Evening!" as well. The
example below defines morning as the hours between 5:00 AM and noon, afternoon
as the hours between noon and 5:00 PM, and the evening as everything else::

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

A couple of things to not about this code. First, the use of ``and`` in the
opening ``if`` statement. This is called a boolean operator or logic operator —
it requires that both the expression to its left and to its right evaluate as
"true". In our case it means that the current hour has to be greater than or
equal to 5 as well as less than 12. You will sometimes see it as ``&&`` instead
of ``and`` as in the first ``else`` statement. (See the section on
:ref:`logic operators <logic-operators>` for more information on all the
available boolean operators.)

The other thing to note is the first ``else`` statement takes an expression in
parantheses. This is known as an "else if" statement, and it allows for
specifying an additional condition that needs to be met for the code inside it
to be executed. The first conditional is that the ``if`` statement was not met,
and then it will evaluate the ``else``'s conditional statement to see if it is
met. If it's not, the code will continue to the ``else`` statement (if any) and
execute the code inside it. You can have multiple "else if" statements before an
optional final ``else``.

So the example page above will say "Good Evening!" from 5 PM - 4:59 AM, "Good
Morning!" from 5 AM - 11:59 AM, and "Good Afternoon!" from 12 PM - 4:59 PM.

:ref:`Next Tutorial: Using Variables <using-variables>`