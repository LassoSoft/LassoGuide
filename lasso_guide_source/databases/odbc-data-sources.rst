.. _odbc-data-sources:

.. direct from book

*****************
ODBC Data Sources
*****************

This chapter documents tags and behaviors which are specific to the ODBC
data source in Lasso. These data sources provide access to many data
sources which don’t have a native connector in Lasso. See the
appropriate chapter for information about other data sources including
:ref:`SQL Data Sources <sql-data-sources>` and :ref:`FileMaker Data
Sources <filemaker-data-sources>`.

-  **Overview** introduces the ODBC data source.
-  **Feature Matrix** includes a table which lists all of the features
   of each data source and highlights the differences between them.

Overview
--------

Native support for ODBC data sources is included in Lasso. This feature
allows Lasso to communicate with hundreds of ODBC compliant data
sources, including Sybase, DB2, Frontbase, Openbase, Interbase, and
Microsoft SQL Server. For more information on ODBC connectivity and
availability for a particular data source, see the data source
documentation or contact the data source manufacturer.

Lasso accesses ODBC drivers which are set up as System DSNs. The ODBC
Data Source Administrator utility or control panel should be used to
configure the driver as a System DSN, then the data source name is
entered into Lasso. See the ***Setting Up Data Sources*** chapter in the
***Lasso Setup Guide*** for additional detals.

.. _odbc-data-sources-table-1:

.. table:: Table 1: Data Sources

    +-----------+--------------------------------------------------+
    |Data Source|Description                                       |
    +===========+==================================================+
    |``ODBC``   |Support any data source with a compatible ODBC    |
    |           |driver set up as a System DSN. See the ***ODBC    |
    |           |Data Sources*** section in the ***Lasso Setup     |
    |           |Guide*** for details about how to install ODBC    |
    |           |drivers.                                          |
    +-----------+--------------------------------------------------+

Tips for Using ODBC Data Sources
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following is a list of tips to following when writing Lasso for use
with ODBC data sources.

These tips illustrate specific concepts and behaviors to keep in mind
when coding.

-  Always specify a primary key field using the ``-KeyField`` command
   tag in ``-Search``, ``-Add``, and ``-FindAll`` actions. This will
   ensure that the ``[KeyField_Value]`` tag will always return a value.
-  Use ``-KeyField`` and ``-KeyValue`` to reference a particular record
   for updates, duplicates, or deletes.
-  Fields may truncate any data beyond the length they are set up to
   store. Ensure that all fields in the accessed databases have
   sufficiently long fields for the values that need to be stored in
   them.
-  Use ``-ReturnField`` command tags to reduce the number of fields
   which are returned from a ``-Search`` action. Returning only the
   fields that need to be used for further processing or shown to the
   site visitor reduces the amount of data that needs to travel between
   Lasso Service and the ODBC data source.
-  When an ``-Add`` or ``-Update`` action is performed on a database,
   the data from the added or updated record is returned inside the
   ``[Inline] … [/Inline]`` tags. If the ``-ReturnField`` parameter is
   used, then only those fields specified should be returned from an
   ``-Add`` or ``-Update`` action. Setting ``-MaxRecords=0`` can be used
   as an indication that no record should be returned.
-  The ``-SQL`` command tag can be allowed or disallowed at the host
   level for users in Lasso Administration. Once the ``-SQL`` command
   tag is allowed for a user, that user may access any database within
   the allowed host inside of a SQL statement. For that reason, only
   trusted users should be allowed to issue SQL queries using the
   ``-SQL`` command tag. For more information, see the ***Setting Up
   Security*** chapter in the ***Lasso Professional 8 Setup Guide***.
-  SQL statements which are generated using visitor-defined data should
   be screened carefully for unwanted commands such as ``DROP`` or
   ``GRANT``. See the ***Setting Up Data Sources*** chapter of the
   ***Lasso Setup Guide*** for more information.
-  Always quote any inputs from site visitors that are incorporated into
   SQL statements. The ``[Encode_SQL]`` tag should be used on any
   visitor supplied values which are going to be passed to a MySQL data
   source. The ``[Encode_SQL92]`` tag should be used on any visitor
   supplies values which will be passed to another SQLbased data source
   such as SQLite or ODBC data sources.

Encoding the values ensures that quotes and other reserved characters
are properly escaped within the SQL statement. The tags also help to
prevent SQL injection attacks by ensuring that all of the characters
within the string value are treated as part of the value. Values from
``[Action_Param]``, ``[Cookie]``, ``[Token_Value]``, ``[Field]``, or
calculations which rely in part on values from any of these tags must be
encoded.

For example, the following ``SQL SELECT`` statement includes quotes
around the ``[Action_Param]`` value and uses ``[Encode_SQL92]`` to
encode the value. The apostrophe (single quote) within the name is
doubled so it will be embedded within the string rather than ending the
string literal.

::

    [Variable: 'SQL_Statement'='SELECT * FROM Contacts.People WHERE ' +
    'Company LIKE \'' + (Encode_SQL92: (Action_Param: 'Company')) + '\';'] 

If ``[Action_Param]`` returns ``McDonald's`` for ``First_Name`` then the
SQL statement generated by this code would appear as follows. Notice
that the apostrophe in the company name is doubled up.

::

    SELECT * FROM Contacts.People WHERE Company LIKE 'McDonald''s'; 

-  Lasso Professional 8 uses connection pooling when connecting to data
   sources via ODBC, and the ODBC connections will remain open during
   the time that Lasso Professional 8 is running.
-  Check for LassoSoft articles at `http://www.lassosoft.com/LassoDocs/
   <http://www.lassosoft.com/LassoDocs/>`_ for documented issues and
   data source set up instructions.

Feature Matrix
--------------

The following table details the features of each data source in this
chapter. Since some features are only available in certain data sources
it is important to check these tables when reading the documentation in
order to ensure that each data source supports your solutions required
features.


.. _odbc-data-sources-table-2:

.. table:: Table 2: ODBC Data Sources

    +--------------------------+--------------------------------------------------+
    |Feature                   |Description                                       |
    +==========================+==================================================+
    |``Friendly Name``         |Lasso Connector for ODBC                          |
    +--------------------------+--------------------------------------------------+
    |``Internal Name``         |odbc                                              |
    +--------------------------+--------------------------------------------------+
    |``Module Name``           |SQLConnector.dll, SQLConnector.dylib, or          |
    |                          |SQLConnector. so                                  |
    +--------------------------+--------------------------------------------------+
    |``Inline Host Attributes``|The ``-Name`` should specify the data source name |
    |                          |(System DSN). A ``-Username`` and ``-Password``   |
    |                          |may also be required.                             |
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

Using ODBC Data Sources
-----------------------

Data source operations outlined in the :ref:`Database Interaction
Fundamentals <database-interaction-fundamentals>`, :ref:`Searching and
Displaying Data <searching-and-displaying-data>`, and :ref:`Adding and
Updating Records <adding-and-updating-records>` chapters are supported
with ODBC data sources. Because ODBC is a standardized API for
connecting to tabular data sources, there are few unique tags in Lasso 8
that are specific to ODBC data sources or invoke special functions
specific to any ODBC data source.
