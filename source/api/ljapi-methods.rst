.. _ljapi-methods:

*********************************
Lasso Types and Methods for LJAPI
*********************************

This chapter provides a reference to all of the types and functions in LJAPI.


Methods
=======

.. method:: ljapi_initialize()

   Creates a Java Virtual Machine for the running Lasso thread. A Lasso Server
   instance calls this method when it starts up.

.. method:: java_jvm_getenv(...)

   This is the wrapper method for the :type:`java_jnienv` object associated with
   the Lasso instance's Java Virtual Machine. This is the method you will use to
   access the Java Native Interface functions documented as member methods of
   :type:`java_jnienv`.


Main Lasso Type
===============

.. type:: java_jnienv
.. method:: java_jnienv()

   This type creates an object that is used to call Java Native Interface (JNI)
   functions. These functions are all documented in the `JNI documentation
   <http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html>`_.

   For your convenience, the sections below are arranged in the same order and
   grouping as the JNI documentation.


Version
-------

.. member:: java_jnienv->GetVersion(...)

   Returns the version of the Java Native Interface.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp15951>`_
   for more information.


Class Operations
----------------

.. member:: java_jnienv->FindClass(...)

   Returns a reference to a Java class. It takes a string of the fully qualified
   class name or array type signature.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16027>`_
   for more information.


Exceptions
----------

.. member:: java_jnienv->Throw(...)

   Throws a Java error (java.lang.Throwable). It takes a :type:`jobject` thrown
   error reference and returns a :type:`jint`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16086>`_
   for more information.

.. member:: java_jnienv->ThrowNew(...)

   Creates and throws a Java error with the message passed to it. It takes a
   :type:`jobject` class reference to use to create the error, and a string with
   the error message. It returns a :type:`jint`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16104>`_
   for more information.

.. member:: java_jnienv->ExceptionOccurred(...)

   Returns whether or not a Java exception was thrown.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16124>`_
   for more information.

.. member:: java_jnienv->ExceptionDescribe(...)

   Outputs the error and stack trace for the Java exception.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16146>`_
   for more information.

.. member:: java_jnienv->ExceptionClear(...)

   Clears any exceptions that have been thrown.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16166>`_
   for more information.

.. member:: java_jnienv->FatalError(...)

   Throws a fatal error to the JVM. It takes a string as the error message.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16186>`_
   for more information.

.. member:: java_jnienv->ExceptionCheck(...)

   Returns "true" if a Java exception has been thrown, otherwise returns
   "false".

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16270>`_
   for more information.


Global and Local References
---------------------------

.. member:: java_jnienv->NewGlobalRef(...)

   Creates a global reference from the specified object. It takes a
   :type:`jobject` reference to an object and returns a new :type:`jobject`
   global object reference.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#NewGlobalRef>`_
   for more information.

.. member:: java_jnienv->DeleteGlobalRef(...)

   Removes the specified global reference. It takes a :type:`jobject` reference
   to a global object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#DeleteGlobalRef>`_
   for more information.

.. member:: java_jnienv->DeleteLocalRef(...)

   Removes the specified local reference. It takes a :type:`jobject` reference
   to an object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#DeleteLocalRef>`_
   for more information.


Object Operations
-----------------

.. member:: java_jnienv->AllocObject(...)

   Allocates a Java object without calling any of the constructor methods. It
   takes a :type:`jobject` class reference (like the return value of
   `java_jnienv->FindClass`). It returns a reference to the object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16337>`_
   for more information.

.. member:: java_jnienv->NewObject(...)

   Allocates and constructs a Java object. It takes a :type:`jobject` class
   reference to the new object's class, a :type:`jmethodid` reference to the
   constructor method to use, and any other parameters as required by the Java
   constructor method. It returns a reference to the object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4517>`_
   for more information.

.. member:: java_jnienv->GetObjectClass(...)

   Returns a class reference for the specified object. It takes a
   :type:`jobject` object reference.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16454>`_
   for more information.

.. member:: java_jnienv->IsInstanceOf(...)

   Returns "true" if the specified object is an instance of the specified class,
   otherwise returns "false". It takes a :type:`jobject` object reference and a
   :type:`jobject` class reference.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16472>`_
   for more information.

.. member:: java_jnienv->IsSameObject(...)

   Returns "true" if both specified objects refer to the same Java object,
   otherwise returns "false". It takes two :type:`jobject` object references.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16514>`_
   for more information.


Accessing Fields of Objects
---------------------------

.. member:: java_jnienv->GetFieldID(...)

   Returns the field ID of a Java object's instance field. It takes a
   :type:`jobject` class reference, a string with the value of the field's name,
   and a string of the signature for the field. It returns a :type:`jfieldid`
   reference.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16540>`_
   for more information.

.. member:: java_jnienv->GetObjectField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java objects. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a :type:`jobject` object reference.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetBooleanField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are boolean primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a boolean.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetByteField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java byte primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a :type:`jbyte`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetCharField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java char primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a :type:`jchar`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetShortField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java short primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a :type:`jshort`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetIntField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java int primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a :type:`jint`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetLongField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java long primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a Lasso integer.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetFloatField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java float primitives. It takes in a
   :type:`jobject` object reference and a :type:`jfieldid` reference and returns
   a Lasso decimal.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->GetDoubleField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java double primitives. It takes in
   a :type:`jobject` object reference and a :type:`jfieldid` reference and
   returns a Lasso decimal.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_
   for more information.

.. member:: java_jnienv->SetObjectField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java objects. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   :type:`jobject` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetBooleanField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java boolean primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   boolean value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetByteField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java byte primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   :type:`jbyte` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetCharField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java char primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   :type:`jchar` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetShortField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java short primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   :type:`jshort` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetIntField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java int primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   :type:`jint` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetLongField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java long primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   integer value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetFloatField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java float primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   :type:`jfloat` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.

.. member:: java_jnienv->SetDoubleField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java double primitives. It takes a
   :type:`jobject` object reference, a :type:`jfieldid` reference, and the new
   decimal value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_
   for more information.


Calling Instance Methods
------------------------

.. member:: java_jnienv->GetMethodID(...)

   Returns a :type:`jmethodid` Lasso object for the Java object's specified
   instance member method. For constructor methods, use "<init>" as the method
   name.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16660>`_
   for more information.

.. member:: java_jnienv->CallVoidMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the method doesn't return a value. It takes a :type:`jobject` object
   reference, a :type:`jmethodid`, and any parameters to be passed to the
   instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallObjectMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java object returned as a Lasso
   :type:`jobject` object reference. It takes a :type:`jobject` object
   reference, a :type:`jmethodid`, and any parameters to be passed to the
   instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallBooleanMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a boolean value. It takes a :type:`jobject`
   object reference, a :type:`jmethodid`, and any parameters to be passed to the
   instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallByteMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java byte primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallCharMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java char primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallShortMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java short primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallIntMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java int primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallLongMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java long primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallFloatMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java float primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallDoubleMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java double primitive. It takes a
   :type:`jobject` object reference, a :type:`jmethodid`, and any parameters to
   be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualVoidMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when there will be no return value. It takes a :type:`jobject` object
   reference, a :type:`jobject` class reference, a :type:`jmethodid`, and any
   parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualObjectMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java object. It takes a :type:`jobject`
   object reference, a :type:`jobject` class reference, a :type:`jmethodid`, and
   any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualBooleanMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a boolean. It takes a :type:`jobject` object
   reference, a :type:`jobject` class reference, a :type:`jmethodid`, and any
   parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualByteMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java byte primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualCharMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java char primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualShortMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java short primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualIntMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java int primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualLongMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java long primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualFloatMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java float primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.

.. member:: java_jnienv->CallNonvirtualDoubleMethod(...)

   Calls the specified Java instance method with the expected parameters passed
   as the remaining Lasso parameters to this method. This method should be used
   when the return value will be a Java double primitive. It takes a
   :type:`jobject` object reference, a :type:`jobject` class reference, a
   :type:`jmethodid`, and any parameters to be passed to the instance method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_
   for more information.


Accessing Static Fields
-----------------------

.. member:: java_jnienv->GetStaticFieldID(...)

   Returns a :type:`jfieldid` reference to a Java class's static field. It takes
   a :type:`jobject` class reference, a string with the value of the field's
   name, and a string of the signature for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16823>`_
   for more information.

.. member:: java_jnienv->GetStaticObjectField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java objects. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a :type:`jobject` object reference.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticBooleanField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are boolean primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a boolean.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticByteField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java byte primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a :type:`jbyte`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticCharField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java char primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a :type:`jchar`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticShortField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java short primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a :type:`jshort`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticIntField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java int primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a :type:`jint`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticLongField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java long primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a Lasso integer.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticFloatField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java float primitives. It takes in a
   :type:`jobject` class reference and a :type:`jfieldid` reference and returns
   a Lasso decimal.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->GetStaticDoubleField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java double primitives. It takes in
   a :type:`jobject` class reference and a :type:`jfieldid` reference and
   returns a Lasso decimal.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_
   for more information.

.. member:: java_jnienv->SetStaticObjectField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java objects. It takes a :type:`jobject`
   class reference, a :type:`jfieldid` reference, and the new :type:`jobject`
   value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticBooleanField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java boolean primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   boolean value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticByteField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java byte primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   :type:`jbyte` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticCharField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java char primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   :type:`jchar` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticShortField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java short primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   :type:`jshort` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticIntField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java int primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   :type:`jint` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticLongField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java long primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   integer value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticFloatField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java float primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   :type:`jfloat` value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.

.. member:: java_jnienv->SetStaticDoubleField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java double primitives. It takes a
   :type:`jobject` class reference, a :type:`jfieldid` reference, and the new
   decimal value for the field.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_
   for more information.


Calling Static Methods
----------------------

.. member:: java_jnienv->GetStaticMethodID(...)

   Returns a :type:`jmethodid` Lasso object for the specified static method. It
   takes a :type:`jobject` class reference, a string specifying the name of the
   method, and a string of the method's signature.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20950>`_
   for more information.

.. member:: java_jnienv->CallStaticVoidMethod(...)

   This method is used to call a Java class static method that doesn't return a
   value. It takes a :type:`jobject` class reference, a :type:`jmethodid` for
   the method, and any parameters to be passed to the static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticObjectMethod(...)

   This method is used to call a Java class static method that returns a Java
   object. It takes a :type:`jobject` class reference, a :type:`jmethodid` for
   the method, and any parameters to be passed to the static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticBooleanMethod(...)

   This method is used to call a Java class static method that returns a Java
   boolean. It takes a :type:`jobject` class reference, a :type:`jmethodid` for
   the method, and any parameters to be passed to the static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticByteMethod(...)

   This method is used to call a Java class static method that returns a Java
   byte primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticCharMethod(...)

   This method is used to call a Java class static method that returns a Java
   char primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticShortMethod(...)

   This method is used to call a Java class static method that returns a Java
   short primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticIntMethod(...)

   This method is used to call a Java class static method that returns a Java
   int primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticLongMethod(...)

   This method is used to call a Java class static method that returns a Java
   long primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticFloatMethod(...)

   This method is used to call a Java class static method that returns a Java
   float primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.

.. member:: java_jnienv->CallStaticDoubleMethod(...)

   This method is used to call a Java class static method that returns a Java
   double primitive. It takes a :type:`jobject` class reference, a
   :type:`jmethodid` for the method, and any parameters to be passed to the
   static method.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_
   for more information.


String Operations
-----------------

.. member:: java_jnienv->NewString(...)

   Takes in a Lasso string and returns a Lasso :type:`jobject` that corresponds
   to a Java object of class ``java.lang.String``.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4925>`_
   for more information.

.. member:: java_jnienv->GetStringLength(...)

   Returns the number of characters in the specified Java string object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17132>`_
   for more information.

.. member:: java_jnienv->GetStringChars(...)

   Takes in a :type:`jobject` of a Java string and returns a Lasso string
   object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17158>`_
   for more information.


Array Operations
----------------

.. member:: java_jnienv->GetArrayLength(...)

   Returns the number of elements in the specified Java array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21732>`_
   for more information.

.. member:: java_jnienv->NewObjectArray(...)

   Returns a :type:`jobject` of a Java array containing Java objects of the
   specified class. It takes the length of the array, a :type:`jobject` class
   reference for the type of objects in the array, and the initial value to set
   each item in the array to.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21619>`_
   for more information.

.. member:: java_jnienv->GetObjectArrayElement(...)

   Returns the specified element of a Java object array. It takes the
   :type:`jobject` containing the array and an integer specifying the index into
   the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21671>`_
   for more information.

.. member:: java_jnienv->SetObjectArrayElement(...)

   Sets the value at the specified index of the specified Java object array. It
   takes a :type:`jobject` of the array, an integer specifying the index into
   the array, and the new :type:`jobject` object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21699>`_
   for more information.

.. member:: java_jnienv->NewBooleanArray(...)

   Returns a :type:`jobject` of a Java array containing Java booleans. It takes
   the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewByteArray(...)

   Returns a :type:`jobject` of a Java array containing Java byte primitives. It
   takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewCharArray(...)

   Returns a :type:`jobject` of a Java array containing Java char primitives. It
   takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewShortArray(...)

   Returns a :type:`jobject` of a Java array containing Java short primitives.
   It takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewIntArray(...)

   Returns a :type:`jobject` of a Java array containing Java int primitives. It
   takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewLongArray(...)

   Returns a :type:`jobject` of a Java array containing Java long primitives. It
   takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewFloatArray(...)

   Returns a :type:`jobject` of a Java array containing Java float primitives.
   It takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->NewDoubleArray(...)

   Returns a :type:`jobject` of a Java array containing Java double primitives.
   It takes the length of the array.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_
   for more information.

.. member:: java_jnienv->GetBooleanArrayElements(...)

   Takes a :type:`jobject` Java boolean array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetByteArrayElements(...)

   Takes a :type:`jobject` Java byte array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetCharArrayElements(...)

   Takes a :type:`jobject` Java char array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetShortArrayElements(...)

   Takes a :type:`jobject` Java short array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetIntArrayElements(...)

   Takes a :type:`jobject` Java int array and returns a Lasso staticarray of the
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetLongArrayElements(...)

   Takes a :type:`jobject` Java long array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetFloatArrayElements(...)

   Takes a :type:`jobject` Java float array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetDoubleArrayElements(...)

   Takes a :type:`jobject` Java double array and returns a Lasso staticarray of
   the elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_
   for more information.

.. member:: java_jnienv->GetBooleanArrayRegion(...)

   Returns the specified region of elements from a Java boolean array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetByteArrayRegion(...)

   Returns the specified region of elements from a Java byte array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetCharArrayRegion(...)

   Returns the specified region of elements from a Java char array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetShortArrayRegion(...)

   Returns the specified region of elements from a Java short array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetIntArrayRegion(...)

   Returns the specified region of elements from a Java int array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetLongArrayRegion(...)

   Returns the specified region of elements from a Java long array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetFloatArrayRegion(...)

   Returns the specified region of elements from a Java float array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->GetDoubleArrayRegion(...)

   Returns the specified region of elements from a Java double array in a Lasso
   staticarray. It takes a :type:`jobject` of the array, an integer for the
   start index of the array region, and an integer specifying the number of
   elements.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_
   for more information.

.. member:: java_jnienv->SetBooleanArrayRegion(...)

   Replaces the specified portion of a Java boolean array with the values
   specified in a Lasso staticarray. It takes a :type:`jobject` of the array, an
   integer for the start index of the array region, an integer specifying the
   number of elements to replace, and a staticarray containing the values to
   use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetByteArrayRegion(...)

   Replaces the specified portion of a Java byte array with the values specified
   in a Lasso staticarray. It takes a :type:`jobject` of the array, an integer
   for the start index of the array region, an integer specifying the number of
   elements to replace, and a staticarray containing the values to use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetCharArrayRegion(...)

   Replaces the specified portion of a Java char array with the values specified
   in a Lasso staticarray. It takes a :type:`jobject` of the array, an integer
   for the start index of the array region, an integer specifying the number of
   elements to replace, and a staticarray containing the values to use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetShortArrayRegion(...)

   Replaces the specified portion of a Java short array with the values
   specified in a Lasso staticarray. It takes a :type:`jobject` of the array, an
   integer for the start index of the array region, an integer specifying the
   number of elements to replace, and a staticarray containing the values to use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetIntArrayRegion(...)

   Replaces the specified portion of a Java int array with the values specified
   in a Lasso staticarray. It takes a :type:`jobject` of the array, an integer
   for the start index of the array region, an integer specifying the number of
   elements to replace, and a staticarray containing the values to use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetLongArrayRegion(...)

   Replaces the specified portion of a Java long array with the values
   specified in a Lasso staticarray. It takes a :type:`jobject` of the array, an
   integer for the start index of the array region, an integer specifying the
   number of elements to replace, and a staticarray containing the values to
   use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetFloatArrayRegion(...)

   Replaces the specified portion of a Java float array with the values
   specified in a Lasso staticarray. It takes a :type:`jobject` of the array, an
   integer for the start index of the array region, an integer specifying the
   number of elements to replace, and a staticarray containing the values to
   use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.

.. member:: java_jnienv->SetDoubleArrayRegion(...)

   Replaces the specified portion of a Java double array with the values
   specified in a Lasso staticarray. It takes a :type:`jobject` of the array, an
   integer for the start index of the array region, an integer specifying the
   number of elements to replace, and a staticarray containing the values to
   use.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_
   for more information.


Monitor Operations
------------------

.. member:: java_jnienv->MonitorEnter(...)

   Enters into the monitor associated with the specified Java object. Requires a
   non-null :type:`jobject` object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp23124>`_
   for more information.

.. member:: java_jnienv->MonitorExit(...)

   Decrements the monitor counter for the current thread and the specified Java
   object. Requires a non-null :type:`jobject` object.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp5252>`_
   for more information.


Reflection Support
------------------

.. member:: java_jnienv->FromReflectedMethod(...)

   Converts a specified Java reflection object into a Lasso :type:`jmethodid`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#from_reflected_method>`_
   for more information.

.. member:: java_jnienv->FromReflectedField(...)

   Converts a specified Java reflection field object into a Lasso
   :type:`jfieldid`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#from_reflected_field>`_
   for more information.

.. member:: java_jnienv->ToReflectedMethod(...)

   Converts a specified Lasso :type:`jmethodid` to a Java reflection object
   returned as a :type:`jobject`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#to_reflected_method>`_
   for more information.

.. member:: java_jnienv->ToReflectedField(...)

   Converts a specified Lasso :type:`jfieldid` to a Java reflection field object
   returned as a :type:`jobject`.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#to_reflected_field>`_
   for more information.


Return Types
============

.. type:: jobject
.. method:: jobject()

   Stores a reference to either a Java class, instantiated object, or thrown
   error.

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/types.html#wp15954>`_
   for more information.

.. type:: jmethodid
.. method:: jmethodid()

   Stores the JNI ID for a specific method (both member methods and class
   methods).

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/types.html#wp1064>`_
   for more information.

.. type:: jfieldid
.. method:: jfieldid()

   Stores the JNI ID for data field members of a class (both an object's and the
   class's).

   See
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/types.html#wp1064>`_
   for more information.


Helper Types for Java Data Primitives
=====================================

.. type:: jfloat
.. method:: jfloat(value::decimal)
.. method:: jfloat(value::integer)
.. method:: jfloat(value::jfloat)

   Creates an object that can be passed to a Java method as a Java float
   primitive.

.. type:: jint
.. method:: jint(value::integer)

   Creates an object that can be passed to a Java method as a Java integer
   primitive.

.. type:: jshort
.. method:: jshort(value::integer)

   Creates an object that can be passed to a Java method as a Java short
   primitive.

.. type:: jchar
.. method:: jchar(value::string)

   Creates an object that can be passed to a Java method as a Java char
   primitive.

.. type:: jchararray
.. method:: jchararray(value::string)

   Creates an object that can be passed to a Java method as a Java array of char
   primitives.

.. type:: jbyte
.. method:: jbyte(value::bytes)

   Creates an object that can be passed to a Java method as a Java byte
   primitive.

.. type:: jbytearray
.. method:: jbytearray(value::bytes)

   Creates an object that can be passed to a Java method as a Java array of byte
   primitives.
