.. _lcapi-sources:

******************
LCAPI Data Sources
******************

When Lasso Server starts up, it looks for module files (Windows DLLs, OS X
DYLIBs, or Linux SOs) in the LassoModules folder. As Lasso encounters each
module, it executes the module’s ``registerLassoModule()`` function once and
only once. It is your job as an LCAPI developer to write code to register each
of your new data source function entry points in this ``registerLassoModule()``
function. Both custom methods and data sources may be registered at the same
time, and the code for them can reside in the same module. The only difference
between registering a data source and a custom method is whether you call
``lasso_registerTagModule()`` or ``lasso_registerDSModule()``.

Data sources are a bit more complex than custom methods because Lasso calls them
with many different actions during the course of various database operations.
Whereas a custom method only needs to know how to format itself, a data source
needs to enumerate its tables, search through records, add new records, delete
records, etc. Even so, this added complexity is easily handled with a single
``switch()`` statement, as you will see in the following tutorial.


Data Source Connectors and Lasso Server Administration
======================================================

Once a custom data source connector module is registered by Lasso Server, it
will appear in the Datasources area of Lasso Server Administration. If a
connector appears here, then it has been installed correctly.

The administrator adds the data source connection information to the Hosts form,
which sets the parameters by which Lasso connects to the data source via the
connector. This information is stored in the site's database_registry SQLite
database, where the connector can retrieve and use the data via function calls.

The Hosts information includes the following:

Name
   The connection URL string to connect to a data source. This is typically the
   IP address or hostname of the machine hosting the data source.

Port
   The TCP/IP port number of the data source.

Enabled
   Allows administrators to enable or disable the connection to the data
   source.

Username
   The username Lasso needs to authenticate to the data source.

Password
   The password Lasso needs to authenticate to the data source.

These values are passed to the data source via the ``lasso_getDataHost``
function, which is described later in this chapter::

   LCAPICALL osError lasso_getDataHost( lasso_request_t token,
      auto_lasso_value_t * host, auto_lasso_value_t * usernamepassword );


Data Source Connector Example
=============================

This section provides a walk-through of an example data source to show how some
of the LCAPI features are used. This code can be found in the SampleConnector
example project which can be downloaded with the other LCAPI examples
`here <http://lassoguide.com/_static/lcapi_examples.zip>`_.

This example data source simply displays some simple text as each action is
called from a Lasso inline. It is not an effective or useful data source; it’s
meant to just provide an overview of what functions must be implemented. The
sample data source will simulate a data source which has two databases, an
"Accounting" database and a "Customers" database. Each of those databases in
turn will report that it has a few tables within it. For a more complete example
of a data source that is useful, look at the SQLiteDS source code in the lasso
source code repository.


LCAPI Data Source Connector Code
--------------------------------

Below is the code for the Sample Data Source Connector::

   void registerLassoModule()
   {
      lasso_registerDSModule( "SampleDSConnector", sampleds_func, 0 );
      lasso_log(LOG_LEVEL_ALWAYS, "Loading Sample Data Source Connector");
   }

   osError sampleds_func( lasso_request_t token, datasource_action_t action, const auto_lasso_value_t * param )
   {
      osError err = osErrNoErr;
      auto_lasso_value_t v1, v2, notused;
      bool boolnotused = false;
      const char * ret;
      switch( action )
      {
         case datasourceInit:
            break;
         case datasourceTerm:
            break;
         case datasourceCloseConnection: // connections only get closed through here
            // Here's where you would gracefully close the connection
            break;
         case datasourceTickle:
            // 
            break;
         case datasourceNames:
            // Database Names
            lasso_addDataSourceResult(token, "Accounting");
            lasso_addDataSourceResult(token, "Customers");
            break;
         case datasourceTableNames:
            if( strcmp(param->data, "Accounting") == 0 ) {
               lasso_addDataSourceResultUTF8(token, "Payroll");
               lasso_addDataSourceResultUTF8(token, "Payables");
               lasso_addDataSourceResultUTF8(token, "Receivables");
            }
            if( strcmp(param->data, "Customers") == 0 ) {
               lasso_addDataSourceResultUTF8(token, "ContactInfo");
               lasso_addDataSourceResultUTF8(token, "ItemsPurchased");
            }
            break;
         case datasourceSearch:
         case datasourceFindAll:
            lasso_getDataSourceName(token, &v1, &boolnotused, &notused);
            lasso_getTableName(token, &v2);

            if( strcmp(v1.data, "Accounting") == 0 ) {
               int count, i;
               lasso_getInputColumnCount(token, &count);
               for( i=0; i < count; i++) {
                  auto_lasso_value_t columnItem;
                  lasso_getInputColumn(token, i, &columnItem);
               }
               if( strcmp(v2.data, "Payroll") == 0 ) {
                  const char ** values = new const char*[3];
                  unsigned long * sizes = new unsigned long[3];
                  values[0] = "Samuel Goldwyn";
                  values[1] = "1955-03-27";
                  values[2] = "15000.00";
                  sizes[0] = 14;
                  sizes[1] = 10;
                  sizes[2] =  8;
                  
                  lasso_addColumnInfo(token, "Employee" , true, lpTypeString  , kProtectionNone);
                  lasso_addColumnInfo(token, "StartDate", true, lpTypeDateTime, kProtectionNone);
                  lasso_addColumnInfo(token, "Wages"    , true, lpTypeDecimal , kProtectionNone);
                  
                  lasso_addResultRow(token, values, sizes, 3);
                  lasso_setNumRowsFound(token, 1);

                  delete [] sizes;
                  delete [] values;
               }
            }
            if( strcmp(v1.data, "Customers") == 0 ) {
            }
            break;
         
         case datasourceAdd:
            ret = "datasourceAdd was called to append a record<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         case datasourceUpdate:
            ret = "datasourceUpdate was called to replace a record<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         case datasourceDelete:
            ret = "datasourceDelete was called to remove a record<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         case datasourceInfo:
            ret = "datasourceInfo was called<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         case datasourcePrepareSQL:
            ret = "datasourcePrepareSQL was called<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         case datasourceUnprepareSQL:
            ret = "datasourceUnprepareSQL was called<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         case datasourceExecSQL:
            ret = "datasourceExecSQL was called<br />";
            lasso_returnTagValueString(token, ret, (int)strlen(ret));

         default:
            break;
      }

      return err;
   }


Data Source Connector Walk Through
----------------------------------

This section provides a step-by-step walk through of the code for the custom
data source connector.

#. Register the new data source in the ``registerLassoModule()`` function::

      void registerLassoModule()
      {
         lasso_registerDSModule( "SampleDSConnector", sampleds_func, 0 );
         lasso_log(LOG_LEVEL_ALWAYS, "Loading Sample Data Source Connector");
      }

#. Implement the ``sampleds_func`` function which gets called when any database
   operations for this data source are encountered::

      osError sampleds_func( lasso_request_t token, datasource_action_t action, const auto_lasso_value_t * param )

   All data source functions have this prototype. When your data source function
   is called, it’s passed an opaque "token" data structure, an integer "action"
   telling it what it should do, and an optional parameter which sometimes
   contains extra information (like a database name) needed by the action being
   requested at the time.

#. Set a default error return value to indicate no error. Returning a non-zero
   value will cause Lasso to report a fatal error and stop processing code We
   are also declaring a few temporary variables to be used later to retrieve
   values such as database names and table names::

      osError err = osErrNoErr;
      auto_lasso_value_t v1, v2, notused;
      bool boolnotused = false;
      const char * ret;

#. This function is called with various different actions passed to it as Lasso
   translates your data requests and updates to it. The ``switch`` statement is
   used with various enumerated values to determine the requested action::

      switch( action )
      {

#. The ``datasourceInit`` action is called once when Lasso Server starts up.
   This gives us a chance to initialize any communications with our database
   back-end, and do any inital setup if needed.

   The ``datasourceTerm`` action is called once when Lasso Server shuts down.
   This allows for any graceful cleanup that may necessary for your datasource.

   The ``datasourceCloseConnection`` action is called to close the connection to
   a data source.

   Because this data source is so simple, it needs no special initialization,
   shutdown code, or close connection code::

      case datasourceInit:
         break;
      case datasourceTerm:
         break;
      case datasourceCloseConnection: // connections only get closed through here
         // Here's where you would gracefully close the connection
         break;

#. The ``datasourceNames`` action is called whenever Lasso needs to get a list
   of databases that your data source provides access to. The developer must
   write code that discovers the list of all databases your datasource host
   "knows about" and call ``lasso_addDataSourceResult()`` once for each found
   database, passing the name of the database. If the data source has five
   databases, then you would call ``lasso_addDataSourceResult()`` five times. In
   our example, we have two databases::

      case datasourceNames:
         // Database Names
         lasso_addDataSourceResult(token, "Accounting");
         lasso_addDataSourceResult(token, "Customers");
         break;

#. Lasso will also need to know about all the tables each of the databases in
   your data source knows about, and for this it calls the function with the
   ``datasourceTableNames`` action passing the database name in the
   ``param->data`` value. In our example, we are adding three tables to the
   "Accounting" database and two to "Customers"::

      case datasourceTableNames:
         if( strcmp(param->data, "Accounting") == 0 ) {
            lasso_addDataSourceResultUTF8(token, "Payroll");
            lasso_addDataSourceResultUTF8(token, "Payables");
            lasso_addDataSourceResultUTF8(token, "Receivables");
         }
         if( strcmp(param->data, "Customers") == 0 ) {
            lasso_addDataSourceResultUTF8(token, "ContactInfo");
            lasso_addDataSourceResultUTF8(token, "ItemsPurchased");
         }
         break;

#. The ``datasourceSearch`` and ``datasourceFindAll`` actions are used to search
   a data source. All pertinent information (database and table names, search
   arguments, sort arguments, etc.) can be retrieved, and a search can be
   performed by calling various LCAPI functions such as
   ``lasso_getDataSourceName()`` and ``lasso_getTableName()`` to get the name of
   the database and table, respectively::

      case datasourceSearch:
      case datasourceFindAll:
         lasso_getDataSourceName(token, &v1, &boolnotused, &notused);
         lasso_getTableName(token, &v2);


#. In our example, only the "Payroll" table in the "Accounting" database has any
   data in it, so we have a conditional to check to see if the "Accounting"
   database was specified. We then use ``lasso_getInputColumnCount()`` to get
   the number of search fields passed to the ``inline``. We have a ``for`` loop
   to retrieve the name/value text for each search parameter. For example,
   ``inline( -Database='Accounting', -Table='Payroll', 'Employee'='fred', 'Wages'='15000')``
   will fill the ``columnItem`` variable with the values "Employee, fred" the
   first time through the loop, and "Wages, 15000" the second time through the
   loop::

      if( strcmp(v1.data, "Accounting") == 0 ) {
         int count, i;
         lasso_getInputColumnCount(token, &count);
         for( i=0; i < count; i++) {
            auto_lasso_value_t columnItem;
            lasso_getInputColumn(token, i, &columnItem);
         }

#. Next, set a conditional statement to ask if the "Payroll" table is being
   searched. If so, we’ll set up some fake hard-coded data in the next few lines
   of code. Declare an array of strings which represents the three fields we
   will return for this search. Declare an array of field sizes to match the
   lengths of the strings created on the previous line.

   The ``lasso_addColumnInfo`` function tells Lasso the column name and data
   type for a column. Call it once for each column and then call
   ``lasso_addResultRow`` with the values and their sizes to add a row to the
   result. Finally, the number of found rows must be specified using
   ``lasso_setNumRowsFound``::

      if( strcmp(v2.data, "Payroll") == 0 ) {
         const char ** values = new const char*[3];
         unsigned long * sizes = new unsigned long[3];
         values[0] = "Samuel Goldwyn";
         values[1] = "1955-03-27";
         values[2] = "15000.00";
         sizes[0] = 14;
         sizes[1] = 10;
         sizes[2] =  8;
         
         lasso_addColumnInfo(token, "Employee" , true, lpTypeString  , kProtectionNone);
         lasso_addColumnInfo(token, "StartDate", true, lpTypeDateTime, kProtectionNone);
         lasso_addColumnInfo(token, "Wages"    , true, lpTypeDecimal , kProtectionNone);
         
         lasso_addResultRow(token, values, sizes, 3);
         lasso_setNumRowsFound(token, 1);

         delete [] sizes;
         delete [] values;
      }

#. The rest of the actions simply return the fact that they had been called. In
   a real data source connector, you would add code for those actions to add,
   update, delete, and query data from the data source.