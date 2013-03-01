.. _database-interaction:

.. direct from book

*********************************
Database Interaction Fundamentals
*********************************

One of the primary purposes of Lasso is to perform database actions
which are a combination of predefined and visitor-defined parameters and
to format the results of those actions. This chapter introduces the
fundamentals of specifying database actions in Lasso.

-  **Inline** Database Actions includes full details for how to use
   the ``[Inline]`` tag to specify database actions.
-  **Action Parameters** describes how to get information about an
   action.
-  **Results** includes information about how to return details of a
   Lasso database action.
-  **Showing Database Schema** describes the tags that can be used to
   examine the schema of a database.
-  **Inline Hosts** describes how connection characteristics for the
   data source host can be specified entirely within the inline.
-  **SQL Statements** describes the ``-SQL`` command tag and how to issue
   raw SQL statements to SQL-compliant data sources.
-  **SQL Transactions** describes how to perform reversible SQL
   transactions using Lasso.

Inlines
-------

The ``[Inline] … [/Inline]`` container tags are used to specify a
database action and to present the results of that action within a Lasso
page. The database action is specified using parameters as keyword/value
parameters within the opening ``[Inline]`` tag. Additional name/value
parameters specify the user-defined parameters of the database action.
Each ``[Inline]`` normally represents a single database action, but when
using SQL statements a single inline can be use to perform batch
operations as well. Additional actions can be performed in subsequent or
nested ``[Inline] … [/Inline]`` tags.

.. table:: Table 1: Inline Tag

   +------------------------+---------------------------------------------+
   |Tag/Parameter           |Description                                  |
   +========================+=============================================+
   |``[Inline] … [/Inline]``|Performs the database action specified in the|
   |                        |opening tag. The results of the database     |
   |                        |action are available inside the container tag|
   |                        |or later on the page within ``[ResultSet] …  |
   |                        |[/ResultSet]`` tags.                         |
   +------------------------+---------------------------------------------+
   |``-Database``           |Specifies the name of the database which will|
   |                        |be used to perform the database action. If no|
   |                        |``-Host`` is specified then the database is  |
   |                        |used to determine what data source should    |
   |                        |process the inline action. (Optional)        |
   +------------------------+---------------------------------------------+
   |``-Host``               |Specifies the connection parameters for a    |
   |                        |host within the inline. This provides an     |
   |                        |alternative to setting up data source hosts  |
   |                        |within Lasso Site Administration. (Optional) |
   +------------------------+---------------------------------------------+
   |``-InlineName``         |Specifies a name for the inline. The same    |
   |                        |name can be used with the ``[ResultSet] …    |
   |                        |[/ResultSet]`` tags to return the records    |
   |                        |from the inline later on the page.           |
   |                        |(Optional)                                   |
   +------------------------+---------------------------------------------+
   |``-Log``                |Specifies at what log level the statement    |
   |                        |from the inline should be logged. Values     |
   |                        |include ``None``, ``Detail``, ``Warning``,   |
   |                        |and ``Critical``. If not specified then the  |
   |                        |default log level for action statements will |
   |                        |be used. (Optional)                          |
   +------------------------+---------------------------------------------+
   |``-StatementOnly``      |Specifies that the inline should generate the|
   |                        |internal statement required to perform the   |
   |                        |action, but not actually perform the         |
   |                        |action. The statement can be fetched with    |
   |                        |``[Action_Statement]``. (Optional)           |
   +------------------------+---------------------------------------------+
   |``-Table``              |Specifies the table that should be used to   |
   |                        |perform the database action. Most database   |
   |                        |actions require that a table be              |
   |                        |specified. The ``-Table`` is used to         |
   |                        |determine what encoding will be used when    |
   |                        |interpreting database results so a ``-Table``|
   |                        |may be necessary even for an inline with a   |
   |                        |``-SQL`` action. (Optional)                  |
   +------------------------+---------------------------------------------+
   |``-Username``           |Specifies the name of the user whose         |
   |                        |permissions should be used to perform the    |
   |                        |database action. If no ``-Username`` is      |
   |                        |specified then the permissions of the        |
   |                        |surrounding inline will be used or the       |
   |                        |permissions of the calling Lasso page        |
   |                        |itself. An inline with just a ``-Username``  |
   |                        |and ``-Password``, but no database action can|
   |                        |be used to run the contained portion of the  |
   |                        |page with the permissions of the specified   |
   |                        |user. (Optional)                             |
   +------------------------+---------------------------------------------+
   |``-Password``           |Specifies the password for the               |
   |                        |user. (Required if ``-Username`` is          |
   |                        |specified.)                                  |
   +------------------------+---------------------------------------------+

The results of the database action can be displayed within the contents
of the ``[Inline] … [/Inline]`` container tags using the
``[Records] … [/Records]`` container tags and the ``[Field]``
substitution tag. Alternately, the ``[Inline]`` can be named using
``-InlineName`` and the results can be displayed later using
``[ResultSet] … [/ResultSet]`` tags.

The entire database action can be specified directly in the opening
``[Inline]`` tag or visitor-defined aspects of the action can be
retrieved from an HTML form submission. ``[Link_…]`` tags can be used to
navigate a found set in concert with the use of ``[Inline] … [/Inline]``
tags. Nested ``[Inline] … [/Inline]`` tags can be used to create complex
database actions.

Inlines can log the statement (SQL or otherwise) that they generate. The
optional ``-Log`` parameter controls at what level the statement is
logged. Setting ``-Log`` to ``None`` will suppress logging from the
inline. If no ``-Log`` is specified then the default log-level set for
the data source in Site Administration will be used.

The ``-StatementOnly`` option instructs the data source to generate the
implementation-specific statement required to perform the desired
database action, but not to actually perform it. The generated statement
can be returned with ``[Action_Statement]``. This is useful in order to
see the statement Lasso will generate for an action, perform some
modifications to that statement, then re-issue the statement using
``-SQL`` in another inline.

**To change the log level for an inline database action:**

Use the ``-Log`` parameter within the opening ``[Inline]`` tag.

-  Suppress the action statement from being logged by setting
   ``-Log='None'``. The action statement will not be logged no matter
   how the various log levels are routed.

   ::

        
       [Inline: -Search, -Database='Example', -Table='Example', -Log='None', …]
       …
       [/Inline]

-  Log the action statement at the critical log level by setting
   ``-Log='Critical'``. This can be useful when debugging a Web site
   since the action statement generated by this inline can be seen even
   if action statements are generally being suppressed by the log
   routing preferences.

   ::

        
       [Inline: -Search, -Database='Example', -Table='Example', -Log='Critical', …]
       …
       [/Inline]

**To see the action statement generated by an inline database action:**

Use the ``[Action_Statement]`` tag within the ``[Inline] … [/Inline]``
tags. The tag will return the action statement that was generated by the
data source connector to fulfill the specified database action. For SQL
data sources like MySQL and SQLite a SQL statement will be returned.
Other data sources may return a different style of action statement.

::

     
    [Inline: -Search, -Database='Example', -Table='Example', …]
       [Action_Statement]
       …
    [/Inline]

To see the action statement that would be generated by the data source
without actually performing the database action the ``-StatementOnly``
parameter can be specified in the opening ``[Inline]`` tag. The
``[Action_Statement]`` tag will return the same value is would for a
normal inline database action, but the database action will not actually
be performed.

::

     
    [Inline: -Search, -Database='Example', -Table='Example', -StatementOnly, …]
       [Action_Statement]
       …
    [/Inline]

Database Actions
^^^^^^^^^^^^^^^^

A database action is performed to retrieve data from a database or to
manipulate data which is stored in a database. Database actions can be
used in Lasso to query records in a database that match specific
criteria, to return a particular record from a database, to add a record
to a database, to delete a record from a database, to fetch information
about a database, or to navigate through the found set from a database
search. In addition, database actions can be used to execute SQL
statements in compliant databases.

The database actions in Lasso are defined according to what action
parameter is used to trigger the action. The following table lists the
parameters which perform database actions that are available in Lasso.

.. table:: Table 2: Inline Database Action Parameters

   +--------------+--------------------------------------------------+
   |Tag           |Description                                       |
   +==============+==================================================+
   |``-Search``   |Finds records in a database that match specific   |
   |              |criteria, returns detail for a particular record  |
   |              |in a database, or navigates through a found set of|
   |              |records.                                          |
   +--------------+--------------------------------------------------+
   |``-FindAll``  |Returns all records in a specific database table. |
   +--------------+--------------------------------------------------+
   |``-Random``   |Returns a single, random record from a database   |
   |              |table.                                            |
   +--------------+--------------------------------------------------+
   |``-Add``      |Adds a record to a database table.                |
   +--------------+--------------------------------------------------+
   |``-Update``   |Updates a specific record from a database table.  |
   +--------------+--------------------------------------------------+
   |``-Duplicate``|Duplicates a specific record in a database        |
   |              |table. Only works with FileMaker Pro databases.   |
   +--------------+--------------------------------------------------+
   |``-Delete``   |Removes a specified record from a database table. |
   +--------------+--------------------------------------------------+
   |``-Show``     |Returns information about the tables and fields   |
   |              |within a database.                                |
   +--------------+--------------------------------------------------+
   |``-SQL``      |Executes a SQL statement in a compatible data     |
   |              |source. Only works with SQLite, MySQL, and other  |
   |              |SQL databases.                                    |
   +--------------+--------------------------------------------------+
   |``-Prepare``  |Creates a prepared SQL statement in a compatible  |
   |              |data source. Nested inlines with an ``-Exec``     |
   |              |action will execute the prepared statement with   |
   |              |different values.                                 |
   +--------------+--------------------------------------------------+
   |``-Exec``     |Executes a prepared statement. Must be called from|
   |              |an inline nested within an inline with a          |
   |              |``-Prepare`` action.                              |
   +--------------+--------------------------------------------------+
   |``-Nothing``  |The default action which performs no database     |
   |              |interaction, but simply passes the parameters of  |
   |              |the action.                                       |
   +--------------+--------------------------------------------------+
   
.. Note:: **Table 2: Database Action Parameters** lists all of the
    database actions that Lasso supports. Individual data source
    connectors may only support a subset of these parameters. The Lasso
    Connector for MySQL and the Lasso Connector for SQLite do not
    support the ``-Duplicate`` action. The Lasso Connector for FileMaker
    Pro does not support the ``-SQL`` action. See the documentation for
    third party data source connectors for information about what
    parameters they support.

Each database action parameter requires additional parameters in order
to execute the proper database action. These parameters are specified
using additional parameters and name/value pairs. For example, a
``-Database`` parameter specifies the database in which the action
should take place and a ``-Table`` parameter specifies the specific
table from that database in which the action should take place.
Name/value pairs specify the query for a ``-Search`` action, the initial
values for the new record created by an ``-Add`` action, or the updated
values for an ``-Update`` action.

Full documentation of which ``[Inline]`` parameters are required for
each action are detailed in the section specific to that action in this
chapter, the :ref:`Searching and Displaying
Data<searching-and-displaying-data>` chapter, or the
:ref:`Adding and Updating Records<adding-and-updating-records>` chapter.

**Example of specifying a -FindAll action within an [Inline]:**

The following example shows an ``[Inline] … [/Inline]`` tag that has a
``-FindAll`` database action specified in the opening tag. The
``[Inline]`` tag includes a ``-FindAll`` parameter to specify the
action, ``-Database`` and ``-Table`` parameters to specify the database
and table from which records should be returned, and a ``-KeyField``
parameter which specifies the key field for the table. The entire
database action is hard-coded within the ``[Inline]`` tag.

The tag ``[Found_Count]`` returns how many records are in the database.
The ``[Records] … [/Records]`` container tags repeat their contents for
each record in the found set. The ``[Field]`` tags are repeated for each
found record creating a listing of the names of all the people stored in
the Contacts database.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        There are [Found_Count] record(s) in the People table.
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

    -> There are 2 record(s) in the People table.
       John Doe
       Jane Doe

**Example of specifying a -Search action within an [Inline]:**

The following example shows an ``[Inline] … [/Inline]`` tag that has a
``-Search`` database action specified in the opening tag. The
``[Inline]`` tag includes a ``-Search`` parameter to specify the action,
``-Database`` and ``-Table`` parameters to specify the database and
table records from which records should be returned, and a ``-KeyField``
parameter which specifies the key field for the table. The subsequent
name/value parameters, ``'First_Name'='John'`` and
``'Last_Name'='Doe'``, specify the query which will be performed in the
database. Only records for John Doe will be returned. The entire
database action is hard-coded within the ``[Inline]`` tag.

The tag ``[Found_Count]`` returns how many records for ``John Doe`` are
in the database. The ``[Records] … [/Records]`` container tags repeat
their contents for each record in the found set. The ``[Field]`` tags
are repeated for each found record creating a listing of all the records
for ``John Doe`` stored in the ``Contacts`` database.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='John',
        'Last_Name'='Doe']
        There were [Found_Count] record(s) found in the People table.
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]
    
    -> There were 1 record(s) found in the People table.
       John Doe

Using HTML Forms
^^^^^^^^^^^^^^^^

The previous two examples show how to specify a hard-coded database
action completely within an opening ``[Inline]`` tag. This is an
excellent way to embed a database action that will be the same every
time a page is loaded, but does not provide any room for visitor
interaction.

A more powerful technique is to use values from an HTML form or URL to
allow a site visitor to modify the database action which is performed
within the ``[Inline]`` tag. The following two examples demonstrate two
different techniques for doing this using the singular
``[Action_Param]`` tag and the array-based ``[Action_Params]`` tag.

**Example of using HTML form values within an [Inline] with
[Action_Param]:**

An inline-based database action can make use of visitor specified
parameters by reading values from an HTML form which the visitor
customizes and then submits to trigger the page containing the
``[Inline] … [/Inline]`` tags.

The following HTML form provides two inputs into which the visitor can
type information. An input is provided for ``First_Name`` and one for
``Last_Name``. These correspond to the names of fields in the Contacts
database. The action of the form is set to response.lasso which will
contain the ``[Inline] … [/Inline]`` tags that perform the actual
database action. The action tag specified in the form is ``-Nothing``
which instructs Lasso to perform no database action when the form is
submitted.

::

    <form action="/response.lasso" method="POST">
        <br>First Name: <input type="text" name="First_Name" value="">
        <br>Last Name: <input type="text" name="Last_Name" value="">
        <br><input type="submit" value="Search">
    </form>

The ``[Inline]`` tag on ``response.lasso`` contains the name/value
parameter ``'First_Name'=(Action_Param: 'First_Name')``. The
``[Action_Param]`` tag instructs Lasso to fetch the input named
``First_Name`` from the action which resulted in the current page being
served, namely the form shown above. The ``[Inline]`` contains a similar
name/value parameter for ``Last_Name``.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'=(Action_Param: 'First_Name'),
        'Last_Name'=(Action_Param: 'Last_Name')]
        There were [Found_Count] record(s) found in the People table.
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

If the visitor entered ``Jane`` for the first name and ``Doe`` for the
last name then the following results would be returned.

::

    -> There were 1 record(s) found in the People table.
       Jane Doe

As many parameters as are needed can be named in the HTML form and then
retrieved in the response page and incorporated into the ``[Inline]``
tag.

.. Note:: The ``[Action_Param]`` tag is equivalent to the
   ``[Form_Param]`` tag used in prior versions of Lasso.

**Example of using an array of HTML form values within an [Inline]
with [Action_Params]:**

Rather than specifying each ``[Action_Param]`` individually, an entire
set of HTML form parameters can be entered into an ``[Inline]`` tag
using the array-based ``[Action_Params]`` tag. Inserting the
``[Action_Params]`` tag into an ``[Inline]`` functions as if all the
parameters and name/value pairs in the HTML form were placed into the
``[Inline]`` at the location of the ``[Action_Params]`` parameter.

The following HTML form provides two inputs into which the visitor can
type information. An input is provided for ``First_Name`` and one for
``Last_Name``. These correspond to the names of fields in the
``Contacts`` database. The action of the form is set to response.lasso
which will contain the ``[Inline] … [/Inline]`` tags that perform the
actual database action. The database action is ``-Nothing`` which
instructs Lasso to perform no database action when the HTML form is
submitted.

::

    <form action="/response.lasso" method="POST">
        <br>First Name: <input type="text" name="First_Name" value="">
        <br>Last Name: <input type="text" name="Last_Name" value="">
        <br><input type="submit" value="Search">
    </form>

The ``[Inline]`` tag on ``response.lasso`` contains the array parameter
``[Action_Params]``. This instructs Lasso to take all the parameters
from the HTML form or URL which results in the current page being loaded
and insert them in the ``[Inline]`` as if they had been typed at the
location of ``[Action_Params]``. This will result in the name/value
pairs for ``First_Name``, ``Last_Name``, and the ``-Nothing`` action to
be inserted into the ``[Inline]``. The latest action specified has
precedence so the ``-Search`` tag specified in the actual ``[Inline]``
tag overrides the ``-Nothing`` which is passed from the HTML form.

::

    [Inline: (Action_Params),
        -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        There were [Found_Count] record(s) found in the People table.
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

If the visitor entered ``Jane`` for the first name and ``Doe`` for the
last name then the following results would be returned.

::

    -> There were 1 record(s) found in the People table.
       Jane Doe

As many parameters as are needed can be named in the HTML form. They
will all be incorporated into the ``[Inline]`` tag at the location of
the ``[Action_Params]`` tag. Any parameters in the ``[Inline]`` after
the ``[Action_Params]`` tag will override conflicting settings from the
HTML form.

.. Note:: ``[Action_Params]`` is a replacement for the
    ``-ReUseFormParams`` keyword in prior versions of Lasso. See the
    :ref:`Upgrading` section for more information.

HTML Form Response Pages
^^^^^^^^^^^^^^^^^^^^^^^^

Every HTML form or URL needs to have a response page specified so Lasso
knows what Lasso page to process and return as the result of the action.
The referenced Lasso page could contain simple HTML or complex
calculations, but some Lasso page must be specified.

**To specify a Lasso page within an HTML form or URL:**

-  The HTML form action can be set to the location of a Lasso page. For
   example, the following HTML ``<form>`` tag references the file
   ``/response.lasso`` in the root of the Web serving folder.

   ::
        
       <form action="/response.lasso" method="POST"> … </form>

-  The URL can reference the location of a Lasso page before the
   question mark ``?`` delimiter. For example, the following anchor tag
   references the file ``response.lasso`` in the same folder as the page
   in which this anchor is contained.

   ::
        
       <a href="response.lasso?Name=Value"> Link </a>

-  The HTML form can reference ``/Action.Lasso`` and then specify the
   path to the Lasso page in a ``-Response`` tag. For example, the
   following HTML ``<form>`` tag references the file ``response.lasso``
   in the root of the Web serving folder. The path is relative to the
   root because the placeholder ``/Action.Lasso`` is specified with a
   leading forward slash ``/``.

   ::
        
       <form action="/Action.Lasso" method="POST">
           <input type="hidden" name="-Response" value="response.lasso">
       </form>

-  The URL can reference ``Action.Lasso`` and then specify the path to
   the Lasso page in a ``-Response`` tag. For example, the following
   anchor tag references the file ``response.lasso`` in the same folder
   as the page in which the link is specified. The path is relative to
   the local folder because the placeholder ``Action.Lasso`` is
   specified without a leading forward slash ``/``.

   ::

       <a href="Action.Lasso?-Response=response.lasso"> Link </a>

The ``-Response`` tag can be used on its own or action specific response
tags can be used so a form is sent to different response pages if
different actions are performed using the form. Response tags can also
be used to send the visitor to different pages if different errors
happen when the database action is attempted by Lasso. The following
table details the available response tags.

.. table:: Table 3: Response Parameters

    +---------------------------------+--------------------------------------------------+
    |Tag                              |Description                                       |
    +=================================+==================================================+
    |``-Response``                    |Default response tag. The value for this response |
    |                                 |tag is used if no others are specified.           |
    +---------------------------------+--------------------------------------------------+
    |``-ResponseAnyError``            |Default error response tag. The value for this    |
    |                                 |response tag is used if any error occurs and no   |
    |                                 |more specific error response tag is set.          |
    +---------------------------------+--------------------------------------------------+
    |``-ResponseReqFieldMissingError``|Error to use if a ``-Required`` field is not given|
    |                                 |a value by the visitor.                           |
    +---------------------------------+--------------------------------------------------+
    |``-ResponseSecurityError``       |Error to use if a security violation occurs       |
    |                                 |because the current visitor does not have         |
    |                                 |permission to perform the database action.        |
    +---------------------------------+--------------------------------------------------+
    |``-LayoutResponse``              |FileMaker Server data sources will format the     |
    |                                 |results using the layout specified in this tag    |
    |                                 |rather than the layout used to specify the        |
    |                                 |database action.                                  |
    +---------------------------------+--------------------------------------------------+

See the :ref:`Error-Control` chapter for more information about using the error
response pages.

Setting HTML Form Values
^^^^^^^^^^^^^^^^^^^^^^^^

If the Lasso page containing an HTML form is the response to an HTML
form or URL, then the values of the HTML form inputs can be set to
values retrieved from the previous Lasso page using ``[Action_Param]``.

For example, if a form is on default.lasso and the action of the form is
default.lasso then the same page will be reloaded with new form values
each time the form is submitted. The following HTML form uses
``[Action_Param]`` tags to automatically restore the values the user
specified in the form previously, each time the page is reloaded.

::

    <form action="default.lasso" method="POST">
        <br>First Name:
            <input type="hidden" name="First_Name" value="[Action_Param: 'First_Name']">
        <br>Last Name:
            <input type="hidden" name="Last_Name" value="[Action_Param: 'Last_Name']">
        <br><input type="submit" value="Submit">
    </form>

Tokens
^^^^^^

Tokens can be used with HTML forms and URLs in order to pass data along
with the action. Tokens are useful because they do not affect the
operation of a database action, but allow data to be passed along with
the action. For example, meta-data could be associated with a visitor to
a Web site without using sessions or cookies.

-  Tokens can be set in a form using the ``-Token.TokenName=TokenValue``
   parameter. Multiple named tokens can be set in a single form.

   ::
        
       <form action="response.lasso" method="POST">
          <input type="hidden" name="-Token.TokenName" value="TokenValue">
       </form>

-  Tokens can be set in a URL using the ``-Token.TokenName=TokenValue``
   parameter. Multiple named tokens can be set in a single URL.

   ::

       <a href="response.lasso?-Token.TokenName=TokenValue"> Link </a>

-  Tokens set in an HTML form or URL are available in the response page
   of the database action. Tokens are not available inside
   ``[Inline] … [/Inline]`` tags on the responses page unless they are
   explicitly set within the ``[Inline]`` tag itself.
-  Tokens can be set in an ``[Inline]`` using the
   ``-Token.TokenName=TokenValue`` parameter. Multiple named tokens can
   be set in a single ``[Inline]``.
-  Tokens set in an ``[Inline]`` are only available immediately inside
   the ``[Inline]``. They are not available to nested ``[Inlines]``
   unless they are set specifically within each ``[Inline]``.
-  By default, tokens are included in the ``[Link_…]`` tags and in
   ``[Action_Params]``. Unless specifically set otherwise, tokens will
   be redefined on pages which are returned using the ``[Link_…]`` tags.

Nesting Inline Database Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Database actions can be combined to perform compound database actions.
All the records in a database that meet certain criteria could be
updated or deleted. Or, all the records from one database could be added
to a different database. Or, the results of searches from several
databases could be merged and used to search another database.

Database actions are combined by nesting ``[Inline] … [/Inline]`` tags.
For example, if ``[Inline] … [/Inline]`` tags are placed inside the
``[Records] … [/Records]`` container tag within another set of
``[Inline] … [/Inline]`` tags then the inner ``[Inline]`` will execute
once for each record found in the outer ``[Inline]``.

All database results tags function for only the innermost set of
``[Inline] … [/Inline]`` tags. Variables can pass through into nested
``[Inline] … [/Inline]`` tags, but tokens cannot, these need to be reset
in each ``[Inline]`` tag in the hierarchy.

.. Note:: SQL nested inlines can also be used to perform reversible SQL
    transactions in transaction-compliant SQL data sources. See the
    :ref:`SQL-Transactions` section at the end of this chapter for more
    information.

**Example of nesting [Inline] … [/Inline] tags:**

This example will use nested ``[Inline] … [/Inline]`` tags to change the
last name of all people whose last name is currently ``Doe`` in a
database to ``Person``. The outer ``[Inline] … [/Inline]`` tags perform
a hard-coded search for all records with ``Last_Name`` equal to ``Doe``.
The inner ``[Inline] … [/Inline]`` tags update each record so
``Last_Name`` is now equal to ``Person``. The output confirms that the
conversion went as expected by outputting the new values.

::
     
    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'Last_Name'='Doe',
        -MaxRecords='All']
        [Records]
            [Inline: -Update,
                -Database='Contacts',
                -Table='People',
                -KeyField='ID',
                -KeyValue=(KeyField_Value),
                'Last_Name'='Person']
                <br>Name is now [Field: 'First_Name'] [Field: 'Last_Name']
            [/Inline]
        [/Records]
    [/Inline]
    -> Name is now Jane Person
       Name is now John Person

Array Inline Parameters
^^^^^^^^^^^^^^^^^^^^^^^

Most parameters can be used within an ``[Inline]`` tag to specify an
action. In addition, parameters and name/ value parameters can be stored
in an array and then passed into an ``[Inline]`` as a block. Any single
value in an ``[Inline]`` which is an array data type will be interpreted
as a series of parameters inserted at that location in the array. This
technique is useful for programmatically assembling database actions.

Many parameters can only take a single value within an ``[Inline]`` tag.
For example, only a single action can be specified and only a single
database can be specified. The last action parameter defines the value
that will be used for the action. The last, for example, ``-Database``
parameter defines the value that will be used for the database of the
action. If an array parameter comes first in an ``[Inline]`` then all
subsequent parameters will override any conflicting values within the
array parameter.

**Example of using an array to pass values into an [Inline]:**

The following LassoScript performs a ``-FindAll`` database action with
the parameters first specified in an array and stored in the variable
Params, then passed into the opening ``[Inline]`` tag all at once. The
value for ``-MaxRecords`` in the ``[Inline]`` tag overrides the value
specified within the array parameter since it is specified later. Only
the number of records found in the database are returned.

::

    <?LassoScript
        Variable: 'Params'=(Array:
            -FindAll='',
            -Database='Contacts',
            -Table='People',
            -MaxRecords=50
        );
        Inline: (Var: 'Params'), -MaxRecords=100;
            'There are ' + (Found_Count) + 'record(s) in the People table.';
        /Inline;
    ?>

    -> There are 2 record(s) in the People table.

Action Parameters
-----------------

Lasso has a set of substitution tags which allow for information about
the current action to be returned. The parameters of the action itself
can be returned or information about the action’s results can be
returned.

The following table details the substitution tags which allow
information about the current action to be returned. If these tags are
used within an ``[Inline] … [/Inline]`` container tag they return
information about the action specified in the opening ``[Inline]`` tag.
Otherwise, these tags return information about the action which resulted
in the current Lasso page being served.

Even Lasso pages called with a simple URL such as
``http://www.example.com/response.lasso`` have an implicit ``-Nothing``
action. Many of these substitution tags return default values even for
the ``-Nothing`` action.

.. table:: Table 4: Action Parameter Tags

    +---------------------------+--------------------------------------------------+
    |Tag                        |Description                                       |
    +===========================+==================================================+
    |``[Action_Param]``         |Returns the value for a specified name/value      |
    |                           |parameter. Equivalent to ``[Form_Param]``.        |
    +---------------------------+--------------------------------------------------+
    |``[Action_Params]``        |Returns an array containing all of the parameters |
    |                           |and name/value parameters that define the current |
    |                           |action.                                           |
    +---------------------------+--------------------------------------------------+
    |``[Action_Statement]``     |Returns the statement that was generated by the   |
    |                           |datasource to implement the requested action. For |
    |                           |SQL datasources this will return a SQL            |
    |                           |statement. Other datasources may return different |
    |                           |values.                                           |
    +---------------------------+--------------------------------------------------+
    |``[Database_Name]``        |Returns the name of the current database.         |
    +---------------------------+--------------------------------------------------+
    |``[KeyField_Name]``        |Returns the name of the current key field.        |
    +---------------------------+--------------------------------------------------+
    |``[KeyField_Value]``       |Returns the name of the current key value if      |
    |                           |defined. Equivalent to ``[RecordID_Value]``.      |
    +---------------------------+--------------------------------------------------+
    |``[Lasso_CurrentAction]``  |Returns the name of the current Lasso action.     |
    +---------------------------+--------------------------------------------------+
    |``[MaxRecords_Value]``     |Returns the number of records from the found set  |
    |                           |that are currently being displayed.               |
    +---------------------------+--------------------------------------------------+
    |``[Operator_LogicalValue]``|Returns the value for the logical operator.       |
    +---------------------------+--------------------------------------------------+
    |``[Response_FilePath]``    |Returns the path to the current Lasso page.       |
    +---------------------------+--------------------------------------------------+
    |``[SkipRecords_Value]``    |Returns the current offset into a found set.      |
    +---------------------------+--------------------------------------------------+
    |``[Table_Name]``           |Returns the name of the current table. Equivalent |
    |                           |to ``[Layout_Name]``.                             |
    +---------------------------+--------------------------------------------------+
    |``[Token_Value]``          |Returns the value for a specified token.          |
    +---------------------------+--------------------------------------------------+
    |``[Search_Arguments]``     |Container tag repeats once for each name/value    |
    |                           |parameter of the current action.                  |
    +---------------------------+--------------------------------------------------+
    |``[Search_FieldItem]``     |Returns the name portion of a name/value parameter|
    |                           |of the current action.                            |
    +---------------------------+--------------------------------------------------+
    |``[Search_OperatorItem]``  |Returns the operator associated with a name/value |
    |                           |parameter of the current action.                  |
    +---------------------------+--------------------------------------------------+
    |``[Search_ValueItem]``     |Returns the value portion of a name/value         |
    |                           |parameter of the current action.                  |
    +---------------------------+--------------------------------------------------+
    |``[Sort_Arguments]``       |Container tag repeats once for each sort          |
    |                           |parameter.                                        |
    +---------------------------+--------------------------------------------------+
    |``[Sort_FieldItem]``       |Returns the field which will be sorted.           |
    +---------------------------+--------------------------------------------------+
    |``[Sort_OrderItem]``       |Returns the order by which the field will be      |
    |                           |sorted.                                           |
    +---------------------------+--------------------------------------------------+

The individual substitution tags can be used to return feedback to site
visitors about what database action is being performed or to return
debugging information. For example, the following code inserted at the
top of a response page to an HTML form or URL or in the body of an
``[Inline] … [/Inline]`` tag will return details about the database
action that was performed.

::

    Action: [Lasso_CurrentAction]
    Database: [Database_Name]
    Table: [Table_Name]
    Key Field: [KeyField_Name]
    KeyValue: [KeyField_Value]
    MaxRecords: [MaxRecords_Value]
    SkipRecords: [SkipRecords_Value]
    Logical Operator: [Operator_LogicialValue]
    Statement: [Action_Statement]

    ->
    Action: Find All
    Database: Contacts
    Table: People
    Key Field: ID
    KeyValue: 100001
    MaxRecords: 50
    SkipRecords: 0
    Logical Operator: AND
    Statement: SELECT * FROM Contacts.People LIMIT 50

The ``[Action_Params]`` tag can be used to return information about the
entire Lasso action in a single array. Rather than assembling
information using the individual substitution tags it is often easier to
extract information from the ``[Action_Params]`` array. The schema of
the array returned by ``[Action_Params]`` is detailed in :ref:`Table 5:
[Action_Params] Array Schema
<database-interaction-fundamentals-table-5>`.

The schema shows the names of the values which are returned in the
array. Even if ``-Layout`` is used to specify the layout for a database
action, the value of that tag is returned after ``-Table`` in the
``[Action_Params] array``.

**To output the parameters of the current database action:**

The value of the ``[Action_Params]`` tag in the following example is
formatted to show the elements of the returned array clearly. The
``[Action_Params]`` array contain values for ``-MaxRecords``,
``-SkipRecords``, and ``-OperatorLogical`` even though these aren’t
specified in the ``[Inline]`` tag.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        [Action_Params]
    [/Inline]

    ->
    (Array:
        (Pair: (-Search) = ()),
        (Pair: (-Database) = (Contacts)),
        (Pair: (-Table) = (People)),
        (Pair: (-KeyField) = (ID)),
        (Pair: (-MaxRecords) = (50)),
        (Pair: (-SkipRecords) = (0)),
        (Pair: (-OperatorLogical) = (AND))
    )

.. _database-interaction-fundamentals-table-5:

.. table:: Table 5: [Action_Params] Array Schema

    +------------------------------+--------------------------------------------------+
    |Tag                           |Description                                       |
    +==============================+==================================================+
    |``Action``                    |The action parameter is always returned first. The|
    |                              |name of the first item is set to the action       |
    |                              |parameter and the value is left empty.            |
    +------------------------------+--------------------------------------------------+
    |``-Database``                 |If defined, the name of the current database.     |
    +------------------------------+--------------------------------------------------+
    |``-Table``                    |If defined, the name of the current table.        |
    +------------------------------+--------------------------------------------------+
    |``-KeyField``                 |If defined, the name of the field which holds the |
    |                              |primary key for the specified table.              |
    +------------------------------+--------------------------------------------------+
    |``-KeyValue``                 |If defined, the particular value for the primary  |
    |                              |key.                                              |
    +------------------------------+--------------------------------------------------+
    |``-MaxRecords``               |Always included. Defaults to ``50``.              |
    +------------------------------+--------------------------------------------------+
    |``-SkipRecords``              |Always included. Defaults to ``0``.               |
    +------------------------------+--------------------------------------------------+
    |``-OperatorLogical``          |Always included. Defaults to ``AND``.             |
    +------------------------------+--------------------------------------------------+
    |``-ReturnField``              |If defined, can have multiple values.             |
    +------------------------------+--------------------------------------------------+
    |``-SortOrder``, ``-SortField``|If defined, can have multiple values.             |
    |                              |``-SortOrder`` is always defined for each         |
    |                              |``-SortField``. Defaults to ``ascending``.        |
    +------------------------------+--------------------------------------------------+
    |``-Token``                    |If defined, can have multiple values each         |
    |                              |specified as ``-Token.TokenName`` with the        |
    |                              |appropriate value.                                |
    +------------------------------+--------------------------------------------------+
    |``Name/Value Parameter``      |If defined, each name/value parameter is included.|
    +------------------------------+--------------------------------------------------+
    |``-Required``                 |If defined, can have multiple values. Included in |
    |                              |order within name/value parameters.               |
    +------------------------------+--------------------------------------------------+
    |``-Operator``                 |If defined, can have multiple values. Included in |
    |                              |order within name/value parameters.               |
    +------------------------------+--------------------------------------------------+
    |``-OperatorBegin``            |If defined, can have multiple values. Included in |
    |                              |order within name/value parameters.               |
    +------------------------------+--------------------------------------------------+
    |``-OperatorEnd``              |If defined, can have multiple values. Included in |
    |                              |order within name/value parameters.               |
    +------------------------------+--------------------------------------------------+

The ``[Action_Params]`` array contains all the parameters and name/value
parameters required to define a database action. It does not include any
``-Response…`` parameters, the ``-Username`` and ``-Password``
parameters, ``-FMScript…`` parameters, ``-InlineName`` keyword or any
legacy or unrecognized parameters.

To output the name/value parameters of the current database action:

Loop through the ``[Action_Params]`` tag and display only name/value
pairs for which the name does not start with a hyphen, i.e. any
name/value pairs which do not start with a keyword. The following
example shows a search of the ``People`` table of the ``Contacts``
database for a person named ``John Doe``.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='John',
        'Last_Name'='Doe']
        [Loop: (Action_Params)->Size]
            [If: !(Action_Params)->(Get: Loop_Count)->(First)->(BeginsWith: '-')]
                <br>
                [Encode_HTML: (Action_Params)->(Get: Loop_Count)]
            [/If]
        [/Loop]
    [/Inline]

    ->
    <br>(Pair: (First_Name) = (John))
    <br>(Pair: (Last_Name) = (Doe))

**To display action parameters to a site visitor:**

The ``[Search_Arguments] … [/Search_Arguments]`` container tag can be
used in conjunction with the ``[Search_FieldItem]``,
``[Search_ValueItem]`` and ``[Search_OperatorItem]`` substitution tags
to return a list of all name/value parameters and associated operators
specified in a database action.

::

    [Search_Arguments]
        [Search_OperatorItem] [Search_FIeldItem] = [Search_ValueItem]
    [/Search_Arguments]

The ``[Sort_Arguments] … [/Sort_Arguments]`` container tag can be used
in conjunction with the ``[Sort_FieldItem]`` and ``[Sort_OrderItem]``
substitution tags to return a list of all name/value parameters and
associated operators specified in a database action.

::

    [Sort_Arguments]
        <br>[Sort_OperatorItem] [Sort_FIeldItem] = [Sort_OrderItem]
    [/Sort_Arguments]

Results
-------

The following table details the substitution tags which allow
information about the results of the current action to be returned.
These tags provide information about the current found set rather than
providing data from the database or providing information about what
database action was performed.

.. table:: Table 6: Results Tags

    +------------------------------+--------------------------------------------------+
    |Tag                           |Description                                       |
    +==============================+==================================================+
    |``[Field]``                   |Returns the value for a specified field from the  |
    |                              |result set.                                       |
    +------------------------------+--------------------------------------------------+
    |``[Found_Count]``             |Returns the number of records found by Lasso.     |
    +------------------------------+--------------------------------------------------+
    |``[Records] … [/Records]``    |Loops once for each record in the found           |
    |                              |set. ``[Field]`` tags within the ``[Records] …    |
    |                              |[/Records]`` tags will return the value for the   |
    |                              |specified field in each record in turn. Can be    |
    |                              |used with an ``-InlineName`` to return the records|
    |                              |for a named inline outside of the inline          |
    |                              |container.                                        |
    +------------------------------+--------------------------------------------------+
    |``[Records_Array]``           |Returns the complete found set in an array of     |
    |                              |arrays. The outer array contains one item for     |
    |                              |every record in the found set. The item for each  |
    |                              |record is an array containing one item for each   |
    |                              |field in the result set.                          |
    +------------------------------+--------------------------------------------------+
    |``[Records_Map]``             |Returns the complet found set in a map of         |
    |                              |maps. See the table below for details about the   |
    |                              |parameters and output of ``[Records_Map]``.       |
    +------------------------------+--------------------------------------------------+
    |``[ResultSet_Count]``         |Returns the number of result sets which were      |
    |                              |generated by the inline. This will generally only |
    |                              |be applicable to inlines which include a ``-SQL`` |
    |                              |parameter with multiple statements. An optional   |
    |                              |``-InlineName`` parameter will return the number  |
    |                              |of result sets that a named inline has, outside of|
    |                              |the inline container.                             |
    +------------------------------+--------------------------------------------------+
    |``[ResultSet] … [/ResultSet]``|Returns a single result set from an inline. The   |
    |                              |opening tag requires an integer parameter which   |
    |                              |specifies which result set to return. An optional |
    |                              |``-InlineName`` parameter will return the         |
    |                              |indicated result set from a named inline.         |
    +------------------------------+--------------------------------------------------+
    |``[Shown_Count]``             |Returns the number of records shown in the current|
    |                              |found set. Less than or equal to                  |
    |                              |``[MaxRecords_Value]``.                           |
    +------------------------------+--------------------------------------------------+
    |``[Shown_First]``             |Returns the number of the first record shown from |
    |                              |the found set. Usually ``[SkipRecords_Value]``    |
    |                              |plus one.                                         |
    +------------------------------+--------------------------------------------------+
    |``[Shown_Last]``              |Returns the number of the last record shown from  |
    |                              |the found set.                                    |
    +------------------------------+--------------------------------------------------+
    |``[Total_Records]``           |Returns the total number of records in the current|
    |                              |table. Works with FileMaker Pro databases only.   |
    +------------------------------+--------------------------------------------------+

.. Note:: Examples of using most of these tags are provided in the
    following :ref:`Searching-and-Displaying-Data` chapter.

The found set tags can be used to display information about the current
found set. For example, the following code generates a status message
that can be displayed under a database listing.

::

    Found [Found_Count] records of [Total_Records] Total.
    <br>Displaying [Shown_Count] records from [Shown_First] to [Shown_Last].

    ->
    Found 100 records of 1500 Total.
    Displaying 10 records from 61 to 70.

These tags can also be used to create links that allow a visitor to
navigate through a found set.

.. _Records-Array:

Records Array
^^^^^^^^^^^^^

The ``[Records_Array]`` tag can be used to get access to all of the data
from an inline operation. The tag returns an array with one element for
each record in the found set. Each element is itself an array that
contains one element for each field in the found set.

The tag can either be used to quickly output all of the data from the
inline operation or can be used with the ``[Iterate] … [/Iterate]`` or
other tags to get access to the data programmatically.

::

    [Inline: -Search, -Database='Contacts', -Table='People']
        [Records_Array]
    [/Inline]

    ->
    (Array: (Array: (John), (Doe)), (Array: (Jane), (Doe)), …)

The output can be made easier to read using the ``[Iterate] …
[/Iterate]`` tags and the ``[Array->Join]`` tag.

::

    [Inline: -Search, -Database='Contacts', -Table='People']
        [Iterate: Records_Array, (Var: 'Record')]
            "[Encode_HTML: $Record->(Join: '", "')]"<br />
        [/Iterate]
    [/Inline]

    ->
    "John", "Doe"<br />
    "Jane", "Doe"<br />
    …

The output can be listed with the appropriate field names by using the
``[Field_Names]`` tag. This tag returns an array that contains each
field name from the current found set. The ``[Field_Names]`` tag will
always contain the same number of elements as the elements of the
``[Records_Array]`` tag.

::

    [Inline: -Search, -Database='Contacts', -Table='People']
        "[Encode_HTML: Field_Names->(Join: '", "')]"<br />
        [Iterate: Records_Array, (Var: 'Record')]
            "[Encode_HTML: $Record->(Join: '", "')]"<br />
        [/Iterate]
    [/Inline]

    ->
    "First_Name", "Last_Name"<br />
    "John", "Doe"<br />
    "Jane", "Doe"<br />
    …

Together the ``[Field_Names]`` and ``[Records_Array]`` tags provide a
programmatic method of accessing all the data returned by an inline
action. When used appropriately these tags can yield better performance
than using ``[Records] … [/Records]``, ``[Field]``, and ``[Field_Name]``
tags.

Records Map
^^^^^^^^^^^

The ``[Records_Map]`` tag functions similarly to the ``[Records_Array]``
tag, but returns all of the data from an inline operation as a map of
maps. The keys for the outer map are the key field values for each
record from the table. The keys for the inner map are the field names
for each record in the found set.

::

    [Inline: -Search, -Database='Contacts', -Table='People', -KeyField='ID']
        [Records_Map]
    [/Inline]

    ->
    (Map: (1)=(Map: (First)=(John), (Last)=(Doe)), (2)=(Map: (First)=(Jane), (Last)=(Doe)), …)

The output of the ``[Records_Map]`` tag can be modified with the following
parameters.

.. table:: Table 7: [Records_Map] Parameters
    
    +-----------------+--------------------------------------------------+
    |Tag              |Description                                       |
    +=================+==================================================+
    |``-KeyField``    |The name of the field to use as the key for the   |
    |                 |outer map. Defaults to the current                |
    |                 |``[KeyField_Name]``, “ID”, or the first field of  |
    |                 |the database results.                             |
    +-----------------+--------------------------------------------------+
    |``-ReturnField`` |Specifies a field name that should be included in |
    |                 |the inner map. Should be called multiple times to |
    |                 |include multiple fields. If no ``-ReturnField`` is|
    |                 |specified then all fields will be returned.       |
    +-----------------+--------------------------------------------------+
    |``-ExcludeField``|The name of a field to exclude from the inner     |
    |                 |map. If no ``-ExcludeField`` is specified then all|
    |                 |fields will be returned.                          |
    +-----------------+--------------------------------------------------+
    |``-Fields``      |An array of field names to use for the inner      |
    |                 |map. By default the value for ``[Field_Names]``   |
    |                 |will be used.                                     |
    +-----------------+--------------------------------------------------+
    |``-Type``        |By default the tag returns a map of maps. By      |
    |                 |specifying ``-Type='array'`` the tag will instead |
    |                 |return an array of maps. This can be useful when  |
    |                 |the order of records is important.                |
    +-----------------+--------------------------------------------------+

Result Sets
^^^^^^^^^^^

An inline which uses a ``-SQL`` action can return multiple result sets.
Each SQL statement within the ``-SQL`` action is separated by a
semi-colon and generates its own result set. This allows multiple SQL
statements to be issued to a data source in a single connection and for
the results of each statement to be reviewed individually.

In the following example the ``[ResultSet_Count]`` tag is used to report
the number of result sets that the inline returned. Since the ``-SQL``
parameter contains two SQL statements, two result sets are returned. The
two result sets are then looped through by passing the
``[ResultSet_Count]`` tag to the ``[Loop] … [/Loop]`` tag and passing
the ``[Loop_Count]`` as the parameter for the ``[ResultSet] …
[/ResultSet]`` tags. Finally, the ``[Records] … [/Records]`` tags are
used as normal to display the records from each result set.

::

    [Inline: -Search, -Database='Contacts', -Table='People',
        -SQL='SELECT * FROM People; SELECT * From Companies']
        [ResultSet_Count] Result Sets
        <hr />
        [Loop: ResultSet_Count]
            [ResultSet: Loop_Count]
                [Records]
                    [Field: 'Name']<br />
                [/Records]
                <hr />
            [/ResultSet]
        [/Loop]
    [/Inline]

    ->
    2 Result Sets
    <hr />
    John Doe<br />
    Jane Doe<br />
    <hr />
    LassoSoft<br />
    <hr />

All of the tags from the preceding table including ``[Records] …
[/Records]``, ``[Records_Array]``, ``[Field_Names]``, ``[Found_Count]``,
etc. can be used within the ``[ResultSet] … [/ResultSet]`` tags.

The same example can be rewritten using a named inline. An ``-InlineName``
parameter with the name ``MyResults`` is added to the opening ``[Inline]``
tag, the ``[ResultSet_Count]`` tag, and the opening ``[ResultSet]`` tag.
Now the result sets can be output from any where on the page below the
closing ``[/Inline]`` tag. The results of the following example will be
the same as those shown above.

::

    [Inline: -InlineName='MyResults', -Search, -Database='Contacts', -Table='People',
        -SQL='SELECT * FROM People; SELECT * From Companies']
    [/Inline]
    
    [ResultSet_Count: -InlineName='MyResults'] Result Sets
    <hr />
    [Loop:(ResultSet_Count: -InlineName='MyResults')]
        [ResultSet: Loop_Count, -InlineName='MyResults']
            [Records]
                [Field: 'Name']<br />
            [/Records]
            <hr />
        [/ResultSet]
    [/Loop] 

Showing Database Schema
-----------------------

The schema of a database can be inspected using the ``[Database_…]``
tags or the ``-Show`` parameter which allows information about a
database to be returned using the ``[Field_Name]`` tag. Value lists
within FileMaker Pro databases can also be accessed using the ``-Show``
parameter. This is documented fully in the :ref:`FileMaker Data Sources
<filemaker-data-sources>` chapter.

.. table:: Table 8: -Show Parameter

    +---------+--------------------------------------------------+
    |Tag      |Description                                       |
    +=========+==================================================+
    |``-Show``|Allows information about a particular database and|
    |         |table to be retrieved.                            |
    +---------+--------------------------------------------------+

The ``-Show`` parameter functions like the ``-Search`` parameter except
that no name/value parameters, sort tags, results tags, or operator tags
are required. ``-Show`` actions can be specified in ``[Inline] …
[/Inline]`` tags, HTML forms, or URLs.

.. table:: Table 9: -Show Action Requirements

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``-Show``    |The action which is to be performed. Required.    |
    +-------------+--------------------------------------------------+
    |``-Database``|The database which should be searched. Required.  |
    +-------------+--------------------------------------------------+
    |``-Table``   |The table from the specified database which should|
    |             |be searched. Required.                            |
    +-------------+--------------------------------------------------+
    |``-KeyField``|The name of the field which holds the primary key |
    |             |for the specified table. Recommended.             |
    +-------------+--------------------------------------------------+

The tags detailed in :ref:`Table 10: Schema Tags
<database-interaction-fundamentals-table-10>` allow the schema of a
database to be inspected. The``[Field_Name]`` tag must be used in
concert with a ``-Show`` action or any database action that returns
results including ``-Search``, ``-Add``, ``-Update``, ``-Random``, or
``-FindAll``. The ``[Database_Names] … [/Database_Names]`` and
``[Database_TableNames] … [/Database_TableNames]`` tags can be used on
their own.

.. _database-interaction-fundamentals-table-10:

.. table:: Table 10: Schema Tags

    +----------------------------+--------------------------------------------------+
    |Tag                         |Description                                       |
    +============================+==================================================+
    |``[Database_Names]``        |Container tag repeats for every database available|
    |                            |to the current user in Lasso. Requires internal   |
    |                            |``[Database_NameItem]`` tag to show results.      |
    +----------------------------+--------------------------------------------------+
    |``[Database_NameItem]``     |When used inside ``[Database_Names] …             |
    |                            |[/Database_Names]`` container tags returns the    |
    |                            |name of the current database.                     |
    +----------------------------+--------------------------------------------------+
    |``[Database_RealName]``     |Returns the real name of a database given an      |
    |                            |alias.                                            |
    +----------------------------+--------------------------------------------------+
    |``[Database_TableNames]``   |Container tag repeats for every table available to|
    |                            |the current user within a database. Accepts one   |
    |                            |required parameter, the name of the               |
    |                            |database. Requires internal                       |
    |                            |``[Database_TableNameItem]`` tag to show          |
    |                            |results. Synonym is ``[Database_LayoutNames]``.   |
    +----------------------------+--------------------------------------------------+
    |``[Database_TableNameItem]``|When used inside ``[Database_TableNames] …        |
    |                            |[/Database_TableNames]`` container tags returns   |
    |                            |the name of the current table. Synonym is         |
    |                            |``[Database_LayoutNameItem]``.                    |
    +----------------------------+--------------------------------------------------+
    |``[Field_Name]``            |Returns the name of a field in the current        |
    |                            |database and table. A number parameter returns the|
    |                            |name of the field in that position within the     |
    |                            |current table. Other parameters are described     |
    |                            |below. Synonym is ``[Column_Name]``.              |
    +----------------------------+--------------------------------------------------+
    |``[Field_Names]``           |Returns an array containing all the field names in|
    |                            |the current result set. This is the same data as  |
    |                            |returned by ``[Field_Name]``, but in a format more|
    |                            |suitable for iterating or other data              |
    |                            |processing. Synonym is ``[Column_Names]``.        |
    +----------------------------+--------------------------------------------------+
    |``[Required_Field]``        |Returns the name of a required field. Requires one|
    |                            |parameter which is the number of the field name to|
    |                            |return or a ``-Count`` keyword to return the total|
    |                            |number of required fields.                        |
    +----------------------------+--------------------------------------------------+
    |``[Table_RealName]``        |Returns the real name of a table given an         |
    |                            |alias. Requires a ``-Database`` parameter which   |
    |                            |specifies the database in which the table or alias|
    |                            |resides.                                          |
    +----------------------------+--------------------------------------------------+

.. Note:: See the previous :ref:`Records-Array` section for an example
    of using ``[Field_Names]``.

**To list all the databases available to the current user:**

The following example shows how to list the names of all available
databases using the ``[Database_Names] … [/Database_Names]`` and
``[Database_NameItem]`` tags. This code will list all databases
available to the current user. An ``[Inline] … [/Inline]`` with a
``-Username`` and ``-Password`` can be wrapped around this code to
display the databases availble to a given Lasso user.

::

    [Database_Names]
        <br>[Loop_Count]: [Database_NameItem]
    [/Database_Name]

    ->
    <br>1: Contacts
    <br>2: Examples
    <br>3: Site

**To list all the tables within a database:**

The following example shows how to list the names of all the tables
within a database using the ``[Database_TableNames] …
[/Database_TableNames]`` and ``[Database_TableNameItem]`` tags. The
tables within the Site database are listed. This code will list all
tables within the databases which are available to the current user. An
``[Inline] … [/Inline]`` with a ``-Username`` and ``-Password`` can be
wrapped around this code to display the tables availble to a given Lasso
user.

::

    [Database_TableNames: 'Site']
        <br>[Loop_Count]: [Database_TableNameItem]
    [/Database_TableNames]
    
    ->
    <br>1: _outgoingemail
    <br>2: _outgoingemailprefs
    <br>3: _schedule
    <br>4: _sessions

**To list all the fields within a table:**

The ``[Field_Name]`` tag accepts a number of optional parameters which
allow information about the tags in the current table to be returned.
These parameters are detailed in :ref:`Table 11: [Field_Name] Parameters
<database-interaction-fundamentals-table-11>`.

.. _database-interaction-fundamentals-table-11:

.. table:: Table 11: [Field_Name] Parameters

    +---------------+--------------------------------------------------+
    |Parameter      |Description                                       |
    +===============+==================================================+
    |``Number``     |The position of the field name to be              |
    |               |returned. Required unless ``-Count`` is specified.|
    +---------------+--------------------------------------------------+
    |``-Count``     |Returns the number of fields in the current table.|
    +---------------+--------------------------------------------------+
    |``-Type``      |Returns the type of the field rather than the     |
    |               |name. Types include ``Text``, ``Number``,         |
    |               |``Image``, ``Date/Time``, ``Boolean`` or          |
    |               |``Unknown``. Requires that a number parameter be  |
    |               |specified.                                        |
    +---------------+--------------------------------------------------+
    |``-Protection``|Returns the protection status of the field rather |
    |               |than the name. Protection statuses include        |
    |               |``None`` or ``Read Only``. Requires that a number |
    |               |parameter be specified. Requires that a number    |
    |               |parameter be specified.                           |
    +---------------+--------------------------------------------------+

**To return information about the fields in a table:**

The following example demonstrates how to return information about the
fields in a table using the ``[Inline] … [/Inline]`` tags to perform a
``-Show`` action. ``[Loop] … [/Loop]`` tags loop through the number of
fields in the table and the name, type, and protection status of each
field is returned. The fields within the Contacts Web table are shown. A
``-Username`` and ``-Password`` may be required if the database and
table are only available to certain Lasso users.

::

    [Inline: -Show,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        [Loop: (Field_Name: -Count)]
            <br>[Loop_Count]: [Field_Name: (Loop_Count)]
            ([Field_Name: (Loop_Count), -Type], [Field_Name: (Loop_Count), -Protection])
        [/Loop]
    [/Inline]
    ->
    <br>1: Creation Date (Date, None)
    <br>2: ID (Number, Read Only)
    <br>3: First_Name (Text, None)
    <br>4: Last_Name (Text, None)

**To list all the required fields within a table:**

The ``[Required_Field]`` tag accepts a number of optional parameters
which allow information about the tags in the current table to be
returned. These parameters are detailed in :ref:`Table 12:
[Required_Field] Parameters
<database-interaction-fundamentals-table-12>`.

.. _database-interaction-fundamentals-table-12:

.. table:: Table 12: [Required_Field] Parameters

    +----------+--------------------------------------------------+
    |Parameter |Description                                       |
    +==========+==================================================+
    |``Number``|The position of the field name to be              |
    |          |returned. Required unless ``-Count`` is specified.|
    +----------+--------------------------------------------------+
    |``-Count``|Returns the number of required fields in the      |
    |          |current table.                                    |
    +----------+--------------------------------------------------+

The ``[Required_Field]`` substitution tag can be used to return a list
of all required fields for the current action. A ``-Show`` action is
used to retrieve the information from the database and then ``[Loop] …
[/Loop]`` tags are used to loop through all the required fields. In the
example that follows the ``People`` table of the ``Contacts`` database
has only one required field, the primary key field ``ID``.

::

    [Inline: -Show,
        -Database='Contacts',
        -Table='People']
        [Loop: (Required_Field: -Count)]
            <br>[Required_Field: (Loop_Count)]
        [/Loop]
    [/Inline]
    ->
    <br>ID

.. _inline-hosts:

Inline Hosts
------------

Lasso provides two different methods to specify the data source which
should execute an inline database action. The connection characteristics
for the data source host can be specified entirely within the inline or
the connection characteristics can be specified within Lasso Site
Administration and then looked up based on what ``-Database`` is
specified within the inline.

Each of the methods is described in more detail below including when one
method may be preferable to the other method and drawbacks of each
method. The database method is used throughout most of the examples in
this documentation.

Database Method
^^^^^^^^^^^^^^^

When Lasso executes an inline it performs several tasks. First, if the
inline contains a ``-Username`` and ``-Password`` then they are used to
authenticate against the users which have been defined in Lasso
Security. Second, if the inline contains a ``-Database`` then it is used
to look up what host and data source should be used to service the
inline. Third, the inline action is checked against Lasso security based
on the permissions of the current user.

The permissions can depend on both the ``-Database`` and ``-Table``. The
``-Table`` is additionally used to look up what encoding should be used
for the results of the database action. Finally, the action is issued
against the specified data source for processing and the results are
returned.

If an inline does not have a specified ``-Username`` and ``-Password``
then it inherits the authentication of the surrounding inline or the
page as a whole. If an inline does not have a specified ``-Database``
then it inherits the ``-Database`` (and ``-Table`` and ``-KeyField``)
from the surrounding inline.

-  **Advantages** – When using the database method, all of the
   connection characteristics for the data source host are defined in
   Lasso Site Administration. This makes it easy to change the
   characteristics of a host, and even move databases from one host to
   another, without modifying any LassoScript code. Lasso’s built-in
   security system is used to vet all database actions before they
   occur. This ensures that security is handled within Lasso rather than
   relying on the data source host to be set up properly.
-  **Disadvantages** – Setting up a new data source when using the
   database method requires visiting Lasso Site Administration and
   configuring Lasso security. This helps promote good security
   practices, but can be an impediment when working on simple Web sites
   or when quickly mocking up solutions. In addition, having part of the
   set up for a Web site in Lasso Site Administration means that Lasso
   must be configured properly in order to deploy a solution. It is
   sometimes desirable to have all of the configuration of a solution
   contained within the code files of the solution itself.

Inline Host Method
^^^^^^^^^^^^^^^^^^

With the inline host method all of the characteristics of the data
source host which will be used to process the inline database action are
specified directly within the inline. Lasso security is not checked when
the inline host method is used.

-  **Advantages** – Data source hosts can be quickly specified directly
   within an inline. No need to visit Lasso Site Administration to set
   up a new data source host. Reduced overhead since Lasso’s security
   settings don’t need to be checked.
-  **Disadvantages** – The username and password for the host must be
   embedded within the Lasso code

Switching data source hosts can be more difficult if inline hosts have
been hard-coded. Lasso does not provide any security for what actions
can be performed on the data source. Any desired security settings must
be configured directly within the data source itself.

Inline hosts are specified using a ``-Host`` parameter within the
inline. The value for the parameter is an array that specifies the
connection characteristics for the inline host. The following example
shows an inline host for the MySQL data source connector which connects
to localhost using a username of ``Root``.

::

    Inline:
        -Host=(Array: -Datasource='mysqlds', -Name='localhost', -Username='root'),
        -SQL='SHOW DATABASES';
        Records_Array;
    /Inline;

The following table lists all of the parameters that can be specified
within the ``-Host`` array. Some data sources may required just that the
``-Datasource`` be specified, but most data sources will require
``-Datasource``, ``-Name``, ``-Username``, and ``-Password``.

The ``-Host`` parameter can also take a value of inherit which specifies
that the ``-Host`` from the surrounding inline should be used. This is
necessary when specifying a ``-Database`` within nested inlines to
prevent Lasso from looking up the database as it would using the
database method.

.. table:: Table 13: -Host Array Parameters

    +------------------+--------------------------------------------------+
    |Parameter         |Description                                       |
    +==================+==================================================+
    |``-DataSource``   |Required data source name. The name for each data |
    |                  |source can be found in Lasso Site Administration  |
    |                  |in the Setup > Data Sources > Connectors          |
    |                  |section. Required.                                |
    +------------------+--------------------------------------------------+
    |``-Name``         |The IP address, DNS host name, or connection      |
    |                  |string for the data source. Required for most data|
    |                  |source.                                           |
    +------------------+--------------------------------------------------+
    |``-Port``         |The port for the data source. Optional.           |
    +------------------+--------------------------------------------------+
    |``-Username``     |The username for the data source                  |
    |                  |connection. Required for most data sources.       |
    +------------------+--------------------------------------------------+
    |``-Password``     |The password for the username. Required if a      |
    |                  |username was specified.                           |
    +------------------+--------------------------------------------------+
    |``-Schema``       |The schema for the data source                    |
    |                  |connection. Required for some data sources .      |
    +------------------+--------------------------------------------------+
    |``-Extra``        |Configuration information which may be used by    |
    |                  |some data sources. Optional.                      |
    +------------------+--------------------------------------------------+
    |``-TableEncoding``|The table encoding for the data source            |
    |                  |connection. Defaults to UTF-8. Optional.          |
    +------------------+--------------------------------------------------+

.. Note:: The ``-Username`` and ``-Password`` specified in this
    ``-Host`` array are sent to the remote data source. They are not
    used to authenticate against Lasso security. Consult the
    documentation for each data source for details about which
    parameters are required, their format, and whether the ``-Extra``
    parameter is used.

Once a ``-Host`` array has been specified the rest of the parameters of
the inline will work much the same as they do in inlines which use a
configured data source host. The primary differences are explained here:

-  Nested inlines will inherit the ``-Host`` from the surrounding inline
   if they are specified with ``-Host='inherit'`` or if they do not
   contain a ``-Database`` parameter.
-  Nested inlines which have a ``-Database`` parameter and no ``-Host``
   parameter will use the ``-Database`` parameter to look up the data
   source host.
-  Nested inlines can specify a different ``-Host`` parameter than the
   surrounding inline. Lasso can handle arbitrarily nested inlines each
   of which use a different host.
-  The parameters ``-Database``, ``-Table``, ``-KeyField`` (or
   ``-Key``), and ``-Schema`` may be required depending on the database
   action. Inline actions such as ``-Search``, ``-FindAll``, ``-Add``,
   ``-Update``, ``-Delete``, etc. require that the database, table, and
   keyfield be specified just as they would need to be in any inline.
-  Some SQL statements may also require that a ``-Database`` be
   specified. For example, in MySQL, a host-level SQL statement like
   SHOW DATABASES doesn’t require that a ``-Database`` be specified. A
   table-level SQL statement like ``SELECT * FROM `people``` won’t work
   unless the ``-Database`` is specified in the inline. A fully
   qualified SQL statement like ``SELECT * FROM `contacts`.`people```
   will also work without a ``-Database``.

SQL Statements
--------------

Lasso provides the ability to issue SQL statements directly to
SQL-compliant data sources, including the MySQL data source. SQL
statements are specified within the ``[Inline]`` tag using the ``-SQL``
command tag. Many third-party databases that support SQL statements also
support the use of the ``-SQL`` command tag. SQL inlines can be used as
the primary method of database interaction in Lasso 8, or they can be
used along side standard inline actions (e.g. ``-Search``, ``-Add``,
``-Update``, ``-Delete``) where a specific SQL function is desired that
cannot be replicated using standard database commands.

For most data sources multiple SQL statements can be specified within
the ``-SQL`` parameter separated by a semi-colon. Lasso will issue all
of the statements to the data source at once and will collect all of the
results into result sets. The ``[ResultSet_Count]`` tag returns the
number of result sets which Lasso found. The ``[ResultSet] …
[/ResultSet]`` tag can then be used with an integer parameter to return
the results from one of the result sets.

.. Important:: Visitor supplied values must be encoded when they are
    concatenated into SQL statements. Encoding these values ensures that
    no invalid characters are passed to the data source and helps to
    prevent SQL injection attacks. The ``[Encode_SQL]`` tag should be
    used to encode values for MySQL data sources. The ``[Encode_SQL92]``
    tag should be used to encode values for other SQL-compliant data
    sources including JDBC data sources and SQLite. The ``-Search``,
    ``-Add``, ``-Update``, etc. database actions automatically perform
    encoding on values passed as name/value pairs into an inline.

.. Note:: **SQL Language** Documentation of SQL itself is outside the
    realm of this manual. Please consult the documentation included with
    your data source for information on what SQL statements are
    supported by it.

.. Note:: **FileMaker** The ``-SQL`` inline parameter is not supported
    for FileMaker data sources.

.. table:: Table 14: SQL Inline Parameters

    +----------------+--------------------------------------------------+
    |Tag             |Description                                       |
    +================+==================================================+
    |``-SQL``        |Issues one or more SQL command to a compatible    |
    |                |data source. Multiple commands are delimited by a |
    |                |semicolon. When multiple commands are used, all   |
    |                |will be executed, however only the last command   |
    |                |issued will return results to the ``[Inline] …    |
    |                |[/Inline]`` tags unless the ``[ResultSet] …       |
    |                |[/ResultSet]`` tags are used.                     |
    +----------------+--------------------------------------------------+
    |``-Database``   |A database in the data source in which to execute |
    |                |the SQL statement.                                |
    +----------------+--------------------------------------------------+
    |``-Table``      |A table in the database. The encoding specified   |
    |                |for this table in Site Administration will be used|
    |                |for the return value from the data source. Only   |
    |                |required if an encoding other than the default for|
    |                |the data source is necessary.                     |
    +----------------+--------------------------------------------------+
    |``-MaxRecords`` |The maximum number of records to return. Optional,|
    |                |defaults to ``50``.                               |
    +----------------+--------------------------------------------------+
    |``-SkipRecords``|The offset into the found set at which to start   |
    |                |returning records. Optional, defaults to ``1``.   |
    +----------------+--------------------------------------------------+

The ``-Database`` parameter can be any database within the data source
in which the SQL statement should be executed. The ``-Database``
parameter will be used to determine the data source, table references
within the statement can include both a database name and a table name,
e.g. ``Contacts.People`` in order to fetch results from multiple tables.
For example, to create a new database in MySQL, a ``CREATE DATABASE``
statement can be executed with ``-Database`` set to ``Site``.

The ``-Table`` parameter is optional. If specified, Lasso will use the
character set established for the table in Site Administration when it
interprets the data returned by the data source. If no ``-Table`` is
specified then the default character encoding will be used.

When referencing the name of a database and table in a SQL statement
(e.g. ``Contacts.People``), only the true file names of a database or
table can be used as MySQL does not recognize Lasso aliases in a SQL
command. Lasso 8 contains two SQL helper tags that return the true file
name of a SQL database or table, as shown in :ref:`Table 15: -SQL Helper
Tags <database-interaction-fundamentals-table-15>`.

.. _database-interaction-fundamentals-table-15:

.. table:: Table 15: -SQL Helper Tags

    +-----------------------+--------------------------------------------------+
    |Tag                    |Description                                       |
    +=======================+==================================================+
    |``[Database_RealName]``|Returns the actual name of a database from an     |
    |                       |alias. Useful for determining the true name of a  |
    |                       |database for use with the ``-SQL`` tag.           |
    +-----------------------+--------------------------------------------------+
    |``[Table_RealName]``   |This tag returns the actual name of a table from  |
    |                       |an alias. Useful for determining the true name of |
    |                       |a table for use with the ``-SQL`` tag.            |
    +-----------------------+--------------------------------------------------+
    |``[Encode_SQL]``       |Encodes illegal characters in MySQL string        |
    |                       |literals by escaping them with a backslash. Helps |
    |                       |to prevent SQL injection attacks and ensures that |
    |                       |SQL statements only contain valid characters. This|
    |                       |tag must be used to encode visitorsupplied values |
    |                       |within SQL statements for MySQL data sources.     |
    +-----------------------+--------------------------------------------------+
    |``[Encode_SQL92]``     |Encodes illegal characters in SQL string literals |
    |                       |by escaping them with a backslash. Helps to       |
    |                       |prevent SQL injection attacks and ensures that SQL|
    |                       |statements only contain valid characters. This tag|
    |                       |can be used to encode values for JDBC and most    |
    |                       |other SQL-compliant data sources.                 |
    +-----------------------+--------------------------------------------------+

**To determine the true database and table name for a SQL statement:**

Use the ``[Database_RealName]`` and ``[Table_RealName]`` tags. When
using the ``-SQL`` tag to issue SQL statements to a MySQL host, only
true database and tables may be used (bypassing the alias). The
``[Database_RealName]`` and ``[Table_RealName]`` tags can be used to
automatically determine the true name of a database and table, allowing
them to be used in a valid SQL statement.

::

    [Var_Set:'Real_DB' = (Database_RealName:'Contacts_Alias')]
    [Var_Set:'Real_TB' = (Table_RealName:'Contacts_Alias')]
    [Inline: -Database ='Contacts_Alias', -SQL='select * from ((Var:'Real_DB') + '.' + (Var:'Real_TB'))']

Results from a SQL statement are returned in a record set within the
``[Inline] … [/Inline]`` tags. The results can be read and displayed
using the ``[Records] … [/Records]`` container tags and the ``[Field]``
substitution tag. However, many SQL statements return a synthetic record
set that does not correspond to the names of the fields of the table
being operated upon. This is demonstrated in the examples that follow.

**To issue a SQL statement:**

Specify the SQL statement within ``[Inline] … [/Inline]`` tags in a
``-SQL`` command tag.

-  The following example calculates the results of a mathematical
   expression ``1 + 2`` and returns the value as a ``[Field]`` value
   named ``Result``. Note that even though this SQL statement does not
   reference a database, a ``-Database`` tag is still required so Lasso
   knows to which data source to send the statement.

   ::

       [Inline: -Database='Example', -SQL='SELECT 1+2 AS Result']
           <br>The result is: [Field: 'Result'].
       [/Inline]

       ->
       <br>The result is 3.

-  The following example calculates the results of several mathematical
   expressions and returns them as field values ``One``, ``Two``, and
   ``Three``.

   ::

       [Inline: -Database='Example',
            -SQL='SELECT 1+2 AS One, sin(.5) AS Two, 5%2 AS Three']
           <br>The results are: [Field: 'One'], [Field: 'Two'], and [Field: 'Three'].
       [/Inline]

       ->
       The results are 3, 0.579426, and 1.

-  The following example calculates the results of several mathematical
   expressions using Lasso and returns them as field values ``One``,
   ``Two``, and ``Three``. It demonstrate how the results of Lasso
   expressions and substitution tags can be used in a SQL statement.

   ::

       [Inline: -Database='Example',
            -SQL='SELECT ' + (1+2) + ' AS One, ' + (Math_Sin: .5) +
                ' AS Two, ' + (Math_Mod: 5, 2) + ' AS Three']
       <br>The results are: [Field: 'One'], [Field: 'Two'], and [Field: 'Three'].
       [/Inline]
       -> <br>The results are 3, 0.579426, and 1.

-  The following example returns records from the ``Phone_Book`` table
   where ``First_Name`` is equal to ``John``. This is equivalent to a
   ``-Search`` using Lasso.

   ::

       [Inline: -Database='Example',
           -SQL='SELECT * FROM Phone_Book WHERE First_Name = \'John\'']
           [Records]
               <br>[Field: 'First_Name'] [Field: 'Last_Name']
           [/Records]
       [/Inline]

       ->
       <br>John Doe
       <br>John Person

**To encode visitor supplied values in a SQL statement:**

All visitor supplied values must be encoded before they are concatenated
into a SQL statement in order to ensure the validity of the SQL
statement and to prevent SQL injection. Values from the
``[Action_Param]``, ``[Cookie]``, ``[Field]``, and ``[Token_Value]``
tags should be encoded as well as values from any calculations which
rely on these tags. The ``[Encode_SQL]`` tag should be used to encode
values within SQL statements for MySQL data sources. The
``[Encode_SQL92]`` tag should be used to encode values for other
SQL-compliant data sources including JDBC data sources and SQLite.

-  The following example encodes the action parameter for ``First_Name``
   using ``[Encode_SQL]`` for a MySQL data source.

   ::

       [Inline: -Database='Example',
           -SQL='SELECT * FROM Phone_Book WHERE First_Name = \'' + (Encode_SQL: (Action_Param: 'First_Name')) + '\'']
       …
       [/Inline]

-  The following example encodes the action parameter for ``First_Name``
   using ``[Encode_SQL92]`` for a SQLite (or other SQL-compliant) data
   source.

   ::

       [Inline: -Database='Example',
           -SQL='SELECT * FROM Phone_Book WHERE First_Name = \'' + (Encode_SQL92: (Action_Param: 'First_Name')) + '\'']
           …
       [/Inline]

If a value is known to be a number then the ``[Integer]`` or
``[Decimal]`` tags can be used to cast the value to the appropriate data
type instead of using an encoding tag. Also, date values which are
formatted using ``[Date_Format]`` or ``[Date->Format]`` do not generally
need to be encoded since they have been parsed and reformatted into a
known valid format.

**To issue a SQL statement with multiple commands:**

Specify the SQL statements within ``[Inline] … [/Inline]`` tags in a
``-SQL`` command tag, with each SQL command separated by a semi-colon.
The following example adds three unique records to the ``Contacts``
database. Note that all single quotes within the SQL statement have been
properly escaped using the ``\`` character, as described at the
beginning of this chapter.

::

    [Inline: -Database='Contacts',
        -SQL='INSERT INTO Contacts.People (First_Name, Last_Name) VALUES (\'John\', \'Jakob\');
            INSERT INTO Contacts.People (First_Name, Last_Name) VALUES (\'Tom\', \'Smith\');
            INSERT INTO Contacts.People (First_Name, Last_Name) VALUES (\'Sally\', \'Brown\')']
    [/Inline]

**To automatically format the results of a SQL statement:**

Use the ``[Field_Name]`` tag and ``[Loop] … [/Loop]`` tags to create an
HTML table that automatically formats the results of a ``-SQL`` command.
The ``-MaxRecords`` tag should be set to All so all records are returned
rather than the default (50).

The following example shows a ``REPAIR TABLE Contacts.People`` SQL
statement being issued to a MySQL database, and the result is
automatically formatted. The statement returns a synthetic record set
which shows the results of the repair.

Notice that the database ``Contacts`` is specified explicitly within the
SQL statement. Even though the database is identified in the
``-Database`` command tag within the ``[Inline]`` tag it still must be
explicitly specified in each table reference within the SQL statement.

::

    [Inline: -Database='Contacts',
        -SQL='REPAIR TABLE Contacts.People',
        -MaxRecords='All']
        <table border="1">
            <tr>
            [Loop: (Field_Name: -Count)]
                <td><b>[Field_Name: (Loop_Count)]</b></td>
            [/Loop]
            </tr>
            [Records]
                <tr>
                [Loop: (Field_Name: -Count)]
                    <td>[Field: (Field_Name: Loop_Count)]</td>
                [/Loop]
                </tr>
            [/Records]
        </table>
    [/Inline]

The results are returned in a table with bold column headings. The
following results show that the table did not require any repairs. If
repairs are performed then many records will be returned.

::

    ->
    Table   Op       Msg_Type     Msg_Text
    People  Check    Status       OK

.. _SQL-Transactions:

SQL Transactions
----------------

Lasso supports the ability to perform reversible SQL transactions
provided that the data source used (e.g. MySQL 4.x) supports this
functionality. See your data source documentation to see if transactions
are supported.

.. Note:: **FileMaker** SQL transactions are not supported for FileMaker
    Pro data sources.

SQL transactions can be achieved within nested ``[Inline] … [/Inline]``
tags. A single connection to MySQL or JDBC data sources will be held
open from the opening ``[Inline]`` tag to the closing ``[/Inline]`` tag.
Any nested inlines that use the same data source will make use of the
same connection.

.. Note:: When using named inlines, the connection is not available in
    subsequent ``[Records: -InlineName='Name'] … [/Records]`` tags.

**To open a transaction and commit or rollback in MySQL:**

Use nested ``-SQL`` inlines, where the outer inline performs a transaction,
and the inner inline commits or rolls back the transaction depending on
the results of a conditional statement.

::

    [Inline: -Database='Contacts', -SQL='START TRANSACTION;
        INSERT INTO Contacts.People (Title, Company) VALUES (\'Mr.\', \'LassoSoft\');']
        [If: (Error_CurrentError) != (Error_NoError)]
            [Inline: -Database='Contacts', -SQL='ROLLBACK;']
            [/Inline]
        [Else]
            [Inline: -Database='Contacts', -SQL='COMMIT;']
            [/Inline]
        [/If]
    [/Inline]

**To fetch the last inserted ID in MySQL:**

Use nested ``-SQL`` inlines, where the outer inline performs an insert
query, and the inner inline retrieves the ID of the last inserted record
using the MySQL ``last_insert_id()`` function. Because the two inlines
share the same connection, the inner inline will always return the value
added by the outer inline.

::

    [Inline: -Database='Contacts',
        -SQL='INSERT INTO People (Title, Company) VALUES (\'Mr.\', \'LassoSoft\');']
        [Inline: -SQL='SELECT last_insert_id()']
            [Field: 'last_insert_id()']
        [/Inline]
    [/Inline]
    ->
    23

Prepared Statements
^^^^^^^^^^^^^^^^^^^

Lasso supports the ability to use prepared statements to speed up
database operations provided that the data source used (e.g. MySQL 4.x)
supports this functionality. See your data source documentation to see
if prepared statements are supported.

A prepared statement can speed up database operations by cutting down on
the amount of overhead which the data source needs to perform for each
statement. For example, processing the following ``INSERT`` statement
requires the data source to load the people table, determine its primary
key, load information about its indexes, and determine default values
for fields not listed. After the new record is inserted the indexes must
be updated. If another ``INSERT`` is performed then all of these steps
are repeated from scratch.

::

    INSERT INTO people (`first name`, `last name`) VALUES ("John", "Doe");

When this statement is changed into a prepared statement then the data
source knows to expect multiple executions of the statement. The data
source can cache information about the table in memory and re-use that
information for each execution. The data source might also be able to
defer some operations such as finalizing index updates until after
several statements have been executed.

The specific details of how prepared statements are treated are data
source independent. The savings in overhead and increase in speed may
vary depending on what type of SQL statement is being issues, the size
of the table and indexes that are being used, and other factors.

The statement above can be rewritten as a prepared statement by
replacing the values with question marks. The name of the table and
field list are defined just as they were in the original SQL statement.
This statement is a template into which particular values will be placed
before the data source executes it.

::

    INSERT INTO people (`first name`, `last name`) VALUES (?, ?)

The particular values are specified as an array. Each element of the
array corresponds with one question mark from the prepared statement. To
insert John Doe into the People table the following array would be used.

::

    (Array: "John", "Doe") 

Two new database actions are used to prepare statement and execute them.
``-Prepare`` is similar to ``-SQL``, but informs Lasso that you want to
create a prepared statement. Nested inlines are then issues with an
``-Exec`` action that gives the array of values which should be plugged
into the prepared statement.

.. table::  Table 16: Prepared Statements

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``-Prepare`` |Prepares a SQL statement for multiple             |
    |             |executions. The statement should contain question |
    |             |marks in place of values that will be substitued  |
    |             |in by the ``-Exec`` arrays.                       |
    +-------------+--------------------------------------------------+
    |``-Exec``    |Executes a prepared statement with specific values|
    |             |specified as an array. Multiple inlines with      |
    |             |``-Exec`` statements should be specified          |
    |             |immediately within the inline with the            |
    |             |``-Prepare`` action.                              |
    +-------------+--------------------------------------------------+
    |``-Database``|A database in the data source in which to prepare |
    |             |the SQL statement. Required only for the          |
    |             |``-Prepare`` action.                              |
    +-------------+--------------------------------------------------+

The prepared statement and values shown above would be issued by the
following inlines. The outer inline prepares the statement and the inner
inline executes it with specific values. Note that the inner inline does
not contain any ``-Database`` or ``-Table`` parameters. These are
inherited from the outer inline so don’t need to be specified again.

::

    Inline: -Database='Contacts', -Table='People', -Prepare='INSERT INTO people (`first name`, `last name`) VALUES (?, ?)';
        Inline: -Exec=(Array: "John", "Doe");
        /Inline;
    /Inline;

If the executed statement returns any values then those results can be
inspected within the inner inline. The inline with the ``-Prepare``
action will never return any results itself, but each inline with an
``-Exec`` result may return a result as if the full equivalent SQL
statement were issued in that inline.
