.. _searching-displaying:

.. direct from book

*****************************
Searching and Displaying Data
*****************************

This chapter documents the Lasso command tags which search for records
and data within Lasso compatible databases and display the results.

-  **Overview** provides an introduction to the database actions
   described in this chapter and presents important security
   considerations.
-  **Searching Records** includes instructions for searching records
   within a database.
-  **Displaying Data** describes the tags that can be used to display
   data that result from database searches.
-  **Linking to Data** includes requirements and instructions for
   navigating through found sets and linking to particular records
   within a database.

Overview
--------

Lasso provides command tags for searching records within Lasso
compatible databases. These command tags are used in conjunction with
additional command tags and name/value parameters in order to perform
the desired database action in a specific database and table or within a
specific record.

The command tags documented in this chapter are listed in :ref:`Table 1:
Command Tags <searching-and-displaying-data-table-1>`. The sections that
follow describe the additional command tags and name/value parameters
required for each database action.

.. _searching-and-displaying-data-table-1:

.. table:: Table 1: Command Tags

    +------------+--------------------------------------------------+
    |Tag         |Description                                       |
    +============+==================================================+
    |``-Search`` |Searches for records within a database.           |
    +------------+--------------------------------------------------+
    |``-FindAll``|Finds all records within a database.              |
    +------------+--------------------------------------------------+
    |``-Random`` |Returns a random record from a database. Only     |
    |            |works with FileMaker Pro databases.               |
    +------------+--------------------------------------------------+

How Searches are Performed
^^^^^^^^^^^^^^^^^^^^^^^^^^

This section describes the steps that take place each time a search is
performed using Lasso.

#.  Lasso checks the database, table, and field name specified in the
    search to ensure that they are all valid.

    .. Note:: If an inline host is specified with a ``-Host`` array then
       step 2 is skipped since Lasso security is bypassed.

#.  Lasso security is checked to ensure that the current user has
    permission to perform a search in the desired database, table, and
    field. Filters are applied to the search criteria if they are
    defined within Lasso Administration.
#.  The search query is formatted and sent to the database application.
    FileMaker Pro search queries are formatted as URLs and submitted to
    the Web Companion. MySQL search queries are formatted as SQL
    statements and submitted directly to MySQL.
#.  The database application performs the desired search and assembles
    a found set. The database application is responsible for
    interpreting search criteria, wild cards in search strings, field
    operators, and logical operators.
#.  The database application sorts the found set based on sort criteria
    included in the search query. The database application is
    responsible for determining the order of records returned to Lasso.
#.  A subset of the found set is sent to Lasso as the result set. Only
    the number of records specified by ``-MaxRecords`` starting at the
    offset specified by ``-SkipRecords`` are returned to Lasso. If any
    ``-ReturnField`` command tags are included in a search then only
    those fields named by the ``-ReturnField`` command tags are returned
    to Lasso.
#.  The result set can be displayed and manipulated using Lasso tags
    that return information about the result set and Lasso tags that
    return fields or other values.

Character Encoding
^^^^^^^^^^^^^^^^^^

Lasso stores and retrieves data from data sources based on the
preferences established in the **Setup > Data Sources** section of Lasso
Administration. The following rules apply for each standard data source.

**Inline Host** – The character encoding can be specified explicitly
using a ``-TableEncoding`` parameter within the ``-Host`` array.

**MySQL** – By default all communication is in the Latin-1 (ISO 8859-1)
character set. This is to preserve backwards compatibility with prior
versions of Lasso. The character set can be changed to the Unicode
standard UTF-8 character set in the **Setup > Data Sources > Tables**
section of Lasso Administration.

**FileMaker Pro** – By default all communication is in the MacRoman
character set when Lasso Professional is hosted on Mac OS X or in the
Latin-1 (ISO 8859-1) character set when Lasso Professional is hosted on
Windows. The preference in the **Setup > Data Sources > Databases**
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
This code should be placed in a Lasso page which is a response to a
database action or within a pair of ``[Inline] … [/Inline]`` tags.

::

    [Error_CurrentError: -ErrorCode]: [Error_CurrentError]

If the database action was performed successfully then the following
result will be returned.

::

    ->
    0: No Error

**To check for a specific error code and message:**

The following example shows how to perform code to correct or report a
specific error if one occurs. The following example uses a conditional
``[If] … [/If]`` tag to check the current error message and see if it is
equal to ``[Error_NoRecordsFound]``.

::

    [If: (Error_CurrentError) == (Error_NoRecordsFound)]
        No records were found!
    [/If] 

Full documentation about error tags and error codes can be found in the
:ref:`Error Control<error-control>` chapter. A list of all Lasso error codes and
messages can be found in :ref:`Appendix B: Error Codes<appendix-b:-error-codes>`.

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

See the :ref:`Database Interaction Fundamentals<database-interaction-fundamentals>` chapter in this guide
and the **Setting Site Preferences** chapter in the **Lasso Professional
8 Setup Guide** for more information.

.. Note:: The use of Classic Lasso has been deprecated. All solutions
    should be transitioned over to the ``[Inline] … [/Inline]`` tag
    based methods described in this chapter.

Security
^^^^^^^^

Lasso has a robust internal security system that can be used to restrict
access to database actions or to allow only specific users to perform
database actions. If a database action is attempted when the current
visitor has insufficient permissions then they will be prompted for a
username and password. An error will be returned if the visitor does not
enter a valid username and password.

.. Note:: If an inline host is specified with a ``-Host`` array then
    Lasso security is bypassed.

An ``[Inline] … [/Inline]`` can be specified to execute with the
permissions of a specific user by specifying ``-Username`` and
``-Password`` command tags within the ``[Inline]`` tag. This allows the
database action to be performed even though the current site visitor
does not necessarily have permissions to perform the database action. In
essence, a valid username and password are embedded into the Lasso page.

.. table:: Table 2: Security Command Tags

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``-Username``|Specifies the username from Lasso Security which  |
    |             |should be used to execute the database action.    |
    +-------------+--------------------------------------------------+
    |``-Password``|Specifies the password which corresponds to the   |
    |             |username.                                         |
    +-------------+--------------------------------------------------+

**To specify a username and password in an [Inline]:**

The following example shows a ``-FindAll`` action performed within an
``[Inline]`` tag using the permissions granted for username
``SiteAdmin`` with password ``Secret``.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -Username='SiteAdmin',
        -Password='Secret']
        [Error_CurrentError: -ErrorCode]: [Error_CurrentError]
    [/Inline]

A specified username and password is only valid for the ``[Inline] …
[/Inline]`` tags in which it is specified. It is not valid within any
nested ``[Inline] … [/Inline]`` tags. See the **Setting Up Security**
chapter of the **Lasso Professional 8 Setup Guide** for additional
important information regarding embedding usernames and passwords into
``[Inline]`` tags.

Searching Records
-----------------

Searches can be performed within any Lasso compatible database using the
``-Search`` command tag. The ``-Search`` command tag is specified within
``[Inline] … [/Inline]`` tags. The ``-Search`` command tag requires that
a number of additional command tags be defined in order to perform the
search. The required command tags are detailed in
:ref:`Table 3: -Search Action Requirements
<searching-and-displaying-data-table-3>`.

.. Note:: If Classic Lasso syntax is enabled then the ``-Search``
    command tag can also be used within HTML forms or URLs. The use of
    Classic Lasso syntax has been deprecated so solutions which rely on
    it should be updated to use the inline methods described in this
    chapter.

Additional command tags are described in :ref:`Table 4: Operator Command
Tags <searching-and-displaying-data-table-4>` and :ref:`Table 6: Results
Command Tags <searching-and-displaying-data-table-6>` in the sections
that follow.

.. _searching-and-displaying-data-table-3:

.. table:: Table 3: -Search Action Requirements

    +-------------------------+--------------------------------------------------+
    |Tag                      |Description                                       |
    +=========================+==================================================+
    |``-Search``              |The action which is to be performed. Required.    |
    +-------------------------+--------------------------------------------------+
    |``-Database``            |The database which should be searched. Required.  |
    +-------------------------+--------------------------------------------------+
    |``-Table``               |The table from the specified database which should|
    |                         |be searched. Required.                            |
    +-------------------------+--------------------------------------------------+
    |``-KeyField``            |The name of the field which holds the primary key |
    |                         |for the specified table. Recommended.             |
    +-------------------------+--------------------------------------------------+
    |``-KeyValue``            |The particular value for the primary key of the   |
    |                         |record which should be returned. Using            |
    |                         |``-KeyValue`` overrides all the other search      |
    |                         |parameters and returns the single record          |
    |                         |specified. Optional.                              |
    +-------------------------+--------------------------------------------------+
    |``Name/Value Parameters``|A variable number of name/value parameters specify|
    |                         |the query which will be performed.                |
    +-------------------------+--------------------------------------------------+
    |``-Host``                |Optional inline host array. See the section on    |
    |                         |:ref:`Inline Hosts in the Database Interaction    |
    |                         |Fundamentals<inline-hosts>` chapter for more      |
    |                         |information.                                      |
    +-------------------------+--------------------------------------------------+

Any name/value parameters included in the search action will be used to
define the query that is performed in the specified table. All
name/value parameters must reference a field within the database. Any
fields which are not referenced will be ignored for the purposes of the
search.

**To search a database using ``[Inline] … [/Inline]`` tags:**

The following example shows how to search a database by specifying the
required command tags within an opening ``[Inline]`` tag. ``-Database``
is set to ``Contacts``, ``-Table`` is set to ``People``, and
``-KeyField`` is set to ``ID``. The search returns records which contain
``John`` with the field ``First_Name``.

The results of the search are displayed to the visitor inside the
``[Inline] … [/Inline]`` tags. The tags inside the ``[Records] …
[/Records]`` tags will repeat for each record in the found set. The
``[Field]`` tags will display the value for the specified field from the
current record being shown.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='John']

        [Records]
            <br>
            [Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]

    [/Inline]

If the search was successful then the following results will be
returned.

::
     
    ->
    <br>John Person
    <br>John Doe

Additional name/value parameters and command tags can be used to
generate more complex searches. These techniques are documented in the
following section on :ref:`Operators`.

**To search a database using visitor-defined values:**

The following example shows how to search a database by specifying the
required command tags within an opening ``[Inline]`` tag, but allow a
site visitor to specify the search criteria in an HTML form. The visitor
is presented with an HTML form in the Lasso page ``default.lasso`` . The
HTML form contains two text inputs for ``First_Name`` and ``Last_Name``
and a submit button. The action of the form is the response page
``response.lasso`` which contains the ``[Inline] … [/Inline]`` tags that
will perform the search. The contents of the ``default.lasso`` file
include the following.

::

    <form action="response.lasso" method="POST">
        <br>First Name: <input type="text" name="First_Name" value="">
        <br>Last Name: <input type="text" name="Last_Name" value="">
        <br><input type="submit" name="-Nothing" value="Search Database">
    </form>

The search is performed and the results of the search are displayed to
the visitor inside the ``[Inline] … [/Inline]`` tags in
``response.lasso``. The values entered by the visitor in the HTML form
in ``default.lasso`` are inserted into the ``[Inline]`` tag using the
``[Action_Param]`` tag. The tags inside the ``[Records] … [/Records]``
tags will repeat for each record in the found set. The ``[Field]`` tags
will display the value for the specified field from the current record
being shown. The contents of the ``response.lasso`` file include the
following.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'=(Action_Param: 'First_Name'),
        'Last_Name'=(Action_Param: 'Last_Name')]
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

If the visitor entered ``John`` for ``First_Name`` and ``Person`` for
``Last_Name`` then the following result would be returned.

::

    ->
    <br>John Person

.. _operators:

Operators
^^^^^^^^^

Lasso includes a set of command tags that allow operators to be used to
create complex database queries. These command tags are summarized in
:ref:`Table 4: Operator Command Tags
<searching-and-displaying-data-table-4>`.

.. _searching-and-displaying-data-table-4:

.. table:: Table 4: Operator Command Tags

    +--------------------+--------------------------------------------------+
    |Tag                 |Description                                       |
    +====================+==================================================+
    |``-OperatorLogical``|Specifies the logical operator for the            |
    |                    |search. Abbreviation is ``-OpLogical``. Defaults  |
    |                    |to ``and``.                                       |
    +--------------------+--------------------------------------------------+
    |``-Operator``       |When specified before a name/value parameter,     |
    |                    |establishes the search operator for that          |
    |                    |name/value parameter. Abbreviation is             |
    |                    |``-Op``. Defaults to ``bw``. See below for a full |
    |                    |list of field operators. Operators can also be    |
    |                    |written as ``-BW``, ``-EW``, ``-CN``, etc.        |
    +--------------------+--------------------------------------------------+
    |``-OperatorBegin``  |Specifies the logical operator for all search     |
    |                    |parameters until ``-OperatorEnd`` is              |
    |                    |reached. Abbreviation is ``-OpBegin``.            |
    +--------------------+--------------------------------------------------+
    |``-OperatorEnd``    |Specifies the end of a logical operator grouping  |
    |                    |started with ``-OperatorBegin``. Abbreviation is  |
    |                    |``-OpEnd``.                                       |
    +--------------------+--------------------------------------------------+

The operator command tags are divided into two categories.

-  **Field Operators** are specified using the ``-Operator`` command tag
   before a name/value parameter. The field operator changes the way
   that the named field is searched for the value. If no field operator
   is specified then the default begins with bw operator is used. See
   :ref:`Table 5: Field Operators
   <searching-and-displaying-data-table-5>` for a list of the possible
   values for   this tag. Field operators can also be abbreviated as
   ``-BW``, ``-EW``, ``-CN``, etc.
-  Logical Operators are specified using the ``-OperatorLogical``,
   ``-OperatorBegin``, and ``-OperatorEnd`` tags. These tags specify how
   the results of different name/value parameters are combined to form
   the full results of the search.

Field Operators
^^^^^^^^^^^^^^^

The possible values for the ``-Operator`` command tag are listed in
:ref:`Table 5: Field Operators <searching-and-displaying-data-table-5>`.
The default operator is begins with ``bw``. Case is unimportant when
specifying operators.

Field operators are interpreted differently depending on which data
source is being accessed. For example, FileMaker Pro interprets ``bw``
to mean that any word within a field can begin with the value specified
for that field. MySQL interprets ``bw`` to mean that the first word
within the field must begin with the value specified. See the chapters
on each data source or the documentation that came with a third-party
data source connector for more information.

Several of the field operators are only supported in MySQL or other SQL
databases. These include the ``ft`` full text operator and the ``rx``
and ``nrx`` regular expression operators.

.. _searching-and-displaying-data-table-5:

.. table:: Table 5: Field

    +-------------------------+--------------------------------------------------+
    |Operators                |Description                                       |
    +=========================+==================================================+
    |``-Op='bw'`` or ``-BW``  |Begins With. Default if no operator is set.       |
    +-------------------------+--------------------------------------------------+
    |``-Op='cn'`` or ``-CN``  |Contains.                                         |
    +-------------------------+--------------------------------------------------+
    |``-Op='ew'`` or ``-EW``  |Ends With.                                        |
    +-------------------------+--------------------------------------------------+
    |``-Op='eq'`` or ``-EQ``  |Equals.                                           |
    +-------------------------+--------------------------------------------------+
    |``-Op='ft'or -FT``       |Full Text. MySQL databases only.                  |
    +-------------------------+--------------------------------------------------+
    |``-Op='gt'`` or ``-GT``  |Greater Than.                                     |
    +-------------------------+--------------------------------------------------+
    |``-Op='gte'`` or ``-GTE``|Greater Than or Equals.                           |
    +-------------------------+--------------------------------------------------+
    |``-Op='lt'`` or ``-LT``  |Less Than.                                        |
    +-------------------------+--------------------------------------------------+
    |``-Op='lte'`` or ``-LTE``|Less Than or Equals.                              |
    +-------------------------+--------------------------------------------------+
    |``-Op='neq'`` or ``-NEQ``|Not Equals.                                       |
    +-------------------------+--------------------------------------------------+
    |``-Op='rx'`` or ``-RX``  |RegExp. Regular expression search. SQL databases  |
    |                         |only.                                             |
    +-------------------------+--------------------------------------------------+
    |``-Op='nrx'`` or ``-NRX``|Not RegExp. Opposite of RegExp. SQL databases     |
    |                         |only.                                             |
    +-------------------------+--------------------------------------------------+

.. Note:: In previous versions of Lasso the field operators could be
    specified using either a short form, e.g. ``bw`` or a long form,
    e.g. ``Begins With``. In Lasso Professional 8 only the short form is
    preferred. Use of the long form is deprecated. It is supported in
    this version, but may not work in future versions of Lasso
    Professional.

**To specify a field operator in an [Inline] tag:**

Specify the field operator before the name/value parameter which it will
affect. The following ``[Inline] … [/Inline]`` tags search for records
where the ``First_Name`` begins with ``J`` and the ``Last_Name`` ends
with ``son``.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -Operator='bw', 'First_Name'='J',
        -Operator='ew', 'Last_Name'='son']
        [Records]
            <br>
            [Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

The results of the search would include the following records.

::

    ->
    <br>John Person
    <br>Jane Person

Logical Operators
^^^^^^^^^^^^^^^^^

The logical operator command tag ``-OperatorLogical`` can be used with a
value of either ``AND`` or ``OR``. The command tags ``-OperatorBegin``, and
``-OperatorEnd`` can be used with values of ``AND``, ``OR``, or ``NOT``.
``-OperatorLogical`` applies to all search parameters specified with
an action . ``-OperatorBegin`` applies to all search parameters until
the matching ``-OperatorEnd`` tag is reached. The case of the value is
unimportant when specifying a logical operator.

-   ``AND`` specifies that records which are returned should fulfil all
    of the search parameters listed.
-   ``OR`` specifies that records which are returned should fulfil one
    or more of the search parameters listed.
-   ``NOT`` specifies that records which match the search criteria
    contained between the ``-OperatorBegin`` and ``-OperatorEnd`` tags
    should be omitted from the found set. ``NOT`` cannot be used with
    the ``-OperatorLogical`` tag.

.. Note:: In lieu of a ``NOT`` option for ``-OperatorLogical``, many
    field operators can be negated individually by substituting the
    opposite field operator. The following pairs of field operators are
    the opposites of each other: ``eq`` and ``neq``, ``lt`` and ``gte``,
    and ``gt`` and ``lte``.

.. Note:: **FileMaker** - The ``-OperatorBegin`` and `` -OperatorEnd``
    tags do not work with Lasso Connector for FileMaker Pro.

**To perform a search using an ``AND`` operator:**

Use the ``-OperatorLogical`` command tag with an ``AND`` value. The
following ``[Inline] … [/Inline]`` tags return records for which the
``First_Name`` field begins with ``John`` and the ``Last_Name`` field
begins with ``Doe``. The position of the ``-OperatorLogical`` command
tag within the ``[Inline]`` tag is unimportant since it applies to the
entire action.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -OperatorLogical='AND',
        'First_Name'='John',
        'Last_Name'='Doe']
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

**To perform a search using an ``OR`` operator:**

Use the ``-OperatorLogical`` command tag with an ``OR`` value. The
following ``[Inline] … [/Inline]`` tags return records for which the
``First_Name`` field begins with either ``John`` or ``Jane``. The
position of the ``-OperatorLogical`` command tag within the ``[Inline]``
tag is unimportant since it applies to the entire action.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -OperatorLogical='OR',
        'First_Name'='John',
        'First_Name'='Jane']
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

**To perform a search using a ``NOT`` operator:**

Use the ``-OperatorBegin`` and ``-OperatorEnd`` command tags with a
``NOT`` value. The following ``[Inline] … [/Inline]`` tags return
records for which the ``First_Name`` field begins with ``John`` and the
``Last_Name`` field is not ``Doe``. The operators tags must surround the
parameters of the search which are to be negated.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='John',
        -OperatorBegin='NOT',
        'Last_Name'='Doe',
        -OperatorEnd='NOT']
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

**To perform a search with a complex query:**

Use the ``-OperatorBegin`` and ``-OperatorEnd`` tags to build up a
complex query. As an example, a query can be constructed to find records
in a database whose ``First_Name`` and ``Last_Name`` both begin with the
same letter ``J`` or ``M``. The desired query could be written in
pseudo-code as follows.

::

    ( (First_Name begins with J) AND (Last_Name begins with J) ) OR
    ( (First_Name begins with M) AND (Last_Name begins with M) )

The pseudo code is translated into a URL as follows. Each line of the
query becomes a pair of ``-OpBegin=AND`` and ``-OpEnd=AND`` tags with a
name/value parameter for ``First_Name`` and ``Last_Name`` contained
inside. The two lines are then combined using a pair of ``-OpBegin=OR``
and ``-OpEnd=OR`` tags. The nesting of the command tags works like the
nesting of parentheses in the pseudo code above to clarify how Lasso
should combine the results of different ``name/value parameters``.

::

    <a href="/response.lasso?-Search&
        -Database=Contacts&
        -Table=People&
        -KeyField=ID&
        -OpBegin=OR&
            -OpBegin=AND&
                First_Name=J&
                Last_Name=J&
            -OpEnd=AND&
            -OpBegin=AND&
                First_Name=M&
                Last_Name=M&
            -OpEnd=AND&
        -OpEnd=OR">
        First Name and Last Name both begin with J or M
    </a>

The following results might be returned when this link is selected.

::

    ->
    <br>Johnny Johnson
    <br>Jimmy James
    <br>Mark McPerson

Results
^^^^^^^

Lasso includes a set of command tags that allow the results of a search
to be customized. These command tags do not change the found set of
records that are returned from the search, but they do change the data
that is returned to Lasso for formatting and display to the visitor. The
results command tags are summarized in :ref:`Table 6: Results Command
Tags <searching-and-displaying-data-table-6>`.

.. _searching-and-displaying-data-table-6:

.. table:: Table 6: Results Command Tags

    +-----------------+--------------------------------------------------+
    |Tag              |Description                                       |
    +=================+==================================================+
    |``-Distinct``    |Specifies that only records with distinct values  |
    |                 |in all returned fields should be returned. MySQL  |
    |                 |databases only.                                   |
    +-----------------+--------------------------------------------------+
    |``-MaxRecords``  |Specifies how many records should be shown from   |
    |                 |the found set. Optional, defaults to ``50``.      |
    +-----------------+--------------------------------------------------+
    |``-SkipRecords`` |Specifies an offset into the found set at which   |
    |                 |records should start being shown. Optional,       |
    |                 |defaults to ``1``.                                |
    +-----------------+--------------------------------------------------+
    |``-ReturnField`` |Specifies a field that should be returned in the  |
    |                 |results of the search. Multiple ``-ReturnField``  |
    |                 |tags can be used to return multiple               |
    |                 |fields. Optional, defaults to returning all fields|
    |                 |in the searched table.                            |
    +-----------------+--------------------------------------------------+
    |``-SortField``   |Specifies that the results should be sorted based |
    |                 |on the data in the named field. Multiple          |
    |                 |``-SortField`` tags can be used for complex       |
    |                 |sorts. Optional, defaults to returning data in the|
    |                 |order it appears in the database.                 |
    +-----------------+--------------------------------------------------+
    |``-SortOrder``   |When specified after a ``-SortField`` parameter,  |
    |                 |specifies the order of the sort, either           |
    |                 |``ascending``, ``descending`` or custom. Optional,|
    |                 |defaults to ``ascending`` for each ``-SortField``.|
    +-----------------+--------------------------------------------------+
    |``-SortRandom``  |Sorts the returned results randomly. MySQL        |
    |                 |databases only.                                   |
    +-----------------+--------------------------------------------------+
    |``-UseLimit``    |Specifies that a MySQL ``LIMIT`` should be used   |
    |                 |instead of Lasso's built-in tools for limiting the|
    |                 |found set. MySQL databases only.                  |
    +-----------------+--------------------------------------------------+
    |``-NoValueLists``|Specifies that value lists should not be fetched  |
    |                 |with the results. This applies to FileMaker Server|
    |                 |data sources and may apply to others as           |
    |                 |well. Check the chapters on each data source for  |
    |                 |details.                                          |
    +-----------------+--------------------------------------------------+

The results command tags are divided into three categories.

-  **Sorting** is specified using the ``-SortField`` and ``-SortOrder``
   command tags. These tags change the order of the records which are
   returned by the search. The sort is performed by the database
   application before Lasso receives the record set.
   
   The ``-SortRandom`` tag can be used to perform a random sort on the
   found set from MySQL databases. Note that the sort will be random
   each time a set of records is returned so ``-MaxRecords`` and
   ``-SkipRecords`` cannot be used to navigate a found set that is
   sorted randomly.

-  The portion of the **Found Set** being shown is specified using the
   ``-MaxRecords`` and ``-SkipRecords`` tags. ``-MaxRecords`` sets the
   number of records which will be shown between the ``[Records] …
   [/Records]`` tags that format the results for the visitor. The
   ``-SkipRecords`` tag sets the offset into the found set which is
   shown. These two tags define the window of records which are shown
   and can be used to navigate through a found set.
   
   The ``-UseLimit`` tag instructs MySQL data sources to use a SQL
   ``LIMIT`` tag to restrict the found set based on the values of the
   ``-MaxRecords`` and ``-SkipRecords`` tags. This may increase
   performance when many records are being found, but ``-MaxRecords`` is
   set to a low value.

-  The **Fields** which are available are specified using the
   ``-ReturnField`` tag. Normally, all fields in the table that was
   searched are returned. If any ``-ReturnField`` tags are specified
   then only those fields will be available to be returned to the
   visitor using the ``[Field]`` tag. Specifying ``-ReturnField`` tags
   can improve the performance of Lasso by not sending unnecessary data
   between the database and the Web server.

   .. Note:: In order to use the ``[KeyField_Value]`` tag within an
    inline the ``keyfield`` must be specified as one of the
    ``-ReturnField`` values.

-  The ``-Distinct`` tag instructs MySQL data sources to return only
   records which contain distinct values across all returned fields.
   This tag is useful when combined with a single ``-ReturnField`` tag
   and a ``-FindAll`` to return all distinct values from a single field
   in the database.

**To return sorted results:**

Specify ``-SortField`` and ``-SortOrder`` command tags within the search
parameters. The following inline includes sort command tags. The records
are first sorted by ``Last_Name`` in ascending order, then sorted by
``First_Name`` in ascending order.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='J',
        -SortField='Last_Name', -SortOrder='Ascending',
        -SortField='First_Name', -SortOrder='Ascending']
        [Records]
            <br>
            [Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

The following results could be returned when this inline is run. The
returned records are sorted in order of ``Last_Name``. If the
``Last_Name`` of two records are equal then those records are sorted in
order of ``First_Name``.

::

    ->
    <br>Jane Doe
    <br>John Doe
    <br>Jane Person
    <br>John Person

**To return a portion of a found set:**

A portion of a found set can be returned by manipulating the values for
``-MaxRecords`` and ``-SkipRecords``. In the following example, a search
is performed for records where the ``First_Name`` begins with ``J``.
This search returns four records, but only the second two records are
shown. ``-MaxRecords`` is set to ``2`` to show only two records and
``-SkipRecords`` is set to ``2`` to skip the first two records.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='J',
        -MaxRecords=2,
        -SkipRecords=2]
        [Records]
            <br>[Field: 'First_Name']
        [/Records]
    [/Inline]

The following results could be returned when this inline is run. Neither
of the ``Doe`` records from the previous example are shown since they
are skipped over.

::

    ->
    <br>Jane Person
    <br>John Person

**To limit the fields returned in search results:**

Use the ``-ReturnField`` command tag. If a single ``-ReturnField``
command tag is used then only the fields that are specified will be
returned. If no ``-ReturnField`` command tags are specified then all
fields within the current table will be shown. In the following example,
only the ``First_Name`` field is shown since it is the only field
specified within a ``-ReturnField`` command tag.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        'First_Name'='J',
        -ReturnField='First_Name']
        [Records]
            <br>[Field: 'First_Name']
        [/Records]
    [/Inline]

The following results could be returned when this link is selected. The
``Last_Name`` field cannot be shown for any of these records since it was
not specified in a``-ReturnField`` command tag.

::

    ->
    <br>Jane
    <br>John
    <br>Jane
    <br>John

If ``[Field: 'Last_Name']`` were specified inside the ``[Inline] …
[/Inline]`` tags and not specified as a``-ReturnField`` then an error
would be returned rather than the indicated results.

Finding All Records
^^^^^^^^^^^^^^^^^^^

All records can be returned from a database using the ``-FindAll``
command tag. The ``-FindAll`` command tag functions exactly like the
``-Search`` command tag except that no name/value parameters or operator
tags are required. Sort tags and tags which sort and limit the found set
work the same as they do for ``-Search`` actions. ``-FindAll`` actions
can be specified in ``[Inline] … [/Inline]`` tags.

.. Note:: If Classic Lasso syntax is enabled then the ``-FindAll``
    command tag can also be used within HTML forms or URLs. The use of
    Classic Lasso syntax has been deprecated so solutions which rely on
    it should be updated to use the inline methods described in this
    chapter.

.. table:: Table 7: -FindAll Action Requirements

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``-FindAll`` |The action which is to be performed. Required.    |
    +-------------+--------------------------------------------------+
    |``-Database``|The database which should be searched. Required.  |
    +-------------+--------------------------------------------------+
    |``-Table``   |The table from the specified database which should|
    |             |be searched. Required.                            |
    +-------------+--------------------------------------------------+
    |``-KeyField``|The name of the field which holds the primary key |
    |             |for the specified table. Recommended.             |
    +-------------+--------------------------------------------------+
    |``-Host``    |Optional inline host array. See the section on    |
    |             |:ref:`Inline Hosts<inline-hosts>` in the Database |
    |             |Interaction Fundamentals chapter for more         |
    |             |information.                                      |
    +-------------+--------------------------------------------------+

**To find all records within a database:**

The following ``[Inline] … [/Inline]`` tags find all records within a
database ``Contacts`` and displays them. The results are shown below.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

    ->
    <br>Jane Doe
    <br>John Person
    <br>Jane Person
    <br>John Doe

**To return all unique field values:**

The unique values from a field in a MySQL database can be returned using
the ``-Distinct`` tag. Only records which have distinct values across
all fields will be returned. In the following example, a ``-FindAll``
action is used on the ``People`` table of the ``Contacts`` database.
Only distinct values from the ``Last_Name`` field are returned.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -Distinct,
        -SortField='First_Name',
        -ReturnField='First_Name']
        [Records]
            <br>[Field: 'First_Name']
        [/Records]
    [/Inline]

The following results are returned. Even though there are multiple
instances of ``John`` and ``Jane`` in the database, only one record for
each name is returned.

::

    ->
    <br>Jane
    <br>John

Finding Random Records
^^^^^^^^^^^^^^^^^^^^^^

A random record can be returned from a database using the ``-Random``
command tag. The ``-Random`` command tag functions exactly like the
``-Search`` command tag except that no name/value parameters or operator
tags are required. ``-Random`` actions can be specified in ``[Inline] …
[/Inline]`` tags.

.. Note:: If Classic Lasso syntax is enabled then the ``-Random``
    command tag can also be used within HTML forms or URLs. The use of
    Classic Lasso syntax has been deprecated so solutions which rely on
    it should be updated to use the inline methods described in this
    chapter.

.. table:: Table 8: -Random Action Requirements

    +-------------+--------------------------------------------------+
    |Tag          |Description                                       |
    +=============+==================================================+
    |``-Random``  |The action which is to be performed. Required.    |
    +-------------+--------------------------------------------------+
    |``-Database``|The database which should be searched. Required.  |
    +-------------+--------------------------------------------------+
    |``-Table``   |The table from the specified database which should|
    |             |be searched. Required.                            |
    +-------------+--------------------------------------------------+
    |``-KeyField``|The name of the field which holds the primary key |
    |             |for the specified table. Recommended.             |
    +-------------+--------------------------------------------------+
    |``-Host``    |Optional inline host array. See the section on    |
    |             |:ref:`Inline Hosts<inline-hosts>` in the Database |
    |             |Interaction Fundamentals chapter for more         |
    |             |information.                                      |
    +-------------+--------------------------------------------------+

**To find a single random record from a database:**

The following inline finds a single random record from a FileMaker Pro
database ``Contacts.fp3`` and displays it. ``-MaxRecords`` is set to
``1`` to ensure that only a single record is shown. One potential result
is shown below. Each time this inline is run a different record will be
returned.

::

    [Inline: -Random,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=1]
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]
    -> <br>Jane Person

**To return multiple records sorted in random order:**

The ``-SortRandom`` tag can be used with the ``-Search`` or ``-FindAll``
actions to return many records from a MySQL database sorted in random
order. In the following example, all records from the ``People`` table of
the ``Contacts`` database are returned in random order.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -SortRandom]
        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

    ->
    <br>John Doe
    <br>Jane Doe
    <br>Jane Person
    <br>John Person

Displaying Data
---------------

The examples in this chapter have all relied on the ``[Records] …
[/Records]`` tags and ``[Field]`` tag to display the results of the
search that have been performed. This section describes the use of these
tags in more detail.

.. table:: Table 9: Field Display Tags

    +--------------------------+--------------------------------------------------+
    |Tag                       |Description                                       |
    +==========================+==================================================+
    |``[Records] … [/Records]``|Loops through each record in a found set. Optional|
    |                          |``-InlineName`` parameter specifies that results  |
    |                          |should be returned from a named inline. Synonym is|
    |                          |``[Rows] … [/Rows]``.                             |
    +--------------------------+--------------------------------------------------+
    |``[Field]``               |Returns the value for a database field. Requires  |
    |                          |one parameter, the field name. Optional parameter |
    |                          |``-RecordIndex`` specifies what record in the     |
    |                          |current found set a field should be shown         |
    |                          |from. Synonym is ``[Column]``.                    |
    +--------------------------+--------------------------------------------------+

The ``[Field]`` tag always returns the value for a field from the
current record when it is used within ``[Records] … [/Records]`` tags.
If the ``[Field]`` tag is used outside of ``[Records] … [/Records]``
tags then it returns the value for a field from the first record in the
found set. If the found set is only one record then the ``[Records] …
[/Records]`` tags are optional.

.. Note:: **FileMaker** - Lasso Connector for FileMaker Pro includes a
    collection of FileMaker Pro specific tags which return database
    results. See the :ref:`FileMaker Data Sources
    <FileMaker-Data-Sources>` chapter for more information.

**To display the results from a search:**

Use the ``[Records] … [/Records]`` tags and ``[Field]`` tag to display
the results of a search. The following ``[Inline] … [/Inline]`` tags
perform a ``-FindAll`` action in a database ``Contacts``. The results
are returned each formatted on a line by itself. The ``[Loop_Count]``
tag is used to indicate the order within the found set.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        [Records]
            <br>[Loop_Count]: [Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]
    [/Inline]

    ->
    <br>1: Jane Doe
    <br>2: John Person
    <br>3: Jane Person
    <br>4: John Doe

**To display the results for a single record:**

Use ``[Field]`` tags within the contents of the ``[Inline] … [/Inline]``
tags. The ``[Records] … [/Records]`` tags are unnecessary if only a
single record is returned. The following ``[Inline] … [/Inline]`` tags
perform a ``-Search`` for a single record whose primary key ``ID``
equals ``1``. The ``[KeyField_Value]`` is shown along with the
``[Field]`` values for the record.

::

    [Inline: -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -KeyValue=1]
        <br>[KeyField_Value]: [Field: 'First_Name'] [Field: 'Last_Name']
    [/Inline]

    ->
    <br>1: Jane Doe

**To display the results from a named inline:**

Use the ``-InlineName`` parameter in both the opening ``[Inline]`` tag
and in the opening ``[Records]`` tag. The ``[Records] … [/Records]``
tags can be located anywhere in the page after the ``[Inline] …
[/Inline]`` tags that define the database action. The following example
shows a ``-FindAll`` action at the top of a page in a LassoScript with
the results formatted later.

::

    <?LassoScript
        Inline: -FindAll,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID',
            -InlineName='FindAll Results';
        /Inline;
    ?>

    … Page Contents …

    [Records: -InlineName='FindAll Results']
        <br>[Loop_Count]: [Field: 'First_Name'] [Field: 'Last_Name']
    [/Records]

    ->
    <br>1: Jane Doe
    <br>2: John Person
    <br>3: Jane Person
    <br>4: John Doe

**To display the results from a search out of order:**

The ``-RecordIndex`` parameter of the ``[Field]`` tag can be used to
show results out of order. Instead of using ``[Records] … [/Records]``
tags to loop through a found set, the following example uses ``[Loop] …
[/Loop]`` tags to loop down through the found set from
``[MaxRecords_Value]`` to ``1``. The ``[Field]`` tags all reference the
``[Loop_Count]`` in their ``-RecordIndex`` parameter.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID']
        [Loop: -LoopFrom=(MaxRecords_Value), -LoopTo=1, -LoopIncrement=-1]
            <br>[Loop_Count]: [Field: 'First_Name', -RecordIndex=(Loop_Count)]
            [Field: 'Last_Name', -RecordIndex=(Loop_Count)]
        [/Loop]
    [/Inline]

    ->
    <br>4: John Doe
    <br>3: Jane Person
    <br>2: John Person
    <br>1: Jane Doe

Linking to Data
---------------

This section describes how to create links which allow a visitor to
manipulate the found set. The following types of links can be created.

-  **Navigation** – Links can be created which allow a visitor to page
   through a found set. Only a portion of the found set needs to be
   shown, but the entire found set can be accessed.
-  **Detail** – Links can be created which allow detail about a
   particular record to be shown in another Lasso page.
-  **Sorting** – Links can be provided to re-sort the current found set
   on a different field.

.. Note:: If Classic Lasso syntax is enabled then the links tags can be
    used to trigger actions using command tags embedded in URLs. The use
    of Classic Lasso syntax has been deprecated so solutions which rely
    on it should be updated to use the inline methods described in this
    chapter.

Most of the link techniques implicitly assume that the records within
the database are not going to change while the visitor is navigating
through the found set. The database search is actually performed again
for every page served to a visitor and if the number of results change
then the records being shown to the visitor can be shifted or altered as
soon as another link is selected.

Link Tags
^^^^^^^^^

Lasso 8 includes many tags which make creating detail links and
navigation links easy within Lasso solutions. The general purpose link
tags are specified in :ref:`Table 10: Link Tags
<searching-and-displaying-data-table-10>`. The common parameters for all
link tags are specified in :ref:`Table 11: Link Tag Parameters
<searching-and-displaying-data-table-11>`.

The remainder of the chapter lists and demonstrates the link URL,
container, and parameter tags. Tags which generate URLs for links
automatically are listed in :ref:`Table 12: Link URL Tags
<searching-and-displaying-data-table-12>`. Container tags which generate
entire HTML anchor tags ``<a>`` automatically are listed in :ref:`Table
13: Link Container Tags <searching-and-displaying-data-table-13>`. Tags
which provide parameter arrays for each link option are listed in
:ref:`Table 14: Link Parameter Tags
<searching-and-displaying-data-table-14>`.

.. _searching-and-displaying-data-table-10:

.. table:: Table 10: Link Tags

    +----------------------------------------+--------------------------------------------------+
    |Tag                                     |Description                                       |
    +========================================+==================================================+
    |``[Link] … [/Link]``                    |General purpose link tag that provides an anchor  |
    |                                        |tag with the specified parameters. The            |
    |                                        |``-Response`` parameter is used as the URL for the|
    |                                        |link.                                             |
    +----------------------------------------+--------------------------------------------------+
    |``[Link_Params]``                       |General purpose link tag that processes a set of  |
    |                                        |parameters using the common rules for all link    |
    |                                        |tags.                                             |
    +----------------------------------------+--------------------------------------------------+
    |``[Link_NextGroup] … [/Link_NextGroup]``|Sets a standard set of options that will be used  |
    |                                        |for all link tags that follow in the current Lasso|
    |                                        |page.                                             |
    +----------------------------------------+--------------------------------------------------+
    |``[Link_URL]``                          |General purpose link tag that provides a URL based|
    |                                        |on the specified parameters. The ``-Response``    |
    |                                        |parameter is used as the URL for the link.        |
    +----------------------------------------+--------------------------------------------------+

Each of the general purpose link tags implement the basic behavior of
all the link tags, but are not usually used on their own. The section on
:ref:`Link Tag Parameters <link-tag-parameters>` below describes the
common parameters that all link tags interpret. The following sections
include the link URL, container, and parameter tags and examples of
their use.

.. Note:: The ``[Link_…]`` tags do not include values for the ``-SQL``,
    ``-Username``, ``-Password`` or the ``-ReturnField`` tags in the
    links they generate.

.. _link-tag-parameters:

Link Tag Parameters
^^^^^^^^^^^^^^^^^^^

All of the link tags accept the same parameters which allow the link
that is being formed to be customized. These parameters include all the
command tags which can be passed to the opening ``[Inline]`` tag and a
series of parameters detailed in :ref:`Table 11: Link Tag
Parameters <searching-and-displaying-data-table-11>` which allow various
command tags to be removed from the generated link tags.

The link tags interpret their parameters as follows.

-  The parameters are processed in the order they are specified within
   the link tag. Later parameters override earlier parameters.
-  Most link tags process ``[Action_Params]`` first, then any parameters
   specified in ``[Link_SetFormat]``, and finally the parameters
   specified within the link tag itself. The general purpose link tags
   do not include ``[Action_Params]`` automatically.
-  Parameters of type array are inserted into the parameters as if each
   item of the array was specified in order at the location of the
   array.
-  Many command tags will only be included once in the resulting link.
   These include ``-Database``, ``-Table``, ``-KeyField``,
   ``-MaxRecords``, and any other command tags that can only be
   specified once within an inline. The last value for the command tag
   will be included in the resulting link.
-  Only one action such as ``-Search``, ``-FindAll``, or ``-Nothing``
   will be included in the resulting link. The last action specified in
   the link tag will be used.
-  Command tags such as ``-Required``, ``-Op``, ``-OpBegin``,
   ``-OpEnd``, ``-SortField``, ``-SortOrder``, and ``-Token`` will be
   included in the order they are specified within the tag.
-  The resulting link will consist of the action followed by all command
   tags specified once in alphabetical order, and finally all name/value
   parameters and command tags that are specified multiple times in the
   same order they were specified in the parameters.
-  All ``-No…`` parameters are interpreted at the location they occur in
   the parameters. If a ``-NoDatabase`` parameter is specified early in
   the parameter list and a ``-Database`` command tag is included later
   then the ``-Database`` command tag will be included in the resulting
   link.
-  The ``-NoClassic`` parameter removes all command tags that are not
   essential to specifying the search and location in the found set to
   an ``[Inline]`` tag. The ``-Database``, ``-Table``, ``-KeyField``,
   and action are all removed. All name/value parameters, ``-Sort…``
   tags, ``-Op`` tags, and either ``-MaxRecords`` and ``-SkipRecords``
   or ``-KeyValue`` are included.
-  The value of the ``-Response`` command tag will be used as the URL for
   the resulting link. The link tags always link to a response file on
   the same server they are called. If not specified the ``-Response``
   will be the same as ``[Response_FilePath]``.
-  The ``-SQL``, ``-Username``, ``-Password``, and ``-ReturnField`` tags
   are never returned by the link tags.

.. Note:: The ``[Referrer]`` and ``[Referrer_URL]`` tags are special
    cases which simply return the referrer specified in the HTTP request
    header. They do not accept any parameters.

.. _searching-and-displaying-data-table-11:

.. table:: Table 11: Link Tag Parameters

    +-------------------------------+--------------------------------------------------+
    |Tag                            |Description                                       |
    +===============================+==================================================+
    |Command Tag                    |Inserts the specified command tag. Either appends |
    |                               |the command tag or overrides an existing command  |
    |                               |tag with the new value.                           |
    +-------------------------------+--------------------------------------------------+
    |Name/Value Pair                |Inserts the specified name/value pair.            |
    +-------------------------------+--------------------------------------------------+
    |Array Parameter                |An array of pairs is inserted as if each          |
    |                               |name/value pair in the array was specified in the |
    |                               |tag parameters at the location of the array.      |
    +-------------------------------+--------------------------------------------------+
    |``-NoAction``                  |Removes the action command tag.                   |
    +-------------------------------+--------------------------------------------------+
    |``-NoClassic``                 |Removes all parameters required to specify an     |
    |                               |action in Classic Lasso leaving only those        |
    |                               |parameters required to specify the query and      |
    |                               |current location in the found set.                |
    +-------------------------------+--------------------------------------------------+
    |``-NoDatabase``                |Removes the ``-Database`` command tag.            |
    +-------------------------------+--------------------------------------------------+
    |``-NoTable``                   |Removes the ``-Table`` or ``-Layout`` command     |
    |                               |tag. ``-NoLayout`` is a synonym.                  |
    +-------------------------------+--------------------------------------------------+
    |``-NoKeyField``                |Removes the ``-KeyField`` command tag.            |
    +-------------------------------+--------------------------------------------------+
    |``-NoKeyValue``                |Removes the ``-KeyValue`` command tag.            |
    +-------------------------------+--------------------------------------------------+
    |``-NoOperatorLogical``         |Removes the ``-OperatorLogical`` command tag.     |
    +-------------------------------+--------------------------------------------------+
    |``-NoResponse``                |Removes the ``-Response`` command tag.            |
    +-------------------------------+--------------------------------------------------+
    |``-NoMaxRecords``              |Removes the ``-MaxRecords`` command tag.          |
    +-------------------------------+--------------------------------------------------+
    |``-NoSkipRecords``             |Removes the ``-SkipRecords`` command tag.         |
    +-------------------------------+--------------------------------------------------+
    |``-NoParams``                  |Removes name/value pairs, ``-Operator``,          |
    |                               |``-OperatorBegin``, ``-OperatorEnd``, and         |
    |                               |``-Required`` tags.                               |
    +-------------------------------+--------------------------------------------------+
    |``-NoSort``                    |Removes all ``-Sort…`` command tags.              |
    +-------------------------------+--------------------------------------------------+
    |``-NoToken``, ``-NoToken.Name``|Removes the ``-Token`` command tag. With a        |
    |                               |parameter as ``-NoToken.Name`` removes the        |
    |                               |specified token command tag.                      |
    +-------------------------------+--------------------------------------------------+
    |``-NoTokens``                  |Removes all ``-Token…`` command tags.             |
    +-------------------------------+--------------------------------------------------+
    |``-NoSchema``                  |Removes the ``-Schema`` command tag for JDBC data |
    |                               |sources.                                          |
    +-------------------------------+--------------------------------------------------+
    |``-No.Name``                   |Removes a specified name/value parameter.         |
    +-------------------------------+--------------------------------------------------+
    |``-Response``                  |Specifies the file that will be used as the URL   |
    |                               |for the link tag. The link tags always link to a  |
    |                               |file on the current server.                       |
    +-------------------------------+--------------------------------------------------+

Link URL Tags
^^^^^^^^^^^^^

The tags listed in :ref:`Table 12: Link URL Tags
<searching-and-displaying-data-table-12>` each return a URL based on the
current database action. Each of these tags accepts the same parameters
as specified in :ref:`Table 11: Link Tag Parameters
<searching-and-displaying-data-table-11>` above and corresponds to
matching container and parameter tags. Examples of the link tags are
included in the Link Examples section that follows.

.. _searching-and-displaying-data-table-12:

.. table:: Table 12: Link URL Tags

    +---------------------------+--------------------------------------------------+
    |Tag                        |Description                                       |
    +===========================+==================================================+
    |``[Link_CurrentActionURL]``|Returns a link to the current Lasso action.       |
    +---------------------------+--------------------------------------------------+
    |``[Link_FirstGroupURL]``   |Returns a link to the first group of records based|
    |                           |on the current Lasso action. Sets ``-SkipRecords``|
    |                           |to ``0``.                                         |
    +---------------------------+--------------------------------------------------+
    |``[Link_PrevGroupURL]``    |Returns a link to the next group of records based |
    |                           |on the current Lasso action. Changes              |
    |                           |``-SkipRecords``.                                 |
    +---------------------------+--------------------------------------------------+
    |``[Link_NextGroupURL]``    |Returns a link to the next group of records based |
    |                           |on the current Lasso action. Changes              |
    |                           |``-SkipRecords``.                                 |
    +---------------------------+--------------------------------------------------+
    |``[Link_LastGroupURL]``    |Returns a link to the last group of records based |
    |                           |on the current Lasso action. Changes              |
    |                           |``-SkipRecords``.                                 |
    +---------------------------+--------------------------------------------------+
    |``[Link_CurrentRecordURL]``|Returns a link to the current record. Sets        |
    |                           |``-MaxRecords`` to ``1`` and changes              |
    |                           |``-SkipRecords``.                                 |
    +---------------------------+--------------------------------------------------+
    |``[Link_FirstRecordURL]``  |Returns a link to the first record based on the   |
    |                           |current Lasso action. Sets ``-MaxRecords`` to     |
    |                           |``1`` and ``-SkipRecords`` to ``0``.              |
    +---------------------------+--------------------------------------------------+
    |``[Link_PrevRecordURL]``   |Returns a link to the next record based on the    |
    |                           |current Lasso action. Sets ``-MaxRecords`` to     |
    |                           |``1`` and changes ``-SkipRecords``.               |
    +---------------------------+--------------------------------------------------+
    |``[Link_LastRecordURL]``   |Returns a link to the last record based on the    |
    |                           |current Lasso action. Sets ``-`MaxRecords`` to    |
    |                           |``1`` and changes ``-SkipRecords``.               |
    +---------------------------+--------------------------------------------------+
    |``[Link_DetailURL]``       |Returns a link to the current record using the    |
    |                           |primary key and key value. Changes ``-KeyValue``. |
    +---------------------------+--------------------------------------------------+
    |``[Referrer_URL]``         |Returns a link to the previous page which the     |
    |                           |visitor was at before the current                 |
    |                           |page. ``[Referer_URL]`` is a synonym.             |
    +---------------------------+--------------------------------------------------+

.. Note:: The ``[Referrer_URL]`` tag is a special case which simply
    returns the referrer specified in the HTTP request header. It does
    not accept any parameters.

Link Container Tags
^^^^^^^^^^^^^^^^^^^

The tags listed in :ref:`Table 13: Link Container Tags
<searching-and-displaying-data-table-13>` each return an anchor tag
based on the current database action. The anchor tags surround the
contents of the container tag. If the link tag is not valid then no
result is returned. Each of these tags accepts the same parameters as
specified in :ref:`Table 11: Link Tag Parameters
<searching-and-displaying-data-table-11>` above and corresponds to
matching URL and parameter tags. Examples of the link tags are included
in the :ref:`Link Examples <link-examples>` section that follows.

.. _searching-and-displaying-data-table-13:

.. table:: Table 13: Link Container Tags

    +------------------------+--------------------------------------------------+
    |Tag                     |Description                                       |
    +========================+==================================================+
    |``[Link_CurrentAction]``|Returns a link to the current Lasso action.       |
    +------------------------+--------------------------------------------------+
    |``[Link_FirstGroup]``   |Returns a link to the first group of records based|
    |                        |on the current Lasso action. Sets ``-SkipRecords``|
    |                        |to ``0``.                                         |
    +------------------------+--------------------------------------------------+
    |``[Link_PrevGroup]``    |Returns a link to the previous group of records   |
    |                        |based on the current Lasso action. Changes        |
    |                        |``-SkipRecords``.                                 |
    +------------------------+--------------------------------------------------+
    |``[Link_NextGroup]``    |Returns a link to the next group of records based |
    |                        |on the current Lasso action. Changes              |
    |                        |``-SkipRecords``.                                 |
    +------------------------+--------------------------------------------------+
    |``[Link_LastGroup]``    |Returns a link to the last group of records based |
    |                        |on the current Lasso action. Changes              |
    |                        |``-SkipRecords``.                                 |
    +------------------------+--------------------------------------------------+
    |``[Link_CurrentRecord]``|Returns a link to the current record. Sets        |
    |                        |``-MaxRecords`` to ``1`` and changes              |
    |                        |``-SkipRecords``.                                 |
    +------------------------+--------------------------------------------------+
    |``[Link_FirstRecord]``  |Returns a link to the first record based on the   |
    |                        |current Lasso action. Sets ``-MaxRecords`` to     |
    |                        |``1`` and ``-SkipRecords`` to ``0``.              |
    +------------------------+--------------------------------------------------+
    |``[Link_PrevRecord]``   |Returns a link to the previous record based on the|
    |                        |current Lasso action. Sets ``-MaxRecords`` to     |
    |                        |``1`` and changes ``-SkipRecords``.               |
    +------------------------+--------------------------------------------------+
    |``[Link_NextRecord]``   |Returns a link to the next record based on the    |
    |                        |current Lasso action. Sets ``-MaxRecords`` to     |
    |                        |``1`` and changes ``-SkipRecords``.               |
    +------------------------+--------------------------------------------------+
    |``[Link_LastRecord]``   |Returns a link to the last record based on the    |
    |                        |current Lasso action. Sets ``-MaxRecords`` to     |
    |                        |``1`` and changes ``-SkipRecords``.               |
    +------------------------+--------------------------------------------------+
    |``[Link_Detail]``       |Returns a link to the current record using the    |
    |                        |``-KeyField`` and ``-KeyValue``. Changes          |
    |                        |``-KeyValue``.                                    |
    +------------------------+--------------------------------------------------+
    |``[Referrer_URL]``      |Returns a link to the previous page which the     |
    |                        |visitor was at before the current                 |
    |                        |page. ``[Referer_URL]`` is a synonym.             |
    +------------------------+--------------------------------------------------+

.. Note:: The ``[Referrer] … [/Referrer]`` tag is a special case which
    simply returns the referrer specified in the HTTP request header. It
    does not accept any parameters.

Link Parameter Tags
^^^^^^^^^^^^^^^^^^^

The tags listed in :ref:`Table 14: Link Parameter Tags
<searching-and-displaying-data-table-14>` each return an array of
parameters based on the current database action. Each of these tags
accepts the same parameters as specified in :ref:`Table 11: Link Tag
Parameters <searching-and-displaying-data-table-11>` above and
corresponds to matching container and URL tags. Examples of the link
tags are included in the :ref:`Link Examples <link-examples>` section
that follows.

.. _searching-and-displaying-data-table-14:

.. table:: Table 14: Link Parameter Tags

    +------------------------------+--------------------------------------------------+
    |Tag                           |Description                                       |
    +==============================+==================================================+
    |``[Link_CurrentActionParams]``|Returns a link to the current Lasso action.       |
    +------------------------------+--------------------------------------------------+
    |``[Link_FirstGroupParams]``   |Returns a link to the first group of records based|
    |                              |on the current Lasso action. Sets ``-SkipRecords``|
    |                              |to ``0``.                                         |
    +------------------------------+--------------------------------------------------+
    |``[Link_PrevGroupParams]``    |Returns a link to the previous group of records   |
    |                              |based on the current Lasso action. Changes        |
    |                              |``-SkipRecords``.                                 |
    +------------------------------+--------------------------------------------------+
    |``[Link_NextGroupParams]``    |Returns a link to the next group of records based |
    |                              |on the current Lasso action. Changes              |
    |                              |``-SkipRecords``.                                 |
    +------------------------------+--------------------------------------------------+
    |``[Link_LastGroupParams]``    |Returns a link to the last group of records based |
    |                              |on the current Lasso action. Changes              |
    |                              |``-SkipRecords``.                                 |
    +------------------------------+--------------------------------------------------+
    |``[Link_CurrentRecordParams]``|Returns a link to the current record. Sets        |
    |                              |``-MaxRecords`` to ``1`` and changes              |
    |                              |``-SkipRecords``.                                 |
    +------------------------------+--------------------------------------------------+
    |``[Link_FirstRecordParams]``  |Returns a link to the first record based on the   |
    |                              |current Lasso action. Sets ``-MaxRecords`` to     |
    |                              |``1`` and ``-SkipRecords`` to ``0``.              |
    +------------------------------+--------------------------------------------------+
    |``[Link_PrevRecordParams]``   |Returns a link to the previous record based on the|
    |                              |current Lasso action. Sets ``-MaxRecords`` to     |
    |                              |``1`` and changes ``-SkipRecords``.               |
    +------------------------------+--------------------------------------------------+
    |``[Link_NextRecordParams]``   |Returns a link to the next record based on the    |
    |                              |current Lasso action. Sets ``-MaxRecords`` to     |
    |                              |``1`` and changes ``-SkipRecords``.               |
    +------------------------------+--------------------------------------------------+
    |``[Link_LastRecordParams]``   |Returns a link to the last record based on the    |
    |                              |current Lasso action. Sets ``-MaxRecords`` to     |
    |                              |``1`` and changes ``-SkipRecords``.               |
    +------------------------------+--------------------------------------------------+
    |``[Link_DetailParams]``       |Returns a link to the current record using the    |
    |                              |primary key and key value. Changes ``-KeyValue``. |
    +------------------------------+--------------------------------------------------+

.. Note:: There is no link parameter tag equivalent to the referrer tags.

.. _link-examples:

Link Examples
^^^^^^^^^^^^^

The basic technique for using the link tags is the same as that which
was described to allow site visitors to enter values into HTML forms and
then use those values within an ``[Inline] … [/Inline]`` action. The
``[Inline]`` tags can have some command tags and search parameters
specified explicitly, with variables, an array, ``[Action_Params]``, or
one of the link tags defining the rest.

For example, an ``[Inline] … [/Inline]`` could be specified to find all
records within a database as follows. The entire action is specified
within the opening ``[Inline]`` tag. Each time a page with the code on
it is visited the action will be performed as written.

::

    [Inline: -FindAll,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=10]
        …
    [/Inline]

The same inline can be modified so that it can accept parameters from an
HTML form or URL which is used to load the page it is on, but can still
act as a standalone action. This is accomplished by adding an
``[Action_Params]`` tag to the opening ``[Inline]`` tag.

::

    [Inline: (Action_Params),
        -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=4]
        …
    [/Inline] 

Any command tags or name/value pairs in the HTML form or URL that
triggers the page with this inline will be passed into the inline
through the ``[Action_Params]`` tag as if they had been typed directly
into the ``[Inline]``. However, the command tags specified directly in
the ``[Inline]`` tag will override any corresponding tags from the
``[Action_Params]``.

Since the action ``-Search`` is specified after the ``[Action_Params]``
array it will override any other action from the array. The action of
this inline will always be ``-Search``. Similarly, all of the
``-Database``, ``-Table``, ``-KeyField``, or ``-MaxRecords`` tags will
have the values specified in the ``[Inline]`` overriding any values
passed in through ``[Action_Params]``.

The various link tags can be used to generate URLs which work with the
specified inline in order to change the set of records being shown, the
sort order and sort field, etc. The link tags are able to override any
command tags not specified in the opening ``[Inline]`` tag, but the
basic action is always performed exactly as specified.

Navigation Links
^^^^^^^^^^^^^^^^

Navigation links are created by manipulating the value for
``-SkipRecords`` so that the visitor is shown a different portion of the
found set each time they follow a link or by setting ``-KeyValue`` to an
appropriate value to show one record in a database.

**To create next and previous links:**

The ``[Link_NextGroup] … [/Link_NextGroup]`` and ``[Link_PrevGroup] …
[/Link_PrevGroup]`` tags can be used with the inline specified above to
page through a set of found records.

The ``[Link_NextGroup] … [/Link_NextGroup]`` tag is used to include a
``-NoClassic`` parameter in each link tag that follows. This ensures
that the ``-Database``, ``-Table``, and ``-KeyField`` are not included
in the links generated by the link tags.

The full inline is shown below. It uses the ``[Records] … [/Records]``
tags to show the people that have been found in the database and
includes next and previous links to page through the found set.

::

    [Inline: (Action_Params),
        -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=4]

        <p>[Found_Count] records were found, showing [Shown_Count]
        records from [Shown_First] to [Shown_Last].

        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]

        [Link_SetFormat: -NoClassic]
        [Link_PrevGroup] <br>Previous [MaxRecords_Value] Records [/Link_PrevGroup]
        [Link_NextGroup] <br>Next [MaxRecords_Value] Records [/Link_NextGroup]
    [/Inline]

The first time this page is loaded the first four records from the
database are shown. Since this is the first group of records in the
database only the ``Next 4 Records`` link is displayed.

::

    ->
    <p>16 records were found, showing 4 records from 1 to 4.
    <br>Jane Doe
    <br>John Person
    <br>Jane Person
    <br>John Doe
    <br>Next 4 Records

If the ``Next 4 Records`` link is selected then the same page is
reloaded. The value for ``-SkipRecords`` is taken from the link tag and
passed into the opening ``[Inline]`` tag through the ``[Action_Params]``
array. The following results are displayed. This time both the ``Next 4
Records`` and the ``Previous 4 Records`` links are displayed.

::

    ->
    <p>16 records were found, showing 4 records from 5 to 8.
    <br>Jane Surname
    <br>John Last_Name
    <br>Mark Last_Name
    <br>Tom Surname
    <br>Previous 4 Records
    <br>Next 4 Records

**To create first and last links:**

Links to the first and last groups of records in the found set can be
added using the ``[Link_FirstGroup] … [/Link_FirstGroup]`` and
``[Link_NextGroup] … [/Link_NextGroup]`` tags. The following inline
includes both next/previous links and first/last links.

::

    [Inline: (Action_Params),
        -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=4]

        <p>[Found_Count] records were found, showing [Shown_Count]
        records from [Shown_First] to [Shown_Last].

        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]

        [Link_SetFormat: -NoClassic]
        [Link_FirstGroup] <br>First [MaxRecords_Value] Records [/Link_FirstGroup]
        [Link_PrevGroup] <br>Previous [MaxRecords_Value] Records [/Link_PrevGroup]
        [Link_NextGroup] <br>Next [MaxRecords_Value] Records [/Link_NextGroup]
        [Link_LastGroup] <br>Last [MaxRecords_Value] Records [/Link_LastGroup]
    [/Inline]

The first time this page is loaded the first four records from the
database are shown. Since this is the first group of records in the
database only the ``Next 4 Records`` and ``Last 4 Records`` links are
displayed. The ``Previous 4 Records`` and ``First 4 Records`` links will
automatically appear if either of these links are selected by the
visitor.

::

    ->
    <p>16 records were found, showing 4 records from 1 to 4.
    <br>Jane Doe
    <br>John Person
    <br>Jane Person
    <br>John Doe
    <br>Next 4 Records
    <br>Last 4 Records

**To create links to page through the found set:**

Many Web sites include page links which allow the visitor to jump
directly to any set of records within the found set. The example
``-FindAll`` returns ``16`` records from ``Contacts`` so four page links
would be created to jump to the 1st, 5th, 9th, and 13th records.

A set of page links can be created using the ``[Link_CurrentActionURL]``
tag as a base and then customizing the ``-SkipRecords`` value as needed.
The following loop creates as many page links as are needed for the
current found set.

::

    [Inline: (Action_Params),
        -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=4]

        <p>[Found_Count] records were found, showing [Shown_Count]
        records from [Shown_First] to [Shown_Last].

        [Records]
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
        [/Records]

        [Link_SetFormat: -NoClassic]
        [Variable: 'Count' = 0]
        [While: $Count < (Found_Count)]
            <br><a href="[Link_CurrentActionURL: -SkipRecords=$Count]">
                Page [Loop_Count]
            </a>
            [Variable: 'Count' = $Count + (MaxRecords_Value)]
        [/While]
    [/Inline]

The results of this code for the example ``-Search`` would be the
following. There are four page links. The first is equivalent to the
``First 4 Records`` link created above and the last is equivalent to the
``Last 4 Records`` link created above.

::

    ->
    <p>16 records were found, showing 4 records from 1 to 4.
    <br>Jane Doe
    <br>John Person
    <br>Jane Person
    <br>John Doe
    <br>Page 1
    <br>Page 2
    <br>Page 3
    <br>Page 4

Sorting Links
^^^^^^^^^^^^^

Sorting links are created by adding or manipulating ``-SortField`` and
``-SortOrder`` command tags. The same found set is shown, but the order
is determined by which link is selected. Often, the column headers in a
table of results from a database will represent the sort links that
allow the table to be resorted by the values in that specific column.

**To create links that sort the found set:**

The following code performs a ``-Search`` in an inline and formats the
results as a table. The column heading at the top of each table column
is a link which re-sorts the results by the field values in that column.
The links for sorting the found set are created by specifying
``-NoSort`` and ``-SortField`` parameters to the ``[Link_FirstGroup] …
[/Link_FirstGroup]`` tags.

::

    [Inline: (Action_Params),
        -Search,
        -Database='Contacts',
        -Table='People',
        -KeyField='ID',
        -MaxRecords=4]

        [Link_SetFormat: -NoClassic]
        <table>
            <tr>
                <th>
                    [Link_FirstGroup: -NoSort, -SortOrder='First_Name']
                        First Name
                    [/Link_FirstGroup]
                </th>
                <th>
                    [Link_FirstGroup: -NoSort, -SortOrder='Last_Name']
                        Last Name
                    [/Link_FirstGroup]
                </th>
            </tr>

        [Records]
            <tr>
                <td>[Field: 'First_Name']</td>
                <td>[Field: 'Last_Name']</td>
            </tr>
        [/Records]

        </table>
    [/Inline]

Detail Links
^^^^^^^^^^^^

Detail links are created in order to show data from a particular record
in the database table. Usually, a listing Lasso page will contain only
limited data from each record in the found set and a detail Lasso page
will contain significantly more information about a particular record.

A link to a particular record can be created using the ``[Link_Detail] …
[/Link_Detail]`` tags to set the ``-KeyField`` and ``-KeyValue`` fields.
This method is guaranteed to return the selected record even if the
database is changing while the visitor is navigating. However, it is
difficult to create next and previous links on the detail page. This
option is most suitable if the selected database record will need to be
updated or deleted.

Alternately, a link to a particular record can be created using
``[Link_CurrentAction] … [/Link_CurrentAction] `` and setting
``-MaxRecords`` to ``1``. This method allows the visitor to continue
navigating by records on the detail page.

**To create a link to a particular record:**

There are two Lasso pages involved in most detail links. The listing
Lasso page ``default.lasso`` includes the ``[Inline] … [/Inline]`` tags
that define the search for the found set. The detail Lasso page
``response.lasso`` includes the ``[Inline] … [/Inline]`` tags that find
and display the individual record.

#.  The ``[Inline]`` tag in ``default.lasso`` simply performs a
    ``-FindAll`` action. Each record in the result set is displayed with
    a link to response.lasso created using the ``[Link_Detail] …
    [/Link_Detail]`` tags.

    ::
    
        [Inline:-FindAll,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID',
            -MaxRecords=4]
            [Link_SetFormat: -NoClassic]
            [Records]
                <br>[Link_Detail: -Response='response.lasso']
                    [Field: 'First_Name'] [Field: 'Last_Name']
                [/Link_Detail]
            [/Records]
        [/Inline]
        -> <br>Jane Doe
        <br>John Person
        <br>Jane Person
        <br>John Doe

#.  The ``[Inline]`` tag on ``response.lasso`` uses ``[Action_Params]``
    to pull the values from the URL generated by the link tags. The
    results contain more information about the particular records than
    is shown in the listing. In this case, the ``Phone_Number`` field is
    included as well as the ``First_Name`` and ``Last_Name``.

    ::
    
        [Inline:(Action_Params),
            -Search,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID']
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
            <br>[Field: 'Phone_Number']
            …
        [/Inline]

        ->
        <br>Jane Doe
        <br>555-1212

**To create a link to the current record in the found set:**

There are two Lasso pages involved in most detail links. The listing
Lasso page ``default.lasso`` includes the ``[Inline] … [/Inline]`` tags
that define the search for the found set. The detail Lasso page
``response.lasso`` includes the ``[Inline] … [/Inline]`` tags that find
and display the individual record. The ``[Link_CurrentAction] …
[/Link_CurrentAction]`` tags are used to create a link from
``default.lasso`` to ``response.lasso`` showing a particular record.

#.  The ``[Inline]`` tag on ``default.lasso`` simply performs a
    ``-FindAll`` action. Each record in the result set is displayed with
    a link to ``response.lasso`` created using the
    ``[Link_CurrentAction] … [/Link_CurrentAction]`` tag.

    ::
    
        [Inline:-FindAll,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID',
            -MaxRecords=4]
            [Link_SetFormat: -NoClassic]
            [Records]
                <br>[Link_CurrentAction: -Response='response.lasso', -MaxRecords=1]
                    [Field: 'First_Name'] [Field: 'Last_Name']
                [/Link_CurrentAction]
            [/Records]
        [/Inline]

        ->
        <br>Jane Doe
        <br>John Person
        <br>Jane Person
        <br>John Doe

#.  The ``[Inline]`` tag in response.lasso uses ``[Action_Params]`` to
    pull the values from the URL generated by the link tags. The results
    contain more information about the particular records than is shown
    in the listing. In this case, the ``Phone_Number`` field is included
    as well as the ``First_Name`` and ``Last_Name.``
    
    The detail page can also contain links to the previous and next
    records in the found set. These are created using the
    ``[Link_PrevRecord] … [/Link_PrevRecord]`` and ``[Link_NextRecord] …
    [/Link_NextRecord]`` tags. The visitor can continue navigating the
    found set record by record.

    ::
    
        [Inline:(Action_Params),
            -Search,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID']
            <br>[Field: 'First_Name'] [Field: 'Last_Name']
            <br>[Field: 'Phone_Number']
            …
            [Link_SetFormat: -NoClassic]
            <br>[Link_PrevRecord] Previous Record [/Link_PrevRecord]
            <br>[Link_NextRecord] Next Record [/Link_NextRecord]
        [/Inline]

        ->
        <br>Jane Last_Name
        <br>555-1212
        <br>Previous Record
        <br>Next Record
