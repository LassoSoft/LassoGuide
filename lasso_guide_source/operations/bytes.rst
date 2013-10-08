.. _bytes:

*****
Bytes
*****

Binary data in Lasso is stored and manipulated using the :type:`bytes` data
type. This chapter details the symbols and methods that can be used to
manipulate binary data.

.. note::
   The bytes type is often used in conjunction with the string type to convert
   binary data between different character encodings (UTF-8, ISO-8859-1). See
   the :ref:`strings` chapter for more information about the string type.


Creating Bytes Objects
======================

All string data in Lasso is processed as double-byte Unicode characters. The
``bytes`` type can be used to represent strings of single-byte binary data. The
``bytes`` type is often referred to as a byte-stream or binary data.

Lasso methods return data in the ``bytes`` type in the following situations:

-  The `field` method returns a byte stream from MySQL "BLOB" fields.
-  The ``bytes`` creator method can be used to allocate a new byte stream.
-  The `web_request->param` methods return a bytes stream
-  Other methods that return or require binary data as outlined in their
   documentation in the Lasso Reference guide.


.. type:: bytes
.. method:: bytes()
.. method:: bytes(initial::integer)
.. method:: bytes(copy::bytes)
.. method:: bytes(import::string)
.. method:: bytes(import::string, encoding::string)
.. method:: bytes(doc::pdf_doc)

   Allocates a byte stream. Can be used to cast a :type:`string` or
   :type:`pdf_doc` data type as a ``bytes`` type, or to instantiate a new
   ``bytes`` object. Accepts one optional parameter that can specify the initial
   size in bytes for the stream or the ``string``, ``pdf_doc``, or ``bytes``
   object to cast as a new bytes object. If casting a ``string`` object, it can
   accept a second optional parameter to specify the encoding of the string.


Inspecting and Manipulating Bytes Objects
=========================================

Byte streams are similar to strings and support many of the same member methods.
In addition, byte streams support a number of member methods that make it easier
to deal with binary data. These methods are outlined below.

.. member:: bytes->size()
.. member:: bytes->length()

   Returns the number of bytes contained in the bytes stream object.

.. member:: bytes->get(position::integer)

   Returns a single byte from the stream. Requires a parameter which specifies
   which byte to fetch.

.. member:: bytes->setSize(p0::integer)

   Sets the byte stream to the specified number of bytes.

.. member:: bytes->getRange(p0::integer, p1::integer)

   Gets a range of bytes from the byte stream. Requires two parameters. The
   first specifies the byte position to start from, and the second specifies how
   many bytes to return.

.. member:: bytes->setRange(\
      what::bytes, \
      where::integer= ?, \
      whatStart::integer= ?, \
      whatLen::integer= ?\
   )

   Sets a range of characters within a byte stream. Requires one parameters: the
   binary data to be inserted. Optional second, third, and fourth parameters
   specify the integer offset into the bytes stream to insert the new data, the
   offset and length of the new data to be inserted, respectively.

.. member:: bytes->find(\
      find::bytes, \
      position::integer= ?, \
      length::integer= ?, \
      patPosition::integer= ?, \
      patLength::integer= ?\
   )
.. member:: bytes->find(\
      find::string, \
      position::integer= ?, \
      length::integer= ?, \
      patPosition::integer= ?, \
      patLength::integer= ?\
   )

   Requires either a ``bytes`` or ``string`` sequence as the first parameter.
   Returns the position of the beginning of the sequence being searched for
   within the ``bytes`` object, or "0" if the sequence is not contained within
   the object. Four optional integer parameters (position, length, parameter
   position, parameter length) indicate position and length limits that can be
   applied to the instance and the parameter sequence.

.. member:: bytes->replace(find::bytes, replace::bytes)

   Replaces all instances of a value within a bytes stream with a new value.
   Requires two parameters. The first parameter is the value to find, and the
   second parameter is the value to replace the first parameter with.

.. member:: bytes->contains(find)

   Returns "true" if the instance contains the specified sequence.

.. member:: bytes->beginsWith(find::string)
.. member:: bytes->beginsWith(find::bytes)

   Returns "true" if the instance begins with the specified sequence.

.. member:: bytes->endsWith(find::string)
.. member:: bytes->endsWith(find::bytes)

   Returns "true" if the instance ends with the specified sequence.

.. member:: bytes->split(find::string)
.. member:: bytes->split(find::bytes)

   Returns an array of bytes instances using the specified sequence as the
   delimiter to split the byte stream. If the delimiter provided is an empty
   ``bytes`` or ``string`` object, the byte stream is split on each byte, so the
   returned array will have each byte as one of its elements.

.. member:: bytes->remove()
.. member:: bytes->remove(p0::integer, p1::integer)

   Removes bytes form a byte stream. When passed without a parameter, it removes
   all bytes, setting the object to an empty ``bytes`` object. In its second
   form, it requires an offset into the byte stream and the number of bytes to
   remove starting from there.

.. member:: bytes->removeLeading(find::bytes)

   Removes all occurrences of the specified sequence from the beginning of the
   byte stream. Requires one parameter which is the data to be removed.

.. member:: bytes->removeTrailing(find::bytes)

    Removes all occurrences of the parameter sequence from the end of the
    instance. Requires one parameter which is the data to be removed.

.. member:: bytes->append(p0::bytes)
.. member:: bytes->append(rhs::string)

   Appends the specified data to the end of the bytes stream. Requires one
   parameter which is the data to append.

.. member:: bytes->trim()

   Removes all whitespace ASCII characters from the beginning and the end of the
   instance.

.. member:: bytes->sub(pos::integer)
.. member:: bytes->sub(p0::integer, p1::integer)

   Returns a specified slice of the byte stream. Requires an integer parameter
   that specifies the index into the byte stream to start taking the slice from.
   An optional second integer parameter can specify the number of bytes to slice
   out of the byte stream. If the second parameter is not specified, then all of
   the rest of the byte stream is taken.

.. member:: bytes->marker()
.. member:: bytes->position()

    Returns the current position at which imports will occur in the byte stream.

.. member:: bytes->setPosition(i::integer)

   Sets the current position within the byte stream. Requires a single integer
   parameter.

.. member:: bytes->exportString(encoding::string)

   Returns a string representing the byte stream. Accepts a single parameter
   which is the character encoding (e.g. "ISO-8859-1", "UTF-8") for the export.

.. member:: bytes->export8bits()

   Returns the first byte as an integer.

.. member:: bytes->export16bits()

   Returns the first 2 bytes as an integer.

.. member:: bytes->export32bits()

   Returns the first 4 bytes as an integer.

.. member:: bytes->export64bits()

   Returns the first 8 bytes as an integer.

.. member:: bytes->importString(s::string, enc::string= ?)

   Imports a string parameter. A second parameter can specify the encoding (e.g.
   "ISO-8859-1", "UTF-8") to use for the import.

.. member:: bytes->import8bits(p0::integer)

   Imports the first byte of an integer parameter.

.. member:: bytes->import16bits(p0::integer)

   Imports the first 2 bytes of an integer parameter.

.. member:: bytes->import32bits(p0::integer)

   Imports the first 4 bytes of an integer parameter.

.. member:: bytes->import64bits(p0::integer)

   Imports the first 8 bytes of an integer parameter.

.. member:: bytes->swapBytes()

   Swaps each two bytes with each other (e.g. a byte stream of 'father' becomes
   'afhtre').


Examples
========


Cast String Data as a Bytes Object
----------------------------------

Use the ``bytes`` creator method. The following example converts a string to a
``bytes`` object::

   local(obj) = bytes('This is some text')


Instantiate a New Bytes Object
------------------------------

Use the ``bytes`` creator method. The example below creates an empty ``bytes``
object with a size of 1024 bytes::

   local(obj) = bytes(1024)


Return the Size of a Byte Stream
--------------------------------

Use the `bytes->size` method. The example below returns the size of a ``bytes``
object::

   local(obj) = bytes('ect…')
   #obj->size

   // => 6


Return a Single Byte From a Byte Stream
---------------------------------------

Use the `bytes->get` method. An integer parameter specifies the index of the
byte to return. Note that this method returns an integer, not a fragment of the
original data (such as a string character)::

   local(obj) = bytes('hello world')
   #obj->get(2)

   // => 101


Find a Value Within a Byte Stream
---------------------------------

Use the `bytes->find` method. The example below returns the starting byte
number of the value "rhino", which is contained within the byte stream::

   bytes('running rhinos risk rampage')->find('rhino')

   // => 9


Determine If a Value is Contained Within a Byte Stream
------------------------------------------------------

Use the `bytes->contains` method. The example below returns "true" if the
value "Rhino" is contained within the byte stream. Note that in this example it
returns false due to the bytes of "rhino" being a different sequence then the
bytes of "Rhino"::

   bytes('running rhinos risk rampage')->find('Rhino')

   // => false


Add a String to a Byte Stream
-----------------------------

Use the `bytes->append` method. The following example adds the string "I am" to
the end of a bytes stream::

   local(obj) = bytes
   #obj->append("I am")


Find and Replace Values in a Byte Stream
----------------------------------------

Use the `bytes->replace` method. The following example finds the string "Blue"
and replaces with the string "Green" within the bytes stream::

   local(colors) = bytes('Blue Red Yellow')
   #colors->replace('Blue', 'Green')


Export a String From a Bytes Stream
-----------------------------------

Use the `bytes->exportString` method. The following example exports a string
using UTF-8 encoding::

   local(obj) = bytes('This is a string')
   #obj->exportString('UTF-8')

   // => This is a string


Import a String Into a Bytes Stream
-----------------------------------

Use the `bytes->importString` method. The following example imports a string
using "ISO-8859-1" encoding::

   local(obj) = bytes('This is a string')
   #obj->importString('This is some more string', 'ISO-8859-1')
