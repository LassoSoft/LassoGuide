.. _lcapi-overview:

********
Overview
********

The Lasso C/C++ Application Programming Interface (LCAPI) lets you write C or
C++ code to add new Lasso methods, data types, or data source connectors to
Lasso. Writing tags in LCAPI offers speed and system performance advantages over
LJAPI and custom Lasso tags. However, modules must be compiled separately for
Windows, OS X, and Linux.

This chapter provides a walk-through for building and debugging an example
LCAPI method. You can download the source code for this and other examples
`here <http://lassoguide.com/_static/lcapi_examples.zip>`_.


.. _lcapi-overview-requirements:

Requirements
============

In order to compile LCAPI methods, data types, or data connectors you need the
following:

Windows
   - Lasso 9 installed on a supported Windows OS

   - Microsoft Visual C++ .NET

OS X
   - Lasso 9 installed on a supported OS

   - The developer tools installed 

   - You need the 10.5 SDK which does not come in the newest development tools.
     For unspported help on getting older SDKs installed, `see this link
     <http://hints.macworld.com/article.php?story=20110318050811544>`_

Linux
   - Lasso 9 installed on a supported OS

   - The gcc C/C++ development libraries and executables


.. _lcapi-overview-quickstart:

Quick Start
===========

This section provides a walk-through for building sample LCAPI method modules.

Build a sample LCAPI module in Windows
   #. Download and expand the example code.

   #. In the MathFuncsTags folder, double-click the MathFuncsCAPI.sln project
      file (you need Microsoft Visual C++ .NET in order to open it).

   #. Choose Build > Build Solution to compile and make the MathFuncsCAPI.DLL.

   #. After building, a Debug folder will have been created inside your
      MathFuncsCAPI project folder.

   #. Open the MathFuncsTags/Debug folder and drag MathFuncsCAPI.DLL into the
      LassoModules folder in a Lasso instance home folder on the hard drive.

   #. Restart the Lasso instance.

   #. New methods ``example_math_abs``, ``example_math_sin``, and
      ``example_math_sqrt`` are now part of the Lasso language.

   #. Drag the sample Lasso page called MathFuncsCAPI.lasso into your web server
      root.

   #. View the MathFuncsCAPI.lasso page in a web browser to see the new Lasso
      methods in action.


Build a sample LCAPI module in OS X / Linux
   #. Download and expand the example code.

   #. Open a terminal window and change the working directory to the
      MathFuncsTags folder in the example code.

   #. Build the sample project using the provided makefile by running ``make``.

   #. After building, a file named "MathFuncsCAPI.dylib" in OS X and
      "MathFuncsCAPI.so" in Linux will be in the current folder. Move that file
      to the LassoModules folder in a Lasso instnace home folder.

   #. Restart the Lasso instance.

   #. New methods ``example_math_abs``, ``example_math_sin``, and
      ``example_math_sqrt`` are now part of the Lasso language.

   #. Drag the sample Lasso page called MathFuncsCAPI.lasso into your web server
      root.

   #. View the MathFuncsCAPI.lasso page in a web browser to see the new Lasso
      methods in action.


.. _lcapi-overview-debugging:

Debugging
=========

You can set breakpoints in your LCAPI compiled libraries and perform source-
level debugging for your own code. In order to set this up, follow the example
below. For this section, we will use the MathFuncsCAPI example.

Debug in Windows
   #. Select "Processes..." from the "Debug" main menu.
   
   #. In the "Processes" window, select each instance of lassoserver.exe and
      choose to "Attach".
   
   #. Close the "Processes" window and set a breakpoint in the
      ``tagMathAbsFunc`` function.
   
   #. Use a web browser to access the sample MathFuncsCAPI.lasso file on your
      web server. Visual Studio will stop at the location that the breakpoint
      was placed.


Debug in OS X / Linux
   #. The provided make file compiles with the DEBUG options be default, so
      there is no need to recompile.

   #. Find out the process ID number of lassoserver so you can attach to it
      later with GNU Debugger:

      .. code-block:: bash

         ps -ax | grep lassoserver

   #. Start the GNU Debugger as a root user:

      .. code-block:: bash

         sudo gdb

   #. From within GNU Debugger's command line, attach to the lassoserver
      process ID by entering the following (replacing <PROCESS ID> with the
      actual process ID):

      .. code-block:: none

         attach <PROCESS ID>

   #. Instruct GNU Debugger to break whenever the function tagMathAbsFunc is
      called by entering the following:

      .. code-block:: none

         break tagMathAbsFunc

   #. Use a web browser to access the sample MathFuncsCAPI.lasso file on your
      web server. GNU Debugger will break at the first line in
      ``tagMathAbsFunc`` when the ``example_math_abs`` method is called.

.. note::
   Type "help" in GNU Debugger for more information about using the GNU
   Debugger, or search for gdb tutorials on the Web for more in-depth
   information.

.. note::
   For newer versions of OS X, use ``lldb`` instead of ``gdb``.


Frequently Asked Questions
==========================

How do I install my custom module?
   Once you've compiled your module, you'll need to move it to the LassoModules
   folder for the instance you want it to run in or the LassoModules folder in
   the master Lasso home folder. You will need to restart any running instances
   for them to pick up the new tags.

How do I return text from my custom module?
   Use either ``lasso_returnTagValueString`` to return UTF-8 data, or
   ``lasso_returnTagValueStringW`` to return UTF-16 data. Character data in
   other encoding methods can be returned by first allocating a string type
   using ``lasso_typeAllocStringConv`` and then returning it using
   ``lasso_returnTagValue``.

How do I return binary data from my custom method?
   Use ``lasso_returnTagValueBytes`` to return binary data.

How do I prevent Lasso from automatically encoding text returned from my custom method?
   Make sure that your method is registered with the ``flag_noDefaultEncoding``
   flag. This flag is specified when you call ``lasso_registerTagModule`` at
   startup.

How do I debug my custom tag?
   You can set breakpoints in your code and attach your debugger to lassoserver.
   Read the section on :ref:`Debugging LCAPI modules<lcapi-overview-debugging>`.

How do I get parameters that were passed into my tag?
   Most of the parameters passed into your custom tag can be retrieved using the
   ``lasso_getTagParam()`` and ``lasso_findTagParam()`` parameter info APIs.
   ``lasso_getTagParam()`` retrieves parameters by index and
   ``lasso_findTagParam()`` retrieves them by name. All parameters retrieved
   using those functions will be returned as strings. To access the parameters
   as Lasso type instances, use ``lasso_getTagParam2`` and
   ``lasso_findTagParam2``.

How do I get the value of unnamed parameters passed into my tag?
   While there is no direct way to get unnamed parameters (how do you know what
   name to ask for?), you can enumerate through all the parameters by index, and
   then pick out the ones which do not have names. If, after retrieving a
   parameter, you discover that its data member is an empty string, then that
   means it is an unnamed parameter, and you can get its value from the name
   member. An example of this is in the method tutorial.

What's an ``auto_lasso_value_t`` and how do I use it?
   It's a data structure which contains both a name and a value (a name/value
   pair). Many LCAPI APIs fill in this structure for you, and you can access the
   name and data members directly as null-terminated C-strings.

What is a lasso_type_t and how do I use it?
   A ``lasso_type_t`` represents an instance of a Lasso type. Any Lasso type can
   be represented by a ``lasso_type_t``, including strings, integers, or custom
   types. LassoCAPI provides many functions for allocating or manipulating
   ``lasso_type_t`` instances. All ``lasso_type_t`` instances encountered inside
   a LassoCAPI tag will be automatically garbage collected after the function
   returns. Therefore, a ``lasso_type_t`` instance should not be saved unless it
   is freed from the garbage collector using ``lasso_typeDetach``.

How do I access variables from the Lasso page I'm in?
   You may need to get or even create Lasso variables (the same variables that a
   Lasso programmer makes when using the ``var(fred) = 12`` variable syntax in a
   Lasso page) from within your LCAPI module. You can retrieve a global
   variable, as long as it has already been assigned before your custom method
   is executed, by calling ``lasso_getVariable()`` with the variable's name.
   Using this method, one could directly set the ``__html_reply__`` variable.

How do I return fatal and non-fatal error codes?
   It is very important that your method return an error code of
   ``osErrNoErr(0)`` if nothing fatal happened. An example of a fatal error
   would be a missing required parameter, for instance. If you encounter a fatal
   error, then return a non-zero result code from your method function, and then
   Lasso will stop processing the page at that point, and display an error page.

How do I write code that will compile easily across multiple operating systems?
   While we cannot provide a complete cross-platform programming tutorial for
   you here, we can at least provide some guidance. The simplest way to make
   sure things compile across platforms is to make sure you use standard library
   functions (from ``stdio.h`` and ``stdlib.h``) as much as possible: functions
   like ``strcpy()``, ``malloc()``, and ``strcmp()`` are always available on all
   platforms. Also note that \*nix platforms are case-sensitive, so when you
   ``#include`` files, just make sure you keep the case the same as the file on
   disk. Finally, stay away from platform-specific functions, such as Windows
   APIs, which most often are not available on \*nix platforms. Take a look at
   our \*nix makefiles which are provided with the sample projects: notice the
   same source code is used for Windows, and all source files are saved with
   DOS-style cr/lf linebreaks so as not to confuse the Windows compilers. As a
   last resort, you can use ``#ifdef`` to show/hide portions of source code
   which are platform-specific.