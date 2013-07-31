.. _overview-embedding-lassoapps:

**************************************
Embedding Lasso and Creating LassoApps
**************************************

There are lots of ways to create websites using Lasso. There are
`a number of frameworks available`_ (including ones not listed on that page).
You could even easily create your own framework. In this chapter, we will look
at how easy it is to just have files that embed Lasso in HTML code, and we will
look at a simple architecture that Lasso provides called LassoApps.


Embedding Lasso
===============

Lasso is designed to make it easy to intermix HTML and Lasso code in a single
file. Just create a normal HTML file with the ".lasso" suffix and you can
intersperse Lasso code between the following dilimiters: "[ ... ]", "<?lasso ...
?>", and "<?LassoScript ... ?>".

::

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
         This page was loaded on [#now->format(`E, MMMM d, YYYY`)] at [#now->format(`h:mm:ss a`)].
      </p>
   </body>

Now all you need to do is use your web browser to request the URL from the
server and it will use Lasso to send you back an HTML page with something like
the following content::
   
   This page was loaded on Wed, July 31, 2013 at 10:36:42 AM


Creating LassoApps
==================

A LassoApp is a bundle of source files, HTML, images and other media types into
a single deployable unit. While developing, this deployable unit is a folder
with the contents, but you can also choose to compile the code and have a binary
file you distribute.

To create a LassoApp, create a directory in the LassoApps directory of your
instance's home folder. By default, URLs to code in the LassoApp will start with
"/lasso9/AppName/". The discussion that follows is going to assume an app named
"AddressBook".


The _install Files
------------------

The first time a LassoApp is loaded by the instance, it will execute any files
with filename beginning with "_install" and ending with ".lasso" or ".inc". For
example, an install file that performs a specific task, such as creating a
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
the following example URLs will all match the same code::

   http://example.com/lasso9/AddressBook/people
   http://example.com/lasso9/AddressBook/people.html
   http://example.com/lasso9/AddressBook/people.lasso

Lasso matches those URLs to a file named "people.lasso" in the root of the
AddressBook directory. It processes that file and then it checks for amy
secondary files to process. These secondary files are pased on the content
extension, so in the case of the above URLs, it will execute a file named
"people[html].lasso". The primary file can return a value that can be used by the
secondary file. This allows you to easily separate business logic from view
code.

For example, your "people.lasso" file might contain the code to create an array
of people objects and then return that array at the end::

   local(found_people) = array

   /** Code to Populate that Array **/
   // ....

   return #found_people

Your "people[html].lasso" file maight look something like this::

   <?lasso
      // Store the value returned from people.lasso
      local(contacts) = #1
   ?>
   <html>
   <head>
      <title>Your Contacts</title>
   </head
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
named "people[json].lasso" to create and display the array of maps::

   local(people) = #1
   json_serialize(
      with person in people
      select map(
         "firstName"=#person->firstName,
         "middletName"=#person->middleName,
         "lastName"=#person->lastName
      )
   )

For more information on creating and compiling LassoApps, be sure to read
:ref:`the LassoApps chapter <lassoapps>` in the Operations Guide.