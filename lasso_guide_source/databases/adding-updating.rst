.. _adding-updating:

***************************
Adding and Updating Records
***************************

Lasso provides action parameters for using the `inline` method for adding,
updating, and deleting records within Lasso compatible databases. These action
parameters are used in conjunction with additional keyword and pair parameters
in order to perform the desired database action in a specific database and table
or within a specific record.

The `inline` parameters documented in this chapter are listed in :ref:`Table:
Add & Update Parameters <inline-adding-and-updating-parameters>`. The sections
that follow describe the additional keyword and pair parameters required for
each database action.

.. _inline-adding-and-updating-parameters:

.. table:: Table: Add & Update Parameters

   +---------------+-----------------------------------------------------------+
   |Parameter      |Description                                                |
   +===============+===========================================================+
   |``-add``       |Adds a record to a database.                               |
   +---------------+-----------------------------------------------------------+
   |``-update``    |Updates a record or records within a database.             |
   +---------------+-----------------------------------------------------------+
   |``-delete``    |Removes a record or records from a database.               |
   +---------------+-----------------------------------------------------------+


Character Encoding
==================

Lasso stores and retrieves data from data sources based on the preferences
established in the Datasources section of Lasso Admin. The following rules apply
for each standard data source.

Inline Host
   The character encoding can be specified explicitly using a ``-tableEncoding``
   parameter within the ``-host`` array.

Inline Table
   The charcter encoding of the specified table using the ``-table`` parameter
   if not specified using ``-tableEncoding`` in a ``-host`` array is used.

MySQL
   By default all communication is in the UTF-8 character set.

FileMaker Server
   By default all communication is in the MacRoman character set when Lasso
   Server is hosted on OS X or in the Latin-1 (ISO 8859-1) character set when
   Lasso Server is hosted on Windows.

JDBC
   All communication with JDBC data sources is in the UTF-8 character set.


Error Reporting
===============

After a database action has been performed, Lasso reports any errors which
occurred via the `error_currentError` method. The value of this method should
be checked to ensure that the database action was successfully performed.


Display the Current Error Code and Message
------------------------------------------

The following code can be used to display the current error message. This code
should be placed in a Lasso page which is a response to a database action or
within the associated block of an `inline` method::

   [error_code]: [error_msg]

If the database action was performed successfully then the following result will
be returned::

   // => 0: No Error


Check for a Specific Error Code and Message
-------------------------------------------

The following example shows how to perform code to correct or report a specific
error if one occurs. The following example uses a conditional ``if`` control
structure to check the current error message and see if it is equal to
`error_databaseTimeout`::

   if(error_currentError == error_databaseTimeout)
      `Connection to database lost!`
   /if

Full documentation about error methods and error codes can be found in the
:ref:`Error Handling <error-handling>` chapter.


Adding Records
==============

Records can be added to any Lasso compatible database using the ``-add``
parameter. The ``-add`` parameter requires that a number of
additional parameters be defined in order to perform the ``-add``
action. The required parameters are detailed in the following table.

.. table:: Table: -Add Action Requirements

   +---------------+-----------------------------------------------------------+
   |Parameter      |Description                                                |
   +===============+===========================================================+
   |``-add``       |The action which is to be performed. Required.             |
   +---------------+-----------------------------------------------------------+
   |``-database``  |The database in which the record should be added. Required.|
   +---------------+-----------------------------------------------------------+
   |``-table``     |The table from the specified database in which the record  |
   |               |should be added. Required.                                 |
   +---------------+-----------------------------------------------------------+
   |``-keyField``  |The name of the field which holds the primary key for the  |
   |               |specified table. Recommended.                              |
   +---------------+-----------------------------------------------------------+
   |``pair         |A variable number of name/value pair parameters that       |
   |parameters``   |specify the field name and initial field values for the    |
   |               |added record. Optional.                                    |
   +---------------+-----------------------------------------------------------+
   |``-host``      |Optional inline host array. See the :ref:`Inline Hosts     |
   |               |<inline-hosts>` section in the :ref:`Database Interaction  |
   |               |Fundamentals <database-interaction>` chapter for more      |
   |               |information.                                               |
   +---------------+-----------------------------------------------------------+

Any name/value pair parameters included in the ``-add`` action will be used to
set the starting values for the record that is added to the database. All pair
parameters must reference a writable field within the database. Any fields which
are not referenced will be set to their default values according to the
database's configuration.

Lasso returns a reference to the record which was added to the database. The
reference is different depending on what type of database to which the record
was added.

SQL Data Sources
   The ``-keyField`` parameter should be set to the primary key field or
   auto-increment field of the table. Lasso will return the added record as the
   result of the action by checking the specified key field for the last
   inserted record. The `keyField_value` method can be used to inspect the value
   of the auto-increment field for the inserted record.

   If no ``-keyField`` is specified, the specified ``-keyField`` is not an
   auto-increment field, or ``-maxRecords`` is set to "0" then no record will be
   returned as a result of the ``-add`` action. This can be useful in situations
   where a large record is being added to the database and there is no need to
   inspect the values which were added.

FileMaker Server
   The `keyField_value` method is set to the value of the internal "Record ID"
   for the new record. The "Record ID" functions as an auto-increment field that
   is automatically maintained by FileMaker Server for all records.

   FileMaker Server automatically performs a search for the record which was
   added to the database. The found set resulting from an ``-add`` action is
   equivalent to a search for the single record using the `keyField_value`
   method.

   The value for ``-keyField`` is ignored when adding records to a FileMaker
   Server database. The value for `keyField_value` is always the internal
   "Record ID" value.

.. note::
   Consult the documentation for third-party data sources to see what behavior
   they implement when adding records to the database.


Add a Record Using the Inline Method
------------------------------------

The following example shows how to perform an ``-add`` action by specifying the
required parameters within an `inline` method. The ``-database`` is set to
"contacts", ``-table`` is set to "people", and ``-keyField`` is set to "id".
Feedback that the ``-add`` action was successful is provided to the visitor
inside the `inline` method using the `error_currentError` method. The added
record will only include default values as defined within the database itself::

   [inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id'
   )]
      <p>[error_code]: [error_msg]</p>
   [/inline]

If the ``-add`` action is successful then the following will be returned::

   // => <p>0: No Error</p>


Add a Record with Data Using the Inline Method
----------------------------------------------

The following example shows how to perform an ``-add`` action by specifying the
required parameters within an `inline` method. In addition, the `inline`
method includes a series of name/value pair parameters that define the values
for various fields within the record that is to be added. The "first_name" field
is set to "John" and the "last_name" field is set to "Doe". The added record
will include these values as well as any default values defined in the database
itself::

   inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe'
   )]
      <p>[error_code]: [error_msg]</p>
      Record [field('id')] was added for [field('first_name')] [field('last_name')].
   [/inline]

The results of the ``-add`` action contain the values for the record that was
just added to the database::

   // =>
   // <p>0: No Error</p>
   // Record 2 was added for John Doe.


Add a Record Using an HTML Form
-------------------------------

The following example shows how to perform an ``-add`` action using an HTML form
to send values into an `inline` method through `web_request->param`. The text
inputs provide a way for the site visitor to define the initial values for
various fields in the record that will be added to the database. The site
visitor can set values for the fields "first_name" and "last_name"::

   <form action="response.lasso" method="POST">
      <br />First Name: <input type="text" name="first_name" value="" />
      <br />Last Name:  <input type="text" name="last_name" value="" />
      <br /><input type="submit" name="submit" value="Add Record" />
   </form>

The response page for the form, "response.lasso", contains the following code
that performs the action using an `inline` method and provides feedback that the
record was successfully added to the database. The field values for the record
that was just added to the database are automatically available within the
`inline` method::

   [inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      "first_name"=web_request->param("first_name"),
      "last_name"=web_request->param("last_name")
   )]
      <p>[error_code]: [error_msg]</p>
      Record [field('id')] was added for [field('first_name')] [field('last_name')].
   [/inline]

If the form is submitted with "Mary" in the "first_name" input and "Person" in
the "last_name" input then the following will be returned::

   // =>
   // <p>0: No Error</p>
   // Record 3 was added for Mary Person


Add a Record Using a URL
------------------------

The following example shows how to perform an ``-add`` action using a URL to
send values into an `inline` method through `web_request->param`. The name/value
pair parameters in the URL define the starting values for various fields in the
database: "first_name" is set to "John" and "last_name" is set to "Person"::

   <a href="response.lasso?first_name=John&last_name=Person">
      Add John Person
   </a>

The response page for the URL, "response.lasso", contains the following code
that performs the action using `inline` method and provides feedback that the
record was successfully added to the database. The field values for the record
that was just added to the database are automatically available within the
`inline` method::

   [inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      "first_name"=web_request->param("first_name"),
      "last_name"=web_request->param("last_name")
   )]
      <p>[error_code]: [error_msg]</p>
      Record [field('id')] was added for [field('first_name')] [field('last_name')].
   [/inline]

If the link for "Add John Person" is selected then the following will be
returned::

   // =>
   // <p>0: No Error</p>
   // Record 4 was added for John Person.


Updating Records
================

Records can be updated within any Lasso compatible database using the
``-update`` parameter. The ``-update`` parameter requires that a number of
additional parameters to be defined in order to perform the ``-update`` action.
The required parameters are detailed in the following table.

.. tabularcolumns:: |l|L|

.. table:: Table: -Update Action Requirements

   +---------------+-----------------------------------------------------------+
   |Parameter      |Description                                                |
   +===============+===========================================================+
   |``-update``    |The action which is to be performed. Required.             |
   +---------------+-----------------------------------------------------------+
   |``-database``  |The database where the record should be updated. Required. |
   +---------------+-----------------------------------------------------------+
   |``-table``     |The table from the specified database in which the record  |
   |               |should be updated. Required.                               |
   +---------------+-----------------------------------------------------------+
   |``-keyField``  |The name of the field which holds the primary key for the  |
   |               |specified table. Either a ``-keyField`` and ``-keyValue``  |
   |               |or a ``-key`` is required.                                 |
   +---------------+-----------------------------------------------------------+
   |``-keyValue``  |The value of the primary key of the record being updated.  |
   +---------------+-----------------------------------------------------------+
   |``-key``       |An array that specifies the search parameters to find the  |
   |               |records to be updated. Either a ``-keyField`` and          |
   |               |``-keyValue`` or a ``-key`` is required.                   |
   +---------------+-----------------------------------------------------------+
   |``pair         |A variable number of name/value pair parameters specifying |
   |parameters``   |the field values which need to be updated. Optional.       |
   +---------------+-----------------------------------------------------------+
   |``-host``      |Optional inline host array. See the :ref:`Inline Hosts     |
   |               |<inline-hosts>` section in the :ref:`Database Interaction  |
   |               |Fundamentals <database-interaction>` chapter for more      |
   |               |information.                                               |
   +---------------+-----------------------------------------------------------+


Lasso has two methods to find which records are to be updated.

``-keyField`` and ``-keyValue``
   Lasso can identify the record to be updated using the values for the
   parameters ``-keyField`` and ``-keyValue``. The ``-keyField`` must be set to
   the name of a field in the table. Usually, this is the primary key field for
   the table. The ``-keyValue`` must be set to a valid value for the
   ``-keyField`` in the table. If no record can be found with the specified
   ``-keyValue`` then an error will be returned.

   The following inline would update the record with an "id" of "1" so it has a
   last name of "Doe"::

      inline(
         -update,
         -database='contacts',
         -table='people',
         -keyField='id',
         -keyValue=1,
         'last_name'='Doe'
      ) => {}

   Note that if the specified key value returns multiple records then all of
   those records will be updated within the target table. If the ``-keyField``
   is set to the primary key field of the table (or any field in the table which
   has a unique value for every record in the table) then the inline will only
   update one record.

``-key``
   Lasso can identify the records that are to be updated using a search that is
   specified in an array. The search can use any of the fields in the current
   database table and any of the operators and logical operators which are
   described in the :ref:`Searching and Displaying Data <searching-displaying>`
   chapter.

   The following inline would update all records in the people database that
   have a first name of "John". to have a last name of "Doe"::

      Inline(
         -update,
         -database='contacts',
         -table='people',
         -key=(: -eq, 'first_name'='John'),
         'last_name'='Doe'
      ) => {}

   Care should be taken when creating the search in a ``-key`` array. An update
   can very quickly modify all of the records in a database and there is no
   undo. Update inlines should be tested carefully before they are deployed on
   live data.

   Any pair parameters included in the update action will be used to set the
   field values for the record being updated. All pair parameters must reference
   a writable field within the database. Any fields which are not referenced
   will maintain the values they had before the update.


Lasso returns a reference to the record that was updated within the database.
The reference is different depending on what type of database is being used.

SQL Data Sources
   The `keyField_value` method is set to the value of the key field that was
   used to identify the record to be updated. The ``-keyField`` should always be
   set to the primary key or auto-increment field of the table. The results when
   using other fields are undefined.

   If the ``-keyField`` is not set to the primary key field or auto-increment
   field of the table or if ``-maxRecords`` is set to "0" then no record will be
   returned as a result of the ``-update`` action. This is useful if a large
   record is being updated and the results of the update do not need to be
   inspected.

FileMaker Server
   The `keyField_value` method is set to the value of the internal "Record ID"
   for the updated record. The "Record ID" functions as an auto-increment field
   that is automatically maintained by FileMaker Server for all records.

Lasso automatically performs a search for the record that was updated within the
database. The found set resulting from an ``-update`` action is equivalent to a
search for the single record using the `keyField_value`.

.. note::
   Consult the documentation for third-party data sources to see what behavior
   they implement when updating records within a database.


Update a Record with Data Using the Inline Method
-------------------------------------------------

The following example shows how to perform an ``-update`` action by specifying
the required parameters within an `inline` method. The record with the value
"2" in field "id" is updated. The `inline` method includes a series of pair
parameters that defines the new values for various fields within the record that
is to be updated. The "first_name" field is set to "Bob" and the "last_name"
field is set to "Surname". The updated record will include these new values, but
any fields which were not included in the action will be left with the values
they had before the update::

   [inline(
      -update,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=2,
      'first_name'='Bob',
      'last_name'='Surname'
   )]
      <p>[error_code]: [error_msg]</p>
      Record [field('id')] was updated to [field('first_name')] [field('last_name')].
   [/inline]

The updated field values from the ``-update`` action are automatically available
within the `inline`::

   // =>
   // <p>0: No Error</p>
   // Record 2 was updated to Bob Surname.


Update a Record Using an HTML Form
----------------------------------

The following example shows how to perform an ``-update`` action using an HTML
form to send values into an `inline` method. The text inputs provide a way for
the site visitor to define the new values for various fields in the record which
will be updated in the database. The site visitor can see and update the current
values for the fields "first_name" and "last_name"::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=3
   )]
   <form action="response.lasso" method="POST">
      <input type="hidden" name="keyValue" value="[keyField_value]" />
      <br />First Name: <input type="text" name="first_name" value="[field('first_name')]" />
      <br />Last Name: <input type="text" name="last_name" value="[field('last_name')]" />
      <br /><input type="submit" name="submit" value="Update Record" />
   </form>
   [/inline]

The response page for the form, "response.lasso", contains the following code
that performs the action using an `inline` method and provides feedback that the
record was successfully updated in the database. The field values from the
updated record are available automatically within the `inline` method::

   [inline(
      -update,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=web_request->param('keyValue'),
      'first_name'=web_request->param('first_name'),
      'last_name'=web_request->param('last_name')
   )]
      <p>[error_code]: [error_msg]</p>
      Record [field('id')] was updated to [field('first_name')] [field('last_name')].
   [/inline]

The form initially shows "Mary" for the "first_name" input and "Person" for the
"last_name" input. If the form is submitted with the "last_name" changed to
"Peoples" then the following will be returned. (The "First_Name" field is
unchanged since it was left set to "Mary".)::

   // =>
   // <p>0: No Error</p>
   // Record 3 was updated to Mary Peoples.


Update a Record Using a URL
---------------------------

The following example shows how to perform an ``-update`` action using a URL to
send field values to an `inline` method. The pair parameters in the URL define
the new values for various fields in the database: "first_name" is set to "John"
and "last_name" is set to "Person"::

   <a href="response.lasso?keyValue=4&first_name=John&last_name=Person">
      Update John Person
   </a>

The response page for the URL, "response.lasso", contains the following code
that performs the action using an `inline` method and provides feedback that
the record was successfully updated within the database::

   [inline(
      -update,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=web_request->param('keyValue'),
      'first_name'=web_request->param('first_name'),
      'last_name'=web_request->param('last_name')
   )]
      <p>[error_code]: [error_msg]</p>
      Record [field('id')] was updated to [field('first_name')] [field('last_name')].
   [/inline]

If the link for "Update John Person" is submitted then the following will be
returned::

   // =>
   // <p>0: No Error</p>
   // Record 4 was updated to John Person.


Update Several Records at Once
------------------------------

The following example shows how to perform an ``-update`` action on several
records at once within a single database table. The goal is to update every
record in the database with the last name of "Person" to the new last name of
"Peoples".

There are two methods to accomplish this. The first method is to use the
``-key`` parameter to find the records that need to be updated within a single
``-update`` inline. The second method is to use an outer inline to find the
records to be updated and then an inner inline which is repeated once for each
record.

The ``-key`` method has the advantage of speed and is the best choice for simple
updates. The nested inline method can be useful if additional processing is
required on each record before it is updated within the data source.


Using -Key to Update Records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inline uses a ``-key`` array which performs a search for all records in the
database with a "last_name" equal to "Person". The update is performed
automatically on this found set::

   inline(
      -update,
      -database='contacts',
      -table='people',
      -key=(: -eq, 'last_name'='Person'),
      -maxRecords='all',
      'last_name'='Peoples'
   ) => {}


Using Nested Inlines to Update Records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The outer `inline` method performs a search for all records in the database with
"last_name" equal to "Person". This forms the found set of records that need to
be updated. The `records` method repeats once for each record in the found set.
The ``-maxRecords='all'`` parameter ensures that all records which match the
criteria are returned.

The inner `inline` method performs an update on each record in the found set.
Methods are used to retrieve the values for the required ``-database``,
``-table``, ``-keyField``, and ``-keyValue`` parameters. This ensures that these
values match those from the outer `inline` method exactly. The pair parameter
``'last_name'='Peoples'`` updates the field to the new value::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords='all',
      'last_name'='Person'
   )]
      [records]
         [inline(
            -update,
            -database=database_name,
            -table=table_name,
            -keyField=keyField_name,
            -KeyValue=keyField_value,
            'last_name'='Peoples'
         )]
            <p>[error_code]: [error_msg]</p>
            Record [field('id')] was updated to [field('first_name')] [field('last_name')].
         [/inline]
      [/records]
   [/inline]

This particular search only finds one record to update. If the update action is
successful then the following will be returned for each updated record::

   // =>
   // <p>0: No Error</p>
   // Record 4 was updated to John Peoples.


Deleting Records
================

Records can be deleted from any Lasso compatible database using the ``-delete``
parameter. The ``-delete`` parameter requires that a number of additional
parameters be defined in order to perform the ``-delete`` action. The required
parameters are detailed in the following table.

.. tabularcolumns:: |l|L|

.. table:: Table: -Delete Action Requirements

   +----------------+----------------------------------------------------------+
   |Parameter       |Description                                               |
   +================+==========================================================+
   |``-delete``     |The action which is to be performed. Required.            |
   +----------------+----------------------------------------------------------+
   |``-database``   |The database where the record should be deleted. Required.|
   +----------------+----------------------------------------------------------+
   |``-table``      |The table from the specified database in which the record |
   |                |should be deleted. Required.                              |
   +----------------+----------------------------------------------------------+
   |``-keyField``   |The name of the field which holds the primary key for the |
   |                |specified table. Either a ``-keyField`` and ``-keyValue`` |
   |                |or a ``-key`` is Required.                                |
   +----------------+----------------------------------------------------------+
   |``-keyValue``   |The value of the primary key of the record that is to be  |
   |                |deleted. Required.                                        |
   +----------------+----------------------------------------------------------+
   |``-key``        |An array that specifies the search parameters to find the |
   |                |records to be deleted. Either a ``-keyField`` and         |
   |                |``-keyValue`` or a ``-key`` is required.                  |
   +----------------+----------------------------------------------------------+
   |``-host``       |Optional inline host array. See the :ref:`Inline Hosts    |
   |                |<inline-hosts>` section in the :ref:`Database Interaction |
   |                |Fundamentals <database-interaction>` chapter for more     |
   |                |information.                                              |
   +----------------+----------------------------------------------------------+

Lasso has two methods to find which records are to be deleted.

``-keyField`` and ``-keyValue``
   Lasso can identify the record to be deleted using the values for the
   ``-keyField`` and ``-keyValue`` parameters. The ``-keyField`` must be set to
   the name of a field in the table. Usually, this is the primary key field for
   the table. The ``-keyValue`` must be set to a valid value for the
   ``-keyField`` in the table. If no record can be found with the specified
   ``-keyValue`` then nothing will be deleted and no error will be returned.

   The following inline would delete the record with an "id" of "1"::

      inline(
         -delete,
         -database='contacts',
         -table='people',
         -keyField='id',
         -keyValue=1
      ) =>{}

   Note that if the specified key value returns multiple records then all of
   those records will be deleted from the target table. If the ``-keyField`` is
   set to the primary key field of the table (or any field in the table which
   has a unique value for every record in the table) then the inline will only
   delete one record.

``-key``
   Lasso can identify the records that are to be deleted using a search which is
   specified in an array. The search can use any of the fields in the current
   database table and any of the operators and logical operators which are
   described in the :ref:`Searching and Displaying Data <searching-displaying>`
   chapter.

   The following inline would delete all records in the people database which
   have a first name of "John"::

      inline(
         -delete,
         -database='contacts',
         -table='people',
         -key=(: -eq, 'first_name'='John')
      ) => {}

   Care should be taken when creating the search in a ``-key`` array. A delete
   can very quickly remove up to all of the records in a database and there is
   no undo. Delete inlines should be tested carefully before they are deployed
   on live data.

Lasso returns an empty found set in response to a ``-delete`` action. Since the
record has been deleted from the database the `field` method can no longer be
used to retrieve any values from it. The `error_currentError` method should be
checked to ensure that it has a value of "No Error" in order to confirm that the
record has been successfully deleted.

There is no confirmation or undo of a delete action. When a record is removed
from a database it is removed permanently. It is important to set up security
appropriately so accidental or unauthorized deletes don't occur.


Delete a Record with Data Using an Inline Method
------------------------------------------------

The following example shows how to perform a delete action by specifying the
required parameters within an `inline` method. The record with the value "2" in
field "id" is deleted::

   [inline(
      -delete,
      -database='contacts',
      -table='people',
      -keyField='id',
      -keyValue=2
   )]
      <p>[error_code]: [error_msg]</p>
   [/inline]

If the delete action is successful then the following will be returned::

   // => <p>0: No Error</p>


Delete Several Records at Once
------------------------------

The following example shows how to perform a ``-delete`` action on several
records at once within a single database table. The goal is to delete every
record in the database with the last name of "Peoples".

.. warning::
   These techniques can be used to remove all records from a database table. It
   should be used with extreme caution and tested thoroughly before being added
   to a production website.

There are two methods to accomplish this. The first method is to use the
``-key`` parameter to find the records that need to be deleted within a single
``-delete`` inline. The second method is to use an outer `inline` to find the
records to be deleted and then an inner `inline` which is repeated once for each
record.

The ``-key`` method has the advantage of speed and is the best choice for simple
deletes. The nested inline method can be useful if additional processing is
required to decide if each record should be deleted.


Using -Key to Update Records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This `inline` uses a ``-key`` array which performs a search for all records in
the database with a "last_name" equal to "Peoples". The records in this found
set are automatically deleted::

   inline(
      -delete,
      -database='contacts',
      -table='people',
      -key=(: -eq, 'last_name'='Peoples')
   ) => {}


Using Nested Inlines to Update Records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The outer `inline` method performs a search for all records in the database with
"last_name" equal to "Peoples". This forms the found set of records that need to
be updated. The `records` method executes once for each record in the found set.
The ``-maxRecords='all'`` parameter ensures that all records which match the
criteria are returned.

The inner `inline` method deletes each record in the found set. Methods are used
to retrieve the values for the required parameters ``-database``, ``-table``,
``-keyField``, and ``-keyValue``. This ensures that these values match those
from the outer `inline` method exactly::

   [inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      -maxRecords='all',
      'last_name'='Peoples'
   )]
      [Records]
         [inline(
            -delete,
            -database=database_name,
            -table=table_name,
            -keyField=keyField_name,
            -keyValue=keyField_value
         )]
            <p>[error_code]: [error_msg]</p>
         [/inline]
      [/records]
   [/inline]

This particular search only finds one record to delete. If the delete action is
successful then the following will be returned for each deleted record::

   // => <p>0: No Error</p>
