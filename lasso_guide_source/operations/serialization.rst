.. _serialization:

.. default-domain:: ls

*************
Serialization
*************

Serializing an object converts the object into a format which can be transmitted
over the network or written to a file. The serialized object data can then later
be used to de-serialize---or recreate---the object.

Lasso uses XML for object serialization. An object which supports serialization
can be converted to and from XML. The object is given control over which of its
data members will be written to the output.

Serializing Objects
===================

An object is serialized by calling its :meth:`serialize` method. This method
serializes the object and returns the resulting data as a string. This method is
provided through :trait:`trait_serializable`, which is described here.

.. trait:: trait_serializable

.. provide:: serialize()::string

   This method serializes the object and returns the resulting data. That data
   can then be used to deserialize the object.

Deserializing Objects
=====================

Serialized object data is converted back into an object by using a
``serialization_reader`` object. This object is created with the serialized data
and then its ``read()`` method is called. If read is successful then a new
object is returned of the same type as the original serialized object.

Example - Serialize an array of objects, then deserialize it back into a new
array::

   local(a = array(1, 2, 'three', pair(4='five')))
   local(data = #a->serialize)
   local(a2 = serialization_reader(#data)->read)
   #a == #a2

Supporting Serialization
========================

In order to be serializable, an object must meet a few requirements. When
creating new object types, these requirements must be met or the objects will
not be serializable. Additionally, any objects contained by a serializable type
must themselves also be serializable in order to be properly handled.

Serializable objects must implement the following methods:

.. require:: onCreate()

   A serializable object must implement a zero parameter onCreate method. Note
   that if a type has no onCreate methods at all, then a suitable method is
   automatically added to the type and so this requirement would be met. During
   deserialization, a new instance of the object is created. No parameters are
   passed at that point.

.. require:: serializationElements()::trait_forEach

   This method is called during object serialization. It should return an array,
   staticarray or some other suitable object containing each of the elements
   which should be serialized along with the target object.

   Each element in the return value should be a ``serialization_element``. These
   objects contain a key and a value. The key and the value must both be
   serializable. The key and the value can be objects of any type. They are both
   given back to the object when it is deserialized in order to return it to the
   state it was in when it was serialized to begin with.

.. require:: acceptDeserializedElement(d::serialization_element)

   As an object is deserialized by a ``serialization_reader``, a new instance is
   first created and then this method is called once for each of the
   serialization elements that were originally included in the data. The
   serialization_elements contain the keys and values used to recreate the
   original object state.

In addition to implementing the proper methods, the object must have
:trait:`trait_serializable`. This trait should be added when the type is defined.

Serialization_element Objects
-----------------------------

``serialization_element`` objects are used when both serializing and deserializing. This
simple object must be created with a key and a value. The key and value are made
available through methods named accordingly.

.. type:: serialization_element
.. method:: serialization_element(key, value)

   Create a new ``serialization_element`` object with a key and value.

.. method:: key()
.. method:: value()

   These methods return, respectively, the key and value that was set when the
   object was created. The key and the value can be objects of any serializable
   type.

Example Serializable Type
-------------------------

This example illustrates how to create a new object type which is serializable.
The example type has data members that it saves to the resulting data.

::

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
   // => 'Value for first member'
