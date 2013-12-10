.. _bytes:

*****
Bytes
*****

.. index:: byte stream, binary data

Binary data in Lasso is stored and manipulated using the :type:`bytes` type.
This chapter details the operators and methods that can be used to manipulate
binary data.

.. tip::
   The :type:`bytes` type is often used in conjunction with the :type:`string`
   type to convert binary data between different character encodings (e.g.
   UTF-8, ISO-8859-1). See the :ref:`strings` chapter for more information about
   the :type:`string` type.


Creating Bytes Objects
======================

While string data in Lasso is processed as one- to four-byte Unicode characters,
the :type:`bytes` type can be used to represent raw strings of single bytes,
which is often referred to as a :dfn:`byte stream` or :dfn:`binary data`.

Lasso's methods return a byte stream in the following situations:

-  The `field` method returns a byte stream from MySQL "BLOB" fields.
-  The `bytes` creator method can be used to allocate a new byte stream.
-  The `web_request->param` methods return a byte stream.
-  Other methods that return or require binary data as outlined in their
   documentation.

.. type:: bytes
.. method:: bytes()
.. method:: bytes(initial::integer)
.. method:: bytes(copy::bytes)
.. method:: bytes(import::string)
.. method:: bytes(import::string, encoding::string)
.. method:: bytes(doc::pdf_doc)

   Allocates a byte stream. Can be used to convert a :type:`string` or
   :type:`pdf_doc` type to a :type:`bytes` type, or to instantiate a new
   :type:`bytes` object. Accepts one optional parameter that can specify the
   initial size in bytes for the stream; or specify the :type:`string`,
   :type:`pdf_doc`, or :type:`bytes` object to convert to a new :type:`bytes`
   object. If converting a :type:`string` object, it can accept an optional
   second parameter to specify the encoding of the string.


Instantiate a New Bytes Object
------------------------------

Use the `bytes` creator method. The example below creates an empty bytes object
with a size of 1024 bytes::

   local(obj) = bytes(1024)


Convert String Data to a Bytes Object
-------------------------------------

Use the `bytes` creator method. The following example converts a string to a
bytes object::

   local(obj) = bytes('This is some text')


Bytes Inspection Methods
========================

Byte streams are similar to strings and support many of the same member methods.
Additionally, byte streams support a number of member methods that make it
easier to deal with binary data. The most common methods are outlined below.

.. member:: bytes->length()

   .. deprecated:: 9.0
      Use `bytes->size` instead.

.. member:: bytes->size()

   Returns the number of bytes contained in the bytes object.

.. member:: bytes->get(position::integer)

   Returns a single byte from the stream. Requires a parameter specifying which
   byte to fetch.

.. member:: bytes->getRange(p0::integer, p1::integer)

   Returns a range of bytes from the byte stream. Requires two parameters: the
   first specifies the byte position to start from, and the second specifies how
   many bytes to return.

.. member:: bytes->find(\
      find::bytes, \
      position::integer= ?, \
      length::integer= ?, \
      patPosition::integer= ?, \
      patLength::integer= ?)
.. member:: bytes->find(\
      find::string, \
      position::integer= ?, \
      length::integer= ?, \
      patPosition::integer= ?, \
      patLength::integer= ?)

   Requires either a byte stream or string sequence as the first parameter.
   Returns the position of the beginning of the sequence being searched for
   within the bytes object, or "0" if the sequence is not contained within the
   object. Four optional integer parameters (position, length, parameter
   position, parameter length) indicate position and length limits that can be
   applied to the instance and the parameter sequence.

.. member:: bytes->contains(find)

   Returns "true" if the byte stream contains the specified sequence.

.. member:: bytes->beginsWith(find::string)
.. member:: bytes->beginsWith(find::bytes)

   Returns "true" if the byte stream begins with the specified sequence.

.. member:: bytes->endsWith(find::string)
.. member:: bytes->endsWith(find::bytes)

   Returns "true" if the byte stream ends with the specified sequence.

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

.. member:: bytes->split(find::string)
.. member:: bytes->split(find::bytes)

   Returns an array of bytes objects using the specified sequence as the
   delimiter to split the byte stream. If the delimiter provided is an empty
   byte stream or string, the byte stream is split on each byte, so the returned
   array will have each byte as one of its elements.

.. member:: bytes->exportString(encoding::string)

   Returns a string representing the byte stream. Accepts a single parameter
   specifying the character encoding (e.g. "ISO-8859-1", "UTF-8") for the
   export.

.. member:: bytes->export8bits()

   Returns the first byte as an integer.

.. member:: bytes->export16bits()

   Returns the first 2 bytes as an integer.

.. member:: bytes->export32bits()

   Returns the first 4 bytes as an integer.

.. member:: bytes->export64bits()

   Returns the first 8 bytes as an integer.


Return the Size of a Byte Stream
--------------------------------

Use the `bytes->size` method. The example below returns the size of a bytes
object::

   local(obj) = bytes('abc…')
   #obj->size

   // => 6


Return a Single Byte from a Byte Stream
---------------------------------------

Use the `bytes->get` method. An integer parameter specifies the index of the
byte to return. Note that this method returns an integer, not a fragment of the
original data (such as a string character)::

   local(obj) = bytes('hello world')
   #obj->get(2)

   // => 101


Find a Value Within a Byte Stream
---------------------------------

Use the `bytes->find` method. The example below returns the starting byte number
of the value ``'rhino'``, which is contained within the byte stream::

   bytes('running rhinos risk rampage')->find('rhino')
   // => 9


Determine If a Byte Stream Contains a Value
-------------------------------------------

Use the `bytes->contains` method. The example below returns "true" if the value
``'Rhino'`` is contained within the byte stream. Note that in this example it
returns "false" because the bytes of ``'rhino'`` are a different sequence then
the bytes of ``'Rhino'``. ::

   bytes('running rhinos risk rampage')->find('Rhino')
   // => false


Export a String from a Byte Stream
----------------------------------

Use the `bytes->exportString` method. The following example exports a string
using UTF-8 encoding::

   local(obj) = bytes('This is a string')
   #obj->exportString('UTF-8')

   // => This is a string


Bytes Manipulation Methods
==========================

Calling the following methods will modify the bytes object.

.. member:: bytes->setSize(p0::integer)

   Sets the byte stream size to the specified number of bytes.

.. member:: bytes->setRange(\
      what::bytes, \
      where::integer= ?, \
      whatStart::integer= ?, \
      whatLen::integer= ?)

   Sets a range of characters within a byte stream. Requires one parameter for
   the binary data to be inserted. Optional second, third, and fourth parameters
   specify the integer offset into the byte stream to insert the new data, and
   the offset and length of the new data to be inserted, respectively.

.. member:: bytes->replace(find::bytes, replace::bytes)

   Replaces all instances of a value within a byte stream with a new value.
   Requires two parameters: the first parameter is the value to find, and the
   second parameter is the value with which to replace the first parameter.

.. member:: bytes->remove()
.. member:: bytes->remove(p0::integer, p1::integer)

   Removes bytes form a byte stream. When passed without a parameter, it removes
   all bytes, setting the object to an empty bytes object. In its second form,
   it requires an offset into the byte stream and the number of bytes to remove
   starting from there.

.. member:: bytes->removeLeading(find::bytes)

   Removes all occurrences of the specified sequence from the beginning of the
   byte stream. Requires one parameter specifying the data to be removed.

.. member:: bytes->removeTrailing(find::bytes)

   Removes all occurrences of the parameter sequence from the end of the
   byte stream. Requires one parameter specifying the data to be removed.

.. member:: bytes->append(p0::bytes)
.. member:: bytes->append(rhs::string)

   Appends the specified data to the end of the byte stream. Requires one
   parameter specifying the data to append.

.. member:: bytes->trim()

   Removes all whitespace ASCII characters from the beginning and the end of the
   byte stream.

.. member:: bytes->setPosition(i::integer)

   Sets the current position within the byte stream. Requires a single integer
   parameter.

.. member:: bytes->importString(s::string, enc::string= ?)

   Imports a string parameter. A second parameter can specify the character
   encoding (e.g. "ISO-8859-1", "UTF-8") to use for the import.

.. member:: bytes->import8bits(p0::integer)

   Imports the first byte of an integer parameter.

.. member:: bytes->import16bits(p0::integer)

   Imports the first 2 bytes of an integer parameter.

.. member:: bytes->import32bits(p0::integer)

   Imports the first 4 bytes of an integer parameter.

.. member:: bytes->import64bits(p0::integer)

   Imports the first 8 bytes of an integer parameter.

.. member:: bytes->swapBytes()

   Swaps the position of every pair of bytes (e.g. a byte stream of ``'father'``
   becomes ``'afhtre'``).


Add a String to a Byte Stream
-----------------------------

Use the `bytes->append` method. The following example adds the string ``'I am'``
to the end of a byte stream::

   local(obj) = bytes
   #obj->append('I am')


Find and Replace Values in a Byte Stream
----------------------------------------

Use the `bytes->replace` method. The following example finds the string
``'Blue'`` and replaces it with the string ``'Green'`` within the byte stream::

   local(colors) = bytes('Blue Red Yellow')
   #colors->replace('Blue', 'Green')


Import a String Into a Byte Stream
----------------------------------

Use the `bytes->importString` method. The following example imports a string
using ISO-8859-1 encoding::

   local(obj) = bytes('This is a string')
   #obj->importString('This is another string', 'ISO-8859-1')
