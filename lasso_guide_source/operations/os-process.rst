.. _os-process:

******************************
Shell Commands with os_process
******************************

.. note::
   The ``os_process`` type has been deprecated and this documentation has been
   superseded by the new :ref:`sys_process type <sys-process>`.

Lasso provides the ability to execute local processes or shell commands through
the ``os_process`` type. This type allows local processes to be launched with an
array of parameters and shell variables. Some processes will execute and return
a result immediately. Other processes can be left open for interactive
read/write operations. The ``os_process`` type enables Lasso users to do things
such as execute AppleScripts, print PDF files, and filter data through external
applications.

The ``os_process`` type works across all three platforms which Lasso supports.
The UNIX underpinnings of Mac OS X and Linux mean that those two operating
systems can run many of the same commands and shell scripts. Windows presents a
very different environment including DOS commands and batch files.

The ``os_process`` type is implemented in an LCAPI module which is loaded by
default for Lasso 9 Server but not loaded when excuting Lasso 9 scripts from the
command-line. To load the LCAPI module for use in Lasso 9 shell scripts, place
the following line of code in your script::

   // If LASSO9_MASTER_HOME is specified, find module there
   // Otherwise find it in the LASSO9_HOME path
   lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/OS_Process.' + sys_dll_ext)

For more information on writing shell scripts, see the chapter on **Calling
Lasso From the Command Line**.


.. type:: os_process
.. method:: os_process(...)

   The ``os_process`` type allows a developer to create a new process on the
   machine and both read from and write data to it. The process is usually
   closed after the ``os_process`` type is destroyed, but can optionally be left
   running. The ``os_process`` type shares many of the same member methods and
   conventions as the file type. This type has been deprecated in favor of
   :ref:`sys_process<sys-process>`

.. member:: os_process->open(
         command::string,
         arguments::trait_array= ?,
         env::trait_array= ?
      )

   Opens a new process. The command string should consist of any path
   information required to find the executable and the executable name. An
   optional arguments array can be given. Any arguments are converted to strings
   and passed to the new process. An optional array of environment strings may
   also be passed in. Both of these optional arrays will be passed to the new
   process. The command string should be identical to what would have been typed
   on the command line with the Lasso site folder as the current working
   directory.

.. member:: os_process->read(length::integer= ?)::bytes

   Reads the specified number of bytes from the process. Returns a bytes object.
   The number of bytes of data actually returned from this method may be less
   than the specified number, depending on the number of bytes that are actually
   available to read. Calling this method without a byte count will read all
   bytes as they become available until the peer process terminates.

.. member:: os_process->readError(length::integer= ?)::bytes

   Reads the specified number of bytes from standard error output for the
   process. Returns a bytes object. Calling this method without a byte count
   will read all bytes as they become available until the peer process
   terminates.

.. member:: os_process->readLine()::string

   Reads data up until a carriage return or line feed. Returns a string object
   created by utilizing the current encoding set for the instance.

.. member:: os_process->readString(length::integer= ?)::string

   Reads the specified number of bytes from the process. Returns a string object
   created by utilizing the current encoding set for the instance. Calling this
   method without a byte count will read all bytes as they become available
   until the peer process terminates.

.. member:: os_process->write(data::bytes)
.. member:: os_process->write(data::string)

   Writes the data to the process. If the data is a string, the current encoding
   is used to convert the data before being written. If the data is a bytes
   object, the data is sent unaltered.

.. member:: os_process->setEncoding(encoding::string)

   Sets the encoding for the instance. The encoding controls how string data is
   written via ``os_process->write`` and how string data is returned via
   ``os_process->readString``. By default, "UTF-8" is used.

.. member:: os_process->isOpen()::boolean

   Returns ``true`` as long as the process is running. If the process was
   terminated, it will return ``false``.

.. member:: os_process->detach()
   
   Detaches the ``os_process`` object from the process. This will prevent the
   process from terminating when the ``os_process`` object is destroyed.

.. member:: os_process->close()

   Closes the connection to the process. This will cause the process to
   terminate unless it has previously been detached from the ``os_process``
   object by calling ``os_process->detach``

.. member:: os_process->closeWrite

   Closes the "write" portion of the connection to the process. This results in
   the process's standard input file being closed.


Mac OS X and Linux Examples
===========================

This section includes several examples of using ``os_process`` on OS X. Except
for the AppleScript example, all of these examples should also work on Linux
machines.

Echo
----

This example uses the ``/bin/echo`` command to simply echo the input back to
stdout which is then read by Lasso::

   <?lasso
      local(os) = os_process('/bin/echo', array( 'Hello World!'))
      #os->read->encodeHTML
      #os->close
   ?>
   // =>
   // Hello World!


List
----

This example uses the ``/bin/ls`` command to list the contents of a directory::

   <?lasso
      local(os) = os_process('/bin/ls', (: '/' + sys_homePath))
      #os->readString->encodeHTML(true, false)
      #os->close
   ?>
   // =>
   // JDBCDrivers
   // JavaLibraries
   // LassoAdmin
   // LassoApps
   // LassoErrors.txt
   // LassoLibraries
   // LassoModules
   // LassoStartup
   // SQLiteDBs


Create File
-----------

This example uses the ``/usr/bin/tee`` command to create a file "test.txt" in
the site folder. The code does not generate any output, it just creates the
file::

   <?lasso
      local(os) = os_process
      handle => {
         #os->close
      }
      #os->open('/usr/bin/tee', (: './test.txt'))
      #os->write('This is a test\n')
      #os->write('This is a test\n')
      #os->close
   ?>


Print
-----

This example uses the ``/usr/bin/lpr`` command to print some text on the default
printer. The result in this case is a page that contains the phrase "This is a
test" at the top. This style of printing can be used to output text data using
the default font for the printer. The ``lpr`` command can also be used with some
common file formats such as PDF files::

   <?lasso
      local(os) = os_process('/usr/bin/lpr')
      #os->write('This is a test')
      #os->write(bytes->import8Bits(4)&)
      #os->closeWrite
      #os->close
   ?>


AppleScript
-----------

This example uses the ``/usr/bin/osascript`` command to run a simple
AppleScript. AppleScript is a full programming language which provides access to
the system and running applications in Mac OS X. The script shown simply returns
the current date and time::

   <?LassoScript
      local(os) = os_process('/usr/bin/osascript', (: '-'))
      #os->write('return current date')
      #os->closeWrite
      #os->read->encodeHTML
      #os->close
   ?>
   // =>
   // Tuesday, March 21, 2006 11:52:34 AM


Web Request
-----------

This example uses the ``/usr/bin/curl`` command to fetch a Web page and return
the results. The ``curl`` type or ``include_url`` method can be used for the
same purpose. Only the first part of the output is shown::

   <?lasso
      local(os) = os_process('/usr/bin/curl', (: 'http://www.apple.com/'))
      #os->read->encodeHTML
      #os->close
   ?>

   // =>
   // <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
   //    <html>
   //    <head>
   //    <title>Apple</title>
   //    ...


Windows Examples
================

This section includes several examples of using ``os_process`` on Windows. Each
of the examples uses the command-line processor ``CMD`` with the option ``/C``
to interpret an individual command.

Echo
----

This example uses the ``CMD`` processor with an ``ECHO`` command to simply echo
the input back to Lasso::

   <?lasso
      local(os) = os_process('cmd', array('/C ECHO Hello World!'))
      #os->readString->encodeHTML
      #os->close
   ?>
   // =>
   // Hello World!


List
----

This example uses the ``CMD`` processor with a ``DIR`` command to list the
contents of a directory. The ``/B`` option instructs Windows to only list the
contents of the directory without extraneous header and footer information::

   <?lasso
      local(os) = os_process('cmd', (: '/C DIR /B .'))
      #os->readString->encodeHTML
      #os->close
   ?>
   // =>
   // JDBCDrivers
   // JavaLibraries
   // LassoAdmin
   // LassoApps
   // LassoErrors.txt
   // LassoLibraries
   // LassoModules
   // LassoStartup
   // SQLiteDBs


Help
----

This example uses the ``CMD`` processor with a ``HELP`` command to show the help
information for a command. The start of the help file for ``CMD`` itself is
shown. Running ``HELP`` without a parameter will return a list of all the
built-in commands which the command processor supports::

   <?lasso
      local(os) = os_process('cmd', (: '/C HELP cmd'))
      #os->readString->encodeHTML
      #os->close
   ?>

   // =>
   // Starts a new instance of the Windows XP command interpreter
   // CMD [/A | /U] [/Q] [/D] [/E:ON | /E:OFF] [/F:ON | /F:OFF] [/V:ON | /V:OFF] [[/S] [/C | /K] string]
   // /C Carries out the command specified by string and then terminates
   // /K Carries out the command specified by string but remains
   // /Q Turns echo off
   // /A Causes the output of internal commands to a pipe or file to be ANSI
   // /U Causes the output of internal commands to a pipe or file to be Unicode


Multiple Commands
-----------------

This example uses the ``CMD`` processor interactively to run several commands.
The processor is started with a parameter of ``/Q`` which suppresses the echoing
of commands back to the output. The result is exactly the same as what would be
provided if these commands were entered directly into the command line shell. In
order to process the results it would be necessary to strip off the header and
the directory prefix from each line::

   <?lasso
      local(os) = os_process('cmd', (: '/Q')
      #os->write('ECHO Line One\r\n')
      #os->write('ECHO Line Two\r\n')
      #os->read->encodeHTML
      #os->close
   ?>

   // =>
   // Microsoft Windows XP [Version 5.1.2600]
   // (C) Copyright 1985-2001 Microsoft Corp.
   // C:\Program Files\LassoSoft\Lasso Instance Manager\home>Line One
   // C:\Program Files\LassoSoft\Lasso Instance Manager\home>Line Two


Batch File
----------

This example uses the ``CMD`` processor to process a batch file. The contents of
batch file batch.bat is shown below. The file is assumed to be located in the
folder for the current site in the Lasso 9 Server application folder::

   @ECHO OFF
   CLS
   ECHO This file demonstrates how to use a batch file.

The batch file is executed by simply calling its name as a command. The results
of the batch file are then outputted. Using a batch file makes executing a
sequence of commands easy since all the code can be perfected using local
testing before it is run through Lasso::

   <?lasso
      local(os) = os_process('cmd', (: '/C batch.bat'))
      #os->readString->encodeHTML
      #os->close
   ?>

   // =>
   // This file demonstrates how to use a batch file.