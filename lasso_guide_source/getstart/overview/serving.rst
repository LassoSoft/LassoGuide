.. _overview-serving-lasso:

*************
Serving Lasso
*************

There are lots of ways to create websites using Lasso. There are a number of
`frameworks available`_, plus other ones not listed on that page, that can help.
You could even easily create your own framework. In this chapter, we will look
at how easy it is to use files that embed Lasso in HTML code, and examine a
simple packaging architecture that Lasso provides called LassoApps.


Embedding Lasso Code
====================

Lasso is designed to make it easy to intermix HTML and Lasso code in a single
file. Just create a normal HTML file with the "|dot| lasso" extension and you
can add Lasso code between the following delimiters: ``[ ... ]``, ``<?lasso ...
?>``, or ``<?= ... ?>``.

For example, you could place the following code in a file named "test.lasso" in
the root of your web root::

   <?lasso
      local(now) = date
   ?>
   <!DOCTYPE html>
   <html>
   <head>
      <title>Test Lasso</title>
   </head>
   <body>
      <p>
         This page was loaded on [#now->format(`E, MMMM d, YYYY`)] at <?= #now->format(`h:mm:ss a`) ?>.
      </p>
      It is currently
      [if(date->hour >= 5 and date->hour < 12) => {^]
         morning!
      [else(date->hour >= 12 && date->hour < 17)]
         afternoon!
      [else]
         evening!
      [^}]
   </body>

Now all you need to do is use a web browser to request the URL from the server
(e.g. :ref:`!http://example.com/test.lasso`) and it will use Lasso to return an
HTML page with something like the following content:

.. code-block:: none

   This page was loaded on Wed, July 31, 2013 at 10:36:42 AM
   It is currently morning!


Creating LassoApps
==================

A LassoApp is a bundle of Lasso source files, HTML files, images, and other
media into a single deployable unit. While developing, this deployable unit is a
folder with the above contents, but you can also choose to compile the bundle
and have a binary file to distribute.

To create a LassoApp, create a directory in the "LassoApps" directory of your
instance's home directory. By default, URLs for the LassoApp will start with
:file:`/lasso9/{AppName}/`. The discussion that follows will assume an app named
"AddressBook" with URLs that look like
:ref:`!http://example.com/lasso9/AddressBook`.


Special Files
-------------

_install Files
   The first time an instance loads a LassoApp, it will execute any files with a
   file name beginning with "_install" and ending with "|dot| lasso" or "|dot|
   inc". For example, an install file that performs a specific task, such as
   creating a database required by the app, could be named
   "_install.create_dbs.lasso".

_init File
   Another special file is the "_init" file. While the "_install" files will
   only ever execute once at installation, a file such as "_init.lasso" will be
   executed every time the instance starts. Initialization files are used to
   define all of the types, traits, and methods used within the application;
   along with any code set by `define_atBegin`. (Defining methods, types, etc.
   is best done at startup on a production system, since redefining a method can
   have an impact on system resources.)


Matching URLs to Code Files
---------------------------

LassoApps match the code files they process based on the type of content
requested as represented by the extension in the URL path. The default type is
HTML if no extension is used or if the "|dot| lasso" extension is used. That
means the following example URLs will all match the same code:

.. code-block:: none

   http://example.com/lasso9/AddressBook/people
   http://example.com/lasso9/AddressBook/people.html
   http://example.com/lasso9/AddressBook/people.lasso

Lasso matches those URLs to a file named "people.lasso" in the root of the
AddressBook directory. It processes that file and then it checks for any
secondary files to process. These secondary files are based on the content
extension, so in the case of the above URLs, it will execute a file named
"people[html].lasso". The primary file can return a value that can be used by
the secondary file. This allows you to easily separate code for logic from code
for display. (Note that if you use the URL ending in "people.lasso", Lasso won't
look for a secondary file to run based on content; only that code file will be
run.)

For example, your "people.lasso" file could contain code to create an array of
people objects and then return that array at the end::

   local(found_people) = array

   // ... populate the array ...

   return #found_people

Your "people[html].lasso" file might look something like this::

   <?lasso
      // Store the value returned from people.lasso
      local(contacts) = #1
   ?>
   <!DOCTYPE html>
   <html>
   <head>
      <title>Your Contacts</title>
   </head>
   <body>
      <table>
      <thead>
         <tr><th>First Name</th><th>Middle Name</th><th>Last Name</th></tr>
      </thead>
      <tbody>
      [with person in #contacts do {^]
         <tr>
            <td>[#person->firstName]</td>
            <td>[#person->middleName]</td>
            <td>[#person->lastName]</td>
         </tr>
      [^}]
      </tbody>
      </table>
   </body>
   </html>

This separation of logic and presentation allows for some rather powerful
features. For example, let's say we wanted our application to return a JSON
representation of the array of people when accessed via the URL
:ref:`!http://example.com/lasso9/AddressBook/people.json`. We already have the
logic that finds the people and creates the array, so all that's required is add
a file named "people[xhr].lasso" to create and display the array of maps::

   <?lasso
      local(people) = #1
      json_serialize(
         with person in #people
         select map(
            'firstName'  = #person->firstName,
            'middleName' = #person->middleName,
            'lastName'   = #person->lastName
         )
      )
   ?>

For more information on creating and compiling LassoApps, see the
:ref:`lassoapps` chapter.

.. _frameworks available: http://www.lassosoft.com/Lasso-frameworks
