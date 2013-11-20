.. default-domain:: c
.. default-role:: func
.. highlight:: c++
.. _lcapi-types:

********************
Creating Lasso Types
********************

Creating a new Lasso type in LCAPI is similar to creating a custom method. When
Lasso Server starts up, it scans the "LassoModules" directory for module files
(Windows DLLs, OS X DYLIBs, or Linux SOs). As it encounters each module, it
executes the ``registerLassoModule`` function for that module. The developer
registers the LCAPI types or methods implemented by the module inside this
function. Registering type initializers differs from registering normal methods
in that the third parameter in `lasso_registerTagModule` is the value
"REG_FLAGS_TYPE_DEFAULT"::

   void registerLassoModule()
   {
      lasso_registerTagModule( "test", "type", myTypeInitFunc,
         REG_FLAGS_TYPE_DEFAULT, "simple test LCAPI type" );
   }

The prototype of an LCAPI type initializer is the same as a regular LCAPI custom
method function. Lasso will call the type initializer each time a new instance
of the type is created::

   osError myTypeInitFunc( lasso_request_t token, tag_action_t action );

When the type initializer function is called, a new instance of the type is
created using `lasso_typeAllocCustom`. This new instance will be created without
data members or member methods::

   osError myTypeInitFunc( lasso_request_t token, tag_action_t action );
   {
      lasso_type_t theNewInstance = NULL;
      lasso_typeAllocCustom( token, &theNewInstance, "test_type" );

Once the type is created, new data members and member methods can be added to it
using `lasso_typeAddMember`. Data members can be of any type and should be
allocated using any of the LCAPI type allocation calls. Member methods are
allocated using `lasso_typeAllocTag`. LCAPI member method functions are
implemented just like any other LCAPI method. In the example below,
``myTagMemberFunction`` is a function with the standard LCAPI prototype::

      const char * kStringData = "This is a string member.";
      lasso_type_t stringMember = NULL;
      lasso_typeAllocString( token, &stringMember, kStringData, strlen(kStringData) );
      lasso_typeAddDataMember( token, theNewInstance, "member1", stringMember );

      lasso_type_t tagMember = NULL;
      lasso_typeAllocTag( token, &tagMember, myTagMemberFunction );
      lasso_typeAddMember( token, theNewInstance, "member2", tagMember );

The final step in creating a new LCAPI type instance is to return the new type
to Lasso as the initializer's return value. After the type is returned, Lasso
will complete the creation of the type by instantiating the new type's parent
types::

      lasso_returnTagValue( token, theNewInstance );
      return osErrNoErr;
   }


Basic Custom Type Example
=========================

This tutorial walks through the main points of creating a custom type using
LCAPI. The resulting type is an ``example_file`` type, and the ability to open,
close, read and write to the file are implemented via the following member
methods: ``example_file->open``, ``example_file->close``,
``example_file->read``, ``example_file->write``.

.. only:: html

   The example project is the "CAPIFile" project in the LCAPI examples found
   :download:`here <../_downloads/lcapi_examples.zip>`. Due to the length of the
   code in that file, the entire code is not reproduced here. Instead, this
   section provides a conceptual overview of the ``example_file`` type and
   describes the basic LCAPI functions used to implement it.

.. only:: latex

   The example project is the "CAPIFile" project in the LCAPI examples found
   `here <http://lassoguide.com/_downloads/lcapi_examples.zip>`_. Due to the
   length of the code in that file, the entire code is not reproduced here.
   Instead, this section provides a conceptual overview of the ``example_file``
   type and describes the basic LCAPI functions used to implement it.

#. The first step in creating a custom type is to register the type's
   initializer. Type initializers are registered in the same way that regular
   method functions are registered. The only difference being that
   "REG_FLAGS_TYPE_DEFAULT" should be passed for the fourth (flags) parameter.

   This concept is illustrated in lines 247--282 of the :file:`CAPIFile.cpp`
   file::

      void registerLassoModule()
      {
         ...
         lasso_registerTagModule("", kFileTypeName, file_init,
            REG_FLAGS_TYPE_DEFAULT, "Initializer for the file type.");
      }

#. The registered type initializer will be called when the module is loaded. In
   the above case, the LCAPI function ``file_init`` was registered as being the
   initializer. The prototype for ``file_init`` should look like any other LCAPI
   function, as shown on line 285 of the :file:`CAPIFile.cpp` file::

      osError file_init(lasso_request_t token, tag_action_t action)

#. The ``file_init`` function will now be called whenever the module is loaded.
   Within the type initializer, the type's member methods are added. Each member
   method is implemented by its own LCAPI function. However, before members can
   be added, the new blank type must be created using `lasso_typeAllocCustom`.

   You can only use `lasso_typeAllocCustom` within a properly registered type
   initializer. The value it produces should always be the return value of the
   method as set by the `lasso_returnTagValue` function. See lines 289--290 of
   the :file:`CAPIFile.cpp` file::

      lasso_type_t file;
      lasso_typeAllocCustom(token, &file, kFileTypeName);

#. Once the blank type has been created, members can be added to it. LCAPI types
   often need to store pointers to allocated structures or memory. LCAPI
   provides a means to accomplish this by using the `lasso_setPtrMember` and
   `lasso_getPtrMember` functions. These functions allow the developer to store
   a pointer with a specific name. The pointer is stored as a regular integer
   data member. The names of all pointer members should begin with an
   underscore. Naming a pointer as such will indicate to Lasso that it should
   not be copied when a copy is made of the type instance. In the initializer
   function, you need to add the integer data member as seen on lines 293--295::

      lasso_type_t i;
      lasso_typeAllocInteger(token, &i, 0);
      lasso_typeAddDataMember(token, file, kPrivateMember, i);

   This LCAPI ``example_file`` type stores its private data in a structure
   called ``file_desc_t``. The actual call to `lasso_setPtrMember` is in the
   method's ``onCreate`` method as shown on lines 344--345 of the
   :file:`CAPIFile.cpp` file::

      file_desc_t * desc = new file_desc_t;
      lasso_setPtrMember(token, self, kPrivateMember, desc, &cleanUp);

#. Member methods for ``open``, ``close``, ``read``, and ``write`` could be
   written like this::

      lasso_type_t mem;
      lasso_typeAllocTag(token, &mem, file_open);
      lasso_typeAddMember(token, file, "open", mem);

      lasso_typeAllocTag(token, &mem, file_close);
      lasso_typeAddMember(token, file, "close", mem);

      lasso_typeAllocTag(token, &mem, file_read);
      lasso_typeAddMember(token, file, "read", mem);

      lasso_typeAllocTag(token, &mem, file_write);
      lasso_typeAddMember(token, file, "write", mem);

   But to avoid the repetitive nature of this, the :file:`CAPIFile.cpp` file
   defines a macro named ``ADD_TAG`` to do the work as seen on lines 300--309::

      #define ADD_TAG(NAME, FUNC) {
         lasso_type_t mem;\
         lasso_typeAllocTag(token, &mem, FUNC);\
         lasso_typeAddMember(token, file, NAME, mem);\
      }

      // Add the type's member tags
      ADD_TAG(kMemOpen, file_open);
      ADD_TAG(kMemClose, file_close);
      ADD_TAG(kMemRead, file_read);
      ADD_TAG(kMemWrite, file_write);

#. At this point, the return value should be set. Keep in mind that the new
   ``example_file`` type is completely blank except for the members that were
   added above. No inherited members are available at this point. Inherited
   members are only added after the LCAPI type initializer returns. Line 324 of
   the :file:`CAPIFile.cpp` file sets the return value::

      lasso_returnTagValue(token, file);

#. There were no errors in the type initialization process, so return a "no
   error" code to Lasso, completing the type's initialization. See line 325 of
   the :file:`CAPIFile.cpp` file::

      return osErrNoErr;

   .. note::
      For brevity, this example will not cover accepting parameters in the
      type's ``onCreate`` method. The full "CAPIFile" project illustrates
      accepting parameters in the ``onCreate`` member method to open the file
      under various read and write permissions.

#. The new file type has now been initialized and made available to the caller
   in the script. The first member method of the file type is
   ``example_file->open``, which is implemented as the LCAPI function
   ``file_open`` beginning on line 385 of the :file:`CAPIFile.cpp` file::

      osError file_open(lasso_request_t token, tag_action_t action)
      {

#. The first step in implementing a member method is to acquire the "self"
   instance. The "self" is the instance upon which the member call was made.
   This is illustrated on lines 387--390 of the :file:`CAPIFile.cpp` file::

      lasso_type_t self = NULL;
      lasso_getTagSelf(token, &self);
      if(!self)
         return osErrInvalidParameter;

#. Once the "self" is successfully acquired and is not "null", the rest of the
   member method can proceed. This member method accepts one parameter, which is
   the path to the file that will be opened. Since the path is a string value,
   it can be acquired using `lasso_getTagParam`. If the path parameter was not
   passed to the open member method, an error should be returned and indicated
   to the user. All of this can be seen on lines 400--418 of the
   :file:`CAPIFile.cpp` file::

      // See what parameters we are being initialized with
      int count;
      lasso_getTagParamCount(token, &count);

      if( count < 2 )
      {
         lasso_setResultMessage(token, "file->open requires at least a file path and open mode.");
         return osErrInvalidParameter;
      }

      if( count > 0 ) // We are given *at the least* a path
      {
         // First param is going to be a string, so use the LCAPI 5 call to get it
         auto_lasso_value_t pathParam;
         pathParam.name = "";
         lasso_getTagParam(token, 0, &pathParam);

         desc->fPath = pathParam.name;
      }

#. Once the path is properly converted, the actual file can be opened using the
   file system calls supplied by the operating system. This concept is
   illustrated on line 225 of the :file:`CAPIFile.cpp` file::

      FILE * f = fopen(xformPath, openMode);

#. The ``FILE`` pointer can now be retrieved using the `lasso_typeGetCustomPtr`
   LCAPI function. No error has occurred while opening the file, so complete the
   function call and return "no error". See line 449 of the :file:`CAPIFile.cpp`
   file::

      return osErrNoErr;

#. The remaining method functions are implemented in a similar manner. Study the
   CAPIFile example for a more in-depth and complete example of how to properly
   construct custom Lasso types in LCAPI.
