.. ljapi-methods:

***********************
LJAPI Types and Methods
***********************


Methods
=======

.. method:: ljapi_initialize()

   This method creates a Java Virtual Machine for the running Lasso thread. A
   Lasso Server instance calls this method when it starts up.

.. method:: java_jvm_getenv(...)

   This is the wrapper method for the ``java_jnienv`` object associated with the
   Lasso instance's Java Virtual Machine. This is the method you will use to
   access the Java Native Interface functions documented as member methods of
   ``java_jnienv``.


Main Lasso Type
===============

.. class:: java_jnienv
.. method:: java_jnienv()

   This type creates an object that is used to call Java Native Interface (JNI)
   functions. These functions are all documented in the JNI documentation here:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html>`_

   For your convenience, the sections below are arranged in the same order and
   grouping as the JNI documentation.


Version
-------

.. method:: java_jnienv->GetVersion(...)

   Returns the version of the Java Natitive Interface. See the documentation for
   more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp15951>`_


Class Operations
----------------

.. method:: java_jnienv->FindClass(...)

   Returns a reference to a Java class. It takes a string of the fully-qualified
   class name or array type signature. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16027>`_


Exceptions
----------

.. method:: java_jnienv->Throw(...)

   Throws a Java error (java.lang.Throwable). It takes a ``jobject`` thrown
   error reference and returns a ``jint``. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16086>`_

.. method:: java_jnienv->ThrowNew(...)

   Creates and throws a Java error with the message passed to it. It takes a
   ``jobject`` class reference to use to create the error, and a string with the
   error message. It returns a ``jint``. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16104>`_

.. method:: java_jnienv->ExceptionOccurred(...)

   Returns whether or not a Java exception was thrown. See the documentation for
   more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16124>`_

.. method:: java_jnienv->ExceptionDescribe(...)

   Outputs the error and stack trace for the Java exception.
   http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16146

.. method:: java_jnienv->ExceptionClear(...)

   Clears any exceptions that have been thrown. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16166>`_

.. method:: java_jnienv->FatalError(...)

   Throws a fatal error to the JVM. It takes a string as the error message. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16186>`_

.. method:: java_jnienv->ExceptionCheck(...)

   Returns true if a Java exception has been thrown, otherwise returns false.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16270>`_


Global and Local References
---------------------------

.. method:: java_jnienv->NewGlobalRef(...)

   Creates a global reference from the specified object. It takes a ``jobject``
   reference to an object and returns a new ``jobject`` global object reference.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#NewGlobalRef>`_

.. method:: java_jnienv->DeleteGlobalRef(...)

   Removes the specified global reference. It takes a ``jobject`` reference to a
   global object. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#DeleteGlobalRef>`_

.. method:: java_jnienv->DeleteLocalRef(...)

   Removes the specified local reference. It takes a ``jobject`` reference to an
   object. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#DeleteLocalRef>`_


Object Operations
-----------------

.. method:: java_jnienv->AllocObject(...)

   Allocates a Java object without calling any of the constructor methods. It
   takes a ``jobject`` class reference (like the return value of
   ``java_jnienv->FindClass``). It returns a reference to the object. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16337>`_

.. method:: java_jnienv->NewObject(...)

   Allocates and constructs a Java object. It takes a ``jobject`` class
   reference to the new object's class, a ``jmethodid`` reference to the
   constructor method to use, and any other parameters as required by the Java
   constructor method. It returns a reference to the object. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4517>`_

.. method:: java_jnienv->GetObjectClass(...)

   This method returns a class reference for the specified object. It takes a
   ``jobject`` object reference. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16454>`_

.. method:: java_jnienv->IsInstanceOf(...)

   Returns true if the specified object is an instance of the specified class,
   otherwise returns false. It takes a ``jobject`` object reference and a
   ``jobject`` class reference. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16472>`_

.. method:: java_jnienv->IsSameObject(...)

   Returns true if both specified objects refer to the same Java object,
   otherwise false. It takes two ``jobject`` object references. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16514>`_


Accessing Fields of Objects
---------------------------

.. method:: java_jnienv->GetFieldId(...)

   Returns the field ID of a Java object's instance field. It takes a
   ``jobject`` class reference, a string with the value of the field's name, and
   a string of the signature for the field. It returns a ``jfieldid`` reference.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16540>`_

.. method:: java_jnienv->GetObjectField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java objects. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a
   ``jobject`` object reference. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetBooleanField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are boolean primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a
   boolean. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetByteField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java byte primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a
   ``jbyte``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetCharField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java char primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a
   ``jchar``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetShortField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java short primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a
   ``jshort``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetIntField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java int primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a
   ``jint``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetLongField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java long primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a Lasso
   integer. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetFloatField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java float primitives. It takes in a
   ``jobject`` object reference and a ``jfieldid`` reference and returns a Lasso
   decimal. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->GetDoubleField(...)

   Returns the value of the specified Java object instance field. This method
   should be used for field values that are Java double primitives. It takes in
   a ``jobject`` object reference and a ``jfieldid`` reference and returns a
   Lasso decimal. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16572>`_

.. method:: java_jnienv->SetObjectField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java objects. It takes a ``jobject``
   object reference, a ``jfieldid`` reference, and the new ``jobject`` value for
   the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetBooleanField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java boolean primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new boolean
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetByteField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java byte primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new ``jbyte``
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetCharField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java char primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new ``jchar``
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetShortField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java short primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new
   ``jshort`` value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetIntField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java int primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new ``jint``
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetLongField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java long primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new integer
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetFloatField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java float primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new
   ``jfloat`` value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_

.. method:: java_jnienv->SetDoubleField(...)

   Sets the value of the specified Java object instance field. This method
   should be used for fields that contain Java double primitives. It takes a
   ``jobject`` object reference, a ``jfieldid`` reference, and the new decimal
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16613>`_


Calling Instance Methods
------------------------

.. method:: java_jnienv->GetMethodID(...)

   Returns a ``jmethodid`` Lasso object for the Java object's specified instance
   member method. For constructor methods, use "<init>" as the method name. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16660>`_

.. method:: java_jnienv->CallVoidMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the method doesn't return a value. It takes a
   ``jobject`` object reference, a ``jmethodid``, and any parameters to be
   passed to the instance method. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallObjectMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java object returned as
   a Lasso ``jobject`` object referece. It takes a ``jobject`` object reference,
   a ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallBooleanMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a boolean value. It takes
   a ``jobject`` object reference, a ``jmethodid``, and any parameters to be
   passed to the instance method. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallByteMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java byte primitive. It
   takes a ``jobject`` object reference, a ``jmethodid``, and any parameters to
   be passed to the instance method. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallCharMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java char primitve. It
   takes a ``jobject`` object reference, a ``jmethodid``, and any parameters to
   be passed to the instance method. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallShortMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java short primitive.
   It takes a ``jobject`` object reference, a ``jmethodid``, and any parameters
   to be passed to the instance method. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallIntMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java int primitive. It
   takes a ``jobject`` object reference, a ``jmethodid``, and any parameters to
   be passed to the instance method. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallLongMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java long primitive. It
   takes a ``jobject`` object reference, a ``jmethodid``, and any parameters to
   be passed to the instance method. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallFloatMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java float primitive.
   It takes a ``jobject`` object reference, a ``jmethodid``, and any parameters
   to be passed to the instance method. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallDoubleMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java double primitive.
   It takes a ``jobject`` object reference, a ``jmethodid``, and any parameters
   to be passed to the instance method. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256>`_

.. method:: java_jnienv->CallNonvirtualVoidMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when there will be no return value. It takes a
   ``jobject`` object reference, a ``jobject`` class reference, a ``jmethodid``,
   and any parameters to be passed to the instance method. See the documentation
   for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualObjectMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java object. It takes a
   ``jobject`` object reference, a ``jobject`` class reference, a ``jmethodid``,
   and any parameters to be passed to the instance method. See the documentation
   for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualBooleanMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a boolean. It takes a
   ``jobject`` object reference, a ``jobject`` class reference, a ``jmethodid``,
   and any parameters to be passed to the instance method. See the documentation
   for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualByteMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java byte primitive. It
   takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualCharMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java char primitive. It
   takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualShortMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java short primitive.
   It takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualIntMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java int primitive. It
   takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualLongMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java long primitive. It
   takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualFloatMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java float primitive.
   It takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_

.. method:: java_jnienv->CallNonvirtualDoubleMethod(...)

   This method calls the specified Java instance method with the expected
   parameters passed as the remaining Lasso parameters to this method. This
   method should be used when the return value will be a Java double primitive.
   It takes a ``jobject`` object reference, a ``jobject`` class reference, a
   ``jmethodid``, and any parameters to be passed to the instance method. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4581>`_


Accessing Static Fields
-----------------------

.. method:: java_jnienv->GetStaticFieldID(...)

   Returns a ``jfieldid`` reference to a Java class's static field. It takes a
   ``jobject`` class reference, a string with the value of the field's name, and
   a string of the signature for the field. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16823>`_

.. method:: java_jnienv->GetStaticObjectField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java objects. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a
   ``jobject`` object reference. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticBooleanField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are boolean primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a
   boolean. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticByteField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java byte primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a
   ``jbyte``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticCharField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java char primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a
   ``jchar``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticShortField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java short primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a
   ``jshort``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticIntField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java int primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a
   ``jint``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticLongField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java long primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a Lasso
   integer. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticFloatField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java float primitives. It takes in a
   ``jobject`` class reference and a ``jfieldid`` reference and returns a Lasso
   decimal. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->GetStaticDoubleField(...)

   Returns the value of the specified Java class static field. This method
   should be used for field values that are Java double primitives. It takes in
   a ``jobject`` class reference and a ``jfieldid`` reference and returns a
   Lasso decimal. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20752>`_

.. method:: java_jnienv->SetStaticObjectField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java objects. It takes a ``jobject`` class
   reference, a ``jfieldid`` reference, and the new ``jobject`` value for the
   field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticBooleanField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java boolean primitives. It takes a
   ``jobject`` class reference, a ``jfieldid`` reference, and the new boolean
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticByteField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java byte primitives. It takes a ``jobject``
   class reference, a ``jfieldid`` reference, and the new ``jbyte`` value for
   the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticCharField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java char primitives. It takes a ``jobject``
   class reference, a ``jfieldid`` reference, and the new ``jchar`` value for
   the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticShortField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java short primitives. It takes a ``jobject``
   class reference, a ``jfieldid`` reference, and the new ``jshort`` value for
   the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticIntField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java int primitives. It takes a ``jobject``
   class reference, a ``jfieldid`` reference, and the new ``jint`` value for the
   field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticLongField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java long primitives. It takes a ``jobject``
   class reference, a ``jfieldid`` reference, and the new integer value for the
   field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticFloatField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java float primitives. It takes a ``jobject``
   class reference, a ``jfieldid`` reference, and the new ``jfloat`` value for
   the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_

.. method:: java_jnienv->SetStaticDoubleField(...)

   Sets the value of the specified Java class static field. This method should
   be used for fields that contain Java double primitives. It takes a
   ``jobject`` class reference, a ``jfieldid`` reference, and the new decimal
   value for the field. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20829>`_


Calling Static Methods
----------------------

.. method:: java_jnienv->GetStaticMethodID(...)

   Returns a ``jmethodid`` Lasso object for the specified static method. It
   takes a ``jobject`` class reference, a string specifying the name of the
   method, and a string of the method's signature. See the documentation for
   more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20950>`_

.. method:: java_jnienv->CallStaticVoidMethod(...)

   This method is used to call a Java class static method that doesn't return a
   value. It takes a ``jobject`` class reference, a ``jmethodid`` for the
   method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticObjectMethod(...)

   This method is used to call a Java class static method that returns a Java
   object. It takes a ``jobject`` class reference, a ``jmethodid`` for the
   method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticBooleanMethod(...)

   This method is used to call a Java class static method that returns a Java
   boolean. It takes a ``jobject`` class reference, a ``jmethodid`` for the
   method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticByteMethod(...)

   This method is used to call a Java class static method that returns a Java
   byte primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticCharMethod(...)

   This method is used to call a Java class static method that returns a Java
   char primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticShortMethod(...)

   This method is used to call a Java class static method that returns a Java
   short primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticIntMethod(...)

   This method is used to call a Java class static method that returns a Java
   int primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticLongMethod(...)

   This method is used to call a Java class static method that returns a Java
   long primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticFloatMethod(...)

   This method is used to call a Java class static method that returns a Java
   float primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_

.. method:: java_jnienv->CallStaticDoubleMethod(...)

   This method is used to call a Java class static method that returns a Java
   double primitive. It takes a ``jobject`` class reference, a ``jmethodid`` for
   the method, and any parameters to be passed to the static method. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4796>`_


String Operations
-----------------

.. method:: java_jnienv->NewString(...)

   Takes in a Lasso string and returns a Lasso ``jobject`` that corresponds to a
   Java object of class ``java.lang.String``. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4925>`_

.. method:: java_jnienv->GetStringLength(...)

   Returns the number of characters in the specified Java string object. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17132>`_

.. method:: java_jnienv->GetStringChars(...)

   It takes a ``jobject`` of a Java string and returns a Lasso string object.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17158>`_


Array Operations
----------------

.. method:: java_jnienv->GetArrayLength(...)

   Returns the number of elements in the specified Java array. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21732>`_

.. method:: java_jnienv->NewObjectArray(...)

   Returns a ``jobject`` of a Java array containing Java objects of the
   specified class. It takes the length of the array, a ``jobject`` class
   reference for the type of objects in the array, and the initial value to set
   each item in the array to. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21619>`_

.. method:: java_jnienv->GetObjectArrayElement(...)

   Returns the specified element of a Java object array. It takes the
   ``jobject`` containing the array and an integer specifying the index into the
   array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21671>`_

.. method:: java_jnienv->SetObjectArrayElement(...)

   Sets the value at the specified index of the specified Java object array. It
   takes a ``jobject`` of the array, an integer specifying the index into the
   array, and the new ``jobject`` object. See the documentation for more
   information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp21699>`_

.. method:: java_jnienv->NewBooleanArray(...)

   Returns a ``jobject`` of a Java array containing Java booleans. It takes the
   length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewByteArray(...)

   Returns a ``jobject`` of a Java array containing Java byte primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewCharArray(...)

   Returns a ``jobject`` of a Java array containing Java char primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewShortArray(...)

   Returns a ``jobject`` of a Java array containing Java short primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewIntArray(...)

   Returns a ``jobject`` of a Java array containing Java int primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewLongArray(...)

   Returns a ``jobject`` of a Java array containing Java long primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewFloatArray(...)

   Returns a ``jobject`` of a Java array containing Java float primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->NewDoubleArray(...)

   Returns a ``jobject`` of a Java array containing Java double primitives. It
   takes the length of the array. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17318>`_

.. method:: java_jnienv->GetBooleanArrayElements(...)

   Takes a ``jobject`` Java boolean array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetByteArrayElements(...)

   Takes a ``jobject`` Java byte array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetCharArrayElements(...)

   Takes a ``jobject`` Java char array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetShortArrayElements(...)

   Takes a ``jobject`` Java short array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetIntArrayElements(...)

   Takes a ``jobject`` Java int array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetLongArrayElements(...)

   Takes a ``jobject`` Java long array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetFloatArrayElements(...)

   Takes a ``jobject`` Java float array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetDoubleArrayElements(...)

   Takes a ``jobject`` Java double array and returns a Lasso staticarray of the
   elements. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp17382>`_

.. method:: java_jnienv->GetBooleanArrayRegion(...)

   Returns the specified region of elements from a Java boolean array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetByteArrayRegion(...)

   Returns the specified region of elements from a Java byte array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetCharArrayRegion(...)

   Returns the specified region of elements from a Java char array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetShortArrayRegion(...)

   Returns the specified region of elements from a Java short array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetIntArrayRegion(...)

   Returns the specified region of elements from a Java int array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetLongArrayRegion(...)

   Returns the specified region of elements from a Java long array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetFloatArrayRegion(...)

   Returns the specified region of elements from a Java float array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->GetDoubleArrayRegion(...)

   Returns the specified region of elements from a Java double array in a Lasso
   staticarray. It takes a ``jobject`` of the array, an integer for the start
   index of the array region, and an integer specifying the number of elements. 
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp6212>`_

.. method:: java_jnienv->SetBooleanArrayRegion(...)

   Replaces the specified portion of a Java boolean array with the values
   specified in a Lasso static array. It takes a ``jobject`` of the array, an
   integer for the start index of the array region, an integer specifying the
   numer of elements to replace, and a staticarray containing the values to use.
   See the documentation for more information:   
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetByteArrayRegion(...)

   Replaces the specified portion of a Java byte array with the values specified
   in a Lasso static array. It takes a ``jobject`` of the array, an integer for
   the start index of the array region, an integer specifying the numer of
   elements to replace, and a staticarray containing the values to use. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetCharArrayRegion(...)

   Replaces the specified portion of a Java char array with the values specified
   in a Lasso static array. It takes a ``jobject`` of the array, an integer for
   the start index of the array region, an integer specifying the numer of
   elements to replace, and a staticarray containing the values to use. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetShortArrayRegion(...)

   Replaces the specified portion of a Java short array with the values
   specified in a Lasso static array. It takes a ``jobject`` of the array, an
   integer for the start index of the array region, an integer specifying the
   numer of elements to replace, and a staticarray containing the values to use.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetIntArrayRegion(...)

   Replaces the specified portion of a Java int array with the values specified
   in a Lasso static array. It takes a ``jobject`` of the array, an integer for
   the start index of the array region, an integer specifying the numer of
   elements to replace, and a staticarray containing the values to use. See the
   documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetLongArrayRegion(...)

   Replaces the specified portion of a Java long array with the values
   specified in a Lasso static array. It takes a ``jobject`` of the array, an
   integer for the start index of the array region, an integer specifying the
   numer of elements to replace, and a staticarray containing the values to use.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetFloatArrayRegion(...)

   Replaces the specified portion of a Java float array with the values
   specified in a Lasso static array. It takes a ``jobject`` of the array, an
   integer for the start index of the array region, an integer specifying the
   numer of elements to replace, and a staticarray containing the values to use.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_

.. method:: java_jnienv->SetDoubleArrayRegion(...)

   Replaces the specified portion of a Java double array with the values
   specified in a Lasso static array. It takes a ``jobject`` of the array, an
   integer for the start index of the array region, an integer specifying the
   numer of elements to replace, and a staticarray containing the values to use.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp22933>`_


Monitor Operations
------------------

.. method:: java_jnienv->MonitorEnter(...)

   Enters into the monitor associated with the specified Java object. Requires a
   non-null ``jobject`` object. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp23124>`_

.. method:: java_jnienv->MonitorExit(...)

   Decrements the monitor counter for the current thread and the specified Java
   object. Requires a non-null ``jobject`` object. See the documentation for
   more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp5252>`_


Reflection Support
------------------

.. method:: java_jnienv->FromReflectedMethod(...)

   Converts a specified Java reflection object into a Lasso ``jmethodid``. See
   the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#from_reflected_method>`_

.. method:: java_jnienv->FromReflectedField(...)

   Converts a specified Java reflection field object into a lasso ``jfieldid``.
   See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#from_reflected_field>`_

.. method:: java_jnienv->ToReflectedMethod(...)

   Converts a specified Lasso ``jmethodid`` to a Java reflection object returned
   as a ``jobject``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#to_reflected_method>`_

.. method:: java_jnienv->ToReflectedField(...)

   Converts a specified Lasso ``jfieldid`` to a Java reflection field object
   returned as a ``jobject``. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#to_reflected_field>`_



Return Types
============

.. class:: jobject
.. method:: jobject()
   
   Stores a reference to either a Java class, instantiated object, or thrown
   error. See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/types.html#wp15954>`_

.. class:: jmethodid
.. method:: jmethodid()

   Stores the JNI ID for a specific method (both member methods and class
   methods). See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/types.html#wp1064>`_

.. class:: jfieldid 
.. method:: jfieldid()

   Stores the JNI ID for data field members of a class (both an object's and the
   class's). See the documentation for more information:
   `<http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/types.html#wp1064>`_


Helper Types for Java Data Primatives
=====================================

.. class:: jfloat
.. method:: jfloat(val::decimal)
.. method:: jfloat(val::integer)
.. method:: jfloat(val::jfloat)

   Creat an object that can be passed to a Java method as a Java float
   primitive.

.. class:: jint
.. method:: jint(val::integer)

   Creat an object that can be passed to a Java method as a Java integer
   primitive.

.. class:: jshort
.. method:: jshort(val::integer)

   Creat an object that can be passed to a Java method as a Java short
   primitive.

.. class:: jchar
.. method:: jchar(val::string)

   Creat an object that can be passed to a Java method as a Java char
   primitive.

.. class:: jchararray
.. method:: jchararray(val::string)

   Creat an object that can be passed to a Java method as a Java array of char
   primitives.

.. class:: jbyte
.. method:: jbyte(val::bytes)

   Creat an object that can be passed to a Java method as a Java byte
   primitive.

.. class:: jbytearray
.. method:: jbytearray(val::bytes)

   Creat an object that can be passed to a Java method as a Java array of byte
   primitives.