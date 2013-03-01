.. _calling-lasso:
.. http://www.lassosoft.com/Language-Guide-Calling-Lasso

*************
Calling Lasso
*************

This chapter describes two different methods of calling Lasso either
using Lasso as a script processor on the command line or using Lasso as
a web application server through the web browser.

This information is presented in the overview as it is vital to
understanding the rest of the topics and examples given in this
document.

-  Calling Lasso Web Pages describes how to call a Lasso page through a
   web browser
-  Calling Lasso on the CLI describes how to execute Lasso code on the
   command line.

Calling Lasso Web Pages
=======================

Lasso is most often used to serve web applications. Lasso language code
is embedded in HTML pages and executed before they are served to a web
visitor. A page which includes Lasso code within it is referred to as a
**Lasso Page**.

Lasso language code is embedded into a regular HTML file by inserting
the code between a certain set of delimiters. These delimiters consist
of an opening and a closing element. Outside of these delimiting
elements, all text is treated as if it were plain text string literals.
Such text is not interpreted by Lasso. Within these delimiters, all text
is parsed and executed as Lasso code. In this manner, an HTML file
becomes a template, with the final resulting data being the combination
of whatever plain text the file contained, plus whatever text was
generated via any contained Lasso language code.

The available delimiting elements are described below. The "..." shown
between the delimiters illustrates where Lasso code would be inserted by
the developer.

::

     <?lasso ... ?>

::

     <?= ... ?>

::

     [ ... ]

All three methods will produce identical results. Multiple expressions
can be contained within these delimiters. The result from each contained
expression is converted to a string and then concatenated together along
with any plain text existing outside of the delimiters.

Although square brackets "[ ... ]" are enabled by default, they can be
disabled by placing "[no_square_brackets]", usually at the top of the
page. Once "[no_square_brackets]" is encountered by the Lasso parser,
square brackets will be turned "off" and any subsequently encountered
square brackets will be treated as plain text.

To illustrate how Lasso language code is embedded into a Lasso page, the
following code may be stored in a file named "test.lasso" contained
within the web server root.

::

     <html>
    <head>
    <title>My Lasso Page</title>
    </head>
    <body>
    <p><?= 'The current date is ' + date ?>.</p>
    </body>
    </html>

The above begins with plain HTML text, then embeds two Lasso code
expressions into the document using the delimiter pair. When this file
is loaded through a browser, the code shown above is executed and the
result is returned to the web browser.

If the embedded message is not visible in the web browser or an error
occurs then you should make sure that Lasso Server has been installed
properly on your machine. Consult the Lasso 9 Setup Guide for complete
instructions.

Calling Lasso on the CLI
========================

Lasso language code can be specified in a file and then executed on the
command line. This style of execution happens directly and does not
require a web server or web browser. Additionally, since a web server or
web request is not in effect during such execution, none of the web
serving specific functionality is available in this context.

Using the lasso9 tool
---------------------

The **lasso9** tool is an executable included with Lasso that handles
the parsing and execution of Lasso code from the command line. For
example, the following text might be placed into a file test.lasso.

::

   'The current date is ' + date

The file can be executed from the terminal using the **lasso9** tool.
If the reader has created such a test file and has done a 'cd' to the
location of the file, the file can be executed like so.

::

   lasso9 ./test.lasso

If the terminal reports the command was not found, or you receive some
other error, then you should make sure that Lasso has been installed
properly on your machine. Consult the Lasso 9 Setup Guide for complete
instructions.

When running Lasso code on the command line, delimiters are not
required, though they can be used. By default, text is assumed to
consist of Lasso code only, unless the file's text begins with a ``<``
character, in which case it is assumed to start out as plain text. For
example, the test file shown in Calling Lasso Web Pages could be run on
the command line and would generate the expected HTML result, including
the embedded message.

Associating files with the lasso9 tool
--------------------------------------

Files containing Lasso code can be directly associated with the lasso9
tool by inserting a standard "hashbang" line **at the very top of the
file** and by making the file executable (usually accomplished using
"chmod +x thefile").

The hashbang line looks like so.

::

   #!/usr/local/bin/lasso9

Using the same test.lasso file as before, but placing the hashbang line
at the top, the complete example would look as follows.

::

   #!/usr/local/bin/lasso9
    'The current date is ' + date

Once it is made executable, the file can be directly executed on the
command line.

::

   ./test.lasso

The result, regardless of the execution method, is identical. Also, note
that the file's extension (.lasso in this case) is irrelevant when
executing Lasso code on the command line. The example file could just
have easily been called "test", with no extension, and the results would
have been the same.

Directly executing code text
----------------------------

The lasso9 tool includes an '-s' option which indicates that the next
argument given to the tool is the Lasso language code to be executed.
This method bypasses the need to first place the code in a file.
Instead, the source code is given directly to the lasso9 tool when it is
invoked.

::

   lasso9 -s "'The current date is ' + date"

The above, when run in a terminal, will produce the same output as the
previous examples. Care must be exercised when using this method because
the shell will tend to interpret some characters for itself, thus
distorting the source code given to the command. Because of this, it is
generally recommended that such source code be surrounded within double
quotes and that single quotes be used for any contained string literals,
as illustrated in the example above.

Executing code from stdin
-------------------------

The lasso9 tool can also accept code to execute from stdin. This is
useful when piping results from one command to the lasso9 tool in order
for it to execute the given code. In order to have lasso9 get its code
from stdout, the ``--`` argument is used. The following example uses the
standard 'echo' command produce code for the lasso 9 tool to read from
stdin and then execute.

::

   echo "'The current date is ' + date" \| lasso9 --

The result of the above is the same as for the previous examples.
