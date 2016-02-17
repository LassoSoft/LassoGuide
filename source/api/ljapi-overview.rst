.. _ljapi-overview:

**************
LJAPI Overview
**************

.. index:: LJAPI

The :dfn:`Lasso Java Application Programming Interface` (LJAPI) allows you to
run Java code from within Lasso. This allows for custom Java code to be created
using Java's libraries that can then be run on all platforms Lasso supports. It
also gives you access to use Java's standard classes to create and manipulate
Java objects without writing a line of Java code.

The LJAPI functionality is implemented in an LCAPI module that bridges the C/C++
Java Native Interface (JNI) to Lasso. See the Oracle website for more
information about `interoperating with Java using JNI`_.


Requirements
============

-  Lasso Server installed on a supported OS
-  Java installed
-  Any other OS-specific packages required for Java support in Lasso installed


Executing a Static Method
=========================

Static methods are methods that are associated with a class, but are not run on
an instantiated object of that class. This example will walk you through running
the Java static class method ``Math.scalb``. This method takes in a floating
point and an integer and returns the value of multiplying the float by 2 to the
power of the integer.

.. note::
   If you are running the example code in a shell script or via the command-line
   interpreter instead of in a Lasso Server instance, you'll need to load the
   LJAPI environment. This can be done with the following two lines of code
   (replace "LJAPI9.dylib" with the name of the library for your OS's
   installation). See the section :ref:`command-loading-libraries` in the
   :ref:`command-line-tools` chapter for more information. ::

      lcapi_loadModule((sys_masterHomePath || sys_homePath) + '/LassoModules/LJAPI9.dylib')
      ljapi_initialize


Static Method Code
------------------

::

   local(class) = java_jvm_getenv->FindClass('java/lang/Math')
   local(mID)   = java_jvm_getenv->GetStaticMethodID(#class, 'scalb', '(FI)F')

   java_jvm_getenv->CallStaticFloatMethod(#class, #mID, jfloat(4.0), jint(3))

   // => 32.000000


Static Method Walkthrough
-------------------------

One thing to notice is that all the communication is done using
`java_jvm_getenv`. This method returns the :type:`java_jnienv` object for the
Lasso instance, and it is this object that allows Lasso to communicate with the
Java Virtual Machine (JVM).

#. The first line of code finds the Java class we want to work with and returns
   a Lasso :type:`jobject`; storing it into the local variable "class". The
   string value that gets passed to `~java_jnienv->FindClass` is the fully
   qualified class name signature (or array type signature). For more
   information, see the `FindClass`_ documentation. ::

      local(class) = java_jvm_getenv->FindClass('java/lang/Math')

#. The next line of code looks up the method ID for the method we want to
   execute and returns it as a :type:`jmethodid` type; storing it into the "mID"
   variable. `~java_jnienv->GetStaticMethodID` takes in the class (jobject)
   object we found in the first line, the name of the method as the second
   parameter, and the signature for that method as the third parameter. For more
   information, see the `GetStaticMethodID`_ documentation. ::

      local(mID)   = java_jvm_getenv->GetStaticMethodID(#class, 'scalb', '(FI)F')

#. The method signature ``(FI)F`` specifies that it takes a float and an int
   parameter and returns a float. The easiest way to find the signature for a
   method is to use the :command:`javap` command on the command line. In the
   example below, we run ``javap -s -p java.lang.Math`` to get all the method
   signatures found in the "java.lang.Math" class, and we use :command:`grep` to
   filter and find the "scalb" method. You'll notice in the result that there
   are actually two methods with the same name but with different signatures,
   and we're using the second one:

   .. code-block:: none

      $> javap -s -p java.lang.Math | grep -A 1 scalb
      public static double scalb(double, int);
        Signature: (DI)D
      --
      public static float scalb(float, int);
        Signature: (FI)F

#. Finally, we execute the method using `~java_jnienv->CallStaticFloatMethod`
   which takes in the class object from the first step and the method ID from
   the second step and then the required parameters for the method we are
   calling, if any. Note that we must convert Lasso decimal objects to
   :type:`jfloat` and Lasso integer objects to :type:`jint`. ::

      java_jvm_getenv->CallStaticFloatMethod(#class, #mID, jfloat(4.0), jint(3))


Instantiating a Java Object and Executing a Member Method
=========================================================

Member methods are methods that are associated with a class and are run on an
instantiated object of that class. This example will walk you through creating a
ZipFile object and running the ``size`` method on that object to find out how
many items are in the zip file.

To run this example yourself, supply a zip file and replace the path and file
name in the example with the path and name of your zip file.


Java Object Member Method Code
------------------------------

::

   local(class) = java_jvm_getenv->FindClass('java/util/zip/ZipFile')
   local(mID)   = java_jvm_getenv->GetMethodID(#class, '<init>', '(Ljava/lang/String;)V')
   local(obj)   = java_jvm_getenv->NewObject(#class, #mID, '/path/to/zipfile.zip')

   local(class) = java_jvm_getenv->GetObjectClass(#obj)
   local(mID)   = java_jvm_getenv->GetMethodID(#class, 'size', '()I')

   java_jvm_getenv->CallIntMethod(#obj, #mID)

   // => 92


Java Object Member Method Walkthrough
-------------------------------------

Once again, all the communication is done using the `java_jvm_getenv` method,
which wraps the Lasso instance's :type:`java_jnienv` object.

#. The first line of code gets the specified Java class and stores a Lasso
   :type:`jobject` into the local variable "class". The value that gets passed
   to `~java_jnienv->FindClass` is the fully qualified class name signature (or
   array type signature). For more information, see the `FindClass`_
   documentation. ::

      local(class) = java_jvm_getenv->FindClass('java/util/zip/ZipFile')

#. Next, the code finds the method ID for the constructor method by passing the
   class object we found in the first step, "<init>" for the method name, and
   the method signature as the third argument::

      local(mID)   = java_jvm_getenv->GetMethodID(#class, '<init>', '(Ljava/lang/String;)V')

#. The method signature ``(Ljava/lang/String;)V`` specifies that it takes a
   string parameter and returns "void". The easiest way to find the signature
   for a method is to use the :command:`javap` command on the command line. In
   the example below, we run ``javap -s -p java.util.zip.ZipFile`` to get all
   the method signatures found in the "java.util.zip.ZipFile" class, and we use
   :command:`grep` to filter and find the constructor methods. You'll notice in
   the result that there are actually three constructor methods, each with
   different signatures, and we are using the first one:

   .. code-block:: none

      $> javap -s -p java.util.zip.ZipFile | grep -A 1 "public java.util.zip.ZipFile"
      public java.util.zip.ZipFile(java.lang.String) throws java.io.IOException;
        Signature: (Ljava/lang/String;)V
      --
      public java.util.zip.ZipFile(java.io.File, int) throws java.io.IOException;
        Signature: (Ljava/io/File;I)V
      --
      public java.util.zip.ZipFile(java.io.File) throws java.util.zip.ZipException, java.io.IOException;
        Signature: (Ljava/io/File;)V

#. After finding the constructor method for our class, the code instantiates an
   object by passing that information into `~java_jnienv->NewObject`. The line
   of code below stores a Java object into "obj" by calling
   `~java_jnienv->NewObject` with the class information, method ID, and any
   additional parameters required by the constructor (in this case, the path to
   the zipped file). For more information on `~java_jnienv->NewObject`, see the
   `NewObject`_ documentation. ::

      local(obj)   = java_jvm_getenv->NewObject(#class, #mID, '/path/to/zipfile.zip')

#. The next line isn't actually necessary since the "class" variable already has
   the class information for "java.util.zip.ZipFile", but we have it here to
   demonstrate how you could deal with wanting to call methods on Java objects
   that were returned by other methods. So, `~java_jnienv->GetObjectClass`
   returns the class information for the specified object. For more information,
   see the `GetObjectClass`_ documentation. ::

      local(class) = java_jvm_getenv->GetObjectClass(#obj)

#. The next line gets the method ID for the ``size`` member method and stores it
   in the local variable "mID"::

      local(mID)   = java_jvm_getenv->GetMethodID(#class, 'size', '()I')

#. Finally, we execute the ``size`` member method by calling
   `~java_jnienv->CallIntMethod` with the Java object as the first parameter and
   the method ID for ``size`` as the second parameter. Notice that the return
   type (int) is in the name of the method. There are a number of these methods
   for `various return types`_. ::

      java_jvm_getenv->CallIntMethod(#obj, #mID)

.. _interoperating with Java using JNI: http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/jniTOC.html
.. _FindClass: http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16027
.. _GetStaticMethodID: http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp20950
.. _NewObject: http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4517
.. _GetObjectClass: http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp16454
.. _various return types: http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html#wp4256
