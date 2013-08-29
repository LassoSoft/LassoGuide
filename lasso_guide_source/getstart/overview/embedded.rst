.. _overview-embedding-lassoapps:

**************************************
Embedding Lasso and Creating LassoApps
**************************************

There are lots of ways to create websites using Lasso. There are
`a number of frameworks available <http://www.lassosoft.com/Lasso-frameworks>`_
(including ones not listed on that page). You could even easily create your own
framework. In this chapter, we will look at how easy it is to just have files
that embed Lasso in HTML code, and we will look at a simple architecture that
Lasso provides called LassoApps.


Embedding Lasso
===============

Lasso is designed to make it easy to intermix HTML and Lasso code in a single
file. Just create a normal HTML file with the ".lasso" suffix and you can
intersperse Lasso code between the following dilimiters: "[ ... ]", "<?lasso ...
?>", and "<?= ... ?>".

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
(ex http://www.example.com/test.lasso) and it will use Lasso to send you back an
HTML page with something like the following content:

.. code-block:: none
   
   This page was loaded on Wed, July 31, 2013 at 10:36:42 AM
   It is currently morning!


Creating LassoApps
==================

A LassoApp is a bundle of source files, HTML files, images and other media files
into a single deployable unit. While developing, this deployable unit is a
folder with the contents, but you can also choose to compile the bundle and have
a binary file you distribute.

To create a LassoApp, create a directory in the LassoApps directory of your
instance's home folder. By default, URLs for the LassoApp will start with
"/lasso9/AppName/". The discussion that follows is going to assume an app named
"AddressBook" with URLs that will then look like
"http://example.com/lasso9/AddressBook".


The _install Files
------------------

The first time a LassoApp is loaded by the instance, it will execute any files
with a file name beginning with "_install" and ending with ".lasso" or ".inc".
For example, an install file that performs a specific task, such as creating a
database required by the app, could be named "_install.create_dbs.lasso".


The _init File
--------------

Another special file is the "_init" file. While the "_install" files will only
ever execute once at installation, a file such as "_init.lasso" will be executed
every time the instance starts. Initialization files are used to define all of
the types, traits and methods used within the application, along with any
``atBegin`` blocks. (Defining methods, types etc is best done at startup on a
production system as re-defining a method can have an impact on system
resources.)


Matching URLs to Code Files
---------------------------

LassoApps match the code files they process based on the type of content
requested as represented by the extension in the URL path. The default type is
HTML if no extension is used or if the ".lasso" extension is used. That means
the following example URLs will all match the same code:

.. code-block:: none

   http://example.com/lasso9/AddressBook/people
   http://example.com/lasso9/AddressBook/people.html
   http://example.com/lasso9/AddressBook/people.lasso

Lasso matches those URLs to a file named "people.lasso" in the root of the
AddressBook directory. It processes that file and then it checks for any
secondary files to process. These secondary files are based on the content
extension, so in the case of the above URLs, it will execute a file named
"people[html].lasso". The primary file can return a value that can be used by
the secondary file. This allows you to easily separate business logic from view
code. (Note, if you use the URL ending in "people.lasso", Lasso won't look for a
secondary file to run based on content, only that code file will be run.)

For example, your "people.lasso" file might contain the code to create an array
of people objects and then return that array at the end::

   local(found_people) = array

   /** Code to Populate that Array **/
   // ...

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

This seperation of logic and presentation allows for some pretty powerful
features. For example, let's say I wanted to return a JSON representation of the
array of people when they accessed the URL
"http://example.com/lasso9/AddressBook/people.json". I already have the logic
that finds the people and creates the array, all I need to do is add a file
named "people[xhr].lasso" to create and display the array of maps::

   <?lasso
      local(people) = #1
      json_serialize(
         with person in #people
         select map(
            "firstName"=#person->firstName,
            "middletName"=#person->middleName,
            "lastName"=#person->lastName
         )
      )
   ?>

For more information on creating and compiling LassoApps, be sure to read
:ref:`the LassoApps chapter <lassoapps>` in the Operations Guide.