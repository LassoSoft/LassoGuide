.. http://www.lassosoft.com/Language-Guide-FileMaker-Data-Sources
.. _filemaker-data-sources:

**********************
FileMaker Data Sources
**********************

Lasso Server allows access to FileMaker Server 7--12 Advanced and FileMaker
Server 9--12 through the Lasso Connector for FileMaker. Lasso provides several
methods and options that are unique to FileMaker Server connections including
``-layoutResponse`` and ``-noValueLists``.

While Lasso is a predominantly data source--independent platform, it does
include many FileMaker-specific options as documented in this chapter. However,
all of the common procedures outlined in the :ref:`database-interaction`,
:ref:`searching-displaying`, and :ref:`adding-updating` chapters can be used
with FileMaker data sources.

.. important::
   The methods and options defined in this chapter can only be used with
   FileMaker data sources. Any solution that relies on the methods in this
   chapter cannot be easily retargeted to work with a different data source.


Lasso and FileMaker
===================

Since Lasso works with many different data sources this documentation uses
data source--agnostic terms to refer to databases, tables, and fields. The
following terms that are used in the FileMaker documentation are equivalent to
their Lasso counterparts:

Database
   Database is used to refer to a single FileMaker database file. FileMaker
   databases differ from other databases in Lasso in that they contain layouts
   rather than individual data tables. Even in FileMaker Server 7--12, Lasso
   sees individual layouts rather than data tables. From a data storage point of
   view, a FileMaker database is equivalent to a single MySQL table.

Layout
   Within Lasso a FileMaker layout is treated as equivalent to a table. The two
   terms can be used interchangeably. This equivalence simplifies Lasso security
   and makes transitioning between data sources easier. All FileMaker layouts
   can be thought of as views of a single data table. Lasso can only access
   fields that are contained in the layout named within the current database
   action.

Record
   FileMaker records are referenced using a single ``-keyValue`` rather than a
   ``-keyField`` and ``-keyValue`` pair. The ``-keyField`` in FileMaker is
   always the Record ID that is set internally.

Field
   The value for any field in the current layout in FileMaker can be returned
   including the values for related fields, repeating fields, and fields in
   portals.


Performance Tips
----------------

This section contains a number of tips that will help get the best performance
from a FileMaker database. Since queries must be performed sequentially within
FileMaker Server, even small optimizations can yield significant increases in
the speed of web serving under heavy load.

-  **Dedicated FileMaker Server Machine** --
   For best performance, place the FileMaker Server on a different machine from
   Lasso Server and the web server.

-  **FileMaker Server** --
   If a FileMaker database must be accessed by a mix of FileMaker clients and
   web visitors through Lasso, it should be hosted on FileMaker Server. Lasso
   can access the database directly through FileMaker Server 7--12 Advanced and
   FileMaker Server 9--12.

-  **Index Fields** --
   Any fields that will be searched through Lasso should have indexing turned
   on. Avoid searching on non-stored calculation fields, related fields, and
   summary fields.

-  **Custom Layouts** --
   Layouts should be created with the minimal number of fields required for
   Lasso. All the data for the fields in the layout will be sent to Lasso with
   the query results. Limiting the number of fields can dramatically cut down
   the amount of data that needs to be sent from FileMaker Server to Lasso.

-  **Value Lists** --
   For FileMaker Server data sources use the ``-noValueLists`` parameter to
   suppress the automatic sending of value lists from FileMaker when those value
   lists are not going to be used on the response page.

-  **Layout Response** --
   For FileMaker Server data sources use the ``-layoutResponse`` parameter to
   specify what layout should be used to return results from FileMaker. A
   different layout from what was specified in the request can be used for the
   result. This is a replacement for the ``-returnField`` parameter, which is
   not supported for FileMaker data sources.

-  **Sorting** --
   Sorting can have a serious impact on performance if large numbers of records
   must be sorted. Avoid sorting large record sets and avoid sorting on
   calculation fields, related fields, unindexed fields, or summary fields.

-  **Contains Searching** --
   FileMaker is optimized for the default "Begins With" searches (and for
   numerical searches). Use of the contains operator (``-cn``) can dramatically
   slow down performance since FileMaker will not be able to use its indices to
   optimize searches.

-  **Max Records** --
   Using ``-maxRecords`` to limit the number of records returned in the result
   set from FileMaker Server can speed up performance. Use ``-maxRecords`` and
   ``-skipRecords`` methods to navigate a visitor through the found set.

-  **Calculation Fields** --
   Calculation fields should be avoided if possible. Searching or sorting on
   unindexed, uncached calculation fields can have a negative effect on
   FileMaker Server performance.

-  **FileMaker Scripts** --
   The use of FileMaker scripts should be avoided if possible. While FileMaker
   executes a script, no other database actions can be performed. FileMaker
   scripts can usually be rewritten as Lasso code to achieve the same effect,
   often with greater performance.

In addition to these tips, MySQL or PostgreSQL can be used to shift some of the
burden off of FileMaker Server. MySQL and PostgreSQL can usually perform
database searches much faster than FileMaker. Lasso also includes sessions and
collection types that can be used to perform some of the tasks of a database,
but with higher performance for small amounts of data.


Compatibility Tips
------------------

Following these tips will help to ensure that it is easy to transfer data from a
FileMaker database to another data source, such as a PostgreSQL database, at a
future date.

-  **Database Names** --
   Database, layout, and field names should contain only a mix of letters,
   numbers, and the underscore character.

-  **Calculation Fields** --
   Avoid the use of calculation fields. Instead, perform calculations within
   Lasso and store the results back into regular fields if they will be needed
   later.

-  **Summary Fields** --
   Avoid the use of summary fields. Instead, summarize data using `inline`
   searches within Lasso.

-  **Scripts** --
   Avoid the use of FileMaker scripts. Most actions performed with scripts can
   be performed using the database actions available within Lasso.

-  **Record ID** --
   Create a calculation field with the calculation ``Status(CurrentRecordID)``
   and name it "id". Always use the ``-keyField='id'`` within `inline` database
   actions. This ensures that when moving to a database that relies on storing
   the key field value explicitly, a unique key field value is available.


FileMaker Queries
=================

The queries generated by inlines for FileMaker data sources differ from the
queries generated for other data sources in several significant ways. This
section includes a description of how search operators, logical operators, and
other keyword parameters are used to construct queries for each of the FileMaker
data sources.


Search Operators
----------------

By default FileMaker performs a "begins with" search for each field in a query.
In FileMaker Server each field can only be specified one time within each search
query. See the information below on FileMaker search symbols for strategies to
perform complex queries in FileMaker Server.

Lasso also provides the following operators that allow different queries to be
performed. Each operator should be specified immediately before the field and
its search value are specified. Note that this list of operators is somewhat
different from those supported by other data source connectors including older
FileMaker data source connectors.

.. tabularcolumns:: lL

.. _filemaker-search-operators:

.. table:: FileMaker Search Field Operators

   ========================= ===================================================
   Operator                  Description
   ========================= ===================================================
   ``-op='bw'`` or ``-bw``   Begins With. Matches records where any word in the
                             field begins with the specified substring. This is
                             the default if no other operator is specified.
   ``-op='cn'`` or ``-cn``   Contains. Matches records where any word in the
                             field contains the substring.
   ``-op='eq'`` or ``-eq``   Equals. Matches records where any word in the field
                             exactly matches the string.
   ``-op='ew'`` or ``-ew``   Ends With. Matches records where any word in the
                             field ends with the specified substring.
   ``-op='gt'`` or ``-gt``   Greater Than. Matches records where the field value
                             is greater than the parameter.
   ``-op='gte'`` or ``-gte`` Greater Than or Equals.
   ``-op='lt'`` or ``-lt``   Less Than. Matches records where the field value is
                             less than the parameter.
   ``-op='lte'`` or ``-lte`` Less Than or Equals.
   ``-op='rx'`` or ``-rx``   Use a FileMaker search expression. See the table
                             below for a list of symbols.
   ========================= ===================================================

Note that there is no ``-neq`` operator or other negated operators. It is
necessary to use a ``-not`` query to omit records from the found set instead, as
explained further below. For example, to find records where the field
"first_name" is not "Joe" the following search terms must be used: ``-not,
-op='eq', 'first_name'='Joe'``

The ``-rx`` operator can be used to pass a raw FileMaker search expression as a
query. This allows the use of any of the FileMaker search symbols. See the
`FileMaker documentation`_ for a full explanation of how these symbols work.

.. tabularcolumns:: lL

.. _filemaker-search-symbols:

.. table:: FileMaker Search Symbols

   ============== ==============================================================
   Symbol         Description
   ============== ==============================================================
   ``@``          Matches one character.
   ``*``          Matches zero or more characters. A single ``*`` matches
                  non-empty fields.
   ``..``         Matches a range of values such as "1..10" or "A..Z". Can be
                  written as two or three periods.
   ``#``          Matches one number.
   ``" "``        Quotes surround a substring that should be matched literally.
   ``=``          Matches a whole word. "=John" will match "John", but not
                  "Johnny". A single ``=`` matches empty fields.
   ``==``         Matches a whole field value rather than per-word. Should be
                  specified at the start of the search term.
   ``<``          Matches values less than a specified value.
   ``<=``         Matches values less than or equal to a specified value.
   ``>``          Matches values greater than a specified value.
   ``>=``         Matches values greater than or equal to a specified value.
   ``//``         Matches today's date.
   ``?``          Matches a record with invalid date data in the field.
   ``!``          Matches records that have a duplicate value. Both records will
                  be returned.
   ============== ==============================================================

The range symbol (``..``) is most useful for performing searches within a date
range. For example a date in 2006 can be found by searching for ``-rx,
'date_field'='1/1/2006..12/31/2006'``.


Logical Operators
-----------------

FileMaker data sources default to performing an AND search. The records that are
returned from the data source must match all of the specified criteria. It is
also possible to specify ``-opLogical`` to switch to an OR search where the
records that are returned from the data source may match any of the specified
criteria.

For example, the following criteria returns records where the "first_name" is
"John" and the "last_name" is "Doe": ``-eq, 'first_name'='John', -eq,
'last_name'='Doe'``

The following criteria instead returns records where the "first_name" is "John"
or the "last_name" is "Doe". This would return records for "John Doe" as well as
"Jane Doe" and "John Walker": ``-opLogical='Or', -eq, 'first_name'='John', -eq,
'last_name'='Doe'``


Complex Queries with FileMaker Server 9 and Later
-------------------------------------------------

Starting with FileMaker Server 9, a search request is made up of one or more
queries. By default a single query is generated and all of the search terms
within it are combined using an AND operator. Additional queries can be added to
either extend the found set using an OR operator or to omit records from the
found set using a NOT operator. These queries correspond precisely to find
requests within the FileMaker Server user interface.

Each field can only be listed once per query. The standard Lasso operators can
be used for most common search parameters like equals, begins with, ends with,
contains, less than, greater than, etc. FileMaker's standard find symbols can be
used for more complex criteria. It may also be necessary to use multiple queries
for more complex search criteria.

Search requests in FileMaker Server 9 and later do not support the "Not Equals"
operator or any of the NOT-variant operators. Instead, these should be created
by combining an omit query with the appropriate affirmative operator. The
``-opLogical``, ``-opBegin``, and ``-opEnd`` operators are not supported. The
``-or`` and ``-not`` operators must be used instead.

.. tabularcolumns:: lL

.. _filemaker-search-keywords:

.. table:: FileMaker Search Operator Parameters

   ========= ===================================================================
   Parameter Description
   ========= ===================================================================
   ``-or``   Starts a new query. Records that match the query will be added to
             the result set.
   ``-not``  Starts an omit query. Records that match the query will be omitted
             from the result set.
   ========= ===================================================================

A search with a single query uses an AND operator to combine each of the search
terms. Records where the field "first_name" begins with the letter "J" and the
field "last_name" begins with the letter "D" can be found using the following
search terms in Lasso. Each record in the result set will match every search
term in the query: ``-bw, 'first_name'='J', -bw, 'last_name='D'``

We start an additional query using an ``-or`` parameter. FileMaker runs the
first and second queries independently and then combines the search results. The
result of the following search terms will be to find every record where the
field "first_name" begins with the letter "J" and the field "last_name" begins
with either the letter "D" or the letter "S". Each record in the result set will
match either the first query or the second query. ::

   -bw, 'first_name'='J',
   -bw, 'last_name'='D',
   -or,
   -bw, 'first_name'='J',
   -bw, 'last_name'='S'

Note that each field name can only appear once per query, but the same field
name can be used in multiple queries. The "first_name" search term is repeated
in both queries so that all returned records will have a "first_name" starting
with "J". If the "first_name" search term was left out of the second query then
the result set would contain every record where the field "first_name" begins
with the "J" and the field "last_name" begins with the letter "D" and every
record where the field "last_name" begins with the letter "S".

The result set can be narrowed by adding an omit query using a ``-not``
parameter. FileMaker will run the first query and any ``-or`` queries first,
generating a complete result set. Then, the ``-not`` queries will be run and any
records that match those queries will be omitted from the found set. The result
of the following search terms will be to find every record where the field
"first_name" begins with the letter "J" and the field "last_name" begins with
the letter "D" except for the record for "John Doe". Each record in the result
set will match the first query and will not match the second query. ::

   -bw, 'first_name'='J',
   -bw, 'last_name'='D',
   -not,
   -bw, 'first_name'='John',
   -bw, 'last_name'='Doe'

It is possible to construct most searches positively using only a single query
or a few ``-or`` queries, but sometimes it is more logical to construct a large
result set and then use one or more ``-not`` queries to omit records from it.


Additional Commands for FileMaker Server 9 and Later
----------------------------------------------------

FileMaker Server 9 supports a number of additional unique commands that are
summarized in the following table. Most of these commands are passed through to
FileMaker Server without modification by Lasso. The :title-reference:`FileMaker
Server 9 Custom Web Publishing with XML and XSLT documentation` should be
consulted for full details about these commands.

.. tabularcolumns:: lL

.. _filemaker-additional-parameters:

.. table:: FileMaker Additional Parameters

   +----------------------------+----------------------------------------------+
   |Parameter                   |Description                                   |
   +============================+==============================================+
   |``-layoutResponse=?``       |Returns the result set using the layout       |
   |                            |specified in this parameter rather than the   |
   |                            |layout used to specify the database action.   |
   +----------------------------+----------------------------------------------+
   |``-noValueLists``           |Suppresses the fetching of value list data    |
   |                            |for FileMaker Server data sources.            |
   +----------------------------+----------------------------------------------+
   |``-relatedSets.filter=?``   |If set to "layout", FileMaker Server will     |
   |                            |return only the number of related records     |
   |                            |shown in portals on the current layout.       |
   |                            |Defaults to returning all records up to the   |
   |                            |number set by ``-relatedSets.max``.           |
   +----------------------------+----------------------------------------------+
   |``-relatedSets.max=?``      |Sets the number of related records returned.  |
   |                            |Can be set to a number or "All".              |
   +----------------------------+----------------------------------------------+
   |``-script=?`` and           |Runs a script after the find has been         |
   |``-script.param=?``         |processed and sorted. The optional parameter  |
   |                            |can be accessed from within the script.       |
   +----------------------------+----------------------------------------------+
   |``-script.preFind=?`` and   |Runs a script before the find is processed.   |
   |``-script.preFind.param=?`` |                                              |
   +----------------------------+----------------------------------------------+
   |``-script.preSort=?`` and   |Runs a script after the find has been         |
   |``-script.preSort.param=?`` |processed, but before the results are sorted. |
   +----------------------------+----------------------------------------------+


Primary Key Field and Record ID
===============================

FileMaker databases include a built-in primary key value called the Record ID.
This value is guaranteed to be unique for any record in a FileMaker database. It
is predominantly sequential, but should not be relied upon to be sequential. The
values of the Record IDs within a database may change after an import or after a
database is compressed using :menuselection:`Save a Copy As...`. Record IDs can
be used within a solution to refer to a record on multiple pages, but should not
be stored as permanent references to FileMaker records.


Return the Current Record ID
----------------------------

The Record ID for the current record can be returned using `keyField_value`. The
following example shows an `inline` method that performs a ``-findAll`` action
and returns the Record ID for each returned record using the `keyField_value`
method::

   inline(
      -findAll,
      -database='contacts',
      -table='people'
   ) => {^
      records => {^
         '<br />' + keyField_value + ': ' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // <br />126: John Doe
   // <br />127: Jane Doe
   // <br />4096: Jane Person


Reference a Record by Record ID
-------------------------------

For ``-update`` and ``-delete`` action parameters the Record ID for the record
being operated upon can be referenced using ``-keyValue``. The ``-keyField``
does not need to be defined or should be set to an empty string if it currently
is (``-keyField=''``). The following example shows a record in "contacts" being
updated with ``-keyValue=126``. The name of the person referenced by the record
is changed to "John Surname". ::

   inline(
      -update,
      -database='contacts',
      -table='people',
      -keyValue=126,
      'first_name'='John',
      'last_name'='Surname'
   ) => {^
      keyField_value + ': ' + field('first_name') + ' ' + field('last_name')
   ^}

   // => 126: John Surname

The following example shows a record in "contacts" being deleted with
``-keyValue=127``. The ``-keyField`` keyword parameter is included, but its
value is set to the empty string. ::

   inline(
      -delete,
      -database='contacts',
      -table='people',
      -keyField='',
      -keyValue=127
   ) => {}

.. tip::
   The calculation value ``Status(CurrentRecordID)`` can be used to access the
   Record ID for the current record.


Sorting Records
===============

In addition to the "ascending" and "descending" values for the ``-sortOrder``
keyword parameter, FileMaker data sources can also accept a custom value. In
FileMaker Server, the value for ``-sortOrder`` should name a value list. The
order of that value list will be used as the custom sorting order for records in
the result set. Note also that FileMaker Server only supports specifying up to
nine sort fields in a single database search.


Return Results in Custom Sort Order
-----------------------------------

Specify ``-sortField`` and ``-sortOrder`` keyword parameters within the search
inline. The records are first sorted by "title" in custom order, then by
"last_name" and "first_name" in ascending order. The "title" field will be
sorted in the order of the elements within the value list associated with the
field in the database. In this case, it will be sorted as "Mr., Mrs., Ms.". ::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id',
      -sortField='title',      -sortOrder='title',
      -sortField='last_name',  -sortOrder='ascending',
      -sortField='first_name', -sortOrder='ascending'
   ) => {^
      records => {^
         '<br />' + field('title') + ' ' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

The following results could be returned when this page is loaded. Each of the
records with a title of "Mr." appear before each of the records with a title of
"Mrs.". Within each title, the names are sorted in ascending alphabetical
order. ::

   // =>
   // <br />Mr. John Doe
   // <br />Mr. John Person
   // <br />Mrs. Jane Doe
   // <br />Mrs. Jane Person


Displaying Data
===============

FileMaker includes a number of methods that allow the different types of
FileMaker fields to be displayed. These methods are summarized below, and
examples are included in the sections that follow.

.. index:: field()

.. method:: field(...)
   :noindex:

   Can be used to reference FileMaker fields including related fields and
   repeating fields. Fields from the current table are named simply (e.g.
   ``field('first_name')``). Fields from a related record are named with the
   related database name, two colons, and the name of the field (e.g.
   ``field('Calls::Approved')``). Repeating fields include the repetition number
   in parentheses (e.g. ``field('Responses(3)')``).

.. method:: repeating(name::string)

   Executes a capture block once for each defined repetition of a repeating
   field. Requires a single parameter, the name of the repeating field from the
   current layout.

.. method:: repeating_valueItem()

   Returns the value for each repetition of a repeating field.

.. method:: portal(name::string)

   Executes a capture block once for each record in a portal. Requires a single
   parameter, the name of the portal relationship from the current layout.
   Fields from the portal can be found using the same method as for related
   records (e.g. ``field('Calls::Approved')`` within a portal showing records
   from the "Calls" database).

.. note::
   All fields that Lasso references must be contained in the current layout in
   FileMaker. For portals and repeating fields only the number of repetitions
   shown in the current layout will be available to Lasso.


Related Fields
--------------

Related fields are named using the relationship name followed by two colons and
the field name. For example, a related field "call_duration" from a "calls"
database might be referenced as ``calls::call_duration``. Any related fields
included in the layout specified for the current Lasso action can be referenced
using this syntax. Data can be retrieved from related fields or it can be set in
related fields when records are added or updated.


Return Data from a Related Field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Specify the name of the related field within a `field` method. The related field
must be contained in the current layout either individually or within a portal.
In a one-to-one relationship, the value from the single related record will be
returned. In a one-to-many relationship, the value from the first related record
as defined by the relationship options will be returned. See the section
:ref:`filemaker-portals` below for more control over one-to-many relationships.

The following example shows a ``-findAll`` action being performed in a database
"contacts". The related field "last_call_time" from the "calls" database is
returned for each record through a relationship named "calls". ::

   inline(
      -findAll,
      -database='contacts',
      -table='people'
   ) => {^
      records => {^
         '<br />' + keyField_value + ': ' + field('first_name') + ' ' + field('last_name') +
         '(Last call at: ' + field('calls::last_call_time') + ').\n'
      ^}
   ^}

   // =>
   // <br />126: John Doe (Last call at 12:00 pm).
   // <br />127: Jane Doe (Last call at 9:25 am).
   // <br />496: Jane Person (Last call at 4:46 pm).


Set Value for a Related Field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Specify the name of the related field, along with the related field's Record ID,
within the action that adds or updates a record. The related field must be
contained in the current layout either individually or within a portal.

In one-to-one or one-to-many relationships, the fully qualified field name must
be used along with the Record ID of the related field in the format
``table::field.id``, where "id" is the related field's Record ID. See the
section :ref:`filemaker-portals` below for more information.

The following example shows an ``-update`` action being performed in a database
"contacts". The related field "last_call_time", with a Record ID of "9", from
the "calls" database is updated for "Jane Person". The new value is returned. ::

   inline(
      -update,
      -database='contacts',
      -table='people',
      -keyField='',
      -keyValue='7',
      'Calls::last_call_time.9'='12:14:56'
   ) => {^
      field('calls::last_call_time')
   ^}

   // => 12:14:56

.. important::
   Every database that is referenced by a related field or a portal must have
   the same permissions defined. If a related database does not have the proper
   permissions then not only will FileMaker Server leave the related fields
   blank, but will deny the entire database request.


.. _filemaker-portals:

Portals
-------

A :dfn:`portal` allows one-to-many relationships to be displayed within
FileMaker databases. Portals allow data from many related records to be
retrieved and displayed in a single Lasso page. A portal must be present in the
current FileMaker layout in order for its values to be retrieved using Lasso.

Only the number of repetitions formatted to display within FileMaker will be
displayed using Lasso. A portal must contain a scroll bar in order for all
records from the portal to be displayed using Lasso.

Fields in portals are named using the same convention as related fields. The
relationship name is followed by two colons and the field name. For example, a
related field "call_duration" from a "calls" database might be referenced as
``calls::call_duration``.

.. tip::
   Everything that is possible to do with portals can also be performed using
   nested `inline` capture blocks to perform actions in the related database.
   Portals are unique to FileMaker databases.


Return Values from a Portal
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `portal` method with the name of the portal referenced. The `field`
method within the `portal` capture block should reference the fields from the
current portal row using the relationship field syntax.

The following example shows a portal "calls" that is contained in the "people"
layout of the "contacts" database. The "time", "duration", and "number" of each
call is displayed. ::

   inline(
      -findAll,
      -database='contact',
      -table='people'
   ) => {^
      records => {^
         '<p>Calls for ' + field('first_name') + ' ' + field('last_name') + ':\n'
         portal('calls') => {^
            '<br />' + field('calls::number') + ' at ' + field('calls::time') +
            'for ' + field('calls::duration') + ' minutes.\n'
         ^}
         '</p>\n'
      ^}
   ^}

   // =>
   // <p>Calls for John Doe:
   // <br />555-1212 at 12:00 pm for 15 minutes.
   // </p>
   // <p>Calls for Jane Doe:
   // <br />555-1212 at 09:25 am for 60 minutes.
   // </p>
   // <p>Calls for Jane Person:
   // <br />555-1212 at 2:23 pm for 55 minutes.
   // <br />555-1212 at 4:46 pm for 5 minutes.
   // </p>


Add a Record to a Portal
^^^^^^^^^^^^^^^^^^^^^^^^

A record can be added to a portal by adding the record directly to the related
database. In the following example the "calls" database is related to the
"contacts" database by means of a field "contact_id" that stores the ID for the
contact to which the calls were made. New records added to "calls" with the
appropriate "contact_id" will be shown through the portal to the next site
visitor.

In the following example a new call is added to the "calls" database for John
Doe. John Doe has an ID of "123" in the "people" table of the "contacts"
database. This is the value used for the "contact_id" field in "calls". ::

   inline(
      -add,
      -database='calls',
      -table='people',
      'contact_id'=123,
      'number'='555-1212',
      'time'='12:00 am',
      'duration'=55
   ) => {}


Value Lists
-----------

Value lists in FileMaker allow a set of possible values to be defined for a
field. The items in the value list associated with a field on the current layout
for a Lasso action can be retrieved using the `value_list` methods as shown in
the examples below. See the `FileMaker documentation`_ for more information on
how to create and use value lists.

In order to display values from a value list, the layout referenced in the
current database action must contain a field formatted to show the desired value
list as a drop-down menu, select list, checkboxes, or radio buttons. Lasso
cannot reference a value list directly, but can reference a value list through a
formatted field in the current layout.

.. index:: value_list(), value_listItem(), selected(), checked()

.. method:: value_list(colName::string)
   :noindex:

   Executes a capture block for each value in the named value list. Requires a
   single parameter: the name of a field from the current layout that has a
   value list assigned to it.

.. method:: value_listItem()
   :noindex:

   While in a `value_list` capture block, it returns the value for the current
   item.

.. method:: selected()
   :noindex:

   Displays the word "selected" if the current value list item is selected in
   the field associated with the value list.

.. method:: checked()
   :noindex:

   Displays the word "checked" if the current value list item is selected in the
   field associated with the value list.


Display All Values from a Value List
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows how to display all values from a value list using a
``-show`` action within an `inline` capture block. The field "title" in the
"people" table contains four values: "Mr.", "Mrs.", "Ms.", and "Dr.". The
``-show`` action allows the values for value lists to be retrieved without
performing a database action. ::

   inline(
      -show,
      -database='contacts',
      -table='people'
   ) => {^
      value_list('title') => {^
         value_listItem + ', '
      ^}
   ^}

   // => Mr., Mrs., Ms., Dr.,


Display a Drop-Down Menu with All Values from a Value List
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows how to format an HTML ``<select>`` drop-down menu to
show all the values from a value list. A select list can be created with the
same code by including a ``"size"`` and/or ``"multiple"`` option within the
``<select>`` tag. This code is usually used within an HTML form that submits to
a page that performs an ``-add`` action so the visitor can select a value from
the value list for the record they create.

The example shows a single ``<select>`` tag within an `inline` capture block
with a ``-show`` command. If many value lists from the same database are being
formatted, they can all be contained within a single inline. ::

   '<form action="response.lasso" method="post">\n'
   inline(
      -show,
      -database='contacts',
      -table='people'
   ) => {^
      '<select name="title">\n'
         value_list('title') => {^
            '   <option value="' + value_listItem + '">' + value_listItem + '</option>\n'
         ^}
      '</select>\n'
   ^}
   '<p><input type="submit" name="submit" value="Add Record">\n</form>\n'

   // =>
   // <form action="response.lasso" method="post">
   // <select name="title">
   //    <option value="Mr." selected>Mr.</option>
   //    <option value="Mrs." >Mrs.</option>
   //    <option value="Ms." >Ms.</option>
   //    <option value="Dr." >Dr.</option>
   // </select>
   // <p><input type="submit" name="submit" value="Add Record"></p>
   // </form>


Display Radio Buttons with All Values from a Value List
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows how to format a set of HTML ``<input>`` tags to show
all the values from a value list as radio buttons. The visitor will be able to
select one value from the value list. Checkboxes can be created with the same
code by changing the type from "radio" to "checkbox". ::

   '<form action="response.lasso" method="post">\n'
   inline(
      -show,
      -database='contacts',
      -table='people'
   ) => {^
      value_list('title') => {^
         '   <input type="radio" name="title" value="' + value_listItem + '" /> ' + value_listItem + '\n'
      ^}
   ^}
   '<p><input type="submit" name="submit" value="Add Record">\n</form>\n'

   // =>
   // <form action="response.lasso" method="post">
   //    <input type="radio" name="title" value="Mr." /> Mr.
   //    <input type="radio" name="title" value="Mrs." /> Mrs.
   //    <input type="radio" name="title" value="Ms." /> Ms.
   //    <input type="radio" name="title" value="Dr." /> Dr.
   // <p><input type="submit" name="submit" value="Add Record"></p>
   // </form>

.. _FileMaker documentation: http://www.filemaker.com/support/product/documentation.html
