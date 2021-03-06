.. _lassoapps:

*********
LassoApps
*********

Lasso Server provides a means for bundling source files, HTML, images, and other
media types into a single deployable unit called a :dfn:`LassoApp`. LassoApps
are served over the web using Lasso Server's FastCGI interface. Lasso Server is
required to run LassoApps. A single server can run multiple LassoApps at the
same time.

The LassoApp system provides a framework of features to make app development
easier and to support a clean and maintainable design. This system also permits
data in one app to be accessed and shared by another, allowing multiple apps to
work in concert.


LassoApp Concepts
=================

LassoApps consist of regular files, logically structured into a tree of nodes
and resources. This node tree is constructed to match the file and directory
structure inside the LassoApp bundle. Each node is associated with one or more
resources. Resources are generally either Lasso pages, CSS, JavaScript,
HTML/XML, XHR, image, or other raw or binary file types.

This node/resource/content representation system permits the logic for producing
a particular application object, such as a "user" or a set of database result
rows, to be isolated from logic for its display. It also allows application
objects to be represented in a variety of manners, and for those representations
to be modified, without having to extend the application objects themselves.

Additionally, the system is unobtrusive, permitting the developer to use their
own methodologies and frameworks while still taking advantage of the LassoApp
system in pieces or as a whole.


Nodes
-----

:dfn:`Nodes` represent the object structure behind a live LassoApp. This object
structure is hierarchical, like a directory structure. The node tree begins with
the "root" node. That root node has a series of subnodes and those subnodes have
zero or more subnodes beneath them. In the case of the root node, each of its
subnodes represent the currently installed and running LassoApps.

Each node has a name and this name is used when locating a particular node
within the tree. Nodes are addressed using standard forward-slash path syntax.
The root node is named "lasso9", so it is accessed using the path
:file:`/lasso9`. The names of subnodes are appended to the path following a "/".

.. code-block:: none

   /lasso9/LassoAppName/resourceName
   /lasso9/AddressBook/groups/userX

The default web server configuration for Lasso Server will direct all paths
beginning with :file:`/lasso9` to Lasso Server. This is the default method for
accessing LassoApps over the web, though the configuration can be modified for
other situations or server requirements. See the section
:ref:`lassoapps-server-configuration` for more information.


Resources
---------

Nodes not only serve as containers for subnodes, they also represent zero or
more :dfn:`resources`. These resources represent data files, such as images,
CSS, or Lasso source files. Resources are used to produce an object that the
LassoApp system must then transform into a format suitable for sending back to
the client. Each resource is associated with a content type. This association is
done either explicitly using the resource file's name, or by relying on the
default content type, which is :mimetype:`text/html`.

.. rubric:: LassoApp Node Hierarchy

.. image:: /_static/lassoapp_nodes.*
   :align: center
   :alt: LassoApp node hierarchy


Content Representations
-----------------------

Each resource is associated with a content type which is used when handling, or
representing, the object produced by a resource. This handling occurs
automatically when a node is requested via a web request and is formatted for
output via HTTP. This handling is performed by a variety of :dfn:`content
representation` objects, each tailored for specific file extension, like "|dot|
jpg" or "|dot| js", and content types such as :mimetype:`image/jpeg` or
:mimetype:`application/javascript`. New content representation objects can be
added and existing representations can be tailored for specific application
objects.

If there exists a content representation object for a given node resource and
content type, then that resource can be invoked and the resulting object given
to the content representation object for transformation or special handling.

To illustrate, consider a resource such as a PNG image that comes from a static,
unchanging PNG file within a LassoApp. After the LassoApp is bundled for
deployment, that image file may not actually exist on disk; instead it is
contained within the LassoApp in a specialized format. Given the resource's PNG
content type, the system chooses the appropriate content representation object.
In turn, that object sets an :mailheader:`Expires` header for that web request,
improving application performance by preventing future redundant image requests.
The content representation object does not have to modify the object data, and
in this case with PNGs, sets an HTTP header but returns the unaltered binary
image data.

Another example would be a node resource that produces a "user" object
containing a first name, last name, etc. A content representation can be added
to handle that particular object type and formats it for display as HTML.
Another content representation can be added to format it for sending back as
JSON data, while another can be added to convert it to the vCard format.


Constructing a LassoApp
=======================

All LassoApps reside as either a file or a directory located within the
"LassoApps" directory, which is located within the current Lasso home. (See the
section :ref:`instance-manager-home-directory` in the :ref:`instance-manager`
chapter for more details.)

LassoApps begin as a directory named according to the application. This
directory contains all of the files for the application. Before deployment, this
directory can be precompiled into the LassoApp format. However, Lasso Server
will happily serve a plain LassoApp directory as long as it is placed in the
proper location. This means that an application can be deployed as a regular
directory of files and also that a developer needn't take any special steps
transitioning between developing and testing an application.

.. important::
   While the above is generally true, it is currently required to restart Lasso
   Server when *adding* or *removing* files from an in-development LassoApp. We
   aim to remove this restriction in a future release. (File content can be
   modified without any such restrictions.)


Directory Organization
----------------------

By using the concepts of nodes, resources, and content representation, a
LassoApp can be organized logically and provide clean, hierarchical, natural
language URLs.

For example a simple "Contacts" LassoApp could have a structure similar to the
following:

.. code-block:: none

   LassoApps/
      mycontacts/
         contacts/
            index.lasso
         css/
            appstyle.css
         index.lasso
         js/
            scripts.js
         other/
            footer.lasso
            header.lasso

This structure would provide the "root" of the LassoApp as
:ref:`!http://example.com/lasso9/mycontacts` which will serve the "index.lasso"
file.


Serving Content
===============

Serving simple content such as images or raw text and HTML is as simple as
putting the file into the LassoApp root directory. As long as the file has the
appropriate file extension (e.g. "|dot| jpg", "|dot| txt", "|dot| html") then it
will be served as expected. Files with a extension other than "|dot| lasso",
"|dot| lasso9" or "|dot| inc" will be served as plain data, meaning they will
not be parsed, compiled and executed by Lasso Server.


Serving Processed Content
-------------------------

Processed content is any data produced programmatically by executing Lasso
source code files. Such data can be generated wholly by Lasso code, or partially
by embedding Lasso code in HTML or other types of templates. This type of
content must reside in a file with an extension of "|dot| lasso", "|dot| lasso9"
or "|dot| inc".

The outgoing content type of processed content is very important. The content
type determines any modifications or special handling that the data will receive
before it is ultimately converted into a stream of bytes and sent to the client.
By default, the content type for a "\*.lasso" file is :mimetype:`text/html`.
Lasso Server will automatically set the outgoing content type accordingly. A
file will be given the default content type when accessed via a URL with either
no extension, a "|dot| html" extension or a "|dot| lasso" extension. For
example, requests for the following URLs:

.. code-block:: none

   http://localhost/lasso9/AddressBook/users
   http://localhost/lasso9/AddressBook/users.html
   http://localhost/lasso9/AddressBook/users.lasso

will, assuming the standard Lasso Server web server configuration, be mapped to
these files in the LassoApp and served with the content type
:mimetype:`text/html`:

.. code-block:: none

   /AddressBook/users.html
   /AddressBook/users.html
   /AddressBook/users.lasso


Explicit Content Types
----------------------

The outgoing content type for a source file can be indicated in the file's name
by placing the content type's file extension between square brackets. These
files will be executed and the resulting value will be returned to the client
using the indicated content type. The following shows some valid file names:

.. code-block:: none

   /AddressBook/users[html].lasso
   /AddressBook/users[xml].lasso
   /AddressBook/users[rss].lasso
   /AddressBook/users[xhr].lasso

The files shown above will expose the following URLs:

.. code-block:: none

   http://localhost/lasso9/AddressBook/users.html
   http://localhost/lasso9/AddressBook/users.xml
   http://localhost/lasso9/AddressBook/users.rss
   http://localhost/lasso9/AddressBook/users.xhr

.. tip::
   A filename with an explicit content type overrides a file with a plain
   extension. For example, a request for
   :ref:`!http://localhost/lasso9/AddressBook/users` or
   :ref:`!http://localhost/lasso9/AddressBook/users.html` will be mapped to
   :file:`/AddressBook/users[html].lasso` if it exists, and then fall back on
   :file:`/AddressBook/users.html`.


Primary and Secondary Processing
--------------------------------

Explicit content types can be used jointly with a similarly named regular
"\*.lasso" file. In this situation, first the *primary* file is executed and
then its value is made available to the *secondary* file as it is executed. The
primary file is always executed. Only then would the secondary file, which
corresponds to the requested content type, be executed.

.. code-block:: none

   /AddressBook/users.lasso - primary content
   /AddressBook/users[html].lasso - secondary
   /AddressBook/users[xml].lasso - secondary
   /AddressBook/users[rss].lasso - secondary
   /AddressBook/users[xhr].lasso - secondary

Given the files shown above, if the URL
:ref:`!http://example.com/lasso9/AddressBook/users.html` was accessed, first the
file "users.lasso" would be executed, and then the file "users[html].lasso"
would be executed. The value produced by the first would be made available to
the second. This technique is used to separate the object produced by the
primary file from its display, which is handled by the secondary file.

In this scenario, the file "users.lasso" could return an array of all the users
in the address book. That list of users might need to be presented to the client
in a variety of formats, like HTML, XML, or RSS. The primary file "users.lasso"
is concerned only with producing the array of users. The secondary files each
handle presenting that array in the desired format.

Since primary files usually return structured data, it is generally required to
return the value using a ``return`` statement. However, primary files that
simply need to return string data can do so without a return statement by
surrounding the code with Lasso delimiters, which will cause the auto-collected
value generated by executing that file to be returned. In such cases, the
delimiter must be first visible character in the file; otherwise Lasso Server
will treat the entire file as executable code.

The following examples show a series of files that produce and format a list of
users for both HTML and XML display. The list is generated first by the
"users.lasso" file, then that list is processed by the "users[html].lasso" and
"users[xml].lasso" files.

.. rubric:: users.lasso

::

   // Note: Usually the type definition would be in an _init file
   define user => type {
      data
         public firstname::string,
         public middleName::string,
         public lastname::string

      public oncreate(firstname::string, lastname::string) => {
         .firstname = #firstname
         .lastname = #lastname
      }
      public oncreate(firstname::string, middle::string, lastname::string) => {
         .firstname = #firstname
         .middlename = #middle
         .lastname = #lastname
      }
   }

   // Return an array of users
   return array(user('Stephen', 'J', 'Gould'),
            user('Francis', 'Crick'),
            user('Massimo', 'Pigliucci'))

.. rubric:: users[html].lasso

::

   <html>
   <title>Users List</title>
   <body>
   <table>
      <tr><th>First Name</th><th>Middle Name</th><th>Last Name</th></tr>
   <?lasso
      // The primary value is given to us as the first parameter
      local(users) = #1

      // Start outputting HTML for each user
      with user in #users
      do {^
         '<tr><td>' + #user->firstName + '</td>
            <td>' + #user->middleName + '</td>
            <td>' + #user->lastName + '</td>
         </tr>'
      ^}
   ?>
   </table>
   </body>
   </html>

.. rubric:: users[xml].lasso

::

   <userslist>
   <?lasso
      // The primary value is given to us as the first parameter
      local(users) = #1

      // Start outputting XML for each user
      with user in #users
      do {^
         '<user><firstname>' + #user->firstName + '</firstname>
            <middlename>' + #user->middleName + '</middlename>
            <lastname>' + #user->lastName + '</lastname>
         </user>'
      ^}
   ?>
   </userslist>


Pass Multiple Values from Primary to Secondary
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To pass multiple values from primary to secondary processors, use a staticarray
as a return from the primary::

   // Return from primary processor
   return (:
      'hello world',
      array(
         user('Stephen', 'J', 'Gould'),
         user('Francis', 'Crick'),
         user('Massimo', 'Pigliucci')
      )
   )

The following sets local variables to the returned values from the primary
processor, in the order they are specified. The number of local variables being
set must match the number of elements in the returned staticarray. (See the
section :ref:`variables-decompositional` in the :ref:`variables` chapter.) ::

   local(txt, users) = #1


Special Files
=============

Using the naming conventions below, a LassoApp can be made to install or load
files as needed.


Customizing Installation
------------------------

.. index:: _install file

One or more specially named files can be placed in the root level of a LassoApp
directory to be executed the first time a LassoApp is loaded into Lasso Server.
These files are named beginning with "_install." followed by any additional
naming characters and ending with a "|dot| lasso" extension. The simplest
install file could be named "_install.lasso". For example, an install file for
performing a specific task, such as creating database required by the app, could
be named "_install.create_dbs.lasso".

Lasso Server will record the first time a particular install file is run. That
file will not be executed again, even when the instance restarts. Only install
files at the root of the LassoApp are executed.


Customizing Initialization
--------------------------

.. index:: _init file

LassoApps can contain a special set of files that are executed every time the
LassoApp is loaded. This loading occurs whenever Lasso Server starts up. These
files are named beginning with "_init." followed by any additional naming
characters and ending with "|dot| lasso". The file "_init.lasso" is the simplest
valid init file name. Only initialization files at the root of the LassoApp are
executed.

Initialization files are used to define types, traits, and methods used within
the application. This includes the definition of a thread object that can be
used to synchronize aspects of the application, hold globally shared data, or
perform periodic tasks.

During the normal operation of an application, definitions should be avoided.
Redefining a method can have an impact on performance and memory usage,
potentially leading to bottlenecks in your application. However, during
application development redefining a method is a common occurrence while source
code is frequently modified. In this case, definitions can be placed in non-init
files (i.e., a regular file) and included in the \_init files using
`lassoApp_include`. This allows the definition be loaded at startup while also
letting the developer execute the file "manually" as it is updated during
development.


Ignored Files
-------------

When serving a LassoApp, Lasso Server will ignore certain file paths based on
their names. Although they can be included in a LassoApp, Lasso will not serve
or process files or directories whose names begin with a period (``.``), hyphen
(``-``), or two underscores (``__``). All other file names are permitted without
restriction.


LassoApp Links
==============

Use the `lassoApp_link` or `lassoApp_include` methods to link between resources
in a LassoApp.


Internal Links
--------------

When creating a LassoApp, it is important not to hard-code paths to files within
the app. Because the files within a LassoApp are not real files, Lasso Server
will alter paths used in HTML links to be able to access the file data. The
`lassoApp_link` method must be used for all intra-app file links.

.. method:: lassoApp_link(path::string)

   Use this method to make links to files that are internal to a LassoApp. A
   LassoApp is compiled out of all the files within a folder. Any links between
   files within that code must be made using `lassoApp_link`, including links in
   HTML anchor tags (``<a>``), image tags (``<img src="...">``), and form
   actions.

To illustrate, consider a LassoApp that contains an image file called "icon.png"
within an "images" subdirectory. In order to display the image, the
`lassoApp_link` method would be used to alter the path, at runtime, to point to
the true location of the file data. The following shows how `lassoApp_link`
would be used to display the image. This example assumes that the link is being
embedded in an HTML ``<img>`` tag::

   <img src="<?= lassoApp_link('/images/icon.png') ?>" />

The path that gets inserted into the HTML document will vary depending on the
system's configuration, but the end result would be the same: the image would be
displayed.

In the context of our "AddressBook" LassoApp from earlier in the chapter, using
a default server configuration, the link above would be
"/lasso9/AddressBook/images/icon.png".

The `lassoApp_link` method must be used whenever a path to a file within the app
is needed. Behind the scenes, Lasso Server will alter the path so that it points
to the right location. However, `lassoApp_link` only operates on paths to files
within the current LassoApp. That is, `lassoApp_link` does not work with paths
to files in other LassoApps running on the same system.


LassoApp Includes
-----------------

It is possible to directly access, or :dfn:`include`, a LassoApp node given its
path. This can be used to pull in file data within the current LassoApp as well
as other LassoApps running on the system. This technique can be used to assemble
a result page based on multiple files working together.

.. method:: lassoApp_include(path::string)
.. method:: lassoApp_include(path::string, as::string, extra= ?)
.. method:: lassoApp_include_current(path::string, extra= ?)

   These methods allow you to include content from the LassoApp node specified
   in the ``path`` parameter. The default is to determine the content type by
   the extension of the node, but the second method allows you to specify the
   extension to use.

   The first two methods allow you to specify a node in any LassoApp, where the
   root of their path is the top level for all LassoApps. The last method
   `lassoApp_include_current` has its root set to the current LassoApp.

To include a LassoApp file from a Lasso file external to the LassoApp, the
`lassoApp_include` method is used. This method accepts one string parameter,
which is the path to the file to include. This path does not need to be altered
via the `lassoApp_link` method. However, the path should be a full path to the
file starting with the name of the LassoApp that contains the file.
Additionally, `lassoApp_include` takes content representations into account.
Therefore, if the HTML representation of a file is desired, the file path should
include the "|dot| html" extension.

For example, a LassoApp result page could consist of pulling in two other
LassoApp files. Earlier in this chapter, several files were described
representing a users list. These files represented the users list in several
formats, particularly XML and HTML. Combined with a groups list, an opening page
from the hypothetical AddressBook LassoApp could look as follows::

   <html>
      <head><title>Title</title></head>
      <body>
         Users list:
         <?= lassoApp_include('/AddressBook/users.html') ?>
         Groups list:
         <?= lassoApp_include('/AddressBook/groups.html') ?>
      </body>
   </html>

A `lassoApp_include` can be used to pull in any of the content representations
for a file, including the primary content. If the raw user list (as shown
earlier in this chapter) were desired, the `lassoApp_include` method would be
used, but the "|dot| lasso" extension would be given in the file path instead of
the "|dot| html" extension. Because of this, the return type of the
`lassoApp_include` method may vary. It may be plain string data, bytes data from
such as an image, or any other type of object.

The following example includes the users list and assigns it to a variable. It
then prints a message pertaining to how many users exist. This illustrates how
the result of `lassoApp_include` is not just character data, but is whatever
type of data the LassoApp file represents. In this case, it is an array. ::

   local(usersList) = lassoApp_include('/AddressBook/users.lasso')
   'There are: ' + #usersList->size + ' users'


Packaging and Deploying LassoApps
=================================

A LassoApp can be packaged in one of three ways: as a directory of files, as a
zipped directory, and as a compiled platform-specific binary. Each method has
its own benefits. Developers can choose the packaging mechanism most suitable to
their needs.


As a Directory
--------------

The first method is as a directory containing the application's files. This is
the simplest method, requiring no extra work by the developer. The same
directory used during development of the LassoApp can be moved to another
machine running Lasso Server and run as-is. Of course, when using this method,
the user has access to all the source code for the application. Generally, this
packaging method would be used by an in-house application where source code
availability is not a concern and the LassoApp is installed manually on a server
by copying the LassoApp directory.


As a Zip File
-------------

The second method is to zip the LassoApp directory. This produces a single zip
file that can be installed on a Lasso Server instance. Lasso Server will handle
unzipping the file in-memory and serving its contents. LassoApps zipped in this
manner provide easy downloading and distribution while still making the source
code for the application accessible. Zipped LassoApps must have a "|dot| zip"
file extension.

Developers should verify that a LassoApp directory is zipped properly.
Specifically, Lasso requires that all of the files and folders inside the
LassoApp directory be zipped and not the LassoApp directory itself. On
UNIX-based platforms (OS X or Linux) the :command:`zip` command-line tool can be
used to create zipped LassoApps. To accomplish this, a developer would
:command:`cd` *into* the LassoApp directory and issue the zip command. Assuming
a LassoApp name of "AddressBook", the following command would be used.

.. code-block:: none

   $> zip -qr ../AddressBook.zip *

The above would zip the files and folders within the AddressBook directory and
create a file named "AddressBook.zip" at the same level as the "AddressBook"
directory. The "r" option indicates to zip that it should recursively zip all
subdirectories, while the "q" option simply indicates that zip should do its job
quietly (by default, zip outputs verbose information on its activities).


As a Compiled Binary
--------------------

.. index:: lassoc

Using the :program:`lassoc` tool, included with Lasso Server, a developer can
compile a LassoApp directory into a single distributable file. LassoApps
packaged in this manner will have the file extension "|dot| lassoapp". Packaging
in this manner provides the greatest security for one's source code because the
source code is not included in the package and is not recoverable by the end
user.

Compiled binary LassoApps are platform-specific. Because these LassoApps are
compiled to native OS-specific executable code, a binary compiled for OS X, for
example, will not run on Linux.

Both lassoc and the freely available :program:`gcc` compiler tools are required
to compile a binary LassoApp. Several steps are involved in this task. However,
you can use a "makefile" which simplifies this process on Linux and OS X. To use
this `example makefile`_, copy the file into the same location as the LassoApp
directory. Then, on the command line, type:

.. code-block:: none

   $> make DirectoryName.lassoapp

Replace "DirectoryName" with the name of the LassoApp directory in the above
command. The resulting file will have a "|dot| lassoapp" extension and can be
placed in the "LassoApps" directory. Lasso Server will load the LassoApp once it
is restarted.

For information on compiling without using a makefile or on Windows, see the
section :ref:`command-compiling-lasso` in the :ref:`command-line-tools` chapter.


Installing the GCC compiler
^^^^^^^^^^^^^^^^^^^^^^^^^^^

On OS X, either:

-  Install and open Xcode, then go to :menuselection:`Preferences --> Downloads
   --> Components --> Command Line Tools`, and click :guilabel:`Install`.
-  Or, install the Command Line Tools package directly from
   https://developer.apple.com/download/more/ (Apple ID required).

On CentOS:

-  run :command:`sudo yum install make` on the command line. This will install
   all required dependencies including :program:`gcc`.

On Ubuntu:

-  run :command:`sudo apt-get install make` on the command line. As with CentOS
   this will install all required dependencies.


Platform-Specific Considerations
--------------------------------

It is important to note that the target for each compiled LassoApp is specific
to that which it is compiled on. If your development platform is OS X and you
wish to deploy your compiled LassoApp on 64-bit CentOS, you must compile the
LassoApp on a 64-bit CentOS machine. The same issue exists for 32-bit vs. 64-bit
architectures on the same distribution. A LassoApp compiled for 32-bit Ubuntu
will not run on 64-bit Ubuntu.


.. _lassoapps-server-configuration:

Server Configuration
====================

Although LassoApps are available through the path :file:`/lasso9/{AppName}/`, it
is often desirable to dedicate a site to serving a single LassoApp. This can be
accomplished by having the web server set an environment variable for Lasso to
indicate which LassoApp the website is serving. The environment variable is
named :envvar:`LASSOSERVER_APP_PREFIX`. Its value should be the path to the root
of the LassoApp. For example, if a site were dedicated to serving the Lasso
Server Admin app, the value for the :envvar:`LASSOSERVER_APP_PREFIX` variable
would be "/lasso9/admin". Having the variable set in this manner would cause
all `lassoApp_link` paths to be prefixed with "/lasso9/admin".

The :envvar:`LASSOSERVER_APP_PREFIX` variable is used along with other web
server configuration directives to provide transparent serving of a LassoApp.
The following example for the Apache 2 web server illustrates how the Lasso
Server Admin app would be served out of a virtual host named "admin.local".

.. code-block:: apacheconf

    <VirtualHost *:80>
        ServerName admin.local
        ScriptAliasMatch ^(.*)$ /lasso9/admin$1
        RewriteEngine on
        RewriteRule ^ - [E=LASSOSERVER_APP_PREFIX:/lasso9/admin]
    </VirtualHost>

Consult your web server's documentation for further information.


LassoApp Tips
=============


Loading Required Types/Traits/Methods at Initialization
-------------------------------------------------------

It is a good habit to load all types and methods required by the LassoApp at the
time Lasso Server loads it. This can be achieved by using "_init.lasso":

.. rubric:: _init.lasso

::

   // Load traits
   lassoApp_include('core/traits/mytrait.lasso')
   lassoApp_include('core/traits/anothertrait.lasso')

   // Load types
   local(coretypes) = array('my_usertype', 'my_addresstype', 'my_companytype')
   with i in #coretypes
   do lassoApp_include('core/types-methods/' + #i + '.lasso')

This will load the specified traits and types at the time the LassoApp is
loaded. All documents in the LassoApp can then assume these types exist. Note
that these types can later be redefined individually by accessing the URL
directly; in this case, at
:ref:`!http://example.com/lasso9/myLassoApp/core/types-methods/my_usertype.lasso`.


Creating Required SQLite Database on Installation
-------------------------------------------------

It is often desirable to keep configuration data for your LassoApp in a database
rather than a local config file. One method of storing this is to leverage Lasso
Server's embedded SQLite data source.

The following code demonstrates automatically creating a SQLite database
whenever the LassoApp is installed on a new instance:

.. rubric:: _install.lasso

::

   define myLassoApp_sqlite_dbname  => 'myLassoApp_db'
   define myLassoApp_sqlite_db      => sys_databasesPath + myLassoApp_sqlite_dbname
   define myLassoApp_config_table   => 'config'

   local(sql) = sqlite_db(myLassoApp_sqlite_db)

   #sql->doWithClose => {
      #sql->executeNow(
         "CREATE TABLE IF NOT EXISTS " + myLassoApp_config_table +
         " (host PRIMARY KEY, dbname, username, pwd, status INTEGER, registerkey);"
      )
   }

The code within "_install.lasso" will only ever be executed when this LassoApp
is first placed in the "LassoApps" directory of an instance and the instance is
restarted.


Serving JSON and XHR Files
--------------------------

Content Representation can be leveraged to provide a range of data formats. One
of these is :abbr:`XHR (XMLHttpRequest)`, also known as :abbr:`AJAX
(Asynchronous JavaScript and XML)`, which in most cases will use a GET request
to send data to the server, e.g.
:ref:`!http://example.com/lasso9/myLassoapp/userdata.xhr?id=123`.

While discussions directly regarding AJAX, jQuery, XHR, REST, XML, and JSON are
outside the scope of this chapter, XHR response data can be in various forms,
including JSON, which we will use for this example.

Consider the following JavaScript (using jQuery):

.. code-block:: javascript

   var dataObj       = new Object;
   dataObj.id        = $('#userid').val();
   $.ajax({
         url:        '/lasso9/myLassoapp/userdata.xhr',
         data:       dataObj,
         async:      true,
         type:       'post',
         cache:      false,
         dataType:   'json',
         success:    function(xhr) {
             alert('User name: ' + xhr.firstname + ' ' + xhr.lastname);
         }
   });

The XHR request is for "userdata.xhr", which Lasso Server will interpret as a
request for "userdata[xhr].lasso" and serve as an XHR file with the correct MIME
type.

.. rubric:: userdata[xhr].lasso

::

   local(id)     = integer(web_request->param('id')->asString)
   local(mydata) = map
   inline(
      -database='example',
      -sql="SELECT firstname, lastname FROM mytable WHERE id = " + #id + " LIMIT 1;"
   ) => {
      records => {
         #mydata->insert('firstname' = field('firstname')->asString)
         #mydata->insert('lastname'  = field('lastname')->asString)
      }
   }
   local(xout) = json_serialize(#mydata)
   #xout

.. _example makefile: http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/makefile
