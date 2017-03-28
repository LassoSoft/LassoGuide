.. _byte-streams:

************
Byte Streams
************

.. index:: byte stream, binary data

Binary data in Lasso is stored and manipulated using the :type:`bytes` type.
This chapter details the operators and methods that can manipulate binary data.

.. tip::
   The :type:`bytes` type is often used in conjunction with the :type:`string`
   type to convert binary data between different character encodings, such as
   UTF-8 and ISO-8859-1. See the :ref:`strings` chapter for more information
   about the :type:`string` type.


Creating Bytes Objects
======================

While string data in Lasso is processed as one- to four-byte Unicode characters,
the :type:`bytes` type can represent raw strings of single bytes, which is often
referred to as a :dfn:`byte stream` or :dfn:`binary data`.

Lasso's methods return a bytes object in the following situations:

-  The `bytes` creator method allocates a new bytes object.
-  The `web_request->param` methods return a bytes object.
-  The `field` method returns a bytes object from MySQL "BLOB" fields.
-  Other methods that return or require binary data as outlined in their
   documentation.

.. type:: bytes
.. method:: bytes()
.. method:: bytes(initial::integer)
.. method:: bytes(copy::bytes)
.. method: bytes(import::string)
.. method:: bytes(import::string, encoding::string= ?)
.. method:: bytes(doc::pdf_doc)

   Allocates a bytes object. Can convert a :type:`string` or :type:`pdf_doc`
   type to a :type:`bytes` type, or instantiate a new :type:`bytes` object.
   Accepts one optional parameter that can specify the initial size in bytes for
   the stream; or specify the :type:`string`, :type:`pdf_doc`, or :type:`bytes`
   object to convert to a new :type:`bytes` object. If converting a
   :type:`string` object, it can accept an optional second parameter to specify
   the encoding of the string.

.. member:: bytes->reserve(size::integer)

   Attempts to preallocate enough memory for the specified number of bytes.
   Useful for optimization by avoiding memory reallocation if the expected byte
   stream size is known in advance.


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

.. member:: bytes->size()

   Returns the number of bytes contained in the bytes object.

.. member:: bytes->length()

   .. deprecated:: 9.0
      Use `bytes->size` instead.

.. member:: bytes->get(position::integer)::integer

   Returns a single byte from the stream. Requires a parameter specifying which
   byte to fetch.

.. member:: bytes->getRange(position::integer, num::integer)::bytes

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

   Searches the bytes object for the byte sequence or string pattern specified
   in the first parameter, returning the position where the sequence first
   begins in the bytes object or "0" if the pattern cannot be found.

   The second and third parameters can specify a portion of the bytes object
   within which to look for the match, with the former specifying the position
   to begin the search and the latter specifying the number of bytes to search.
   Similarly, the fourth and fifth parameters can specify a portion of the
   sequence that should be used for matching.

.. member:: bytes->contains(find::string)
.. member:: bytes->contains(find::bytes)

   Returns "true" if the byte stream contains the specified sequence.

.. member:: bytes->beginsWith(find::string)
.. member:: bytes->beginsWith(find::bytes)

   Returns "true" if the byte stream begins with the specified sequence.

.. member:: bytes->endsWith(find::string)
.. member:: bytes->endsWith(find::bytes)

   Returns "true" if the byte stream ends with the specified sequence.

.. member:: bytes->bestCharset(charset::string)

   Checks if the byte stream can be encoded using the specified character set.
   Returns the either the specified character set name if it can, or an
   appropriate character set name if not.

.. member:: bytes->detectCharset()

   Checks which character sets could be used to decode the byte stream and
   returns a staticarray of guesses where each is a staticarray of the character
   set name, the language covered by the character set (if any), and a
   confidence value.


Find a Character Set for a Byte Stream
--------------------------------------

Use the `bytes->bestCharset` method. The examples below show the result of
passing a byte stream containing a character that can't be encoded with the
suggested character set::

   bytes('This is a plain ASCII string')->bestCharset('ISO-8859-1')
   // => ISO-8859-1

   bytes('This isn’t a plain ASCII string')->bestCharset('ISO-8859-1')
   // => UTF-8


Bytes Export Methods
====================

Bytes objects keep track of a "marker", indicating where in the stream export
operations will begin from. Newly created bytes objects have their marker set to
"0", and are incremented by the number of exported bytes when any of the export
member methods that return bytes objects are called. The marker can also be set
manually.

.. member:: bytes->asString(encoding::string= ?)

   Returns the entire byte stream as a string using the specified encoding,
   defaulting to "UTF-8".

.. member:: bytes->marker()

   Returns the current position at which exports will occur in the byte stream.

.. member:: bytes->marker=(value::integer)

   Sets the byte stream's marker to the passed value.

.. member:: bytes->position()
.. member:: bytes->position=(value::integer)
.. member:: bytes->setPosition(i::integer)

   .. deprecated:: 9.0
      Use `bytes->marker` and `bytes->marker=` instead.

.. member: bytes->exportAs(encoding::string= ?)
.. member:: bytes->exportString(encoding::string)

   Returns a string representing the byte stream. Requires a single parameter
   specifying the character encoding (e.g. "ISO-8859-1" or "UTF-8") for the
   export. If the byte stream has a marker set, only the bytes following the
   marker will be returned. The marker is not modified.

.. member: bytes->exportBytes()
.. member:: bytes->exportBytes(num::integer= ?)

   Returns the byte stream as a bytes object. Accepts one optional parameter
   that can specify the number of bytes to return. If the byte stream has a
   marker set, only the bytes following the marker will be returned. Sets the
   marker to the end of the stream.

.. member:: bytes->export8bits()
.. member:: bytes->export16bits()
.. member:: bytes->export32bits()
.. member:: bytes->export64bits()

   Returns 1, 2, 4, or 8 bytes of the byte stream starting from the marker as an
   integer and increments the marker by the same amount.

.. member:: bytes->exportSigned8bits()
.. member:: bytes->exportSigned16bits()
.. member:: bytes->exportSigned32bits()
.. member:: bytes->exportSigned64bits()

   Returns 1, 2, 4, or 8 bytes of the byte stream starting from the marker as a
   signed (two's-complement) integer and increments the marker by the same
   amount.

.. member:: bytes->split(find::string)
.. member:: bytes->split(find::bytes)

   Returns an array of bytes objects using the specified sequence as the
   delimiter to split the byte stream. If the delimiter provided is an empty
   byte stream or string, the byte stream is split on each byte, so the returned
   array will have each byte as one of its elements.

.. member: bytes->sub(pos::integer)
.. member:: bytes->sub(position::integer, num::integer= ?)

   Returns a specified slice of the byte stream. Requires an integer parameter
   specifying the index into the byte stream to start taking the slice from. An
   optional second integer parameter can specify the number of bytes to slice
   out of the bytes object. If the second parameter is not specified, all of the
   bytes following the index are returned.


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

Use the `bytes->contains` method. The example below will return "true" if the
value ``'Rhino'`` is contained within the byte stream. Note that in this example
it will return "false" because the bytes of ``'rhino'`` are a different sequence
than the bytes of ``'Rhino'``. ::

   bytes('running rhinos risk rampage')->find('Rhino')
   // => false


Export a String from a Byte Stream
----------------------------------

Use the `bytes->exportString` method. The following example exports a string
using UTF-8 encoding::

   local(obj) = bytes('This is a string')
   #obj->exportString('UTF-8')

   // => This is a string


Bytes Decoding/Encoding Methods
===============================

.. member:: bytes->crc()

   Returns the cyclic redundancy check integer value for the byte stream.

.. member:: bytes->encodeBase64()

   Returns a base64-encoded representation of the byte stream as a bytes object.

.. member:: bytes->decodeBase64()

   Returns the binary data of a base64-encoded byte stream as a bytes object.
   This is the opposite of the `bytes->encodeBase64` method.

.. member:: bytes->encodeHex()

   Returns the byte stream in hexadecimal format.

.. member:: bytes->decodeHex()

   Returns the binary data of a byte stream containing hexadecimal ASCII
   characters by converting each pair of characters to a single byte. This is
   the opposite of the `bytes->encodeHex` method.

.. member:: bytes->encodeMd5()

   Returns the MD5 hash value for the byte stream as a bytes object.

.. member: bytes->encodeQP(isHeader::boolean=false)
.. member:: bytes->encodeQP()

   Returns the byte stream in quoted-printable format.

.. member: bytes->decodeQP(isHeader::boolean=false)
.. member:: bytes->decodeQP()

   Returns the binary data of a quoted-printable--encoded byte stream as a bytes
   object. This is the opposite of the `bytes->encodeQP` method.

.. member:: bytes->encodeSql()

   Returns the byte stream with any illegal characters for MySQL data sources
   properly escaped.

.. member:: bytes->encodeSql92()

   Returns the byte stream with any illegal characters for SQL-92--compliant
   data sources properly escaped. Not for use with MySQL.

.. member: bytes->encodeUrl(strict::boolean=false)
.. member:: bytes->encodeUrl()

   Returns the byte stream with any illegal characters for URLs properly
   escaped.

.. member:: bytes->decodeUrl()

   Returns the binary data of a URL-encoded byte stream as a bytes object, with
   any escaped characters replaced with their ASCII equivalents. This is the
   opposite of the `bytes->encodeUrl` method.


Encode a File as Base64
-----------------------

Use the `bytes->encodeBase64` method. The example below reads a file into a byte
stream and prints its Base64-encoded value::

   file('red-dot.png')->readBytes->encodeBase64
   // => iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==


Bytes Iteration Methods
=======================

.. member:: bytes->forEachByte()

   Executes a given capture block once for every bytes in the byte stream. The
   byte can be accessed in the capture block through the special local variable
   ``#1``.

.. member:: bytes->eachByte()

   Returns an ``eacher`` that can be used in conjunction with query expressions
   to inspect and perform complex operations on every byte in the byte stream.


Bytes Manipulation Methods
==========================

Calling the following methods will modify the bytes object without returning a
value.

.. member:: bytes->setSize(num::integer)

   Sets the byte stream size to the specified number of bytes.

.. member:: bytes->setRange(\
      what::bytes, \
      where::integer= ?, \
      whatStart::integer= ?, \
      whatLen::integer= ?)

   Sets a range of characters within a byte stream. Requires one parameter for
   the binary data to be inserted. The optional second, third, and fourth
   parameters specify the integer offset into the byte stream to insert the new
   data, and the offset and length of the new data to be inserted, respectively.

.. member:: bytes->padLeading(tosize::integer, with::bytes= ?)
.. member:: bytes->padLeading(tosize::integer, with::string= ?)

   If the byte stream is smaller in size than the first parameter specifying the
   target number of bytes, it changes the byte stream by prepending a character
   to its beginning until it reaches the specified size. The character used for
   prepending defaults to a space, but can be set with an optional second
   parameter.

.. member:: bytes->padTrailing(tosize::integer, with::bytes= ?)
.. member:: bytes->padTrailing(tosize::integer, with::string= ?)

   If the byte stream is smaller in size than the first parameter specifying the
   target number of bytes, it changes the byte stream by appending a character
   to its end until it reaches the specified size. The character used for
   appending defaults to a space, but can be set with an optional second
   parameter.

.. member:: bytes->replace(find::bytes, replace::bytes)

   Replaces all instances of a value within a byte stream with a new value.
   Requires two parameters: the first parameter is the value to find, and the
   second parameter is the value with which to replace the first parameter.

.. member:: bytes->remove()
.. member:: bytes->remove(position::integer, num::integer)

   Removes bytes from a byte stream. When passed without a parameter, it removes
   all bytes, setting the object to an empty bytes object. In its second form,
   it requires an offset into the byte stream and the number of bytes to remove
   starting from there.

.. member:: bytes->removeLeading(find::bytes)

   Removes all occurrences of the specified sequence from the beginning of the
   byte stream. Requires one parameter specifying the data to be removed.

.. member:: bytes->removeTrailing(find::bytes)

   Removes all occurrences of the parameter sequence from the end of the
   byte stream. Requires one parameter specifying the data to be removed.

.. member:: bytes->append(rhs::bytes)
.. member:: bytes->append(rhs::string)

   Appends the specified data to the end of the byte stream. Requires one
   parameter specifying the data to append.

.. member:: bytes->trim()

   Removes all whitespace ASCII characters from the beginning and the end of the
   byte stream.

.. member: bytes->importAs(p0::string, p1::string)
.. member:: bytes->importString(s::string, enc::string= ?)

   Imports a string parameter into the byte stream. A second parameter can
   specify the character encoding (e.g. "ISO-8859-1" or "UTF-8") to use for the
   import.

.. member:: bytes->importBytes(b::bytes)

   Imports a bytes object parameter into the byte stream.

.. member:: bytes->import8bits(i::integer)
.. member:: bytes->import16bits(i::integer)
.. member:: bytes->import32bits(i::integer)
.. member:: bytes->import64bits(i::integer)

   Imports the first 1, 2, 4, or 8 bytes of an integer parameter.

.. member:: bytes->swapBytes()

   Swaps the position of every pair of bytes, e.g. a byte stream of ``'father'``
   becomes ``'afhtre'``.


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
