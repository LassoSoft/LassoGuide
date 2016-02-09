.. _searching-displaying:

*****************************
Searching and Displaying Data
*****************************

Lasso provides several parameters for the `inline` method for retrieving records
within Lasso-compatible databases. These parameters are used in conjunction with
name/value pair parameters in order to perform the desired database action in a
specific database and table or within a specific record.

The `inline` action parameters documented in this chapter are listed below. The
sections that follow describe the additional keyword and pair parameters
required for each database action.

``-search``
   Searches for records within a database.

``-findAll``
   Finds all records within a database.

``-random``
   Returns a random record from a database. (Only works with FileMaker Server
   databases.)


How Searches are Performed
==========================

The following describes each step that takes place every time a search is
performed using Lasso:

#. Lasso checks the database, table, and field name specified in the search to
   verify that they are all valid.
#. The search query is formatted and sent to the database application. FileMaker
   Server search queries are formatted as URLs and submitted to the Web
   Publishing Engine. MySQL search queries are formatted as SQL statements and
   submitted directly to MySQL.
#. The database application performs the desired search and assembles a found
   set. The database application is responsible for interpreting search
   criteria, wild cards in search strings, field operators, and logical
   operators.
#. The database application sorts the found set based on sort criteria included
   in the search query. The database application is responsible for determining
   the order of records returned to Lasso.
#. A subset of the found set is sent to Lasso as the result set. Only the number
   of records specified by ``-maxRecords`` starting at the offset specified by
   ``-skipRecords`` is returned to Lasso. If any ``-returnField`` parameters are
   included in a search then only those fields they specify are returned to
   Lasso.
#. The result set can be displayed and manipulated using methods that return
   information about the result set and methods that return fields or other
   values.


Character Encoding
==================

Lasso stores and retrieves data from data sources based on the preferences
established in the "Datasources" section of Lasso Server Admin. The following
rules apply for each standard data source:

:Inline Host:
   The character encoding can be specified explicitly using a ``-tableEncoding``
   parameter within the ``-host`` array.
:Inline Table:
   The character encoding of the table specified using the ``-table`` parameter
   is used if ``-tableEncoding`` is not specified within the ``-host`` array.
:MySQL:
   By default all communication is encoded as UTF-8.
:FileMaker Server:
   By default all communication is in the MacRoman character set when Lasso
   Server is hosted on OS X, or in the Latin-1 (ISO-8859-1) character set when
   Lasso Server is hosted on Windows.
:ODBC:
   Encoding of communication with ODBC data sources is dependent on the encoding
   of the table being accessed.


Error Reporting
===============

After a database action has been performed, Lasso reports any errors that
occurred via the `error_currentError` method. The value of this method should be
checked to verify that the database action was successfully performed.


Display Current Error Code and Message
--------------------------------------

The following code can be used to display the current error message. This code
should be placed in a Lasso page that is a response to a database action or
within the capture block of an `inline` method. ::

   error_code + ': ' + error_msg

If the database action was performed successfully then the following result will
be returned::

   // => 0: No Error


Check for a Specific Error Code and Message
-------------------------------------------

The following example shows how to report a specific error if one occurs using a
conditional ``if`` statement to check if the current error message is equal to
`error_databaseTimeout`::

   if(error_currentError == error_databaseTimeout)
      'Connection to database lost!'
   /if

Full documentation about error methods and error codes can be found in the
:ref:`error-handling` chapter.


Searching Records
=================

Searches can be performed within any Lasso-compatible database using the
``-search`` parameter in an `inline` method. The ``-search`` parameter requires
that a number of additional parameters be defined in order to perform the
search. The additional required parameters are detailed in the table
:ref:`searching-search-action` along with a description of other recommended or
optional parameters specific to the ``-search`` action.

Additional optional parameters are described in the tables
:ref:`searching-operator-parameters` and :ref:`searching-result-parameters` in
the sections that follow.

.. tabularcolumns:: |l|L|

.. _searching-search-action:

.. table:: -Search Action Requirements

   ================ ============================================================
   Parameter        Description
   ================ ============================================================
   ``-search``      The action that is to be performed. Required.
   ``-database=?``  The database that should be searched. Required.
   ``-table=?``     The table from the specified database that should be
                    searched. Required.
   ``-keyField=?``  The name of the field that holds the primary key for the
                    specified table. Recommended.
   ``-keyValue=?``  The particular value for the primary key of the record that
                    should be returned. Using ``-keyValue`` overrides all the
                    other search parameters and returns the single record
                    specified. Optional.
   ``-key=?``       An array that specifies the search field operators and pair
                    parameters to find the matching records.
   ``-host=?``      Optional inline host array. See the section
                    :ref:`database-inline-connection` in the
                    :ref:`database-interaction` chapter for more information.
   name/value pairs A variable number of name/value pair parameters specify the
                    query that will be performed. Any pair parameters included
                    in the search action will be used to define the query that
                    is performed in the specified table. All pair parameters
                    must reference a field within the database. Any fields that
                    are not referenced will be ignored for the purposes of the
                    search.
   ================ ============================================================


Search a Database Using an Inline
---------------------------------

The following example shows how to search a database by specifying the required
parameters within an `inline` method. The ``-database`` is set to "contacts",
``-table`` is set to "people", and ``-keyField`` is set to "id". The search
returns records that contain "John" with the field "first_name".

The results of the search are displayed to the visitor inside the inline. The
`records` method will repeat for each record in the found set. The `field`
methods will display the value for the specified field from the current record
being shown. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

If the search was successful then the following results will be returned::

   // =>
   // <br />John Person
   // <br />John Doe

Additional pair parameters and keyword parameters can be used to generate more
complex searches. These techniques are documented in the section
:ref:`searching-operators` later in this chapter.


Search a Database Using Visitor-Supplied Values
-----------------------------------------------

The following example shows how to search a database by specifying the required
parameters within an `inline` method, but allowing a site visitor to specify the
search criteria in an HTML form. The visitor is presented with an HTML form in
the Lasso page "default.lasso". The HTML form contains two text inputs for
"first_name" and "last_name" and a submit button. The action of the form is the
response page "response.lasso" which contains the inline that will perform the
search. The contents of the "default.lasso" file include the following::

   <form action="response.lasso" method="POST">
      <br />First Name: <input type="text" name="first_name" value="" />
      <br />Last Name: <input type="text" name="last_name" value="" />
      <br /><input type="submit" name="submit" value="Search" />
   </form>

The search is performed and the results of the search are displayed to the
visitor inside the `inline` method in "response.lasso". The values entered by
the visitor in the HTML form in "default.lasso" are inserted into the inline
using the `web_request->param` method. The `records` method will execute the
capture block for each record in the found set. The `field` methods will display
the value for the specified field from the current record being shown. The
contents of the "response.lasso" file include the following::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'=web_request->param('first_name'),
      'last_name'=web_request->param('last_name')
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

If the visitor entered "John" for "first_name" and "Person" for "last_name" then
the following result would be returned::

   // =>
   // <br />John Person


.. _searching-operators:

Search Operators
================

Lasso inlines include a set of parameters that allow operators to be used to
create complex database queries. These parameters are summarized in the table
:ref:`searching-operator-parameters`.

.. tabularcolumns:: |l|L|

.. _searching-operator-parameters:

.. table:: Search Operator Parameters

   +--------------------------+----------------------------------------------------------+
   |Parameter                 |Description                                               |
   +==========================+==========================================================+
   |``-operatorLogical=?`` or |Specifies the logical operator for the search.            |
   |``-opLogical=?``          |Abbreviation is ``-opLogical``. Defaults to AND.          |
   +--------------------------+----------------------------------------------------------+
   |``-operator=?`` or        |When specified before a pair parameter, sets the search   |
   |``-op=?``                 |operator for that parameter. Abbreviation is ``-op``.     |
   |                          |Defaults to "bw". See below for a full list of field      |
   |                          |operators, which can also be written as ``-bw``, ``-ew``, |
   |                          |``-cn``, etc.                                             |
   +--------------------------+----------------------------------------------------------+
   |``-operatorBegin=?`` or   |Specifies the logical operator for all search parameters  |
   |``-opBegin=?``            |until ``-operatorEnd`` is reached. Abbreviation is        |
   |                          |``-opBegin``.                                             |
   +--------------------------+----------------------------------------------------------+
   |``-operatorEnd=?`` or     |Specifies the end of a logical operator grouping started  |
   |``-opEnd=?``              |with ``-operatorBegin``. Abbreviation is ``-opEnd``.      |
   +--------------------------+----------------------------------------------------------+

The operator parameters are divided into two categories:

Field Operators
   These are specified using the ``-operator`` parameter before a name/value
   pair parameter. The field operator changes the way that the named field is
   searched for the value. If no field operator is specified then the default
   begins with operator ("bw") is used. See the table
   :ref:`searching-field-operators` for a list of the possible values. Field
   operators can also be abbreviated as ``-bw``, ``-ew``, ``-cn``, etc.

Logical Operators
   These are specified using the ``-operatorLogical``, ``-operatorBegin``, and
   ``-operatorEnd`` parameters. These parameters specify how the results of
   different pair parameters are combined to form the full results of the
   search. You cannot mix ``-operatorLogical`` with ``-operatorBegin`` and
   ``-operatorEnd``.


Field Operators
---------------

The possible values for the ``-operator`` parameter are listed in the table
:ref:`searching-field-operators`. The default operator is begins with ("bw").
Case is not considered when specifying operators. Several of the field operators
are only supported in MySQL or other SQL databases. These include the "ft"
full-text operator and the "rx" and "nrx" regular expression operators, which
are described further in the table :ref:`sql-mysql-search-operators`.

.. tabularcolumns:: |l|L|

.. _searching-field-operators:

.. table:: Search Field Operators

   ========================= ===================================================
   Operator                  Description
   ========================= ===================================================
   ``-op='bw'`` or ``-bw``   Begins With. Default if no operator is set.
   ``-op='nbw'`` or ``-nbw`` Not Begins With.
   ``-op='cn'`` or ``-cn``   Contains.
   ``-op='ncn'`` or ``-ncn`` Not Contains.
   ``-op='eq'`` or ``-eq``   Equals.
   ``-op='neq'`` or ``-neq`` Not Equals.
   ``-op='ew'`` or ``-ew``   Ends With.
   ``-op='new'`` or ``-new`` Not Ends With.
   ``-op='gt'`` or ``-gt``   Greater Than.
   ``-op='gte'`` or ``-gte`` Greater Than or Equals.
   ``-op='lt'`` or ``-lt``   Less Than.
   ``-op='lte'`` or ``-lte`` Less Than or Equals.
   ``-op='ft'`` or ``-ft``   Full-Text Search. MySQL databases only.
   ``-op='rx'`` or ``-rx``   Regular Expression Search. MySQL databases only.
   ``-op='nrx'`` or ``-nrx`` Not Regular Expression Search. MySQL databases
                             only.
   ========================= ===================================================

Field operators are interpreted differently depending on which data source is
being accessed. For example, FileMaker Server interprets "bw" to mean that any
word within a field can begin with the value specified for that field. MySQL
interprets "bw" to mean that the first word within the field must begin with the
value specified. See the chapters on each data source or the documentation that
came with a third-party data source connector for more information.


Specify a Field Operator in an Inline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Specify the field operator before the name/value pair parameter that it will
affect. The following `inline` method searches for records where the
"first_name" begins with "J" and the "last_name" ends with "son"::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -operator='bw', 'first_name'='J',
      -operator='ew', 'last_name'='son'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name')
      ^}
   ^}

The same could be accomplished by using a ``-key`` parameter::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -key=(: -bw, 'first_name'='J', -ew, 'last_name'='son')
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

The results of the search would include the following records::

   // =>
   // <br />John Person
   // <br />Jane Person


Logical Operators
-----------------

The logical operator parameter ``-operatorLogical`` can be used with a value of
either "And" or "Or". The parameters ``-operatorBegin`` and ``-operatorEnd`` can
be used with values of "And", "Or", or "Not". An ``-operatorLogical`` applies to
all search parameters specified with an action while ``-operatorBegin`` applies
to all search parameters until the matching ``-operatorEnd`` parameter is
reached. (Thus the two cannot be mixed into the same inline.) The case of the
value is unimportant when specifying a logical operator.

-  **AND** --
   Specifies that records that are returned should fulfill all of the search
   parameters listed.
-  **OR** --
   Specifies that records that are returned should fulfill one or more of the
   search parameters listed.
-  **NOT** --
   Specifies that records that match the search criteria contained between the
   ``-operatorBegin`` and ``-operatorEnd`` parameters should be omitted from the
   found set. The NOT operator cannot be used with the ``-operatorLogical``
   keyword parameter.

.. tip::
   In lieu of a NOT option for ``-operatorLogical``, many field operators can
   be negated individually by substituting the opposite field operator. The
   following pairs of field operators are the opposites of each other: "eq" and
   "neq", "lt" and "gte", and "gt" and "lte".

.. note::
   The ``-operatorBegin`` and ``-operatorEnd`` parameters do not work with Lasso
   Connector for FileMaker Server.


Perform a Search Using an AND Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorLogical`` command tag with an "And" value. The following
`inline` method returns records for which the "first_name" field begins with
"John" and the "last_name" field begins with "Doe". The position of the
``-operatorLogical`` parameter within the inline is unimportant since it applies
to the entire action. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -operatorLogical='And',
      'first_name'='John',
      'last_name'='Doe'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name')
      ^}
   ^}

   // => <br />John Doe


Perform a Search Using an OR Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorLogical`` parameter with an "Or" value. The following
`inline` method returns records for which the "first_name" field begins with
either "John" or "Jane". The position of the ``-operatorLogical`` parameter
within the inline is unimportant since it applies to the entire action. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -operatorLogical='Or',
      'first_name'='John',
      'first_name'='Jane'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // <br />John Doe
   // <br />Jane Doe
   // <br />John Person


Perform a Search Using a NOT Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorBegin`` and ``-operatorEnd`` parameters with a "Not" value.
The following `inline` method returns records for which the "first_name" field
begins with "John" and the "last_name" field is not "Doe". The operator
parameters must surround the parameters of the search that is to be negated. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      -operatorBegin='Not',
         'last_name'='Doe',
      -operatorEnd='Not'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name')
      ^}
   ^}

   // => <br />John Person


Perform a Search with a Complex Query
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorBegin`` and ``-operatorEnd`` parameters to build up a complex
query. As an example, a query can be constructed to find records in a database
whose "first_name" and "last_name" both begin with the same letter "J" or "M".
The desired query could be written in pseudocode as follows:

.. code-block:: none

   ( (first_name begins with J) AND (last_name begins with J) )
   OR
   ( (first_name begins with M) AND (last_name begins with M) )

To translate this into an inline statement, each line of the query becomes a
pair of ``-opBegin='And'`` and ``-opEnd='And'`` parameters with a pair parameter
for "first_name" and "last_name" contained inside. The two lines are then
combined using a pair of ``-opBegin='Or'`` and ``-opEnd='Or'`` parameters. The
nesting of the parameters works like the nesting of parentheses in the
pseudocode above to clarify how Lasso should combine the results of different
name/value pair parameters. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -opBegin='Or',
         -opBegin='And',
            'first_name'='J',
            'last_name'='J',
         -opEnd='And',
         -opBegin='And',
            'first_name'='M',
            'last_name'='M',
         -opEnd='And',
      -opEnd='Or'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

The returned result might look something like this::

   // =>
   // <br />Johnny Johnson
   // <br />Jimmy James
   // <br />Mark McPerson


Returning Records
=================

Lasso inlines include a set of parameters that allow the results of a search to
be customized. These parameters do not change the found set of records that are
returned from the search, but they do change the data that is returned for
formatting and display to the visitor. The result parameters are summarized in
the table :ref:`searching-result-parameters`.

.. seealso::

   -  SQL-specific methods and parameters in the :ref:`sql-data-sources` chapter
   -  FileMaker Server--specific methods and parameters in the
      :ref:`filemaker-data-sources` chapter

.. tabularcolumns:: |l|L|

.. _searching-result-parameters:

.. table:: Result Parameters

   +---------------------+-----------------------------------------------------+
   |Parameter            |Description                                          |
   +=====================+=====================================================+
   |``-sortField=?`` or  |Specifies that the results should be sorted based on |
   |``-sortColumn=?``    |the data in the named field. Multiple ``-sortField`` |
   |                     |parameters can be used for complex sorts. Optional,  |
   |                     |defaults to returning data in the order it appears   |
   |                     |in the database.                                     |
   +---------------------+-----------------------------------------------------+
   |``-sortOrder=?``     |When specified after a ``-sortField`` parameter,     |
   |                     |specifies the order of the sort, either "ascending", |
   |                     |"descending" or custom. Optional, defaults to        |
   |                     |"ascending" for each ``-sortField``.                 |
   +---------------------+-----------------------------------------------------+
   |``-maxRecords=?``    |Specifies how many records should be shown from the  |
   |                     |found set. Optional, defaults to "50".               |
   +---------------------+-----------------------------------------------------+
   |``-skipRecords=?``   |Specifies an offset into the found set at which      |
   |                     |records should start being shown. Optional, defaults |
   |                     |to "1".                                              |
   +---------------------+-----------------------------------------------------+
   |``-returnField=?`` or|Specifies a field that should be returned in the     |
   |``-returnColumn=?``  |results of the search. Multiple ``-returnField``     |
   |                     |parameters can be used to return multiple fields.    |
   |                     |Optional, defaults to returning all fields in the    |
   |                     |searched table.                                      |
   +---------------------+-----------------------------------------------------+

The result parameters are divided into three categories:

#. **Sorting** is specified using the ``-sortField`` and ``-sortOrder``
   parameters. These parameters change the order of the records that the search
   returns. The database application performs the sort before Lasso receives the
   record set.

#. The portion of the **Found Set** being shown is specified using the
   ``-maxRecords`` and ``-skipRecords`` parameters. ``-maxRecords`` sets the
   number of records that will be iterated over in the `records` method, while
   ``-skipRecords`` sets the offset into the found set that is shown. These two
   parameters define the window of records that are shown and can be used to
   navigate through a found set.

#. The **Fields** that are available are specified using the ``-returnField``
   parameter. Normally, all fields in the searched table are returned. If any
   ``-returnField`` parameters are specified then only those fields will be
   available for display using the `field` method. Specifying ``-returnField``
   parameters can improve the performance of Lasso by not sending unnecessary
   data between the database and the web server.

   .. note::
      In order to use the `keyField_value` method within an inline, the
      ``-keyField`` must be specified as one of the ``-returnField`` values.


Return Sorted Results
---------------------

Specify ``-sortField`` and ``-sortOrder`` parameters within an inline search.
The following inline includes sort parameters. The records are first sorted by
"last_name" in ascending order, then sorted by "first_name" in ascending order::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='J',
      -sortField='last_name',  -sortOrder='ascending',
      -sortField='first_name', -sortOrder='ascending'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

The following results could be returned when this inline is run. The returned
records are sorted in order of "last_name". If the "last_name" of two records
are equal then those records are sorted in order of "first_name". ::

   // =>
   // <br />Jane Doe
   // <br />John Doe
   // <br />Jane Person
   // <br />John Person


Return a Portion of a Found Set
-------------------------------

A portion of a found set can be returned by manipulating the values for
``-maxRecords`` and ``-skipRecords``. In the following example, a search is
performed for records where the "first_name" begins with "J". This search
returns four records, but only the second two records are shown. ``-maxRecords``
is set to "2" to show only two records and ``-skipRecords`` is set to "2" to
skip the first two records. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='J',
      -maxRecords=2,
      -skipRecords=2
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

The following results could be returned when this inline is run. Neither of the
"Doe" records from the previous example are shown since they are skipped over.
::

   // =>
   // <br />Jane Person
   // <br />John Person


Limit Fields Returned in Search Results
---------------------------------------

Use the ``-returnField`` parameter. If a single ``-returnField`` parameter is
used then only the fields that are specified will be returned. If no
``-returnField`` parameters are specified then all fields within the current
table will be returned. In the following example, only the "first_name" field is
shown since it is the only field specified within a ``-returnField`` parameter::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='J',
      -returnField='first_name'
   ) => {^
      records => {^
         '<br />' + field('first_name') + '\n'
      ^}
   ^}

The "last_name" field cannot be shown for any of these records since it was not
specified in a``-returnField`` parameter. The above code would result in
something like the following::

   // =>
   // <br />John
   // <br />Jane
   // <br />Jane
   // <br />John

If the data source is MySQL, the ``-distinct`` parameter can be added to just
return two records instead of four; one with the first name of "John" and the
other with "Jane" See the :ref:`sql-data-sources` chapter for details on the
``-distinct`` parameter.


Finding All Records
===================

All records can be returned from a database using the ``-findAll`` parameter.
The ``-findAll`` parameter functions exactly like the ``-search`` parameter
except that no name/value pair parameters or operator parameters are required.
Parameters that sort and limit the found set work the same as they do for
``-search`` actions.

.. tabularcolumns:: |l|L|

.. _searching-findall-action:

.. table:: -FindAll Action Requirements

   =============== =============================================================
   Parameter       Description
   =============== =============================================================
   ``-findAll``    The action that is to be performed. Required.
   ``-database=?`` The database that should be searched. Required.
   ``-table=?``    The table from the specified database that should be
                   searched. Required.
   ``-keyField=?`` The name of the field that holds the primary key for the
                   specified table. Recommended.
   ``-host=?``     Optional inline host array. See the section
                   :ref:`database-inline-connection` in the
                   :ref:`database-interaction` chapter for more information.
   =============== =============================================================


Return All Records from a Database
----------------------------------

The following `inline` method finds all records within a table named "people" in
the "contacts" database and displays them. The results are shown below::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // <br />John Doe
   // <br />Jane Doe
   // <br />John Person
   // <br />Jane Person


Finding Random Records
======================

A random record can be returned from a FileMaker database using the ``-random``
parameter. The ``-random`` parameter functions exactly like the ``-search``
parameter except that no name/value pair parameters or operator parameters are
required.

.. tabularcolumns:: |l|L|

.. _searching-random-action:

.. table:: -Random Action Requirements

   =============== =============================================================
   Parameter       Description
   =============== =============================================================
   ``-random``     The action that is to be performed. Required.
   ``-database=?`` The database that should be searched. Required.
   ``-table=?``    The table from the specified database that should be
                   searched. Required.
   ``-keyField=?`` The name of the field that holds the primary key for the
                   specified table. Recommended.
   ``-host=?``     Optional inline host array. See the section
                   :ref:`database-inline-connection` in the
                   :ref:`database-interaction` chapter for more information.
   =============== =============================================================


Return a Random Record from a Database
--------------------------------------

The following inline finds a single random record from a FileMaker Server
database "contacts" and displays it. The ``-maxRecords`` is set to "1" to ensure
that only a single record is shown. One potential result is shown below. Each
time this inline is run a different record will be returned. ::

   inline(
      -random,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=1
   ) => {^
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name')
      ^}
   ^}

   // => <br />Jane Person


Displaying Data
===============

The examples in this chapter have all relied on the `records` method and `field`
method to display the results of the search that have been performed. This
section describes the use of these methods in more detail. (See the section
:ref:`database-action-results` in the :ref:`database-interaction` chapter for
method documentation and more information.)

The `field` method always returns the value for a field from the current record
when it is used within a capture block of a `records` method. If the `field`
method is used outside of `records` block but inside an `inline` capture block,
then it returns the value for the field from the first record in the found set.
If the found set has only one record then the `records` method is optional.

.. note::
   For clarity, the example code in these chapters display data exactly as
   returned from the database, but production code should use
   `~string->encodeHtml`, `~string->encodeXml`, or an encoding parameter with
   `field` calls to ensure characters are proplerly formatted for the chosen
   output format.


Display Results of a Search
---------------------------

Use the `records` method and `field` method to display the results of a search.
The following `inline` method performs a ``-findAll`` action in a database
"contacts". The results are returned each formatted on a line by itself. The
`loop_count` method is used to indicate the order within the found set. ::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {^
      records => {^
         '<br />' + loop_count + ': ' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // <br />1: John Doe
   // <br />2: Jane Doe
   // <br />3: John Person
   // <br />4: Jane Person


Display Result for a Single Record
----------------------------------

Use `field` methods within the capture block of an `inline` method. The
`records` methods are unnecessary if only a single record is returned. The
following inline performs a ``-search`` for a single record whose primary key
"id" equals "1". The `keyField_value` is shown along with the `field` values for
the record. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=1
   ) => {^
      '<br />' + keyField_value + ': ' + field('first_name') + ' ' + field('last_name') + '\n'
   ^}

   // =>
   // <br />1: Jane Doe


Display Results from a Named Inline
-----------------------------------

Use the ``-inlineName`` parameter in both the `inline` method and in the
`records` method. The `records` method can be located anywhere in the code after
the inline that define the database action. The following example shows a
``-findAll`` action at the top of a page of code with the results formatted
later::

   inline(
      -inlineName='FindAll Results',
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {}

   // ...

   records(-inlineName='FindAll Results') => {^
      '<br />' + loop_count + ': ' + field('first_name') + ' ' + field('last_name') + '\n'
   ^}

   // =>
   // <br />1: John Doe
   // <br />2: Jane Doe
   // <br />3: John Person
   // <br />4: Jane Person
