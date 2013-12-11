.. default-domain:: c
.. default-role:: func
.. _lcapi-methods:

**********************
Creating Lasso Methods
**********************

When Lasso first starts up, it looks for module files (Windows DLLs, OS X
DYLIBs, or Linux SOs) in its "LassoModules" directory. As it encounters each
module, it executes that module's ``registerLassoModule`` function once and only
once. LCAPI developers must write code to register each new custom method (or
type or data source connector) in this ``registerLassoModule`` function. The
following example function is required in every LCAPI module. It gets called
once when Lasso starts up:

.. code-block:: c++

   void registerLassoModule() {
      lasso_registerTagModule( "CAPITester", "testtag", myTagFunc,
         REG_FLAGS_TAG_DEFAULT, "simple test LCAPI tag" );
   }

The preceding example registers a C function named ``myTagFunc`` to execute
whenever the Lasso ``CAPITester_testtag`` method call is encountered in Lasso
code. The first parameter ``CAPITester`` is the namespace in which ``testtag``
will be placed.

Once the method function is registered, Lasso will call it at appropriate times
while parsing and executing Lasso code. The custom method functions will not be
called if none of the custom methods are encountered while executing a script.
When Lasso encounters one of your custom methods, it will be called with two
parameters: an opaque data structure called a ``token``, and an integer
``action`` which is currently unused. LCAPI provides many function calls that
can be used to get information about the environment, variables, parameters,
etc., when provided with a token.

The passed-in token can also be used to acquire any parameters and to return a
value from your custom method function.


Basic Custom Method Function
============================

Use the following C++ code:

.. code-block:: c++

   osError myTagFunc(lasso_request_t token, tag_action_t action)
   {
      const char * retString = "Hello, World!";
      return lasso_returnTagValueString(token, retString, strlen(retString));
   }

Below is the Lasso code needed to get the custom method to execute::

   <p>Here is the custom tag:</p>
   [CAPITester_testtag]
   <!-- This should display "Hello, World" when this page executes -->

This will produce:

.. code-block:: none

   Here is the custom tag:
   Hello, World


Custom Method Tutorial
======================

.. only:: html

   This section provides a walkthrough of building an example method to show how
   LCAPI features are used. This code can be found in the "SampleMethod" folder
   in the LCAPI examples, which can be :download:`downloaded here
   <../_downloads/lcapi_examples.zip>`.

.. only:: latex

   This section provides a walkthrough of building an example method to show how
   LCAPI features are used. This code can be found in the "SampleMethod" folder
   in the LCAPI examples, which can be `downloaded here
   <http://lassoguide.com/_downloads/lcapi_examples.zip>`_.

The method will simply display its parameters, and it will look like the example
below when called in Lasso code::

   sample_method('some text here', -option1='named param', -option2=12.5)

Notice the method takes one unnamed parameter, one string keyword parameter
``-option1``, and one numeric keyword parameter ``-option2``. For keyword
parameters, Lasso does not care about the order in which you pass them, so plan
to make this method as flexible as possible by not assuming anything about their
order. The following variations should work exactly the same::

   sample_method('some text here', -option1='named param', -option2=12.5)
   sample_method('some text here', -option2=12.5, -option1='named param')


LCAPI Method Module Code
------------------------

Below is the C++ code for the custom method:

.. code-block:: c++

   void registerLassoModule()
   {
      lasso_registerTagModule( "sample", "method", myTagFunc,
         REG_FLAGS_TAG_DEFAULT, "sample test" );
   }

   osError myTagFunc( lasso_request_t token, tag_action_t action )
   {
      std::basic_string<char> retValue;
      lasso_type_t opt2 = NULL;
      auto_lasso_value_t v;
      INITVAL(&v);

      if( lasso_findTagParam(token, "-option1", &v) == osErrNoErr ) {
         retValue.append("The value of -option1 is ");
         retValue.append(v.data);
      }

      if( lasso_findTagParam2(token, "-option2", &opt2) == osErrNoErr ) {
         double tempValue;
         char tempValueFmtd[128];

         lasso_typeGetDecimal(token, opt2, &tempValue);
         sprintf(tempValueFmtd, "%.15lg", tempValue);

         retValue.append(" The value of -option2 is ");
         retValue.append(tempValueFmtd);
      }

      int count = 0;
      lasso_getTagParamCount(token, &count);

      for( int i = 0; i < count; ++i )
      {
         lasso_getTagParam(token, i, &v);
         if( v.name == v.data ) {
            retValue.append(" The value of unnamed param is ");
            retValue.append(v.data);
         }
      }

      return lasso_returnTagValueString(token, retValue.c_str(), (int)retValue.length());
   }


Method Module Code Walkthrough
------------------------------

This section provides a step-by-step walkthrough of the code for the custom
method module.

#. First, the new method is registered in the required ``registerLassoModule``
   export function:

   .. code-block:: c++

      void registerLassoModule()
      {
         lasso_registerTagModule( "sample", "method", myTagFunc,
            REG_FLAGS_TAG_DEFAULT, "sample test" );
      }

#. Implement ``myTagFunc``, which gets called when ``sample_method`` is
   encountered. All method functions have this prototype. When the method
   function is called, it's passed an opaque ``token`` data structure.

   .. code-block:: c++

      osError myTagFunc( lasso_request_t token, tag_action_t action )
      {

   The remainder of the code in the walkthrough includes the implementation for
   the ``myTagFunc`` function.

#. Allocate a string to be this method's return value:

   .. code-block:: c++

      std::basic_string<char> retValue;

#. The `lasso_type_t` variable named "opt2" and the `auto_lasso_value_t`
   variable named "v" will be temporary variables for holding parameter values.
   Start off by initializing them:

   .. code-block:: c++

      lasso_type_t opt2 = NULL;
      auto_lasso_value_t v;
      INITVAL(&v);

#. Call `lasso_findTagParam` in order to get the value of the ``-option1``
   parameter. If it is found (no error while finding the named parameter),
   append some information about it to our return value string:

   .. code-block:: c++

      if( lasso_findTagParam(token, "-option1", &v) == osErrNoErr ) {
         retValue.append("The value of -option1 is ");
         retValue.append(v.data);
      }

#. Look for the other named parameter ``-option2`` and store its value into
   variable "opt2". Because ``-option2`` should be a decimal value, use
   `lasso_findTagParam2`, which will preserve the original data type of the
   value as opposed to converting it into a string like `lasso_findTagParam`
   will.

   .. code-block:: c++

      if( lasso_findTagParam2(token, "-option2", &opt2) == osErrNoErr ) {

#. Declare a temporary floating-point (double) value to hold the number passed
   in and then declare a temporary string to hold the converted number for
   display. Get the value of "opt2" as a decimal then print it to the
   "tempValueFmtd" variable.

   .. code-block:: c++

      double tempValue;
      char tempValueFmtd[128];

      lasso_typeGetDecimal(token, opt2, &tempValue);
      sprintf(tempValueFmtd, "%.15lg", tempValue);

#. Append the parameter's information to the return string:

   .. code-block:: c++

      retValue.append(" The value of -option2 is ");
      retValue.append(tempValueFmtd);

#. Now, we're going to look for the unnamed parameter. Because there's no way to
   ask for unnamed parameters, we're going to enumerate through all the
   parameters looking for one without a name. The integer "count" will hold the
   number of parameters found. Use `lasso_getTagParamCount` to find out how many
   parameters were passed into our method. The variable "count" now contains the
   number "3", if we were indeed passed three parameters.

   .. code-block:: c++

      int count = 0;
      lasso_getTagParamCount(token, &count);

      for( int i = 0; i < count; ++i )
      {

#. Use `lasso_getTagParam` to retrieve a parameter by its index. If you
   design methods that require parameters to be in a particular order, then use
   this function to retrieve parameters by index, starting at index 0. If the
   parameter is unnamed, that means it's the one needed. Note that if the user
   passes in more than one unnamed parameter, this loop will find all of them,
   and will ignore any named parameters. (A parameter is unnamed if both the
   name and data of the struct point to the same value.)

   .. code-block:: c++

      lasso_getTagParam(token, i, &v);
      if( v.name == v.data ) {

#. Again, append a descriptive line of text about the unnamed parameter and its
   value.

   .. code-block:: c++

      if( v.name == v.data ) {
         retValue.append(" The value of unnamed param is ");
         retValue.append(v.data);
      }

#. Returning an error code is very important. If you return a non-zero error
   code, then the interpreter will throw an exception indicating that this
   method failed fatally, causing Lasso's standard page error routines to
   display an error message. In our example, `lasso_returnTagValueString` will
   return an error if it has a problem setting the return value.

   .. code-block:: c++

      return lasso_returnTagValueString(token, retValue.c_str(), (int)retValue.length());
