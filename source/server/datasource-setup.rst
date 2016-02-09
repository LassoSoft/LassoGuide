.. http://www.lassosoft.com/Lasso-9-Server-Administration
.. _datasource-setup:

****************
Datasource Setup
****************

Lasso Server communicates with :dfn:`data sources`, which are any type of
software mechanism for storing and retrieving data (including databases), using
Lasso :dfn:`data source connectors`, which are modular components that translate
Lasso requests into commands specific to each data source. Connections to data
sources, or :dfn:`datasources`, are configured in the "Datasources" section of
Lasso Server Admin. Lasso Server provides built-in connectors for all of the
data sources listed below.

Most connectors can access data sources that are installed on the same machine
as Lasso Server or on a remote machine. Some connectors can only access files on
the local machine. Whether or not an ODBC data source can communicate with Lasso
on a separate machine depends on whether or not the driver can communicate via
TCP/IP.

Custom data source connectors for other data sources can also be created for use
with Lasso Server using Lasso's C API (LCAPI), Java API (LJAPI) or Lasso itself
using the :type:`dsinfo` type. (Information about creating and using LCAPI
third-party data source connectors can be found in the :ref:`lcapi-sources`
chapter of the LCAPI documentation.)

:ref:`datasource-setup-filemaker`
   Supports FileMaker Server 7--12 Advanced and FileMaker Server 9--12.

:ref:`datasource-setup-mysql`
   Supports MySQL Server 3.x, 4.x, or 5.x data sources. The MySQL client
   libraries need to be installed when using this data source.

:ref:`datasource-setup-oracle`
   Supports Oracle data sources. The Oracle "Instant Client" libraries must be
   installed in order to activate this data source.

:ref:`datasource-setup-postgresql`
   Supports PostgreSQL data sources. The PostgreSQL client libraries must be
   installed in order to activate this data source.

:ref:`datasource-setup-odbc`
   Support any data source with a compatible ODBC driver.

:ref:`datasource-setup-sql-server`
   Supports Microsoft SQL Server. The SQL Server client libraries must be
   installed in order to activate this data source.

:ref:`datasource-setup-sqlite`
   SQLite is also the internal data source used for the storage of Lasso's
   preferences and security settings.


Lasso Data Source Connectors
============================

Data source connectors allow database actions to be performed via Lasso code.
Database actions can be used in Lasso to search for records in a database that
match specific criteria; to navigate through the found set from a search; to
add, update, or delete a record in a database; to fetch schema information about
a database; and more. Additionally, database actions can be used to execute SQL
statements in SQL-compliant databases.

Interacting with data sources via Lasso generally involves these steps:

#. Configuring the data source application or service to accept connections from
   Lasso. This is done in the data source itself, outside of Lasso. This chapter
   describes configuring each data source to accept connections from Lasso.

#. Configuring Lasso Server to communicate with a data source host. This
   involves adding the data source connection information in the "Datasources"
   section of Lasso Server Admin. This chapter details creating connections with
   the data sources described above.

#. Writing Lasso code to interact with the data source. This is covered in the
   :ref:`database-interaction` chapter.

Alternatively, data sources can be connected to directly by specifying all the
connection parameters within an inline. Using this method does not require
setting up the data source host in Lasso Server Admin, and can be used when some
security can be sacrificed for coding efficiency. In this case, the following
steps need to be taken:

#. Configuring the data source application or service to accept connections from
   Lasso, as described above.

#. Writing Lasso code to interact with the data source and passing in the host
   parameters to the inline. Each of the data sources documented below will give
   examples of interfacing with a data source host in this manner.

.. only:: html

   .. important::
      Links to third-party distributions and tools are provided for your
      convenience and were accurate when this guide was written. LassoSoft
      cannot guarantee the availability or suitability of software downloaded
      from third-party web sites.


.. _datasource-setup-filemaker:

FileMaker Server Data Sources
=============================

Lasso Server communicates with FileMaker Server 7--12 Advanced and FileMaker
Server 9--12 through their built-in XML interface. Lasso cannot communicate with
any other products in the FileMaker 7, 8, or 9 product line such as FileMaker
Pro.


Requirements
------------

One of the following:

-  FileMaker Server 9--12 for Windows or OS X
-  FileMaker Server 9--12 Advanced for Windows or OS X
-  FileMaker Server Advanced 7 or 8 for Windows or OS X

Additionally, the Web Publishing Engine must be installed and each database must
be configured according to the instructions in the following section.


Configuring FileMaker Server 9 or Higher
----------------------------------------

This section describes setting up FileMaker Server 9--12 or FileMaker Server
9--12 Advanced for use with Lasso. These versions will be referred to
collectively as FileMaker Server.

Follow the instructions included with FileMaker Server carefully. Starting with
version 9, setting up FileMaker Server is considerably easier than setting up
earlier versions.

-  Make sure that the "Web Serving" options are turned on and that the XML
   interface is enabled.
-  The databases that are to be accessed by Lasso must be in the FileMaker
   Server Data/Databases folder and must be "Open" within FileMaker Server.
-  Each database to be accessed by Lasso must have the "fmxml" keyword added to
   the "Extended Privileges" section of the "Accounts & Privileges" dialog box.
   The username and password entered into Lasso Server Admin must use a
   Privilege Set that has access to this extended privilege.
-  FileMaker Server database security is only as secure as the Publishing Engine
   setup. It is possible for web browsers to communicate directly with the
   Publishing Engine. It is strongly recommended that the security features of
   FileMaker Server be used to secure web-accessible databases.
-  It is strongly recommended that only a single IP address corresponding to the
   machine on which Lasso Server runs be permitted to access the Publishing
   Engine.
-  For tips on optimizing performance for FileMaker databases, see the
   :ref:`filemaker-data-sources` chapter.


Configuring FileMaker Server Advanced 7 or 8
--------------------------------------------

This section describes setting up FileMaker Server Advanced for use with Lasso.

Follow the instructions included with FileMaker Server Advanced carefully. There
are several steps in the process that are not obvious and require reading the
documentation to set up properly. Configuring FileMaker Server Advanced is
beyond the scope of this documentation, but some common pitfalls are listed
below.

-  Make sure both FileMaker Server and the FileMaker Server Advanced Publishing
   Engine are installed. The machine with the Publishing Engine must be running
   a supported web server.
-  Configure FileMaker Server with a Client Services identifier and passcode.
   Enter this same identifier and passcode in the Web Publishing Administration
   Console.
-  Verify XML Publishing is turned on in the Web Publishing Administration
   Console.
-  The databases to be accessed by Lasso must be in the FileMaker Server
   Data/Databases folder and must be "Open" within FileMaker Server.
-  Each database to be accessed by Lasso must have the "fmxml" keyword added to
   the "Extended Privileges" section of the "Accounts & Privileges" dialog box.
   The username and password entered into Lasso Server Admin must use a
   Privilege Set that has access to this extended privilege.
-  FileMaker Server Advanced database security is only as secure as the
   Publishing Engine setup. It is possible for web browsers to communicate
   directly with the Publishing Engine. It is strongly recommended that the
   security features of FileMaker Server Advanced be used to secure
   web-accessible databases.
-  It is strongly recommended that only a single IP address corresponding to the
   machine on which Lasso Server runs be permitted to access the Publishing
   Engine.
-  For tips on optimizing performance for FileMaker databases, see the
   :ref:`filemaker-data-sources` chapter.


Adding a FileMaker Server Data Source Host
------------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the section :ref:`instance-administration-datasources` in
the :ref:`instance-administration` chapter.

To add a new FileMaker Server host:

#. In the "Datasources" section of Lasso Server Admin, click the
   :guilabel:`filemakerds` item.
#. Click the :guilabel:`Add host` item to reveal the host connection form.
#. Enter the IP address or domain name where the FileMaker Server data sources
   are being hosted.
#. Enter the TCP port the FileMaker Server communicates on in the "Port" field.
   See the FileMaker Server documentation for information on where to find or
   set this. It is commonly "80" for FileMaker Server, or "443" to connect over
   https.
#. Select "Yes" from the :guilabel:`Enabled` drop-down to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source host and all databases therein using this username by
   default. If the host does not require a username, then leave this field
   blank.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source host and all databases therein using this password by
   default. If the host does not require a password, then leave this field
   blank.
#. Click the :guilabel:`Add host` button.
#. Once the host is added, the new host appears in the "Hosts" listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the
:guilabel:`Enabled` drop-down to "No". With the FileMaker Server data source
added here, `inline` methods can use the ``-database`` parameter to specify the
name of the FileMaker database to perform an action on.


Specifying FileMaker Server Hosts in Inlines
--------------------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is centrally controlled. However, it can
sometimes be beneficial to access a data source host without a lot of
configuration. This section describes how to construct an `inline` method to
access a FileMaker Server data source host. See the
:ref:`database-inline-connection` section for full details about specifying
hosts in inlines.

To access a FileMaker Server host directly in an `inline` method, the ``-host``
parameter can be used to specify all of the connection parameters. The ``-host``
parameter takes an array that should contain the following elements:

-  ``-datasource`` should be specified as "filemakerds".
-  ``-name`` should be specified as the IP address or domain name of the machine
   hosting FileMaker Server.
-  ``-port`` is optional and defaults to "80" if no port is specified.
-  ``-username`` set to the user to authenticate as.
-  ``-password`` set to the specified user's password to authenticate the
   connection.

The following code shows how a connection to a FileMaker Server data source
hosted on the same machine as Lasso might appear::

   inline(
      -host=(:
         -datasource='filemakerds',
         -name='localhost',
         -port='80',
         -username='username',
         -password='secret'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}

If there are no databases or tables listed, check the following links in a web
browser to verify that the Web Publishing Engine is working correctly. Replace
"filemaker_host" and "database_name" with values for your particular situation.

-  :samp:`http://{filemaker_host}/fmi/xml/FMPXMLRESULT.xml?-dbnames`
-  :samp:`http://{filemaker_host}/fmi/xml/FMPXMLRESULT.xml?-db={database_name}&-layoutnames`

If either URL returns an error code other than 0 or fails in any way, Lasso will
be unable to submit requests to FileMaker Server. Verify that XML Publishing is
enabled or consult the FileMaker Server documentation on how to proceed.


.. _datasource-setup-mysql:

MySQL Data Sources
==================

Lasso Server can communicate with MySQL servers configured to accept TCP/IP
client connections. For more information on MySQL, visit
`<http://www.mysql.com/>`_.


Requirements
------------

-  MySQL Server 3.23 or MySQL Server 4.x or MySQL Server 5.x
-  The MySQL service must be running and accepting TCP/IP connections on a port
   with no conflicts. This is port 3306 by default.
-  MySQL access privileges must be properly assigned for the machine running
   Lasso Server to be allowed to authenticate.
-  The Lasso Server machine must have the MySQL client libraries installed.


Configuring MySQL Server
------------------------

MySQL is operated via a command-line interface application which is normally
located in the "bin" directory of the MySQL installation on the server machine.
For information on how to use this, consult the MySQL documentation. Various
installers for MySQL may have the service automatically start when the machine
boots up, so also check the installation instructions for the installation
method you are using.

Security for MySQL data sources can be set at any level (server-level,
database-level, table-level, etc.). For unrestricted operation, all permissions
for all levels of security need to be given to the user Lasso Server uses to
connect. This involves setting a new user and password for Lasso Server in MySQL
with the appropriate permissions, and then entering the username and password in
Lasso Server Admin. Follow the procedure below for granting all permissions to
Lasso Server in MySQL using the MySQL command-line utility.

#. From the command line, log in to MySQL as your root user by entering the
   following command:

   .. code-block:: none

      $> mysql -u root -p

   You will be prompted for the MySQL root user's password specified during the
   MySQL installation.

#. After entering the password, you'll see the MySQL command prompt
   (``mysql>``). Enter the following to create a new user with a username and
   password and access to all levels of security in MySQL:

   .. code-block:: none

      mysql> GRANT ALL ON *.* TO Username@Hostname IDENTIFIED BY "Password";

   Replace "Username" and "Password" with the username and password values you
   wish for the user to have, and replace "Hostname" with the IP address or
   domain name that Lasso Server will be connecting from.

Now there is a user with all permissions that can communicate with MySQL from
the machine Lasso Server is running on. This user can now be used when
configuring the MySQL host in the "Datasources" section of Lasso Server Admin.

.. important::
   You may, of course, wish to tighten security and restrict the user Lasso
   Server uses. It is possible to assign limited privileges to the user Lasso
   Server uses one at a time by replacing "ALL" in the "GRANT" statement with an
   individual permission (e.g. INSERT, SELECT, DELETE), and replacing "\*.\*"
   with a specific database or database.table name. This will restrict the
   functionality of Lasso Server to the privileges that are assigned to it. For
   example, giving Lasso Server only the "SELECT" privilege will allow a MySQL
   database to be searched using Lasso, but records cannot be added, updated, or
   deleted using Lasso.


Adding a MySQL Data Source Host
-------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the section :ref:`instance-administration-datasources` in
the :ref:`instance-administration` chapter.

To add a new MySQL host:

#. In the "Datasources" section of Lasso Server Admin, click the
   :guilabel:`MySQLDS` item.
#. Click the :guilabel:`Add host` item to reveal the host connection form.
#. Enter the IP address or domain name where the MySQL databases are being
   hosted in the "Host" field.
#. Enter the TCP port the MySQL service communicates on in the "Port" field.
   This is commonly "3306" for MySQL.
#. Select "Yes" from the :guilabel:`Enabled` drop-down to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Click the :guilabel:`Add host` button.
#. Once the host is added, the new host appears in the "Hosts" listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the
:guilabel:`Enabled` drop-down to "No". With the MySQL data source added here,
`inline` methods can use the ``-database`` parameter to specify the name of the
MySQL database to perform an action on.


Specifying MySQL Hosts in Inlines
---------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is centrally controlled. However, it can
sometimes be beneficial to access a data source host without a lot of
configuration. This section describes how to construct an `inline` method that
accesses a MySQL data source host. See the :ref:`database-inline-connection`
section for full details about specifying hosts in inlines.

To access a MySQL host directly in an `inline` method, the ``-host`` parameter
can be used to specify all of the connection parameters. The ``-host`` parameter
takes an array that should contain the following elements:

-  ``-datasource`` should be specified as "mysqlds".
-  ``-name`` should be specified as the IP address or domain name of the machine
   hosting MySQL.
-  ``-port`` is optional and defaults to "3306" if no port is specified.
-  ``-username`` set to the user to authenticate as.
-  ``-password`` set to the specified user's password to authenticate the
   connection.

The following code shows how a connection to a MySQL data source hosted on the
same machine as Lasso might appear::

   inline(
      -host=(:
         -datasource='mysqlds',
         -name='localhost',
         -port='3306',
         -username='username',
         -password='secret'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-oracle:

Oracle Data Sources
===================

Lasso Server can communicate with an Oracle service running on a host machine
via a TCP/IP connection. For more information on Oracle, visit
`<http://www.oracle.com/>`_.


Requirements
------------

-  Oracle Database 10g
-  The Lasso Server machine must have the Oracle "Instant Client" installed if
   Lasso Server and Oracle are running on separate machines. The `Instant Client
   download`_ can be found on the Oracle website. (Make sure to download just
   the basic Instant Client files rather than the complete Oracle 10g client or
   database installer.)


Installing Oracle Instant Client
--------------------------------

:OS X:
   #. Download version 10.0.2.4 of the Instant Client for OS X.
   #. Decompress the archive, which will create a folder "instantclient_10_2".
   #. Copy the contents of folder into :file:`/usr/local/oracle/lib/`.
   #. Execute the following command to create symbolic links so that Lasso can
      find the Oracle libraries. (Using :command:`sudo` will require that you
      enter your password in order to continue.)

      .. code-block:: none

         $> sudo ln -sf /usr/local/oracle/lib/* /usr/local/lib/

   #. Execute the following command to create a symbolic link to the library
      "libclntsh.dylib.10.1" so that Lasso can load the library:

      .. code-block:: none

         $> sudo ln -s /usr/local/lib/libclntsh.dylib.10.1 /usr/local/lib/libclntsh.dylib

:Linux:
   #. Download version 11.2.0.2.0 of the Instant Client for Linux.
   #. Decompress the archive, which will create a folder "instantclient_11_2".
   #. Copy the contents of the folder into :file:`/usr/local/oracle/lib/`.
   #. Execute the following command to create symbolic links so that Lasso can
      find the Oracle libraries. (Using :command:`sudo` will require that you
      enter your password in order to continue.)

      .. code-block:: none

         $> sudo ln -sf /usr/local/oracle/lib/* /usr/local/lib/

   #. Execute the following command to create a symbolic link to the library
      "libclntsh.so.11.1" so that Lasso can load the library:

      .. code-block:: none

         $> sudo ln -s /usr/local/lib/libclntsh.so.11.1 /usr/local/lib/libclntsh.so


Configuring Oracle
------------------

The Oracle database server must be configured with a user that has access to all
of the databases, tables, and other resources that will be published through
Lasso. Consult the Oracle documentation for help configuring Oracle's built-in
security. The Oracle website has a "Getting Started" section which explains how
to install and perform `basic configuration of an Oracle database server`_.


Adding an Oracle Data Source Host
---------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the section :ref:`instance-administration-datasources` in
the :ref:`instance-administration` chapter.

To add a new Oracle host:

#. In the "Datasources" section of Lasso Server Admin, click the
   :guilabel:`Oracle` item.
#. Click the :guilabel:`Add host` item to reveal the host connection form.
#. Enter the IP address or domain name where the Oracle data sources are being
   hosted, the port, and the database name using the "host:port/database" format
   in the "Host" field (e.g. "www.example.com:1521/MyDatabase").
#. Enter the TCP port of the Oracle service in the "Port" field. This is
   commonly "1521" for Oracle.
#. Select "Yes" from the :guilabel:`Enabled` drop-down to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Click the :guilabel:`Add host` button.
#. Once the host is added, the new host appears in the "Hosts" listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the
:guilabel:`Enabled` drop-down to "No". With the Oracle Server data source added
here, `inline` methods can use the ``-database`` parameter to specify the name
of the Oracle database to perform an action on.


Specifying Oracle Hosts in Inlines
----------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is centrally controlled. However, it can
sometimes be beneficial to access a data source host without a lot of
configuration. This section describes how to construct an `inline` method that
accesses an Oracle data source host. See the :ref:`database-inline-connection`
section for full details about specifying hosts in inlines.

To access an Oracle host directly in an `inline` method, the ``-host`` parameter
can be used to specify all of the connection parameters. The ``-host`` parameter
takes an array that should contain the following elements:

-  ``-datasource`` should be specified as "oracle".
-  ``-name`` should be specified as the IP address or domain name of the machine
   hosting Oracle, followed by a colon and the port to connect on, and ending
   with a slash and the database name (e.g. "www.example.com:1521/MyDatabase").
-  ``-port`` is optional and defaults to "1521" if no port is specified.
-  ``-username`` set to the user to authenticate as.
-  ``-password`` set to the specified user's password to authenticate the
   connection.

The following code shows how a connection to an Oracle data source might
appear::

   inline(
      -host=(:
         -datasource='oracle',
         -name='oracle.example.com:1521/MyDatabase',
         -port='1521',
         -username='username',
         -password='secret'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-postgresql:

PostgreSQL Data Sources
=======================

Lasso Server can communicate with PostgreSQL servers configured to accept TCP/IP
client connections. For more information on PostgreSQL, visit
`<http://www.postgresql.org/>`_.


Requirements
------------

-  PostgreSQL 8.x
-  The Lasso Server machine must have the PostgreSQL "libpq" library installed.


Configuring PostgreSQL
----------------------

The PostgreSQL database server must be configured with a user that has access to
all of the databases, tables, and other resources that will be published through
Lasso. Consult the `PostgreSQL documentation`_ for help configuring its built-in
security.


Adding a PostgreSQL Data Source Host
------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the section :ref:`instance-administration-datasources` in
the :ref:`instance-administration` chapter.

To add a new PostgreSQL server host:

#. In the "Datasources" section of Lasso Server Admin, click the
   :guilabel:`PostgreSQL` item.
#. Click the :guilabel:`Add host` item to reveal the host connection form.
#. Enter the IP address or domain name where the PostgreSQL data source is being
   hosted in the "Host" field.
#. Enter the TCP port the PostgreSQL service is listening on in the "Port"
   field. This is commonly "5432" for PostgreSQL.
#. Select "Yes" from the :guilabel:`Enabled` drop-down to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Click the :guilabel:`Add host` button.
#. Once the host is added, the new host appears in the "Hosts" listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the
:guilabel:`Enabled` drop-down to "No". With the PostgreSQL data source added
here, `inline` methods can use the ``-database`` parameter to specify the name
of the PostgreSQL database to perform an action on.


Specifying PostgreSQL Hosts in Inlines
--------------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is centrally controlled. However, it can
sometimes be beneficial to access a data source host without a lot of
configuration. This section describes how to construct an `inline` method that
accesses a PostgreSQL data source host. See the
:ref:`database-inline-connection` section for full details about specifying
hosts in inlines.

To access a PostgreSQL host directly in an `inline` method, the ``-host``
parameter can be used to specify all of the connection parameters. The ``-host``
parameter takes an array that should contain the following elements:

-  ``-datasource`` should be specified as "postgres".
-  ``-name`` should be specified as the IP address or domain name of the machine
   hosting PostgreSQL.
-  ``-port`` is optional and defaults to "5432" if no port is specified.
-  ``-username`` set to the user to authenticate as.
-  ``-password`` set to the specified user's password to authenticate the
   connection.

The following code shows how a connection to a PostgreSQL data source hosted on
the same machine as Lasso might appear::

   inline(
      -host=(:
         -datasource='postgres',
         -name='localhost',
         -port='5432',
         -username='username',
         -password='secret'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-odbc:

ODBC Data Sources
=================

:dfn:`ODBC` (Open Database Connectivity) is a generalized API for providing
access to databases. Lasso Server can communicate with any ODBC-compliant data
source as long as the operating system has a compatible ODBC driver properly
installed. For more information on ODBC, see the :ref:`odbc-data-sources`
chapter and the documentation included with your operating system.


Requirements
------------

-  An ODBC driver that has been configured as a System DSN in the ODBC control
   panel.

   :OS X:
      ODBC data sources are configured using "ODBC Administrator" which can be
      found in the :file:`/Applications/Utilities` folder (OS X 10.5) or
      downloaded from `<http://support.apple.com/kb/DL895>`_. Lasso can access
      data sources configured as System DSNs.

   :Linux:
      Consult the documentation of the ODBC drivers for information about how to
      set up data sources on Linux. Many ODBC drivers ship with a control panel
      that allows configuration of those drivers. Lasso can access data sources
      configured as System DSNs.

   :Windows:
      ODBC data sources are configured using "ODBC Data Source Administrator"
      which is normally accessed through the Windows Control Panel under
      :file:`Administrative Tools`. Lasso can access data sources configured as
      System DSNs.


Configuring ODBC Hosts
----------------------

Consult the documentation for your data sources and ODBC drivers for details
about how to secure access to the data made available through the driver. Most
data sources will require the following steps:

#. Install your ODBC driver using the provided installer or instructions.
#. Create a System DSN in the ODBC administration application. Note that the
   System DSN name, username, and password configured here will need to be
   entered in Lasso.
#. Locate and configure the :file:`SQL.ini` file for your driver. This file sets
   the options for your ODBC driver including the location of your data source.
   Consult your driver's documentation for details about where to find this file
   and what options can be configured.
#. Follow the steps below to add the data source to Lasso.


Adding an ODBC Data Source Host
-------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the section :ref:`instance-administration-datasources` in
the :ref:`instance-administration` chapter.

To add a new ODBC host:

#. In the "Datasources" section of Lasso Server Admin, click the
   :guilabel:`ODBC` item.
#. Click the :guilabel:`Add host` item to reveal the host connection form.
#. Enter the System DSN name of the ODBC connection in the "Host" field.
#. Enter the TCP port of the ODBC connection in the "Port" field.
#. Select "Yes" from the :guilabel:`Enabled` drop-down to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Click the :guilabel:`Add host` button.
#. Once the host is added, the new host appears in the "Hosts" listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the
:guilabel:`Enabled` drop-down to "No". With the ODBC data source added here,
`inline` methods can use the ``-database`` parameter to specify the name of the
database to perform an action on.


Specifying ODBC Hosts in Inlines
--------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is centrally controlled. However, it can
sometimes be beneficial to access a data source host without a lot of
configuration. This section describes how to construct an `inline` method that
accesses an ODBC data source host. See the :ref:`database-inline-connection`
section for full details about specifying hosts in inlines.

To access an ODBC host directly in an `inline` method, the ``-host`` parameter
can be used to specify all of the connection parameters. The ``-host`` parameter
takes an array that should contain the following elements:

-  ``-datasource`` should be specified as "odbc".
-  ``-name`` should be specified as the System DSN.
-  ``-username`` set to the user to authenticate as, if required.
-  ``-password`` set to the specified user's password to authenticate the
   connection, if required.

The following code shows how a connection to an ODBC data source hosted on the
same machine as Lasso might appear::

   inline(
      -host=(:
         -datasource='odbc',
         -name='System_DSN_Name',
         -username='username',
         -password='secret'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-sql-server:

SQL Server Data Sources
=======================

Lasso Server can communicate with Microsoft SQL Server databases configured to
accept TCP/IP client connections. For more information on SQL Server, visit
`<http://www.microsoft.com/en-us/sqlserver/>`_.


Requirements
------------

-  Microsoft SQL Server 2005--2012
-  The Lasso Server machine must have the SQL Server client libraries installed.

   :OS X and Linux:
      The FreeTDS libraries need to be compiled and installed, for which the
      source can be found at `<http://www.freetds.org/>`_. (Instead of compiling
      from source, you may first want to look into installing via a package
      manager such as :program:`apt`, :program:`yum`, :program:`macports`, or :program:`homebrew`.)

   :Windows:
      The necessary client libraries should already be installed.


Configuring SQL Server
----------------------

The SQL Server database server must be configured with a user that has access to
all of the databases, tables, and other resources that will be published through
Lasso. Consult the `SQL Server documentation`_ for help configuring its built-in
security.


Adding a SQL Server Data Source Host
------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the section :ref:`instance-administration-datasources` in
the :ref:`instance-administration` chapter.

To add a new SQL Server database host:

#. In the "Datasources" section of Lasso Server Admin, click the
   :guilabel:`SQLServer` item.
#. Click the :guilabel:`Add host` item to reveal the host connection form.
#. Enter the IP address or domain name where the SQL Server data source is being
   hosted followed by a backslash and the name of a database in the "Host"
   field. (e.g. "www.example.com\\MyDatabase")
#. Enter the TCP port the SQL Server service is listening on in the "Port"
   field. This is commonly "1433" for SQL Server.
#. Select "Yes" from the :guilabel:`Enabled` drop-down to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Click the :guilabel:`Add host` button.
#. Once the host is added, the new host appears in the "Hosts" listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the
:guilabel:`Enabled` drop-down to "No". With the SQL Server data source added
here, `inline` methods can use the ``-database`` parameter to specify the name
of the SQL Server database to perform an action on.


Specifying SQL Server Hosts in Inlines
--------------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is centrally controlled. However, it can
sometimes be beneficial to access a data source host without a lot of
configuration. This section describes how to construct an `inline` method that
accesses a SQL Server data source host. See the
:ref:`database-inline-connection` section for full details about specifying
hosts in inlines.

To access a SQL Server host directly in an `inline` method, the ``-host``
parameter can be used to specify all of the connection parameters. The ``-host``
parameter takes an array that should contain the following elements:

-  ``-datasource`` should be specified as "sqlserver".
-  ``-name`` should be specified as the IP address or domain name of the machine
   hosting SQL Server.
-  ``-port`` is optional and defaults to "1433" if no port is specified.
-  ``-username`` set to the user to authenticate as.
-  ``-password`` set to the specified user's password to authenticate the
   connection.

The following code shows how a connection to a SQL Server data source hosted on
the same machine as Lasso might appear::

   inline(
      -host=(:
         -datasource='sqlserver',
         -name='(local)\MYDB',
         -username='username',
         -password='secret'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-sqlite:

SQLite Data Sources
===================

Lasso Server comes with an embedded high-performance data source called SQLite.
This data source is used to store Lasso's internal site preferences and security
settings. SQLite is installed, enabled, and preconfigured within Lasso Server by
default. No further set up or installation of SQLite is required.

SQLite databases are stored in the "SQLiteDBs" folder within each instance's
home directory. By default this folder contains databases that are required for
Lasso Server to function. Custom databases may be created and added to this
folder and Lasso `inline` methods will automatically have access to them using
the ``-database`` parameter.

.. _Instant Client download: http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html
.. _basic configuration of an Oracle database server: http://www.oracle.com/pls/db111/portal.portal_db
.. _PostgreSQL documentation: http://www.postgresql.org/docs/manuals/
.. _SQL Server documentation: http://www.microsoft.com/en-us/sqlserver/learning-center/resources.aspx
