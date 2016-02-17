.. highlight:: none
.. _command-line-tools:

******************
Command-Line Tools
******************

The Lasso platform comes with various command-line tools to assist you. Lasso
uses some of these tools to create and run the instances of Lasso that talk with
your web server. This chapter will contain an overview of those tools and
describe how you can run them yourself.


lassoserver
===========

.. index:: lassoserver

The :program:`lassoserver` executable is installed at
:file:`/usr/sbin/lassoserver` on OS X and Linux operating systems and at
:file:`C:\\Program Files\\LassoSoft\\Lasso Instance
Manager\\home\\LassoExecutables\\lassoserver` on Windows. This program creates a
FastCGI server that interfaces with web servers to process Lasso files in
response to web requests. Each instance of Lasso has its own lassoserver process
running a FastCGI server. Additionally, the lassoserver executable can start up
an HTTP server instead of a FastCGI server. As an HTTP server, it can serve both
static files and Lasso files. This is useful for local development, though you
should run a production web server (such as Apache) for your production servers.

The following is the list of options for running lassoserver:

.. program:: lassoserver

.. option:: -p <tcp_listen_port>

   Set the port that either the FastCGI or HTTP server binds on. This option is
   ignored if you choose to create a FastCGI socket.

   Default is 8999.

.. option:: -addr <tcp_bind_address>

   Set the IP address to bind to when running as either a FastCGI or HTTP
   server. This option is ignored if you choose to create a FastCGI socket.

   Default is 0.0.0.0, which will bind to all IPs associated with your machine.

.. option:: -fproxy <fcgi_proxy_socket>

   Specify the path to create a socket for FastCGI proxy requests to be sent to.
   This path will be relative to :envvar:`LASSO9_HOME` unless you start the path
   with two slashes.

   Default is to not create this socket.

.. option:: -flisten <fcgi_listen_socket>

   Specify the path to create a socket for FastCGI requests to be sent to. This
   path is always relative to :envvar:`LASSO9_HOME`.

   Default is to not create this socket.

.. option:: -user <user>

   Specifies the OS user to run lassoserver as. In order for this to be
   effective, you must be running lassoserver with root privileges.

   Default is to run as the user invoking lassoserver.

.. option:: -group <group>

   Specify the OS group to run lassoserver as. In order for this to be
   effective, you must be running lassoserver with root privileges.

   Default is to run as the primary group of the user invoking lassoserver.

.. option:: -httproot <path>

   This option tells lassoserver to start an HTTP server instead of a FastCGI
   server and to use the path specified as the web root. This option will be
   ignored if either :option:`-fproxy` or :option:`-flisten` is specified.

   Default is to not start up as an HTTP server.

.. option:: -scriptextensions <ext1[;ext2] ... >

   Identify which file extensions should be considered Lasso files. This option
   is used in conjunction with :option:`-httproot` to tell the HTTP server which
   files should be processed as Lasso code. Note that multiple extensions are
   delimited by semicolons.

   Default is to not treat any files as Lasso code.

.. option:: -addapp <path>

   This option specifies a path to a LassoApp that is to be installed when
   lassoserver starts up. This allows you to include LassoApps that are outside
   the LassoApp directory in your instance home directory. This option can be
   specified multiple times with different paths and all specified LassoApps
   will be installed.

   Default is to not install any additional LassoApps.


Starting lassoserver
--------------------

To start lassoserver as a FastCGI server listening on port 9000::

   $> lassoserver -p 9000

To start lassoserver as a FastCGI server listening on a socket at
"$LASSO9_HOME/lasso.sock"::

   $> lassoserver -flisten lasso.sock

To start lassoserver as a FastCGI proxy server listening on a socket at
"/tmp/lasso.sock"::

   $> lassoserver -fproxy //tmp/lasso.sock

To start lassoserver as an HTTP server that processes "\*.lasso" and "\*.inc"
files as Lasso code::

   $> lassoserver -httproot /path/to/webroot -scriptextensions "lasso;inc"


lassoim(d)
==========

.. index:: lassoim(d)

The :program:`lassoim(d)` executable is installed at :file:`/usr/sbin/lassoim`
on OS X, :file:`/usr/sbin/lassoimd` on Linux operating systems, and
:file:`C:\\Program Files\\LassoSoft\\Lasso Instance
Manager\\home\\LassoExecutables\\lassoim` on Windows. This program creates the
FastCGI server that runs Lasso's Instance Manager web application. It also makes
sure that all enabled instances are running.

To manually start lassoim(d), just call it from the command line. (It ignores
any arguments passed to it.) ::

   $> lassoim

When running this executable, it is important to set the :envvar:`LASSO9_HOME`
environment variable to a path of a directory containing all the built-in Lasso
libraries. By default, this should be :file:`/var/lasso/home` on OS X and Linux
operating systems.


lasso9
======

.. index:: lasso9

The :program:`lasso9` executable is installed at :file:`/usr/bin/lasso9` on OS X
and Linux operating systems and at :file:`C:\\Program Files\\LassoSoft\\Lasso
Instance Manager\\home\\LassoExecutables\\lasso9` on Windows. This program can
execute Lasso code from a file, piped from STDIN, passed in as a string, or
inside an interactive interpreter. This executable doesn't load and start up
everything that :program:`lassoserver` does. See the section
:ref:`command-loading-libraries` for what isn't loaded and how to load the extra
components if you need them.

To execute a file of Lasso code, pass the path to the file as the argument to
lasso9. For example::

   $> lasso9 /path/to/code.lasso

.. program:: lasso9

.. option:: -s <code>

   Use :option:`-s` to execute the string passed to lasso9 as Lasso code::

   $> lasso9 -s "lasso_version"

.. option:: --

   Use :option:`--` to execute Lasso code from STDIN::

   $> echo 'lasso_version' | lasso9 --

.. option:: -i

   Use :option:`-i` to execute Lasso code interactively. When you do this a new
   prompt will appear (``>:``), and what you type there will be processed as
   Lasso code when you hit :kbd:`return`. You can also paste small amounts of
   multi-line code into the prompt; just be sure to hit :kbd:`return` right
   after pasting so that the last line of code will be included. When finished,
   type :kbd:`Control-C` to exit.

.. parsed-literal::

   $> lasso9 -i
   >: lasso_version
   Mac OS X |version|
   >: loop(3) => { stdoutnl(loop_count) }
   1
   2
   3

.. note::
   Each chunk of code is processed as if it were a separate file, so local
   variables processed in one chunk are unavailable to future chunks. You'll
   either need to copy and paste multi-line code, or use thread variables.

For more details, see the section :ref:`calling-lasso-cli` in the
:ref:`calling-lasso` chapter.


lassoc
======

.. index:: lassoc

The :program:`lassoc` executable is installed at :file:`/usr/bin/lassoc` on OS X
and Linux operating systems and at :file:`C:\\Program Files\\LassoSoft\\Lasso
Instance Manager\\home\\LassoExecutables\\lassoc` on Windows. This program is
used to compile LassoApps, Lasso libraries, and Lasso executables. See the
section :ref:`command-compiling-lasso` below for more information.


.. _command-environment-variables:

Special Environment Variables
=============================

There are several environment variables that have various effects on running
:program:`lasso9`, :program:`lassoserver`, or custom Lasso executables. The
following lists the variables and a description of their function:

.. envvar:: LASSO9_HOME

   This variable is set to the path of a directory containing either the
   instance-specific libraries and startup items, or to a path containing all of
   the Lasso built-in libraries. If set to an instance-specific home directory,
   be sure to also set the :envvar:`LASSO9_MASTER_HOME` variable.

   Default is :file:`/var/lasso/home` for OS X and Linux.

.. envvar:: LASSO9_MASTER_HOME

   This variable must be set to a directory containing all the built-in Lasso
   libraries if the :envvar:`LASSO9_HOME` variable is set to an
   instance-specific home directory.

   Default is not set.

.. envvar:: LASSO9_PRINT_FAILURES

   This variable can be set to an integer that specifies how verbose a Lasso
   executable should be in its error reporting. Setting it to "1" outputs the
   most information, with larger integer values making it less verbose.

   Default is not set, which is the least verbose.

.. envvar:: LASSO9_RETAIN_COMMENTS

   If this variable is set to "1", Lasso will retain any doc comments in the
   code it loads, allowing you to programmatically view and process these
   comments.

   Default is not set.

.. envvar:: LASSO9_PRINT_LIB_LOADS

   If this variable is set to "1", Lasso will print diagnostic information to
   STDOUT regarding the on-demand libraries that it loads. This can be useful
   when debugging your own on-demand Lasso libraries.

   Default is not set.

.. envvar:: LASSOSERVER_APP_PREFIX

   If this variable is set by the web server, lassoserver will assume the
   host is dedicated to serving a single LassoApp, and will prepend this path to
   all `lassoApp_link` paths. For details and an example, see the section
   :ref:`lassoapps-server-configuration` in the :ref:`lassoapps` chapter.

   Default is not set.

.. envvar:: LASSOSERVER_DOCUMENT_ROOT

   If this variable is set by the web server, lassoserver will use this path
   instead of the standard :envvar:`DOCUMENT_ROOT` to serve files from. This can
   be useful when using Apache's ``VirtualDocumentRoot`` or ``UserDir``
   features. In the example below, Apache will serve any of the folder names in
   "/srv/lasso/sites/" as virtual hosts, and Lasso will use the value of
   :envvar:`LASSOSERVER_DOCUMENT_ROOT` as each host's document root.

   .. code-block:: apacheconf

      <VirtualHost *:80>
          ServerName admin.local
          VirtualDocumentRoot "/srv/lasso/sites/%1"
          RewriteEngine on
          RewriteRule ^ - [E=LASSOSERVER_DOCUMENT_ROOT:/srv/lasso/sites/%{HTTP_HOST}]
      </VirtualHost>

   Default is not set.

.. envvar:: LASSOSERVER_FASTCGIPORT

   Set the port that the FastCGI server binds on. Same as specifying the
   :option:`-p` option.

.. envvar:: LASSOSERVER_USER

   Specifies the OS user to run lassoserver as. Same as specifying the
   :option:`-user` option.

.. envvar:: LASSOSERVER_GROUP

   Specifies the OS group to run lassoserver as. Same as specifying the
   :option:`-group` option.


Lasso Shell Scripts on OS X and Linux
=====================================

.. index:: shell script

While most developers use Lasso to create dynamic websites, you can also write
Lasso code that can be run from the command line to assist you in administrative
or repetitive tasks. These files that run from the command line are often called
:dfn:`shell scripts` since you run them from your terminal's shell.


Running Scripts
---------------

There are two ways to run a file containing Lasso code from the command line:

-  Pass the path of the file to the :program:`lasso9` executable::

      $> lasso9 /path/to/code.lasso

-  Make sure the file has execute permissions turned on and that it starts with
   the proper hashbang, then call the file directly::

      $> /path/to/code.lasso

This second option requires having the file's executable permissions set. You
can do this in OS X or Linux with the :command:`chmod` command::

   $> chmod +x /path/to/code.lasso

Calling the file directly also requires that the file contain the proper
hashbang, which tells your shell which interpreter to use when executing the
file. It must be the first line of the file and it starts with the pound sign
and an exclamation mark followed by the path to the interpreter. For Lasso code,
it should look like this::

   #!/usr/bin/env lasso9

If you have a custom installation of Lasso, adjust the path to the lasso9
executable accordingly.


Reading Command-Line Arguments
------------------------------

.. highlight:: lasso

When running Lasso shell scripts, Lasso provides two special thread variables
for inspecting the command that was run and the arguments that were passed to
it: "argc" and "argv". The "argc" variable returns the number of arguments,
including the command. The "argv" variable returns a staticarray in which the
first element is the command and the remaining elements are the arguments passed
to the command.

The following example outputs the values of ``$argc`` and ``$argv`` when the
script is run using the lasso9 tool. The contents of the file
"/path/to/code.lasso" are::

   stdoutnl($argc)
   stdoutnl($argv)

Here's what happens when you run the code:

.. code-block:: none

   $> lasso9 /path/to/code.lasso -moose hair
   3
   staticarray(/path/to/code.lasso, -moose, hair)

The following example shows the values of ``$argc`` and ``$argv`` when the
script is run directly. The contents of the file "/path/to/code.lasso" are::

   #!/usr/bin/env lasso9
   stdoutnl($argc)
   stdoutnl($argv)

Here's what happens when you run the script directly:

.. code-block:: none

   $> /path/to/code.lasso -moose hair
   3
   staticarray(/path/to/code.lasso, -moose, hair)

As you can see, calling the script with lasso9 produces the same result as
calling the script directly, so you don't ever need to worry about the first
element in ``$argv`` being "lasso9".

Using these two thread variables, you can create scripts whose behavior changes
when different arguments are passed to them. In fact, the lasso9 executable
itself is a Lasso shell script (`source`_), written in Lasso and compiled into a
binary.


.. _command-loading-libraries:

Loading Libraries in Shell Scripts
==================================

.. index:: LCAPI, LJAPI

Lasso shell scripts are not run in the :program:`lassoserver` context. This
means that various libraries and tools that lassoserver loads are not loaded or
available by default when your script runs. Although all the core libraries are
available, the LCAPI modules, LJAPI modules, logging system, email queue,
security registry, web request and response environment, LassoApps, and files in
"LassoStartup" are not loaded. This is actually beneficial since your script
would otherwise take as long as lassoserver to start up before getting to
running your code. If you find you need something that isn't loaded, you can
load it yourself. The sections below will show you how.


Load All Database and LCAPI Modules
-----------------------------------

If you want to have access to all database connectors and to all the LCAPI
modules such as the ImageMagick methods or the :type:`os_process` type, you can
load them all with the `database_initialize` method::

   #!/usr/bin/env lasso9
   database_initialize


Load Specific LCAPI Modules
---------------------------

If you want, you can just load individual LCAPI modules. The following example
loads just the MySQL database connector::

   #!/usr/bin/env lasso9
   // If LASSO9_MASTER_HOME is specified, find module there
   // Otherwise, find it in the LASSO9_HOME path
   lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/MySQLConnector.' + sys_dll_ext)


Set Up the LJAPI Environment
----------------------------

To create the JVM and set up the LJAPI environment, you must first load the
LJAPI9 LCAPI module and then call the `ljapi_initialize` method::

   #!/usr/bin/env lasso9
   match(lasso_version(-lassoplatform)) => {
      case('Linux')
         lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/LJAPI.so')
      case('Mac OS X')
         lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/LJAPI9.dylib')
      // Fail if unknown OS
      case
         fail('Unknown platform')
      }
   ljapi_initialize


Load a LassoApp
---------------

LassoApps have the ability to run or load code when they are initialized. Often
this code adds methods, types, or traits that you may want available in your
Lasso shell scripts. The code below contains three examples of loading up
LassoApps: one for compiled LassoApps, one for zipped LassoApps, and one for a
LassoApp directory. ::

   #!/usr/bin/env lasso9
   // Load a compiled LassoApp from LASSO9_MASTER_HOME if specified
   // Otherwise, load it from LASSO9_HOME
   lassoapp_installer->install(
      lassoapp_compiledsrc_appsource(
         (sys_masterHomePath || sys_homePath) +
         '/LassoApps/example.lassoapp'
      )
   )

   // Load a zipped LassoApp from LASSO9_HOME
   lassoapp_installer->install(
      lassoapp_zipsrc_appsource(sys_appsPath + 'example.zip')
   )

   // Load a LassoApp from the specified directory
   lassoapp_installer->install(
      lassoapp_dirsrc_appsource('//path/to/example/')
   )


Include Another File with Lasso Code
------------------------------------

.. index:: sourcefile()

If you would like to run Lasso code in another file from your script, you can
include that file using the :type:`sourcefile` type. The following example will
have "/path/to/code.lasso" running the code from "/path/to/doc.lasso"::

   // Contents of /path/to/code.lasso
   local(doc) = sourcefile(file('//path/to/doc.lasso'))
   stdoutnl("Calling " + #doc->filename + "...")
   #doc->invoke
   stdoutnl("This is heavy.")

::

   // Contents of /path/to/doc.lasso
   stdoutnl("Great Scott!")

Here's what happens when you run "/path/to/code.lasso":

.. code-block:: none

   $> lasso9 /path/to/code.lasso
   Calling //path/to/doc.lasso...
   Great Scott!
   This is heavy.


Include Another File Relative to the Script
-------------------------------------------

Sometimes it's helpful to have the script you are running able to include a file
that is relative to the script. If you pass a relative path to the :type:`file`
type, it will expect the file you are trying to reference to be included
relative from your shell's current working directory. To get around this, you
must have the current script figure out the absolute path to its parent
directory so you can append the relative path. The following code does just
that::

   #!/usr/bin/env lasso9
   // Contents of /path/to/project/sub1/code.lasso

   // This should let us run this file anywhere and still properly import relative files
   local(path_here) = currentCapture->callsite_file->stripLastComponent
   not #path_here->beginsWith('/') ?
      #path_here = io_file_getcwd + '/' + #path_here
   not #path_here->endsWith('/') ?
      #path_here->append('/')
   local(f) = file(#path_here + '../sub2/code.lasso')

   stdoutnl("Loading ../sub2/code.lasso")
   sourcefile(#f)->invoke
   stdoutnl("Done.")

::

   // Contents of /path/to/project/sub2/code.lasso
   stdoutnl("I am a relative include.")

Here's what happens when you run "/path/to/project/sub1/code.lasso":

.. code-block:: none

   $> /path/to/project/sub1/code.lasso
   Loading ../sub2/code.lasso
   I am a relative include.
   Done


Change the Working Directory
----------------------------

Occasionally you may find it helpful to change the directory context your script
is running in. You can use the `dir->setcwd` method to do so::

   #!/usr/bin/env lasso9
   // Contents of /path/to/code.lasso

   stdoutnl("We are here: " + io_file_getcwd)
   dir('/etc/')->setcwd
   stdoutnl("Now we are here: " + io_file_getcwd)

Here's what happens when you run this file:

.. code-block:: none

   $> cd /path/to/
   $> lasso9 ./code.lasso
   We are here: /path/to
   Now we are here: /etc


Read and Set Environment Variables
----------------------------------

Lasso can read and set shell environment variables using `sys_getEnv` and
`sys_setEnv` respectively. The following example adds a directory to the "PATH"
environment variable for the script::

   #!/usr/bin/env lasso9
   // Contents of /path/to/code.lasso

   // Ignore the return value of sys_setEnv
   local(_) = sys_setEnv(`PATH`, `/var/lasso/home/bin:` + sys_getEnv(`PATH`))
   stdoutnl(sys_getEnv(`PATH`))

Here's what happens when you run this script:

.. code-block:: none

   $> /path/to/code.lasso
   /var/lasso/home/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin


.. _command-compiling-lasso:

Compiling Lasso Code
====================

All Lasso code is compiled before it is executed. Whether the code is a Lasso
page being served by Lasso Server or a script being run by the :program:`lasso9`
command-line tool, behind the scenes Lasso compiles the code and then executes
the compiled code. (Lasso does cache the compiled code for re-use, but that is
beyond the scope of this section.)

There are certain cases where it is advantageous to compile the Lasso code ahead
of time. The Lasso platform comes with the :program:`lassoc` command-line tool
which aids in compiling LassoApps, Lasso libraries, and Lasso executables.
Compilation can result in faster startup times, lower memory usage, and
obfuscation of the source code.

Libraries help keep memory usage down because only objects that are actually
used are loaded. They also improve startup time. Lasso can start up by only
loading the very basic built-in functions and objects and then let the rest of
the system load in over time.

A special type of library called a :dfn:`bitcode` file can also be produced,
which has a "|dot| bc" file extension. Bitcode is an LLVM-specific format that
Lasso knows how to load. Bitcode files can be shared across platforms on the
same processor. For example, the same bitcode file could be used on OS X x86 and
CentOS x86. Bitcode files don't load as fast, have about 80% larger file size
and consume more memory than library files compiled into a shared library, but
they don't require GCC and are cross-platform.


Prerequisites
-------------

The following must be installed to compile Lasso code:

-  Lasso Server installed on a supported OS
-  Your operating systems's developer command-line tools. (Consult the
   documentation for your OS on how to install a compiler, linker, etc.)
-  For OS X, you will also need the 10.5 SDK libraries in order to create
   binaries that are compatible with all supported versions of OS X. See this
   link for unsupported help with `installing older SDKs`_.

The examples below are shown running from a command-line prompt. For Windows,
make sure you are running these commands from the Visual Studio command prompt.


Compiling Executables
---------------------

.. highlight:: none

You can compile shell scripts into executable files. This decreases the overhead
of running the script through the :program:`lasso9` tool, and allows you to
distribute your own command-line tools without distributing the source code. The
examples below take a shell script named "myscript.lasso" and compile it into
the executable "myscript".

.. rubric:: OS X

::

   $> lassoc -O -app -n -obj -o myscript.a.o myscript.lasso
   $> gcc -o myscript myscript.a.o -isysroot /Developer/SDKs/MacOSX10.5.sdk \
   -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 \
   -macosx_version_min=10.5 -F/Library/Frameworks -framework Lasso9

.. rubric:: Linux

::

   $> lassoc -O -app -n -obj -o myscript.a.o myscript.lasso
   $> gcc -o myscript myscript.a.o -llasso9_runtime

.. rubric:: Windows

::

   $> lassoc -O -app -n -obj -o myscript.obj myscript.lasso
   $> link myscript.obj \
   > /LIBPATH:"C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables" \
   > lasso9_runtime.lib -defaultlib:libcmt


Compiling Libraries
-------------------

You can create your own library of methods and types and then compile it into
one library file for distribution. Libraries compiled this way go into the
"LassoLibraries" directory of an instance's :envvar:`LASSO9_HOME` or
:envvar:`LASSO9_MASTER_HOME` directory. The advantages of doing this instead of
placing the source code in the "LassoStartup" directory are that Lasso starts
faster and consumes less memory. This is because Lasso only loads the methods
and types in libraries when they are first used instead of at startup. This
makes starting an instance of Lasso Server faster as the code will be loaded
when first needed, and it helps keep memory down as only those methods and types
that are actually used by the instance get loaded.

The examples below take a file named "mylibs.inc" and compile it into a
dynamically loaded Lasso library.

.. rubric:: OS X

::

   $> lassoc -O -dll -n -obj -o mylibs.d.o mylibs.inc
   $> gcc -dynamiclib -o mylibs.dylib mylibs.d.o -isysroot /Developer/SDKs/MacOSX10.5.sdk \
   -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 \
   -macosx_version_min=10.5 -F/Library/Frameworks -framework Lasso9

.. rubric:: Linux

::

   $> lassoc -O -dll -n -obj -o mylibs.d.o mylibs.inc
   $> gcc -shared -o mylibs.so mylibs.d.o -llasso9_runtime

.. rubric:: Windows

::

   $> lassoc -O -dll -n -obj -o mylibs.obj mylibs.inc
   $> link /DLL mylibs.obj /OUT:mylibs.dll \
   /LIBPATH:"C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables" \
   lasso9_runtime.lib -defaultlib:libcmt


Compiling LassoApps
-------------------

LassoApps allow you to create an easily deployable and distributable web
application. They are installed into the "LassoApps" directory of an instance's
:envvar:`LASSO9_HOME` or :envvar:`LASSO9_MASTER_HOME` directory. (See the
:ref:`lassoapps` chapter for more information.) Compiling them allows Lasso to
start up faster and allows for distributing closed-sourced solutions.

The examples below take a folder named "myapp" and compile it into a LassoApp
named "myapp.lassoapp".

.. rubric:: OS X

::

   $> lassoc -O -dll -n -obj -lassoapp -o myapp.ap.o myapp/
   $> gcc -dynamiclib -o myapp.lassoapp myapp.ap.o -isysroot /Developer/SDKs/MacOSX10.5.sdk \
   -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 \
   -macosx_version_min=10.5 -F/Library/Frameworks -framework Lasso9

.. rubric:: Linux

::

   $> lassoc -O -dll -n -obj -lassoapp -o myapp.ap.o myapp/
   $> gcc -shared -o myapp.lassoapp myapp.ap.o -llasso9_runtime

.. rubric:: Windows

::

   $> lassoc -O -dll -n -obj -lassoapp -o myapp.lassoapp.obj myapp
   $> link /DLL myapp.lassoapp.obj /OUT:myapp.lassoapp \
   /LIBPATH:"C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables" \
   lasso9_runtime.lib -defaultlib:libcmt


Using Build Utilities
---------------------

Instead of manually executing those commands each time you want to compile your
code, it is recommended you use a build utility like :command:`make` for OS X
and Linux or :command:`nmake` for Windows. Both of these utilities are very
powerful and you should explore their documentation. The Lasso source tree has
an example of both a `make file`_ and an `nmake file`_ which you can download
and modify to fit your solutions.

.. _source: http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/lasso9.lasso
.. _installing older SDKs: http://hints.macworld.com/article.php?story=20110318050811544
.. _make file: http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/makefile
.. _nmake file: http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/makefile.nmake
