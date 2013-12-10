.. _sql-data-sources:

****************
SQL Data Sources
****************

This chapter documents methods and behaviors that are specific to the SQL data
sources in Lasso. These include the data source connectors for MySQL, SQLite,
Oracle, PostgreSQL, and SQL Server. Most of the features of Lasso work equally
across all data sources. The differences specific to each SQL data source are
noted in the features list and in the descriptions of individual features.

MySQL
   Supports MySQL 3.x, 4.x, or 5.x data sources.

Oracle
   Supports Oracle data sources. The Oracle "Instant Client" libraries must be
   installed in order to activate this data source.

PostgreSQL
   Supports PostgreSQL data sources. The PostgreSQL client libraries must be
   installed in order to activate this data source.

SQL Server
   Supports Microsoft SQL Server. The SQL Server client libraries must be
   installed in order to activate this data source.

SQLite
   Supports SQLite 3 data sources. SQLite is the internal data source that is
   used for the storage of Lasso's preferences and security settings.


Supported Features for SQL Data Sources
=======================================

The following lists detail the features of each data source in this chapter.
Since some features are only available in certain data sources it is important
to check these tables when reading the documentation in order to ensure that
each data source supports your solution's required features.


.. _sql-mysql-features:

MySQL Data Source
-----------------

:Friendly Name:
   Lasso Connector for MySQL
:Internal Name:
   mysqlds
:Module Name:
   MySQLConnector.dll, MySQLConnector.dylib, or MySQLConnector.so
:Inline Host Attributes:
   Requires ``-name`` specifying connection URL (e.g. "mysql.example.com"),
   ``-username``, and ``-password``. Optional ``-port`` defaults to "3306".
:Actions:
   ``-add``, ``-delete``, ``-exec``, ``-findAll``, ``-prepare``, ``-search``,
   ``-show``, ``-sql``, ``-update``
:Operators:
   ``-bw``, ``-cn``, ``-eq``, ``-ew``, ``-gt``, ``-gte``, ``-lt``, ``-lte``,
   ``-nbw``, ``-ncn``, ``-new``, ``-ft``, ``-rx``, ``-nrx``,
   ``-opBegin``/``-opEnd`` with "And", "Or", "Not".
:KeyField:
   ``-keyField``/``-keyValue`` and ``-key=array``


.. _sql-oracle-features:

Oracle Data Source
------------------

:Friendly Name:
   Lasso Connector for Oracle
:Internal Name:
   oracle
:Module Name:
   SQLConnector.dll, SQLConnector.dylib, or SQLConnector.so
:Inline Host Attributes:
   Requires ``-name`` specifying connection URL (e.g.
   "oracle.example.com:1521/mydatabase"), ``-username``, and ``-password``.
:Actions:
   ``-add``, ``-delete``, ``-findAll``, ``-search``, ``-show``, ``-sql``,
   ``-update``
:Operators:
   ``-bw``, ``-cn``, ``-eq``, ``-ew``, ``-gt``, ``-gte``, ``-lt``, ``-lte``,
   ``-nbw``, ``-ncn``, ``-new``, ``-opBegin``/``-opEnd`` with "And", "Or",
   "Not".
:KeyField:
   ``-keyField``/``-keyValue``

.. note::
   Field names are case-sensitive. All field names and key field names within
   the inline must be specified with the proper case.


.. _sql-postgresql-features:

PostgreSQL Data Source
----------------------

:Friendly Name:
   Lasso Connector for PostgreSQL
:Internal Name:
   postgresql
:Module Name:
   SQLConnector.dll, SQLConnector.dylib, or SQLConnector.so
:Inline Host Attributes:
   Requires ``-name`` specifying connection URL (e.g. "postgresql.example.com"),
   ``-username``, and ``-password``.
:Actions:
   ``-add``, ``-delete``, ``-findAll``, ``-search``, ``-show``, ``-sql``,
   ``-update``
:Operators:
   ``-bw``, ``-cn``, ``-eq``, ``-ew``, ``-gt``, ``-gte``, ``-lt``, ``-lte``,
   ``-nbw``, ``-ncn``, ``-new``, ``-opBegin``/``-opEnd`` with "And", "Or",
   "Not".
:KeyField:
   ``-keyField``/``-keyValue``

.. note::
   Field names are case-sensitive. All field names and key field names within
   the inline must be specified with the proper case.


.. _sql-ms-sql-server-features:

SQL Server Data Source
----------------------

:Friendly Name:
   Lasso Connector for SQL Server
:Internal Name:
   sqlserver
:Module Name:
   SQLConnector.dll, SQLConnector.dylib, or SQLConnector.so
:Inline Host Attributes:
   Requires ``-name`` specifying connection URL (e.g.
   "sqlserver.example.com\\mydatabase"), ``-username``, and ``-password``.
:Actions:
   ``-add``, ``-delete``, ``-findAll``, ``-search``, ``-show``, ``-sql``,
   ``-update``
:Operators:
   ``-bw``, ``-cn``, ``-eq``, ``-ew``, ``-gt``, ``-gte``, ``-lt``, ``-lte``,
   ``-nbw``, ``-ncn``, ``-new``, ``-opBegin``/``-opEnd`` with "And", "Or",
   "Not".
:KeyField:
   ``-keyField``/``-keyValue``


.. _sql-sqlite-features:

SQLite Data Source
------------------

:Friendly Name:
   Lasso Internal
:Internal Name:
   sqliteconnector
:Module Name:
   SQLiteConnector.dylib, SQLiteConnector.dll, or SQLiteConnector.so
:Actions:
   ``-add``, ``-delete``, ``-findAll``, ``-search``, ``-show``, ``-sql``,
   ``-update``
:Operators:
   ``-bw``, ``-cn``, ``-eq``, ``-ew``, ``-gt``, ``-gte``, ``-lt``, ``-lte``,
   ``-nbw``, ``-ncn``, ``-new``, ``-opBegin``/``-opEnd`` with "And", "Or",
   "Not".
:KeyField:
   ``-keyField``/``-keyValue``


SQL Data Source Tips
====================

-  Always specify a primary key field using the ``-keyField`` parameter for
   ``-search``, ``-add``, and ``-findAll`` actions. This will ensure that the
   `keyField_value` method will always return a value.

-  Use ``-keyField`` and ``-keyValue`` parameters to reference a particular
   record for updates or deletes.

-  Data sources can be case-sensitive. For best results, reference database and
   table names in the same letter case as they appear on disk in your Lasso
   code. Field names may also be case-sensitive (such as in Oracle and
   PostgreSQL).

-  Some data sources will truncate any data beyond the length they are set up to
   store. Ensure that all fields have sufficient capacity for the values that
   need to be stored in them.

-  Use ``-returnField`` parameters to reduce the number of fields that are
   returned from a ``-search`` action. Returning only the fields that need to be
   used for further processing or shown to the site visitor reduces the amount
   of data that needs to travel between Lasso and the data source.

-  When an ``-add`` or ``-update`` action is performed on a database, the data
   from the added or updated record is available inside the capture block of the
   `inline` method. If the ``-returnField`` parameter is used, then only those
   fields specified should be returned from an ``-add`` or ``-update`` action.
   Setting ``-maxRecords=0`` can be used as an indication that no record should
   be returned.


Security Tips
=============

-  SQL statements that are generated using visitor-defined data should be
   screened carefully for unwanted commands such as "DROP" or "GRANT".

-  Always sanitize any inputs from site visitors that are incorporated into SQL
   statements. Any SQL strings that have visitor-defined data should be
   sanitized using the `string->encodeSql` method for MySQL data sources and the
   `string->encodeSql92` method for SQL92-compliant data sources such as SQLite,
   PostgreSQL, or JDBC data sources. Encoding the values in this manner ensures
   that quotes and other reserved characters are properly escaped within the SQL
   statement, thereby helping to prevent SQL injection attacks.

   For example, the following SQL "SELECT" statement contains a SQL string in
   the LIKE clause and uses `string->encodeSql` to encode the value of the
   "company" `web_request->param`. This encoding causes all single quotes within
   the passed ``company`` parameter to be encoded with a backslash. ::

      local(sql_statement = "SELECT * FROM contacts.people WHERE company LIKE '" +
            string(web_request->param('company'))->encodeSql + "%';")

   If ``web_request->param('company')`` returns "McDonald's" then the SQL
   statement generated by this code would appear as follows:

   .. code-block:: sql

      SELECT * FROM Contacts.People WHERE Company LIKE 'McDonald\'s%';


SQL Data Source Methods
=======================

Lasso includes methods to identify which type of SQL data source is being used.
These methods are summarized below.

.. method:: lasso_datasourceIsMySQL(name)

   Returns "true" if the specified database is hosted by MySQL. Requires one
   string parameter, which is the name of a database.

.. method:: lasso_datasourceIsSybase(name)

   Returns "true" if the specified database is hosted by Sybase. Requires one
   string parameter, which is the name of a database.

.. method:: lasso_datasourceIsOracle(name)

   Returns "true" if the specified database is hosted by Oracle. Requires one
   string parameter, which is the name of a database.

.. method:: lasso_datasourceIsPostgreSQL(name)

   Returns "true" if the specified database is hosted by PostgreSQL. Requires
   one string parameter, which is the name of a database.

.. method:: lasso_datasourceIsSQLServer(name)

   Returns "true" if the specified database is hosted by Microsoft SQL Server.
   Requires one string parameter, which is the name of a database.

.. method:: lasso_datasourceIsSQLite(name)

   Returns "true" if the specified database is hosted by SQLite. Requires one
   string parameter, which is the name of a database.


Check Whether a Database is Hosted by MySQL
-------------------------------------------

The following example shows how to use `lasso_datasourceIsMySQL` to check
whether the database "Example" is hosted by MySQL or not::

   if(lasso_datasourceIsMySQL('example'))
      stdoutnl("Example is hosted by MySQL!")
   else
      stdoutnl("Example is not hosted by MySQL.")
   /if

   // => Example is hosted by MySQL!


List All Databases Hosted by MySQL
----------------------------------

Use the `database_names` method to list all databases available to Lasso. The
`lasso_datasourceIsMySQL` method can be used to check each database and only
those that MySQL hosts will be returned. The result shows two databases, "site"
and "example", which are available through MySQL::

   database_names
      if(lasso_datasourceIsMySQL(database_nameItem))
            '<br />' + database_nameItem + '\n'
      /if
   /database_names

   // =>
   // <br />example
   // <br />site


Searching Records with SQL Data Sources
=======================================

In Lasso, there are unique search operations that can be performed using SQL
data sources. These search operations take advantage of special functions such
as full-text indexing, regular expressions, record limits, and distinct values
to allow optimal performance and power when searching. All these search
operations can be used on MySQL data sources in addition to all search
operations described in the :ref:`searching-displaying` chapter.


Search Field Operators for MySQL
--------------------------------

Additional field operators are available for the ``-operator`` (or ``-op``)
parameter when searching MySQL data sources. These operators are summarized in
the table below. Basic use of the ``-operator`` parameter is described in the
:ref:`searching-displaying` chapter.

.. tabularcolumns:: |l|L|

.. _sql-mysql-search-operators:

.. table:: MySQL Additional Search Field Operators

   ========================= ===================================================
   Operator                  Description
   ========================= ===================================================
   ``-op='ft'`` or ``-ft``   Full-Text Search. If used, a MySQL full-text search
                             is performed on the field specified. Will only work
                             on fields that are full-text indexed in MySQL.
                             Records are automatically returned in order of high
                             relevance (contains many instances of that value)
                             to low relevance (contains few instances of the
                             value). Only one ``-ft`` operator may be used per
                             action, and no ``-sortField`` parameter should be
                             specified.
   ``-op='nrx'`` or ``-rx``  Regular Expression Search. If used, then regular
                             expressions may be used as part of the search field
                             value. Returns records matching the regular
                             expression value for that field.
   ``-op='nrx'`` or ``-nrx`` Not Regular Expression Search. If used, then
                             regular expressions may be used as part of the
                             search field value. Returns records that do not
                             match the regular expression value for that field.
   ========================= ===================================================

.. note::
   For more information on full-text searches and the regular expressions
   supported in MySQL, see the `MySQL documentation`_.


Perform a Full-Text Search on a Field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a MySQL field is indexed as full-text, then using ``-op='ft'`` before the
field in a search inline performs a MySQL full-text search on that field. The
example below performs a full-text search on the "jobs" field in the "people"
table, and returns the "first_name" field for each record that contain the word
"Manager". Records that contain the most instances of the word "Manager" are
returned first. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -op='ft', 'jobs'='Manager'
   ) => {^
      records => {^
         '<br />' + field('first_name') + '\n'
      ^}
   ^}

   // =>
   // <br />Mike
   // <br />Jane


Use Regular Expressions as Part of a Search
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Regular expressions can be used as part of a search value for a field by using
``-op='rx'`` before the field in a search inline. The following example searches
for all records where the "last_name" field contains eight characters using a
regular expression::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -op='rx', 'last_name'='.{8}',
      -maxRecords='all'
   ) => {^
      records => {^
         '<br />' + field('last_name') + ', ' + field('first_name')
      ^}
   ^}

   // =>
   // <br />Lastname, Mike
   // <br />Lastname, Mary Beth

The following example searches for all records where the "last_name" field
doesn't contain eight characters. This is easily accomplished using the same
inline search above using ``-op='nrx'`` instead. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -op='nrx', 'last_name'='.{8}',
      -maxRecords='all'
   ) => {^
      records => {^
         '<br />' + field('last_name') + ', ' + field('first_name') + '\n'
      ^}
   ^}

   // =>
   // <br />Doe, John
   // <br />Doe, Jane
   // <br />Surname, Bob
   // <br />Surname, Jane
   // <br />Surname, Margaret
   // <br />Unknown, Thomas


Result Keyword Parameters
-------------------------

Additional result keyword parameters are available when searching the data
sources in this chapter using the `inline` method. These parameters are
summarized in the following table.

.. tabularcolumns:: |l|L|

.. _sql-result-parameters:

.. table:: SQL Additional Result Parameters

   =============== =============================================================
   Parameter       Description
   =============== =============================================================
   ``-distinct``   Causes a ``-search`` action to only output records that
                   contain unique field values (comparing only returned fields)
                   or a ``findAll`` action to return records that are distinct
                   across all fields. Does not require a value. May be used with
                   the ``-returnField`` parameter to limit the fields checked
                   for distinct values. MySQL only.
   ``-groupBy=?``  Specifies a field name that should by used as the "GROUP BY"
                   statement for a search action. Allows data to be summarized
                   based on the values of the specified field.
   ``-sortRandom`` Requests that returned records be sorted randomly. Is used in
                   place  of the ``-sortField`` and ``-sortOrder`` parameters.
                   Does not require a value. MySQL only.
   ``-useLimit``   Prematurely ends a ``-search`` or ``-findAll`` action once
                   the specified number of records for the ``-maxRecords``
                   parameter have been found and returns the found records.
                   Requires the ``-maxRecords`` parameter. This issues a "LIMIT"
                   or "TOP" statement.
   =============== =============================================================


Return Only Unique Records in a Search
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-distinct`` parameter in a search inline. In the following example, a
``-findAll`` action is used on the "people" table of the "contacts" database.
Only distinct values from the "last_name" field are returned. ::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -returnField='last_name',
      -distinct
   ) => {^
      records => {^
         '<br />' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // <br />Doe
   // <br />Surname
   // <br />Lastname
   // <br />Unknown

The ``-distinct`` parameter is especially useful for generating lists of values
that can be used in a drop-down list. The following example is a drop-down list
of all the last names in the "people" table::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -returnField='last_name',
      -distinct
   ) => {^
      '<select name="last_name">\n'
      records => {^
         '   <option value="' + field('last_name') + '">' + field('last_name') + '</option>\n'
      ^}
      '</select>\n'
   ^}

   // =>
   // <select name="last_name">
   //    <option value="Doe">Doe</option>
   //    <option value="Surname">Surname</option>
   //    <option value="Lastname">Lastname</option>
   //    <option value="Unknown">Unknown</option>
   // </select>


Use the ``-groupBy`` parameter to specify a field whose values should be
distinct without limiting which fields are returned. The following query will
return the same result as above, but have all fields available for display::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -groupBy='last_name'
   ) => {^
      '<select name="last_name">\n'
      records => {^
         '   <option value="' + field('last_name') + '">' + field('last_name') + '</option>\n'
      ^}
      '</select>\n'
   ^}


Sort Results Randomly
^^^^^^^^^^^^^^^^^^^^^

Use the ``-sortRandom`` parameter in a search inline. In the following example,
all records from the "people" table of the "contacts" database are returned in
random order::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id',
      -sortRandom
   ) => {^
      records => {^
         field('id')
      ^}
   ^}

   // => 5 2 8 1 3 6 4 7

.. note::
   Due to the nature of the ``-sortRandom`` parameter, the results of this
   example will vary upon each execution of the inline.


Return Records Once a Limit is Reached
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-useLimit`` parameter in the search inline. Normally, Lasso will find
all records that match the inline search criteria and then pare down the results
based on ``-maxRecords`` and ``-skipRecords`` values. The ``-useLimit``
parameter instructs the data source to terminate the specified search process
once the number of records specified for ``-maxRecords`` is found. The following
example searches the "people" table with a limit of five records::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -maxRecords='5',
      -useLimit
   ) => {^
      found_count
   ^}

   // => 5

.. note::
   If the ``-useLimit`` parameter is used, the value of the `found_count` method
   will always be the same as the ``-maxRecords`` value if the limit is reached.
   Otherwise, the `found_count` method will return the total number of records
   in the specified table that match the search criteria if ``-useLimit`` is not
   used.


Searching for Null Values
-------------------------

When searching tables in a SQL data source, "NULL" values may be explicitly
searched for within fields using the :type:`null` object. A "NULL" value in a
SQL data source designates that there is no other value stored in that
particular field. This is similar to searching a field for an empty string (e.g.
``'fieldname'=''``), however "NULL" values and empty strings are not the same in
SQL data sources. For more information about "NULL" values, see the
documentation for the data source. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -op='eq', 'title'=null,
      -maxRecords='all'
   ) => {^
      records => {^
         '<br />Record ' + field('id') + ' does not have a title.\n'
      ^}
   ^}

   // =>
   // <br />Record 7 does not have a title.
   // <br />Record 8 does not have a title.


Adding and Updating Records
===========================

In Lasso, there are special add and update operations that can be performed
using SQL data sources in addition to all add and update operations described in
the :ref:`adding-updating` chapter.


Multiple Field Values
---------------------

When adding or updating data to a field in MySQL, the same field name can be
used several times in an ``-add`` or ``-update`` inline. The result is that all
data added or updated in each instance of the field name will be concatenated in
a comma-delimited form. This is particularly useful for adding data to "SET"
field types.


Add or Update Multiple Field Values
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example adds a record with two comma-delimited values in the
"Jobs" field::

   inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      'jobs'='Customer Service',
      'jobs'='Sales'
   ) => {^
      field('jobs')
   ^}

   // => Customer Service,Sales

The following example updates the "jobs" field of a record with three
comma-delimited values::

   inline(
      -update,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=5,
      'jobs'='Customer Service',
      'jobs'='Sales',
      'jobs'='Support'
   ) => {^
      field('jobs')
   ^}

   // => Customer Service,Sales,Support

.. note::
   The individual values being added or updated should not contain commas.


Null Values
-----------

"NULL" values can be explicitly added to fields using the :type:`null` object. A
"NULL" value in a SQL data source designates that there is no value for a
particular field. This is similar to setting a field to an empty string (e.g.
``'fieldname'=''``), however the two are different in SQL data sources. For more
information about "NULL" values, see the documentation for the data source.


Add or Update a Null Field Value
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the :type:`null` object as the field value. The following example adds a
record with a "NULL" value in the "last_name" field::

   inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      'last_name'=null
   ) => {}

The following example updates a record with a "NULL" value in the "last_name"
field::

   inline(
      -update,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=5,
      'last_name'=null
   ) => {}


Value Lists
===========

A :dfn:`value list` in Lasso is a set of possible values that can be used for a
field. Value lists in MySQL are lists of predefined and stored values for a
"SET" or "ENUM" field type. A value list from a "SET" or "ENUM" field can be
displayed using the methods defined below. None of these methods will work in
``-sql`` inlines or if ``-noValueLists`` is specified.

.. method:: value_list(name::string)

   Executes a capture block once for each value allowed for an "ENUM" or "SET"
   field. Requires a single parameter: the name of an "ENUM" or "SET" field from
   the current table. This method will not work in ``-sql`` inlines or if the
   ``-noValueLists`` parameter is specified.

.. method:: value_listItem()

   While in a `value_list` capture block, it returns the value for the current
   item.

.. method:: selected()

   Displays the word "selected" if the current value list item is contained in
   the data of the "ENUM" or "SET" field.

.. method:: checked()

   Displays the word "checked" if the current value list item is contained in
   the data of the "ENUM" or "SET" field.

.. note::
   See the :ref:`searching-displaying` chapter for information about the
   ``-show`` parameter which is used throughout this section.


Display Allowed Values for an ENUM or SET Field
-----------------------------------------------

Perform a ``-show`` action to return the schema of a MySQL database and use the
`value_list` method to display the allowed values for an "ENUM" or "SET" field.
The following example shows how to display all values from the "ENUM" field
"title" in the "people" table. "SET" fields function in the same manner as
"ENUM" fields, and all examples in this section may be used with either "ENUM"
or "SET" field types. ::

   inline(
      -show,
      -database='contacts',
      -table='people'
   ) => {^
      value_list('title') => {^
         '<br />' + value_listItem + '\n'
      ^}
   ^}

   // =>
   // <br />Mr.
   // <br />Mrs.
   // <br />Ms.
   // <br />Dr.

The following example shows how to display all values from a value list using a
named inline. The same name "values" is referenced by ``-inlineName`` in both
the `inline` method and `resultSet` method. ::

   inline(
      -inlineName='Values',
      -show,
      -database='contacts',
      -table='people'
   ) => {}

   // ...

   resultSet(1, -inlineName='Values') => {^
      value_list('title') => {^
         '<br />' + value_listItem + '\n'
      ^}
   ^}

   // =>
   // <br />Mr.
   // <br />Mrs.
   // <br />Ms.
   // <br />Dr.


Display a Drop-Down Menu with All Values from a Value List
----------------------------------------------------------

The following example shows how to format an HTML ``<select>`` drop-down menu to
show all the values from a value list. A select list can be created with the
same code by including size and multiple parameters within the ``<select>`` tag.
This code is usually used within an HTML form that calls a response page that
performs an ``-add`` or ``-update`` action so the visitor can select a value
from the value list for the record they create or modify.

The example shows a single ``<select>`` within an `inline` method with a
``-show`` action. If many value lists from the same database are being
formatted, they can all be contained within a single inline. ::

   '<form action="response.lasso" method="POST">\n'
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
   '<p><input type="submit" name="submit" value="Add Record"></p>\n'
   '</form>\n'

   // =>
   // <form action="response.lasso" method="POST">
   // <select name="title">
   //    <option value="Mr.">Mr.</option>
   //    <option value="Mrs.">Mrs.</option>
   //    <option value="Ms.">Ms.</option>
   //    <option value="Dr.">Dr.</option>
   // </select>
   // <p><input type="submit" name="submit" value="Add Record"></p>
   // </form>


Display Radio Buttons with All Values from a Value List
-------------------------------------------------------

The following example shows how to format a set of HTML ``<input>`` tags to show
all the values from a value list as radio buttons. The visitor will be able to
select one value from the value list. Checkboxes can be created with the same
code by changing the type from radio to checkbox. ::

   '<form action="response.lasso" method="POST">\n'
   inline(
      -show,
      -database='contacts',
      -table='people'
   ) => {^
      value_list('title') => {^
         '   <input type="radio" name="title" value="' + value_listItem + '" /> ' + value_listItem + '\n'
      ^}
   ^}
   '<p><input type="submit" name="submit" value="Add Record"></p>\n'
   '</form>\n'

   // =>
   // <form action="response.lasso" method="POST">
   //    <input type="radio" name="title" value="Mr." /> Mr.
   //    <input type="radio" name="title" value="Mrs." /> Mrs.
   //    <input type="radio" name="title" value="Ms." /> Ms.
   //    <input type="radio" name="title" value="Dr." /> Dr.
   // <p><input type="submit" name="submit" value="Add Record"></p>
   // </form>


Display Only Selected Values from a Value List
----------------------------------------------

The following example shows how to display the selected values from a value list
for the current record. The record for "John Doe" is found within the database
and the selected value for the "title" field, "Mr.", is displayed.

The `selected` method is used to ensure that only selected value list items are
shown. The following example uses a conditional to check whether `selected` is
empty and only shows the `value_listItem` if it is not::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=126
   ) => {^
      value_list('title') => {^
         if(selected != '') => {^
            '<br />' + value_listItem
         ^}
      ^}
   ^}

   // => <br />Mr.

The `field` method can also be used simply to display the current value for a
field without reference to the value list. ::

   '<br />' + field('title')

   // => <br />Mr.


Display a Drop-Down Menu with Selected Values from a Value List
---------------------------------------------------------------

The following example shows how to format an HTML ``<select>`` list to show all
the values from a value list with the selected values highlighted. The
`selected` method returns "selected" if the current value list item is selected
in the database or nothing otherwise. ::

   '<form action="response.lasso" method="POST">\n'
   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=126
   ) => {^
      '<select name="title" multiple size="4">\n'
      value_list('title') => {^
         '   <option value="' + value_listItem + '" ' + selected + '>' + value_listItem + '</option>\n'
      ^}
      '</select>\n'
   ^}
   '<input type="submit" name="submit" value="Update Record">\n'
   '</form>\n'

   // =>
   // <form action="response.lasso" method="POST">
   // <select name="title" multiple size="4">
   //    <option value="Mr." selected>Mr.</option>
   //    <option value="Mrs." >Mrs.</option>
   //    <option value="Ms." >Ms.</option>
   //    <option value="Dr." >Dr.</option>
   // </select>
   // <input type="submit" name="submit" value="Update Record">
   // </form>


Display Checkboxes with Selected Values from a Value List
---------------------------------------------------------

The following example shows how to format a set of HTML ``<input>`` tags to show
all the values from a value list as checkboxes with the selected checkboxes
checked. The `checked` method returns "checked" if the current value list item
is selected in the database or nothing otherwise. Radio buttons can be created
with the same code by changing the type from "checkbox" to "radio". ::

   '<form action="response.lasso" method="POST">\n'
   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=126
   ) => {^
      value_list('title') => {^
         '   <input type="checkbox" name="title" value="' + value_listItem + '" ' + checked + '>' + value_listItem + '\n'
      ^}
   ^}
   '<input type="submit" name="submit" value="Update Record">\n'
   '</form>\n'

   // =>
   // <form action="response.lasso" method="POST">
   //    <input type="checkbox" name="title" value="Mr." checked> Mr.
   //    <input type="checkbox" name="title" value="Mrs." > Mrs.
   //    <input type="checkbox" name="title" value="Ms." > Ms.
   //    <input type="checkbox" name="title" value="Dr." > Dr.
   // <input type="submit" name="submit" value="Update Record">
   // </form>

.. note::
   Storing multiple values is only supported using "SET" field types.


SQL Statements
==============

Lasso provides the ability to issue SQL statements directly to SQL-compliant
data sources, including the MySQL data source. SQL statements are specified
within the `inline` method using the ``-sql`` parameter. Many third-party
databases that support SQL statements also support the use of the ``-sql``
parameter. SQL inlines can be used as the primary method of database interaction
in Lasso, or they can be used alongside standard inline actions (e.g.
``-search``, ``-add``, ``-update``, ``-delete``) where a specific SQL function
is desired that cannot be replicated using standard database commands.

.. note::
   The ``-sql`` inline parameter is not supported for FileMaker data sources.

.. note::
   Documentation of SQL itself is outside the realm of this guide. Please
   consult the documentation included with your data source for information on
   what SQL statements it supports.

For most data sources multiple SQL statements can be specified within the
``-sql`` parameter separated by a semicolon. Lasso will issue all of the
statements to the data source at once and will collect all of the results into
result sets. The `resultSet_count` method returns the number of result sets that
Lasso found. The `resultSet` method can then be used with an integer parameter
to return the results from one of the result sets.

.. caution::
   Visitor-supplied values must be sanitized when they are concatenated into SQL
   statements. Sanitizing these values ensures that no invalid characters are
   passed to the data source and helps to prevent SQL injection attacks.
   The `string->encodeSql` method should be used to encode values for MySQL
   strings. The `string->encodeSql92` method should be used to encode values
   for strings for other SQL-compliant data sources including JDBC data sources
   and SQLite. The ``-search``, ``-add``, ``-update``, etc. database actions
   automatically sanitize values passed as pairs into an inline.

.. tabularcolumns:: |l|L|

.. _sql-statement-parameters:

.. table:: SQL Statement Parameters

   ================== ==========================================================
   Parameter          Description
   ================== ==========================================================
   ``-sql=?``         Issues one or more SQL command to a compatible data
                      source. Multiple commands are delimited by a semicolon.
                      When multiple commands are used, all will be executed,
                      however only the first command issued will return results
                      to the `inline` method unless the `resultSet` method is
                      used.
   ``-database=?``    The database in the data source in which to execute the
                      SQL statement.
   ``-table=?``       A table in the database (used for encoding information).
   ``-maxRecords=?``  The maximum number of records to return. Optional,
                      defaults to "50".
   ``-skipRecords=?`` The offset into the found set at which to start returning
                      records. Optional, defaults to "1".
   ================== ==========================================================

The ``-database`` parameter can be any database within the data source in which
the SQL statement should be executed. The ``-database`` parameter will be used
to determine the data source, and table references within the statement can
include both a database name and a table name (e.g. "contacts.people") in order
to fetch results from multiple tables. For example, to create a new database in
MySQL, a ``CREATE DATABASE`` statement can be executed with ``-database`` set to
a name of a database in the host you want the new database to reside in.

When referencing the name of a database and table in a SQL statement (e.g.
"contacts.people"), only the true names of a database can be used as MySQL does
not recognize Lasso database aliases in a SQL command.

.. index:: encodeSql(), encodeSql92()

.. member:: string->encodeSql()
   :noindex:

   Encodes illegal characters in MySQL string literals by escaping them with a
   backslash. Helps to prevent SQL injection attacks and ensures that SQL
   statements only contain valid characters. This method must be used to encode
   visitor supplied values within SQL statements for MySQL strings.

.. member:: string->encodeSql92()
   :noindex:

   Encodes illegal characters in SQL string literals by escaping a single quote
   with two single quotes. Helps to prevent SQL injection attacks and ensures
   that SQL statements only contain valid characters. This method can be used to
   encode values for SQLite and most other SQL-compliant data sources.

Results from a SQL statement are returned in a record set within the `inline`
method. The results can be read and displayed using the `records` or `rows`
methods and the `field` or `column` method. However, many SQL statements return
a synthetic record set that does not correspond to the names of the fields of
the table being operated upon. This is demonstrated in the examples that follow.


Issuing SQL Statements
----------------------

SQL statement are specified within an `inline` method with a ``-sql`` keyword
parameter.

The following example calculates the results of a mathematical expression "1 +
2" and returns the value as a field named "result". Note that even though this
SQL statement does not reference a database, a ``-database`` parameter is still
required so Lasso knows to which data source to send the statement::

   inline(
      -database='example',
      -sql="SELECT 1+2 AS result;"
   ) => {^
      'The result is: ' + field('result')
   ^}

   // => The result is 3

The following example calculates the results of several mathematical expressions
and returns them as field values "one", "two", and "three"::

   inline(
      -database='example',
      -sql="SELECT 1+2 AS one, sin(.5) AS two, 5%2 AS three;"
   ) => {^
      'The results are: ' + field('one') + ', ' + field('two') + ', and ' + field('three')
   ^}

   // => The results are 3, 0.579426, and 1

The following example calculates the results of several mathematical expressions
using Lasso and returns them as field values "one", "two", and "three". It
demonstrates how the results of Lasso expressions and methods can be used in a
SQL statement::

   inline(
      -database='example',
      -sql="SELECT " + (1+2) + " AS one, " + math_sin(0.5) + " AS two, " + (5%2) + " AS three;"
   ) => {^
      'The results are: ' + field('one') + ', ' + field('two') + ', and ' + field('three')
   ^}

   // => The results are 3, 0.579426, and 1

The following example returns records from the "phone_book" table where
"first_name" is equal to "John". This is equivalent to a ``-search`` action::

   inline(
      -database='contacts',
      -sql="SELECT * FROM phone_book WHERE first_name = 'John';"
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // <br />John Doe
   // <br />John Person


Issue a SQL Statement with Multiple Commands
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Specify several SQL statements within an `inline` method in a ``-sql`` keyword
parameter, with each SQL command separated by a semicolon. The following example
adds three unique records to the "people" table of the "contacts" database::

   inline(
      -database='contacts',
      -sql="INSERT INTO people (first_name, last_name) VALUES ('John',  'Jakob');
            INSERT INTO people (first_name, last_name) VALUES ('Tom',   'Smith');
            INSERT INTO people (first_name, last_name) VALUES ('Sally', 'Brown');"
   ) => {}


Determine the Actual Database Name for a SQL Statement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `database_realName` method. When using the ``-sql`` parameter to issue
SQL statements to a host, only true database names may be used (bypassing the
alias). The `database_realName` method can be used to automatically determine
the true name of a database, allowing them to be used in a valid SQL statement.
::

   local(real_db) = database_realName('Contacts_alias')
   inline(
      -database='contacts_alias',
      -sql="SELECT * FROM `" + #real_db + "`.people;"
   ) => {}


Sanitizing Visitor-Supplied Values in a SQL Statement
-----------------------------------------------------

All visitor supplied values must be sanitized before they are concatenated into
a SQL statement in order to ensure the validity of the SQL statement and to
prevent SQL injection. Values from the `web_request->param`, `cookie`, and
`field` methods should be encoded as well as values from any calculations that
rely on these methods. The `string->encodeSql` method should be used to encode
values within SQL statements for MySQL data sources. The `string->encodeSql92`
method should be used to encode values for other SQL-compliant data sources
including JDBC data sources and SQLite.

The following example encodes the query or post parameter for "first_name" for a
MySQL data source::

   inline(
      -database='contacts',
      -sql="SELECT * FROM phone_book WHERE first_name = '" +
         string(web_request->param('first_name'))->encodeSql + "';"
   ) => {}

The following example encodes the query or post parameter "first_name" for a
SQLite (or other SQL-compliant) data source::

   inline(
      -database='contacts',
      -sql="SELECT * FROM phone_book WHERE first_name = '" +
         string(web_request->param('first_name'))->encodeSql92 + "';"
   ) => {}

.. important::
   The `string->encodeSql` and `string->encodeSql92`  methods can only be used
   to sanitize data being used as SQL string data in the SQL expression. If you
   need to sanitize data being used as integer or decimal data, use those
   creator methods to ensure the object is of those types. To sanitize a date
   object, use the `date->format` method and make sure the format string doesn't
   contain invalid characters. If you need to use variables to specify database,
   table, or column names inside a SQL statement, then you will need to take
   additional precautions that vary by data source. All of this is to say that
   you should always sanitize your inputs, and simply using the
   `~string->encodeSql` methods is not enough.


Automatically Formatting SQL Statement Results
----------------------------------------------

Use the `field_name` method and `loop` method to create an HTML table that
automatically formats the results of a ``-sql`` command. The ``-maxRecords``
parameter should be set to "All" so all records are returned rather than the
default (50).

The following example shows a ``REPAIR TABLE contacts.people`` SQL statement
being issued to a MySQL database, and the result is automatically formatted. The
statement returns a synthetic record set that shows the results of the repair.

Notice that the database "contacts" is specified explicitly within the SQL
statement. Even though the database is identified in the ``-database`` parameter
within the inline it may still be explicitly specified in each table reference
within the SQL statement. ::

   inline(
      -database='contacts',
      -sql="REPAIR TABLE contacts.people;",
      -maxRecords='all'
   ) => {^
      '<table border="1">\n'
      '<tr>\n'
      loop(field_name(-count)) => {^
         '   <td><b>' + field_name(loop_count) + '</b></td>\n'
      ^}
      '</tr>\n'
      records => {^
         '<tr>\n'
         loop(field_name(-count)) => {^
            '   <td>' + field(field_name(loop_count)) + '</td>\n'
         ^}
         '</tr>\n'
      ^}
      '</table>\n'
   ^}

The results are returned in a table with bold column headings. The following
results show that the table did not require any repairs. If repairs are
performed then many more records will be returned. ::

   // =>
   // <table border="1">
   // <tr>
   //    <td><b>Table</b></td>
   //    <td><b>Op</b></td>
   //    <td><b>Msg_type</b></td>
   //    <td><b>Msg_text</b></td>
   // </tr>
   // <tr>
   //    <td>people</td>
   //    <td>Check</td>
   //    <td>Status</td>
   //    <td>OK</td>
   // </tr>
   // </table>


Using Result Sets
-----------------

An inline that uses a ``-sql`` action can return multiple result sets. Each SQL
statement within the ``-sql`` action is separated by a semicolon and generates
its own result set. This allows multiple SQL statements to be issued to a data
source in a single connection and for the results of each statement to be
reviewed individually.

In the following example the `resultSet_count` method is used to report the
number of result sets that the inline returned. Since the ``-sql`` parameter
contains two SQL statements, two result sets are returned. The two result sets
are then looped through by passing the `resultSet_count` method to the `loop`
method and passing the `loop_count` as the parameter for the `resultSet` method.
Finally, the `records` method is used as normal to display the records from each
result set. ::

   inline(
      -database='contacts',
      -sql="SELECT CONCAT(first_name, ' ', last_name) AS name FROM people; SELECT name FROM companies;"
   ) => {^
      resultSet_count + ' Result Sets\n'
      '<hr />\n'
      loop(resultSet_count) => {^
         resultSet(loop_count) => {^
            records => {^
               '<br />' + field('name') + '\n'
            ^}
            '<hr />\n'
         ^}
      ^}
   ^}

   // =>
   // 2 Result Sets
   // <hr />
   // <br />John Doe
   // <br />Jane Doe
   // <hr />
   // <br />LassoSoft
   // <hr />

The same example can be rewritten using a named inline. An ``-inlineName``
parameter with the name "MyResults" is added to the `inline` method, the
`resultSet_count` method, and the `resultSet` method. This way the result sets
can be output from anywhere after the inline. The results of the following
example will be the same as those shown above::

   inline(
      -inlineName='MyResults',
      -database='contacts',
      -sql="SELECT CONCAT(first_name, ' ', last_name) AS name FROM people; SELECT name FROM companies;"
   ) => {}

   // ...

   resultSet_count(-inlineName='MyResults') + ' Result Sets'
   '<hr />'
   loop(resultSet_count(-inlineName='MyResults')) => {^
      resultSet(loop_count, -inlineName='MyResults') => {^
         records => {^
            '<br />' + field('name')
         ^}
         '<hr />'
      ^}
   ^}


.. _sql-transactions:

SQL Transactions
================

Lasso supports the ability to perform :dfn:`SQL transactions`, which are
reversible groups of statements, provided that the data source used (e.g. MySQL
4 and later with certain storage engines) supports this functionality. See your
data source documentation to see if transactions are supported.

.. note::
   SQL transactions are not supported for FileMaker Server data sources.

SQL transactions can be achieved within nested `inline` methods. A single
connection to MySQL or JDBC data sources will be held open around the outer
inline. Any nested inlines that use the same data source will make use of the
same connection.

.. note::
   When using named inlines, the connection is not available in subsequent
   ``records(-inlineName='Name')`` methods.


Open a Transaction and Commit or Rollback in MySQL
--------------------------------------------------

Use nested ``-sql`` inlines, where the outer inline performs a transaction, and
the inner inline commits or rolls back the transaction depending on the results
of a conditional statement. ::

   inline(
      -database='contacts',
      -sql="START TRANSACTION;
            INSERT INTO contacts.people (title, company) VALUES ('Mr.', 'LassoSoft');"
   ) => {
      if(error_currentError != error_msg_noerror) => {
         inline(-database='contacts', -sql="ROLLBACK;") => {}
      else
         inline(-database='contacts', -sql="COMMIT;") => {}
      }
   }


Fetch the Last Inserted ID in MySQL
-----------------------------------

Use nested ``-sql`` inlines, where the outer inline performs an insert query,
and the inner inline retrieves the ID of the last inserted record using the
MySQL ``last_insert_id()`` function. Because the two inlines share the same
connection, the inner inline will always return the value added by the outer
inline. ::

   inline(
      -database='contacts',
      -sql="INSERT INTO people (title, company) VALUES ('Mr.', 'LassoSoft');"
   ) => {^
      inline(-sql="SELECT last_insert_id();") => {^
         field('last_insert_id()')
      ^}
   ^}

   // => 23


Prepared Statements
===================

Lasso supports the ability to use prepared statements to speed up database
operations provided that the data source used (e.g. MySQL 4 and later) supports
this functionality. See your data source documentation to see if prepared
statements are supported.

A :dfn:`prepared statement` is a cached database query that can speed up
database operations by cutting down on the amount of overhead that the data
source needs to perform for each statement. For example, processing the
following "INSERT" statement requires the data source to load the people table,
determine its primary key, load information about its indexes, and determine
default values for fields not listed. After the new record is inserted the
indexes must be updated. If another "INSERT" is performed then all of these
steps are repeated from the beginning:

.. code-block:: sql

   INSERT INTO people (`first_name`, `last_name`) VALUES ("John", "Doe");

When this statement is changed into a prepared statement then the data source
knows to expect multiple executions of the statement. The data source can cache
information about the table in memory and reuse that information for each
execution. The data source might also be able to defer some operations such as
finalizing index updates until after several statements have been executed.

The specific details of how prepared statements are treated are dependent on the
data source. The savings in overhead and increase in speed may vary depending on
what type of SQL statement is being issued, the size of the table and indexes
that are being used, and other factors.

The statement above can be rewritten as a prepared statement by replacing the
values with question marks. The name of the table and field list are defined
just as they were in the original SQL statement. This statement is a template
into which particular values will be placed before the data source executes it:

.. code-block:: sql

   INSERT INTO people (`first_name`, `last_name`) VALUES (?, ?)

The particular values are specified as an array. Each element of the array
corresponds with one question mark from the prepared statement. To insert "John
Doe" into the "people" table the following array would be used::

   array('John', 'Doe')

One new database action is used to prepare statement and execute them:
``-prepare`` is similar to ``-sql``, but informs Lasso that you want to create a
prepared statement. Nested inlines are then issued with an array and the
``-sql`` parameter. The array should contain values that should be plugged into
the prepared statement.

The prepared statement and values shown above would be issued by the following
inlines. The outer inline prepares the statement and the inner inline executes
it with specific values. Note that the inner inline does not contain any
``-database`` or ``-table`` parameters. These are inherited from the outer
inline so they don't need to be specified again. ::

   inline(
      -database='contacts',
      -prepare="INSERT INTO people (`first_name`, `last_name`) VALUES (?, ?);"
   ) => {
      inline(array('John', 'Doe'), -sql) => {}
   }

If the executed statement returns any values then those results can be inspected
within the inner inline. The inline with the ``-prepare`` action will not return
any results itself, but each inner inline with a ``-sql`` parameter may return a
result as if the full equivalent SQL statement were issued in that inline.

.. _MySQL documentation: http://dev.mysql.com/doc/
