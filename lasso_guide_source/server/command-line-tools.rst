.. _command-line-tools:

++++++++++++++++++++++++
Lasso Command-Line Tools
++++++++++++++++++++++++

The Lasso platform comes with various command-line tools to assist you. Lasso
uses some of these tools to create and run the instances of Lasso that talk with
your web server. This chapter will contain an overview of those tools and
describe how you can run them yourself.


lassoserver
===========

The lassoserver executable is installed at "/usr/sbin/lassoserver" on OS X and
Linux operating systems and at "C:\\Program Files\\LassoSoft\\Lasso Instance
Manager\\home\\LassoExecutables\\lassoserver" on Windows. This program creates a
FastCGI server that interfaces with web servers to process Lasso files in
response to web requests. Each instance of Lasso has its own lassoserver process
running a FastCGI server. Additionally, the lassoserver executable can start up
an HTTP server instead of a FastCGI server. As an HTTP server, it can serve both
static files and Lasso files. This is great for local development, but you
should run a production web server (such as Apache) for your production servers.

The following is the list of options for running lassoserver:

================================ ===============================================
Option                           Description
================================ ===============================================
-p tcp_listen_port               Set the port that either the FastCGI or HTTP
                                 server binds on. This option is ignored if you
                                 choose an option to create a FastCGI socket.
                                 
                                 Default is 8999.
                                 
-addr tcp_bind_address           Set the IP address to bind to when running as
                                 either a FastCGI or HTTP server. This option is
                                 ignored if you choose an option to create a
                                 FastCGI socket.
                                 
                                 Default is 0.0.0.0 which will bind to all IPs
                                 associated with your machine.
                                 
-fproxy fcgi_proxy_socket        Specify the path to create a socket for FastCGI
                                 proxy requests to be sent. This path will be
                                 relative to :term:`LASSO9_HOME` unless you
                                 start the path with two slashes.
                                 
                                 Default is to not create this socket.
                                 
-flisten fcgi_listen_socket      Specify the path to create a socket for FastCGI
                                 requests to be sent. This path is always
                                 relative to :term:`LASSO9_HOME`. 
                                 
                                 Default is to not create this socket.
                                 
-user user                       Specifies the OS user to run lassoserver as. In
                                 order for this to be successful, you must be
                                 running lassoserver with root privileges.

                                 Default is to run as the user invoking
                                 lassoserver.
                                 
-group group                     Specify the OS group to run lassoserver as. In
                                 order for this to be effective, you must run
                                 lassoserver with root privileges.
                                 
                                 Default is to run as the primary group of the
                                 user invoking lassoserver.
                                 
-httproot path                   This option tells lassoserver to start an HTTP
                                 server instead of a FastCGI server and to use
                                 the path specified as the webroot. This option
                                 will be ignored if either "-fproxy" or
                                 "-flisten" is specified.
                                 
                                 Default is to not start up as an HTTP server.
                                 
-scriptextensions ext1;ext2;ext3 Identify which file extensions should be
                                 considered Lasso files. This option is used in
                                 conjuction with "-httproot" to tell the HTTP
                                 server which files should be processed as Lasso
                                 code. Note that multiple extensions are
                                 delineated by semicolons.
                                 
                                 Default is not to treat any files as Lasso code
                                 
-addapp path                     This option specifies a path to a LassoApp to
                                 be installed when lassoserver starts up. This
                                 allows you to include LassoApps that are
                                 outside the LassoApp directory in your instance
                                 home directory. This option can be specified
                                 multiple times with different paths and all
                                 specified LassoApps will be installed.
                                 
                                 Default is to not install any additional
                                 LassoApps.
================================ ===============================================


Examples
--------

To start lassoserver as a FastCGI server listening on port 9000::

   $> lassoserver -p 9000

To start lassoserver as a FastCGI server listening on a socket at
"$LASSO9_HOME/lasso.sock"::

   $> lassoserver -flisten lasso.sock

To start lassoserver as a FastCGI proxy server listening on a socket at
"/tmp/lasso.sock"::

   $> lassoserver -fproxy //tmp/lasso.sock

To start lassoserver as an HTTP server that processes ".lasso" and ".inc" files
as Lasso code::

   $> lassoserver -httproot /path/to/webroot -scriptextensions "lasso;inc"


lassoim(d)
==========

The lassoim(d) executable is installed at "/usr/sbin/lassoim" on OS X,
"/usr/sbin/lassoimd" on Linux operating systems, and "C:\\Program
Files\\LassoSoft\\Lasso Instance Manager\\home\\LassoExecutables\\lassoim" on
Windows. This program creates the FastCGI server that runs Lasso's Instance
Manager web application. It also makes sure that all enabled instances are
running.

To manually start lassoim(d) just call it from the command-line. (It ignores any
arguments passed to it.)::

   $> lassoim

When running this executable, it is important to set the :term:`LASSO9_HOME`
environment variable to a path of a directory containing all the built-in Lasso
libraries. By default, this should be "/var/lasso/home" on OS X and Linux
operating systems.


lasso9
======

The lasso9 executable is installed at "/usr/bin/lasso9" on OS X and Linux
operating systems and at "C:\\Program Files\\LassoSoft\\Lasso Instance
Manager\\home\\LassoExecutables\\lasso9" on Windows. This program can execute Lasso
code in a file, from stdin, passed to it as a string, or in an interactive
interpreter. This executable doesn't load and startup everything that
lassoserver does. See the discussion on :ref:`the libararies available to shell
scripts <libaries-available-shell-scripts>` for what doesn't get loaded and how
to load the extra pieces if you need them.

To execute a file of Lasso code, pass the path to the file as the argument to
lasso9. For example::

   $> lasso9 /path/to/code.lasso

To execute Lasso code from stdin, pass "--" as the first argument to lasso9::

   $> echo 'lasso_version' | lasso9 --

To execute Lasso code passed to lasso9 as a string, pass the "-s" flag as the
first argument to lasso9::

   $> lasso9 -s "lasso_version"

For more details, see the section on :ref:`Calling Lasso on the CLI
<calling-lasso-cli>`.


To execute Lasso code interactively, call lasso9 with the "-i" flag as the first
argument. When you do this a new prompt will appear (">:"), and what you type
there will be processed as Lasso code when you hit return. You can also paste
small amounts of multi-line code into the prompt - just be sure to hit return
right after you paste so that the last line of code will be included. (One thing
to note: each chunk of code is processed as if it were a separate file, so local
variables processed in one chunk are unavailable to future chunks. You'll either
need to copy and paste multi-line code, or use thread variables.)

::

   $> lasso9 -i
   >: lasso_version
   Mac OS X 9.2
   >: loop(3) => { stdoutnl(loop_count) }
   1
   2
   3


lassoc
======

The lassoc executable is installed at "/usr/bin/lassoc" on OS X and Linux
operating systems and at "C:\\Program Files\\LassoSoft\\Lasso Instance
Manager\\home\\LassoExecutables\\lassoc" on Windows. This program is used to
compile LassoApps, Lasso libraries, and Lasso executables. See :ref:`the section
on compiling Lasso code<compiling-lasso>` for more information.


.. _special-environment-variables:

Special Environment Variables
=============================

There are four shell environment variables that have various effects on running
lasso9, lassoserver or custom Lasso executables. The following lists the
variables and a description of their function.

LASSO9_HOME
   This variable is set to the path of a directory containing either the
   instance-specific libraries and startup items, or to a path containing all of
   the Lasso 9 built-in libraries. If set to an instance-specific home
   directory, then be sure to also set the LASSO9_MASTER_HOME variable.

   Default is "/var/lasso/home" for OS X and Linux.

LASSO9_MASTER_HOME
   This variable must be set to a directory containing all the built-in Lasso
   libraries if the LASSO9_HOME variable is set to an instance-specific home
   directory.

   Default is not set.

LASSO9_PRINT_FAILURES
   This variable can be set to an integer that specifies how verbose a Lasso
   executable should be in its error reporting. Setting it to 1 outputs the most
   information with larger integer values making it less verbose.

   Default is not set (which is the least verbose).

LASSO9_RETAIN_COMMENTS
   If this variable is set to 1, then Lasso will retain the documentation
   comments in the code it loads allowing you to programmatically view and
   process these comments.

   Default is not set.

LASSO9_PRINT_LIB_LOADS
   If this variable is set to 1, Lasso will print to stdout diagnostic
   information regarding the on-demand libraries that it loads. This can be
   useful when debugging your own on-demand Lasso Libraries.

   Default is not set.


Writing Shell Scripts in Lasso on OS X and Linux
================================================

While most developers use Lasso to create dynamic websites, you can also create
Lasso code that can be run from the command-line to assist you in administrative
or repetitive tasks. These files that run from the command line are often called
shell scripts since you run them from your terminal's shell.


Running Scripts
---------------

There are two ways to run a file containing Lasso code from the command-line:

#. Pass the path of the file to the lasso9 executable::

      $> lasso9 /path/to/code.lasso

#. Make sure the file has execute permissions turned on and that it starts with
   the proper :term:`hashbang` / :term:`shebang` and call the file directly::

      $> /path/to/code.lasso

This second option requires having the OS executable permissions set. You can do
this in OS X or Linux with the chmod command::

   $> chmod +x /path/to/code.lasso

Calling the file directly also requires that the file contain the proper
:term:`hashbang` / :term:`shebang` which tells your shell which interpreter to
use when executing the file. It must be the first line of the file and it starts
with the pound sign and an exclamation mark followed by the path to the
interpreter. For Lasso code, it should look like this::

   #! /usr/bin/lasso9

If you have a custom installation of Lasso, adjust the path to the lasso9
executable accordingly.


Dealing with Command-Line Arguments
-----------------------------------

When running Lasso command-line scripts, Lasso provides two special thread
variables to inspect the command that was run and the arguments that were passed
to it: ``$argc`` and ``$argv``. The ``$argc`` variable returns the number of
arguments, including the command. The ``$argv`` variable returns a staticarray -
the first element of which is the command and the remaining elements are the
arguments passed to the command.


The following example outputs the values of ``$argc`` and ``$argv`` when the
script is run using the lasso9 executable. The contents of the file
"/path/to/code.lasso" are::

   stdoutnl($argc)
   stdoutnl($argv)

Here's what happens when you run the code::

   $> lasso9 /path/to/code.lasso -moose hair
   3
   staticarray(/path/to/code.lasso, -moose, hair)

The following example shows the values of ``$argc`` and ``$argv`` when the
script is run directly. The contents of the file "/path/to/code.lasso" are::
   
   #! /usr/bin/lasso9
   stdoutnl($argc)
   stdoutnl($argv)

Here's what happens when you run the script directly::

   $> /path/to/code.lasso -moose hair
   3
   staticarray(/path/to/code.lasso, -moose, hair)

As you can see, calling the script with lasso9 produces the same thing as
calling the script directly, so you don't ever need to worry about the first
element in ``$argv`` being "lasso9".

Using these two thread variables, you can create scripts whose behavior changes
when different arguments are passed to them. In fact, the lasso9 executable
itself is a Lasso shell script - written in Lasso and compiled into a binary.
(You can view its source here:
`<http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/lasso9.lasso>`_.)


.. _libaries-available-shell-scripts:

What Libraries are Available in a Shell Script
==============================================

Lasso shell scripts are not run in the lassoserver context. This means that
various libraries and tools that lassosever loads are not loaded or available by
default when your script runs. While all the core libraries are available, the
LCAPI modules, LJAPI modules, logging system, email queue, security registry,
web request and response environment, LassoApps, and files in LassoStartup are
not loaded. This is actually beneficial since your script would otherwise take
as long as lassoserver to startup before it got to running your code. If you
find you need something that isn't loaded, you can load it yourself. The
sections below will show you how.


Loading All Database and LCAPI Modules
--------------------------------------

If you want to have access to all database connectors and to all the LCAPI
modules such as the ImageMagick methods or the ``os_process`` type you can load
them all with the ``database_initialize`` method::

   #! /usr/bin/lasso9
   database_initialize


Load Specific LCAPI Modules
---------------------------

If you want, you can just load individual LCAPI modules. The following example
just loads the MySQL database connector::

   #! /usr/bin/lasso9
   // If LASSO9_MASTER_HOME is specified, find module there
   // Otherwise find it in the LASSO9_HOME path
   lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/MySQLConnector.' + sys_dll_ext)


Setup LJAPI Environment
-----------------------

To create the JVM and setup the LJAPI environment, you must first load the
LJAPI9 LCAPI module and then call the ``ljapi_initialize`` method::

   #! /usr/bin/lasso9

   match(lasso_version(-lassoplatform)) => {
   case('Linux')
       lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/LJAPI.so')
   case('Mac OS X')
       lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/LJAPI9.bundle')
   // Fail if unknown OS
   case
       fail('Unknown platform')
   }
   ljapi_initialize


Load a LassoApp
---------------

LassoApps have the ability to run / load code when they are initialized. Often
this code adds methods / types / traits that you may want available in your
Lasso shell scripts. The code below contains three examples of loading up
LassoApps - one for compiled LassoApps, one for zipped LassoApps, and one for a
LassoApp directory::

   #! /usr/bin/lasso9
   // Load a compiled LassoApp from LASSO9_MASTER_HOME if specified
   // Else load it from LASSO9_HOME
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

If you would like to run Lasso code in another file from your script, you can
include that file using the ``sourcefile`` method. The following example will
have "/path/to/code.lasso" running the code from "/path/to/doc.lasso"::

   // Contents of /path/to/code.lasso
   local(doc) = file('//path/to/doc.lasso')
   sourcefile(#doc)->invoke
   stdoutnl('This is heavy.')

::

   // Contents of /path/to/doc.lasso
   stdoutnl('Great Scott!')

Here's what happens when you run "/path/to/code.lasso"::

   $> lasso9 /path/to/code.lasso
   Great Scott!
   This is heavy.


Include Another File Relative to the Path of the Running Script
---------------------------------------------------------------

Sometimes it would be nice to have the script you are running be able to include
a file that is relative to the script. If you pass a relative path to the
``file`` type, it will expect the file you are trying to reference to be
included relative from your shell's current working directory. To get around
this, you must have the current script figure out the absolute path to its
parent directory and then you can append the relative path. The following code
does just that::

   // Contents of /path/to/project/sub1/code.lasso
   #! /usr/bin/lasso9

   // This should let us run this file anywhere and still properly import relative files
   local(path_here) = currentCapture->callsite_file->stripLastComponent
   not #path_here->beginsWith('/')
       ? #path_here = io_file_getcwd + '/' + #path_here
   not #path_here->endsWith('/') 
       ? #path_here->append('/')
   local(f) = file(#path_here + '../sub2/code.lasso')

   stdoutnl('Loading ../sub2/code.lasso')
   sourcefile(#f)->invoke
   stdoutnl('Done')

::

   // Contents of /path/to/project/sub2/code.lasso
   stdoutnl('I am a relative include.')

Here's what happens when you run "/path/to/project/sub1/code.lasso"::
   
   $> /path/to/project/sub1/code.lasso
   Loading ../sub2/code.lasso
   I am a relative include.
   Done


Change the Working Directory
----------------------------

Occasionally you may find it helpful to change the directory context your script
is running in. You can use the ``dir->setcwd`` method to do just that::

   // Contents of /path/to/code.lasso
   #! /usr/bin/lasso9
   stdoutnl('We are here: ' + io_file_getcwd)
   dir('/etc/')->setcwd
   stdoutnl('Now we are here: ' + io_file_getcwd)

Here's what happens when you run this file::
   
   $> cd /path/to/
   $> lasso9 ./code.lasso
   We are here: /path/to
   Now we are here: /etc


Reading and Setting Environment Variables
-----------------------------------------

Lasso can read and set shell environment variables using ``sys_getEnv`` and
``sys_setEnv`` respectively. The following example adds a directory to the
"PATH" environment variable for the script::

   // Contents of /path/to/code.lasso
   #! /usr/bin/lasso9
   // Ignore the return value of sys_setEnv
   local(_) = sys_setEnv(`PATH`, `/var/lasso/home/bin:` + sys_getEnv(`PATH`))
   stdoutnl(sys_getEnv(`PATH`))

Here's what happens when you run this script::

   $> /path/to/code.lasso
   /var/lasso/home/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin


.. _compiling-lasso:

Compiling Lasso Code
====================

All Lasso code is compiled before it is executed. Whether the code is a
:term:`Lasso page` being served by Lasso server or a script being run by the
lasso9 command-line tool, behind the scenes Lasso compiles the code and then
executes the compiled code. (Lasso does cache the copiled code for reuse, but
that is beyond the scope of this section.)

There are certain cases where it is advantageous to compile the lasso code ahead
of time. The Lasso platform comes with the lassoc command-line tool which aids
in compiling LassoApps, Lasso libraries, and Lasso executables. Compilation can
result in faster startup times, lower memory usage, and obfuscation of the
source code.






Libraries help keep memory usage down because only objects that are actually used are loaded
They also improve startup time
Lasso can startup by only loading the very basic builtin functions and objects
and then let the rest of the system load in over time

A special type of library can be produced: a .bc bitcode file. Bitcode is a LLVM
specific format that Lasso knows how to load. bitcode files can be shared across
platforms on the same processor For example the same .bc file could be used on
OS X x86 and CentOS x86 .bc files don't load as fast, have about 80% larger file
size and consume more memory than library files compiled into a shared library
but don't require GCC


Prerequisites
-------------

The following must be installed to compile Lasso code:

*  Lasso 9

*  Your operating systems's developer command-line tools. (Consult the
   documentation for your OS on how to install a compiler, linker, etc.)

*  For OS X, you will also need Xcode 3 installed for the 10.5 SDK libraries in
   order to create binaries that are compatible with all supported versions of
   OS X.

The examples below are shown running from a command-line prompt. For Windows,
make sure you are running these commands from the Visual Studio command prompt.


Compiling Executables
---------------------

You can compile shell scripts into executable files. This decreases the overhead
of running the script through the lasso9 interpreter, and allows you to
distribute your own command-line tools without distributing the source code. The
examples below take a shell script named "myscript.lasso" and compile it into
the executable "myscript".

**OS X**
::

   $> lassoc -O -app -n -obj -o myscript.a.o myscript.lasso
   $> gcc -o myscript myscript.a.o -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 -macosx_version_min=10.5 -F/Library/Frameworks -framework Lasso9

**Linux**
::

   $> lassoc -O -app -n -obj -o myscript.a.o myscript.lasso
   $> gcc -o myscript myscript.a.o -llasso9_runtime

**Windows**
::

   $> lassoc -O -app -n -obj -o myscript.obj myscript.lasso
   $> link myscript.obj /LIBPATH:"C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables" lasso9_runtime.lib -defaultlib:libcmt


Compiling Libraries
-------------------

You can create your own library of methods and types and then compile it into
one a library file for distribution. Libraries compiled this way go into the
LassoLibraries folder of an instance's :term:`LASSO9_HOME` or
:term:`LASSO9_MASTER_HOME` folder. The advantages of doing this instead of
sticking the source code in the LassoStartup folder are that Lasso starts faster
and consumes less memory. This is because Lasso only loads the methods and types
in libraries when they are first used instead of at startup. This makes starting
an instance of Lasso Server faster as the code will be loaded when first needed,
and it helps keep memory down as only those methods and types that are actually
used by the instance get loaded.

The examples below take a file named "mylibs.inc" and compiles it into a
dynamically loaded Lasso library.

**OS X**
::

   $> lassoc -O -dll -n -obj -o mylibs.d.o mylibs.inc
   $> gcc -dynamiclib -o mylibs.dylib mylibs.d.o -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 -macosx_version_min=10.5 -F/Library/Frameworks -framework Lasso9

**Linux**
::

   $> lassoc -O -dll -n -obj -o mylibs.d.o mylibs.inc
   $> gcc -shared -o mylibs.so mylibs.d.o -llasso9_runtime

**Windows**
::

   $> lassoc -O -dll -n -obj -o mylibs.obj mylibs.inc
   $> link /DLL mylibs.obj /OUT:mylibs.dll /LIBPATH:"C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables" lasso9_runtime.lib -defaultlib:libcmt


Compiling LassoApps
-------------------

:term:`LassoApps` allow you to create an easily deployable and distributable web
application. They are installed into the LassoApps folder of an instance's
:term:`LASSO9_HOME` or :term:`LASSO9_MASTER_HOME` folder. (See the :ref:`the
chapter on LassoApps<lassoapps>` for more information.) Compiling them allows
for Lasso to startup faster and allows for distributing closed-sourced
solutions.

The examples below take a folder named "myapp" and compiles it into a
:term:`LassoApp` named "myapp.lassoapp".

**OS X**
::

   $> lassoc -O -dll -n -obj -lassoapp -o myapp.ap.o myapp/
   $> gcc -dynamiclib -o myapp.lassoapp myapp.ap.o -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 -macosx_version_min=10.5 -F/Library/Frameworks -framework Lasso9

**Linux**
::

   $> lassoc -O -dll -n -obj -lassoapp -o myapp.ap.o myapp/
   $> gcc -shared -o myapp.lassoapp myapp.ap.o -llasso9_runtime

**Windows**
::

   $> lassoc -O -dll -n -obj -lassoapp -o myapp.lassoapp.obj myapp
   $> link /DLL myapp.lassoapp.obj /OUT:myapp.lassoapp /LIBPATH:"C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables" lasso9_runtime.lib -defaultlib:libcmt




Using Build Utilities
---------------------

Instead of manually executing those commands each time you want to compile your
code, it is recommended you use a build utility like "make" for OS X and Linux
or "nmake" for Windows. Both of these utilities are very powerful and you should
explore their documentation. The Lasso source tree has an exmaple of both a
`make file <http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/makefile>`_
and an
`nmake file <http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/makefile.nmake>`_
which you can download and modify to fit your solutions.