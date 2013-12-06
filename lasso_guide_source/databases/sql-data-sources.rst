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
   ``-bw``, ``-cn``, ``-eq``, ``-ew``, ``-ft``, ``-gt``, ``-gte``, ``-lt``,
   ``-lte``, ``-nbw``, ``-ncn``, ``-new``, ``-nrx``, ``-rx``,
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
   ``-search``, ``-add``, and ``-findall`` actions. This will ensure that the
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

      local(sql_statement) = "SELECT * FROM contacts.people WHERE " +
         "company LIKE '" + string(web_request->param('company'))->encodeSql + "%'"

   If ``web_request->param('company')`` returns "McDonald's" then the SQL
   statement generated by this code would appear as follows:

   .. code-block:: sql

      SELECT * FROM Contacts.People WHERE Company LIKE 'McDonald\'s'


SQL Data Source Methods
=======================

Lasso 9 includes methods to identify which type of SQL data source is being
used. These methods are summarized below.

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
      "Example is hosted by MySQL!"
   else
      "Example is not hosted by MySQL."
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
            `<br />` + database_nameItem
      /if
   /database_names

   // =>
   // <br />example
   // <br />site


Searching Records with MySQL
============================

In Lasso 9, there are unique search operations that can be performed using MySQL
data sources. These search operations take advantage of special functions in
MySQL such as full-text indexing, regular expressions, record limits, and
distinct values to allow optimal performance and power when searching. These
search operations can be used on MySQL data sources in addition to all search
operations described in the :ref:`searching-displaying` chapter.


Search Field Operators
----------------------

Additional field operators are available for the ``-operator`` (or ``-op``)
parameter when searching MySQL data sources. These operators are summarized in
the table below. Basic use of the ``-operator`` parameter is described in the
:ref:`searching-displaying` chapter.

.. tabularcolumns:: |l|L|

.. _sql-mysql-search-operators:

.. table:: MySQL Search Field Operators

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
   ``-op='nrx'`` or ``-rx``  Regular Expression. If used, then regular
                             expressions may be used as part of the search field
                             value. Returns records matching the regular
                             expression value for that field.
   ``-op='nrx'`` or ``-nrx`` Not Regular Expression. If used, then regular
                             expressions may be used as part of the search field
                             value. Returns records that do not match the
                             regular expression value for that field.
   ========================= ===================================================

.. note::
   For more information on full-text searches and the regular expressions
   supported in MySQL, see the MySQL documentation.


Perform a Full-Text Search on a Field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a MySQL field is indexed as full-text, then using ``-op='ft'`` before the
field in a search inline performs a MySQL full-text search on that field. The
example below performs a full-text search on the "jobs" field in the "contacts"
database, and returns the "first_name" field for each record that contain the
word "Manager". Records that contain the most instances of the word "Manager"
are returned first. ::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -op='ft', 'jobs'='Manager'
   )]
      [records]
         [field('first_name')]<br />
      [/records]
   [/inline]

   // =>
   // Mike<br />
   // Jane<br />


Use Regular Expressions as Part of a Search
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Regular expressions can be used as part of a search value for a field by using
``-op='rx'`` before the field in a search inline. The following example searches
for all records where the "last_name" field contains eight characters using a
regular expression::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -op='rx',
      'last_name'='.{8}',
      -maxRecords='all'
   )]
      [records]
         [field('last_name')], [field('first_name')]<br />
      [/records]
   [/inline]

   // =>
   // Lastname, Mike<br />
   // Lastname, Mary Beth<br />

The following example searches for all records where the "last_name" field
doesn't contain eight characters. This is easily accomplished using the same
inline search above using ``-op='nrx'`` instead. ::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -op='nrx',
      'last_name'='.{8}',
      -maxRecords='all'
   )]
      [records]
         [field('last_name')], [field('first_name')]<br />
      [/records]
   [/inline]

   // =>
   // Doe, John<br />
   // Doe, Jane<br />
   // Surname, Bob<br />
   // Surname, Jane<br />
   // Surname, Margaret<br />
   // Unknown, Thomas<br />


Search Keyword Parameters
-------------------------

Additional search keyword parameters are available when searching the data
sources in this chapter using the `inline` method. These parameters are
summarized in the following table.

.. tabularcolumns:: |l|L|

.. _sql-search-parameters:

.. table:: Search Parameters

   =============== =============================================================
   Parameter       Description
   =============== =============================================================
   ``-useLimit``   Prematurely ends a ``-search`` or ``-findAll`` action once
                   the specified number of records for the ``-maxRecords``
                   parameter have been found and returns the found records.
                   Requires the ``-maxRecords`` parameter. This issues a "LIMIT"
                   or "TOP" statement.
   ``-sortRandom`` Sorts returned records randomly. Is used in place  of the
                   ``-sortField`` and ``-sortOrder`` parameters. Does not
                   require a value.
   ``-distinct``   Causes a ``-search`` action to only output records that
                   contain unique field values (comparing only returned fields).
                   Does not require a value. May be used with the
                   ``-returnField`` parameter to limit the fields checked for
                   distinct values.
   ``-groupBy``    Specifies a field name that should by used as the "GROUP BY"
                   statement. Allows data to be summarized based on the values
                   of the specified field.
   =============== =============================================================


Return Records Once a Limit is Reached
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-useLimit`` parameter in the search inline. Normally, Lasso will find
all records that match the inline search criteria and then pare down the results
based on ``-maxRecords`` and ``-skipRecords`` values. The ``-useLimit``
parameter instructs the data source to terminate the specified search process
once the number of records specified for ``-maxRecords`` is found. The following
example searches the "contacts" database with a limit of five records::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -maxRecords='5',
      -useLimit
   )
      found_count
   /inline

   // => 5

.. note::
   If the ``-useLimit`` parameter is used, the value of the `found_count` method
   will always be the same as the ``-maxRecords`` value if the limit is reached.
   Otherwise, the `found_count` method will return the total number of records
   in the specified table that match the search criteria if ``-useLimit`` is not
   used.


Sort Results Randomly
^^^^^^^^^^^^^^^^^^^^^

Use the ``-sortRandom`` parameter in a search inline. The following example
finds all records and sorts them randomly::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id',
      -sortRandom
   )
      records
         field('id')
      /records
   /inline

   // => 5 2 8 1 3 6 4 7

.. note::
   Due to the nature of the ``-sortRandom`` parameter, the results of this
   example will vary upon each execution of the inline.


Return Only Unique Records in a Search
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-distinct`` parameter in a search inline. The following example only
returns records that contain distinct values for the "last_name" field::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -returnField='last_name',
      -distinct
   )
      records
         field('last_name') + '<br />\n'
      /records
   /inline

   // =>
   // Doe<br />
   // Surname<br />
   // Lastname<br />
   // Unknown<br />

The ``-distinct`` parameter is especially useful for generating lists of values
that can be used in a drop-down list. The following example is a drop-down list
of all the last names in the "contacts" database::

   [inline(
      -findAll,
      -database='contacts',
      -table='people',
      -returnField='last_name',
      -distinct
   )]
      <select name="last_name">
      [records]
         <option value="[field('last_name')]">[field('last_name')]</option>
      [/records]
      </select>
   [/inline]

   // =>
   // <select name="last_name">
   //    <option value="Doe">Doe</option>
   //    <option value="Surname">Surname</option>
   //    <option value="Lastname">Lastname</option>
   //    <option value="Unknown">Unknown</option>
   // </select>


Searching for Null Values
-------------------------

When searching tables in a SQL data source, "NULL" values may be explicitly
searched for within fields using the :type:`null` object. A "NULL" value in a
SQL data source designates that there is no other value stored in that
particular field. This is similar to searching a field for an empty string (e.g.
``'fieldname'=''``), however "NULL" values and empty strings are not the same in
SQL data sources. For more information about "NULL" values, see the
documentation for the data source. ::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -op='eq',
      'title'=null,
      -maxRecords='all'
   )]
      [records]
         record [field('id')] does not have a title.<br />
      [/records]
   [/inline]

   // =>
   // Record 7 does not have a title.<br />
   // Record 8 does not have a title.<br />


Adding and Updating Records
===========================

In Lasso 9, there are special add and update operations that can be performed
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
   )
      field('jobs')
   /inline

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
   )
      field('jobs')
   /inline

   // => Customer Service,Sales,Support

.. note::
   The individual values being added or updated should not contain commas.


Null Values
-----------

"NULL" values can be explicitly added to fields using the :type:`null` object. A
"NULL" value in a SQL data source designates that there is no value for a
particular field. This is similar to setting a field to an empty string (e.g.
``'fieldname'=''``), however the two are different in SQL data sources. For more
information about "NULL" values, see the data source documentation.


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
"title" in the "contacts" database. "SET" fields function in the same manner as
"ENUM" fields, and all examples in this section may be used with either "ENUM"
or "SET" field types. ::

   [inline(-show, -database='contacts', -table='people')]
      [value_list('title')]
         <br />[value_listItem]
      [/value_list]
   [/inline]

   // =>
   // <br />Mr.
   // <br />Mrs.
   // <br />Ms.
   // <br />Dr.

The following example shows how to display all values from a value list using a
named inline. The same name "values" is referenced by ``-inlineName`` in both
the `inline` method and `resultSet` method. ::

   inline(-inlineName='values', -show, -database='contacts', -table='people') => {}
   // ... some code ...
   resultSet(1, -inlineName='values')
      value_list('title')
         '<br />' + value_listItem
      /value_list
   /resultSet

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

   <form action="response.lasso" method="POST">
   [inline(-show, -database='contacts', -table='people')]
      <select name="title">
      [value_list('title')]
         <option value="[value_listItem]">[value_listItem]</option>
      [/value_list]
      </select>
   [/inline]

      <p><input type="submit" name="submit" value="Add Record"></p>
   </form>

   // =>
   // <form action="response.lasso" method="POST">
   //    <select name="title">
   //       <option value="Mr.">Mr.</option>
   //       <option value="Mrs.">Mrs.</option>
   //       <option value="Ms.">Ms.</option>
   //       <option value="Dr.">Dr.</option>
   //    </select>
   //    <p><input type="submit" name="submit" value="Add Record"></p>
   // </form>


Display Radio Buttons with All Values from a Value List
-------------------------------------------------------

The following example shows how to format a set of HTML ``<input>`` tags to show
all the values from a value list as radio buttons. The visitor will be able to
select one value from the value list. Checkboxes can be created with the same
code by changing the type from radio to checkbox. ::

   <form action="response.lasso" method="POST">
   [inline(-show, -database='contacts', -table='people')]
   [value_list('title')]
      <input type="radio" name="title" value="[value_listItem]" /> [value_listItem]
   [/value_list]
   [/inline]

      <p><input type="submit" name="submit" value="Add Record"></p>
   </form>

   // =>
   // <form action="response.lasso" method="POST">
   //    <input type="radio" name="title" value="Mr." /> Mr.
   //    <input type="radio" name="title" value="Mrs." /> Mrs.
   //    <input type="radio" name="title" value="Ms." /> Ms.
   //    <input type="radio" name="title" value="Dr." /> Dr.
   //
   //    <p><input type="submit" name="submit" value="Add Record"></p>
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
   )
      value_list('title')
         if(selected != '')
            '<br />' + value_listItem
         /if
      /value_list
   /inline

   // => <br />Mr.

The `field` method can also be used simply to display the current value for a
field without reference to the value list. ::

   <br />[field('title')]

   // => <br />Mr.


Display a Drop-Down Menu with Selected Values from a Value List
---------------------------------------------------------------

The following example shows how to format an HTML ``<select>`` list to show all
the values from a value list with the selected values highlighted. The
`selected` method returns "selected" if the current value list item is selected
in the database or nothing otherwise. ::

   <form action="response.lasso" method="POST">
   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=126
   )]
      <select name="title" multiple size="4">
      [value_list('title')]
         <option value="[value_listItem]" [selected]>[value_listItem]</option>
      [/value_list]
      </select>
   [/inline]
      <input type="submit" name="submit" value="Update Record">
   </form>

   // =>
   // <form action="response.lasso" method="POST">
   //    <select name="title" multiple size="4">
   //       <option value="Mr." selected>Mr.</option>
   //       <option value="Mrs." >Mrs.</option>
   //       <option value="Ms." >Ms.</option>
   //       <option value="Dr." >Dr.</option>
   //    </select>
   //    <input type="submit" name="submit" value="Update Record">
   // </form>


Display Checkboxes with Selected Values from a Value List
---------------------------------------------------------

The following example shows how to format a set of HTML ``<input>`` tags to show
all the values from a value list as checkboxes with the selected checkboxes
checked. The `checked` method returns "checked" if the current value list item
is selected in the database or nothing otherwise. Radio buttons can be created
with the same code by changing the type from "checkbox" to "radio". ::

   <form action="response.lasso" method="POST">
   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=126
   )]
   [value_list('title')]
      <input type="checkbox" name="title" value="[value_listItem]" [checked]>
      [value_listItem]
   [/value_list]
   [/inline]
      <input type="submit" name="submit" value="Update Record">
   </form>

   // =>
   // <form action="response.lasso" method="POST">
   //    <input type="checkbox" name="title" value="Mr." checked>
   //    Mr.
   //    <input type="checkbox" name="title" value="Mrs." >
   //    Mrs.
   //    <input type="checkbox" name="title" value="Ms." >
   //    Ms.
   //    <input type="checkbox" name="title" value="Dr." >
   //    Dr.
   //    <input type="submit" name="submit" value="Update Record">
   // </form>

.. note::
   Storing multiple values is only supported using "SET" field types.
