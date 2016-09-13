.. _logging:

*******
Logging
*******

Lasso Server has a built-in error logging system that allows warning messages to
be logged at several different levels. Each log level can be routed to one or
more destinations, allowing for a great deal of flexibility in handling.

The built-in log levels include:

Critical
   Critical errors that affect the operation of Lasso Server. Critical errors
   are logged to all destinations by default. Typically, the server or site
   administrator will need to fix whatever is causing the critical error.

Warning
   Warnings are informative messages about possible problems with the
   functioning of Lasso Server. Warnings do not always require action by the
   server or site administrator. Warnings are logged only to the console by
   default.

Detail
   Detailed messages about the normal functioning of Lasso Server. Includes
   status messages from the email queue and event scheduler, etc. Detail
   messages are logged only to the console by default.

Deprecated
   Flags any use of deprecated functionality in Lasso code. Deprecated methods
   are supported in this version of Lasso, but may not be supported in a future
   version. Any deprecated functionality should be updated to new, preferred
   syntax for best compatibility with future versions of Lasso. Deprecated
   messages are logged only to the console by default.

The destinations that the log levels can be routed to include:

Console
   The Lasso Server instance's console, which is viewable from the Instance
   Manager. It is stored in a file named :file:`lasso.out.txt` in the instance's
   :envvar:`LASSO9_HOME` directory and has a max file size of 10 MB by default.

File
   The :file:`lasso_logbook.txt` file, located in the instance's
   :envvar:`LASSO9_HOME` directory. This file is also capped at 10 MB by default.

Database
   The "logbook" table in the "lasso_logbook" SQLite database, viewable via the
   "Log Book" section of Lasso Server Admin
   (:ref:`!http://example.com/lasso9/admin/logbook`).

The routing of Lasso's internal log levels can be modified using the "Log Book"
section of the Lasso Server Admin interface
(:ref:`!http://example.com/lasso9/admin/logbook`). For details on how to change
the log level routing programmatically, see the section :ref:`logging-routing`
later in this chapter.


Logging Methods
===============

The `log_critical`, `log_warning`, `log_detail`, and `log_deprecated` methods
are used to log custom data to the Lasso internal error logs with a defined
Lasso error level of "Critical", "Warning", "Detail", or "Deprecated",
respectively.

.. method:: log_critical(...)

   Logs to Lasso's internal error logs with an error level assignment of
   "Critical". Requires the text to be logged as a parameter. Logging options
   for this error level are set in Lasso Server Admin.

.. method:: log_warning(...)

   Logs to Lasso's internal error logs with an error level assignment of
   "Warning". Requires the text to be logged as a parameter. Logging options for
   this error level are set in Lasso Server Admin.

.. method:: log_detail(...)

   Logs to Lasso's internal error logs with an error level assignment of
   "Detail". Requires the text to be logged as a parameter. Logging options for
   this error level are set in Lasso Server Admin.

.. method:: log_deprecated(...)

   Logs to Lasso's internal error logs with an error level assignment of
   "Deprecated". Requires the text to be logged as a parameter. Logging options
   for this error level are set in Lasso Server Admin.

.. method:: log_always(...)

   Logs to Lasso's console. This error level cannot be routed, and is always
   sent to Lasso's console.


Create a Log Message
--------------------

The following example will create a log statement at the level of "Warning" if
Lasso throws a "Divide By Zero" error. The displayed result is the log message
that gets sent to the console; note that it contains a timestamp in brackets::

   handle(error_code == error_code_divideByZero) => {
      log_warning('A mathematical error occurred while processing this page')
   }

   // => [2013-03-23 16:59:41] A mathematical error occurred while processing this page


Logging to Files
================

In addition to using the built-in log level routing system, it is sometimes
desirable to create a separate log file specific to a custom solution. The `log`
method can be used to write text messages out to a log file.

.. method:: log(path)

   When executed, the results of the auto-collection from the `log` method's
   capture block is appended to a specified text file. The `log` method can
   write to any text file that is accessible from Lasso. The capture block must
   be an auto-collect block as the collected data from the capture block will be
   included in the appended data. If you don't use an auto-collect block then no
   data will be appended to the log file.

   The following example outputs a single line containing the date and time with
   a return at the end to the file specified. The methods are shown first with a
   Windows path, then with an OS X or Linux path. ::

      log('C://Logs/LassoLog.txt') => {^
         date->format('%Q %T')
         '\r\n'
      ^}

      log('//Logs/LassoLog.txt') => {^
         date->format('%Q %T')
         '\n'
      ^}

   The path to the directory where the log will be stored should be specified
   according to the same rules as those for the :type:`file` methods. See the
   section :ref:`files-paths` in the :ref:`files` chapter for full details about
   relative, absolute, and fully qualified paths on OS X, Linux, and Windows.


Log Site Visits to a File
-------------------------

The following code will log the current date and time, the visitor's IP address,
the name of the server, the page they were loading, and the GET and POST
parameters that were specified::

   log('//tmp/foo.bar') => {^
      date->format('%Q %T') +
      ' ' + web_request->remoteAddr +
      ' ' + (web_request->isHttps ? 'https://' | 'http://') +
      web_request->httpHost +
      web_request->requestUri +
      ' ' + web_request->postParams + '\n'
   ^}


Automatically Roll Log Files by Date
------------------------------------

Include a date component in the name of the log file. Since the date component
will change every day, a new log file will be created daily the first time an
item is logged. The following example logs to a file named with the current
date, e.g. "2013-05-31.txt"::

   local(cur_date) = date->format('%Q')
   log('//Logs/' + #cur_date + '.txt') => {^
      date->format('%Q %T')
   ^}


.. _logging-routing:

Log Routing
===========

Log preferences can be viewed or changed in the "Log Book" section of Lasso
Server Admin. Use of the `log_setDestination` method is only necessary to
change the log settings programmatically.

.. method:: log_setDestination(level::integer, \
      dest1::integer= ?, \
      dest2::integer= ?, \
      dest3::integer= ?)

   The first parameter specifies a log message level. Subsequent parameters
   specify the destination to which that level of messages should be logged.
   Both the log level and any destinations are specified with integer values. It
   is preferred that you use the convenience methods described below as
   parameters rather than using literal integer values.

.. method:: log_level_critical()

   Returns the integer value for specifying the "Critical" message level in the
   `log_setDestination` method. Using this method will help future-proof your
   code.

.. method:: log_level_warning()

   Returns the integer value for specifying the "Warning" message level in the
   `log_setDestination` method. Using this method will help future-proof your
   code.

.. method:: log_level_detail()

   Returns the integer value for specifying the "Detail" message level in the
   `log_setDestination` method. Using this method will help future-proof your
   code.

.. method:: log_level_deprecated()

   Returns the integer value for specifying the "Deprecated" message level in
   the `log_setDestination` method. Using this method will help future-proof
   your code.

.. method:: log_destination_console()

   Returns the integer value for specifying the "Console" destination in the
   `log_setDestination` method. Using this method will help future-proof your
   code.

.. method:: log_destination_file()

   Returns the integer value for specifying the "File" destination in the
   `log_setDestination` method. Using this method will help future-proof your
   code.

.. method:: log_destination_database()

   Returns the integer value for specifying the "Database" destination in the
   `log_setDestination` method. Using this method will help future-proof your
   code.


Change Logging Preferences
--------------------------

Use the `log_setDestination` method to change the destination of a given log
message level. In the following example, detail messages are sent to the console
and the errors table of the instance's database::

   log_setDestination(
      log_level_detail,
      log_destination_database,
      log_destination_console
   )


Reset Logging Preferences
-------------------------

The following four commands reset the log preferences to their default values.
Critical errors are sent to all three destinations; warnings, detail, and
deprecation messages are sent only to the console. ::

   log_setDestination(
      log_level_critical,
      log_destination_console,
      log_destination_database,
      log_destination_file
   )
   log_setDestination(log_level_warning,    log_destination_console)
   log_setDestination(log_level_detail,     log_destination_console)
   log_setDestination(log_level_deprecated, log_destination_console)
