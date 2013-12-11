.. _serialization-compression:

*****************************
Serialization and Compression
*****************************

To :dfn:`serialize` an object is to convert the object into a format that can be
transmitted over the network or written to a file. The serialized object data
can then later be used to :dfn:`deserialize`---or re-create---the object.

Lasso uses XML for object serialization. An object whose type supports
serialization can be converted to and from XML, or can be stored in a session.
The object is given control over which of its data members will be written to
the output.

Lasso also provides a set of methods to compress or decompress data for more
efficient data transmission.


Serializing and Deserializing Objects
=====================================

An object is serialized by calling its `~trait_serializable->serialize` method,
which serializes the object and returns the resulting data as a string. This
method is provided through :trait:`trait_serializable`, which is described
below.

Serialized object data is converted back into an object by using a
:type:`serialization_reader` object. This object is created with the serialized
data after which its `~serialization_reader->read` method is called. If the read
is successful, then a new object of the same type and data as the original
serialized object is returned.

.. type:: serialization_reader
.. method:: serialization_reader(s::string)
.. method:: serialization_reader(x::xml_element)

   Creates a :type:`serialization_reader` object. Can be instantiated with a
   string of XML or an :type:`xml_element` object.

.. member: serialization_reader->read()
.. member:: serialization_reader->read(x::xml_element= ?)

   Re-creates the serialized element.

This example code serializes an array of objects, then deserializes it back into
a new array::

   local(a) = array(1, 2, 'three', pair(4='five'))
   local(data) = #a->serialize
   local(a2) = serialization_reader(#data)->read
   #a == #a2

   // => true


Supporting Serialization
========================

In order to be serializable, an object must meet a few requirements. When
creating new object types, these requirements must be met or the objects will
not be serializable. Additionally, any objects contained by a serializable type
must themselves also be serializable in order to be properly handled.

Serializable objects must implement the following methods:

.. trait:: trait_serializable

.. require:: trait_serializable->onCreate()

   A serializable object must implement a zero parameter ``onCreate`` method.
   Note that if a type has no ``onCreate`` methods at all, then a suitable
   method is automatically added to the type to allow this requirement to be
   met. During deserialization, a new instance of the object is created. No
   parameters are passed at that point.

.. require:: trait_serializable->serializationElements()::trait_forEach

   This method is called during object serialization. It should return an array,
   staticarray, or some other suitable object containing each of the elements
   that should be serialized along with the target object.

   Each element in the return value should be a :type:`serialization_element`.
   These objects contain a key and a value. The key and the value must both be
   serializable. The key and the value can be objects of any type. They are both
   given back to the object when it is deserialized in order to return it to the
   state it was in when it was serialized to begin with.

.. require:: trait_serializable->acceptDeserializedElement(d::serialization_element)

   As an object is deserialized by a :type:`serialization_reader`, first a new
   instance is created, then this method is called once for each of the
   serialization elements that were originally included in the data. The
   :type:`serialization_element` items contain the keys and values used to
   re-create the original object state.

Implementing the proper methods allows the object to import
:trait:`trait_serializable`, which provides the `~trait_serializable->serialize`
method. This trait should be added when the type is defined.

.. provide:: trait_serializable->serialize()::string

   Serializes the object and returns the resulting data. That data can then be
   deserialized, re-creating an object with the correct data.

:type:`serialization_element` objects are used when both serializing and
deserializing. This simple object must be created with a key and a value. The
key and value are made available through methods named accordingly.

.. type:: serialization_element
.. method:: serialization_element(key, value)

   Create a new :type:`serialization_element` object with a key and value.

.. member:: serialization_element->key()
.. member:: serialization_element->value()

   These methods respectively return the key and value that was set when the
   object was created. Both the key and value can be objects of any serializable
   type.


Serializable Type Example
-------------------------

This example illustrates how to create a new object type that is serializable.
The example type has data members that are saved during serialization. ::

   define example_obj => type {
      trait { import trait_serializable }

      data public dmem1 = 'Value for first member',
         public dmem2 = 'Second member\'s value'

      public serializationElements()::trait_forEach => {
         return (:
            serialization_element(1, .dmem1),
            serialization_element(2, .dmem2) )
      }

      public acceptDeserializedElement(d::serialization_element) => {
         match(#d->key) => {
            case(1)
               .dmem1 = #d->value
            case(2)
               .dmem2 = #d->value
         }
      }
   }

   local(
      obj = example_obj,
      data = #obj->serialize,
      new = serialization_reader(#data)->read
   )
   #new->dmem1

   // => Value for first member


Compression Methods
===================

Lasso provides two methods that allow data to be stored or transmitted more
efficiently. The `compress` method can be used to compress any text string into
an efficient byte stream that can be stored in a binary field in a database or
transmitted to another server. The `decompress` method can then be used to
restore a compressed byte stream into the original string.

.. method:: compress(b::bytes)
.. method:: compress(s::string)

   Compresses a string or bytes object.

.. method:: uncompress(b::bytes)
.. method:: decompress(b::bytes)

   Decompresses a byte stream.

The compression algorithm should only be used on large string values. For
strings of less than one hundred characters the algorithm may actually result in
a larger string than the source.

These methods can be used in concert with the `serialize` method which creates a
string representation of a type that implements :trait:`trait_serializable`, and
the `serialization_reader->read` method which returns the original value based
on a string representation.


Compress and Decompress a String
--------------------------------

The following example takes the string value stored in the variable "input" and
compresses it and stores that information in "smaller". Finally, it decompresses
the data into the variable "output" and then displays the value now stored in
output. ::

   local(input)   = 'This is the string to be compressed.'
   local(smaller) = compress(#input)
   local(output)  = decompress(#smaller)
   #output

   // => This is the string to be compressed.


Compress and Decompress an Array
--------------------------------

The following example takes an array value stored in "my_array" and serializes
the data into the "input" variable. It then compresses that data into the
"smaller" variable. The "output" variable is then set to the decompressed and
deserialized value stored in the "smaller" variable. The value in "output" is
then displayed. ::

   local(my_array) = array('one', 'two', 'three', 'four', 'five')
   local(input)    = #my_array->serialize
   local(smaller)  = compress(#input)
   local(output)   = serialization_reader(xml(decompress(#smaller)))->read
   #output

   // => array(one, two, three, four, five)
