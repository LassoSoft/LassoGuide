.. _date-duration:

*****************
Date and Duration
*****************

This chapter introduces the :type:`date` and :type:`duration` types in Lasso.
:dfn:`Dates` are objects that represent a calendar date and/or clock time.
:dfn:`Durations` are objects that represents a length of time in hours, minutes,
and seconds. Date and duration objects can be manipulated using operators, and
methods can be used to determine date differences, time differences, and more.
Date objects may also be formatted and converted to a number of predefined or
custom formats, and specific information may be extrapolated from a date object
(day of week, name of month, etc.).


Date Objects
============

Since dates and durations can take many forms, values that represent a date or a
duration must be explicitly converted to a date or duration object using the
`date` and `duration` creator methods. For example, a value of "01/01/2002
12:30:00" will be treated as a string until converted to a date object using the
`date` method::

   date('01/01/2002 12:30:00')

Once a value is converted to a date or duration object, special member methods,
accessors, conversion operations, and math operations may then be used.

When performing date operations, Lasso uses its internal date libraries to
automatically adjust for leap years and daylight saving time for the local time
zone in all applicable regions of the world (as not all regions recognize
daylight saving time). The current time and time zone are based on that of the
computer or web server Lasso is running on.

.. note::
   Lasso extracts daylight saving time information from the operating system.
   For information on special exceptions with date calculations during daylight
   saving time, see the section :ref:`date-duration-math`.


Date Type
=========

For Lasso to recognize a string as a date, the string must be explicitly
converted to a :type:`date` type using the `date` creator method::

   date('5/22/2002 12:30:00')

When converting to a :type:`date` type using the `date` creator method, the date
formats shown below are automatically recognized as valid date strings by Lasso.
These automatically recognized date formats are U.S. or MySQL dates with a
four-digit year followed by an optional 24-hour time with seconds. The slash
(``/``), hyphen (``-``), and colon (``:``) characters are the only punctuation
marks recognized in valid date strings by Lasso when used in the formats shown
below.

.. code-block:: none

   1/25/2002
   1/25/2002 12:34
   1/25/2002 12:34:56
   1/25/2002 12:34:56 GMT
   2002-01-25
   2002-01-25 12:34:56
   2002-01-25 12:34:56 GMT

Lasso also recognizes a number of special-purpose date formats which are shown
below. These are useful when working with HTTP headers or email message headers.

.. code-block:: none

   20020125123456
   20020125T12:34:56
   Tue, Dec 17 2002 12:34:56 -0800
   Tue Dec 17 12:34:56 PST 2002

The date formats containing time zone information (e.g. "-0800" or "PST") will
be recognized as GMT dates. The time zone will be used to automatically adjust
the date/time to the equivalent GMT date/time.

If using a date format not listed above, custom date formats can be defined
using the ``-format`` parameter of the `date` creator method.

The following variations of the automatically recognized date formats are valid
without using the ``-format`` parameter:

-  If the `date` creator method is used without a parameter then the current
   date and time is returned. Milliseconds are rounded to the nearest second.

-  If the time is not specified then it is set to be the current hour when the
   object is created. For example, "22:00:00" if the object was created at
   10:48:59 PM:

   .. code-block:: none

      mm/dd/yyyy -> mm/dd/yyyy 22:00:00

-  If the seconds are not specified then the time is assumed to be even on the
   minute:

   .. code-block:: none

      mm/dd/yyyy hh:mm -> mm/dd/yyyy hh:mm:00

-  An optional GMT designator can be used to specify Greenwich Mean Time rather
   than local time:

   .. code-block:: none

      mm/dd/yyyy hh:mm:ss GMT

-  Two-digit years are assumed to be in the 1\ :sup:`st` century. For best
   results, always use four-digit years:

   .. code-block:: none

      mm/dd/00 -> mm/dd/0001
      mm/dd/39 -> mm/dd/0039
      mm/dd/40 -> mm/dd/0040
      mm/dd/99 -> mm/dd/0099

-  Days and months can be specified with or without leading "0"s. The following
   are all valid Lasso date strings:

   .. code-block:: none

      1/1/2002
      01/1/2002
      1/01/2002
      01/01/2002
      01/01/2002 16:35
      01/01/2002 16:35:45
      GMT 01/01/2002 12:35:45 GMT


Converting Values to Dates
--------------------------

If the value is in a recognized string format described previously, simply use
the `date` creator method::

   date('05/22/2002')
   // => 05/22/2002

   date('05/22/2002 12:30:00')
   // => 05/22/2002 12:30:00

   date('2002-05-22')
   // => 2002-05-22

If the value is not in a string format described previously, use the `date`
creator method with the ``-format`` parameter. For information on how to use the
``-format`` parameter, see the section :ref:`date-duration-formatting-dates`. ::

   date('5.22.02 12:30', -format='%m.%d.%y %H:%M')
   // => 5.22.02 12:30

   date('20020522123000', -format='%Y%m%d%H%M')
   // => 200205221230

Date values stored in database fields or variables can be converted to a date
object using the `date` creator method. Either the format of the date stored in
the field or variable should be in one of the formats described above or the
``-format`` parameter must be used to explicitly specify the format. ::

   date(#myDate)
   date(field('modified_date'))
   date(web_request->param('birth_date'))


Date Methods
------------

.. type:: date
.. method:: date()
.. method:: date(\
      -year= ?, -month= ?, -day= ?, \
      -hour= ?, -minute= ?, -second= ?, \
      -dateGMT= ?, -locale::locale= ?\
   )
.. method:: date(date::string, -format::string= ?, -locale::locale= ?)
.. method:: date(date::integer, -locale::locale= ?)
.. method:: date(date::decimal, -locale::locale= ?)
.. method:: date(date::date, -locale::locale= ?)

   All the various creator methods that can be used to create a date object.
   When called without parameters, it returns a date object with the current
   date and time. A date object can be created from properly formatted strings,
   integers, decimals, and dates. A date object can also be created by passing
   valid values to the keyword parameters ``-second``, ``-minute``, ``-hour``,
   ``-day``, ``-month``, ``-year``, and ``-dateGMT``. Each creator method also
   allows for specifying a :type:`locale` object to use with the ``-locale``
   keyword parameter. (By default this is set to what the `locale_default`
   method returns.)

.. method:: date_format(value, format::string)
.. method:: date_format(value, -format::string)

   Returns the passed-in date parameter in the specified format. Requires a date
   object or any valid objects that can be converted to a date (it automatically
   recognizes the same formats as the `date` creator methods). The format can be
   specified as the second parameter or as the value part of a ``-format``
   keyword parameter and defines the format for the return value. See the
   :ref:`date-duration-formatting-dates` section below for more details on
   format strings.

.. method:: date_setFormat(format::string)

   Sets the date format for date objects to use for output for an entire Lasso
   thread. The required parameter is a format string.

.. method:: date_gmtToLocal(value)

   Converts the date/time of any object that can be converted to a date object
   from Greenwich Mean Time to the local time of the machine running Lasso
   Server.

.. method:: date_localToGMT(value)

   Converts the date/time of any object that can be converted to a date object
   from local time to Greenwich Mean Time.

.. method:: date_getLocalTimeZone()

   Returns the current time zone of the machine running Lasso Server as a
   standard GMT offset string (e.g. "-0700"). Optional ``-long`` parameter shows
   the name of the time zone (e.g. "America/New_York").

.. method:: date_minimum()

   Returns the minimum possible date recognized by a date object in Lasso.

.. method:: date_maximum()

   Returns the maximum possible date recognized by a date object in Lasso.

.. method:: date_msec()

   Returns an integer representing the number of milliseconds recorded on the
   machine's internal clock. Can be used for general timing of code execution.


Display Date Values
^^^^^^^^^^^^^^^^^^^

The current date/time can be displayed with `date`. The example below assumes
a current date and time of "5/22/2002 14:02:05"::

   date
   // => 2002-05-22 14:02:05

The :type:`date` type can be used to assemble a date from individual parameters.
The following method assembles a valid Lasso date by specifying each part of the
date separately. Since the time is not specified it is assumed to be the current
time the date object is created in the example below assumes the current date
and time of "5/7/2013 15:45:04"::

   date(-year=2002, -month=5, -day=22)
   // => 2002-05-22 15:45:04


Convert Date Values To and From GMT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any date object can be converted to and from Greenwich Mean Time using the
`date_gmtToLocal` and `date_localToGMT` methods. These methods will only convert
to and from the current time zone of the machine running Lasso. The following
example uses Eastern Daylight Time (EDT) as the current time zone::

   date_gmtToLocal(date('5/22/2002 14:02:05 GMT'))
   // => 05/22/2002 10:02:05 EDT

   date_localToGMT(date('5/22/2002 14:02:05 EDT'))
   // => 05/22/2002 18:02:05 GMT+00:00


Display the Current Time Zone of the Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `date_getLocalTimeZone` method displays the current time zone of the machine
running Lasso. The following example uses Eastern Standard Time (EST) as the
current time zone::

   date_getLocalTimeZone
   // => -0500

   date_getLocalTimeZone(-long)
   // => America/New_York


Time a Section of Lasso Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Call the `date_msec` method to get a clock value before and after the code has
executed. The difference in times represents the number of milliseconds that
have elapsed. Note that the `date_msec` value may occasionally roll back around
to zero so any negative times reported by this code should be disregarded. ::

   <?lasso
      local(start) = date_msec
      // ... the code to time ...
      'The code took ' + (date_msec - #start) + ' milliseconds to process.'
   ?>

   // => The code took 5 milliseconds to process


.. _date-duration-formatting-dates:

Formatting Dates
----------------

Various methods take a format string for one of their parameters. A :dfn:`format
string` is a compilation of symbols that define the format of the string to be
output or parsed. There are two different sets of formatting strings. Detailed
in the following table are the classic formatting symbols, first introduced in
earlier versions of Lasso:

.. tabularcolumns:: |l|L|

.. _date-duration-classic-symbols:

.. table:: Classic Date Formatting Symbols

   ====== ======================================================================
   Symbol Description
   ====== ======================================================================
   ``%d`` U.S. Date Format (mm/dd/yyyy)
   ``%Q`` MySQL date format (yyyy-mm-dd)
   ``%q`` MySQL timestamp format (yyyymmddhhmmss)
   ``%r`` 12-hour time format (hh:mm:ss [AM/PM])
   ``%T`` 24-hour time format (hh:mm:ss)
   ``%Y`` 4-digit year
   ``%y`` 2-digit year
   ``%m`` month number (01=January, 12=December)
   ``%B`` full English month name (e.g. "January")
   ``%b`` abbreviated English month name (e.g. "Jan")
   ``%d`` day of month (01--31)
   ``%w`` day of week (01=Sunday, 07=Saturday)
   ``%W`` week of year
   ``%A`` full English weekday name (e.g. "Wednesday")
   ``%a`` abbreviated English weekday name (e.g. "Wed")
   ``%H`` 24-hour time hour (0--23)
   ``%h`` 12-hour time hour (1--12)
   ``%M`` minute (0--59)
   ``%S`` second (0--59)
   ``%p`` AM/PM for 12-hour time
   ``%G`` GMT time zone indicator
   ``%z`` time zone offset in relation to GMT (e.g. +0100, -0800)
   ``%Z`` time zone designator (e.g. PST, GMT-1, GMT+12)
   ``%%`` percent character
   ====== ======================================================================

Each of the date format symbols that returns a number automatically pads that
number with "0" so all values returned by the method are the same length.

-  An optional underscore (``_``) between the percent sign (``%``) and the
   letter designating the symbol specifies that a space should be used instead
   of "0" for the padding character (e.g. ``%_m`` returns the month number with
   space padding).
-  An optional hyphen (``-``) between the percent sign (``%``) and the letter
   designating the symbol specifies that no padding should be performed (e.g.
   ``%-m`` returns the month number with no padding).
-  A literal percent sign can be inserted using ``%%``.

.. note::
   If the ``%z`` or ``%Z`` symbols are used when parsing a date, the resulting
   date object will represent the equivalent GMT date/time.

As of version 9, Lasso also recognizes the ICU formatting strings for both
creating and displaying dates. These format strings simply use letters to
specify the format without any flags (such as the ``%`` character). For example,
to output a two-digit year, the ICU format string is ``yy`` and to output it as
a four-digit year, it's ``yyyy``. Because of this, characters that are not
symbols need to be escaped if they are in the format string. To escape
characters in an ICU format string, wrap them in single quotes. Use two
consecutive single quotes for a literal single quote.

See the ICU website for a detailed explanation of `ICU date formatting
symbols`_.

.. Sphinx isn't generating proper LaTeX for multi-row cells

.. tabularcolumns:: |l|l|l|l|

.. _date-duration-icu-symbols:

.. table:: ICU Date Formatting Symbols

   +--------+----------------------------------------------------+---------------+----------------------------------+
   | Symbol | Description                                        | Example       | Result                           |
   +========+====================================================+===============+==================================+
   | G      | era designator                                     | G, GG, or GGG | AD                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | GGGG          | Anno Domini                      |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | GGGGG         | A                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | y      | year                                               | yy            | 96                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | y or yyyy     | 1996                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | Y      | year of "Week of Year"                             | Y             | 1997                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | u      | extended year                                      | u             | 4601                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | U      | cyclic year name (Chinese lunar calendar)          | U             | 甲子                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | Q      | quarter                                            | Q or QQ       | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | QQQ           | Q2                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | QQQQ          | 2nd quarter                      |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | q      | stand alone quarter                                | q or qq       | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | qqq           | Q2                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | qqqq          | 2nd quarter                      |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | M      | month in year                                      | M or MM       | 9                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | MMM           | Sept                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | MMMM          | September                        |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | MMMMM         | S                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | L      | stand alone month in year                          | L or LL       | 9                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | LLL           | Sept                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | LLLL          | September                        |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | LLLLL         | S                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | w      | week of year                                       | w or ww       | 27                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | W      | week of month                                      | W             | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | d      | day of month                                       | d             | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | dd            | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | D      | day of year                                        | D             | 189                              |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | F      | day of week in month                               | F             | 2 (2nd Wed in July)              |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | g      | modified Julian day                                | g             | 2451334                          |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | E      | day of week                                        | E, EE, or EEE | Tues                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | EEEE          | Tuesday                          |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | EEEEE         | T                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | EEEEEE        | Tu                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | e      | local day of week                                  | e or ee       | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | eee           | Tues                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | eeee          | Tuesday                          |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | eeeee         | T                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | eeeeee        | Tu                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | c      | stand alone local day of week                      | c or cc       | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | ccc           | Tues                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | cccc          | Tuesday                          |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | ccccc         | T                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | cccccc        | Tu                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | a      | am/pm marker                                       | a             | pm                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | h      | hour in am/pm (1--12)                              | h             | 7                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | hh            | 7                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | H      | hour of day (0--23)                                | H             | 0                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | HH            | 0                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | k      | hour of day (1--24)                                | k             | 24                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | kk            | 24                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | K      | hour in am/pm (0--11)                              | K             | 0                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | KK            | 0                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | m      | minute of hour                                     | m             | 4                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | mm            | 4                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | s      | second of minute                                   | s             | 5                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | ss            | 5                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | S      | millisecond (maximum of 3 significant digits)      | S             | 2                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | for S or SS, truncates to the number of letters    | SS            | 23                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | SSS           | 235                              |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | for SSSS or longer, fills additional places with 0 | SSSS          | 2350                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | A      | milliseconds in day                                | A             | 61201235                         |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | z      | Time Zone: specific non-location                   | z, zz, or zzz | PDT                              |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        |                                                    | zzzz          | Pacific Daylight Time            |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | Z      | Time Zone: ISO 8601 basic hms? / :rfc:`822`        | Z, ZZ, or ZZZ | -800                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: long localized GMT (=OOOO)              | ZZZZ          | GMT-08:00                        |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | TIme Zone: ISO 8601 extended hms? (=XXXXX)         | ZZZZZ         | -08:00, -07:52:58, Z             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | O      | Time Zone: short localized GMT                     | O             | GMT-8                            |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: long localized GMT (=ZZZZ)              | OOOO          | GMT-08:00                        |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | v      | Time Zone: generic non-location                    | v             | PT                               |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | (falls back first to VVVV)                         | vvvv          | Pacific Time or Los Angeles Time |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | V      | Time Zone: short time zone ID                      | V             | uslax                            |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: long time zone ID                       | VV            | America/Los_Angeles              |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: time zone exemplar city                 | VVV           | Los Angeles                      |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: generic location (falls back to OOOO)   | VVVV          | Los Angeles Time                 |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | X      | Time Zone: ISO 8601 basic hm?, with Z for 0        | X             | -08, +0530, Z                    |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 basic hm, with Z               | XX            | -0800, Z                         |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 extended hm, with Z            | XXX           | -08:00, Z                        |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 basic hms?, with Z             | XXXX          | -0800, -075258, Z                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 extended hms?, with Z          | XXXXX         | -08:00, -07:52:58, Z             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | z      | Time Zone: ISO 8601 basic hm?, without Z for 0     | x             | -08, +0530                       |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 basic hm, without Z            | xx            | -800                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 extended hm, without Z         | xxx           | -08:00                           |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 basic hms?, without Z          | xxxx          | -0800, -075258                   |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   |        | Time Zone: ISO 8601 extended hms?, without Z       | xxxxx         | -08:00, -07:52:58                |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | ``'``  | begin/end text string                              | ``'text'``    | text                             |
   +--------+----------------------------------------------------+---------------+----------------------------------+
   | ``''`` | literal single quote                               | ``''``        | '                                |
   +--------+----------------------------------------------------+---------------+----------------------------------+

.. note::
   Format strings in Lasso can contain both percent-based formatting as well as
   ICU formatting in the same string. Because of this, be sure you properly
   escape any characters you don't want treated as format delimiters in your
   format string. For example, if the current date was "2013-03-09 20:15:30",
   the following code: ``date->format("day: %A")`` would produce "9PM2013:
   Saturday" as the "day" portion of the format string would be treated as part
   of ICU formatting. Wrapping in single quotes mitigates this:
   ``date->format("'day: '%A")``.


Convert Date Strings to Various Formats
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following examples show how to use `date_format` to output either Lasso date
objects or valid Lasso date strings to alternate formats::

   date_format('06/14/2001', -format='%A, %B %d')
   // => Thursday, June 14

   date_format('06/14/2001', '%a, %b %d')
   // => Thu, Jun 14

   date_format('2001-06-14', -format='%Y%m%d%H%M')
   // => 200106141600

   date_format(date('1/4/2002'), '%m.%d.%y')
   // => 01.04.02

   date_format(date('1/4/2002 02:30:00'), -format='%B, %Y')
   // => January, 2002

   date_format(date('1/4/2002 02:30:00'), '%r')
   // => 02:30:00 AM

   date_format(date, -format="y-MM-dd")
   // => 2013-02-24


Import and Export Dates from MySQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A common conversion in Lasso is converting MySQL dates to and from U.S. dates.
Dates are stored in MySQL in the format "yyyy-mm-dd". The following example
shows how to import a date in this format and then output it to U.S. date format
using the `date_format` method::

   date_format('2001-05-22', -format='%-D')
   // => 5/22/2001

   date_format('5/22/2001', -format='%Q')
   // => 2001-05-22

   date_format(date('2001-05-22'), '%D')
   // => 05/22/2001

   date_format(date('5/22/2001'), '%Q')
   // => 2001-05-22


Set a Custom Date Format for a Thread
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `date_setFormat` method. This allows all date objects in a thread to be
output in a custom format without the use of the `date_format` or `date->format`
methods. The format specified is only valid for the currently executing thread
after the `date_setFormat` method has been called::

   date_setFormat('%m%d%y')

The example above means that from now on in the currently executing thread, all
dates converted to strings will use that format. ::

   date('01/01/2002')
   // => 010102


Date Formatting Methods
-----------------------

In addition to `date_format` and `date_setFormat`, Lasso also offers the
`date->format` and `date->setFormat` member methods for performing formatting
adjustments on date objects.

.. member:: date->format()
.. member:: date->format(format::string, -locale::locale= ?)
.. member:: date->format(-format::string, -locale::locale= ?)

   Outputs the date object in the specified format. If no format is passed, the
   current format stored with the object will be used. Otherwise, it requires a
   format string to specify the format. Optionally takes a :type:`locale` object
   to set its locale.

.. member:: date->setFormat(format::string)

   Sets a date output format for a particular date object. Requires a format
   string as a parameter.

.. member:: date->getFormat()

   Returns the current format string set for the current date object. This will
   always return an ICU format string.

.. member:: date->clear()

   Resets the specified fields to their default values. The following fields can
   be specified as keyword parameters: ``-second``, ``-minute``, ``-hour``,
   ``-day``, ``-week``, ``-month``, ``-year``. If no parameters are specified,
   then the entire date is reset to default values.

.. member:: date->set(...)

   Sets one or more elements of the date to a new value. If a field overflows
   then other fields may be modified as well. For example, if you have the date
   "3/31/2008" and you set the month to "2" then the day will be adjusted to
   "29" automatically resulting in "2/29/2008".

   Elements must be specified as :samp:`{keyword}={value}` parameters. See the
   table :ref:`date-duration-field-elements` for the full list of parameters
   that this method can set.

.. member:: date->get(...)

   Returns the current value for the specified field of the current date object.
   Only one field value can be fetched at a time. Note that many of the more
   common fields can also be retrieved through individual member methods.

   See the table :ref:`date-duration-field-elements` for the full list of
   parameters that this method can retrieve.

.. tabularcolumns:: |l|L|

.. _date-duration-field-elements:

.. table:: Date Field Elements for ``get`` and ``set``

   ====================== ======================================================
   Parameter              Description
   ====================== ======================================================
   ``-year``              Specifies the year field for the date.
   ``-month``             Specifies the month field for the date.
   ``-week``              Specifies the week field for the date.
   ``-day``               Specifies the day field for the date.
   ``-hour``              Specifies the hour field for the date.
   ``-minute``            Specifies the minute field for the date.
   ``-second``            Specifies the second field for the date.
   ``-weekofyear``        Specifies the week of year field for the date.
   ``-weekofmonth``       Specifies the week of month field for the date.
   ``-dayofmonth``        Specifies the day of month field for the date.
   ``-dayofyear``         Specifies the day of year field for the date.
   ``-dayofweek``         Specifies the day of week field for the date.
   ``-dayofweekinmonth``  Specifies the day of week in month field for the date.
   ``-ampm``              Specifies the am/pm field for the date.
   ``-hourofday``         Specifies the hour of day field for the date.
   ``-zoneoffset``        Specifies the time zone offset field for the date.
   ``-dstoffset``         Specifies the DST offset field for the date.
   ``-yearwoy``           Specifies the year week of year field for the date.
   ``-dowlocal``          Specifies the local day of week field for the date.
   ``-extendedyear``      Specifies the extended year field for the date.
   ``-julianday``         Specifies the julian day field for the date.
   ``-millisecondsinday`` Specifies the milliseconds in day field for the date.
   ====================== ======================================================


Convert Date Objects to Various Formats
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following examples show how to output date objects in alternate formats
using the `date->format` method::

   local(my_date) = date('2002-06-14 00:00:00')
   #my_date->format('%A, %B %d')
   // => Friday, June 14

   local(my_date) = date('06/14/2002 09:00:00')
   #my_date->format('%Y%m%d%H%M')
   // => 200206140900

   local(my_date) = date('01/31/2002')
   #my_date->format('%d.%m.%y')
   // => 31.01.02

   local(my_date) = date('09/01/2002')
   #my_date->format('%B, %Y')
   // => September, 2002


Set an Output Format for a Specific Date Object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `date->setFormat` method. This causes all instances of a particular
date object to be output in a specified format::

   local(my_date) = date('01/01/2002')
   #my_date->setFormat('%m%d%y')

The example above causes all instances of ``#my_date`` in the current code to be
output in a custom format without the `date_format` or `date->format`
methods::

   #my_date
   // => 010102


Use Locales to Format Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :type:`locale` type that allows for automatically formatting data such as
dates and currency based on known standards for various locations. You can use
:type:`locale` objects to output dates in these standard formats.

.. type:: locale
.. method:: locale(language::string, country::string =?, variant::string =?)

   Creates a :type:`locale` object which may be used to format the output of
   various data in the manner specified by the locale.

   The method requires one parameter which is the 2-letter ISO-639_ code of the
   language, and accepts optional parameters for the 2-letter ISO-3166_ country
   code and a variant code which allows further refinement to the locale.

.. member:: locale->format(as::date, style::integer =?, andTime::integer =?, addlFlag::integer =?)

   Display a date in the format of the given locale. The method requires one
   parameter which is the date value to be formatted. When formatting dates, the
   method accepts up to 3 additional integer flags which specify different
   date/time formatting types.

The following example creates two locale objects (one for the U.S. and one for
Canada) and uses them to output the date in the format for each locale::

   local(my_date) = date('01/01/2005 08:40:33 AM')
   local(en_us)   = locale('en', 'US')
   local(en_ca)   = locale('en', 'CA')

   #en_us->format(#my_date, 1)
   #en_ca->format(#my_date, 1)

   // =>
   // January 1, 2005
   // 1 January, 2005


Date Accessor Methods
---------------------

A date accessor method returns a specific integer or string value from a date
object, such as the name of the current month or the seconds of the time.

.. member:: date->year()

   Returns a four-digit integer representing the year for the date object
   (defaults to current date).

.. member:: date->month(-long::boolean= ?, -short::boolean= ?)

   Returns the numerical month (1=January, 12=December) for the date object.
   Optional ``-long`` parameter returns the full month name (e.g. "January") or
   an optional ``-short`` parameter returns an abbreviated month name (e.g.
   "Jan").

.. member:: date->week()
.. member:: date->weekOfYear()

   Returns the numerical week of the year (out of 52) for the date object.

.. member:: date->weekOfMonth()

   Returns the numerical week of the month for the date object.

.. member:: date->dayOfWeekInMonth()

   Returns the numerical day of week in month for the date object.

.. member:: date->dayOfYear()

   Returns the numerical day of the year (out of 365) for the date object. Will
   work for leap years as well (out of 366).

.. member:: date->day()
.. member:: date->dayOfMonth()

   Returns the numerical day of the month (e.g. 15) for the date object.

.. member:: date->dayOfWeek()

   Returns the numerical day of the week (1=Sunday, 7=Saturday) for the date
   object.

.. member:: date->hour()
.. member:: date->hourOfDay()

   Returns the hour (0--23) for the date object.

.. member:: date->hourOfAMPM()

   Returns the relative hour (1--12) for the date object.

.. member:: date->minute()

   Returns the minute (0--59) for the date object.

.. member:: date->second()

   Returns the second (0--59) for the date object.

.. member:: date->millisecond()

   Returns the millisecond (0--59) for the date object.

.. member:: date->time()

   Returns the time for the date object.

.. member:: date->ampm()

   Returns "0" if the time is before noon and "1" if the time is noon or later.

.. member:: date->am()

   Returns "true" if the time is in the morning (before noon), otherwise returns
   "false".

.. member:: date->pm()

   Returns "true" if the time is in the evening (noon or after), otherwise
   returns "false".

.. member:: date->timezone()

   Returns the set time zone for the date object. Defaults to the current time
   zone of the server.

.. member:: date->zoneOffset()

   Returns the time zone offset field for the date object.

.. member:: date->gmt()

   Returns "true" if the date object is in GMT time and "false" if it is in
   local time.

.. member:: date->dst()

   Returns "true" if the date object is in daylight saving time and "false" if
   it is not.

.. member:: date->dstOffset()

   Returns the daylight saving time (DST) offset field for the date object.
   Returns "0" if the date for the time zone is not experiencing daylight
   savings.

.. member:: date->asInteger()

   Returns "epoch time", the number of seconds from 1/1/1970 to the time of the
   date object.


Using Date Accessors
^^^^^^^^^^^^^^^^^^^^

The individual parts of a date object can be displayed using the :type:`date`
type member methods::

   date('5/22/2002 14:02:05')->year
   // => 2002

   date('5/22/2002 14:02:05')->month
   // => 5

   date('2/22/2002 14:02:05')->month(-long)
   // => February

   date('5/22/2002 14:02:05')->day
   // => 22

   date('5/22/2002 14:02:05')->dayOfWeek
   // => 4

   date('5/22/2002 14:02:05')->time
   // => 14:02:05

   date('5/22/2002 14:02:05')->hour
   // => 14

   date('5/22/2002 14:02:05')->minute
   // => 2

   date('5/22/2002 14:02:05')->second
   // => 5

The `date->millisecond` method can only return the current number of
milliseconds (as related to the clock time) for the machine running Lasso::

   date->millisecond
   // => 957


Duration Type
=============

A :type:`duration` is a special type that represents a length of time. A
duration is not a 24-hour clock time, and may represent any number of hours,
minutes, or seconds.

Similar to dates, durations must be created using `duration` creator methods
before they can be manipulated. Durations may be converted from a
"hours:minutes:seconds"-formatted string, or just as seconds. ::

   duration('1:00:00')
   // => 1:00:00

   duration(3600)
   // => 1:00:00

Once an object has been created as a :type:`duration` type, duration
calculations and accessors may then be used. Durations are especially useful for
calculating lengths of time under 24 hours, though they can be used for any
lengths of time. Durations are based on start and end date/time objects. These
start and end date/times are either specified when creating the duration or the
current date/time is used as the start date/time while the end date/time is
calculated based on the specified length for the duration.


Duration Methods
----------------

.. type:: duration
.. method:: duration(time::string)
.. method:: duration(time::integer)
.. method:: duration(start::date, end::date)
.. method:: duration(start::string, end::string)
.. method:: duration(-year= ?, -week= ?, -day= ?, -hour= ?, -minute= ?, -second= ?)

   Creates a duration object. Accepts a duration string for
   ``'hours:minutes:seconds'``, an integer number of seconds, or a start and end
   date specified as either dates or strings that can be converted to dates. Or
   by specifying one or more of the following keyword parameters to add the
   amount of time indicated by the name of the keyword parameter: ``-year``,
   ``-week``, ``-day``, ``-hour``, ``-minute``, or ``-second``.

.. member:: duration->year()

   Returns the integer number of years in a duration (based on the specified
   start and end date or based on a start date of when the duration object was
   created with an end date dependant on the specified length of time).

.. member:: duration->month()

   Returns the integer number of months in a duration (based on the specified
   start and end date or based on a start date of when the duration object was
   created with an end date dependant on the specified length of time).

.. member:: duration->week()

   Returns the integer number of weeks in the duration.

.. member:: duration->day()

   Returns the integer number of days in the duration.

.. member:: duration->hour()

   Returns the integer number of hours in the duration.

.. member:: duration->minute()

   Returns the integer number of minutes in the duration.

.. member:: duration->second()

   Returns the integer number of seconds in the duration.


Create and Display Durations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Durations can be created using the `duration` creator method with the ``-week``,
``-day``, ``-hour``, ``-minute``, and ``-second`` parameters. This always
returns a duration object whose `duration->asString` method returns a string in
"hours:minutes:seconds" format. ::

   duration(-week=5, -day=3, -hour=12)
   // => 924:00:00

   duration(-day=4, -hour=2, -minute=30)
   // => 98:30:00

   duration(-hour=12, -minute=45, -second=50)
   // => 12:45:50

   duration(-hour=3, -minute=30)
   // => 03:30:00

   duration(-minute=15, -second=30)
   // => 00:15:30

   duration(-second=30)
   // => 00:00:30

Specific elements of time can be returned from a duration using the accessor
member methods. ::

   duration('8766:30:45')->year
   // => 1

   duration('8766:30:45')->month
   // => 12

   duration('8766:30:45')->week
   // => 52

   duration('8766:30:45')->day
   // => 365

   duration('8766:30:45')->hour
   // => 8766

   duration('8766:30:45')->minute
   // => 525990

   duration('8766:30:45')->second
   // => 31559445


.. _date-duration-math:

Date and Duration Math
======================

Date calculations can be performed by using special ``date_…`` methods,
:type:`date` member methods, and operators. Date calculations that can be
performed include adding or subtracting year, month, week, day, and time
increments to and from dates, and calculations with durations.

.. important::
   Lasso does not account for changes to and from daylight saving time when
   performing date math and duration calculations. One should take this into
   consideration when performing a date or duration calculation across dates
   that encompass a change to or from daylight saving time, as the resulting
   date may be off by an hour.


Date Math Methods
-----------------

Lasso provides a few top-level methods for performing date calculations. These
methods are summarized below.

.. method:: date_add(\
      value, \
      -millisecond::integer= ?, \
      -second::integer= ?, \
      -minute::integer= ?, \
      -hour::integer= ?, \
      -day::integer= ?, \
      -week::integer= ?, \
      -month::integer= ?, \
      -year::integer= ?\
   )

   Returns a date value generated by adding a specified amount of time to a
   specified date object or valid date string. The first parameter is a date
   object or valid value that can be converted to a date. Keyword/value
   parameters define what should be added to the first parameter.

.. method:: date_subtract(\
      value, \
      -millisecond::integer= ?, \
      -second::integer= ?, \
      -minute::integer= ?, \
      -hour::integer= ?, \
      -day::integer= ?, \
      -week::integer= ?, \
      -month::integer= ?, \
      -year::integer= ?\
   )

   Returns a date value generated by subtracting a specified amount of time from
   a specified date value. The first parameter is a Lasso date object or valid
   value that can be converted to a date. Keyword/value parameters define what
   should be subtracted from the first parameter.

.. method:: date_difference(value, when, ...)

   Returns the time difference between two specified dates. A duration is the
   default return value. Optional parameters may be used to output a specific
   integer time value instead of a duration: ``-millisecond``, ``-second``,
   ``-minute``, ``-hour``, ``-day``, ``-week``, ``-month``, or ``-year``.


Add Time to a Date
^^^^^^^^^^^^^^^^^^

Using the `date_add` method, a specified number of hours, minutes, seconds,
days, or weeks can be added to a date object or valid value that can be
converted to a date. The following examples show the result of adding different
values to the current date of "5/22/2002 14:02:05"::

   date_add(date, -second=15)
   // => 2002-05-22 14:02:20

   date_add(date, -minute=15)
   // => 2002-05-22 14:17:05

   date_add(date, -hour=15)
   // => 2002-05-23 05:02:05

   date_add(date, -day=15)
   // => 2002-06-06 14:02:05

   date_add(date, -week=15)
   // => 2002-09-04 14:02:05

   date_add(date, -month=6)
   // => 2002-11-22 14:02:05

   date_add(date, -year=1)
   // => 2003-05-22 14:02:05


Subtract Time from a Date
^^^^^^^^^^^^^^^^^^^^^^^^^

Using the `date_subtract` method, a specified number of hours, minutes, seconds,
days, or weeks can be subtracted a date object or valid value that can be
converted to a date. The following examples show the result of subtracting
different values from the date "5/22/2001 14:02:05"::

   date_subtract(date('5/22/2001 14:02:05'), -second=15)
   // => 05/22/2001 14:01:50

   date_subtract(date('5/22/2001 14:02:05'), -minute=15)
   // => 05/22/2001 13:47:05

   date_subtract(date('5/22/2001 14:02:05'), -hour=15)
   // => 05/21/2001 23:02:05

   date_subtract('5/22/2001 14:02:05', -day=15)
   // => 05/7/2001 14:02:05

   date_subtract('5/22/2001 14:02:05', -week=15)
   // => 02/6/2001 14:02:05


Determine the Duration Between Two Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `date_difference` method. The following examples show how to calculate
the time difference between two date object or valid values that can be
converted to a date::

   date_difference(date('5/23/2002'), date('5/22/2002'))
   // => 24:00:00

   date_difference(date('5/23/2002'), date('5/22/2002'), -second)
   // => 86400

   date_difference(date('5/23/2002'), '5/22/2002', -minute)
   // => 1440

   date_difference(date('5/23/2002'), '5/22/2002', -hour)
   // => 24

   date_difference('5/23/2002', date('5/22/2002'), -day)
   // => 1

   date_difference('5/23/2002', date('5/30/2002'), -week)
   // => -1

   date_difference('5/23/2002', '6/23/2002', -month)
   // => -1

   date_difference('5/23/2002', '5/23/2001', -year)
   // => 1


Date Math Member Methods
------------------------

A number of member methods are used for performing date math operations on date
objects, such as adding durations to dates, subtracting a duration from a date,
and determining a duration between two dates. These methods are summarized
below.

.. member:: date->add(...)

   Adds a specified amount of time to a date object. Can pass a duration object
   or specify the amount of time by passing keyword parameters to define what
   values should be added to the object: ``-second``, ``-minute``, ``-hour``,
   ``-day``, ``-week``, ``-month``, or ``-year``.

.. member:: date->roll(...)

   Like `date->add`, this method adds the specified amount of time to the
   current date object. However, unlike `date->add`, only the specified field is
   adjusted. For example, rolling 60 minutes doesn't change the date at all
   since the minute field will roll back to its original value and the hour
   field will not be modified. Valid fields to roll are ``-second``,
   ``-minute``, ``-hour``, ``-day``, ``-week``, ``-month``, or ``-year``.

.. member:: date->subtract(...)

   Subtracts a specified amount of time from a date object. Can pass a duration
   object or specify the amount of time by passing keyword/value parameters to
   define what should be subtracted from the object: ``-millisecond``,
   ``-second``, ``-minute``, ``-hour``, ``-day``, or ``-week``.

.. member:: date->difference(when, ...)

   Calculates the duration between two date objects. The first parameter must be
   a valid value that can be converted to a date. By default, this method
   returns a duration object, but will return an integer time value if one of
   the following optional parameter is specified: ``-millisecond``, ``-second``,
   ``-minute``, ``-hour``, ``-day``, ``-week``, ``-month``, or ``-year``.

.. member:: date->daysBetween(other::date)

   Requires another date object as a parameter and returns the number of days
   between the current date object and the specified date object.

.. member:: date->businessDaysBetween(other::date)

   Requires another date object as a parameter and returns the number of
   business days between the current date object and the specified date object.

.. member:: date->hoursBetween(other::date)

   Requires another date object as a parameter and returns the number of hours
   between the current date object and the specified date object.

.. member:: date->minutesBetween(other::date)

   Requires another date object as a parameter and returns the number of minutes
   between the current date object and the specified date object.

.. member:: date->secondsBetween(other::date)

   Requires another date object as a parameter and returns the number of seconds
   between the current date object and the specified date object.

.. note::
   The `date->add`, `date->roll`, and `date->subtract` methods do not return any
   values, but are instead used to change the value of the object calling them.


Add Time to a Date
^^^^^^^^^^^^^^^^^^

Use the `date->add` method. The following examples show how to add a duration to
a date and display that date::

   local(my_date) = date('5/22/2002')
   #my_date->add(duration('24:00:00'))
   #my_date
   // => 05/23/2002

   local(my_date) = date('5/22/2002 00:00:00')
   #my_date->add(duration(3600))
   #my_date
   // => 05/22/2002 01:00:00

   local(my_date) = date('5/22/2002')
   #my_date->add(-week=1)
   #my_date
   // => 05/29/2002


Subtract Time from a Date
^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `date->subtract` method. The following examples show how to subtract a
duration from a date object and display that date::

   local(my_date) = date('5/22/2002')
   #my_date->subtract(duration('24:00:00'))
   #my_date
   // => 05/21/2002

   local(my_date) = date('5/22/2002 00:00:00')
   #my_date->subtract(duration(7200))
   #my_date
   // => 05/21/2002 22:00:00

   local(my_date) = date('5/22/2002')
   #my_date->subtract(-day=3)
   #my_date
   // => 05/19/2002


Determine the Duration Between Two Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `date->difference` method. The following examples show how to calculate
the time difference between two dates and display as a duration::

   local(my_date) = date('5/15/2002 00:00:00')
   #my_date->difference(date('5/22/2002 01:30:00'))
   // => 169:30:00

   local(my_date) = date('5/15/2002')
   #my_date->difference(date('5/22/2002'), -day)
   // => 7


Date Math Operators
-------------------

Date and duration math can also be performed using math operators in a manner
similar to integer objects. If a date or duration appears to the left of a math
operator then the appropriate math operation will be performed and the result
will be a date or duration as appropriate.

.. member:: date->+(rhs)

   A duration can be added to a date or two durations summed using the ``+``
   operator.

.. member:: date->-(rhs)

   A duration can be subtracted from a date or duration or the duration between
   two dates can be determined using the ``-`` operator.


Add or Subtract Dates and Durations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following examples show addition and subtraction operations using dates and
durations::

   date('5/22/2002') + duration('24:00:00')
   // => 05/23/2002

   date('5/22/2002') - duration('48:00:00')
   // => 05/20/2002


Determine the Duration Between Two Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following calculates the duration between two dates using the subtraction
operator (``-``)::

   date('5/22/2002') - date('5/15/2002')
   // => 168:00:00


Add One Day to the Current Date
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example adds one day to the current date::

   date + duration(-day=1)
   // => 2007-10-30 18:03:27


Return the Duration Between Now and a Future Date
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example returns the duration between the current date and
12/31/2250::

   date('12/31/2250') - date
   // => 2079000:56:08

.. _ICU date formatting symbols: http://userguide.icu-project.org/formatparse/datetime#TOC-Date-Time-Format-Syntax
.. _ISO-639: http://www.loc.gov/standards/iso639-2/
.. _ISO-3166: http://www.iso.org/iso/prods-services/iso3166ma/02iso-3166-code-lists/country_names_and_code_elements
