.. _whatis:
.. http://www.lassosoft.com/Tutorial-What-is-Lasso

**************
What is Lasso?
**************

Lasso is a dynamic scripting language designed for creating dynamic, data-driven
websites. Lasso gives website pages the ability to be dynamic by integrating
with a web server to create the content of the pages on-the-fly, pages which are
then sent to a Web browser.

HTML
====

A web page is really just a text document, like a Microsoft Word document or a
PDF. When you open up a PDF to look at it, the PDF reader on your computer takes
the code which makes up the document and paints it on the screen to make it
readble for you.

In the same way a Web browser on your computer (like Safari or Chrome or
Internet Explorer) takes a document and displays. When you request a web page,
your computer goes out to the Internet and requests a document to be read. These
documents are typically made with a specific set of descriptive wrappers, called
"HTML", which define what and where things should be placed on the page.

Body Tag
--------

If you take some basic text, and put it into a text document, you can open up
that document with a browser and see your text. In this example, we'll include
the "body tag", as it defines what should be in the body of the visible portion
of the page in an HTML document:: 

   <html>
      <body>Hello! I am an HTML document</body>
   </html>

This would look like this in your browser:

Hello! I am an HTML document


Dealing with Dynamically Changing Content
=========================================

However, websites these days are much more dynamic and have constantly changing
information and content. This isn't magic - your server must do the lifting for
you. Here is a simple example:

Current Date Example
--------------------

Let's say you wanted your document to show the current date. One inefficient way
to do this would be to open your HTML document every day and manually change the
date in your document. Then, when anyone viewed your document, they would get
the correct date on your web page. Doing this would be an inefficient use of
your time when you could use the server to do it automatically for you.

One way to have the server automatically update the date for you would be to
write a script to open up the document every day and change the date for you.
This works great until you want to show something more granular like seconds.
Then you would have to open the document every second and change it. This
wouldn't just be inefficient for a human, but inefficient for a server —
especially if the web site has many pages that might need updating.

Instead, you can use Lasso to dynamically insert the date for you, whenever
the page is requested by a browser. Here is how you would do it.

Create a file named "index.lasso" inside the webroot for your website. Place the
following code in that document::

   <html>
      <body>Hello! I am an HTML document. Today is [date].</body>
   </html>

When someone requests this document from the server, the server will use Lasso
to find and process the Lasso code. In this case, the ``[date]`` portion of the
page will be replaced with "2013-07-24 09:12:35", so the document sent to the
browser would be this::

   <html>
      <body>Hello! I am an HTML document. Today is 2013-07-24 09:12:35.</body>
   </html>

The person viewing this document wouldn't see the underlying HTML code, but just
the text in the body.

In order to make the date appear more meaningfully, you would have to adapt the
Lasso code to display the date in the manner you intended. For example::

   <html>
      <body>Hello! I am an HTML document. Today is [date->format('E, MMMM d, YYYY')].</body>
   </html>

This would have the date display as "Wed, July 24, 2013".

What we have just done here is embedded Lasso code into a document. With Lasso
properly installed and configured, the web server will ask Lasso to process the
document and create a response for it to send back to the requesting Web
browser. When Lasso processes the document, it looks for the embedded Lasso code
to execute within special delimiters and leaves the rest of the document alone.
Text that is within square brackets (``[]``) or within ``<?lasso ?>`` or within
``<?= ?>`` is interpreted as Lasso code.

Let's take a closer look at the Lasso code we just used. In the first example,
it was simply ``date``. This creates a date object with the current date and
time. Think of an object as an item that can be interacted with. In the second
example, we are interacting with the object by calling its format method with a
special string that tells it how we want it to format itself for display. (More
on creating and working with objects in future chapters.)

This is a very simple example, so let's move to something a little more complex.

:ref:`Next Tutorial: Using Logic <using-logic>`