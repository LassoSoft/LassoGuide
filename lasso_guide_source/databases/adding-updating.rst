.. _adding-updating:

.. direct from book

***************************
Adding and Updating Records
***************************

This chapter documents the Lasso command tags which add, update, delete,
and duplicate records within Lasso compatible databases.

- **Overview** provides an introduction to the database actions
  described in this chapter and presents important security
  considerations.
- **Adding Records** includes requirements and instructions for
  adding records to a database.
- **Updating Records** includes requirements and instructions for updating
  records within a database.
- **Deleting Records** includes requirements and instructions for deleting
  records within a database.
- **Duplicating Records** includes requirements and instructions for
  duplicating records within a database.

Overview
--------

Lasso provides command tags for adding, updating, deleting, and
duplicating records within Lasso compatible databases. These command
tags are used in conjunction with additional command tags and name/value
parameters in order to perform the desired database action in a specific
database and table or within a specific record. The command tags
documented in this chapter are listed in :ref:`Table 1: Command Tags
<adding-and-updating-records-table-1>`. The sections that follow
describe the additional command tags and name/value parameters required
for each database action.

.. _adding-and-updating-records-table-1:

.. table:: Table 1: Command Tags

  +--------------+-------------------------------+
  |Tag           |Description                    |
  +==============+===============================+
  |``-Add``      |Adds a record to a database.   |
  +--------------+-------------------------------+
  |``-Update``   |Updates a record or records    |
  |              |within a database.             |
  +--------------+-------------------------------+
  |``-Delete``   |Removes a record or records    |
  |              |from a database.               |
  +--------------+-------------------------------+
  |``-Duplicate``|Duplicates a record within a   |
  |              |database. Works with FileMaker |
  |              |Pro databases.                 |
  +--------------+-------------------------------+

Character Encoding
^^^^^^^^^^^^^^^^^^

Lasso stores and retrieves data from data sources based on the
preferences established in the ***Setup > Data Sources*** section of
Lasso Administration. The following rules apply for each standard data
source.

**Inline Host** – The character encoding can be specified explicitly
using a ``-TableEncoding`` parameter within the ``-Host`` array.

**MySQL** – By default all communication is in the Latin-1 (ISO 8859-1)
character set. This is to preserve backwards compatibility with prior
versions of Lasso. The character set can be changed to the Unicode
standard UTF-8 character set in the ***Setup > Data Sources > Tables***
section of Lasso Administration.

**FileMaker Pro** – By default all communication is in the MacRoman
character set when Lasso Professional is hosted on Mac OS X or in the
Latin-1 (ISO 8859-1) character set when Lasso Professional is hosted on
Windows. The preference in the ***Setup > Data Sources > Databases***
section of Lasso Administration can be used to change the character set
for cross-platform communications.

**JDBC** – All communication with JDBC data sources is in the Unicode
standard UTF-8 character set. See the Lasso Professional 8 Setup Guide
for more information about how to change the character set settings in
Lasso Administration.

Error Reporting
^^^^^^^^^^^^^^^

After a database action has been performed, Lasso reports any errors
which occurred via the ``[Error_CurrentError]`` tag. The value of this
tag should be checked to ensure that the database action was
successfully performed.

**To display the current error code and message:**

The following code can be used to display the current error message.
This code should be placed in a format file which is a response to a
database action or within a pair of ``[Inline] … [/Inline]`` tags.

::

   [Error_CurrentError: -ErrorCode]: [Error_CurrentError]

If the database action was performed successfully then the following
result will be returned.

::

   0: No Error

Classic Lasso
^^^^^^^^^^^^^

If Classic Lasso support has been disabled within Lasso Administration
then database actions will not be performed automatically if they are
specified within HTML forms or URLs. Although the database action will
not be performed, the ``-Response`` tag will function normally. Use the
following code in the response page to the HTML forms or URL to trigger
the database action.

::

    [Inline: (Action_Params)]
    [Error_CurrentError: -ErrorCode]: [Error_CurrentError]
    [/Inline]

See the ***Database Interaction Fundamentals*** chapter and the
***Setting Site Preferences*** chapter of the Lasso Professional 8 Setup
Guide for more information.

Security
^^^^^^^^

Lasso has a robust internal security system that can be used to restrict
access to database actions or to allow only specific users to perform
database actions. If a database action is attempted when the current
visitor has insufficient permissions then they will be prompted for a
username and password. An error will be returned if the visitor does not
enter a valid username and password.

.. Note:: If an inline host is specified with a ``-Host`` array then Lasso security is bypassed.

An ``[Inline] … [/Inline]`` can be specified to execute with the
permissions of a specific user by specifying ``-Username`` and
``-Password`` command tags within the ``[Inline]`` tag. This allows the
database action to be performed even though the current site visitor
does not necessarily have permissions to perform the database action. In
essence, a valid username and password are embedded into the format file.

.. table:: Table 2: Security Command Tags

  +-------------+-------------------------------------------------+
  |Tag          |Description                                      |
  +=============+=================================================+
  |``-Username``|Specifies the username from Lasso Security which |
  |             |should be used to execute the database action.   |
  +-------------+-------------------------------------------------+
  |``-Password``|Specifies the password which corresponds to the  |
  |             |username.                                        |
  +-------------+-------------------------------------------------+

**To specify a username and password in an [Inline]:**

The following example shows a ``-Delete`` action performed within an
``[Inline]`` tag using the permissions granted for username
``SiteAdmin`` with password ``Secret``.

::

    [Inline: -Delete,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=137,
        -Username='SiteAdmin',
        -Password='Secret']
        
        [Error_CurrentError: -ErrorCode]: [Error_CurrentError]
    
    [/Inline]

A specified username and password is only valid for the ``[Inline] …
[/Inline]`` tags in which it is specified. It is not valid within any
nested ``[Inline] … [/Inline]`` tags. See the ***Setting Up Security***
chapter of the Lasso Professional 8 Setup Guide for additional important
information regarding embedding usernames and passwords into
``[Inline]`` tags.

Adding Records
--------------

Records can be added to any Lasso compatible database using the ``-Add``
command tag. The ``-Add`` command tag requires that a number of
additional command tags be defined in order to perform the ``-Add``
action. The required command tags are detailed in the following table.

.. table:: Table 3: -Add Action Requirements

  +----------------+-------------------------------------------------+
  |Tag             |Description                                      |
  +================+=================================================+
  |``-Add``        |The action which is to be performed. Required.   |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-Database``   |The database in which the record should be       |
  |                |added. Required.                                 |
  +----------------+-------------------------------------------------+
  |``-Table``      |The table from the specified database in which   |
  |                |the record should be added. Required.            |
  +----------------+-------------------------------------------------+
  |``-KeyField``   |The name of the field which holds the primary key|
  |                |for the specified table. Recommended.            |
  +----------------+-------------------------------------------------+
  |``Name/Value    |A variable number of name/value parameters       |
  |Parameters``    |specify the initial field values for the added   |
  |                |record. Optional.                                |
  +----------------+-------------------------------------------------+
  |``-Host``       |Optional inline host array.                      |
  |                |                                                 |
  |                |.. seealso:: the section on ***Inline Hosts***   |
  |                |   in the ***Database Interaction                |
  |                |   Fundamentals*** chapter for more information. |
  +----------------+-------------------------------------------------+

Any name/value parameters included in the ``-Add`` action will be used
to set the starting values for the record which is added to the
database. All name/value parameters must reference a writable field
within the database. Any fields which are not referenced will be set to
their default values according to the database's configuration.

Lasso returns a reference to the record which was added to the database.
The reference is different depending on what type of database to which
the record was added.

- **SQL Data Sources** – The ``-KeyField`` tag should be set to the
  primary key field or auto-increment field of the table. Lasso
  will return the added record as the result of the action by
  checking the specified key field for the last inserted record.
  The ``[KeyField_Value]`` tag can be used to inspect the value of
  the auto-increment field for the inserted record.

  If no ``-KeyField`` is specified, the specified ``-KeyField`` is not
  an auto-increment field, or ``-MaxRecords`` is set to 0 then no record
  will be returned as a result of the ``-Add action``. This can be
  useful in situations where a large record is being added to the
  database and there is no need to inspect the values which were added.

- **FileMaker Pro** – The ``[KeyField_Value]`` tag is set to the
  value of the internal Record ID for the new record. The Record ID
  functions as an auto-increment field that is automatically
  maintained by FileMaker Pro for all records.

  FileMaker Pro automatically performs a search for the record which was
  added to the database. The found set resulting from an ``-Add`` action
  is equivalent to a search for the single record using the
  ``[KeyField_Value]``.

  The value for ``-KeyField`` is ignored when adding records to a
  FileMaker Pro database. The value for ``[KeyField_Value]`` is always
  the internal Record ID value.

.. Note:: Consult the documentation for third-party data sources to see what behavior they implement when adding records to the database.

**To add a record using [Inline] … [/Inline] tags:**

The following example shows how to perform an ``-Add`` action by
specifying the required command tags within an opening ``[Inline]`` tag.
``-Database`` is set to ``Contacts``, ``-Table`` is set to ``People``,
and ``-KeyField`` is set to ``ID``. Feedback that the ``-Add`` action
was successful is provided to the visitor inside the ``[Inline] …
[/Inline]`` tags using the ``[Error_CurrentError]`` tag. The added
record will only include default values as defined within the database
itself.

::

    [Inline: -Add,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
    
    [/Inline]

If the ``-Add`` action is successful then the following will be
returned.

``-> 0: No Error``

**To add a record with data using [Inline] … [/Inline] tags:**

The following example shows how to perform an ``-Add`` action by
specifying the required command tags within an opening ``[Inline]`` tag.
In addition, the ``[Inline]`` tag includes a series of name/value
parameters that define the values for various fields within the record
that is to be added. The ``First_Name`` field is set to ``John`` and the
``Last_Name`` field is set to ``Doe``. The added record will include
these values as well as any default values defined in the database
itself.

::

    [Inline: -Add,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='John',
        'Last_Name'='Doe']
        
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        <br>Record [Field: 'ID'] was added for [Field: 'First_Name'] [Field: 'Last_Name'].
    
    [/Inline]

The results of the ``-Add`` action contain the values for the record
that was just added to the database.

::

  -> 0: No Error
     Record 2 was added for John Doe.

**To add a record using an HTML form:**

The following example shows how to perform an ``-Add`` action using an
HTML form to send values into an ``[Inline]`` tag through
``[Action_Params]``. The text inputs provide a way for the site visitor
to define the initial values for various fields in the record which will
be added to the database. The site visitor can set values for the fields
``First_Name`` and ``Last_Name``.

::

    <form action="response.lasso" method="POST">
    <br>First Name: <input type="text" name="First_Name" value="">
    <br>Last Name: <input type="text" name="Last_Name" value="">
    <br><input type="submit" name="-Nothing" value="Add Record">
    </form>

The response page for the form, ``response.lasso``, contains the
following code that performs the action using an ``[Inline]`` tag and
provides feedback that the record was successfully added to the
database. The field values for the record that was just added to the
database are automatically available within the ``[Inline] … [/Inline]``
tags.

::

    [Inline: (Action_Params),
        -Add,
        -Database='Contacts',
        -Table='People',
        -Keyfield='ID']
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        <br>Record [Field: 'ID'] was added for [Field: 'First_Name'] [Field: 'Last_Name'].
    [/Inline]

If the form is submitted with ``Mary`` in the ``First Name`` input and
``Person`` in the ``Last Name`` input then the following will be
returned.

::

  -> 0: No Error
     Record 3 was added for Mary Person

**To add a record using a URL:**

The following example shows how to perform an ``-Add`` action using a
URL to send values into an ``[Inline]`` tag through ``[Action_Params]``.
The name/value parameters in the URL define the starting values for
various fields in the database: ``First_Name`` is set to John and
``Last_Name`` is set to ``Person``.

::

    <a href="response.lasso?First_Name=John&Last_Name=Person">
        Add John Person
    </a>

The response page for the URL, ``response.lasso``, contains the
following code that performs the action using `` [Inline]`` tag and
provides feedback that the record was successfully added to the
database. The field values for the record that was just added to the
database are automatically available within the
`` [Inline] … [/Inline]`` tags.

::

    [Inline: (Action_Params),
        -Add,
        -Database='Contacts',
        -Table='People',
        -Keyfield='ID']
        [Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        Record [Field: 'ID'] was added for [Field: 'First_Name'] [Field: 'Last_Name'].
    [/Inline]

If the link for Add John Person is selected then the following will be
returned.

::

    -> 0: No Error
       Record 4 was added for John Person.

Updating Records
----------------

Records can be updated within any Lasso compatible database using the
``-Update`` command tag. The ``-Update`` command tag requires that a
number of additional command tags be defined in order to perform the
``-Update`` action. The required command tags are detailed in the
following table.

.. table:: Table 4: -Update Action Requirements

  +----------------+-------------------------------------------------+
  |Tag             |Description                                      |
  +================+=================================================+
  |``-Update``     |The action which is to be performed. Required.   |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-Database``   |The database in which the record should be       |
  |                |updated. Required.                               |
  +----------------+-------------------------------------------------+
  |``-Table``      |The table from the specified database in which   |
  |                |the record should be updated. Required.          |
  +----------------+-------------------------------------------------+
  |``-KeyField``   |The name of the field which holds the primary key|
  |                |for the specified table. Either a -KeyField and  |
  |                |-KeyValue or a -Key is required.                 |
  +----------------+-------------------------------------------------+
  |``-KeyValue``   |The value of the primary key of the record which |
  |                |is to be updated.                                |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-Key``        |An array that specifies the search parameters to |
  |                |find the records to be updated. Either a         |
  |                |-KeyField and -KeyValue or a -Key is required.   |
  +----------------+-------------------------------------------------+
  |``Name/Value    |A variable number of name/value parameters       |
  |Parameters``    |specifying the field values which need to be     |
  |                |updated. Optional.                               |
  +----------------+-------------------------------------------------+
  |``-Host``       |Optional inline host array.                      |
  |                |                                                 |
  |                |.. seealso:: the section on ***Inline Hosts***   |
  |                |   in the ***Database Interaction                |
  |                |   Fundamentals*** chapter for more information. |
  +----------------+-------------------------------------------------+


Lasso has two methods to find which records are to be updated.

- **-KeyField and -KeyValue** – Lasso can identify the record which is
  to be updated using the values for the command tags ``-KeyField`` and
  ``-KeyValue``. ``-KeyField`` must be set to the name of a field in
  the table. Usually, this is the primary key field for the table.
  ``-KeyValue`` must be set to a valid value for the ``-KeyField`` in
  the table. If no record can be found with the specified ``-KeyValue``
  then an error will be returned.

  The following inline would update the record with an ``ID`` of ``1``
  so it has a last name of ``Doe``.

  ::
  
    Inline: -Update,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=1,
        'Last_Name'='Doe';
    /Inline;

  Note that if the specified key value returns multiple records then
  all of those records will be updated within the target table. If the
  ``-KeyField`` is set to the primary key field of the table (or any
  field in the table which has a unique value for every record in the
  table) then the inline will only update one record.

- **-Key** – Lasso can identify the records that are to be updated
  using a search which is specified in an array. The search can use any
  of the fields in the current database table and any of the operators
  and logical operators which are described in the previous chapter.

  The following inline would update all records in the people database
  which have a first name of ``John``. to have a last name of ``Doe``.

  ::
  
    Inline: -Update,
        -Database='Contacts',
        -Table='People',
        -Key=(Array: -Eq, 'First_Name'='John'),
        'Last_Name'='Doe';
    /Inline;

  Care should be taken when creating the search in a ``-Key`` array. An
  update can very quickly modify up to all of the records in a database
  and there is no undo. Update inlines should be debugged carefully
  before they are deployed on live data.

  Any name/value parameters included in the update action will be used
  to set the field values for the record which is updated. All
  name/value parameters must reference a writable field within the
  database. Any fields which are not referenced will maintain the
  values they had before the update.
  
  Lasso returns a reference to the record which was updated within the
  database. The reference is different depending on what type of
  database is being used.

- **SQL Data Sources** – The ``[KeyField_Value]`` tag is set to the
  value of the key field which was used to identify the record to be
  updated. The ``-KeyField`` should always be set to the primary key or
  auto-increment field of the table. The results when using other
  fields are undefined.
  
  If the ``-KeyField`` is not set to the primary key field or
  auto-increment field of the table or if ``-MaxRecords`` is set to 0
  then no record will be returned as a result of the ``-Update`` action.
  This is useful if a large record is being updated and the results of
  the update do not need to be inspected.

- **FileMaker Pro** – The ``[KeyField_Value]`` tag is set to the value
  of the internal Record ID for the updated record. The Record ID
  functions as an auto-increment field that is automatically maintained
  by FileMaker Pro for all records.

Lasso automatically performs a search for the record which was updated
within the database. The found set resulting from an ``-Update`` action
is equivalent to a search for the single record using the
``[KeyField_Value]``.

.. Note:: Consult the documentation for third-party data sources to see what behavior they implement when updating records within a database.

**To update a record with data using [Inline] … [/Inline] tags:**

The following example shows how to perform an ``-Update`` action by
specifying the required command tags within an opening ``[Inline]`` tag.
The record with the value 2 in field ID is updated. The ``[Inline]`` tag
includes a series of name/value parameters that define the new values
for various fields within the record that is to be updated. The
``First_Name`` field is set to ``Bob`` and the ``Last_Name`` field is
set to ``Surname``. The updated record will include these new values,
but any fields which were not included in the action will be left with
the values they had before the update.

::

    [Inline: -Update,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=2,
        'First_Name'='Bob',
        'Last_Name'='Surname']
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        <br>Record [Field: 'ID'] was added for [Field: 'First_Name'] [Field: 'Last_Name'].
    [/Inline]

The updated field values from the ``-Update`` action are automatically
available within the ``[Inline]``.

::

  -> 0: No Error
     Record 2 was updated to Bob Surname.

**To update a record using an HTML form:**

The following example shows how to perform an ``-Update`` action using
an HTML form to send values into an ``[Inline]`` tag. The text inputs
provide a way for the site visitor to define the new values for various
fields in the record which will be updated in the database. The site
visitor can see and update the current values for the fields
``First_Name`` and ``Last_Name``.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=3]

    <form action="response.lasso" method="POST">
        <input type="hidden" name="-KeyValue" value="[KeyField_Value]">
        <br>First Name: <input type="text" name="First_Name"
        value="[Field: 'First_Name']">
        <br>Last Name: <input type="text" name="Last_Name"
        value="[Field: 'Last_Name']">
        <br><input type="submit" name="-Update" value="Update Record">
    </form>
    [/Inline]

The response page for the form, ``response.lasso``, contains the
following code that performs the action using an ``[Inline]`` tag and
provides feedback that the record was successfully updated in the
database. The field values from the updated record are available
automatically within the ``[Inline] … [/Inline]`` tags.

::

    [Inline: (Action_Params),
        -Update,
        -Database='Contacts',
        -Table='People',
        -Keyfield='ID']
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        <br>Record [Field: 'ID'] was updated to [Field: 'First_Name'] [Field: 'Last_Name'].
    [/Inline]

The form initially shows ``Mary`` for the ``First Name`` input and
``Person`` for the ``Last Name`` input. If the form is submitted with
the ``Last Name`` changed to ``Peoples`` then the following will be
returned. The ``First Name`` field is unchanged since it was left set to
``Mary``.

::

  -> 0: No Error
     Record 3 was updated to Mary Peoples.

**To update a record using a URL:**

The following example shows how to perform an ``-Update`` action using a
URL to send field values to an ``[Inline]`` tag. The name/value
parameters in the URL define the new values for various fields in the
database: ``First_Name`` is set to ``John`` and ``Last_Name`` is set to
``Person``.

::

    <a href="response.lasso?-KeyValue=4&
    First_Name=John&Last_Name=Person"> Update John Person </a>

The response page for the URL, ``response.lasso``, contains the
following code that performs the action using ``[Inline] … [/Inline]``
tags and provides feedback that the record was successfully updated
within the database.

::

    [Inline: (Action_Params),
        -Update,
        -Database='Contacts',
        -Table='People',
        -Keyfield='ID']
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        <br>Record [Field: 'ID'] was updated to [Field: 'First_Name'] [Field: 'Last_Name'].
    [/Inline]

If the link for ``Update John Person`` is submitted then the following
will be returned.

::

    -> 0: No Error
       Record 4 was updated for John Person.

**To update several records at once:**

The following example shows how to perform an ``-Update`` action on
several records at once within a single database table. The goal is to
update every record in the database with the last name of ``Person`` to
the new last name of ``Peoples``.

There are two methods to accomplish this. The first method is to use the
``-Key`` parameter to find the records that need to be updated within a
single ``-Update`` inline. The second method is to use an outer inline
to find the records to be updated and then an inner inline which is
repeated once for each record.

The ``-Key`` method has the advantage of speed and is the best choice
for simple updates. The nested inline method can be useful if additional
processing is required on each record before it is updated within the
data source.

- The inline uses a ``-Key`` array which performs a search for all
  records in the database ``Last_Name`` equal to ``Person``. The
  update is performed automatically on this found set.

::

    [Inline: -Update,
        -Database='Contacts',
        -Table='People',
        -Key=(Array: -Eq, 'Last_Name'='Person'),
        -MaxRecords='All',
        'Last_Name'='Peoples']
    [/Inline]

- The outer ``[Inline] … [/Inline]`` tags perform a search for all
  records in the database with ``Last_Name`` equal to ``Person``.
  This forms the found set of records which need to be updated. The
  ``[Records] … [/Records]`` tags repeat once for each record in
  the found set. The ``-MaxRecords='All'`` command tag ensures that
  all records which match the criteria are returned.

  The inner ``[Inline] … [/Inline]`` tags perform an update on each
  record in the found set. Substitution tags are used to retrieve the
  values for the required command tags ``-Database``, ``-Table``,
  ``-KeyField``, and ``-KeyValue``. This ensures that these values match
  those from the outer ``[Inline] … [/Inline]`` tags exactly. The
  name/value pair ``'Last_Name'='Peoples'`` updates the field to the new
  value. ::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords='All',
        'Last_Name'='Person']
        [Records]
            [Inline: -Update,
                -Database=(Database_Name),
                -Table=(Table_Name),
                -KeyField=(KeyField_Name),
                -KeyValue=(KeyField_Value),
                'Last_Name'='Peoples']
                <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
                <br>Record [Field: 'ID'] was updated to
                [Field: 'First_Name'] [Field: 'Last_Name'].
            [/Inline]
        [/Records]
    [/Inline]
  
  This particular search only finds one record to update. If the update
  action is successful then the following will be returned for each
  updated record.

::

    -> 0: No Error
       Record 4 was updated to John Peoples.

Deleting Records
----------------

Records can be deleted from any Lasso compatible database using the
``-Delete`` command tag. The ``-Delete`` command tag can be specified
within an ``[Inline]`` tag, an HTML form, or a URL. The ``-Delete``
command tag requires that a number of additional command tags be defined
in order to perform the ``-Delete`` action. The required command tags
are detailed in the following table.

.. table:: Table 5: -Delete Action Requirements

  +----------------+-------------------------------------------------+
  |Tag             |Description                                      |
  +================+=================================================+
  |``-Delete``     |The action which is to be performed. Required.   |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-Database``   |The database in which the record should be       |
  |                |deleted. Required.                               |
  +----------------+-------------------------------------------------+
  |``-Table``      |The table from the specified database in which   |
  |                |the record should be deleted. Required.          |
  +----------------+-------------------------------------------------+
  |``-KeyField``   |The name of the field which holds the primary key|
  |                |for the specified table. Either a -KeyField and  |
  |                |-KeyValue or a -Key is Required.                 |
  +----------------+-------------------------------------------------+
  |``-KeyValue``   |The value of the primary key of the record which |
  |                |is to be deleted.  Required.                     |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-Key``        |An array that specifies the search parameters to |
  |                |find the records to be deleted. Either a         |
  |                |-KeyField and -KeyValue or a -Key is required.   |
  +----------------+-------------------------------------------------+
  |``-Host``       |Optional inline host array.                      |
  |                |                                                 |
  |                |.. seealso:: the section on ***Inline Hosts***   |
  |                |   in the ***Database Interaction                |
  |                |   Fundamentals*** chapter for more information. |
  +----------------+-------------------------------------------------+
  
Lasso has two methods to find which records are to be deleted.

- **-KeyField and -KeyValue** – Lasso can identify the record which is
  to be deleted using the values for the command tags ``-KeyField`` and
  ``-KeyValue``. ``-KeyField`` must be set to the name of a field in the
  table. Usually, this is the primary key field for the table.
  ``-KeyValue`` must be set to a valid value for the ``-KeyField`` in
  the table. If no record can be found with the specified ``-KeyValue``
  then an error will be returned.

  The following inline would delete the record with an ``ID`` of ``1``.

  ::

    Inline: -Delete,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=1;
    /Inline;

  Note that if the specified key value returns multiple records then all
  of those records will be deleted from the target table. If the
  ``-KeyField`` is set to the primary key field of the table (or any
  field in the table which has a unique value for every record in the
  table) then the inline will only delete one record.

- **-Key** – Lasso can identify the records that are to be deleted
  using a search which is specified in an array. The search can use
  any of the fields in the current database table and any of the
  operators and logical operators which are described in the
  previous chapter.

  The following inline would delete all records in the people database
  which have a first name of ``John``.

  ::

    Inline: -Delete,
        -Database='Contacts',
        -Table='People',
        -Key=(Array: -Eq, 'First_Name'='John');
    /Inline;

  Care should be taken when creating the search in a ``-Key`` array. A
  delete can very quickly remove up to all of the records in a database
  and there is no undo. Delete inlines should be debugged carefully
  before they are deployed on live data.

Lasso returns an empty found set in response to a ``-Delete`` action.
Since the record has been deleted from the database the ``[Field]`` tag
can no longer be used to retrieve any values from it. The
``[Error_CurrentError]`` tag should be checked to ensure that it has a
value of ``No Error`` in order to confirm that the record has been
successfully deleted.

There is no confirmation or undo of a delete action. When a record is
removed from a database it is removed permanently. It is important to
set up Lasso security appropriately so accidental or unauthorized
deletes don't occur. See the ***Setting Up Security*** chapter in the
Lasso Professional 8 Setup Guide for more information about setting up
database security.

**To delete a record with data using [Inline] … [/Inline] tags:**

The following example shows how to perform a delete action by specifying
the required command tags within an opening ``[Inline]`` tag. The record
with the value ``2`` in field ``ID`` is deleted.

::

    [Inline: -Delete,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=2]
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
    [/Inline]

If the delete action is successful then the following will be returned.

::

  -> 0: No Error

**To delete several records at once:**

The following example shows how to perform a ``-Delete`` action on
several records at once within a single database table. The goal is to
delete every record in the database with the last name of ``Peoples``.

.. Warning:: These techniques can be used to remove all records from a database table. It should be used with extreme caution and tested thoroughly before being added to a public Web site.

There are two methods to accomplish this. The first method is to use the
``-Key`` parameter to find the records that need to be deleted within a
single ``-Delete`` inline. The second method is to use an outer inline
to find the records to be deleted and then an inner inline which is
repeated once for each record.

The ``-Key`` method has the advantage of speed and is the best choice
for simple deletes. The nested inline method can be useful if additional
processing is required to decide if each record should be deleted.

- The inline uses a ``-Key`` array which performs a search for all
  records in the database ``Last_Name`` equal to ``Peoples``. The
  records in this found set are automatically deleted.

  ::

    [Inline: -Delete,
        -Database='Contacts',
        -Table='People',
        -Key=(Array: -Eq, 'Last_Name'='Peoples')]
    [/Inline]

- The outer ``[Inline] … [/Inline]`` tags perform a search for all
  records in the database with ``Last_Name`` equal to ``Peoples``.
  This forms the found set of records which need to be updated. The
  ``[Records] … [/Records]`` tags repeat once for each record in
  the found set. The ``-MaxRecords='All'`` command tag ensures that
  all records which match the criteria are returned.

  The inner ``[Inline] … [/Inline]`` tags delete each record in the
  found set. Substitution tags are used to retrieve the values for the
  required command tags ``-Database``, ``-Table``, ``-KeyField``, and
  ``-KeyValue``. This ensures that these values match those from the
  outer ``[Inline] … [/Inline]`` tags exactly.

  ::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords='All',
        'Last_Name'='Peoples']
        [Records]
        
            [Inline: -Delete,
                -Database=(Database_Name),
                -Table=(Table_Name),
                -KeyField=(KeyField_Name),
                -KeyValue=(KeyField_Value)]
                [Error_CurrentError: -ErrorCode]: [Error_CurrentError]
            [/Inline]
        [/Records]
    [/Inline]

  This particular search only finds one record to delete. If the delete
  action is successful then the following will be returned for each
  deleted record.

  ::

    -> 0: No Error

Duplicating Records
-------------------

Records can be duplicated within any Lasso compatible database using the
``-Duplicate`` command tag. The ``-Duplicate`` command tag can be
specified within an ``[Inline]`` tag, an HTML form, or a URL. The
``-Duplicate`` command tag requires that a number of additional command
tags be defined in order to perform the ``-Duplicate`` action. The
required command tags are detailed in the following table.

.. Note:: Lasso Connector for MySQL and Lasso Connector for SQLite do not support the ``-Duplicate`` command tag.

.. table:: Table 6: -Duplicate Action Requirements

  +----------------+-------------------------------------------------+
  |Tag             |Description                                      |
  +================+=================================================+
  |``-Duplicate``  |The action which is to be performed. Required.   |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-Database``   |The database in which the record should be       |
  |                |duplicated. Required.                            |
  +----------------+-------------------------------------------------+
  |``-Table``      |The table from the specified database in which   |
  |                |the record should be duplicated. Required.       |
  +----------------+-------------------------------------------------+
  |``-KeyField``   |The name of the field which holds the primary key|
  |                |for the specified table. Required.               |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``-KeyValue``   |The value of the primary key of the record which |
  |                |is to be duplicated. Required.                   |
  |                |                                                 |
  +----------------+-------------------------------------------------+
  |``Name/Value    |A variable number of name/value parameters       |
  |Parameters``    |specifying field values which should be modified |
  |                |in the duplicated record. Optional.              |
  +----------------+-------------------------------------------------+
  |``-Host``       |Optional inline host array.                      |
  |                |                                                 |
  |                |.. seealso:: the section on ***Inline Hosts***   |
  |                |   in the ***Database Interaction                |
  |                |   Fundamentals*** chapter for more information. |
  +----------------+-------------------------------------------------+
  
Lasso identifies the record which is to be duplicated using the values
for the command tags ``-KeyField`` and ``-KeyValue``. ``-KeyField`` must
be set to a field in the table which has a unique value for every record
in the table. Usually, this is the primary key field for the table.
``-KeyValue`` must be set to a valid value for the ``-KeyField`` in the
table. If no record can be found with the specified ``-KeyValue`` then
an error will be returned.

Any name/value parameters included in the duplicate action will be used
to set the field values for the record which is added to the database.
All name/value parameters must reference a writable field within the
database. Any fields which are not referenced will maintain the values
they had from the record which was duplicated.

Lasso always returns a reference to the new record which was added to
the database as a result of the ``-Duplicate`` action. This is
equivalent to performing a ``-Search`` action which returns a single
record found set containing just the record which was added to the
database.

**To duplicate a record with data using [Inline] … [/Inline] tags:**

The following example shows how to perform a duplicate action within a
FileMaker Pro database by specifying the required command tags within an
opening ``[Inline]`` tag. The record with the value ``2`` for the
keyfield value is duplicated. The ``[Inline]`` tag includes a series of
name/value parameters that define the new values for various fields
within the record that is to be updated. The ``First_Name`` field is set
to ``Joe`` and the ``Last_Name`` field is set to ``Surname``. The new
record will include these values, but any fields which were not
specified in the action will be left with the values they had from the
source record.

::

    [Inline: -Duplicate,
        -Database='Contacts.fp3',
        -Table='People',
        -KeyField='ID',
        -KeyValue=2,
        'First_Name'='Joe',
        'Last_Name'='Surname']
        <p>[Error_CurrentError: -ErrorCode]: [Error_CurrentError]
        <br>Record [Field: 'ID'] was duplicated for [Field: 'First_Name'] [Field: 'Last_Name'].
    [/Inline]

If the duplicate action is successful then the following will be
returned. The values from the ``[Field]`` tags are retrieved from the
record which was just added to the database as a result of the duplicate
action.

::

  -> 0: No Error
     Record 6 was duplicated for Joe Surname.
