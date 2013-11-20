.. http://www.lassosoft.com/Language-Guide-Calling-Lasso
.. _calling-lasso:

*************
Calling Lasso
*************

This chapter describes two different methods of calling Lasso: either using
Lasso as a script processor on the command line or using Lasso as a web
application server through the web browser.

This information is presented at the start of the Language Guide as it is vital
to understanding the rest of the topics and examples given in this guide.


Calling Lasso Web Pages
=======================

Lasso is most often used to serve web applications. Lasso code can be embedded
in HTML pages and executed before they are served to web visitors. A page that
includes Lasso code within it is referred to as a :dfn:`Lasso page`.

Lasso code is embedded within a regular HTML file by inserting the code between
a certain set of delimiters. These delimiters consist of an opening and a
closing element. Outside of these delimiting elements, all text is treated as if
it were plain text string literals. Such text is not interpreted by Lasso.
Within the delimiters, all text is parsed and executed as Lasso code. In this
manner, an HTML file becomes a template, with the final resulting data being the
combination of whatever plain text the file contained, plus whatever text was
generated via any contained Lasso code.

The available delimiting elements are described below. The "..." shown between
the delimiters illustrates where Lasso code would be inserted by the developer.

::

   <?lasso ... ?>

::

   <?= ... ?>

::

   [ ... ]

All three delimiters will produce identical results. Multiple expressions can be
contained within these delimiters. The result from each contained expression is
converted to a string and then concatenated together along with any plain text
existing outside of the delimiters.

Although square brackets (``[ ... ]``) are enabled by default, they can be
disabled by placing ``[no_square_brackets]``, usually at the top of the page,
outside the delimiters. Once ``[no_square_brackets]`` is encountered by the
Lasso parser, square brackets will be turned "off" and any subsequently
encountered square brackets will be treated as plain text. Turning square
brackets off works on a per-file basis, and there is no way to turn them back on
once they are off.

To illustrate how Lasso code is embedded within a Lasso page, the following code
may be stored in a file named "test.lasso" contained within the web server root.

.. _calling-lasso-web-ex:

::

   <!DOCTYPE html>
   <html>
   <head>
      <title>My Lasso Page</title>
   </head>
   <body>
      <p><?= 'The current date is ' + date ?>.</p>
   </body>
   </html>

The above begins with plain HTML markup, then adds two Lasso code expressions
into the document using a delimiter pair. When this file is loaded through a
browser, the code shown above is executed and the result is returned to the web
browser.

If the embedded message is not visible in the web browser or an error occurs,
then you should make sure that Lasso Server has been properly installed on your
machine. Consult the :ref:`installation guide for your operating system
<lasso-server-guide-index>` for complete instructions.


.. _calling-lasso-cli:

Calling Lasso from the CLI
==========================

Lasso code can be saved in a file and then executed on the command line. This
style of execution happens directly and does not require a web server or web
browser. Additionally, since a web server or web request is not in effect during
such execution, none of the web-serving-specific functionality is available in
this context. (For more information on the command-line tools that come as part
of the Lasso platform, see the :ref:`command-line-tools` chapter.)


Using the lasso9 Tool
---------------------

The :program:`lasso9` executable is a tool included with Lasso that handles the
parsing and execution of Lasso code from the command line. For example, the
following text might be placed into a file "test.lasso"::

   'The current date is ' + date

The file can be executed from the terminal using lasso9. If the reader has
created such a test file and has done a :command:`cd` to the location of the
file, then the file can be executed like so:

.. code-block:: none

   $> lasso9 ./test.lasso
   The current date is 2012-08-08 15:07:25

If the terminal reports the command was not found, or you receive some other
error, then you should make sure that Lasso has been installed properly on your
machine. Consult the :ref:`installation guide for your operating system
<lasso-server-guide-index>` for complete instructions.

When running Lasso code on the command line, delimiters are not required, though
they can be used. By default, text is assumed to consist of Lasso code only,
unless the file's text begins with an open angle bracket (``<``), in which case
it is assumed to start out as plain text. For example, the :ref:`test file shown
in "Calling Lasso Web Pages" <calling-lasso-web-ex>` could be run on the command
line and would generate the expected HTML result, including the embedded
message.


Associating Files with the lasso9 Tool
--------------------------------------

Files containing Lasso code can be directly associated with the
:program:`lasso9` tool by inserting a standard :dfn:`hashbang` line *at the
very top of the file*, and by making the file executable (usually accomplished
by running :command:`chmod +x thefile.lasso`).

The hashbang line for a standard installation looks like this::

   #!/usr/bin/lasso9

Using the same "test.lasso" file as before, but placing the hashbang line at the
top, the complete example would look as follows::

   #!/usr/bin/lasso9
   'The current date is ' + date

Once it has been made executable, the file can be directly executed on the
command line.

.. code-block:: none

   $> ./test.lasso
   The current date is 2012-08-08 15:07:25

The result, regardless of the execution method, is identical. Also, note that
the file's extension (".lasso" in this case) is irrelevant when executing Lasso
code on the command line. The example file could just have easily been named
"test", with no extension, and the results would have been the same.


Executing Code Directly
-----------------------

The :program:`lasso9` tool includes a :option:`-s` option which indicates that
the next argument given to the tool is the Lasso code to be executed. This
method bypasses the need to first place the code in a file. Instead, the source
code can be given directly to lasso9 when it is invoked.

.. code-block:: none

   $> lasso9 -s "'The current date is ' + date"
   The current date is 2012-08-08 15:07:25

Running the above example will produce the same output as the previous examples.
Care must be exercised when using this method because the shell will interpret
some characters for itself, therefore distorting the source code given to the
command. Because of this, it is generally recommended that such source code be
surrounded within double quotes and that single quotes be used for any contained
string literals, as illustrated in the example above.


Executing Code from STDIN
-------------------------

The :program:`lasso9` tool can also accept code to execute from STDIN. This is
useful when piping results from one command to lasso9 in order for it to execute
the given code. In order to have lasso9 receive its code from STDIN, the
:option:`--` argument is used. The following example uses the standard
:command:`echo` command to produce code for lasso9 to read from STDIN and then
execute:

.. code-block:: none

   $> echo "'The current date is ' + date" | lasso9 --
   The current date is 2012-08-08 15:07:25
