.. _sql-data-sources:

.. direct from book

****************
SQL Data Sources
****************

This chapter documents tags and behaviors which are specific to the SQL
data sources in Lasso. These include the data sources for MySQL, SQLite,
Oracle, OpenBase, PostgreSQL, and SQL Server. See the appropriate
chapter for information about other data sources including
:ref:`FileMaker Data Sources <filemaker-data-sources>` and :ref:`ODBC
:Data Sources <odbc-data-sources>`.

-  **Overview** introduces the SQL data sources and includes tips for
   working with the data sources.
-  **Feature Matrix** includes a table which lists all of the features
   of each SQL data source and highlights the differences between them.
-  **SQL Tags** describes tags specific to SQL data sources.
-  **Searching Records** describes unique search operations that can be
   performed using SQL data sources.
-  **Adding and Updating Records** describes unique add and update
   operations that can be performed using SQL data sources.
-  **Value Lists** describes how to retrieve and show lists of allowed
   field values for ``ENUM`` and ``SET`` fields in SQL data sources.

Overview
--------

This chapter documents tags and features unique to SQL data sources.
Most of the features of Lasso work equally across all data sources. The
differences specific to each SQL data source are noted in the features
matrix and in the descriptions of individual features.

.. _sql-data-sources-table-1:

.. table:: Table 1: Data Sources

    +--------------+--------------------------------------------------+
    |Data Source   |Description                                       |
    +==============+==================================================+
    |``MySQL``     |Supports MySQL 3.x, 4.x, or 5.x data sources.     |
    +--------------+--------------------------------------------------+
    |``OpenBase``  |Supports OpenBase data sources.                   |
    +--------------+--------------------------------------------------+
    |``Oracle``    |Supports Oracle data sources. The Oracle "Instant |
    |              |Client" libraries must be installed in order to   |
    |              |activate this data source. See the Oracle Data    |
    |              |Sources section in the Lasso Setup Guide for more |
    |              |information.                                      |
    +--------------+--------------------------------------------------+
    |``PostgreSQL``|Supports PostgreSQL data sources. The PostgreSQL  |
    |              |client libraries must be installed in order to    |
    |              |activate this data source. See the PostgreSQL Data|
    |              |Sources section in the Lasso Setup Guide for more |
    |              |information.                                      |
    +--------------+--------------------------------------------------+
    |``SQL Server``|Supports Microsoft SQL Server. The SQL Server     |
    |              |client libraries must be installed in order to    |
    |              |activate this data source. See the SQL Server Data|
    |              |Sources section in the Lasso Setup Guide for more |
    |              |information.                                      |
    +--------------+--------------------------------------------------+
    |``SQLite``    |SQLite is the internal data source which is used  |
    |              |for the storage of Lasso's preferences and        |
    |              |security settings.                                |
    +--------------+--------------------------------------------------+

**Tips for Using MySQL Data Sources**

-  Always specify a primary key field using the ``-KeyField`` command
   tag in ``-Search``, ``-Add``, and ``-Findall`` actions. This will
   ensure that the ``[KeyField_Value]`` tag will always return a value.
-  Use ``-KeyField`` and ``-KeyValue`` to reference a particular record
   for updates, duplicates, or deletes.
-  Data sources can be case-sensitive. For best results, reference
   database and table names in the same lettercase as they appear on
   disk in your Lasso code. Field names may also be case sensitive (such
   as in Oracle and PostgreSQL).
-  Most data sources will truncate any data beyond the length they are
   set up to store. Ensure that all fields have sufficient capacity for
   the values that need to be stored in them.
-  Use ``-ReturnField`` command tags to reduce the number of fields
   which are returned from a ``-Search`` action. Returning only the
   fields that need to be used for further processing or shown to the
   site visitor reduces the amount of data that needs to travel between
   Lasso Service and the data source.
-  When an ``-Add`` or ``-Update`` action is performed on a database,
   the data from the added or updated record is returned inside the
   ``[Inline] … [/Inline]`` tags. If the ``-ReturnField`` parameter is
   used, then only those fields specified should be returned from an
   ``-Add`` or ``-Update`` action. Setting ``-MaxRecords=0`` can be used
   as an indication that no record should be returned.
-  See the Site ***Administration Utilities*** chapter in the Lasso
   Professional 8 Setup Guide for information about optimizing tables
   for optimum performance and checking tables for damage.

**Security Tips**

-  The ``-SQL`` command tag can only be allowed or disallowed at the
   host level for users in Lasso Administration. Once the ``-SQL``
   command tag is allowed for a user, that user may access any database
   within the allowed host inside of a SQL statement. For that reason,
   only trusted users should be allowed to issue SQL queries using the
   ``-SQL`` command tag. For more information, see the ***Setting Up
   Security*** chapter in the Lasso Professional 8 Setup Guide.
-  SQL statements which are generated using visitor-defined data should
   be screened carefully for unwanted commands such as ``DROP`` or
   ``GRANT``. See the ***Setting Up Data Sources*** chapter of the Lasso
   Professional 8 Setup Guide for more information.
-  Always quote any inputs from site visitors that are incorporated into
   SQL statements. The ``[Encode_SQL]`` tag should be used on any
   visitor supplied values which are going to be passed to a MySQL data
   source. The ``[Encode_SQL92]`` tag should be used on any visitor
   supplies values which will be passed to another SQL-based data source
   such as SQLite or JDBC data sources.
   
   Encoding the values ensures that quotes and other reserved characters
   are properly escaped within the SQL statement. The tags also help to
   prevent SQL injection attacks by ensuring that all of the characters
   within the string value are treated as part of the value. Values from
   ``[Action_Param]``, ``[Cookie]``, ``[Token_Value]``, ``[Field]``, or
   calculations which rely in part on values from any of these tags must
   be encoded.

   For example, the following ``SQL SELECT`` statement includes quotes
   around the ``[Action_Param]`` value and uses ``[Encode_SQL]`` to
   encode the value. The apostrophe (single quote) within the name is
   escaped as \\' so it will be embedded within the string rather than
   ending the string literal.

   ::
    
       [Variable: 'SQL_Statement'='SELECT * FROM Contacts.People WHERE ' +
        'Company LIKE \'' + (Encode_SQL: (Action_Param: 'Company')) + '\';']

   If ``[Action_Param]`` returns ``McDonald's`` for ``First_Name`` then
   the SQL statement generated by this code would appear as follows.
   Notice that the apostrophe in the company name is escaped.

   ::

      SELECT * FROM Contacts.People WHERE Company LIKE 'McDonald\'s';

Feature Matrix
--------------

The following tables detail the features of each data source in this
chapter. Since some features are only available in certain data sources
it is important to check these tables when reading the documentation in
order to ensure that each data source supports your solutions required
features.

.. _sql-data-sources-table-2:

.. table:: Table 2: MySQL Data Source

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Connector for MySQL                         |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |mysqlds                                           |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |MySQLConnector.dll, MySQLConnector.dylib, or      |
    |                          |MySQLConnector.so                                 |
    +--------------------------+--------------------------------------------------+
    |``Inline Host Attributes``|Requires ``-Name`` specifying connection URL      |
    |                          |(i.e. mysql.example.com), ``-Username``, and      |
    |                          |``-Password``. Optional ``-Port`` defaults to     |
    |                          |``3306``.                                         |
    +--------------------------+--------------------------------------------------+
    |``Actions``               |``-Add``, ``-Delete``, ``-Exec``, ``-FindAll``,   |
    |                          |``-Prepare``, ``-Search``, ``-Show``, ``-SQL``,   |
    |                          |``-Update``                                       |
    +--------------------------+--------------------------------------------------+
    |``Operators``             |``-BW``, ``-CN``, ``-EQ``, ``-EW``, ``-FT``,      |
    |                          |``-GT``, ``-GTE``, ``-LT``, ``-LTE``, ``-NBW``,   |
    |                          |``-NCN``, ``-NEW``, ``-NRX``, ``-RX``,            |
    |                          |``-OpBegin``/``-OpEnd`` with ``And``, ``Or``,     |
    |                          |``Not``.                                          |
    +--------------------------+--------------------------------------------------+
    |``KeyField``              |``-KeyField``/``-KeyValue`` and ``-Key=(Array)``  |
    +--------------------------+--------------------------------------------------+

.. _sql-data-sources-table-3:

.. table:: Table 3: OpenBase Data Source

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Connector for OpenBase                      |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |openbaseds                                        |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |OpenBaseConnector.dll, OpenBaseConnector.dylib, or|
    |                          |OpenBaseConnector.so                              |
    +--------------------------+--------------------------------------------------+
    |``Inline Host Attributes``|Requires ``-Name`` specifying connection URL      |
    |                          |(i.e., ``openbase.example.com/database``),        |
    |                          |``-Username``, and ``-Password``.                 |
    +--------------------------+--------------------------------------------------+
    |``Actions``               |``-Add``, ``-Delete``, ``-FindAll``, ``-Search``, |
    |                          |``-Show``, ``-SQL``, ``-Update``                  |
    +--------------------------+--------------------------------------------------+
    |``Operators``             |``-BW``, ``-CN``, ``-EQ``, ``-EW``, ``-GT``,      |
    |                          |``-GTE``, ``-LT``, ``-LTE``, ``-NBW``, ``-NCN``,  |
    |                          |``-NEW``, ``-OpBegin``/``-OpEnd`` with ``And``,   |
    |                          |``Or``, ``Not``.                                  |
    +--------------------------+--------------------------------------------------+
    |``KeyField``              |``-KeyField``/``-KeyValue``                       |
    +--------------------------+--------------------------------------------------+

.. _sql-data-sources-table-4:

.. table:: Table 4: Oracle Data Source

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Connector for Oracle                        |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |oracle                                            |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |SQLConnector.dll, SQLConnector.dylib, or          |
    |                          |SQLConnector.so                                   |
    +--------------------------+--------------------------------------------------+
    |``Inline Host Attributes``|Requires ``-Name`` specifying connection URL      |
    |                          |(i.e., ``oracle.example.com:1521/mydatabase``),   |
    |                          |``-Username``, and ``-Password``.                 |
    +--------------------------+--------------------------------------------------+
    |``Actions``               |``-Add``, ``-Delete``, ``-FindAll``, ``-Search``, |
    |                          |``-Show``, ``-SQL``, ``-Update``                  |
    +--------------------------+--------------------------------------------------+
    |``Operators``             |``-BW``, ``-CN``, ``-EQ``, ``-EW``, ``-GT``,      |
    |                          |``-GTE``, ``-LT``, ``-LTE``, ``-NBW``, ``-NCN``,  |
    |                          |``-NEW``, ``-OpBegin``/``-OpEnd`` with ``And``,   |
    |                          |``Or``, ``Not``.                                  |
    +--------------------------+--------------------------------------------------+
    |``KeyField``              |``-KeyField``/``-KeyValue``                       |
    +--------------------------+--------------------------------------------------+

.. Note:: Field names are case sensitive. All field names and key field
    names within the inline must be specified with the proper case.

.. _sql-data-sources-table-5:

.. table:: Table 5: PostgreSQL Data Source

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Connector for PostgreSQL                    |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |postgresql                                        |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |SQLConnector.dll, SQLConnector.dylib, or          |
    |                          |SQLConnector.so                                   |
    +--------------------------+--------------------------------------------------+
    |``Inline Host Attributes``|Requires ``-Name`` specifying connection URL      |
    |                          |(i.e., ``postgresql.example.com``), ``-Username``,|
    |                          |and ``-Password``.                                |
    +--------------------------+--------------------------------------------------+
    |``Actions``               |``-Add``, ``-Delete``, ``-FindAll``, ``-Search``, |
    |                          |``-Show``, ``-SQL``, ``-Update``                  |
    +--------------------------+--------------------------------------------------+
    |``Operators``             |``-BW``, ``-CN``, ``-EQ``, ``-EW``, ``-GT``,      |
    |                          |``-GTE``, ``-LT``, ``-LTE``, ``-NBW``, ``-NCN``,  |
    |                          |``-NEW``, ``-OpBegin``/``-OpEnd`` with ``And``,   |
    |                          |``Or``, ``Not``.                                  |
    +--------------------------+--------------------------------------------------+
    |``KeyField``              |``-KeyField``/``-KeyValue``                       |
    +--------------------------+--------------------------------------------------+

.. Note:: Field names are case sensitive. All field names and key field
    names within the inline must be specified with the proper case.

.. _sql-data-sources-table-6:

.. table:: Table 6: Microsoft SQL Server Data Source

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Connector for SQL Server                    |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |sqlserver                                         |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |SQLConnector.dll, SQLConnector.dylib, or          |
    |                          |SQLConnector.so                                   |
    +--------------------------+--------------------------------------------------+
    |``Inline Host Attributes``|Requires ``-Name`` specifying connection URL      |
    |                          |(i.e., ``sqlserver.example.com\mydatabase``),     |
    |                          |``-Username``, and ``-Password``.                 |
    +--------------------------+--------------------------------------------------+
    |``Actions``               |``-Add``, ``-Delete``, ``-FindAll``, ``-Search``, |
    |                          |``-Show``, ``-SQL``, ``-Update``                  |
    +--------------------------+--------------------------------------------------+
    |``Operators``             |``-BW``, ``-CN``, ``-EQ``, ``-EW``, ``-GT``,      |
    |                          |``-GTE``, ``-LT``, ``-LTE``, ``-NBW``, ``-NCN``,  |
    |                          |``-NEW``, ``-OpBegin``/``-OpEnd`` with ``And``,   |
    |                          |``Or``, ``Not``.                                  |
    +--------------------------+--------------------------------------------------+
    |``KeyField``              |``-KeyField``/``-KeyValue``                       |
    +--------------------------+--------------------------------------------------+

.. _sql-data-sources-table-7:

.. table:: Table 7: SQLite Data Source

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Internal                                    |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |sqliteconnector                                   |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |Built-In                                          |
    +--------------------------+--------------------------------------------------+
    |``Actions``               |``-Add``, ``-Delete``, ``-FindAll``, ``-Search``, |
    |                          |``-Show``, ``-SQL``, ``-Update``                  |
    +--------------------------+--------------------------------------------------+
    |``Operators``             |``-BW``, ``-CN``, ``-EQ``, ``-EW``, ``-GT``,      |
    |                          |``-GTE``, ``-LT``, ``-LTE``, ``-NBW``, ``-NCN``,  |
    |                          |``-NEW``, ``-OpBegin``/``-OpEnd`` with ``And``,   |
    |                          |``Or``, ``Not``.                                  |
    +--------------------------+--------------------------------------------------+
    |``KeyField``              |``-KeyField``/``-KeyValue``                       |
    +--------------------------+--------------------------------------------------+

SQL Data Source Tags
--------------------

Lasso 8 includes tags to identify which type of MySQL data source is
being used. These tags are summarized in the following table.

.. _sql-data-sources-table-8:

.. table:: Table 8: SQL Data Source Tags

    +----------------------------------+--------------------------------------------------+
    |Tag                               |Description                                       |
    +==================================+==================================================+
    |``[Lasso_DatasourceIsMySQL]``     |Returns ``True`` if a database is hosted by       |
    |                                  |MySQL. Requires one string value, which is the    |
    |                                  |name of a database.                               |
    +----------------------------------+--------------------------------------------------+
    |``[Lasso_DatasourceIsOpenBase]``  |Returns ``True`` if a database is hosted by       |
    |                                  |OpenBase. Requires one string value, which is the |
    |                                  |name of a database.                               |
    +----------------------------------+--------------------------------------------------+
    |``[Lasso_DatasourceIsOracle]``    |Returns ``True`` if a database is hosted by       |
    |                                  |Oracle. Requires one string value, which is the   |
    |                                  |name of a database.                               |
    +----------------------------------+--------------------------------------------------+
    |``[Lasso_DatasourceIsPostgreSQL]``|Returns ``True`` if a database is hosted by       |
    |                                  |PostgreSQL. Requires one string value, which is   |
    |                                  |the name of a database.                           |
    +----------------------------------+--------------------------------------------------+
    |``[Lasso_DatasourceIsSQLServer]`` |Returns ``True`` if a database is hosted by       |
    |                                  |Microsoft SQL Server. Requires one string value,  |
    |                                  |which is the name of a database.                  |
    +----------------------------------+--------------------------------------------------+
    |``[Lasso_DatasourceIsSQLite]``    |Returns ``True`` if a database is hosted by       |
    |                                  |SQLite. Requires one string value, which is the   |
    |                                  |name of a database.                               |
    +----------------------------------+--------------------------------------------------+

**To check whether a database is hosted by MySQL:**

The following example shows how to use ``[Lasso_DatasourceIsMySQL]`` to
check whether the database Example is hosted by MySQL or not.

::

    [If: (Lasso_DatasourceIsMySQL: 'Example')]
        Example is hosted by MySQL!
    [Else]
        Example is not hosted by MySQL.
    [/If]

    ->
    Example is hosted by MySQL!

**To list all databases hosted by MySQL:**

Use the ``[Database_Names] … [/Database_Names]`` tags to list all
databases available to Lasso. The ``[Lasso_DatasourceIsMySQL]`` tag can
be used to check each database and only those that are hosted by MySQL
will be returned. The result shows two databases, ``Site`` and
``Example``, which are available through MySQL.

::

    [Database_Names]
        [If: (Lasso_DatasourceIsMySQL:(Database_NameItem))]
            <br>[Database_NameItem]
        [/If]
    [/Database_Names]
    
    ->
    <br>Example
    <br>Site

Searching Records
-----------------

In Lasso 8, there are unique search operations that can be performed
using MySQL data sources. These search operations take advantage of
special functions in MySQL such as full-text indexing, regular
expressions, record limits, and distinct values to allow optimal
performance and power when searching. These search operations can be
used on MySQL data sources in addition to all search operations
described in the :ref:`Searching and Displaying Data <searching-and-displaying-data>` chapter.

Search Field Operators
^^^^^^^^^^^^^^^^^^^^^^

Additional field operators are available for the ``-Operator`` (or ``-Op``)
tag when searching MySQL data sources. These operators are summarized in
:ref:`Table 2: MySQL Search Field Operators <sql-data-sources-table-2>`. Basic use of the ``-Operator`` tag is described in the :ref:`Searching and Displaying Data <searching-and-displaying-data>` chapter.

.. _sql-data-sources-table-9:

.. table:: Table 9: MySQL Search Field Operators

    +-------------------------+--------------------------------------------------+
    |Operator                 |Description                                       |
    +=========================+==================================================+
    |``-Op='ft'`` or ``-FT``  |Full-Text Search. If used, a MySQL full-text      |
    |                         |search is performed on the field specified. Will  |
    |                         |only work on fields that are full-text indexed in |
    |                         |MySQL. Records are automatically returned in order|
    |                         |of high relevance (contains many instances of that|
    |                         |value) to low relevance (contains few instances of|
    |                         |the value). Only one ft operator may be used per  |
    |                         |action, and no ``-SortField`` parameter should be |
    |                         |specified.                                        |
    +-------------------------+--------------------------------------------------+
    |``-Op='nrx'`` or ``-RX`` |Regular Expression. If used, then regular         |
    |                         |expressions may be used as part of the search     |
    |                         |field value. Returns records matching the regular |
    |                         |expression value for that field.                  |
    +-------------------------+--------------------------------------------------+
    |``-Op='nrx'`` or ``-NRX``|Not Regular Expression. If used, then regular     |
    |                         |expressions may be used as part of the search     |
    |                         |field value. Returns records that do not match the|
    |                         |regular expression value for that field.          |
    +-------------------------+--------------------------------------------------+

.. Note:: For more information on full-text searches and regular
    expressions supported in MySQL, see the MySQL documentation.

**To perform a full-text search on a field:**

If a MySQL field is indexed as full-text, then using ``-Op='ft'`` before
the field in a search inline performs a MySQL full text search on that
field. The example below performs a full text search on the ``Jobs``
field in the ``Contacts`` database, and returns the ``First_Name`` field
for each record that contain the word ``Manager``. Records that contain
the most instances of the word ``Manager`` are returned first.

::

    [Inline: -Search, -Database='Contacts', -Table='People',
        -Op='ft',
        'Jobs'='Manager']
        [Records]
            [Field:'First_Name']<br>
        [/Records]
    [/Inline]
    
    ->
    Mike<br>
    Jane<br>

**To use regular expressions as part of a search:**

Regular expressions can be used as part of a search value for a field by
using ``-Op='rx'`` before the field in a search inline. The following
example searches for all records where the ``Last_Name`` field contains
eight characters using a regular expression.

::

    [Inline: -Search, -Database='Contacts', -Table='People',
        -Op='rx',
        'Last_Name'='.{8}',
        -MaxRecords='All']
        [Records]
            [Field:'Last_Name'], [Field:'First_Name']<br>
        [/Records]
    [/Inline]

    ->
    Lastname, Mike<br>
    Lastname, Mary Beth<br>

The following example searches for all records where the ``Last_Name``
field doesn’t contain eight characters. This is easily accomplished
using the same inline search above using ``-Op='nrx'`` instead.

::

    [Inline: -Search, -Database='Contacts', -Table='People',
        -Op='nrx',
        'Last_Name'='.{8}',
        -MaxRecords='All']
        [Records]
            [Field:'Last_Name'], [Field:'First_Name']<br>
        [/Records]
    [/Inline]

    ->
    Doe, John<br>
    Doe, Jane<br>
    Surname, Bob<br>
    Surname, Jane<br>
    Surname, Margaret<br>
    Unknown, Thomas<br>

Search Command Tags
^^^^^^^^^^^^^^^^^^^

Additional search command tags are available when searching the data
sources in this chapter using the ``[Inline]`` tag. These tags allow
special search functions to be performed without writing SQL statements.
These operators are summarized in the following table.

.. _sql-data-sources-table-10:

.. table:: Table 10: Search Command Tags

    +---------------+--------------------------------------------------+
    |Tag            |Description                                       |
    +===============+==================================================+
    |``-UseLimit``  |Prematurely ends a ``-Search`` or ``-FindAll``    |
    |               |action once the specified number of records for   |
    |               |the ``-MaxRecords`` tag have been found and       |
    |               |returns the found records. Requires the           |
    |               |``-MaxRecords`` tag. This issues a ``LIMIT`` or   |
    |               |``TOP`` statement.                                |
    +---------------+--------------------------------------------------+
    |``-SortRandom``|Sorts returned records randomly. Is used in place |
    |               |of the ``-SortField`` and ``-SortOrder``          |
    |               |parameters. Does not require a value.             |
    +---------------+--------------------------------------------------+
    |``-Distinct``  |Causes a ``-Search`` action to only output records|
    |               |that contain unique field values (comparing only  |
    |               |returned fields). Does not require a value. May be|
    |               |used with the ``-ReturnField`` parameter to limit |
    |               |the fields checked for distinct values.           |
    +---------------+--------------------------------------------------+
    |``-GroupBy``   |Specifies a field name which should by used as the|
    |               |``GROUP BY`` statement. Allows data to be         |
    |               |summarized based on the values of the specified   |
    |               |field.                                            |
    +---------------+--------------------------------------------------+

**To immediately return records once a limit is reached:**

Use the ``-UseLimit`` tag in the search inline. Normally, Lasso will
find all records that match the inline search criteria and then pair
down the results based on ``-MaxRecords`` and ``-SkipRecords`` values.
The ``-UseLimit`` tag instructs the data source to terminate the
specified search process once the number of records specified for
``-MaxRecords`` is found. The following example searches the
``Contacts`` database with a limit of five records.

::

    [Inline: -FindAll,
        -Database='Contacts', -Table='People',
        -MaxRecords='5',
        -UseLimit]
        [Found_Count]
    [/Inline]

    -> 5

.. Note:: If the ``-UseLimit`` tag is used, the value of the
    ``[Found_Count]`` tag will always be the same as the ``-MaxRecords``
    value if the limit is reached. Otherwise, the ``[Found_Count]`` tag
    will return the total number of records in the specified table that
    match the search criteria if ``-UseLimit`` is not used.

**To sort results randomly:**

Use the ``-SortRandom`` tag in a search inline. The following example
finds all records and sorts first by last name then randomly.

::

    [Inline: -FindAll, -Database='Contacts', -Table='People',
        -Keyfield='ID',
        -SortRandom]
        [Records]
            [Field:'ID']
        [/Records]
    [/Inline]

    ->
    5 2 8 1 3 6 4 7

.. Note:: Due to the nature of the ``-SortRandom`` tag, the results of
    this example will vary upon each execution of the inline.

**To return only unique records in a search:**

Use the ``-Distinct`` parameter in a search inline. The following
example only returns records that contain distinct values for the
``Last_Name`` field.

::

    [Inline: -FindAll, -Database='Contacts', -Table='People',
        -ReturnField='Last_Name',
        -Distinct]
        [Records]
            [Field:'Last_Name']<br>
        [/Records]
    [/Inline]

    ->
    Doe<br>
    Surname<br>
    Lastname<br>
    Unknown<br>

The ``-Distinct`` tag is especially useful for generating lists of
values that can be used in a pull-down menu. The following example is a
pull-down menu of all the last names in the ``Contacts`` database.

::

    [Inline: -Findall, -Database='Contacts', -Table='People',
        -ReturnField='Last_Name',
        -Distinct]
        <select name="Last_Name">
            [Records]
                <option value="[Field: 'Last_Name']">
                    [Field: 'Last_Name']
                </Option>
            [/Records]
        </Select>
    [/Inline]

Searching Null Values
^^^^^^^^^^^^^^^^^^^^^

When searching tables in a SQL data source, ``NULL`` values may be
explicitly searched for within fields using the ``[Null]`` tag. A
``NULL`` value in a SQL data source designates that there is no other
value stored in that particular field. This is similar to searching a
field for an empty string (e.g. ``'fieldname'=''``), however ``NULL``
values and empty strings are not the same in SQL data sources. For more
information about ``NULL`` values, see the documentation for the data
source.

::

    [Inline: -Search,
        -Database='Contacts', -Table='People',
        -Op='eq',
        'Title'=(Null),
        -MaxRecords='All']
        [Records]
            Record [Field:'ID'] does not have a title.<br>
        [/Records]
    [/Inline]

    ->
    Record 7 does not have a title.<br>
    Record 8 does not have a title.<br>

Adding and Updating Records
---------------------------

In Lasso 8, there are special add and update operations that can be
performed using SQL data sources in addition to all add and update
operations described in the :ref:`Adding and Updating Records
<adding-and-updating-records>` chapter.

Multiple Field Values
^^^^^^^^^^^^^^^^^^^^^

When adding or updating data to a field in MySQL, the same field name
can be used several times in an ``-Add`` or ``-Update`` inline. The
result is that all data added or updated in each instance of the field
name will be concatenated in a comma-delimited form. This is
particularly useful for adding data to ``SET`` field types.

**To add or update multiple values to a field:**

The following example adds a record with two comma delimited values in
the ``Jobs`` field:

::

    [Inline: -Add, -Database='Contacts', -Table='People',
        -KeyField='ID',
        'Jobs'='Customer Service',
        'Jobs'='Sales']
        [Field:'Jobs']
    [/Inline]

    ->
    Customer Service, Sales

The following example updates the ``Jobs`` field of a record with three
comma-delimited values:

::

    [Inline: -Update, -Database='Contacts', -Table='People',
        -KeyField='ID',
        -KeyValue='5',
        'Jobs'='Customer Service',
        'Jobs'='Sales',
        'Jobs'='Support']
        [Field:'Jobs']
    [/Inline]

    ->
    Customer Service, Sales, Support

.. Note:: The individual values being added or updated should not
    contain commas.

Adding or Updating Null Values
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``NULL`` values can be explicitly added to fields using the ``[Null]``
tag. A ``NULL`` value in a SQL data source designates that there is no
value for a particular field. This is similar to setting a field to an
empty string (e.g. ``'fieldname'=''``), however the two are different in
SQL data sources. For more information about ``NULL`` values, see the
data source documentation.

**To add or update a null value to a field:**

Use the ``[Null]`` tag as the field value. The following example adds a
record with a ``NULL`` value in the ``Last_Name`` field.

::

    [Inline: -Add, -Database='Contacts', -Table='People',
        -KeyField='ID',
        'Last_Name'=(Null)]
    [/Inline]

The following example updates a record with a ``NULL`` value in the
``Last_Name`` field.

::

    [Inline: -Update, -Database='Contacts', -Table='People',
        -KeyField='ID',
        -KeyValue='5',
        'Last_Name'=(Null)]
    [/Inline] 

Value Lists
-----------

A value list in Lasso is a set of possible values that can be used for a
field. Value lists in MySQL are lists of pre-defined and stored values
for a ``SET`` or ``ENUM`` field type. A value list from a ``SET`` or
``ENUM`` field can be displayed using the tags defined in :ref:`Table 4:
MySQL Value List Tags <sql-data-sources-table-4>`. None of these tags
will work in ``-SQL`` inlines or if ``-NoValueLists`` is specified.

.. _sql-data-sources-table-11:

.. table:: Table 11: MySQL Value List Tags

    +--------------------------------+--------------------------------------------------+
    |Tag                             |Description                                       |
    +================================+==================================================+
    |``[Value_List] … [/Value_List]``|Container tag repeats each value allowed for      |
    |                                |``ENUM`` or ``SET`` fields. Requires a single     |
    |                                |parameter: the name of an ``ENUM`` or ``SET``     |
    |                                |field from the current table. This tag will not   |
    |                                |work in ``-SQL`` inlines or if ``-NoValueLists``  |
    |                                |is specified.                                     |
    +--------------------------------+--------------------------------------------------+
    |``[Value_ListItem]``            |Returns the value for the current item in a value |
    |                                |list. Optional ``-Checked`` or ``-Selected``      |
    |                                |parameter returns only values currently contained |
    |                                |in the ``ENUM`` or ``SET`` field.                 |
    +--------------------------------+--------------------------------------------------+
    |``[Selected]``                  |Displays the word Selected if the current value   |
    |                                |list item is contained in the data of the ``ENUM``|
    |                                |or ``SET`` field.                                 |
    +--------------------------------+--------------------------------------------------+
    |``[Checked]``                   |Displays the word Checked if the current value    |
    |                                |list item is contained in the data of the ``ENUM``|
    |                                |or ``SET`` field.                                 |
    +--------------------------------+--------------------------------------------------+
    |``[Option]``                    |Generates a series of ``<option> … </option>``    |
    |                                |tags for the value list. Requires a single        |
    |                                |parameter: the name of an ``ENUM`` or ``SET``     |
    |                                |field from the current table.                     |
    +--------------------------------+--------------------------------------------------+

.. Note:: See the :ref:`Searching and Displaying Data
    <searching-and-displaying-data>` chapter for information about the
    ``-Show`` command tag which is used throughout this section.

**To display values for an ENUM or SET field:**

-  Perform a ``-Show`` action to return the schema of a MySQL database
   and use the ``[Value_List]`` tag to display the allowed values for an
   ``ENUM`` or ``SET`` field. The following example shows how to display
   all values from the ``ENUM`` field ``Title`` in the ``Contacts``
   database. ``SET`` field value lists function in the same manner as
   ``ENUM`` value lists, and all examples in this section may be used
   with either ``ENUM`` or ``SET`` field types.

   ::

       [Inline: -Show, -Database='Contacts', -Table='People']
           [Value_List: 'Title']
               <br>[Value_ListItem]
           [/Value_List]
       [/Inline]

       ->
       <br>Mr.
       <br>Mrs.
       <br>Ms.
       <br>Dr.

-  The following example shows how to display all values from a value
   list using a named inline. The same name ``Values`` is referenced by
   ``-InlineName`` in both the ``[Inline]`` tag and ``[Value_List]`` tag.

   ::

       [Inline: -InlineName='Values', -Show, -Database='Contacts', -Table='People']
       [/Inline]
       …
       [Value_List: 'Title', -InlineName='Values']
           <br>[Value_ListItem]
       [/Value_List]

       ->
       <br>Mr.
       <br>Mrs.
       <br>Ms.
       <br>Dr.

**To display an HTML pop-up menu in an -Add form with all values from a
value list:**

-  The following example shows how to format an HTML ``<select> …
   </select>`` pop-up menu to show all the values from a value list. A
   select list can be created with the same code by including size
   and/or multiple parameters within the ``<select>`` tag. This code is
   usually used within an HTML form that performs an ``-Add`` action so
   the visitor can select a value from the value list for the record
   they create.

   The example shows a single ``<select> …</select>`` within ``[Inline]
   … [/Inline]`` tags with a ``-Show`` command. If many value lists from
   the same database are being formatted, they can all be contained
   within a single set of ``[Inline] … [/Inline]`` tags.

   ::

       <form action="response.lasso" method="POST">
           <input type="hidden" name="-Add" value="">
           <input type="hidden" name="-Database" value="Contacts">
           <input type="hidden" name="-Table" value="People">
           <input type="hidden" name="-KeyField" value="ID">

       [Inline: -Show, -Database='Contacts', -Table='People']
           <select name="Title">
               [Value_List: 'Title']
                   <option value="[Value_ListItem]">[Value_ListItem]</option>
               [/Value_List]
           </select>
       [/Inline]

           <p><input type="submit" name="-Add" value="Add Record"></p>
       </form>

-  The ``[Option]`` tag can be used to easily format a value list as an
   HTML ``<select> … </select>`` pop-up menu. The ``[Option]`` tag
   generates all of the ``<option> … </option>`` tags for the pop-up
   menu based on the value list for the specified field. The example
   below generates exactly the same HTML as the example above.

   ::

       <form action="response.lasso" method="POST">
           <input type="hidden" name="-Add" value="">
           <input type="hidden" name="-Database" value="Contacts">
           <input type="hidden" name="-Table" value="People">
           <input type="hidden" name="-KeyField" value="ID">

       [Inline: -Show, -Database='Contacts', -Table='People']
           <select name="Title">
               [Option: 'Title']
           </select>
       [/Inline]
    
           <p><input type="submit" name="-Add" value="Add Record"></p>
       </form>

**To display HTML radio buttons with all values from a value list:**

The following example shows how to format a set of HTML ``<input>`` tags
to show all the values from a value list as radio buttons. The visitor
will be able to select one value from the value list. Check boxes can be
created with the same code by changing the type from radio to checkbox.

::

    <form action="response.lasso" method="POST">
        <input type="hidden" name="-Add" value="">
        <input type="hidden" name="-Database" value="Contacts">
        <input type="hidden" name="-Table" value="People">
        <input type="hidden" name="-KeyField" value="ID">

    [Inline: -Show, -Database='Contacts', -Table='People']
        [Value_List: 'Title']
            <input type="radio" name="Title" value="[Value_ListItem]"> [Value_ListItem]
        [/Value_List]
    [/Inline]

        <p><input type="submit" name="-Add" value="Add Record"></p>
    </form>

**To display only selected values from a value list:**

The following examples show how to display the selected values from a
value list for the current record. The record for ``John Doe`` is found
within the database and the selected value for the ``Title`` field,
``Mr.`` is displayed.

-  The ``-Selected`` keyword in the ``[Value_ListItem]`` tag ensures
   that only selected value list items are shown. The following example
   uses a conditional to check whether ``[Value_ListItem: -Selected]``
   is empty.

   ::

       [Inline: -Search, -Database='Contacts', -Table='People',
           -KeyField='ID',
           -KeyValue=126]
           [Value_List: 'Title']
               [If: (Value_ListItem: -Selected) != '']
                   <br>[Value_ListItem: -Selected]
               [/If]
           [/Value_List]
       [/Inline]

       ->
       <br>Mr.

-  The ``[Selected]`` tag ensures that only selected value list items
   are shown. The following example uses a conditional to check whether
   ``[Selected]`` is empty and only shows the ``[Value_ListItem]`` if it
   is not.

   ::

       [Inline: -Search, -Database='Contacts', -Table='People',
           -KeyField='ID',
           -KeyValue=126]
           [Value_List: 'Title']
               [If: (Selected) != '']
                   <br>[Value_ListItem]
               [/If]
           [/Value_List]
       [/Inline]

       ->
       <br>Mr.

-  The ``[Field]`` tag can also be used simply to display the current
   value for a field without reference to the value list.

   ::

       <br>[Field: 'Title']

       ->
       <br>Mr.

**To display an HTML pop-up menu in an -Update form with selected value
list values:**

-  The following example shows how to format an HTML ``<select> …
   </select>`` select list to show all the values from a value list with
   the selected values highlighted. The ``[Selected]`` tag returns
   ``Selected`` if the current value list item is selected in the
   database or nothing otherwise. This code will usually be used in an
   HTML form that performs an ``-Update`` action to allow the visitor to
   see what values are selected in the database currently and make
   different choices for the updated record.

   ::

       <form action="response.lasso" method="POST">
           <input type="hidden" name="-Update" value="">
           <input type="hidden" name="-Database" value="Contacts">
           <input type="hidden" name="-Table" value="People">
           <input type="hidden" name="-KeyField" value="ID">
           <input type="hidden" name="-KeyValue" value="127">

       [Inline: -Search, -Database='Contacts', -Table='People',
           -KeyField='ID',
           -KeyValue=126]
           <select name="Title" multiple size="4">
               [Value_List: 'Title']
                   <option value="[Value_ListItem]" [Selected]>[Value_ListItem]</option>
               [/Value_List]
           </select>
       [/Inline]

           <input type="submit" name="-Update" value="Update Record">
       </form>

-  The ``[Option]`` tag automatically inserts ``Selected`` parameters as
   needed to ensure that the proper options are selected in the HTML
   select list. The example below generates exactly the same HTML as the
   example above.

   ::

       <form action="response.lasso" method="POST">
           <input type="hidden" name="-Update" value="">
           <input type="hidden" name="-Database" value="Contacts">
           <input type="hidden" name="-Table" value="People">
           <input type="hidden" name="-KeyField" value="ID">
           <input type="hidden" name="-KeyValue" value="127">

       [Inline: -Search, -Database='Contacts', -Table='People',
           -KeyField='ID',
           -KeyValue=126]
           <select name="Title" multiple size="4">
               [Option: 'Title']
           </select>
       [/Inline]

           <input type="submit" name="-Update" value="Update Record">
       </form> 

**To display HTML check boxes with selected value list values:**

The following example shows how to format a set of HTML ``<input>`` tags
to show all the values from a value list as check boxes with the
selected check boxes checked. The ``[Checked]`` tag returns ``Checked``
if the current value list item is selected in the database or nothing
otherwise. Radio buttons can be created with the same code by changing
the type from ``checkbox`` to ``radio``.

::

    <form action="response.lasso" method="POST">
        <input type="hidden" name="-Update" value="">
        <input type="hidden" name="-Database" value="Contacts">
        <input type="hidden" name="-Table" value="People">
        <input type="hidden" name="-KeyField" value="ID">
        <input type="hidden" name="-KeyValue" value="127">
    
    [Inline: -Search, -Database='Contacts', -Table='People',
        -KeyField='ID',
        -KeyValue=126]
        [Value_List: 'Title']
            <input type="checkbox" name="Title" value="[Value_ListItem]" [Checked]>
                [Value_ListItem]
        [/Value_List]
    [/Inline]

        <input type="submit" name="-Update" value="Update Record">
    </form>

.. Note:: Storing multiple values is only supported using ``SET`` field
    types.
