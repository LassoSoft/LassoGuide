.. _searching-displaying:

*****************************
Searching and Displaying Data
*****************************

Lasso provides several parameters for the ``inline`` method for searching
records within Lasso compatible databases. These parameters are used in
conjunction with name/value pair parameters in order to perform the desired
database action in a specific database and table or within a specific record.

The ``inline`` parameters documented in this chapter are listed in
:ref:`Search Parameters <inline-search-parameters>`. The sections that follow
describe the additional keyword parameters and pair parameters required for each
database action.

.. _inline-search-parameters:

.. tabularcolumns:: |l|L|

.. table:: Search Parameters

   +------------+--------------------------------------------------+
   |Parameter   |Description                                       |
   +============+==================================================+
   |``-search`` |Searches for records within a database.           |
   +------------+--------------------------------------------------+
   |``-findAll``|Finds all records within a database.              |
   +------------+--------------------------------------------------+
   |``-random`` |Returns a random record from a database. Only     |
   |            |works with FileMaker Pro databases.               |
   +------------+--------------------------------------------------+

How Searches are Performed
==========================

The following describes each step that take place every time a search is
performed using Lasso:

#. Lasso checks the database, table, and field name specified in the search to
   ensure that they are all valid.
#. The search query is formatted and sent to the database application. FileMaker
   Pro search queries are formatted as URLs and submitted to the Web Companion.
   MySQL search queries are formatted as SQL statements and submitted directly
   to MySQL.
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
established in the "Datasources" section of Lasso Admin. The following rules
apply for each standard data source:

Inline Host
   The character encoding can be specified explicitly using a ``-tableEncoding``
   parameter within the ``-host`` array.

MySQL
   By default all communication is in the UTF-8 character set.

FileMaker Pro
   By default all communication is in the MacRoman character set when Lasso
   Professional is hosted on Mac OS X or in the Latin-1 (ISO 8859-1) character
   set when Lasso Professional is hosted on Windows.

JDBC
   All communication with JDBC data sources is in the UTF-8 character set.

Error Reporting
===============

After a database action has been performed, Lasso reports any errors which
occurred via the ``[error_currentError]`` method. The value of this method
should be checked to ensure that the database action was successfully performed.

Display the Current Error Code and Message
------------------------------------------

The following code can be used to display the current error message. This code
should be placed in a Lasso page which is a response to a database action or
within the associated block of an ``inline`` method::

   [error_code]: [error_msg]

If the database action was performed successfully then the following result will
be returned::

   // =>
   // 0: No Error


Check for a Specific Error Code and Message
-------------------------------------------

The following example shows how to perform code to correct or report a specific
error if one occurs. The following example uses a conditional ``if`` control
structure to check the current error message and see if it is equal to
``error_databaseTimeout``::

   [if(error_currentError == error_databaseTimeout)]
      Connection to database lost!
   [/if] 

Full documentation about error methods and error codes can be found in the
:ref:`Error Handling<error-handling>` chapter.


Searching Records
=================

Searches can be performed within any Lasso compatible database using the
``-search`` parameter in an ``inline`` method. The ``-search`` parameter
requires that a number of additional parameters be defined in order to perform
the search. The additional required parameters are detailed in :ref:`Table:
-Search Action Requirements <inline-search-action_required>` along with a
description of other recommended or optional parameters specific to the
``-search`` action.

Additional optional parameters are described in
:ref:`Table: Operator Parameters<inline-operator-parameters>` and
:ref:`Table: Results Parameters <inline-results-parameters>` in the sections
that follow.

.. _inline-search-action_required:

.. tabularcolumns:: |l|L|

.. table:: -Search Action Requirements

   +------------------------+--------------------------------------------------+
   |Parameter               |Description                                       |
   +========================+==================================================+
   |``-search``             |The action which is to be performed. Required.    |
   +------------------------+--------------------------------------------------+
   |``-database``           |The database which should be searched. Required.  |
   +------------------------+--------------------------------------------------+
   |``-table``              |The table from the specified database which should|
   |                        |be searched. Required.                            |
   +------------------------+--------------------------------------------------+
   |``-keyField``           |The name of the field which holds the primary key |
   |                        |for the specified table. Recommended.             |
   +------------------------+--------------------------------------------------+
   |``-keyValue``           |The particular value for the primary key of the   |
   |                        |record which should be returned. Using            |
   |                        |``-keyValue`` overrides all the other search      |
   |                        |parameters and returns the single record          |
   |                        |specified. Optional.                              |
   +------------------------+--------------------------------------------------+
   |``Pair Parameters``     |A variable number of name/value pair parameters   |
   |                        |specify the query which will be performed. Any    |
   |                        |pair parameters included in the search action will|
   |                        |be used to define the query that is performed in  |
   |                        |the specified table. All pair parameters must     |
   |                        |reference a field within the database. Any fields |
   |                        |which are not referenced will be ignored for the  |
   |                        |purposes of the search.                           |
   +------------------------+--------------------------------------------------+
   |``-host``               |Optional inline host array. See the section on    |
   |                        |:ref:`Inline Hosts in the Database Interaction    |
   |                        |Fundamentals<inline-hosts>` chapter for more      |
   |                        |information.                                      |
   +------------------------+--------------------------------------------------+


Search a Database Using the Inline Method
-----------------------------------------

The following example shows how to search a database by specifying the required
parameters within an ``inline`` method. ``-database`` is set to "contacts",
``-table`` is set to "people", and ``-keyField`` is set to id. The search
returns records which contain "John" with the field "first_name".

The results of the search are displayed to the visitor inside the ``inline``
method. The ``records`` method will repeat for each record in the found set. The
``field`` methods will display the value for the specified field from the
current record being shown::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John'
   )]
      [records]
         <br />[field('first_name')] [field('last_name')]
      [/records]
   [/inline]

If the search was successful then the following results will be returned::
     
   // =>
   // <br />John Person
   // <br />John Doe

Additional pair parameters and keyword parameters can be used to generate more
complex searches. These techniques are documented in the following section on
:ref:`Operators<inline-search-operators>`.


Search a Database Using Visitor-Defined Values
----------------------------------------------

The following example shows how to search a database by specifying the required
parameters within an ``inline`` method, but allow a site visitor to specify the
search criteria in an HTML form. The visitor is presented with an HTML form in
the Lasso page "default.lasso". The HTML form contains two text inputs for
"first_name" and "last_name" and a submit button. The action of the form is the
response page "response.lasso" which contains the ``inline`` method that will
perform the search. The contents of the "default.lasso" file include the
following::

   <form action="response.lasso" method="POST">
      <br />First Name: <input type="text" name="first_name" value="" />
      <br />Last Name: <input type="text" name="last_name" value="" />
      <br /><input type="submit" name="submit" value="Search Database" />
   </form>

The search is performed and the results of the search are displayed to the
visitor inside the ``inline`` method in "response.lasso". The values entered by
the visitor in the HTML form in "default.lasso" are inserted into the ``inline``
method using the ``web_request->param`` method. The ``records`` method will
execute the associated block for each record in the found set. The ``field``
methods will display the value for the specified field from the current record
being shown. The contents of the "response.lasso" file include the following::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'=web_request->param('first_name'),
      'last_name' =web_request->param('last_name')
   )]
      [records]
         <br />[field('first_name')] [field('last_name')]
      [/records]
   [/inline]

If the visitor entered "John" for "first_name" and "Person" for "last_name" then
the following result would be returned::

   // =>
   // <br />John Person

.. _inline-search-operators:

Operators
=========

Lasso inlines include a set of parameters that allow operators to be used to
create complex database queries. These parameters are summarized in
:ref:`Table: Operator Parameters<inline-operator-parameters>`.

.. _inline-operator-parameters:

.. tabularcolumns:: |l|L|

.. table:: Table: Operator Parameters

   +--------------------+------------------------------------------------------+
   |Parameters          |Description                                           |
   +====================+======================================================+
   |``-operatorLogical``|Specifies the logical operator for thesearch.         |
   |``-opLogical``      |Abbreviation is ``-opLogical``. Defaults to "and".    |
   +--------------------+------------------------------------------------------+
   |``-operator``       |When specified before a pair parameter, establishes   |
   |``-op``             |the search operator for that pair parameter.          |
   |                    |Abbreviation is ``-op``. Defaults to "bw". See below  |
   |                    |for a full list of field operators. Operators can also|
   |                    |be written as ``-bw``, ``-ew``, ``-cn``, etc.         |
   +--------------------+------------------------------------------------------+
   |``-operatorBegin``  |Specifies the logical operator for all search         |
   |``-opBegin``        |parameters until ``-operatorEnd`` is reached.         |
   |                    |Abbreviation is ``-opBegin``.                         |
   +--------------------+------------------------------------------------------+
   |``-operatorEnd``    |Specifies the end of a logical operator grouping      |
   |``-opEnd``          |started with ``-operatorBegin``. Abbreviation is      |
   |                    |``-opEnd``.                                           |
   +--------------------+------------------------------------------------------+

The operator parameters are divided into two categories:

Field Operators
   These are specified using the ``-operator`` parameter before a name/value
   pair parameter. The field operator changes the way that the named field is
   searched for the value. If no field operator is specified then the default
   begins with ("bw") operator is used. See
   :ref:`Table: Field Operators<inline-field-operators>` for a list of the
   possible values. Field operators can also be abbreviated as ``-bw``, ``-ew``,
   ``-cn``, etc.

Logical Operators
   These are specified using the ``-operatorLogical``, ``-operatorBegin``, and
   ``-operatorEnd`` parameters. These parameters specify how the results of
   different pair parameters are combined to form the full results of the
   search.


Field Operators
---------------

The possible values for the ``-operator`` parameter are listed in
:ref:`Table: Field Operators<inline-field-operators>`. The default operator is
begins with ("bw"). Case is unimportant when specifying operators.

Field operators are interpreted differently depending on which data source is
being accessed. For example, FileMaker Pro interprets "bw" to mean that any word
within a field can begin with the value specified for that field. MySQL
interprets "bw" to mean that the first word within the field must begin with the
value specified. See the chapters on each data source or the documentation that
came with a third-party data source connector for more information.

Several of the field operators are only supported in MySQL or other SQL
databases. These include the "ft" full text operator and the "rx" and "nrx"
regular expression operators.

.. _inline-field-operators:

.. table:: Table: Field Operators

   +-------------------------+-------------------------------------------------+
   |Operators                |Description                                      |
   +=========================+=================================================+
   |``-op='bw'`` Or ``-bw``  |Begins With. Default if no operator is set.      |
   +-------------------------+-------------------------------------------------+
   |``-op='cn'`` Or ``-cn``  |Contains.                                        |
   +-------------------------+-------------------------------------------------+
   |``-op='ew'`` Or ``-ew``  |Ends With.                                       |
   +-------------------------+-------------------------------------------------+
   |``-op='eq'`` Or ``-eq``  |Equals.                                          |
   +-------------------------+-------------------------------------------------+
   |``-op='ft'or -ft``       |Full Text. MySQL databases only.                 |
   +-------------------------+-------------------------------------------------+
   |``-op='gt'`` Or ``-gt``  |Greater Than.                                    |
   +-------------------------+-------------------------------------------------+
   |``-op='gte'`` Or ``-gte``|Greater Than or Equals.                          |
   +-------------------------+-------------------------------------------------+
   |``-op='lt'`` Or ``-lt``  |Less Than.                                       |
   +-------------------------+-------------------------------------------------+
   |``-op='lte'`` Or ``-lte``|Less Than or Equals.                             |
   +-------------------------+-------------------------------------------------+
   |``-op='neq'`` Or ``-neq``|Not Equals.                                      |
   +-------------------------+-------------------------------------------------+
   |``-op='rx'`` Or ``-rx``  |RegExp. Regular expression search. SQL databases |
   |                         |only.                                            |
   +-------------------------+-------------------------------------------------+
   |``-op='nrx'`` Or ``-nrx``|Not RegExp. Opposite of RegExp. SQL databases    |
   |                         |only.                                            |
   +-------------------------+-------------------------------------------------+


Specify a Field Operator in an Inline Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Specify the field operator before the name/value pair parameter which it will
affect. The following ``inline`` method searches for records where the
"first_name" begins with "J" and the "last_name" ends with "son"::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -operator='bw', 'first_name'='J',
      -operator='ew', 'last_name'='son'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

The results of the search would include the following records::

   // =>
   // <br />John Person
   // <br />Jane Person


Logical Operators
-----------------

The logical operator parameter ``-operatorLogical`` can be used with a value of
either "AND" or "OR". The parameters ``-operatorBegin``, and ``-operatorEnd``
can be used with values of "AND", "OR", or "NOT". ``-operatorLogical`` applies
to all search parameters specified with an action while ``-operatorBegin``
applies to all search parameters until the matching ``-operatorEnd`` parameter
is reached. The case of the value is unimportant when specifying a logical
operator.

-  "AND" specifies that records which are returned should fulfil all of the
   search parameters listed.
-  "OR" specifies that records which are returned should fulfil one or more of
   the search parameters listed.
-  "NOT" specifies that records which match the search criteria contained
   between the ``-operatorBegin`` and ``-operatorEnd`` parameters should be
   omitted from the found set. "NOT" cannot be used with the
   ``-operatorLogical`` keyword parameter.

.. note::
   In lieu of a "NOT" option for ``-operatorLogical``, many field operators can
   be negated individually by substituting the opposite field operator. The
   following pairs of field operators are the opposites of each other: "eq" and
   "neq", "lt" and "gte", and "gt" and "lte".

.. note::
   **FileMaker** - The ``-operatorBegin`` and `` -operatorEnd`` parameters do
   not work with Lasso Connector for FileMaker Pro.


Perform a Search Using an "AND" Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorLogical`` command tag with an "AND" value. The following
``inline`` method returns records for which the "first_name" field begins with
"John" and the "last_name" field begins with "Doe". The position of the
``-operatorLogical`` parameter within the ``inline`` method is unimportant since
it applies to the entire action::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -operatorLogical='AND',
      'first_name'='John',
      'last_name'='Doe'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]


Perform a Search Using an OR Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorLogical`` parameter with an "OR" value. The following
``inline`` method returns records for which the "first_name" field begins with
either "John" or "Jane". The position of the ``-operatorLogical`` parameter
within the ``inline`` method is unimportant since it applies to the entire
action::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -operatorLogical='OR',
      'first_name'='John',
      'first_name'='Jane'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]


Perform a Search Using a "NOT" Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``-operatorBegin`` and ``-operatorEnd`` parameters with a "NOT" value.
The following ``inline`` method returns records for which the "first_name" field
begins with "John" and the "last_name" field is not "Doe". The operator
parameters must surround the parameters of the search which is to be negated::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      -operatorBegin='NOT',
      'last_name'='Doe',
      -operatorEnd='NOT'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]


Perform a Search With a Complex Query

Use the ``-operatorBegin`` and ``-operatorEnd`` parameters to build up a complex
query. As an example, a query can be constructed to find records in a database
whose "First_name" And "last_name" both begin with the same letter "J" or "M".
The desired query could be written in pseudo-code as follows::

   ( (first_name begins with J) AND (last_name begins with J) ) OR
   ( (first_name begins with M) AND (last_name begins with M) )

The pseudo code is translated into Lasso code as follows. Each line of the query
becomes a pair of ``-opBegin=AND`` and ``-opEnd=AND`` parameters with a pair
parameter for "first_name" and "last_name" contained inside. The two lines are
then combined using a pair of ``-opBegin=OR`` and ``-opEnd=OR`` parameters. The
nesting of the parameters works like the nesting of parentheses in the pseudo
code above to clarify how Lasso should combine the results of different
name/value pair parameters::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -opBegin='OR',
         -opBegin='AND',
            'first_name'='J',
            'last_name'='J',
         -opEnd='AND',
         -opBegin='AND',
            'first_name'='M',
            'last_name'='M',
         -opEnd='AND',
      -opEnd='OR'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

The following results might look something like this::

   // =>
   // <br />Johnny Johnson
   // <br />Jimmy James
   // <br />Mark McPerson


Results
=======

Lasso inlines include a set of parameters that allow the results of a search to
be customized. These parameters do not change the found set of records that are
returned from the search, but they do change the data that is returned for
formatting and display to the visitor. The results parameters are summarized in
:ref:`Table: Results Parameters<inline-results-parameters>`.

.. _inline-results-parameters:

.. table:: Table: Results Parameters

   +------------------+--------------------------------------------------------+
   |Parameter         |Description                                             |
   +==================+========================================================+
   |``-distinct``     |Specifies that only records with distinct values in all |
   |                  |returned fields should be returned. MySQL only.         |
   +------------------+--------------------------------------------------------+
   |``-maxRecords``   |Specifies how many records should be shown from         |
   |                  |the found set. Optional, defaults to "50".              |
   +------------------+--------------------------------------------------------+
   |``-skipRecords``  |Specifies an offset into the found set at which         |
   |                  |records should start being shown. Optional,             |
   |                  |defaults to "1".                                        |
   +------------------+--------------------------------------------------------+
   |``-returnField``  |Specifies a field that should be returned in the results|
   |``-returnColumn`` |of the search. Multiple ``-returnField`` parameters can |
   |                  |be used to return multiple fields. Optional, defaults to|
   |                  |returning all fields in the searched table.             |
   +------------------+--------------------------------------------------------+
   |``-sortField``    |Specifies that the results should be sorted based       |
   |``-sortColumn``   |on the data in the named field. Multiple                |
   |                  |``-sortField`` parameters can be used for complex       |
   |                  |sorts. Optional, defaults to returning data in the      |
   |                  |order it appears in the database.                       |
   +------------------+--------------------------------------------------------+
   |``-sortOrder``    |When specified after a ``-sortField`` parameter,        |
   |                  |specifies the order of the sort, either "ascending",    |
   |                  |"descending" or custom. Optional, defaults to           |
   |                  |"ascending" for each ``-sortField``.                    |
   +------------------+--------------------------------------------------------+

The results parameters are divided into three categories:

#. **Sorting** is specified using the ``-sortField`` and ``-sortOrder``
   parameters. These parameters change the order of the records which are
   returned by the search. The sort is performed by the database application
   before Lasso receives the record set.

#. The portion of the **Found Set** being shown is specified using the
   ``-maxRecords`` and ``-skipRecords`` parameters. ``-maxRecords`` sets the
   number of records which will be iterated over in the ``records`` method. The
   ``-skipRecords`` parameter sets the offset into the found set which is shown.
   These two methods define the window of records which are shown and can be
   used to navigate through a found set.
   
#. The **Fields** which are available are specified using the ``-returnField``
   method. Normally, all fields in the table that was searched are returned. If
   any ``-returnField`` parameters are specified then only those fields will be
   available to be returned to the visitor using the ``field`` method.
   Specifying ``-returnField`` parameters can improve the performance of Lasso
   by not sending unnecessary data between the database and the Web server.

   .. note::
      In order to use the ``keyField_value`` method within an ``inline``, the
      ``-keyField`` must be specified as one of the ``-returnField`` values.

#. The "-distinct" parameter instructs MySQL data sources to return only records
   which contain distinct values across all returned fields. This parameter is
   useful when combined with a single ``-returnField`` parameter and a
   ``-findAll`` to return all distinct values from a single field in the
   database.


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
      -sortField='last_name', -sortOrder='ascending',
      -sortField='first_name', -sortOrder='ascending'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

The following results could be returned when this inline is run. The returned
records are sorted in order of "last_name". If the "last_name" of two records
are equal then those records are sorted in order of "first_name"::

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
skip the first two records::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='J',
      -maxRecords=2,
      -skipRecords=2
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

The following results could be returned when this inline is run. Neither of the
"Doe" records from the previous example are shown since they are skipped over::

   // =>
   // <br />Jane Person
   // <br />John Person


Limit the Fields Returned in Search Results
-------------------------------------------

Use the ``-returnField`` parameter. If a single ``-returnField`` parameter used
then only the fields that are specified will be returned. If no ``-returnField``
parameters are specified then all fields within the current table will be
returned. In the following example, only the "first_name" field is shown since
it is the only field specified within a ``-returnField`` parameter::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='J',
      -returnField='first_name'
   )]
      [records]<br />[field('first_name')][/records]
   [/inline]

The "last_name" field cannot be shown for any of these records since it was not
specified in a``-returnField`` parameter. The above code would result in
something like the following::

   // =>
   // <br />Jane
   // <br />John
   // <br />Jane
   // <br />John


Finding All Records
===================

All records can be returned from a database using the ``-findAll`` parameter.
The ``-findAll`` parameter functions exactly like the ``-search`` parameter
except that no name/value pair parameters or operator parameters are required.
Parameters that sort and limit the found set work the same as they do for
``-search`` actions.

.. tabularcolumns:: |l|L|

.. table:: Table: -FindAll Action Requirements

   +-------------+-------------------------------------------------------------+
   |Parameter    |Description                                                  |
   +=============+=============================================================+
   |``-findAll`` |The action which is to be performed. Required.               |
   +-------------+-------------------------------------------------------------+
   |``-database``|The database which should be searched. Required.             |
   +-------------+-------------------------------------------------------------+
   |``-table``   |The table from the specified database which should           |
   |             |be searched. Required.                                       |
   +-------------+-------------------------------------------------------------+
   |``-keyField``|The name of the field which holds the primary key            |
   |             |for the specified table. Recommended.                        |
   +-------------+-------------------------------------------------------------+
   |``-host``    |Optional inline host array. See the section on               |
   |             |:ref:`Inline Hosts<inline-hosts>` in the Database            |
   |             |Interaction Fundamentals chapter for more                    |
   |             |information.                                                 |
   +-------------+-------------------------------------------------------------+

Find All Records Within a Database
----------------------------------

The following ``inline`` method find all records within a table named "people"
in the "contacts" database and displays them. The results are shown below::

   [inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id'
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

   // =>
   // <br />Jane Doe
   // <br />John Person
   // <br />Jane Person
   // <br />John Doe


Return All Unique Field Values
------------------------------

The unique values from a field in a MySQL database can be returned using the
``-distinct`` parameter. Only records which have distinct values across all
fields will be returned. In the following example, a ``-findAll`` action is used
on the "people" table of the "contacts" database. Only distinct values from the
"last_name" field are returned::

   [inline(
      -findAll,
      -database='contacts',
      -table='people',
      -distinct,
      -sortField='first_name',
      -returnField='first_name'
   )]
      [records]<br />[field('first_name')][/records]
   [/inline]

The following results are returned. Even though there are multiple instances of
"John" and "Jane" in the database, only one record for each name is returned::

   // =>
   // <br />Jane
   // <br />John


Finding Random Records
======================

A random record can be returned from a database using the ``-random``
parameter. The ``-random`` parameter functions exactly like the
``-search`` parameter except that no name/value pair parameters or operator
parameters are required.

.. tabularcolumns:: |l|L|

.. table:: Table: -Random Action Requirements

   +--------------+------------------------------------------------------------+
   |Parameter     |Description                                                 |
   +==============+============================================================+
   |``-random``   |The action which is to be performed. Required.              |
   +--------------+------------------------------------------------------------+
   |``-database`` |The database which should be searched. Required.            |
   +--------------+------------------------------------------------------------+
   |``-table``    |The table from the specified database which should          |
   |              |be searched. Required.                                      |
   +--------------+------------------------------------------------------------+
   |``-keyField`` |The name of the field which holds the primary key           |
   |              |for the specified table. Recommended.                       |
   +--------------+------------------------------------------------------------+
   |``-host``     |Optional inline host array. See the section on              |
   |              |:ref:`Inline Hosts<inline-hosts>` in the Database           |
   |              |Interaction Fundamentals chapter for more                   |
   |              |information.                                                |
   +--------------+------------------------------------------------------------+


Find a Single Random Record From a Database
-------------------------------------------

The following inline finds a single random record from a FileMaker Pro database
"contacts" and displays it. ``-maxRecords`` is set to "1" to ensure that only a
single record is shown. One potential result is shown below. Each time this
inline is run a different record will be returned::

   [inline(
      -random,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=1
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

   // => <br />Jane Person

Return Multiple Records Sorted in Random Order
----------------------------------------------

The ``-sortRandom`` parameter can be used with the ``-search`` or ``-findAll``
actions to return many records from a MySQL database sorted in random order. In
the following example, all records from the "people" table of the "contacts"
database are returned in random order::

   [inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id',
      -sortRandom
   )]
      [records]<br />[field('first_name')] [field('last_name')][/records]
   [/inline]

   // =>
   // <br />John Doe
   // <br />Jane Doe
   // <br />Jane Person
   // <br />John Person


Displaying Data
===============

The examples in this chapter have all relied on the ``records`` tags and
``field`` methods to display the results of the search that have been performed.
This section describes the use of these methods in more detail. (See the section
on :ref:`Working with Inline Action Results<inline-results-methods>` in the
:ref:`Database Interaction Fundamentals<database-interaction>` chaapter for
method documentation and more description.)

The ``field`` method always returns the value for a field from the current
record when it is used within an associated block of a ``records`` method. If
the ``field`` method is used outside of ``records`` block but inside an
``inline`` associated block then it returns the value for the field from the
first record in the found set. If the found set is only one record then the
``records`` method is optional.

.. note::
   **FileMaker** - Lasso Connector for FileMaker Pro includes a collection of
   FileMaker Pro specific methods which return database results. See the
   :ref:`FileMaker Data Sources <FileMaker-Data-Sources>` chapter for more
   information.


Display the Results From a Search
---------------------------------

Use the ``records`` method and ``field`` method to display the results of a
search. The following ``inline`` method perform a ``-findAll`` action in a
database "contacts". The results are returned each formatted on a line by
itself. The ``loop_count`` method is used to indicate the order within the found
set::

   [inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id'
   )]
      [records]
         <br />[loop_count]: [field('first_name')] [field('last_name')]
      [/records]
   [/inline]

   // =>
   // <br />1: Jane Doe
   // <br />2: John Person
   // <br />3: Jane Person
   // <br />4: John Doe


Display the Results for a Single Record
---------------------------------------

Use ``field`` methods within the associated block of an ``inline`` method. The
``records`` methods are unnecessary if only a single record is returned. The
following ``inline`` method perform a ``-search`` for a single record whose
primary key "id" equals "1". The ``keyField_value`` is shown along with the
``field`` values for the record::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=1
   )]
      <br />[keyField_value]: [field('first_name')] [field('last_name')]
   [/inline]

   // ->
   // <br />1: Jane Doe


Display the Results From a Named Inline:
----------------------------------------

Use the ``-inlineName`` parameter in both the ``inline`` method and in the
``records`` method. The ``records`` method can be located anywhere in the code
after the ``inline`` method that define the database action. The following
example shows a ``-findAll`` action at the top of a page of code with the
results formatted later::

   <?lasso
      inline(
         -findAll,
         -database='contacts',
         -table='people',
         -keyField='id',
         -inlineName='FindAll Results'
      ) => {}
   ?>

   // ... Page Contents ...

   [records(-inlineName='FindAll Results')]
      <br />[loop_count]: [field('first_name')] [field('last_name')]
   [/records]

   // =>
   // <br />1: Jane Doe
   // <br />2: John Person
   // <br />3: Jane Person
   // <br />4: John Doe


Linking to Data
===============

This section describes how to create links which allow a visitor to
manipulate the found set. The following types of links can be created.

Navigation
   Links can be created which allow a visitor to page through a found set. Only
   a portion of the found set needs to be shown, but the entire found set can be
   accessed.

Detail
   Links can be created which allow detail about a particular record to be shown
   in another Lasso page.

Sorting
   Links can be provided to re-sort the current found set on a different field.

Most of the link techniques implicitly assume that the records within the
database are not going to change while the visitor is navigating through the
found set. The database search is actually performed again for every page served
to a visitor and if the number of results change then the records being shown to
the visitor can be shifted or altered as soon as another link is selected.

Link Methods
------------

Lasso 9 includes many methods which make creating detail links and navigation
links easy within Lasso solutions. The general purpose link methods are defined
below. The common parameters for all link methods are specified in :ref:`Table:
Link Method Parameters <table-link-method-parameters>`.

.. method:: link(...)

   General purpose link method that provides an anchor tag with the specified
   parameters. The ``-response`` parameter is used as the URL for the link.

.. method:: link_params(...)

   General purpose link method that processes a set of parameters using the
   common rules for all link methods.

.. method:: link_nextGroup(...)
   
   Sets a standard set of options that will be used for all link methods that
   follow in the current Lasso page.

.. method:: link_url(...)

   General purpose link method that provides a URL based on the specified
   parameters. The ``-response`` parameter is used as the URL for the link.

Each of the general purpose link methods implement the basic behavior of
all the link methods, but are not usually used on their own. The section on
:ref:`Link Method Parameters <link-method-parameters>` below describes the
common parameters that all link methods interpret. The following sections
include the link URL, container, and parameter methods and examples of
their use.

.. note::
   The link methods do not include values for the ``-sql``, ``-username``,
   ``-password`` or the ``-returnField`` parameters in the links they generate.

.. _link-method-parameters:

Link Method Parameters
----------------------

All of the link methods accept the same parameters which allow the link that is
being formed to be customized. These parameters include all the action
parameters which can be passed to an ``inline`` method and a series of
parameters detailed in :ref:`Table: Link Method Parameters
<table-link-method-parameters>` which allow various parameters to be removed
from the generated link method.

The link methods interpret their parameters as follows:

-  The parameters are processed in the order they are specified within the link
   method. Later parameters override earlier parameters.
-  Most link methods process ``action_params`` first, then any parameters
   specified in ``link_setFormat``, and finally the parameters specified within
   the link method itself. The general purpose link methods do not include
   ``action_params`` automatically.
-  Parameters of type array are inserted into the parameters as if each
   item of the array was specified in order at the location of the array.
-  Many action parameters will only be included once in the resulting link.
   These include ``-database``, ``-table``, ``-keyField``, ``-maxRecords``, and
   any other action parameter that can only be specified once within an inline.
   The last value for the parameter will be included in the resulting link.
-  Only one action such as ``-search``, ``-findAll``, or ``-nothing`` will be
   included in the resulting link. The last action specified in the link method
   will be used.
-  Action parameters such as ``-required``, ``-op``, ``-opBegin``, ``-opEnd``,
   ``-sortField``, and ``-sortOrder`` will be included in the order they are
   specified within the method.
-  The resulting link will consist of the action followed by all action
   parameters specified once in alphabetical order, and finally all name/value
   pair parameters and keyword parameters that are specified multiple times in
   the same order they were specified in the parameter list.
-  All ``-no…`` parameters are interpreted at the location they occur in the
   parameter list. If a ``-noDatabase`` parameter is specified early in the
   parameter list and a ``-database`` parameter is included later then the
   ``-database`` parameter will be included in the resulting link.
-  The ``-noClassic`` parameter removes all action parameters that are not
   essential to specifying the search and location in the found set to an
   ``inline`` method. The ``-database``, ``-table``, ``-keyField``, and action
   are all removed. All name/value pair parameters, ``-sort…`` parameters,
   ``-op`` parameters, and either ``-maxRecords`` and ``-skipRecords`` or
   ``-keyValue`` are included.
-  The value of the ``-response`` parameter will be used as the URL for the
   resulting link. The link methods always link to a response file on the same
   server they are called. If not specified the ``-response`` will be the same
   as ``response_filePath``.
-  The ``-sql``, ``-username``, ``-password``, and ``-returnField`` parameters
   are never returned by the link methods.

.. note::
   The ``referrer`` and ``referrer_url`` methods are special cases which simply
   return the referrer specified in the HTTP request header. They do not accept
   any parameters.

.. _table-link-method-parameters:

.. tabularcolumns:: |l|L|

.. table:: Table: Link Method Parameters

   +------------------------+--------------------------------------------------+
   |Parameter               |Description                                       |
   +========================+==================================================+
   |Action Parameter        |Inserts the specified action parameter. Either    |
   |                        |appends the action parameter or overrides an      |
   |                        |existing action parameter with the new value.     |
   +------------------------+--------------------------------------------------+
   |Name/Value Pair         |Inserts the specified name/value pair.            |
   +------------------------+--------------------------------------------------+
   |Array Parameter         |An array of pairs is inserted as if each          |
   |                        |name/value pair in the array was specified in the |
   |                        |tag parameters at the location of the array.      |
   +------------------------+--------------------------------------------------+
   |``-NoAction``           |Removes the action command tag.                   |
   +------------------------+--------------------------------------------------+
   |``-NoClassic``          |Removes all parameters required to specify an     |
   |                        |action in Classic Lasso leaving only those        |
   |                        |parameters required to specify the query and      |
   |                        |current location in the found set.                |
   +------------------------+--------------------------------------------------+
   |``-NoDatabase``         |Removes the ``-database`` parameter.              |
   +------------------------+--------------------------------------------------+
   |``-NoTable``            |Removes the ``-table`` or ``-layout`` parameter.  |
   |                        |``-noLayout`` is a synonym.                       |
   +------------------------+--------------------------------------------------+
   |``-NoKeyField``         |Removes the ``-keyField`` parameter.              |
   +------------------------+--------------------------------------------------+
   |``-NoKeyValue``         |Removes the ``-keyValue`` parameter.              |
   +------------------------+--------------------------------------------------+
   |``-NoOperatorLogical``  |Removes the ``-operatorLogical`` parameter.       |
   +------------------------+--------------------------------------------------+
   |``-NoResponse``         |Removes the ``-response`` parameter.              |
   +------------------------+--------------------------------------------------+
   |``-NoMaxRecords``       |Removes the ``-maxRecords`` parameter.            |
   +------------------------+--------------------------------------------------+
   |``-NoSkipRecords``      |Removes the ``-skipRecords`` parameter.           |
   +------------------------+--------------------------------------------------+
   |``-NoParams``           |Removes name/value pairs, ``-operator``,          |
   |                        |``-operatorBegin``, ``-operatorEnd``, and         |
   |                        |``-required`` parameters.                         |
   +------------------------+--------------------------------------------------+
   |``-NoSort``             |Removes all ``-sort…`` parameters.                |
   +------------------------+--------------------------------------------------+
   |``-NoSchema``           |Removes the ``-schema`` parameter for JDBC data   |
   |                        |sources.                                          |
   +------------------------+--------------------------------------------------+
   |``-No.Name``            |Removes a specified name/value parameter.         |
   +------------------------+--------------------------------------------------+
   |``-Response``           |Specifies the file that will be used as the URL   |
   |                        |for the link tag. The link methods always link to |
   |                        |a file on the current server.                     |
   +------------------------+--------------------------------------------------+


Link URL Methods
----------------

The methods defined below each return a URL based on the current database
action. Each of these methods accepts the same parameters as specified in
:ref:`Table: Link Method Parameters <table-link-method-parameters>` above.
Examples of the link methods are included in the :ref:`Link Examples
<link-examples>`  section that follows.

.. method:: link_currentActionURL(...)

   Returns a link to the current Lasso action.

.. method:: link_firstGroupURL(...)

   Returns a link to the first group of records based on the current Lasso
   action. Sets ``-skipRecords`` to "0".

.. method:: link_prevGroupURL(...)

   Returns a link to the next group of records based on the current Lasso
   action. Changes ``-skipRecords``.

.. method:: link_nextGroupURL(...)

   Returns a link to the next group of records based on the current Lasso
   action. Changes ``-skipRecords``.

.. method:: link_lastGroupURL(...)

   Returns a link to the last group of records based on the current Lasso
   action. Changes ``-skipRecords``.

.. method:: link_currentRecordURL(...)

   Returns a link to the current record. Sets ``-maxRecords`` to "1" and changes
   ``-skipRecords``.

.. method:: link_firstRecordURL(...)

   Returns a link to the first record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and ``-skipRecords`` to "0".

.. method:: Link_PrevRecordURL(...)

   Returns a link to the next record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``.

.. method:: link_lastRecordURL(...)

   Returns a link to the last record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``.

.. method:: link_detailURL(...)

   Returns a link to the current record using the primary key and key value.
   Changes ``-keyValue``.

.. method:: referrer_url()
.. method:: referer_url()

   Returns a link to the previous page which the visitor was at before the
   current page.

   .. note::
      The ``referrer_url`` method is a special case which simply returns the
      referrer specified in the HTTP request header. It does not accept any
      parameters.


Link Anchor Methods
-------------------

The methods defined below each return an HTML anchor tag based on the current
database action. The anchor tags surround the contents of the method. If the
link method is not valid then no result is returned. Each of these methods
accepts the same parameters as specified in :ref:`Table: Link Method Parameters
<table-link-method-parameters>` above. Examples of the link methods are included
in the :ref:`Link Examples <link-examples>` section that follows.

.. method:: link_currentAction(...)

   Returns a link to the current Lasso action. Requires an associated block.

.. method:: link_firstGroup(...)

   Returns a link to the first group of records based on the current Lasso
   action. Sets ``-skipRecords`` to "0". Requires an associated block.

.. method:: link_prevGroup(...)

   Returns a link to the previous group of records based on the current Lasso
   action. Changes ``-skipRecords``. Requires an associated block.

.. method:: link_nextGroup(...)

   Returns a link to the next group of records based on the current Lasso
   action. Changes ``-skipRecords``. Requires an associated block.

.. method:: link_lastGroup(...)

   Returns a link to the last group of records based on the current Lasso
   action. Changes ``-skipRecords``. Requires an associated block.

.. method:: link_currentRecord(...)

   Returns a link to the current record. Sets ``-maxRecords`` to "1" and changes
   ``-skipRecords``. Requires an associated block.

.. method:: link_firstRecord(...)

   Returns a link to the first record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and ``-skipRecords`` to "0". Requires an associated
   block.

.. method:: link_prevRecord(...)

   Returns a link to the previous record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``. Requires an associated
   block.

.. method:: link_nextRecord(...)

   Returns a link to the next record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``. Requires an associated
   block.

.. method:: link_lastRecord(...)

   Returns a link to the last record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``. Requires an associated
   block.

.. method:: link_detail(...)

   Returns a link to the current record using the ``-keyField`` and
   ``-keyValue``. Changes ``-keyValue``. Requires an associated block.

.. method:: referer()
.. method:: referrer()

   Returns a link to the previous page which the visitor was at before the
   current page. Requires an associated block.

   .. note::
      The ``referrer`` method is a special case which simply returns the
      referrer specified in the HTTP request header. It does not accept any
      parameters.


Link Parameter Array Methods
----------------------------

The methods defined below each return an array of parameters based on the
current database action. Each of these methods accepts the same parameters as
specified in :ref:`Table: Link Method Parameters <table-link-method-parameters>`
above. Examples of the link methods are included in the :ref:`Link Examples
<link-examples>` section that follows.

.. method:: link_currentActionParams(...)

   Returns a link to the current Lasso action.

.. method:: link_firstGroupParams(...)

   Returns a link to the first group of records based on the current Lasso
   action. Sets ``-skipRecords`` to "0".

.. method:: link_prevGroupParams(...)

   Returns a link to the previous group of records based on the current Lasso
   action. Changes ``-skipRecords``.

.. method:: link_nextGroupParams(...)

   Returns a link to the next group of records based on the current Lasso
   action. Changes ``-skipRecords``.

.. method:: link_lastGroupParams(...)

   Returns a link to the last group of records based on the current Lasso
   action. Changes ``-skipRecords``.

.. method:: link_currentRecordParams(...)

   Returns a link to the current record. Sets ``-maxRecords`` to "1" and changes
   ``-skipRecords``.

.. method:: link_firstRecordParams(...)

   Returns a link to the first record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and ``-skipRecords`` to "0".

.. method:: link_prevRecordParams(...)

   Returns a link to the previous record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``.

.. method:: link_nextRecordParams(...)

   Returns a link to the next record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``.

.. method:: link_lastRecordParams(...)

   Returns a link to the last record based on the current Lasso action. Sets
   ``-maxRecords`` to "1" and changes ``-skipRecords``.

.. method:: link_detailParams(...)

   Returns a link to the current record using the primary key and key value.
   Changes ``-keyValue``.

.. _link-examples:

Link Examples
-------------

The basic technique for using the link methods is the same as that which was
described to allow site visitors to enter values into HTML forms and then use
those values within an ``inline`` action. The ``inline`` methods can have some
action parameters and search parameters specified explicitly, with variables, an
array, ``web_request->params``, or one of the link methods defining the rest.

For example, an ``inline`` could be specified to find all records within a
database as follows. The entire action is specified within the ``inline``
method. Each time a page with the code on it is visited the action will be
performed as written::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=10
   )
      // ... your code ...
   /inline

The same ``inline`` can be modified so that it can accept parameters from an
HTML form or URL which is used to load the page it is on, but can still act as a
standalone action. This is accomplished by adding an ``web_request->params``
method to the opening of the ``inline`` method::

   inline(
      web_request->params,
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=4
   )
      // ... your code ...
   /inline

Any keyword parameters or name/value pairs in the HTML form or URL that triggers
the page with this inline will be passed into the inline through the
``web_request->params`` method as if they had been typed directly into the
``inline``. However, the keyword parameters specified directly in the ``inline``
method will override any corresponding parameters from the
``web_request->params``.

Since the action ``-search`` is specified after the ``web_request->params``
array it will override any other action from the array. The action of this
inline will always be ``-search``. Similarly, all of the ``-database``,
``-table``, ``-keyField``, or ``-maxRecords`` parameters will have the values
specified in the ``inline`` overriding any values passed in through
``web_request->params``.

The various link methods can be used to generate URLs which work with the
specified inline in order to change the set of records being shown, the sort
order and sort field, etc. The link methods are able to override any parameters
not specified in the ``inline`` method, but the basic action is always performed
exactly as specified.


Navigation Links
----------------

Navigation links are created by manipulating the value for ``-skipRecords`` so
that the visitor is shown a different portion of the found set each time they
follow a link or by setting ``-keyValue`` to an appropriate value to show one
record in a database.

Create Next and Previous Links
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``link_nextGroup`` and ``link_prevGroup`` methods can be used with the
``inline`` specified above to page through a set of found records.

The ``link_nextGroup`` method is used to include a ``-noClassic`` parameter in
each link method that follows. This ensures that the ``-database``, ``-table``,
and ``-keyField`` are not included in the links generated by the link methods.

The full inline is shown below. It uses the ``records`` method to show the
people that have been found in the database and includes next and previous links
to page through the found set::

   [inline(
      web_request->params,
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=4
   )]

      <p>[found_count] records were found, showing [shown_count]
        records from [shown_first] to [shown_last].

      [records]
         <br />[field('first_name')] [field('last_name')]
      [/records]

      [link_setFormat(-noClassic)]
      [link_prevGroup]<br />Previous [maxRecords_value] Records [/link_prevGroup]
      [link_nextGroup]<br />Next [maxRecords_value] Records [/link_nextGroup]
    [/inline]

The first time this page is loaded the first four records from the database are
shown. Since this is the first group of records in the database only the ``Next
4 Records`` link is displayed::

   // =>
   // <p>16 records were found, showing 4 records from 1 to 4.
   // <br />Jane Doe
   // <br />John Person
   // <br />Jane Person
   // <br />John Doe
   // <br />Next 4 Records

If the "Next 4 Records" link is selected then the same page is
reloaded. The value for ``-skipRecords`` is taken from the link method and
passed into the ``inline`` method through the ``web_request->params``
array. The following results are displayed. This time both the "Next 4
Records" and the "Previous 4 Records" links are displayed::

   // =>
   // <p>16 records were found, showing 4 records from 5 to 8.
   // <br />Jane Surname
   // <br />John Last_Name
   // <br />Mark Last_Name
   // <br />Tom Surname
   // <br />Previous 4 Records
   // <br />Next 4 Records


Create First and Last Links
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Links to the first and last groups of records in the found set can be added
using the ``link_firstGroup`` and ``link_nextGroup`` methods. The following
``inline`` includes both next/previous links and first/last links::

   [inline(
      web_request->params,
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=4
   )]

      <p>[found_count] records were found, showing [shown_count]
         records from [shown_first] to [shown_last].

      [records]
         <br />[field('first_name')] [field('last_name')]
      [/records]

      [link_setFormat(-noClassic)]
      [link_firstGroup]<br />First [maxRecords_value] Records [/link_firstGroup]
      [link_prevGroup] <br />Previous [maxRecords_value] Records [/link_prevGroup]
      [link_nextGroup] <br />Next [maxRecords_value] Records [/link_nextGroup]
      [link_lastGroup] <br />Last [maxRecords_value] Records [/link_lastGroup]
   [/inline]

The first time this page is loaded the first four records from the database are
shown. Since this is the first group of records in the database only the "Next 4
Records" and "Last 4 Records" links are displayed. The "Previous 4 Records" and
"First 4 Records" links will automatically appear if either of these links are
selected by the visitor::

   // ->
   // <p>16 records were found, showing 4 records from 1 to 4.
   // <br />Jane Doe
   // <br />John Person
   // <br />Jane Person
   // <br />John Doe
   // <br />Next 4 Records
   // <br />Last 4 Records


Create Links to Page Through the Found Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Many Web sites include page links which allow the visitor to jump directly to
any set of records within the found set. The example ``-findAll`` returns "16"
records from "contacts" so four page links would be created to jump to the 1st,
5th, 9th, and 13th records.

A set of page links can be created using the ``link_currentActionURL`` method as
a base and then customizing the ``-skipRecords`` value as needed. The following
loop creates as many page links as are needed for the current found set::

   [inline(
      web_request->params,
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=4
   )]

      <p>[found_count] records were found, showing [shown_count]
        records from [shown_first] to [shown_last].

      [records]
         <br />[field('first_name')] [field('last_name')]
      [/records]

      [link_setFormat(-noClassic)]
      [local(count) = 0]
      [while(#count < found_count)]
         <br /><a href="[link_currentActionURL(-skipRecords=#count)]">
            Page [loop_count]
         </a>
         [#count += maxRecords_value]
      [/while]
   [/inline]

The results of this code for the example ``-search`` would be the following.
There are four page links. The first is equivalent to the "First 4 Records" link
created above and the last is equivalent to the "Last 4 Records" link created
above::

   // =>
   // <p>16 records were found, showing 4 records from 1 to 4.
   // <br />Jane Doe
   // <br />John Person
   // <br />Jane Person
   // <br />John Doe
   // <br />Page 1
   // <br />Page 2
   // <br />Page 3
   // <br />Page 4


Sorting Links
-------------

Sorting links are created by adding or manipulating ``-sortField`` and
``-sortOrder`` parameters. The same found set is shown, but the order is
determined by which link is selected. Often, the column headers in a table of
results from a database will represent the sort links that allow the table to be
resorted by the values in that specific column.


Create Links That Sort the Found Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following code performs a ``-search`` in an ``inline`` and formats the
results as a table. The column heading at the top of each table column is a link
which re-sorts the results by the field values in that column. The links for
sorting the found set are created by specifying ``-noSort`` and ``-sortField``
parameters to the ``link_firstGroup`` method::

   [inline(
      web_request->params,
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords=4
   )]

      [link_setFormat(-noClassic)]
      <table>
         <tr>
            <th>
               [link_firstGroup(-noSort, -sortOrder='first_name')]
                  First Name
               [/link_firstGroup]
            </th>
            <th>
               [link_firstGroup(-noSort, -sortOrder='last_name')]
                  Last Name
               [/link_firstGroup]
            </th>
         </tr>
      [records]
         <tr>
            <td>[field('first_name')]</td>
            <td>[field('last_name')]</td>
         </tr>
      [/records]
      </table>
   [/inline]


Detail Links
------------

Detail links are created in order to show data from a particular record in the
database table. Usually, a listing Lasso page will contain only limited data
from each record in the found set and a detail Lasso page will contain
significantly more information about a particular record.

A link to a particular record can be created using the ``link_detail`` method to
set the ``-keyField`` and ``-keyValue`` fields. This method is guaranteed to
return the selected record even if the database is changing while the visitor is
navigating. However, it is difficult to create next and previous links on the
detail page. This option is most suitable if the selected database record will
need to be updated or deleted.

Alternately, a link to a particular record can be created using
``link_currentAction`` and setting ``-maxRecords`` to "1". This method allows
the visitor to continue navigating by records on the detail page.


Create a Link to a Particular Record
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are two Lasso pages involved in most detail links. The listing Lasso page
"default.lasso" includes the ``inline`` method that defines the search for the
found set. The detail Lasso page "response.lasso" includes the ``inline`` method
that finds and display the individual record.

#. The ``inline`` method in "default.lasso" simply performs a ``-findAll``
   action. Each record in the result set is displayed with a link to
   "response.lasso" created using the ``link_detail`` method::

      [inline(
         -findAll,
         -database='contacts',
         -table='people',
         -keyField='id',
         -maxRecords=4
      )]
         [link_setFormat(-noClassic)]
         [records]<br />
            [link_detail(-response='response.lasso')]
               [field('first_name')] [field('last_name')]
            [/link_detail]
         [/records]
      [/inline]

      // =>
      // <br /><a [/* ... href info ... */]>Jane Doe</a>
      // <br /><a [/* ... href info ... */]>John Person</a>
      // <br /><a [/* ... href info ... */]>Jane Person</a>
      // <br /><a [/* ... href info ... */]>John Doe</a>

#. The ``inline`` method on "response.lasso" uses ``web_request->params`` to
   pull the values from the URL generated by the link methods. The results
   contain more information about the particular records than is shown in the
   listing. In this case, the "phone_number" field is included as well as the
   "first_name" and "last_name"::
   
      [inline(
         web_request->params,
         -search,
         -database='contacts',
         -table='people',
         -keyField='id'
      )]
         <br />[field('first_name')] [field('last_name')]
         <br />[field('phone_number')]
         [/* ... other code ... */]
      [/inline]

      // =>
      // <br />Jane Doe
      // <br />555-1212


Create a Link to the Current Record in the Found Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are two Lasso pages involved in most detail links. The listing Lasso page
"default.lasso" includes the ``inline`` method that defines the search for the
found set. The detail Lasso page "response.lasso" includes the ``inline`` method
that finds and display the individual record. The ``link_currentAction`` method
is used to create a link from "default.lasso" to "response.lasso" showing a
particular record.

#. The ``inline`` method on "default.lasso" simply performs a ``-findAll``
   action. Each record in the result set is displayed with a link to
   "response.lasso" created using the ``link_currentAction`` method::
    
      [inline(
         -findAll,
         -database='contacts',
         -table='people',
         -keyField='id',
         -maxRecords=4
      )]
         [link_setFormat(-noClassic)]
         [records]<br />
            [link_currentAction(-response='response.lasso', -maxRecords=1)]
               [field('first_name')] [field('last_name')]
            [/link_currentAction]
         [/records]
      [/inline]

      // =>
      // <br />Jane Doe
      // <br />John Person
      // <br />Jane Person
      // <br />John Doe

#. The ``inline`` method in "response.lasso" uses ``web_request->params`` to
   pull the values from the URL generated by the link methods. The results
   contain more information about the particular records than is shown in the
   listing. In this case, the "phone_number" field is included as well as the
   "first_name" and "last_name."
    
   The detail page can also contain links to the previous and next records in
   the found set. These are created using the ``link_prevRecord`` and
   ``link_nextRecord`` methods. The visitor can continue navigating the found
   set record by record::
    
      [Inline(
         web_request->params,
         -search,
         -database='contacts',
         -table='people',
         -keyField='id'
      )]
         <br />[field('first_name')] [field('last_name')]
         <br />[field('phone_number')]

         [link_setFormat(-noClassic)]
         <br />[link_prevRecord] Previous Record [/link_prevRecord]
         <br />[link_nextRecord] Next Record [/link_nextRecord]
      [/inline]

      // =>
      // <br />Jane Last_Name
      // <br />555-1212
      // <br />Previous Record
      // <br />Next Record