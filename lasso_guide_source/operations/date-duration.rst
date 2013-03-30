.. _date-duration:

***************
Date & Duration
***************

This chapter introduces the date and the duration data types in Lasso 9. Dates
are a data type that represent a calendar date and/or clock time. Durations are
a data type that represents a length of time in hours, minutes, and seconds.
Date and duration objects can be manipulated in a similar manner as integer
objects, and methods can be used to determine date differences, time
differences, and more. Date objects may also be formatted and converted to a
number of predefined or custom formats, and specific information may be
extrapolated from a date object (day of week, name of month, etc.).

Since dates and durations can take many forms, values that represent a date or a
duration must be explicitly cast as date or duration types using the ``date``
and ``duration`` creator methods. For example, a value of "01/01/2002 12:30:00"
will be treated as a string data type until it is cast as a date type using the
``date`` method::

   date('01/01/2002 12:30:00')

Once a value is cast as a date or duration data type, special member methods,
accessors, conversion operations, and math operations may then be used.


Internal Date Libraries
=======================

When performing date operations, Lasso uses internal date libraries to
automatically adjust for leap years and daylight saving time for the local time
zone in all applicable regions of the world (not all regions recognize daylight
saving time). The current time and time zone are based on that of the Web
server.

.. note::
   Lasso extracts daylight saving time information from the operating system.
   For information on special exceptions with date calculations during daylight
   saving time, see the :ref:`Date and Duration Math<date-duration-math>`
   section.

Date Type
=========

For Lasso to recognize a string as a date data type, the string must be
explicitly cast as a date data type using the ``date`` creator method::

   date('5/22/2002 12:30:00')

When casting as a date type using the ``date`` creator method, the following
date formats are automatically recognized as valid date strings by Lasso: These
automatically recognized date formats are U.S. or MySQL dates with a four digit
year followed by an optional 24-hour time with seconds. The  "/" ,  "-" , and
":"  characters are the only punctuation marks recognized in valid date strings
by Lasso when used in the formats shown below::

   1/25/2002
   1/25/2002 12:34
   1/25/2002 12:34:56
   1/25/2002 12:34:56 GMT
   2002-01-25
   2002-01-25 12:34:56
   2002-01-25 12:34:56 GMT

Lasso also recognizes a number of special purpose date formats which are shown
below. These are useful when working with HTTP headers or email message
headers::

    20020125123456
    20020125T12:34:56
    Tue, Dec 17 2002 12:34:56 -0800
    Tue Dec 17 12:34:56 PST 2002

The date formats which contain time zone information (e.g. "-0800" or "PST")
will be recognized as GMT dates. The time zone will be used to automatically
adjust the date/time to the equivalent GMT date/time.

If using a date format not listed above, custom date formats can be defined
using the ``-format`` parameter of the ``date`` creator method.

The following variations of the automatically recognized date formats
are valid without using the ``-format`` parameter:

-  If the ``date`` creator method is used without a parameter then the current
   date and time are returned. Milliseconds are rounded to the nearest second.

-  If the time is not specified then it is set to be the current hour when the
   object is created. For example, "22:00:00" if the object was created at
   10:48:59 PM::

      mm/dd/yyyy -> mm/dd/yyyy 22:00:00
   
-  If the seconds are not specified then the time is assumed to be even on the
   minute::

      mm/dd/yyyy hh:mm -> mm/dd/yyyy hh:mm:00

-  An optional GMT designator can be used to specify Greenwich Mean Time rather
   than local time::

      mm/dd/yyyy hh:mm:ss GMT

-  Two digit years are assumed to be in the 1\ :sup:`st` century. For best
   results, always use four digit years::

      mm/dd/00 -> mm/dd/0001
      mm/dd/39 -> mm/dd/0039
      mm/dd/40 -> mm/dd/0040
      mm/dd/99 -> mm/dd/0099

-  Days and months can be specified with or without leading "0"s. The following
   are all valid Lasso date strings::

      1/1/2002
      01/1/2002
      1/01/2002
      01/01/2002
      01/01/2002 16:35
      01/01/2002 16:35:45
      GMT 01/01/2002 12:35:45 GMT


Cast a Value as a Date Type
---------------------------

If the value is in a recognized string format described previously,
simply use the ``date`` creator method::

   date('05/22/2002')          // => 05/22/2002
   date('05/22/2002 12:30:00') // => 05/22/2002 12:30:00
   date('2002-05-22')          // => 2002-05-22

If the value is not in a string format described previously, use the ``date``
creator method with the ``-format`` parameter. For information on how to use the
``-format`` parameter, see the
:ref:`Formatting Dates<date-duration-formatting-dates>` section later in this
chapter::

   date('5.22.02 12:30', -format='%m.%d.%y %H:%M') // => 5.22.02 12:30
   date('20020522123000', -format='%Y%m%d%H%M')    // => 200205221230

Date values which are stored in database fields or variables can be cast as a
date type using the ``date`` creator method. The format of the date stored in
the field or variable should be in one of the format described above or the
``-format`` parameter must be used to explicitly specify the format::

   date(#myDate)
   date(field('modified_date'))
   date(web_request->param('birth_date'))


.. class:: date
.. method:: date()
.. method:: date(
      -year= ?, -month= ?, -day= ?, 
      -hour= ?, -minute= ?, -second= ?, 
      -dateGMT= ?, -locale::locale= ?
   )
.. method:: date(date::string, -format::string= ?, -locale::locale= ?)
.. method:: date(date::integer, -locale::locale= ?)
.. method:: date(date::decimal, -locale::locale= ?)
.. method:: date(date::date, -locale::locale= ?)

   All the various creator methods that can be used to create a date object.
   When called without parameters, it returns a date object with the current
   date and time. A date object can be created from properly formatted strings,
   integers, decimals, and dates. A date object can also be created by passing
   valid values to keyword parameters named ``-second``, ``-minute``, ``-hour``,
   ``-day``, ``-month``, ``-year``, and ``-dateGMT``. Each creator method also
   allows for specifying a locale object to use with the ``-locale`` keyword
   parameter. (By default this is set to what the ``locale_default`` method
   returns.)

.. method:: date_format(value, format::string)
.. method:: date_format(value, -format::string)

   Returns the passed-in date parameter in the specified format. Requires a date
   object or any valid objects that can be cast as a date (it auto-recognizes
   the same formats as the ``date`` creator methods). The format can be
   specified as the second parameter or as the value part of a ``-format``
   keyword parameter and defines the format for the return value. See the
   :ref:`Formatting Dates<date-duration-formatting-dates>` section below for
   more details on format strings.

.. method:: date_setFormat(format::string)

   Sets the date format for date objects to use for output for an entire Lasso
   thread. The required parameter is a format string.

.. method:: date_gmtToLocal(value)

   Converts the date/time of any object that can be cast as a date object from
   Greenwich Mean Time to the local time of the machine running Lasso 9. 

.. method:: date_localToGMT(value)

   Converts the date/time of any object that can be cast as a date object from
   local time to Greenwich Mean Time.
  
.. method:: date_getLocalTimeZone()

   Returns the current time zone of the machine running Lasso 9 as a standard
   GMT offset string (e.g. "-0700"). Optional "-long" parameter shows the name
   of the time zone (e.g. "America/New_York").

.. method:: date_minimum()

   Returns the minimum possible date recognized by a date object in Lasso.
  
.. method:: date_maximum()

   Returns the maximum possible date recognized by a date object in Lasso.
  
.. method:: date_msec()

   Returns an integer representing the number of milliseconds recorded on the
   machine's internal clock. Can be used for precise timing of code execution.


Display Date Values
^^^^^^^^^^^^^^^^^^^

The current date/time can be displayed with ``date``. The example below assumes
a current date and time of "5/22/2002 14:02:05"::

   date
   // => 2002-05-22 14:02:05

The ``date`` type can be used to assemble a date from individual parameters. The
following method assembles a valid Lasso date by specifying each part of the
date separately. Since the time is not specified it is assumed to be the current
time the date object is created in the example below assumes the current date
and time of 5/7/2013 15:45:04::

   date(-year=2002, -month=5, -day=22)
   // => 2002-05-22 15:45:04


Convert Date Values To and From GMT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any date object can be converted to and from Greenwich Mean Time using the
``date_gmtToLocal`` and ``date_localToGMT`` methods. These methods will only
convert to and from the current time zone of the machine running Lasso. The
following example uses Pacific Time (PDT) as the current time zone::

   date_gmtToLocal(date('5/22/2002 14:02:05'))
   // => 05/22/2002 14:02:05
   date_localToGMT(date('5/22/2002 14:02:05'))
   // => 05/22/2002 14:02:05


Show the Current Time Zone for the Server Running Lasso 9
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``date_getLocalTimeZone`` method displays the current time zone of the
machine running Lasso. The following example uses Eastern Standard Time (EST) as
the current time zone::

   date_getLocalTimeZone
   // -> -0500
   date_getLocalTimeZone(-long)
   // => America/New_York


Time a Section of Lasso Code

Call the ``date_msec`` method to get a clock value before and after the code has
executed. The difference in times represents the number of milliseconds which
have elapsed. Note that the ``date_msec`` value may occasionally roll back
around to zero so any negative times reported by this code should be
disregarded::

   <?lasso
      local(start) = date_msec
      // … The code to time …
      'The code took ' + (date_msec - #start) + ' milliseconds to process.'
   ?>

.. _date-duration-formatting-dates:

Formatting Dates
----------------

Various methods take a format string for one of their parameters. A format
string is a compliation of symbols that define the format of the string to be
outputted or parsed. The symbols which can be used in a format string are
detailed in the following table:

====== =========================================================================
Symbol Description
====== =========================================================================
``%d`` U.S. Date Format (Mm/Dd/yyyy).
``%Q`` MySQL date format (yyyy-mm-dd).
``%q`` MySQL timestamp format (yyyymmddhhmmss)
``%r`` 12-hour time format (hh:mm:ss [AM/PM]).
``%T`` 24-hour time format (hh:mm:ss).
``%Y`` 4-digit year.
``%y`` 2-digit year.
``%m`` Month number (01=January, 12=December).
``%B`` Full English month name (e.g. "January").
``%b`` Abbreviated English month name (e.g. "Jan").
``%d`` Day of month (01-31).
``%w`` Day of week (01=Sunday, 07=Saturday).
``%W`` Week of year.
``%A`` Full English weekday name (e.g. "Wednesday").
``%a`` Abbreviated English weekday name (e.g. "Wed").
``%H`` 24-hour time hour (0-23).
``%h`` 12-hour time hour (1-12).
``%M`` Minute (0-59).
``%S`` Second (0-59).
``%p`` AM/PM for 12-hour time.
``%G`` GMT time zone indicator.
``%z`` Time zone offset in relation to GMT (e.g. +0100, -0800).
``%Z`` Time zone designator (e.g. PST, GMT-1, GMT+12).
``%%`` A literal percent character,
====== =========================================================================

Each of the date format symbols that returns a number automatically pads that
number with ``0`` so all values returned by the tag are the same length.

-  An optional underscore ("_") between the percent sign ("%") and the letter
   designating the symbol specifies that a space should be used instead of "0"
   for the padding character (e.g. "%_m" returns the month number with space
   padding).
-  An optional hyphen ("-") between the percent sign ("%") and the letter
   designating the symbol specifies that no padding should be performed (e.g.
   "%-m" returns the month number with no padding).
-  A literal percent sign can be inserted using "%%".

.. note::
   If the "%z" or "%Z" symbols are used when parsing a date, the resulting date
   object will represent the equivalent GMT date/time.

Starting in Lasso 9, Lasso also recognizes the ICU formatting strings for both
creating and displaying dates. These format strings simply use letters to
specify the format without any flags (such as the "%" symbol). For example, to
output a two-digit year, the ICU format string is "yy" and to output it as a
four digit year, it's "yyyy". Because of this, characters that are not symbols
need to be escaped if they are in the format string. To escape characters in an
ICU format string, wrap them in single-quotes.

For a detailed list of letters for an ICU format string, see the following
website: `<http://userguide.icu-project.org/formatparse/datetime#TOC-Date-Time-Format-Syntax>`_

.. note::
   Format string in Lasso 9 can contain both percent-based formatting as well as
   ICU formatting in the same string. Because of this, be sure you properly
   escape any characters you don't want treated as format delimiters in your
   format string. For example, if the current date was "2013-03-09 20:15:30",
   the following code: ``date->format("day: %A")`` would produce
   "9PM2013: Saturday" as the "day" portion of the format string would be
   treated as part of ICU formatting.


Convert Lasso Date Objects to Various Formats
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following examples show how to convert either Lasso date objects or valid
Lasso date strings to alternate formats::

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


Import and Export Dates From MySQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A common conversion in Lasso is converting MySQL dates to and from U.S. dates.
Dates are stored in MySQL in the following format "yyyy-mm-dd". The following
example shows how to import a date in this format and then output it to a U.S.
date format using the ``date_format`` method::

   date_format('2001-05-22', -format='%-D')
   // => 5/22/2001

   date_format('5/22/2001', -format='%Q')
   // => 2001-05-22

   date_format(date('2001-05-22'), '%D')
   // => 05/22/2001

   date_format(date('5/22/2001'), '%Q')
   // => 2001-05-22


Set a Custom Date Format For a Thread
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``date_setFormat`` method. This allows all date objects in a thread to
be outputted in a custom format without the use of the ``date_format`` or
``date->format`` methods. The format specified is only valid for the currently
executing thread after the ``date_setFormat`` method has been called::

   date_setFormat('%m%d%y')

The example above means that from now on in the currently executing thread, all
dates converted to strings will use that format. Ex::

   date('01/01/2002')
   // => 010102


Date Format Member Methods
--------------------------

In addition to ``date_format`` and ``date_setFormat``, Lasso 9 also
offers the ``date->format`` and ``date->setFormat`` member methods for performing format
conversions on date objects.

.. method:: date->format()
.. method:: date->format(format::string, -locale::locale= ?)
.. method:: date->format(-format::string, -locale::locale= ?)

   Outputs the date object in the specified format. If no format is passed, the
   current format stored with the object will be used. Otherwise, it requries a
   format string to specify the format. Optionally takes a ``locale`` object to
   set its locale.

.. method:: date->setFormat(format::string)

   Sets a date output format for a particular date object. Requires a format    
   string as a parameter.

.. method:: date->getformat()

   Returns the current format string set for the current date object.

.. method:: date->clear()

   Resets the specified fields to their default values. The following fields can
   be specified as keyword parameters: ``-second``, ``-minute``, ``-hour``,
   ``-day``, ``-week``, ``-month``, ``-year``. If no parameters are specified,
   then the entire date is reset to default values.

.. method:: date->set(…)

   Sets one or more elements of the date to a new value. If a field overflows
   then other fields may be modified as well.  For example, if you have the date
   "3/31/2008" and you set the month to "2" then the day will be
   adjusted to "29" automatically resulting in "2/29/2008".

   Elements must be specified as keyword=value parameters.See table
   :ref:`List of Field Elements for Get and Set
   <table-date-field-elements-for-get-set>` for the full list of parameters that
   this method can set.

.. method:: date->get(…)

   Returns the current value for the specified field of the current date object.
   Only one field value can be fetched at a time. Note that many of the more
   common fields can also be retrieved through individual member tags.

   See table :ref:`List of Field Elements for Get and Set
   <table-date-field-elements-for-get-set>` for the full list of parameters that
   this method can retrieve.

.. _table-date-field-elements-for-get-set:

.. table:: Table: List of Field Elements for Get and Set

   ================== ==========================================================
   Parameter          Description
   ================== ==========================================================
   -year              Sets the year field for the date.
   -month             Sets the month field for the date.
   -week              Sets the week field for the date.
   -day               Sets the day field for the date.
   -hour              Sets the hour field for the date.
   -minute            Sets the minute field for the date.
   -second            Sets the second field for the date.
   -weekofyear        Sets the week of year field for the date.
   -weekofmonth       Sets the week of month field for the date.
   -dayofmonth        Sets the day of month field for the date.
   -dayofyear         Sets the day of year field for the date.
   -dayofweek         Sets the day of week field for the date.
   -dayofweekinmonth  Sets the day of week in month field for the date.
   -ampm              Sets the am/pm field for the date.
   -hourofday         Sets the hour of day field for the date.
   -zoneoffset        Sets the time zone offset field for the date.
   -dstoffset         Sets the dst offset field for the date.
   -yearwoy           Sets the year week of year field for the date.
   -dowlocal          Sets the local day of week field for the date.
   -extendedyear      Sets the extended year field for the date.
   -julianday         Sets the julian day field for the date.
   -millisecondsinday Sets the milliseconds in day field for the date.
   ================== ==========================================================


Convert Date Objects to Various Formats
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following examples show how to output date objects in alternate formats
using the ``date->format`` method::

   local(my_date) = date('2002-06-14 00:00:00')
   #my_date->format('%A, %B %d')
   // => Friday, June 14

::

   local(my_date) = date('06/14/2002 09:00:00')
   #my_date->format('%Y%m%d%H%M')
   // => 200206140900

::

   local(my_date) = date('01/31/2002')
   #my_date->format('%d.%m.%y')
   // => 31.01.02

::

   local(my_date) = date('09/01/2002')
   #my_date->format('%B, %Y')]
   // => September, 2002


Set an Output Format for a Specific Date Object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``date->setFormat`` method. This causes all instances of a particular
date object to be output in a specified format\::

   local(my_date) = date('01/01/2002')
   #my_date->setFormat('%m%d%y')

The example above causes all instances of ``#my_date`` in the current code to be
output in a custom format without the ``date_format`` or ``date->format``
methods::

   #my_date
   // => 010102


Using Locales to Format Dates
-----------------------------

Lasso 9 introduces a new locales feature that allows for automatically
formatting things such as dates and currency based on known standards for
various locations. You can use locale objects to output dates in these standard
formats. (See the chapter on :ref:`locales<locale>` for more information.)

Using Locales to Display Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example creates two ``locale`` objects (one for the US and one for
Canada) and uses them to output the date in the format for each locale::

   local(my_date) = date('01/01/2005 08:40:33 AM')
   local(en_us)   = locale('en', 'US')
   local(en_ca)   = locale('en', 'CA')

   #en_us->format(#my_date, 1)
   #en_ca->format(#my_date, 1)

   // =>
   // January 1, 2005
   // 1 January, 2005


Date Accessors
--------------

A date accessor method returns a specific integer or string value from
a date object, such as the name of the current month or the seconds
of the time.

.. method:: date->year()

   Returns a four-digit integer representing the year for a specified date.
  
.. method:: date->month(
      -long::boolean= ?,
      -short::boolean= ?
   )

   Returns the number of the month (1=January, 12=December) for a specified date
   (defaults to current date). Optional ``-long`` parameter returns the full
   month name (e.g. "January") or an optional ``-short`` parameter returns an
   abbreviated month name (e.g. "Jan").
  
.. method:: date->day()

   Returns the integer day of the month (e.g. 15).
  
.. method:: date->dayOfYear()

   Returns integer day of year (out of 365). Will work with leap years as well
   (out of 366).
  
.. method:: date->dayOfWeek()

   Returns the number of the day of the week (1=Sunday, 7=Saturday) for the date
   object.
  
.. method:: date->week()
.. method:: date->weekOfYear()

   Returns the integer week number for the year of the specified date (out of
   52).

.. method:: date->weekOfMonth()

   Returns the week of month field for the date.

.. method:: date->dayOfMonth()

   Returns the day of month field for the date.

.. method:: date->dayOfWeekInMonth()

   Returns the day of week in month field for the date.
  
.. method:: date->hour()
.. method:: date->hourOfDay()

   Returns the hour for the date object (0-23).

.. method:: date->hourOfAMPM()

   Returns the relative hour for the date object (1-12).

.. method:: date->minute()

   Returns integer minutes from "0" to "59" for the date object.
  
.. method:: date->second()

   Returns integer seconds from "0" to "59" for the date object.
  
.. method:: date->millisecond()

   Returns the current integer milliseconds of the current date object.
  
.. method:: date->time()
   
   Returns the time of the date object.

.. method:: date->ampm()
   
   Returns "0" if the time is before noon and "1" if it's noon or later.

.. method:: date->am()

   Returns "true" if the time is in the morning (before noon), otherwise returns
   false.

.. method:: date->pm()

   Returns "true" if the time is in the evening (after noon), otherwise returns
   false.

.. method:: date->timezone()

   Returns the timezone setup for the date. Defaults to the current timezone of
   the server.

.. method:: date->zoneOffset()

   Returns the time zone offset field for the date.
  
.. method:: date->gmt()

   Returns "true" if the date object is in GMT time and "false" if it is in
   local time.
  
.. method:: date->dst()

   Returns "true" if the date object is in daylight savings time and "false" if
   it is not.

.. method:: date->dstOffset()

   Returns the daylight saving time (DST) offset field for the date. Returns "0"
   if the date for the timezone is not experiencing daylight savings.

.. method:: date->asInteger()

   Returns epoch time - the number of seconds from 1/1/1970 to the time of the
   current date object.


Use Date Accessors
^^^^^^^^^^^^^^^^^^

The individual parts of a date object can be displayed using the ``date`` type
member methods::

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

The ``date->millisecond`` method can only return the current number of
milliseconds (as related to the clock time) for the machine running Lasso::

   date->millisecond
   // => 957

Duration Type
=============

A duration is a special data type that represents a length of time. A duration
is not a 24-hour clock time, and may represent any number of hours, minutes, or
seconds.

Similar to dates, durations must be created using duration creator methods
before they can be manipulated.  Durations may be cast from an
"hours:minutes:seconds" formatted string, or just as seconds::

   duration('1:00:00')
   // => 1:00:00

   duration(3600)
   // => 1:00:00

Once an object has been created as a duration type, duration calculations and
accessors may then be used. Durations are especially useful for calculating
lengths of time under 24 hours, although they can be utilized for any lengths of
time. Durations are based on start and end date/time objects. These start and
end date/times are either specified when creating the duration or the current
date/time is used as the start date/time while the end date/time is calculated
based on the specified length for the duration.

.. class:: duration
.. method:: duration(time::string)
.. method:: duration(time::integer)
.. method:: duration(start::date, end::date)
.. method:: duration(start::string, end::string)
.. method:: duration(-year= ?, -week= ?, -day= ?, -hour= ?, -minute= ?, -second= ?)

   Creeates a duration object. Accepts a duration string for
   "hours:minutes:seconds". Or an integer number of seconds. Or a start and end
   date specified as either dates or strings that can be cast as dates. Or by
   specifying one or more of the following keyword parameters to add the amount
   of time indicated by the name of the keyword parameter: ``-year``, ``-week``,
   ``-day``, ``-hour``, ``-minute``, ``-second``
  
.. method:: duration->year()

   Returns the integer number of years in a duration (based on the specified
   start and end date or based on a start date of when the duration object was
   created with an end date dependant on the specified length of time).
  
.. method:: duration->month()

   Returns the integer number of months in a duration (based on the specified
   start and end date or based on a start date of when the duration object was
   created with an end date dependant on the specified length of time).

.. method:: duration->week()

   Returns the integer number of weeks in the duration.

.. method:: duration->day()

   Returns the integer number of days in the duration.

.. method:: duration->hour()

   Returns the integer number of hours in the duration.

.. method:: duration->minute()

   Returns the integer number of minutes in the duration.

.. method:: duration->second()

   Returns the integer number of seconds in the duration.


Create and Display Durations
----------------------------

Durations can be created using the ``duration`` creator method with the
``-week``, ``-day``, ``-hour``, ``-minute``, and ``-second`` parameters. This
always returns a duration string in "hours:minutes:seconds" format::

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
memebr methods::

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

Date calculations in Lasso 9 can be performed by using special date methods,
durations methods, and math symbols in Lasso 9. Date calculations that can be
performed include adding or subtracting year, month, week, day, and time
increments to and from dates, and calculations with durations.

.. note::
   **Daylight Saving Time**
   Lasso does not account for changes to and from daylight saving time when
   performing date math and duration calculations. One should take this into
   consideration when performing a date or duration calculation across dates
   that encompass a change to or from daylight saving time (resulting date may
   be off by an hour).


Date Math Methods
-----------------

Lasso 9 provides a few top-level methods for performing date calculations.
These methods are summarized below.

.. method:: date_add(
      value,
      -millisecond::integer= ?,
      -second::integer= ?,
      -minute::integer= ?,
      -hour::integer= ?,
      -day::integer= ?,
      -week::integer= ?,
      -month::integer= ?,
      -year::integer= ?
   )

   Adds a specified amount of time to a date object or valid date string. First
   parameter is a date object or valid value that can be cast as a date.
   Keyword/value parameters define what should be added to the first parameter.
  
.. method:: date_subtract(
      value,
      -millisecond::integer= ?,
      -second::integer= ?,
      -minute::integer= ?,
      -hour::integer= ?,
      -day::integer= ?,
      -week::integer= ?,
      -month::integer= ?,
      -year::integer= ?
   )

   Subtracts a specified amount of time from a sepcified date value. The first
   parameter is a Lasso date object or valid value that can be cast as a date.
   Keyword/value parameters define what should be subtracted from the first
   parameter.
  
.. method:: date_difference(value, when, …)

   Returns the time difference between two specified dates. A duration is
   the default return value. Optional parameters may be used to output a
   specific integer time value instead of a duration: ``-millisecond``,
   ``-second``, ``-minute``, ``-hour``, ``-day``, ``-week``, ``-month``, or
   ``-year``.


Add Time to a Date
^^^^^^^^^^^^^^^^^^

Using the ``date_add`` method, a specified number of hours, minutes, seconds,
days, or weeks can be added to a date object or valid value that can be cast as
a date. The following examples show the result of adding different values to the
current date of "5/22/2002 14:02:05"::

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


Subtract Time From a Date
^^^^^^^^^^^^^^^^^^^^^^^^^

Using the ``date_subtract`` method, a specified number of hours, minutes,
seconds, days, or weeks can be subtracted a date object or valid value that can
be cast as a date. The following examples show the result of subtracting
different values from the date ``5/22/2001 14:02:05``::

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


Determine the Time Difference Between Two Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``date_difference`` method. The following examples show how to
calculate the time difference between two date object or valid values that can
be cast as a date::

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


Date Member Math Methods
------------------------

Lasso 9 provides member methods that perform date math operations on date
objects. These methods are used for adding durations to dates, subtracting a
duration from a date, and determining a duration between two dates. These
methods are summarized below.

.. method:: date->add(…)

   Adds a specified amount of time to a data object. Can pass a duraction object
   or specify the amount of time by passing keyword/value parameters to define
   what should be added to the object: ``-second``, ``-minute``, ``-hour``,
   ``-day``, ``-week``, ``-month``, or ``-year``.

.. method:: date->roll(…)

   Like ``date->add``, this method adds the specified amount of time to the
   current date object. However, unlike ``date->add``, only the specified field
   is adjusted. For example, rolling 60 minutes doesn't change the date at all
   since the minute field will roll back to its original value and the hour
   field will not be modified. Valid fields to roll are ``-second``,
   ``-minute``, ``-hour``, ``-day``, ``-week``, ``-month``, or ``-year``.
  
.. method:: date->subtract(…)

   Subtracts a specified amount of time from a date object. Can pass a duration
   object or specify the amount of time by passing keyword/value parameters to
   define what should be subtracted from the object: ``-millisecond``,
   ``-second``, ``-minute``, ``-hour``, ``-day``, or ``-week``.
  
.. method:: date->difference(when, …)

   Calculates the duration between two date objects. The first paramater must be
   a valid value that can be cast as a date. By default, this method returns a
   duration object, but will return an integer time value if one of the
   following optional parameter is specified: ``-millisecond``, ``-second``,
   ``-minute``, ``-hour``, ``-day``, ``-week``, ``-month``, or ``-year``.

.. method:: date->minutesBetween(other::date)
   
   Requires one parameter - another date object - and returns the number of
   minutes between the current date object and the specified date object.

.. method:: date->hoursBetween(other::date)
   
   Requires one parameter - another date object - and returns the number of
   hours between the current date object and the specified date object.

.. method:: date->secondsBetween(other::date)
   
   Requires one parameter - another date object - and returns the number of
   seconds between the current date object and the specified date object.

.. method:: date->daysBetween(other::date)
   
   Requires one parameter - another date object - and returns the number of days
   between the current date object and the specified date object.

.. method:: date->businessDaysBetween(other::date)
   
   Requires one parameter - another date object - and returns the number of
   business days between the current date object and the specified date object.

.. note::
   The ``date->add``, ``date->roll``, and ``date->subtract`` methods do not
   return any values, but are used to change the values of the object calling
   them.


Add a Duration to a Date
^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``date->add`` method. The following examples show how to add a duration
to a date and return a date::

   local(my_date) = date('5/22/2002')
   #my_date->add(duration('24:00:00'))
   #my_date
   // => 05/23/2002

::

   local(my_date) = date('5/22/2002 00:00:00')
   #my_date->add(duration(3600))
   #my_date
   // => 05/22/2002 01:00:00

::

   local(my_date) = date('5/22/2002')
   #my_date->add(-week=1)
   #my_date
   // => 05/29/2002


Subtract a Duration From a Date
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``date->subtract`` method. The following examples show how to subtract a
duration from a date object and return a date::

   local(my_date) = date('5/22/2002')
   #my_date->subtract(duration('24:00:00'))
   #my_date
   // => 05/21/2002

::

   local(my_date) = date('5/22/2002 00:00:00')
   #my_date->subtract(duration(7200))
   #my_date
   // => 05/21/2002 22:00:00

::

   local(my_date) = date('5/22/2002')
   #my_date->subtract(-day=3)
   #my_date
   // => 05/19/2002


Determine the Duration Between Two Dates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``date->difference`` method. The following examples show how to
calculate the time difference between two dates and return a duration::

   local(my_date) = date('5/15/2002 00:00:00')
   #my_date->difference(date('5/22/2002 01:30:00'))
   // => 169:30:00

::

   local(my_date) = date('5/15/2002')
   #my_date->difference(date('5/22/2002'), -day)
   // => 7


Using Math Symbols
------------------

In Lasso 9, one has the ability to perform date and duration
calculations using math symbols (similar to integer objects). If a
date or duration appears to the left of a math symbol then the
appropriate math operation will be performed and the result will be a
date or duration as appropriate.

.. method:: date->+(rhs)

  ``+`` Used for adding a date and a duration, or adding two durations.

.. method:: date->-(rhs)

  ``-`` Used for subtracting a duration from a date, subtracting a duration from
  a duration, or determining the duration between two dates.


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

The following calculates the duration between two dates using the minus symbol::

   date('5/22/2002') - date('5/15/2002')
   // => 168:00:00


Add One Day to the Current Date
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example adds one day to the current date::

   date + duration(-day=1)


Return the Duration Between the Current Date and a Day in the Future
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example returns the duration between the current date and
12/31/2250::

   date('12/31/2250') - date