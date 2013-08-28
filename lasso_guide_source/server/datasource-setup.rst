.. _datasource-setup:

***********************
Setting Up Data Sources
***********************

Lasso 9 Server communicates with data sources using Lasso data source connectors
which are modular components configured using the "Datasources" section of Lasso
Server Admin. Lasso 9 Server provides built-in connectors for all of the data
sources listed below.

Most connectors can access data sources which are installed on the same machine
as Lasso 9 or on a remote machine. Some connectors can only access files on the
local machine. Whether or not an ODBC data source can communicate with Lasso on
a separate machine depends on whether or not the driver can communicate via
TCP/IP.

Custom data source connectors for other data sources can also be created for use
with Lasso 9 using Lasso 9's C API (LCAPI), Java API (LJAPI) or Lasso itself
using the ``dsinfo`` type. (Information about creating and using LCAPI
third-party data source connectors can be found in the :ref:`Creating Lasso Data
Sources <lcapi-sources>` LCAPI documentation.)


:ref:`FileMaker Server Data Sources<datasource-setup-filemaker>`
   Supports FileMaker Server 7 - 12 Advanced and FileMaker Server 9 - 12.

:ref:`MySQL Data Sources<datasource-setup-mysql>`
   Supports MySQL 3.x, 4.x, or 5.x data sources. The MySQL client libraries
   need to be installed when using this data source.

:ref:`Oracle Data Source<datasource-setup-oracle>`
   Supports Oracle data sources. The Oracle "Instant Client" libraries must be
   installed in order to activate this data source. See the section below for
   more information.

:ref:`PostgreSQL Data Source<datasource-setup-postgresql>`
   Supports PostgreSQL data sources. The PostgreSQL client libraries must be
   installed in order to activate this data source. See the section below for
   more information.

:ref:`ODBC Data Sources<datasource-setup-odbc>`
   Support any data source with a compatible ODBC driver. See the section below
   for details about how to install ODBC drivers.

:ref:`SQL Server<datasource-setup-sql-server>`
   Supports Microsoft SQL Server. The SQL Server client libraries must be
   installed in order to activate this data source. See the section below for
   more information

:ref:`SQLite Data Source<datasource-setup-sqlite>`
   SQLite is also the internal data source which is used for the storage of
   Lasso's preferences and security settings.

Using Lasso Data Source Connectors
==================================

Data source connectors allow database actions to be performed via Lasso code.
Database actions can be used in Lasso to search for records in a database that
match specific criteria; to navigate through the found set from a
search; to add, update, or delete a record in a database; to fetch schema
information about a database; and more. In addition, database actions can be
used to execute SQL statements in SQL-compliant databases.

Interacting with data sources via Lasso usually involves these steps:

#. Configuring the data source application or service to accept connections from
   Lasso. This is done in the data source itself, outside of Lasso. This chapter
   describes configuring each data source to accept connections from Lasso.

#. Configure Lasso 9 Server to communicate with a data source host. This
   involves adding the data source connection information in the Datasource
   section of Lasso Server Admin. This chapter details creating connections with
   the data sources described above.

#. Write Lasso code to interact with the data source. This is covered in the
   :ref:`Database Interaction<database-interaction>` section.

Alternatively, data sources can be connected to directly by specifying the host
parameters directly in an inline. Using this method does not require setting up
the data source host in Lasso Server Admin, and can be used when some security
can be sacrificed for coding efficiency. In this case, the following steps need
to be taken:

#. Configuring the data source application or service to accept connections from
   Lasso. This is done in the data source itself, outside of Lasso. This chapter
   describes configuring each data source to accept connections from Lasso.

#. Write Lasso code to interact with the data source and passing in the host
   parameters to the inline. Each of the data sources documented below will give
   examples of interfacing with a data source host in this manner.


.. _datasource-setup-filemaker:

FileMaker Server Data Sources
=============================

Lasso 9 communicates with FileMaker Server 7-12 Advanced and FileMaker Server
9-12 through the built-in XML interface. Lasso cannot communicate with any other
products in the FileMaker 7, 8 or 9 product line such as FileMaker Pro.

Requirements
------------

-  FileMaker Server 9-12 for Windows or OS X

or

- FileMaker Server 9-12 Advanced for Windows or OS X

or

-  FileMaker Server Advanced 7 or 8 for Windows or OS X

Additionally, the Web Publishing Engine must be installed and each database must
be configured according to the instructions in the following section


Configuring FileMaker Server 9 or Higher
----------------------------------------

This section describes setting up FileMaker Server 9-12 or FileMaker Server 9-12
Advanced for use with Lasso. These versions will be referred to collectively as
FileMaker Server.

Follow the instructions included with FileMaker Server carefully. Starting with
version 9, setting up FileMaker Server is considerably easier than setting up
earlier versions.

-  Make sure that the "Web Serving" options are turned on and that the XML
   interface is enabled.
-  The databases which are to be accessed by Lasso must be in the FileMaker
   Server Data/Databases folder and must be Open within FileMaker Server.
-  Each database to be accessed by Lasso must have the fmxml keyword added to
   the "Extended Privileges" section of the "Accounts & Privileges" dialog box.
   The username and password which are entered into Lasso Server Admin must use
   a Privilege Set which has access to this extended privilege.
-  FileMaker Server database security in Lasso 9 Server is only as secure as the
   Publishing Engine setup. It is possible for Web browsers to communicate
   directly with the Publishing Engine. It is strongly recommended that the
   security features of FileMaker Server be used to secure accessible databases.
-  It is strongly recommended that only a single IP address is permitted to
   access the Publishing Engine which represents the machine on which Lasso 9
   runs.
-  For tips on optimizing performance for FileMaker databases, see :ref:`the
   section on querying FileMaker Data Sources <filemaker-data-sources>`.


Configuring FileMaker Server Advanced 7 or 8
--------------------------------------------

This section describes setting up FileMaker Server Advanced for use with Lasso.

Follow the instructions included with FileMaker Server Advanced carefully. There
are several steps in the process which are not obvious and require reading the
documentation to set up properly. Configuring FileMaker Server Advanced is
beyond the scope of this documentation, but some common pitfalls are listed
below.

-  Make sure both FileMaker Server and the FileMaker Server Advanced Publishing
   Engine are installed. The machine with the Publishing Engine must be running
   a supported Web server.
-  Configure FileMaker Server with a Client Services identifier and passcode.
   Enter this same identifier and passcode in the Web Publishing Administration
   Console.
-  Ensure XML Publishing is turned on in the Web Publishing Administration
   Console.
-  The databases which are to be accessed by Lasso must be in the FileMaker
   Server Data/Databases folder and must be Open within FileMaker Server.
-  Each database to be accessed by Lasso must have the fmxml keyword added to
   the Extended Privileges section of the Accounts & Privileges dialog box. The
   username and password which are entered into Lasso Server Admin must use a
   Privilege Set which has access to this extended privilege.
-  FileMaker Server Advanced database security in Lasso 9 Server is only as
   secure as the Publishing Engine setup. It is possible for web browsers to
   communicate directly with the Publishing Engine. It is strongly recommended
   that the security features of FileMaker Server Advanced be used to secure
   accessible databases.
-  It is strongly recommended that only a single IP address is permitted to
   access the Publishing Engine which represents the machine on which Lasso 9
   runs.
-  For tips on optimizing performance for FileMaker databases, see :ref:`the
   section on querying FileMaker Data Sources <filemaker-data-sources>`.


Adding FileMaker Server Data Source Hosts
-----------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the :ref:`Configuring Data Sources
<instance-administration-datasources>` section.

To add a new FileMaker Server host:

#. In the "Datasources" area of Lasso Server Admin, click the "filemakerds" item.
#. Click the "Add host" button to reveal the host connection form.
#. Enter the IP address or domain name where the FileMaker Server data sources
   are being hosted.
#. Enter the TCP port the FileMaker Server communicates on in the "Port" field.
   See the FileMaker Server documentation for information on where to find or
   set this. It is commonly "80" for FileMaker Server.
#. Select "Yes" from the "Enabled" pull-down menu to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source host and all databases therein using this username by
   default. If the host does not require a username, then leave this field
   blank.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source host and all databases therein using this password by
   default. If the host does not require a password, then leave this field
   blank.
#. Select the "Add Host" button.
#. Once the host is added, the new host appears in the Hosts Listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the "Enabled"
drop-down to "No". With the FileMaker Server data source added here, ``inline``
methods can use the ``-database`` parameter to specify the name of the FileMaker
database to perform an action on.


Specifying FileMaker Server Hosts in Inlines
--------------------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is fully controlled. However, it can sometimes be
beneficial to access a data source host without a lot of configuration. This
section describes how to construct an ``inline`` method to access a FileMaker
Server data source host. See the :ref:`Inline Connection Overview<inline-hosts>`
section for full details about inline host specification.

To access a FileMaker Server host directly in an ``inline`` method, the
``-host`` parameter can be used to specify all of the connection parameters. The
``-host`` parameter takes an array that should contain the following elements:

-  The ``-datasource`` should be specified as "filemakerds".
-  The ``-name`` should be specified as the IP address or domain name of the
   machine hosting FileMaker Server.
-  The ``-port`` is optional and defaults to 80 if no port is specified.
-  The ``-username`` of the user to authenticate as.
-  The ``-password`` of the specified user to authenticate the connection.

The following code shows how a connection to a FileMaker Server data source
hosted on the same machine as Lasso might appear::

   inline(
      -host=(: 
         -datasource='filemakerds', 
         -name='localhost', 
         -port='80', 
         -username='username', 
         -password='password'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-mysql:

MySQL Data Sources
==================

Lasso 9 can communicate with MySQL servers configured to accept TCP/IP client
connections. For more information on MySQL, visit `<http://www.mysql.com>`_.

Requirements
------------

-  MySQL 3.23 or MySQL 4.x or MySQL 5.x
-  The MySQL service must be running and accepting TCP/IP connections on a port
   with no conflicts. This is port 3306 by default.
-  MySQL access privileges must be properly assigned for the machine running
   Lasso 9 to be allowed to authenticate.
-  The Lasso 9 machine must have the MySQL client libraries installed.

.. note::
   Links to third party distributions and tools are provided for your
   convenience and were accurate when this manual was written. LassoSoft cannot
   be responsible for the availability or suitability of software downloaded
   from third party web sites.


Configuring MySQL Server
------------------------

MySQL is operated via a command-line interface application which is normally
located in the "bin" directory of the MySQL installation on the server machine.
For information on how to use this, consult the MySQL documentation. Various
installers for MySQL may have the service automatically start when the machine
boots up, so also check the installation instructions for the installation
method you are using.

Security for MySQL data sources can be set at any level (server-level, database-
level, table-level, etc.). For unrestricted operation, all permissions for all
levels of security need to be given to the user Lasso 9 uses to connect. This
involves setting a new user and password for Lasso 9 in MySQL with the
appropriate permissions, and then entering the username and password in Lasso
Server Admin. Follow the procedure below for granting all permissions to Lasso 9
in MySQL using the MySQL command-line utility.

#. From the command line, log in to MySQL as your root user by entering the
   following command:

   .. code-block:: none

      $> mysql -u root -p

   You will be prompted for the MySQL root user's password specified during the
   MySQL installation.

#. After entering the password, you'll see the MySQL command prompt ("mysql>").
   Enter the following to create a new user with a username and password and
   access to all levels of security in MySQL:

   .. code-block:: none

      mysql> GRANT ALL ON *.* TO Username@Hostname IDENTIFIED BY "Password";

   Replace "Username" and "Password" with the username and password values you
   wish for the user to have, and replace "Hostname" with the IP address or
   domain name that Lasso 9 will be connecting from.

Now there is a user with all permissions that can communicate with MySQL from
the machine Lasso 9 is running on. This user can now be used when configuring
the MySQL host in the Datasources section of Lasso Server Admin.

.. note::
   You may, of course, wish to tighten security and restrict the user Lasso 9
   uses. It is possible to assign limited privileges to the user Lasso 9 uses
   one at a time by replacing "ALL" in the "GRANT" statement with an individual
   permission (e.g. INSERT, SELECT, DELETE), and replacing "\*.\*" with a
   specific database or database.table name. This will restrict the
   functionality of Lasso 9 to the privileges that are assigned to it. For
   example, giving Lasso 9 only the "SELECT" privilege will allow a MySQL
   database to be searched using Lasso, but records cannot be added, updated, or
   deleted using Lasso.


Adding a MySQL Server Data Source Host
--------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the :ref:`Configuring Datasources
<instance-administration-datasources>` section.

To add a new MySQL server host:

#. In the Datasources area of Lasso Server Admin, click the "MySQLDS" item.
#. Click the "Add host" button to reveal the host connection form.
#. Enter the IP address or domain name where the MySQL datasources are being
   hosted in the "Host" field.
#. Enter the TCP port the MySQL service communicates on in the "Port" field.
   This is commonly "3306" for MySQL.
#. Select "Yes" from the "Enabled" pull-down menu to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Select the "Add Host" button.
#. Once the host is added, the new host appears in the Hosts Listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the "Enabled"
drop-down to "No". With the MySQL Server data source added here, ``inline``
methods can use the ``-database`` parameter to specify the name of the MySQL
database to perform an action on.


Specifying MySQL Hosts in Inlines
---------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is fully controlled. However, it can sometimes be
beneficial to access a data source host without a lot of configuration. This
section describes how to construct an ``inline`` method which access a MySQL
data source host. See the :ref:`Inline Connection Overview<inline-hosts>`
section for full details about inline host specification.

To access a MySQL host directly in an ``inline`` method, the ``-host`` parameter
can be used to specify all of the connection parameters. The ``-host`` parameter
takes an array that should contain the following elements:

-  The ``-datasource`` should be specified as "mysqlds".
-  The ``-name`` should be specified as the IP address or domain name of the
   machine hosting MySQL Server.
-  The ``-port`` is optional and defaults to 3306 if no port is specified.
-  The ``-username`` of the user to authenticate as.
-  The ``-password`` of the specified user to authenticate the connection.

The following code shows how a connection to a MySQL data source hosted on the
same machine as Lasso might appear::

   inline(
      -host=(: 
         -datasource='mysqlds', 
         -name='localhost', 
         -port='3306', 
         -username='username', 
         -password='password'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-oracle:

Oracle Data Source
==================

Lasso 9 can communicate with an Oracle service running on a host machine via a
TCP/IP connection. For more information on Oracle, visit
`<http://www.oracle.com/>`_.


Requirements
------------

-  Oracle Database 10g
-  The Lasso 9 machine must have the Oracle “Instant Client” installed if Lasso
   9 and Oracle are running on seprate machines. The instant client can be
   downloaded from the following web site. (Make sure to download just the basic
   instant client files rather than the complete Oracle 10g client or database
   installation.)
   `<http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html>`_


Installing Oracle Instant Client
--------------------------------

OS X
   -  Download version 10.0.2.4 of the Instant Client for OS X.
   -  Decompress the archive, which will create a folder "instantclient_10_2"
   -  Copy the contents of folder into "/usr/local/oracle/lib/"
   -  Execute the following command to create symbolic links so that Lasso can
      find the Oracle libraries. (Using "sudo" will require that you enter your
      password in order to continue.)

      .. code-block:: none

         $> sudo ln -sf /usr/local/oracle/lib/* /usr/local/lib/

   -  Execute the following command to create a symbolic link to the
      "libclntsh.dylib.10.1" so that Lasso can load the library:

      .. code-block:: none

         $> sudo ln -s /usr/local/lib/libclntsh.dylib.10.1 /usr/local/lib/libclntsh.dylib

Linux
   -  Download version 11.2.0.2.0 of the Instant Client for Linux
   -  Decompress the archive, which will create a folder "instantclient_11_2"
   -  Copy the contents of the folder into "/usr/local/oracle/lib/"
   -  Execute the following command to create symbolic links so that Lasso can
      find the Oracle libraries. (Using "sudo" will require that you enter your
      password in order to continue.)

      .. code-block:: none

         $> sudo ln -sf /usr/local/oracle/lib/* /usr/local/lib/

   -  Execute the following command to create a symbolic link to the
      "libclntsh.so.11.1 "so that Lasso can load the library::

         $> sudo ln -s /usr/local/lib/libclntsh.so.11.1 /usr/local/lib/libclntsh.so

.. note::
   Links to third party distributions and tools are provided for your
   convenience and were accurate when this manual was written. LassoSoft cannot
   be responsible for the availability or suitability of software downloaded
   from third party web sites.


Configuring Oracle
------------------

The Oracle database server must be configured with a user which has access to
all of the databases, tables, and other resources which will be published
through Lasso. Consult the Oracle documentation for help configuring Oracle's
built-in security. The Oracle website has a "Getting Started" section which
explains how to install and perform basic configuration of an Oracle database
server. `<http://www.oracle.com/pls/db111/portal.portal_db>`_


Adding an Oracle Data Source Host
---------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the :ref:`Configuring Datasources
<instance-administration-datasources>` section.

To add a new Oracle host:

#. In the Datasources area of Lasso Server Admin, click the "oracle" item.
#. Click the "Add host" button to reveal the host connection form.
#. Enter the IP address or domain name where the Oracle data sources are being
   hosted, the port, and database name using the ":/" format in the "Host"
   field (e.g. "www.example.com:1521/Mydatabase").
#. Enter the TCP port of the Oracle service in the "Port" field. This is
   commonly 1521 for Oracle.
#. Select "Yes" from the "Enabled" pull-down menu to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Select the "Add Host" button.
#. Once the host is added, the new host appears in the "Hosts Listing" below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the "Enabled"
drop-down to "No". With the Oracle Server data source added here, ``inline``
methods can use the ``-database`` parameter to specify the name of the Oracle
database to perform an action on.


Specifying Oracle Hosts in Inlines
----------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is fully controlled. However, it can sometimes be
beneficial to access a data source host without a lot of configuration. This
section describes how to construct an ``inline`` method which access an Oracle
data source host. See the :ref:`Inline Connection Overview<inline-hosts>`
section for full details about inline host specification.

To access an Oracle host directly in an ``inline`` method, the ``-host``
parameter can be used to specify all of the connection parameters. The ``-host``
parameter takes an array that should contain the following elements:

-  The ``-datasource`` should be specified as "oracle".
-  The ``-name`` should be specified as the IP address or domain name of the
   machine hosting Oracle, followed by a colon and the port to connect on, and 
   ending with a slash and the database name (e.g.
   "www.example.com:1521/Mydatabase").
-  The ``-port`` is optional and defaults to 1521 if no port is specified.
-  The ``-username`` of the user to authenticate as.
-  The ``-password`` of the specified user to authenticate the connection.

The following code shows how a connection to an Oracle data source might
appear::

   inline(
      -host=(: 
         -datasource='oracle', 
         -name='oracle.example.com:1521/mydatabase', 
         -port='1521', 
         -username='username', 
         -password='password'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-postgresql:

PostgreSQL Data Source
======================

Lasso 9 can communicate with Postgres servers configured to accept TCP/IP client
connections. For more information on Postgres, visit
`<http://www.postgresql.org/>`_.

Requirements
------------

-  PostgreSQL 8.x
-  The Lasso 9 machine must have the PostgreSQL libpq library installed.


Configuring PostgreSQL
----------------------

The PostgreSQL database server must be configured with a user which has access
to all of the databases, tables, and other resources which will be published
through Lasso. Consult the PostgreSQL documentation for help configuring
PostgreSQL's built-in security: `<http://www.postgresql.org/docs/manuals/>`_


Adding a PostgreSQL Data Source Host
------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the :ref:`Configuring Datasources
<instance-administration-datasources>` section.

To add a new PostgreSQL server host:

#. In the Datasources area of Lasso Server Admin, click the "PostgreSQL" item.
#. Click the "Add host" button to reveal the host connection form.
#. Enter the IP address or domain name where the PostgreSQL data source is being
   hosted in the "Host" field.
#. Enter the TCP port the PostgreSQL service is listening on in the "Port"
   field. This is commonly 5432 for PostgreSQL.
#. Select "Yes" from the "Enabled" pull-down menu to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Select the "Add Host" button.
#. Once the host is added, the new host appears in the Hosts Listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the "Enabled"
drop-down to "No". With the PostgreSQL data source added here, ``inline``
methods can use the ``-database`` parameter to specify the name of the
PostgreSQL database to perform an action on.


Specifying PostgreSQL Hosts in Inlines
--------------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is fully controlled. However, it can sometimes be
beneficial to access a data source host without a lot of configuration. This
section describes how to construct an ``inline`` method which access a
PostgreSQL data source host. See the :ref:`Inline Connection Overview
<inline-hosts>` section for full details about inline host specification.

To access a PostgreSQL host directly in an ``inline`` method, the ``-host``
parameter can be used to specify all of the connection parameters. The ``-host``
parameter takes an array that should contain the following elements:

-  The ``-datasource`` should be specified as "postgres".
-  The ``-name`` should be specified as the IP address or domain name of the
   machine hosting PostgreSQL.
-  The ``-port`` is optional and defaults to 5432 if no port is specified.
-  The ``-username`` of the user to authenticate as.
-  The ``-password`` of the specified user to authenticate the connection.

The following code shows how a connection to a PostgreSQL data source hosted on
the same machine as Lasso might appear::

   inline(
      -host=(: 
         -datasource='postgres',
         -name='localhost',
         -port='5432',
         -username='username', 
         -password='password'
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

Lasso 9 can communicate with any ODBC compliant data source as long as the
operating system has a compatible ODBC driver properly installed. For more
information on ODBC, see the documentation included with your operating system.


Requirements
------------

-  An ODBC driver which has been configured as a System DSN in the ODBC control
   panel.

Windows
   ODBC data sources are configured using the "ODBC Data Source Administrator"
   which is normally accessed through "Settings > Control Panels >
   Administrative Tools > Data Sources (ODBC)". Lasso can access data sources
   configured as System DSNs.

OS X
   ODBC data sources are configured using the ODBC Administrator which can be
   found in the "/Applications/Utilities" folder. Lasso can access data sources
   configured as System DSNs.

Linux
   Consult the documentation of the ODBC drivers for information about how to
   set up data sources on Linux. Many ODBC drivers ship with a control panel
   which allows configuration of those drivers. Lasso can access data sources
   configured as System DSNs.


Configuring ODBC Hosts
----------------------

Consult the documentation for your data sources and ODBC drivers for details
about how to secure access to the data made available through the driver. Most
data sources will require the following steps:

#. Install your ODBC driver using the provided installer or instructions.
#. Create a System DSN in the ODBC administration application. Note that the
   System DSN name, username, and password which are configured here will need
   to be entered in Lasso.
#. Locate and configure the SQL.ini file for your driver. This file sets the
   options for your ODBC driver including the location of your data source.
   Consult your driver's documentation for details about where to find this file
   and what options can be configured.
#. Follow the steps below to add the data source to Lasso.


Adding an ODBC Data Source Host
-------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the :ref:`Configuring Datasources
<instance-administration-datasources>` section.

To add a new ODBC host:

#. In the "Datasources" area of Lasso Server Admin, click the "ODBC" item.
#. Click the "Add host" button to reveal the host connection form.
#. Enter the System DSN name of the ODBC connection in the "Host" field.
#. Enter the TCP port of the ODBC connection in the "Port" field.
#. Select "Yes" from the "Enabled" pull-down menu to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Select the "Add Host" button.
#. Once the host is added, the new host appears in the Hosts Listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the "Enabled"
drop-down to "No". With the ODBC data source added here, ``inline`` methods can
use the ``-database`` parameter to specify the name of the database to perform
an action on.


Specifying ODBC Hosts in Inlines
--------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is fully controlled. However, it can sometimes be
beneficial to access a data source host without a lot of configuration. This
section describes how to construct an ``inline`` method which access an ODBC
data source host. See the :ref:`Inline Connection Overview <inline-hosts>`
section for full details about inline host specification.

To access an ODBC host directly in an ``inline`` method, the ``-host`` parameter
can be used to specify all of the connection parameters. The ``-host`` parameter
takes an array that should contain the following elements:

-  The ``-datasource`` should be specified as "odbc".
-  The ``-name`` should be specified as the System DSN.
-  The ``-username`` of the user to authenticate as, if required.
-  The ``-password`` of the specified user to authenticate the connection, if
   required.

The following code shows how a connection to an ODBC data source hosted on the
same machine as Lasso might appear::

   inline(
      -host=(: 
         -datasource='odbc',
         -name='System_DSN_Name',
         -username='username', 
         -password='password'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-sql-server:

SQL Server Data Source
======================

Lasso 9 can communicate with Microsoft SQL Server databases configured to accept TCP/IP client
connections. For more information on SQL Server, visit
`<http://www.microsoft.com/en-us/sqlserver/>`_.

Requirements
------------

-  Microsoft SQL Server 2005-2012
-  The Lasso 9 machine must have the SQL Server client libraries installed.
   
   Windows
      The necessary client libraries should already be installed
   
   OS X and Linux
      The FreeTDS libraries need to be compiled and installed. The source can be
      found here: `<http://www.freetds.org>`_. (Instead of compiling from
      source, you may want to check for installing via a package manager such
      as "apt", "yum", or "homebrew".)


Configuring SQL Server
----------------------

The SQL Server database server must be configured with a user that has access
to all of the databases, tables, and other resources which will be published
through Lasso. Consult the SQL Server documentation for help configuring its
built-in security:
`<http://www.microsoft.com/en-us/sqlserver/learning-center/resources.aspx>`_


Adding a SQL Server Data Source Host
------------------------------------

For general information about navigating Lasso Server Admin and adding a host to
a data source, see the :ref:`Configuring Data Sources
<instance-administration-datasources>` section.

To add a new SQL Server database host:

#. In the "Datasources" area of Lasso Server Admin, click the "SQLServer" item.
#. Click the "Add host" button to reveal the host connection form.
#. Enter the IP address or domain name where the SQL Server data source is being
   hosted followed by a backslash and the name of a database in the "Host"
   field. (e.g. "www.example.com\MyDataBase")
#. Enter the TCP port the SQL Server service is listening on in the "Port"
   field. This is commonly 1433 for SQL Server.
#. Select "Yes" from the "Enabled" pull-down menu to enable the host.
#. Enter a username for the host in the "Username" field. Lasso will connect to
   the data source and all databases therein using this username by default.
#. Enter a password for the host in the "Password" field. Lasso will connect to
   the data source and all databases therein using this password by default.
#. Select the "Add Host" button.
#. Once the host is added, the new host appears in the Hosts Listing below.

Databases in newly created hosts are enabled by default. The administrator can
disable databases by expanding the database listing and setting the "Enabled"
drop-down to "No". With the SQL Server data source added here, ``inline``
methods can use the ``-database`` parameter to specify the name of the
SQL Server database to perform an action on.


Specifying SQL Server Hosts in Inlines
--------------------------------------

Setting up a data source host in Lasso Server Admin is the best way to ensure
that access to the data source is fully controlled. However, it can sometimes be
beneficial to access a data source host without a lot of configuration. This
section describes how to construct an ``inline`` method which access a SQL
Server data source host. See the :ref:`Inline Connection Overview<inline-hosts>`
section for full details about inline host specification.

To access a SQL Server host directly in an ``inline`` method, the ``-host``
parameter can be used to specify all of the connection parameters. The ``-host``
parameter takes an array that should contain the following elements:

-  The ``-datasource`` should be specified as "sqlserver".
-  The ``-name`` should be specified as the IP address or domain name of the
   machine hosting SQL Server.
-  The ``-port`` is optional and defaults to 1433 if no port is specified.
-  The ``-username`` of the user to authenticate as.
-  The ``-password`` of the specified user to authenticate the connection.

The following code shows how a connection to a SQL Server data source hosted on
the same machine as Lasso might appear::

   inline(
      -host=(: 
         -datasource='sqlserver',
         -name='(local)\MYDB',
         -username='username', 
         -password='password'
      ),
      -findAll,
      -database='database',
      -table='table'
   ) => {^
      found_count
   ^}


.. _datasource-setup-sqlite:

SQLite Data Source
==================

Lasso Server comes with an embedded high-performance data source called SQLite.
This data source is used to store Lasso's internal site preferences and security
settings. SQLite is installed, enabled, and pre-configured within Lasso Server
by default. No further set up or installation of SQLite is required.

SQLite databases are stored in the SQLiteDBs folder within each instance's
folder. By default this folder contains databases that are required for Lasso
Server to function. Custom databases may be created and added to this folder and
Lasso ``inline`` methods will automatically have access to them using the
``-database`` parameter.