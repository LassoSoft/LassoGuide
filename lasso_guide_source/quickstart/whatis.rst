.. http://www.lassosoft.com/Tutorial-What-is-Lasso

**************
What is Lasso?
**************

Lasso gives website pages the ability to be dynamic and interactive by changing
the content on the pages on-the-fly, pages which are then sent to a computer
over the Web to be read by a browser.

HTML
====

A web page is really just a text document, like a Microsoft Word document or a
PDF. When you open up a PDF to look at it, the PDF reader on your computer takes
the code which makes up the document and paints it on the screen for you, so you
as a human can interpret and appreciate it.

In the same way, the browser on your computer (like Firefox or Internet
Explorer) takes a document and displays it as if it is a document. When you
request a web page, your computer goes out onto the internet and requests a
document to be read. These documents are typically made with a specific set of
descriptive wrappers, called "HTML", which define what and where things should
be placed on the page.

Body Tag
--------

If you take some basic text, and put it into a text document, you can open up
this document with a browser and you will see your text. In this example, we'll
include the "body tag", as it defines what should be in the body of the visible
portion of the page in an HTML document.

:: 

   <body>Hello! I am an HTML document</body>

This would look like this in your browser;

::

   Hello! I am an HTML document

Dealing with Dynamically Changing Content
=========================================

However, websites these days are much more dynamic and have constantly changing
information and content. This isn't magic - your server must do the lifting for
you. Here is a simple example:

Current Date example
--------------------

Let's say you wanted your document to show the current date. One inefficient way
to do this would be to open your HTML document every day and manually change the
date in your document. Then, when anyone from went to go see your document, they
would get the correct date on your web page. In many people's opinion, this
would be an inefficient use of your time.

::

   <body>Hello! I am an HTML document. Today is Nov 13th, 2013.</body>

You could use the server to do this automatically for you, allowing you to go to
something else. One way would be to write a script which opens up your document
every day and changes the date for you. This works great until you want to show
something more granular: like seconds. Then you would have to open the document
every second and change it. This isn't just inefficient for a human, but
inefficient for a server.

Using Lasso to Change the Date
------------------------------

So instead, you can use Lasso to dynamically change the date for you, whenever
the page is requested by someone's browser. Here is how you would do it.

In your text document, you would type the following::

   <body>Hello! I am an HTML document. Today is [Date].</body>

When someone requested this document from the server, the server would use Lasso
to find and replace the word [Date] with the text "Nov 13th, 2013". So your
viewer would get::

   <body>Hello! I am an HTML document. Today is Nov 13th, 2013.</body>

[Date] outputs -> "01-10-03 20:00:00" (the current date and time).

In order to make the date appear more meaningfully, you would have to adapt the
Lasso tag to display the date in the manner you intended::

   [Date: -Format='']

So the text in your document would look like this::

   <body>Hello! I am an HTML document. Today is [Date: -Format=''].</body>

And this would dynamically change the text of your document as it leaves the
server, and your readers wouldn't know the difference.

What you would have just done here is embedded Lasso programming. Very simply,
creating code which outputs dynamic information, which the server changes on the
fly as people request pages, is the essence of Lasso programming.

This is a very simple example, so let's move to something a little more complex.
