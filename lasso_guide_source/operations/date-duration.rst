.. _date-duration:

.. direct from book

***************
Date & Duration
***************

Dates and times in Lasso can be stored and manipulated as special date
and duration data types. This chapter describes the tags that can be
used to manipulate dates and times.

-  `Overview`_ provides an introduction to using the Lasso date and
   duration data types.
-  `Date Tags`_ describes the substitution and member tags that can be
   used to cast, format, and display dates and times.
-  `Duration Tags`_ describes the substitution and member tags that can
   be used to cast, format, and display durations.
-  `Date and Duration Math`_ includes requirements and instructions for
   deleting records within a database.
-  `Duplicating Records`_ describes the tags that are used to perform
   calculations using both dates and durations.

Overview
========

This chapter introduces the date and the duration data types in Lasso 8.
Dates are a data type that represent a calendar date and/or clock time.
Durations are a data type that represents a length of time in hours,
minutes, and seconds. Date and duration data types can be manipulated in
a similar manner as integer data types, and operations can be performed
to determine date differences, time differences, and more. Date data
types may also be formatted and converted to a number of predefined or
custom formats, and specific information may be extrapolated from a date
data type (day of week, name of month, etc.).

Since dates and durations can take many forms, values that represent a
date or a duration must be explicitly cast as date or duration data
types using the ``[Date]`` and ``[Duration]`` tags. For example, a value
of ``01/01/2002 12:30:00`` will be treated as a string data type until
it is cast as a date data type using the ``[Date]`` tag::

   [Date:'01/01/2002 12:30:00']

Once a value is cast as a date or duration data type, special tags,
accessors, conversion operations, and math operations may then be used.

Internal Date Libraries
-----------------------

When performing date operations, Lasso uses internal date libraries to
automatically adjust for leap years and daylight saving time for the
local time zone in all applicable regions of the world (not all regions
recognize daylight saving time). The current time and time zone are
based on that of the Web server.

.. Note:: **Daylight Saving Time**   Lasso extracts daylight saving time
   information from the operating system, and can only support daylight
   saving time conversions between the years **1970** and **2038**. For
   information on special exceptions with date calculations during
   daylight saving time, see the :ref:`Date and Duration Math` section.

Date Tags
=========

For Lasso to recognize a string as a date data type, the string must be
explicitly cast as a date data type using the ``[Date]`` tag.

::

   [Date: '5/22/2002 12:30:00']

When casting as a date data type using the ``[Date]`` tag, the following
date formats are automatically recognized as valid date strings by
Lasso: These automatically recognized date formats are U.S. or MySQL
dates with a four digit year followed by an optional 24-hour time with
seconds. The  ``/`` ,  ``-`` , and  ``:``  characters are the only
punctuation marks recognized in valid date strings by Lasso when used in
the formats shown below.

::

    1/25/2002
    1/25/2002 12:34
    1/25/2002 12:34:56
    1/25/2002 12:34:56 GMT

    2002-01-25
    2002-01-25 12:34:56
    2002-01-25 12:34:56 GMT

Lasso also recognizes a number of special purpose date formats which are
shown below. These are useful when working with HTTP headers or email
message headers.

::

    20020125123456
    20020125T12:34:56
    Tue, Dec 17 2002 12:34:56 -0800
    Tue Dec 17 12:34:56 PST 2002

The date formats which contain time zone information (e.g. ``-0800`` or
``PST``) will be recognized as GMT dates. The time zone will be used to
automatically adjust the date/time to the equivalent GMT date/time.

If using a date format not listed above, custom date formats can be
defined as date data types using the ``[Date]`` tag with the ``-Format``
parameter.

The following variations of the automatically recognized date formats
are valid without using the -Format parameter.

-  If the ``[Date]`` tag is used without a parameter then the current
   date and time are returned. Milliseconds are rounded to the nearest
   second.
-  If the time is not specified then it is assumed to be ``00:00:00``,
   midnight on the specified date.

::

   mm/dd/yyyy -> mm/dd/yyyy 00:00:00
   
-  If the seconds are not specified then the time is assumed to be even
   on the minute.

::

   mm/dd/yyyy hh:mm -> mm/dd/yyyy hh:mm:00

-  An optional GMT designator can be used to specify Greenwich Mean Time
   rather than local time.

::

   mm/dd/yyyy hh:mm:ss GMT

-  Two digit years are assumed to be in the 21\ :sup:`st` century if
   they are less than ``40`` or in the 20\ :sup:`th` century if they are
   greater than or equal to ``40``. Two digit years range from ``1940``
   to ``2039``. For best results, always use four digit years.

::

      mm/dd/00 -> mm/dd/2000
       mm/dd/39 -> mm/dd/2039
       mm/dd/40 -> mm/dd/1940
       mm/dd/99 -> mm/dd/1999

-  Days and months can be specified with or without leading ``0``\ s. The
   following are all valid Lasso date strings.

::

      1/1/02
       1/1/2002
       1/1/2002
       1/1/2002
       1/1/2002
       01/01/02
       01/01/2002
       16:35 01/01/2002 16:35
       16:35:45 01/01/2002 16:35:45
       12:35:45 GMT 01/01/2002 12:35:45 GMT

**To cast a value as a date data type:**

If the value is in a recognized string format described previously,
simply use the ``[Date]`` tag.

::

    [Date: '05/22/2002'] -> 05/22/2002 00:00:00
    [Date: '05/22/2002 12:30:00'] -> 05/22/2002 12:30:00
    [Date: '2002-22-05'] -> 2002-22-05 00:00:00

If the value is not in a string format described previously, use the
``[Date]`` tag with the ``-Format`` parameter. For information on how to
use the ``-Format`` parameter, see the :ref:`Formatting Dates` section
later in this chapter.

::

    [Date: '5.22.02 12:30', -Format='%m.%d.%y %H%M'] -> 5.22.02 12:30
    [Date: '20020522123000', -Format='%Y%m%d%H%M'] -> 200205221230

Date values which are stored in database fields or variables can be cast
to the date data type using the date tag. The format of the date stored
in the field or variable should be in one of the format described above
or the ``-Format`` parameter must be used to explicitly specify the
format.

::

    [Date: (Variable: 'myDate')]
    [Date: (Field: 'Modified_Date')]
    [Date: (Action_Param: 'Birth_Date')]

Date Tags
---------

Lasso contains date substitution tags that can be used to cast date
strings as date data types, format date data types, and perform
date/time conversions.

   
``[Date]``
   Used to cast values to date data types when used 
     with a valid date string as a parameter. An      
     optional ``-Format`` parameter with a date format
     string may be used to explicitly cast an unknown 
     date format. When no parameter is used, it       
     returns the current date and time. An optional   
     ``-DateGMT`` keyword/value parameter returns GMT 
     date and time. Also accepts parameters for       
     ``-Second``, ``-Minute``, ``-Hour``, ``-Day``,   
     ``-Month``, ``-Year``, and ``-DateGMT`` for      
     constructing and outputting dates.               
  
  ``[Date_Format]``
   Changes the output format of a Lasso             
     date. Requires a Lasso date data type or valid   
     Lasso date string as a parameter (auto-recognizes
     the same formats as the ``[Date]`` tag). The     
     ``-Format`` keyword/value parameter defines how  
     the date should be reformatted. See the          
     :ref:`Formatting Dates` section below for more   
  ``|information.``

  ``[Date_SetFormat]``
   Sets a date format for output using the          
     ``[Date]`` tag for an entire Lasso page. The     
     ``-Format`` parameter uses a format string. An   
     optional ``-TimeOptional`` parameter causes the  
     output to not return ``00:00:00`` if there is no 
     time value.                                      

  ``[Date_GMTToLocal]``
   Converts a date/time from Greenwich Mean Time to 
     local time of the machine running Lasso Service. 

  ``[Date_LocalToGMT]``
   Converts a date/time from local time to Greenwich
     Mean Time.                                       
  
  ``[Date_GetLocalTimeZone]``
   Returns the current time zone of the machine     
     running Lasso Service as a standard GMT offset   
     string (e.g. ``-0700``). Optional ``-Long``      
     parameter shows the name of the time zone (e.g.  
     PDT).

  ``[Date_Minimum]``
   Returns the minimum possible date recognized by a
     Date data type in Lasso.                         
  
  ``[Date_Maximum]``
   Returns the maximum possible date recognized as a
     Date data type in Lasso.                         
  
  ``[Date_Msec]``
   Returns an integer representing the number of    
     milliseconds recorded on the machine's internal  
     clock. Can be used for precise timing of code execution.

**To display date values:**

-  The current date/time can be displayed with ``[Date]``. The example
   below assumes a current date of ``5/22/2002 14:02:05``.

::

   [Date] -> 5/22/2002 14:02:05

-  The ``[Date]`` tag can be used to assemble a date from individual
   parameters. The following tag assembles a valid Lasso date string by
   specifying each part of the date separately. Since the time is not
   specified it is assumed to be midnight on the specified day.

::

   [Date: -Year=2002, -Month=5, -Day=22] -> 5/22/2002 00:00:00

**To convert date values to and from GMT:**

Any date data type can instantly be converted to and from Greenwich Mean
Time using the ``[Date_GMTToLocal]`` and ``[Date_LocalToGMT]`` tags.
These tags will only convert the current time zone of the machine
running Lasso Service. The following example uses Pacific Time (PDT) as
the current time zone.

::

    [Date_GMTToLocal: (Date: '5/22/2002 14:02:05')] -> 5/22/2002 09:02:05
    [Date_LocalToGMT: (Date: '5/22/2002 14:02:05')] -> 5/22/2002 07:02:05

**To show the current time zone for the server running Lasso Service:**

The ``[Date_GetLocalTimeZone]`` tag displays the current time zone of
the machine running Lasso Service. The following example uses Pacific
Time (PDT) as the current time zone.

::

    [Date_GetLocalTimeZone] -> 0700
    [Date_GetLocalTimeZone: -Long] -> PDT

**To time a section of Lasso code:**

Call the ``[Date_Msec]`` tag to get a clock value before and after the
code has executed. The different in times represents the number of
milliseconds which have elapsed. Note that the ``[Date_Msec]`` value may
occasionally roll back around to zero so any negative times reported by
this code should be disregarded.

::

   <?LassoScript
      Var: 'start' = Date_Msec;
        The code to time
      'The code took ' + (Date_Msec - $start) + ' milliseconds to process.';
   ?>

Formatting Dates
----------------

The ``[Date]`` tag and the ``[Date_Format]`` tag each have a ``-Format``
parameter which accepts a string of symbols that define the format of
the date which should be parsed in the case of the ``[Date]`` tag or
formatted in the case of the ``[Date_Format]`` tag. The symbols which
can be used in the ``-Format`` parameter are detailed in the following
table.

  ``%d``
   U.S. Date Format (Mm/Dd/yyyy).                          
  
  ``%Q``
   MySQL date format (yyyy-mm-dd).                         
  
  ``%q``
   MySQL timestamp format (yyyymmddhhmmss)                 
  
  ``%r``
   12-hour time format (hh:mm:ss [AM/PM]).                 
  
  ``%T``
   24-hour time format (hh:mm:ss).                         
  
  ``%Y``
   4-digit year.                                           
  
  ``%y``
   2-digit year.                                           
  
  ``%m``
   Month number (01=January, 12=December).                 
  
  ``%B``
   Full English month name (e.g. "January").               
  
  ``%b``
   Abbreviated English month name (e.g. "Jan").            
  
  ``%d``
   Day of month (01-31).                                   
  
  ``%w``
   Day of week (01=Sunday, 07=Saturday).                   
  
  ``%W``
   Week of year.                                           
  
  ``%A``
   Full English weekday name (e.g. "Wednesday").           
  
  ``%a``
   Abbreviated English weekday name (e.g. "Wed").          
  
  ``%H``
   24-hour time hour (0-23).                               
  
  ``%h``
   12-hour time hour (1-12).                               
  
  ``%M``
   Minute (0-59).                                          
  
  ``%S``
   Second (0-59).                                          
  
  ``%p``
   AM/PM for 12-hour time.                                 
  
  ``%G``
   GMT time zone indicator.                                
  
  ``%z``
   Time zone offset in relation to GMT (e.g. +0100, -0800).
  
  ``%Z``
   Time zone designator (e.g. PST, GMT-1, GMT+12)          
  

Each of the date format symbols that returns a number automatically pads
that number with ``0`` so all values returned by the tag are the same
length.

-  An optional underscore ``_`` between the percent sign ``%`` and the
   letter designating the symbol specifies that a space should be used
   instead of ``0`` for the padding character (e.g. ``%_m`` returns the
   month number with space padding).
-  An optional hyphen ``-`` between the percent sign ``%`` and the
   letter designating the symbol specifies that no padding should be
   performed (e.g. ``%-m`` returns the month number with no padding).
-  A literal percent sign can be inserted using ``%%``.

.. Note:: If the ``%z`` or ``%Z`` symbols are used when parsing a
   date, the resulting Lasso date object will represent the
   equivalent GMT date/time.

**To convert Lasso date data types to various formats:**

The following examples show how to convert either Lasso date data types
or valid Lasso date strings to alternate formats.

::

    [Date_Format: '06/14/2001', -Format='%A, %B %d'] -> Thursday, June 14
    [Date_Format: '06/14/2001', -Format='%a, %b %d'] -> Thu, Jun 14
    [Date_Format: '2001-06-14', -Format='%Y%m%d%H%M'] -> 200106140000
    [Date_Format: (Date:'1/4/2002'), -Format='%m.%d.%y'] -> 01.04.02
    [Date_Format: (Date:'1/4/2002 02:30:00'), -Format='%B, %Y '] -> January, 2002
    [Date_Format: (Date:'1/4/2002 02:30:00'), -Format='%r'] -> 2:30 AM

**To import and export dates from MySQL:**

A common conversion in Lasso is converting MySQL dates to and from U.S.
dates. Dates are stored in MySQL in the following format ``yyyy-mm-dd``.
The following example shows how to import a date in this format to a
U.S. date format using the ``[Date_Format]`` tag with an appropriate
``-Format`` parameter.

::

    [Date_Format: '2001-05-22', -Format='%D'] -> 5/22/2001
    [Date_Format: '5/22/2001', -Format='%Q'] -> 2001-05-22
    [Date_Format: (Date:'2001-05-22'), -Format='%D'] -> 5/22/2001
    [Date_Format: (Date:'5/22/2001'), -Format='%Q'] -> 2001-05-22

**To set a custom Lasso date format for a file:**

Use the ``[Date_SetFormat]`` tag. This allows all date data types on a
page to be output in a custom format without the use of the
``[Date_Format]`` tag. The format specified is only valid for Lasso code
contained in the same file below the ``[Date_SetFormat]`` tag.

::

    [Date_SetFormat: -Format='%m%d%y']

The example above allows the following Lasso date to be output in a
custom format without the ``[Date_Format]`` tag.

::

    [Date:'01/01/2002'] -> 010102

Date Format Member Tags
-----------------------

In addition to ``[Date_Format]`` and ``[Date_SetFormat]``, Lasso 8 also
offers the ``[Date->Format]`` member tags for performing format
conversions on date data types.

  ``[Date->Format]``
   Changes the output format of a Lasso date data   
     type. May only be used with Lasso date data      
     types. Requires a date format string as a parameter.

  ``[Date->SetFormat]``
   Sets a date output format for a particular Lasso 
     date data type object. Requires a date format    
     string as a parameter. An optional               
     ``-TimeOptional`` parameter causes the output to 
     not return ``00:00:00`` if there is no time value.

  ``[Date->Set]``
   Sets one or more elements of the date to a new   
     value. Accepts the same parameters as the        
     ``[Date]`` tag including ``-Year``, ``-Month``,  
     ``-Day``, ``-Hour``, ``-Minute``, and ``-Second.``

**To convert Lasso date data types to various formats:**

The following examples show how to convert Lasso date data types to
alternate formats using the ``[Date->Format]`` tag.

::

    [Var:'MyDate'=(Date:'2002-06-14 00:00:00')]
    [$MyDate->Format: '%A, %B %d'] -> Tuesday, June 14, 2002

::

    [Var:'MyDate'=(Date:'06/14/2002 09:00:00')]
    [$MyDate->Format: '%Y%m%d%H%M'] -> 200206140900

::

    [Var:'MyDate'=(Date:'01/31/2002')]
    [$MyDate->Format: '%d.%m.%y'] -> 31.01.02

::

    [Var:'MyDate'=(Date:'09/01/2002')]
    [$MyDate->Format: '%B, %Y '] -> September, 2002

**To set an output format for a specific date data type:**

Use the ``[Date->SetFormat]`` tag. This causes all instances of a
particular date data type object to be output in a specified format.

::

    [Var:'MyDate'=(Date:'01/01/2002')]
    [$MyDate->(SetFormat: '%m%d%y')]

The example above causes all instances of ``[Var:'MyDate']`` in the
current Lasso page to be output in a custom format without the
``[Date_Format]`` or ``[Date->Format]`` tag.

::

    [Var:'MyDate'] -> 010102

Date Accessors
--------------

A date accessor function returns a specific integer or string value from
a date data type, such as the name of the current month or the seconds
of the current time. All date accessor tags in Lasso 8 are defined in
:ref:`Table 4: Date Accessor Tags <date-and-time-operations-table-4>`.


  ``[Date->Year]``
   Returns a four-digit integer representing the 
     year for a specified date. An optional        
     ``-Days`` parameter returns the number of days
     in the current year (e.g. 365).               
  
  ``[Date->Month]``
   Returns the number of the month (1=January,   
     12=December) for a specified date (defaults to
     current date). Optional ``-Long`` returns the 
     full English month name (e.g. "January") or   
     ``-Short`` returns an abbreviated English     
     month name (e.g. "Jan"). An optional ``-Days``
     parameter returns the number of days in the   
     current month (e.g. 31).                      
  
  ``[Date->Day]``
   Returns the integer day of the month          
     (e.g. 15).                                    
  
  ``[Date->DayofYear]``
   Returns integer day of year (out of 365). Will
     work with leap years as well (out of 366).    
  
  ``[Date->DayofWeek]``
   Returns the number of the day of the week     
     (1=Sunday, 7=Saturday) for a specified        
     date. Optional ``-Short`` returns an          
     abbreviated English day name (e.g. "Sun") and 
     ``-Long`` returns the full English day name   
     (e.g. "Sunday").                              
  
  ``[Date->Week]``
   Returns the integer week number for the year  
     of the specified date (out of 52). The        
     ``-Sunday`` parameter returns the integer week
     of year starting from Sunday (default). A     
     ``-Monday`` parameter returns integer week of 
     year starting from Monday.                    
  
  ``[Date->Hour]``
   Returns the hour for a specified date/time. An
     optional ``-Short`` parameter returns integer 
     hour from ``1`` to ``12`` instead of ``1`` to ``24``.

  ``[Date->Minute]``
   Returns integer minutes from ``0`` to ``59``  
     for a specified date/time.                    
  
  ``[Date->Second]``
   Returns integer seconds from ``0`` to ``59``  
     for the specified date/time.                  
  
  ``[Date->Millisecond]``
   Returns the current integer milliseconds of   
     the current date/time only.                   
  
  ``[Date->Time]``
   Returns the time of a specified date/time.    
  
  ``[Date->GMT]``
   Returns whether the specified date is in local
     or GMT time Returns ``True`` for GMT time and 
     ``False`` for local time.                     
  
  ``[Date->DST]``
   Returns whether the specified date is in      
     daylight saving time or not. Returns ``1`` for
     daylight saving time, ``0`` for standard time,
     and ``-1`` for indeterminate.                 

**To use date accessors:**

-  The individual parts of the current date/time can be displayed using
   the ``[Date-> ]`` tags.

::

   [(Date:'5/22/2002 14:02:05')->Year] -> 2002
   [(Date:'5/22/2002 14:02:05')->Month] -> 5
   [(Date:'2/22/2002 14:02:05')->(Month: -Long)] -> February
   [(Date:'5/22/2002 14:02:05')->Day] -> 22
   [(Date:'5/22/2002 14:02:05')->(DayOfWeek: -Short)] -> Wed
   [(Date:'5/22/2002 14:02:05')->Time] -> 14:02:05
   [(Date:'5/22/2002 14:02:05')->Hour] -> 14
   [(Date:'5/22/2002 14:02:05')->Minute] -> 02
   [(Date:'5/22/2002 14:02:05')->Second] -> 05

-  The ``[Date->Millisecond]`` tag can only return the current number of
   millisecond value (as related to the clock time) for the machine
   running Lasso Service.

::

   [Date->Millisecond] -> 957

Duration Tags
=============

A duration is a special data type that represents a length of time. A
duration is not a 24-hour clock time, and may represent any number of
hours, minutes, or seconds.

Similar to dates, durations must be cast as duration data types before
they can be manipulated. This is done using the ``[Duration]`` tag.
Durations may be cast in an ``hours:minutes:seconds`` format, or just as
seconds.

::

    [Duration:'1:00:00'] -> 1:00:00
    [Duration:'3600'] -> 1:00:00

Once a value has been cast as a duration data type, duration
calculations and accessors may then be used. Durations are especially
useful for calculating lengths of time under 24 hours, although they can
be utilized for any lengths of time. Durations are independent of
calendar months and years, and durations that equal a length of time
longer that one month are only estimates based on the average length of
years and months (i.e. ``365.2425`` days per years, ``30.4375`` days per
month). Duration tags in Lasso 8 are summarized in :ref:`Table 5:
Duration Tags <date-and-time-operations-table-5>`.

  ``[Duration]``
   Casts values as a duration data type. Accepts a  
     duration string for hours: minutes:seconds, or an
     integer number of seconds. An optional ``-Week`` 
     parameter automatically adds a specified number  
     of weeks to the duration. Optional ``-Day``,     
     ``-Hour``, ``-Minute``, and ``-Second``          
     parameters may also be used for automatically    
     adding day, hour, minute, and second time        
     increments to the duration.                      
  
  ``[Duration->Year]``
   Returns the integer number of years in a duration
     (based on an average of 365.25 days per year).   
  
  ``[Duration->Month]``
   Returns the integer number of months in a        
     duration (based on an average of 30.4375 days per month).

  ``[Duration->Week]``
   Returns the integer number of weeks in the duration.

  ``[Duration->Day]``
   Returns the integer number of days in the duration.

  ``[Duration->Hour]``
   Returns the integer number of hours in the duration.

  ``[Duration->Minute]``
   Returns the integer number of minutes in the duration.

  ``[Duration->Second]``
   Returns the integer number of seconds in the duration.

**To cast and display durations:**

-  Durations can be created using the ``[Duration]`` tag with the
   ``-Week``, ``-Day``, ``-Hour``, ``-Minute``, and ``-Second``
   parameters. This always returns durations in ``hours:minutes:seconds``
   format.

::
       [Duration: -Week=5, -Day=3, -Hour=12] -> 924:00:00
       [Duration: -Day=4, -Hour=2, -Minute=30] -> 98:30:00
       [Duration: -Hour=12, -Minute=45, -Second=50] -> 12:45:50
       [Duration: -Hour=3, -Minute=30] -> 03:30:00
       [Duration: -Minute=15, -Second=30] -> 00:15:30
       [Duration: -Second=30] -> 00:00:30

-  The ``-Week``, ``-Day``, ``-Hour``, ``-Minute``, and ``-Second``
   parameters of the ``[Duration]`` tag may also be combined with a base
   duration for ease of use when setting a duration value. This always
   returns durations in ``hours:minutes:seconds`` format.

::

       [Duration:'5:30:30', -Week=5, -Day=3, -Hour=12] -> 929:30:30
       [Duration:'1:00:00', -Day=4, -Hour=2, -Minute=30] -> 99:30:00
       [Duration:'3600', -Hour=12, -Minute=45, -Second=50] -> 13:45:50

-  Specific increments of time can be returned from a duration using the
   ``[Duration-> ]`` tags.

::

       [(Duration:'8766:30:45')->Year] -> 1
       [(Duration:'8766:30:45')->Month] -> 12
       [(Duration:'8766:30:45')->Week] -> 52
       [(Duration:'8766:30:45')->Day] -> 365
       [(Duration:'8766:30:45')->Hour] -> 8767
       [(Duration:'8766:30:45')->Minute] -> 525991
       [(Duration:'8766:30:45')->Second] -> 31559445

Date and Duration Math
======================

Date calculations in Lasso can be performed by using special date math
tags, durations tags, and math symbols in Lasso 8. Date calculations
that can be performed include adding or subtracting year, month, week,
day, and time increments to and from dates, and calculating time
durations. Durations are a new data type that represent a length of time
in seconds and are introduced in the preceding :ref:`Duration Tags`
section.

.. Note:: **Daylight Saving Time**   Lasso does not account for changes
   to and from daylight saving time when performing date math and
   duration calculations. One should take this into consideration when
   performing a date or duration calculation across dates that encompass
   a change to or from daylight saving time (resulting date may be off
   by one hour).

Date Math Tags
--------------

Lasso 8 provides two date math substitution tags for performing date
calculations. These tags are generally used for adding increments of
time to a date, and output a Lasso date in the format specified. These
tags are summarized in :ref:`Table 6: Date Math Tags
<date-and-time-operations-table-6>`.

  ``[Date_Add]``
   Adds a specified amount of time to a Lasso date  
     data type or valid Lasso date string. First      
     parameter is a Lasso date. Keyword/value         
     parameters define what should be added to the    
     first parameter: ``-Millisecond``, ``-Second``,  
     ``-Minute``, ``-Hour``, ``-Day``, ``-Week``,     
     ``-Month``, or ``-Year``.                        
  
  ``[Date_Subtract]``
   Subtracts a specified amount of time from a Lasso
     date data type or valid Lasso date string. First 
     parameter is a Lasso date. Keyword/value         
     parameters define what should be subtracted from 
     the first parameter: ``-Millisecond``,           
     ``-Second``, ``-Minute``, ``-Hour``, ``-Day``,   
     ``-Week``, ``-Month``, or ``-Year``.             
  
  ``[Date_Difference]``
   Returns the time difference between two specified
     dates. A duration is the default return          
     value. Optional parameters may be used to output 
     a specific integer time value instead of a       
     duration: ``-Millisecond``, ``-Second``,         
     ``-Minute``, ``-Hour``, ``-Day``, ``-Week``,     
     ``-Month``, or ``-Year``. Lasso rounds to the    
     nearest integer when using these optional parameters.

**To add time to a date:**

A specified number of hours, minutes, seconds, days, or weeks can be
added to a date data type or valid date string using the ``[Date_Add]``
tag. The following examples show the result of adding different values
to the current date ``5/22/2002 14:02:05``.

::

    [Date_Add: (Date), -Second=15] -> 5/22/2002 14:02:20
    [Date_Add: (Date), -Minute=15] -> 5/22/2002 14:17:05
    [Date_Add: (Date), -Hour=15] -> 5/23/2002 05:02:05
    [Date_Add: (Date), -Day=15] -> 6/6/2002 14:02:05
    [Date_Add: (Date), -Week=15] -> 9/4/2002 14:02:05
    [Date_Add: (Date), -Month=6] -> 11/22/2002 14:02:05
    [Date_Add: (Date), -Year=1] -> 5/22/2003 14:02:05

**To subtract time from a date:**

A specified number of hours, minutes, seconds, days, or weeks can be
subtracted from a date data type or valid date string using the
``[Date_Subtract]`` tag. The following examples show the result of
subtracting different values from the date ``5/22/2001 14:02:05``.

::

    [Date_Subtract: (Date: '5/22/2001 14:02:05'), -Second=15] -> 5/22/2001 14:01:50
    [Date_Subtract: (Date:'5/22/2001 14:02:05'), -Minute=15] -> 5/22/2001 13:47:05
    [Date_Subtract: (Date:'5/22/2001 14:02:05'), -Hour=15] -> 5/21/2001 23:02:05
    [Date_Subtract: '5/22/2001 14:02:05', -Day=15] -> 5/7/2001 14:02:05
    [Date_Subtract: '5/22/2001 14:02:05', -Week=15] -> 2/6/2001 14:02:05

**To determine the time difference between two dates:**

Use the ``[Date_Difference]`` tag. The following examples show how to
calculate the time difference between two date data types or valid date
strings.

::

    [Date_Difference: (Date: '5/23/2002'), (Date:'5/22/2002')] -> 24:00:00
    [Date_Difference: (Date:'5/23/2002'), (Date:'5/22/2002'), -Second] -> 86400
    [Date_Difference: (Date:'5/23/2002'), '5/22/2002', -Minute] -> 3600
    [Date_Difference: (Date: '5/23/2002'), '5/22/2002', -Hour] -> 24
    [Date_Difference: '5/23/2002', (Date:'5/22/2002'), -Day] -> 1
    [Date_Difference: '5/23/2002', (Date:'5/30/2002'), -Week] -> 1
    [Date_Difference: '5/23/2002', '6/23/2002', -Month] -> 1
    [Date_Difference: '5/23/2002', '5/23/2001', -Year] -> 1

Date and Duration Math Tags
---------------------------

Lasso 8 provides three member tags that perform date math operations
requiring both date and duration data types. These tags are used for
adding durations to dates, subtracting a duration from a date, and
determining a duration between two dates. These tags are summarized in
:ref:`Table 7: Date and Duration Math Tags
:<date-and-time-operations-table-7>`.

  ``[Date->Add]``
   Adds a duration to a Lasso date data            
     type. Optional keyword/value parameters may be  
     used in place of a duration to define what      
     should be added to the first parameter:         
     ``-Millisecond``, ``-Second``, ``-Minute``,     
     ``-Hour``, ``-Day``, or ``-Week``.              
  
  ``[Date->Subtract]``
   Subtracts a duration from a Lasso date data     
     type. Optional keyword/value parameters may be  
     used in place of a duration to define what      
     should be subtracted from the first parameter:  
     ``-Millisecond``, ``-Second``, ``-Minute``,     
     ``-Hour``, ``-Day``, or ``-Week``.              
  
  ``[Date->Difference]``
   Calculates the duration between two date data   
     types. The second parameter is subtracted from  
     the first parameter to determine a              
     duration. Optional parameters may be used to    
     output a specified integer time value instead of
     a duration: ``-Millisecond``, ``-Second``,      
     ``-Minute``, ``-Hour``, ``-Day``, ``-Week``,    
     ``-Month``, or ``-Year``. Lasso rounds to the   
     nearest integer when using these optional parameters.

.. Note:: The ``[Date->Add]`` and ``[Date->Subtract]`` tags do not
   directly output values, but can be used to change the values of
   variables that contain date or duration data types.

**To add a duration to a date:**

Use the ``[Date->Add]`` tag. The following examples show how to add a
duration to a date and return a date.

::

    [Var_Set:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Add:(Duration:'24:00:00'))]
    [$MyDate] -> 5/23/2002 00:00:00

::

    [Var_Set:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Add:(Duration:'3600'))]
    [$MyDate] -> 5/22/2002 12:30:00

::

    [Var_Set:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Add: -Week=1)]
    [$MyDate] -> 5/29/2002 00:00:00

**To subtract a duration from a date:**

Use the ``[Date->Subtract]`` tag. The following examples show how to
subtract a duration from a date and return a date.

::

    [Var_Set:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Subtract:(Duration:'24:00:00'))]
    [$MyDate] -> 5/21/2002

::

    [Var:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Subtract:(Duration:'7200'))]
    [$MyDate] -> 5/22/2002 9:30:00

::

    [Var:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Subtract: -Day=3)]
    [$MyDate] -> 5/19/2002 00:00:00

**To determine the duration between two dates:**

Use the ``[Date->Difference]`` tag. The following examples show how to
calculate the time difference between two dates and return a duration.

::

    [Var_Set:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Difference:(Date:'5/15/2002 01:30:00'))] -> 169:30:00

::

    [Var:'MyDate'=(Date: '5/22/2002')]
    [$MyDate->(Difference:(Date:'5/15/2002'), -Day)] -> 7

Using Math Symbols
------------------

In Lasso 8, one has the ability to perform date and duration
calculations using math symbols (similar to integer data types). If a
date or duration appears to the left of a math symbol then the
appropriate math operation will be performed and the result will be a
date or duration as appropriate. All math symbols that can be used with
dates or durations are shown in :ref:`Table 8: Date Math Symbols
<date-and-time-operations-table-8>`.

  ``+``
   Used for adding a date and a duration, or adding two durations.  
  
  ``-``
   Used for subtracting a duration from a date, subtracting a       
     duration from a duration, or determining the duration between two dates.

  ``*``
   Used for multiplying durations by an integer value.              
  
  ``/``
   Used for dividing durations by an integer or duration value.     
  

**To add or subtract dates and durations:**

The following examples show addition and subtraction operations using
dates and durations.

::

    [(Date: '5/22/2002') + (Duration:'24:00:00')] -> 5/23/2002
    [(Date: '5/22/2002') - (Duration:'48:00:00')] -> 5/20/2002

**To determine the duration between two dates:**

The following calculates the duration between two dates using the minus
symbol (``-``).

::

    [(Date: '5/22/2002') - (Date:'5/15/2002')] -> 168:00:00

**To add one day to the current date:**

The following example adds one day to the current date.

::

    [(Date) + (Duration: -Day=1)]

**To multiply or divide a duration by an integer:**

The following examples show multiplication and division operations using
durations and integers.

::

    [(Duration: -Minute=10) * 12] -> 02:00:00
    [(Duration: '60') * 10] -> 00:10:00
    [(Duration: -Hour=1) / 2] -> 00:30:00
    [(Duration: '00:30:00') / 10] -> 00:03:00

**To divide a duration by a duration:**

The following examples show division of durations by durations. The
resulting value is a decimal data type.

::

    [(Duration: -Hour=24) / (Duration: -Hour=6)] -> 4.0
    [(Duration: '05:00:00') / (Duration: '00:30:00')] -> 10.0

**To return the duration between the current date and a day in the
future:**

The following example returns the duration between the current date and
12/31/2004.

::

    [(Date: '12/31/2004') - (Date)]
