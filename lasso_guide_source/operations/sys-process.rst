.. _sys-process:

*******************************
Shell Commands with sys_process
*******************************

Lasso provides the ability to execute local processes or shell commands through
the :type:`sys_process` type. This type allows local processes to be launched
with an array of parameters and shell variables. Some processes will execute and
return a result immediately. Other processes can be left open for interactive
read/write operations. The :type:`sys_process` type enables Lasso users to do
tasks such as execute AppleScripts, print PDF files, and filter data through
external applications.

The :type:`sys_process` type works across all three platforms that Lasso
supports. The UNIX underpinnings of OS X and Linux mean that those two operating
systems can run many of the same commands and shell scripts. Windows presents a
very different environment including DOS commands and batch files.

For more information on writing shell scripts with Lasso, see the
:ref:`command-line-tools` chapter.


Using sys_process
=================

.. type:: sys_process
.. method:: sys_process()
.. method:: sys_process(cmd::string, args= ?, env= ?, user::string= ?)

   The :type:`sys_process` type allows a developer to create a new process on
   the machine and both read from and write data to it. The process is usually
   closed after the :type:`sys_process` object is destroyed, but can optionally
   be left running. The :type:`sys_process` type shares many of the same member
   methods and conventions as the :type:`file` type.

   There are two constructor methods for creating :type:`sys_process` objects:
   the first allows for an empty object with no information being passed to it.
   The second takes the same parameters as the `sys_process->open` method and
   calls that method, thereby immediately running the command passed to it.

.. member:: sys_process->open(command::string, \
         arguments::staticarray= ?, \
         environment::staticarray= ?, \
         user::string= ?)

   Opens a new process. The command string should consist of the full path to
   the executable unless it is just a built-in command that does not have a
   path; in that case just pass the name of the command. An optional staticarray
   of arguments can be passed as the second parameter. Any arguments are
   converted to strings and passed to the new process. An optional staticarray
   of environment strings may be specified as the third parameter, and these too
   will be passed to the new process. By default, the new process is run as the
   current user. The fourth parameter allows for optionally specifying a user to
   run the new process under. This option only works if the current user is the
   superuser.

.. member:: sys_process->wait()::integer

   Calling this member method causes execution of your code to pause until the
   new process you have opened with `sys_process` finishes its execution. It
   returns the exit code of the command you ran. If you have not yet opened up
   a new process, it will return "-1".

.. member:: sys_process->read(count::integer= ?, -timeout= ?)::bytes

   Reads the specified number of bytes from the process's standard out (STDOUT).
   Returns a bytes object. The number of bytes of data actually returned from
   this method may be less than the specified number depending on the number of
   bytes that are actually available to read. Calling this method without a byte
   count will read 1024 bytes. A timeout value may also be specified which is
   the number of milliseconds to wait for the number of bytes being requested.
   The default value for this is "0" which means that it will just read what is
   currently available.

.. member:: sys_process->readError(count::integer= ?, -timeout= ?)::bytes

   Reads the specified number of bytes from the process's standard error
   (STDERR) output. Returns a bytes object. Calling this method without a byte
   count will read 1024 bytes. A timeout value may also be specified which is
   the number of milliseconds to wait for the number of bytes being requested.
   The default value for this is "0" which means that it will just read what is
   currently available.

.. member:: sys_process->readString(count::integer= ?, -timeout= ?)::string

   This method is identical to `sys_process->read` but returns a string object
   instead of a bytes object.

.. member:: sys_process->write(data::bytes)
.. member:: sys_process->write(data::string)

   Writes the specified data to the new process's standard in (STDIN). If the
   data is a string, the current encoding is used to convert the data before
   being sent. If the data is a bytes object, the data is sent unaltered.

.. member:: sys_process->setEncoding(encoding::string)

   Sets the encoding for the instance. The encoding controls how string data is
   written via `sys_process->write` and how string data is returned via
   `sys_process->readString`. By default, UTF-8 is used.

.. member:: sys_process->isOpen()::boolean

   Returns "true" as long as the process is running. After the process is
   terminated, it will return "false".

.. member:: sys_process->detach()

   Detaches the :type:`sys_process` object from the process. This will prevent
   the process from terminating when the :type:`sys_process` object is
   destroyed.

.. member:: sys_process->close()

   Closes the connection to the process. This will cause the process to
   terminate unless it has previously been detached from the :type:`sys_process`
   object by calling `sys_process->detach`.

.. member:: sys_process->closeWrite()

   Closes the "write" portion of the connection to the process. This results in
   the process's standard in (STDIN) being closed.

.. member:: sys_process->exitCode()

   This method is synonymous with `sys_process->wait` except that it does not
   return a value if no process has been opened.

.. member:: sys_process->testExitCode()

   Returns the exit code of the process if it has terminated, otherwise it
   returns "void".

.. important::
   If you wish to run a command that you expect to run briefly and you want to
   inspect its output after it has run, then don't forget to call either
   `sys_process->wait` or `sys_process->exitCode` before calling any of the
   ``sys_process->read…`` methods. If you don't wait, your code will more than
   likely call the read method before the new process fully starts up, and you
   may miss anything written to STDOUT or STDERR. If the process may take a long
   time, or output a lot of data, you may want to use either
   `sys_process->isOpen` or `sys_process->testExitCode` as test conditions in a
   while loop that does the reading. (See examples below.)


OS X and Linux Examples
=======================

This section includes several examples of using `sys_process` on OS X. Except
for the AppleScript example, all of these examples should also work on Linux
installations.


Echo
----

This example uses the :command:`/bin/echo` command to simply echo the input back
to STDOUT, which is then read by Lasso::

   local(proc) = sys_process('/bin/echo', array('Hello World!'))
   local(_) = #proc->wait
   #proc->read->encodeHTML
   #proc->close

   // => Hello World!


List
----

This example uses the :command:`/bin/ls` command to list the contents of a
directory::

   local(proc) = sys_process('/bin/ls', (: '/' + sys_homePath))
   fail_if(#proc->exitCode != 0, 'Unknown error')
   #proc->readString->encodeHTML(true, false)
   #proc->close

   // =>
   // LassoApps
   // LassoModules
   // LassoStartup
   // SQLiteDBs
   // lasso.err.txt
   // lasso.fastcgi.sock
   // lasso.out.txt


Create File
-----------

This example uses the :command:`/usr/bin/tee` command to create a file
"test.txt" in the site folder. The code does not generate any output, it just
creates the file. ::

   local(proc) = sys_process
   handle => {
      #proc->close
   }
   #proc->open('/usr/bin/tee', (: './test.txt'))
   #proc->write('This is a test\n')
   #proc->write('This is a test\n')
   #proc->close


Print
-----

This example uses the :command:`/usr/bin/lpr` command to print some text on the
default printer. The result in this case is a page that contains the phrase
"This is a test" at the top. This style of printing can be used to output text
data using the default font for the printer. The :command:`lpr` command can also
be used with some common file formats such as PDF files. ::

   local(proc) = sys_process('/usr/bin/lpr')
   #proc->write('This is a test')
   #proc->write(bytes->import8Bits(4)&)
   #proc->closeWrite
   #proc->close


AppleScript
-----------

This example uses the :command:`/usr/bin/osascript` command to run a simple
AppleScript. AppleScript is a full scripting language that provides access to
the system and running applications in OS X. The script shown returns the
current date and time::

   local(proc) = sys_process('/usr/bin/osascript', (: '-'))
   #proc->write('return current date')
   local(_) = #proc->closeWrite&wait
   #proc->readString->encodeHTML
   #proc->close

   // => Tuesday, March 21, 2006 11:52:34 AM


Web Request
-----------

This example uses the :command:`/usr/bin/curl` command to fetch a web page and
return the results. The :type:`curl` type or `include_url` method can be used
for the same purpose. You'll notice that we don't just wait and then do a read;
this is to show how to deal with not knowing how large of a response there will
be from STDOUT. Only the first part of the output is shown. ::

   local(proc) = sys_process('/usr/bin/curl', (: 'http://www.apple.com/'))
   local(data)
   while(#proc->isOpen or #data := #proc->readString) => {^
      #data->asString->encodeHTML
   ^}
   #proc->close

   // =>
   // <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
   //    <html>
   //    <head>
   //    <title>Apple</title>
   // ... rest of response ...


Windows Examples
================

This section includes several examples of using `sys_process` on Windows. Each
of the examples uses the command-line processor :program:`CMD` with the option
"/C" to interpret an individual command.


Echo
----

This example uses the :program:`CMD` processor with an :command:`ECHO` command
to simply echo the input back to Lasso::

   local(proc) = sys_process('cmd', array('/C ECHO Hello World!'))
   local(_) = #proc->wait
   #proc->readString->encodeHTML
   #proc->close

   // => Hello World!


List
----

This example uses the :program:`CMD` processor with a :command:`DIR` command to
list the contents of a directory. The "/B" option instructs Windows to only list
the contents of the directory without extraneous header and footer information.
::

   local(proc) = sys_process('cmd', (: '/C DIR /B .'))
   local(_) = #proc->wait
   #proc->readString->encodeHTML
   #proc->close

   // =>
   // JavaLibraries
   // JDBCDrivers
   // LassoApps
   // LassoModules
   // LassoStartup
   // SQLiteDBs
   // JDBCLog.txt
   // lasso.err.txt
   // lasso.out.txt


Help
----

This example uses the :program:`CMD` processor with a :command:`HELP` command to
show the help information for a command. The start of the help file for
:program:`CMD` itself is shown. Running :command:`HELP` without a parameter will
return a list of all the built-in commands supported by the command processor.
::

   local(proc) = sys_process('cmd', (: '/C HELP cmd'))
   local(_) = #proc->wait
   #proc->readString->encodeHTML
   #proc->close

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

This example uses the :program:`CMD` processor interactively to run several
commands. The processor is started with a parameter of "/Q" which suppresses the
echoing of commands back to the output. The result is exactly the same as what
would be provided if these commands were entered directly into the command line
shell. In order to process the results, it would be necessary to strip off the
header and the directory prefix from each line. ::

   local(proc) = sys_process('cmd', (: '/Q')
   #proc->write('ECHO Line One\r\n')
   #proc->write('ECHO Line Two\r\n')
   local(_) = #proc->wait
   #proc->read->encodeHTML
   #proc->close

   // =>
   // Microsoft Windows XP [Version 5.1.2600]
   // (C) Copyright 1985-2001 Microsoft Corp.
   // C:\Program Files\LassoSoft\Lasso Instance Manager\home>Line One
   // C:\Program Files\LassoSoft\Lasso Instance Manager\home>Line Two


Batch File
----------

This example uses the :program:`CMD` processor to process a batch file. The
contents of batch file "batch.bat" is shown below. The file is assumed to be
located in the folder for the current site in the Lasso Server application
folder.

.. code-block:: bat

   @ECHO OFF
   CLS
   ECHO This file demonstrates how to use a batch file.

The batch file is executed by calling its name as a command. The results of the
batch file are then output. Using a batch file makes executing a sequence of
commands easy since all the code can be perfected using local testing before it
is run through Lasso. ::

   local(proc) = sys_process('cmd', (: '/C batch.bat'))
   local(_) = #proc->wait
   #proc->readString->encodeHTML
   #proc->close

   // => This file demonstrates how to use a batch file.
