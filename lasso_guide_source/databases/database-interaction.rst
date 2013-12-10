.. http://www.lassosoft.com/Language-Guide-Database-Interaction
.. _database-interaction:

*********************************
Database Interaction Fundamentals
*********************************

A database is the cornerstone of any significant web application. One of the
primary applications of Lasso is to perform database actions and format the
results of those actions. This chapter introduces the fundamentals of specifying
database actions in Lasso.


Inlines
=======

The `inline` method is used to specify a database action and to present the
results of that action within a Lasso page. The database action is specified
using keyword parameters passed to the inline. Additional name/value parameters
specify the user-defined parameters of the database action. Each inline normally
represents a single database action, but when using SQL statements a single
inline can be use to perform batch operations as well. Additional actions can be
performed in subsequent or nested `inline` methods.

.. method:: inline(...)

   Performs the database action specified by the parameters. The results of the
   database action are available inside the required capture block or, if an
   ``-inlineName`` is specified, later on the page within `resultSet`,
   `records`, or `rows` methods.

   :param -database:
      Specifies the name of the database that will be used to perform the
      database action. If no ``-host`` is specified then the database is used to
      look up the data source specified in Lasso Admin for that database.
      Optional.
   :param -host:
      Specifies the connection parameters for a host within the inline. This
      provides an alternative to setting up data source hosts within Lasso
      Admin. Optional. See the table :ref:`database-host-parameters` for the
      options available.
   :param -inlineName:
      Specifies a name for the inline. The same name can be used with
      `resultSet`, `records`, or `rows` methods to return the records from the
      inline later on in the page. Optional.
   :param -statementOnly:
      Specifies that the inline should generate the internal statement required
      to perform the action, but not actually perform the action. The statement
      can be fetched with `action_statement`. Optional.
   :param -table:
      Specifies the table that should be used to perform the database action.
      Most database actions require that a table be specified. The ``-table`` is
      used to determine what encoding will be used when interpreting database
      results, so a ``-table`` may be necessary even for an inline with an
      ``-sql`` action. Optional.

The results of the database action can be displayed within the contents of the
inline's capture block using the `records` or `rows` methods along with `field`
or `column` methods. Alternately, the inline can be named using ``-inlineName``
and the results can be displayed later using `resultSet`, `records`, or `rows`
methods.

The entire database action can be specified directly in the opening `inline`
method, or visitor-defined aspects of the action can be retrieved from query or
post parameters. Nested `inline` methods can be used to create complex database
actions.

The ``-statementOnly`` option instructs the data source to generate the
implementation-specific statement required to perform the desired database
action, but not to actually perform it. The generated statement can be returned
with `action_statement`. This is useful for seeing the statement Lasso will
generate for an action.


Database Actions
----------------

A :dfn:`database action` is performed to retrieve data from a database or to
manipulate data stored in a database. Database actions can be used in Lasso to
query records in a database that match specific criteria, to return a particular
record from a database, to add a record to a database, to delete a record from a
database, to fetch information about a database, or to navigate through the
found set from a database search. Additionally, database actions can be used to
execute SQL statements in databases that understand SQL.

The database actions in Lasso are defined according to which action parameter is
used to trigger the action. The following table lists the parameters that
perform database actions that are available in Lasso.

.. tabularcolumns:: |l|L|

.. _database-action-parameters:

.. table:: Database Action Parameters

   ============== ==============================================================
   Parameter      Description
   ============== ==============================================================
   ``-search``    Finds records in a database that match specific criteria,
                  returns detail for a particular record in a database, or
                  navigates through a found set of records.
   ``-findAll``   Returns all records in a specific database table.
   ``-random``    Returns a single, random record from a database table.
   ``-add``       Adds a record to a database table.
   ``-update``    Updates a specific record in a database table.
   ``-delete``    Removes a specified record from a database table.
   ``-show``      Returns information about the tables and fields within a
                  database.
   ``-sql=?``     Executes a SQL statement in a compatible data source. Only
                  works with SQLite, MySQL, and other SQL databases.
   ``-prepare=?`` Creates a prepared SQL statement in a compatible data source.
                  Nested inlines will execute the prepared statement with
                  different values.
   ``-nothing``   The default action which performs no database actions, but
                  simply passes the parameters of the action.
   ============== ==============================================================

.. note::
   The table :ref:`database-action-parameters` lists all of the database actions
   that Lasso supports. Individual data source connectors may only support a
   subset of these parameters. For example, the Lasso Connector for FileMaker
   Server does not support the ``-sql`` action. See the documentation for
   third-party data source connectors for information about what actions they
   support.

Each database action parameter requires additional parameters in order to
execute the action properly. These parameters are specified using additional
keyword parameters. For example, a ``-database`` parameter specifies the
database in which the action should take place and a ``-table`` parameter
specifies the specific table from that database in which the action should take
place. Keyword parameters specify the query for a ``-search`` action, the
initial values for the new record created by an ``-add`` action, or the updated
values for an ``-update`` action.

Full documentation of which inline parameters are required for each action are
detailed in the section specific to that action in this chapter or in subsequent
chapters.


Specifying a -FindAll Action Within an Inline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows an `inline` method that has a ``-findAll`` database
action specified. The inline includes a ``-findAll`` parameter to specify the
action, ``-database`` and ``-table`` parameters to specify the database and
table from which records should be returned, and a ``-keyField`` parameter to
specify the key field for the table. The entire database action is hard-coded
within the `inline` method.

The method `found_count` returns how many records are in the database. The
`records` method executes the code in the capture block for each record in the
found set. The `field` methods are repeated for each found record, creating a
listing of the names of all the people stored in the "people" table. ::

   inline(
      -findAll,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {^
      'There are ' + found_count + ' record(s) in the People table.\n'
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // There are 2 record(s) in the People table.
   // <br />John Doe
   // <br />Jane Doe


Specifying a -Search Action Within an Inline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows an `inline` method that has a ``-search`` database
action . The inline includes a ``-search`` parameter to specify the action,
``-database`` and ``-table`` parameters to specify the database and table
records from which records should be returned, and a ``-keyField`` parameter to
specify the key field for the table. The subsequent keyword parameters,
``'first_name'='John'`` and ``'last_name'='Doe'``, specify the query that will
be performed in the database. Only records for John Doe will be returned. The
entire database action is hard-coded within the inline.

The method `found_count` returns how many records for "John Doe" are in the
database. The `records` method executes the code in the capture block for each
record in the found set. The `field` methods are repeated for each found record,
creating a listing of all the records for "John Doe" stored in the "people"
table::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe'
   ) => {^
      'There were ' + found_count + ' record(s) found in the People table.\n'
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

   // =>
   // There were 1 record(s) found in the People table.
   // <br />John Doe


Displaying the Generated Action Statement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `action_statement` method within the `inline` method. This will return
the action statement that was generated by the data source connector to fulfill
the specified database action. For SQL data sources like MySQL and SQLite a SQL
statement will be returned. Other data sources may return a different style of
action statement. ::

   inline(-search, -database='example', -table='example', /* etc. */) => {^
      action_statement
      // ...
   ^}

To see the action statement that would be generated by the data source without
actually performing the database action the ``-statementOnly`` parameter can be
specified in the `inline` method. The `action_statement` method will return
the same value it would for a normal inline database action, but the database
action will not actually be performed. ::

   inline(-search, -database='example', -table='example', -statementOnly, /* etc. */) => {^
      action_statement
      // ...
   ^}


Inlines and HTML Forms
----------------------

The previous two examples show how to specify a hard-coded database action
completely within an `inline` method. This is an excellent way to embed a
database action that will be the same every time a page is loaded, but does not
provide any room for visitor interaction.

A more powerful technique is to use values from an HTML form or URL to allow a
site visitor to modify the database action that is performed within the inline.
The following two examples demonstrate two different techniques for doing this
using the singular `web_request->param` method and the
:type:`tie`-based `web_request->params` method.


Using HTML Form Values Within an Inline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An inline-based database action can make use of visitor-specified parameters by
reading values from an HTML form that the visitor customizes and submits to
trigger the page containing the `inline` method.

The following HTML form provides two inputs into which the visitor can type
information. An input is provided for "first_name" and one for "last_name".
These correspond to the names of fields in the "people" table. The action
of the form is set to "/response.lasso" which will contain the inline that
performs the actual database action::

   <form action="response.lasso" method="POST">
      <br />First Name: <input type="text" name="first_name" value="" />
      <br />Last Name: <input type="text" name="last_name" value="" />
      <br /><input type="submit" name="submit" value="Search" />
   </form>

The `inline` method in "response.lasso" contains the :type:`pair` parameter
``'first_name'=web_request->param('first_name')``. The `web_request->param`
method instructs Lasso to fetch the input named "first_name" from the form post
parameters submitted to the current page being served, namely the form shown
above. The inline contains a similar pair parameter for "last_name". ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'=web_request->param('first_name'),
      'last_name'=web_request->param('last_name')
   ) => {^
      'There were ' + found_count + ' record(s) found in the People table.\n'
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

If the visitor entered "Jane" for the first name and "Doe" for the last name
then the following results would be returned::

   // =>
   // There were 1 record(s) found in the People table.
   // <br />Jane Doe

As many parameters as needed can be named in the HTML form and then retrieved in
the response page via the inline.

.. tip::
   The `web_request->param` member method is a replacement for the
   `action_param` or ``form_param`` methods used in prior versions of Lasso for
   fetching GET or POST data.


Using an Array of Form Values Within an Inline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Rather than specifying each `web_request->param` individually, an entire set of
HTML form parameters can be entered into an `inline` method using the
`web_request->params` method. Inserting the `web_request->params` method into an
inline functions as if all the parameters and name/value pairs in the HTML form
were placed into the inline at the location of the `web_request->params`
parameter.

The `inline` method in our updated "response.lasso" contains the parameter
`web_request->params`. This instructs Lasso to take all the parameters from the
HTML form or URL which results in the current page being loaded and insert them
in the inline as if they had been typed at the location of
`web_request->params`. This will cause the name/value pairs for "first_name" and
"last_name" entered in the form above to be inserted into the inline. ::

   inline(
      web_request->params,
      -search,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {^
      'There were ' + found_count + ' record(s) found in the People table.\n'
      records => {^
         '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
      ^}
   ^}

If the visitor entered "Jane" for the first name and "Doe" for the last name
then the following results would be returned::

   // =>
   // There were 1 record(s) found in the People table.
   // <br />Jane Doe

As many parameters as needed can be named in the HTML form. They will all be
passed into the inline at the location of the `web_request->params` method.

.. tip::
   The `web_request->params` member method is a replacement for the
   `action_params` method used in prior versions of Lasso for fetching GET or
   POST data.


Setting HTML Form Values
^^^^^^^^^^^^^^^^^^^^^^^^

If the Lasso page containing an HTML form is the action to an HTML form or the
URL has query parameters, then the values of the HTML form inputs can be set to
values passed from the previous Lasso page using `web_request->param`.

For example, if a form is on "default.lasso" and the action of the form is also
"default.lasso" then the same page will be reloaded with the visitor-specified
form values each time the form is submitted. The following HTML form uses
`web_request->param` calls to automatically restore the values the user
specified in the form previously each time the page is reloaded::

   <form action="default.lasso" method="POST">
      <br />First Name: <input type="text" name="first_name" value="[web_request->param('first_name')]" />
      <br />Last Name: <input type="text" name="last_name" value="[web_request->param('last_name')]" />
      <br /><input type="submit" name="submit" value="Submit" />
   </form>


Nesting Inline Database Actions
-------------------------------

Database actions can be combined to perform compound database actions. All the
records in a database that meet certain criteria could be updated or deleted.
Or, all the records from one database could be added to a different database.
Or, the results of searches from several databases could be merged and used to
search another database.

Database actions are combined by nesting `inline` methods. For example, if
inlines are placed inside a `records` method within another inline then the
inner `inline` methods will execute once for each record found in the outer
`inline` method.

All database result methods function for only the innermost `inline` method.
Variables can pass through into nested inlines.

.. tip::
   SQL nested inlines can also be used to perform reversible SQL transactions in
   transaction-compliant data sources. See the :ref:`sql-transactions` section
   in the :ref:`sql-data-sources` chapter for more information.


Updating Specific Records with Nested Inlines
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This example will use nested `inline` methods to change the last name of all
people whose last name is currently "Doe" in a database to "Person". The outer
inline performs a hard-coded search for all records with "last_name" equal to
"Doe". The inner inline updates each record so "last_name" is now equal to
"Person". The output confirms that the conversion went as expected by outputting
the new values. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'last_name'='Doe',
      -maxRecords='all'
   ) => {^
      records => {^
         inline(
            -update,
            -database='contacts',
            -table='people',
            -keyField='id',
            -keyValue=keyField_value,
            'last_name'='Person'
         ) => {^
            '<br />Name is now ' + field('first_name') + ' ' + field('last_name') + '\n'
         ^}
      ^}
   ^}

   // =>
   // <br />Name is now John Person
   // <br />Name is now Jane Person


Array-based Inline Parameters
-----------------------------

Most parameters used within an `inline` method specify an action. Additionally,
keyword parameters and name/value pair parameters can be stored in an array and
then passed into an inline as a group. Any single value in an inline that is an
array object will be interpreted as a series of parameters inserted at the
location of the array. This technique is useful for programmatically assembling
database actions.

Many parameters can only take a single value within an `inline` method. For
example, only a single action can be specified and only a single database can be
specified. The last parameter defines the value that will be used for the
action. For example, the last ``-database`` parameter defines the value that
will be used for the database of the action. If an array parameter comes first
in an inline then all subsequent parameters will override any conflicting values
within the array parameter.


Using an Array to Pass Values Into an Inline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following Lasso code performs a ``-findAll`` database action with the
parameters first specified in an array and stored in the variable "params", then
passed into an `inline` method all at once. The value for ``-maxRecords`` in the
inline overrides the value specified within the array parameter since it is
specified later. Only the number of records found in the database are returned::

   local(params) = (:
      -findAll,
      -database='contacts',
      -table='people',
      -maxRecords=50
   )
   inline(#params, -maxRecords=100) => {^
      'There are ' + found_count + ' record(s) in the People table.'
   ^}

   // => There are 2 record(s) in the People table.


Inline Introspection Methods
----------------------------

Lasso has a set of methods that return information about the current inline's
action. The parameters of the action itself can be returned or information about
the action's results can be returned.

The following methods can be used within an `inline` method's capture block to
return information about the action specified by the inline.

.. method:: action_param(name::string, join::string='\r\n')
.. method:: action_param(name::string, -count)
.. method:: action_param(name::string, position::integer)

   Requires a parameter specifying the name of a keyword or pair parameter
   passed to the `inline` method. If no other parameter is specified, then it
   returns all values it finds for the specified name joined together with a
   line break. An optional second parameter can specify what string to use as a
   separator when it finds more than one parameter with the specified name.

   To find the number of parameters passed to an `inline` method that share a
   specified name, you can specify ``-count`` as the second parameter. This will
   return the number of parameters sharing the same name. To get the value of a
   specific one of these parameters, instead pass an integer specifying which
   parameter you want. For example, if there are 4 parameters that share the
   same name passed to an inline, you can retrieve the one that comes third by
   passing a "3" as the second value to `action_param`.

.. method:: action_params()

   Returns an array containing all of the keyword parameters and pair parameters
   that define the current action.

.. method:: action_statement()

   Returns the statement that was generated for the data source to implement the
   requested action. For SQL databases this will return a SQL statement. Other
   data sources may return different values.

.. method:: database_name()

   Returns the name of the current database.

.. method:: keyField_name()
.. method:: keyColumn_name()

   Returns the name of the current key field.

.. method:: keyField_value()
.. method:: keyColumn_value()

   Returns the name of the current key value if defined. Can also be used for
   actions that add a new record to get the newly generated ID.

.. method:: lasso_currentAction()

   Returns the name of the current action.

.. method:: maxRecords_value()

   Returns the number of records from the found set that are currently being
   displayed.

.. method:: skipRecords_value()

   Returns the current offset into a found set.

.. method:: table_name()
.. method:: layout_name()

   Returns the name of the current table.

.. method:: search_arguments()

   Executes a capture block once for each pair parameter in the current action.

.. method:: search_fieldItem()

   Used in the capture block of a `search_arguments` method. This method returns
   the "name" portion of the current pair parameter.

.. method:: search_valueItem()

   Used in the capture block of a `search_arguments` method. This method returns
   the "value" portion of the current pair parameter.

.. method:: search_operatorItem()

   Used in the capture block of a `search_arguments` method. This method returns
   the operator associated with the current pair parameter.

.. method:: sort_arguments()

   Executes a capture block once for each sort parameter in the current action.

.. method:: sort_fieldItem()

   Used in the capture block of a `sort_arguments` method. This method returns
   the field that will be sorted.

.. method:: sort_orderItem()

   Used in the capture block of a `sort_arguments` method. This method returns
   the direction in which the field will be sorted.


Display Parameters of the Current Database Action
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The value of the `action_params` method in the following example is formatted
to clearly show the elements of the returned array::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {^
      action_params
   ^}

   // =>
   // staticarray(
   //     (-search = true),
   //     (-database = contacts),
   //     (-table = people),
   //     (-keyField = id)
   // )


Display Parameter Pairs of the Current Database Action
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Loop through the `action_params` method and display only name/value pairs for
which the name does not start with a hyphen, i.e., any pair parameters and not
keyword parameters. The following example shows a search of the "people" table
of the "contacts" database for a person named "John Doe"::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe'
   ) => {^
      with param in action_params
      where not #param->first->beginsWith('-')
      sum '<br />' + #param->asString->encodeHtml + '\n'
   ^}

   // =>
   // <br />(first_name = John)
   // <br />(last_name = Doe)


Display Action Parameters to a Site Visitor
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `search_arguments` method can be used in conjunction with the
`search_fieldItem`, `search_valueItem` and `search_operatorItem` methods to
return a list of all pair parameters and associated operators specified in a
database action. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe'
   ) => {^
      search_arguments => {^
         '<br />' + search_fieldItem + ' ' + search_operatorItem + ' ' + search_valueItem + '\n'
      ^}
   ^}

   // =>
   // <br />first_name BW John
   // <br />last_name BW Doe

The `sort_arguments` method can be used in conjunction with the
`sort_fieldItem` and `sort_orderItem` methods to return a list of all sort
parameters specified in a database action. ::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -sortField='first_name', -sortOrder='descending',
      -sortField='last_name'
   ) => {^
      sort_arguments => {^
         '<br />' + sort_fieldItem + ' ' + sort_orderItem + '\n'
      ^}
   ^}

   // =>
   // <br />first_name descending
   // <br />last_name ascending


.. _database-action-results:

Inline Action Result Methods
----------------------------

The following documentation details the methods that allow information about the
results of the current action to be returned. These methods provide information
about the current found set rather than providing data about the database or
providing information about what database action was performed.

.. method:: field(name::string, ...)
.. method:: column(name::string, ...)

   Returns the value for a specified field from the result set. Can optionally
   take one of the following encoding keyword parameters: ``-encodeNone``,
   ``-encodeHtml``, ``-encodeBreak``, ``-encodeSmart``, ``-encodeUrl``,
   ``-encodeStrictUrl``, ``-encodeXml``.

.. method:: found_count()::integer

   Returns the number of records found by the database action.

.. method:: records(inlineName::string)
.. method:: records(-inlineName::string= ?)
.. method:: rows(inlineName::string)
.. method:: rows(-inlineName::string= ?)

   Loops once for each record in the found set. Any `field` methods within the
   `records` or `rows` methods will return the value for the specified field in
   each row in turn. Can be used outside of an inline capture block by
   specifying the name of a previously declared inline method with an
   ``-inlineName`` keyword parameter or just by passing in an inline name.

.. method:: records_array()
.. method:: rows_array()

   Returns the complete found set in a staticarray of staticarrays. The outer
   staticarray contains one staticarray for every row in the found set. The
   inner staticarrays contain one item for each field in the result set.

.. method:: records_map(...)

   Returns the complete found set in a map of maps. See the table below for
   details about the parameters and output of `records_map`.

   :param -keyField:
      The name of the field to use as the key for the outer map. Defaults to the
      current `keyField_name`, "ID", or the first field of the database results.
   :param -returnField:
      Specifies a field name that should be included in the inner map. Should be
      called multiple times to include multiple fields. If no ``-returnField``
      is specified then all fields will be returned.
   :param -excludeField:
      The name of a field to exclude from the inner map. If no ``-excludeField``
      is specified then all fields will be returned.
   :param -fields:
      An array of field names to use for the inner map. By default the value for
      `field_names` will be used.
   :param -type:
      By default the method returns a map of maps. By specifying
      ``-type='array'`` the method will instead return an array of maps. This
      can be useful when the order of records is important.

.. method:: resultSet_count(-inlineName= ?)

   Returns the number of result sets that were generated by the inline. This
   will generally only be applicable to inlines that include a ``-sql``
   parameter with multiple statements. An optional ``-inlineName`` parameter
   will return the number of result sets that a named inline has, outside of the
   inline's capture block.

.. method:: resultSet(-inlineName= ?)
.. method:: resultSet(num::integer, -inlineName= ?)
.. method:: resultSet(num::integer, inlineName::string)

   Returns a single result set from an inline. The method can take an integer
   for its parameter to specify which result set to return. This defaults to the
   first set if it is not specified. An optional ``-inlineName`` keyword
   parameter or just passing in an inline name will return the indicated result
   set from a named inline.

.. method:: shown_count()

   Returns the number of records shown in the current found set. Less than or
   equal to `maxRecords_value`.

.. method:: shown_first()

   Returns the number of the first record shown from the found set. Usually
   `skipRecords_value` plus one.

.. method:: shown_last()

   Returns the number of the last record shown from the found set.

.. note::
   Examples of using most of these methods are provided in the
   :ref:`searching-displaying` and :ref:`sql-data-sources` chapters.

The action result methods can be used to display information about the current
found set. For example, the following code generates a status message that can
be displayed under a database listing::

   'Found ' + found_count + ' records.\n'
   '<br />Displaying ' + shown_count + ' records from ' + shown_first + ' to ' + shown_last + '.'

   // =>
   // Found 100 records.
   // Displaying 10 records from 61 to 70.

These methods can also be used to create links that allow a visitor to navigate
through a found set.


Using a Records Array
^^^^^^^^^^^^^^^^^^^^^

The `records_array` method can be used to get access to all of the data from an
inline operation. The method returns a staticarray with one element for each
record/row in the found set. Each element is itself a staticarray that contains
one element for each field/column in the found set.

The method can either be used to quickly output all of the data from the inline
operation or can be used with the `iterate` methods or query expressions to
access the data programmatically. (Of course, at that point, you probably just
want to use the `records` or `rows` methods with the `field` or `column`
methods.) ::

   inline(-search, -database='contacts', -table='people') => {^
      records_array
   ^}

   // => staticarray(staticarray(1, John, Doe), staticarray(1, Jane, Doe), ...)

The output can be made easier to read on a web page using the `iterate` method
and the `array->join` method::

   inline(-search, -database='contacts', -table='people') => {^
      iterate(records_array, local(record)) => {^
         '<br />' + ('"' + #record->join('", "') + '"')->encodeHtml + '\n'
      ^}
   ^}

   // =>
   // <br />&quot;1&quot;, &quot;John&quot;, &quot;Doe&quot;
   // <br />&quot;2&quot;, &quot;Jane&quot;, &quot;Doe&quot;
   // ...

   // Web output
   // =>
   // "1", "John", "Doe"
   // "2", "Jane", "Doe"
   // ...

The output can be listed with the appropriate field names by using the
`field_names` method. This method returns an array that contains each field name
from the current found set. The `field_names` method will always contain the
same number of elements as the elements of the `records_array` method. ::

   inline(-search, -database='contacts', -table='people') => {^
      '<table>\n'
      '<tr><td>' + field_names->join('</td><td>')->encodeHtml(false, true) + '</td></tr>\n'
      iterate(records_array, local(record)) => {^
         '<tr>\n'
         '   <td>' + #record->join('</td><td>')->encodeHtml(false, true) + '</td>\n'
         '</tr>\n'
      ^}
      '</table>\n'
   ^}

   // =>
   // <table>
   // <tr><td>id</td><td>first_name</td><td>last_name</td></tr>
   // <tr>
   //    <td>1</td><td>John</td><td>Doe</td>
   // </tr>
   // <tr>
   //    <td>2</td><td>Jane</td><td>Doe</td>
   // </tr>
   // ...
   // </table>

Together the `field_names` and `records_array` methods provide a programmatic
process of accessing all the data returned by an inline action. There may be
some cases when these methods yield better performance than using `records`,
`field`, and `field_name` methods.


Using a Records Map
^^^^^^^^^^^^^^^^^^^

The `records_map` method functions similarly to the `records_array` method, but
returns all of the data from an inline operation as a map of maps. The keys for
the outer map are the key field values for each record from the table. The keys
for the inner map are the field names for each record in the found set. ::

   inline(-search, -database='contacts', -table='people', -keyField='id') => {^
      records_map
   ^}

   // => map(1 = map(first = John, last = Doe), 2 = map(first = Jane, last = Doe), ...)


Database Schema Inspection Methods
----------------------------------

The schema of a database can be inspected using the ``database_…`` methods or
the inline ``-show`` action parameter which allows information about a database
to be returned using the `field_name` method. Value lists within FileMaker
Server databases can also be accessed using the ``-show`` parameter. This is
documented in the :ref:`filemaker-data-sources` chapter.

The ``-show`` action parameter functions like the ``-search`` parameter except
that no name/value pair parameters, sort parameters, result parameters, or
operator parameters are required. The only other parameters required for a
``-show`` action are the ``-database`` and ``-table`` parameters. It is also
recommended that you specify the ``-keyField`` parameter.

The methods detailed below allow the schema of a database to be inspected. The
`field_name` method must be used in concert with a ``-show`` action or any
database action that returns results including ``-search``, ``-add``,
``-update``, ``-random``, or ``-findAll``. The `database_names` and
`database_tableNames` methods can be used on their own.

.. method:: database_names()

   Executes the capture block for every database specified in Lasso Admin.
   Requires using `database_nameItem` to show results.

.. method:: database_nameItem()

   Used inside the capture block of a `database_names` method to return the name
   of the current database.

.. method:: database_realName(alias::string)

   Returns the real name of a database given the alias that Lasso uses for the
   name.

.. method:: database_tableNames(dbname::string)

   Executes the capture block for every table in the specified database.
   Requires using `database_tableNameItem` to show results.

.. method:: database_tableNameItem()

   Used inside the capture block of a `database_tableNames` method to return the
   name of the current table.

.. method:: field_name(-count)
.. method:: field_name(position::integer)
.. method:: field_name(position::integer, -type)
.. method:: column_name(-count)
.. method:: column_name(position::integer)
.. method:: column_name(position::integer, -type)

   If passed the parameter ``-count`` then it returns the number of fields in
   the current table. If passed an integer, it returns the name of a field at
   that position in the current database and table. If passed an integer and
   then the ``-type`` parameter, it returns the type of field rather than the
   name. Types include "Text", "Number", "Date/Time", "Boolean", and "Unknown".

.. method:: field_names()
.. method:: column_names()

   Returns an array containing all the field names in the current result set.
   This is the same data as returned by `field_name`, but in a format more
   suitable for iterating or other data processing.


List All Databases Entered in Lasso Admin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows how to list the names of all databases set in Lasso
Admin using the `database_names` and `database_nameItem` methods::

   database_names => {^
      '<br />' + loop_count + ': ' + database_nameItem + '\n'
   ^}

   // =>
   // <br />1: Contacts
   // <br />2: Examples
   // <br />3: Site


List All Tables Within a Database
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows how to list the names of all the tables within a
database using the `database_tableNames` and `database_tableNameItem` methods.
The tables within the "Site" database are listed::

   database_tableNames('contacts') => {^
      '<br />' + loop_count + ': ' + database_tableNameItem + '\n'
   ^}

   // =>
   // <br />1: companies
   // <br />2: people


List All Fields Within a Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example demonstrates how to return information about the fields in
a table using the `inline` method to perform a ``-show`` action. A `loop` method
loops through the number of fields in the table and the name and type of each
field is returned. The fields within the "contacts" table are shown::

   inline(
      -show,
      -database='contacts',
      -table='people',
      -keyField='id'
   ) => {^
      loop(field_name(-count)) => {^
         '<br />' + loop_count + ': ' + field_name(loop_count) + ' (' + field_name(loop_count, -type) + ')\n'
      ^}
   ^}

   // =>
   // <br />1: creation_date (Date)
   // <br />2: id (Number)
   // <br />3: first_name (Text)
   // <br />4: last_name (Text)


.. _database-inline-connection:

Inline Connection Options
=========================

Lasso provides two different ways to specify the data source that should execute
an inline database action. The connection characteristics for the data source
host can be specified entirely within the inline or the connection
characteristics can be specified within Lasso Admin and then looked up based on
which ``-database`` is specified within the inline.

Each of these options is described in more detail below including when one may
be preferable to the other and the drawbacks of each. The database method is
used throughout most of the examples in this documentation.


Database Name Method
--------------------

If an inline contains only a ``-database`` parameter, then it is used to look up
what host and data source should be used to service the inline. If there is a
``-table`` parameter, Lasso uses this to look up what encoding should be used
for the results of the database action. If an inline does not have a specified
``-database`` then it inherits the ``-database`` (and ``-table`` and
``-keyField``) from the surrounding inline.

:Advantages:
   When using the database method, all of the connection characteristics for the
   data source host are defined in Lasso Admin. This makes it easy to change the
   characteristics of a host, and even move databases from one host to another,
   without modifying any Lasso code.

:Disadvantages:
   Setting up a new data source when using the database method requires visiting
   Lasso Admin. This helps promote good security practices, but can be an
   impediment when working on simple web sites or when quickly mocking up
   solutions. Additionally, having part of the set up for a website in Lasso
   Admin means that Lasso must be configured properly in order to deploy a
   solution. It is sometimes desirable to have all of the configuration of a
   solution contained within the code files of the solution itself.


Host Array Method
-----------------

With the host array method, all of the characteristics of the data source host
that will be used to process the inline database action are specified directly
within the inline.

:Advantages:
   Data source hosts can be quickly specified directly within an inline. No need
   to visit Lasso Admin to set up a new data source host. Additionally, there is
   reduced overhead since the connection information doesn't need to be
   retrieved from the SQLite database.

:Disadvantages:
   The username and password for the host must be embedded within the Lasso
   code. (Although this can be in code that is not in the web root, thereby
   mitigating this disadvantage.) Also, switching data source hosts can be more
   difficult if inline hosts have been hard-coded.

Inline hosts are specified using a ``-host`` parameter within the inline. The
value for the parameter is an array that specifies the connection
characteristics for the database host. The following example shows an inline
host for the MySQL data source that connects to "localhost" using a username of
"lasso"::

   inline(
      -host=(: -datasource='mysqlds', -name='localhost', -username='lasso', -password='secret'),
      -sql="SHOW DATABASES;"
   ) => {^
      records_array
   ^}

   // => staticarray(staticarray(contacts), staticarray(examples), staticarray(site))

The following table lists all of the parameters that can be specified within the
``-host`` array. Some data sources may require that just the ``-datasource`` be
specified, but most data sources will require ``-datasource``, ``-name``,
``-username``, and ``-password``.

The ``-host`` parameter can also take a value of "inherit" which specifies that
the ``-host`` from the surrounding inline should be used. This is necessary when
specifying a ``-database`` within nested inlines to prevent Lasso from looking
up the database as it would using the database method.

.. tabularcolumns:: |l|L|

.. _database-host-parameters:

.. table:: Host Array Parameters

   ==================== ========================================================
   Parameter            Description
   ==================== ========================================================
   ``-dataSource=?``    Required data source name. The name for each data source
                        can be found in the "Datasources" section of Lasso
                        Server Admin.
   ``-name=?``          The IP address, DNS host name, or connection string for
                        the data source. Required for most data sources.
   ``-port=?``          The port for the data source. Optional.
   ``-username=?``      The username for the data source connection. Required
                        for most data sources.
   ``-password=?``      The password for the username. Required for most data
                        sources.
   ``-schema=?``        The schema for the data source connection. Required for
                        some data sources.
   ``-tableEncoding=?`` The table encoding for the data source connection.
                        Defaults to "UTF-8". Optional.
   ``-extra=?``         Configuration information that may be used by some data
                        sources. Optional.
   ==================== ========================================================

.. note::
   Consult the documentation for each data source for details about which
   parameters are required, their format, and whether the ``-extra`` parameter
   is used.

Once a ``-host`` array has been specified the rest of the parameters of the
inline will work much the same as they do in inlines that use a configured data
source host. The primary differences are explained here:

-  Nested inlines will inherit the ``-host`` from the surrounding inline if they
   are specified with ``-host='inherit'`` or if they do not contain a
   ``-database`` parameter.

-  Nested inlines that have a ``-database`` parameter and no ``-host`` parameter
   will use the ``-database`` parameter to look up the data source host.

-  Nested inlines can specify a different ``-host`` parameter than the
   surrounding inline. Lasso can handle arbitrarily nested inlines each of which
   use a different host.

-  The parameters ``-database``, ``-table``, ``-keyField`` (or ``-key``), and
   ``-schema`` may be required depending on the database action. Inline actions
   such as ``-search``, ``-findAll``, ``-add``, ``-update``, ``-delete``, etc.
   require that the database, table, and key field be specified just as they
   would need to be in any inline.

-  Some SQL statements may also require that a ``-database`` be specified. For
   example, in MySQL, a host-level SQL statement like ``SHOW DATABASES`` doesn't
   require that a ``-database`` be specified. A table-level SQL statement like
   ``SELECT * FROM 'people'`` won't work unless the ``-database`` is specified
   in the inline. (A fully qualified SQL statement like ``SELECT * FROM
   'contacts'.'people'`` will also work without a ``-database``.)
