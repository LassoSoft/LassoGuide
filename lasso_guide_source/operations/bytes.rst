.. _bytes:

.. direct from book

*****
Bytes
*****

Binary data in Lasso is stored and manipulated using the bytes data type
or the ``[Byte]`` tags. This chapter details the symbols and tags that
can be used to manipulate binary data.

-  `Bytes Type`_ describes the data type which Lasso uses for binary
   data.

.. Note:: The bytes type is often used in conjunction with the string
    type to convert binary data between different character encodings
    (UTF-8, ISO-8859-1). See the previous chapter for more information
    about the string type.

Bytes Type
==========

All string data in Lasso is processed as double-byte Unicode characters.
The ``[Byte]`` type is used to represent strings of single-byte binary
data. The ``[Byte]`` type is often referred to as a byte-stream or
binary data.

Lasso tags return data in the ``[Byte]`` type in the following
situations.

-  The ``[Field]`` tag returns a byte stream from MySQL ``BLOB`` fields.
-  When the ``-Binary`` encoding type is used on any tag.
-  The ``[Byte]`` tag can be used to allocate a new byte stream.
-  Other tags that return binary data. See the Lasso Reference for a
   complete list.

``[Bytes]``
    Allocates a byte stream. Can be used to cast a    
    string data type as a bytes type, or to           
    instantiate a new bytes instance. Accepts two     
    optional parameters. The first is the initial size
    in bytes for the stream. The second is the        
    increment to use to grow the stream when data is  
    stored that goes beyond the current allocation.   


Byte streams are similar to strings and support many of the same member
tags. In addition, byte streams support a number of member tags that
make it easier to deal with binary data. These tags are listed in the
:ref:`Byte Stream Member Tags <bytes-table-2>` table.

``[Bytes->Size]``
    Returns the number of bytes contained in the bytes
    stream object.                                    

``[Bytes->Get]``
    Returns a single byte from the stream. Requires a 
    parameter which specifies which byte to fetch.    

``[Bytes->SetSize]``
    Sets the byte stream to the specified number of   
    bytes.                                            

``[Bytes->GetRange]``
    Gets a range of bytes from the byte               
    stream. Requires a single parameter which is the  
    byte position to start from. An optional second   
    parameter specifies how many bytes to return.     

``[Bytes->SetRange]``
    Sets a range of characters within a byte          
    stream. Requires two parameters: An integer offset
    into the base stream, and the binary data to be   
    inserted. An optional third and fourth parameter  
    specify the offset and length of the binary data  
    to be inserted.                                   

``[Bytes->Find]``
    Returns the position of the beginning of the      
    parameter sequence within the bytes instance, or  
    ``0`` if the sequence is not contained within the 
    instance. Four optional integer parameters        
    (offset, length, parameter offset, parameter      
    length) indicate position and length limits that  
    can be applied to the instance and the parameter  
    sequence.                                         

``[Bytes->Replace]``
    Replaces all instances of a value within a bytes  
    stream with a new value. Requires two             
    parameters. The first parameter is the value to   
    find, and the second parameter is the value to    
    replace the first parameter with.                 

``[Bytes->Contains]``
    Returns ``true`` if the instance contains the     
    parameter sequence.                               

``[Bytes->BeginsWith]``
    Returns ``true`` if the instance begins with the  
    parameter sequence.                               

``[Bytes->EndsWith]``
    Returns ``true`` if the instance ends with the    
    parameter sequence.                               

``[Bytes->Split]``
    Splits the instance into an array of bytes        
    instances using the parameter sequence as the     
    delimiter. If the delimiter is not provided, the  
    instance is split, byte for byte, into an array of
    byte instances.                                   

``[Bytes->Remove]``
    Removes bytes form a byte stream. Requires an     
    offset into the byte stream. Optionally accepts a 
    number of bytes to remove.                        

``[Bytes->RemoveLeading]``
    Removes all occurrences of the parameter sequence 
    from the beginning of the instance. Requires one  
    parameter which is the data to be removed.        

``[Bytes->RemoveTrailing]``
    Removes all occurrences of the parameter sequence 
    from the end of the instance. Requires one        
    parameter which is the data to be removed.        

``[Bytes->Append]``
    Appends the specified data to the end of the bytes
    instance. Requires one parameter which is the data
    to append.                                        

``[Bytes->Trim]``
    Removes all whitespace ASCII characters from the  
    beginning and the end of the instance.            

``[Bytes->Position]``
    Returns the current position at which imports will
    occur in the byte stream.                         

``[Bytes->SetPosition]``
    Sets the current position within the byte         
    stream. Requires a single integer parameter.      

``[Bytes->ExportString]``
    Returns a string represeting the byte             
    stream. Accepts a single parameter which is the   
    character encoding (e.g. ISO-8859-1, UTF-8) for   
    the export. A parameter of ``Binary`` will perform
    a byte for byte export of the stream.             

``[Bytes->Export8bits]``
    Returns the first byte as an integer.             

``[Bytes->Export16bits]``
    Returns the first 2 bytes as an integer.          

``[Bytes->Export32bits]``
    Returns the first 4 bytes as an integer.          

``[Bytes->Export64bits]``
    Returns the first 8 bytes as an integer.          

``[Bytes->ImportString]``
    Imports a string parameter. A second parameter    
    specifies the encoding (e.g. ISO-8859-1, UTF-8) to
    use for the import. A second parameter of         
    ``Binary`` will perform a byte for byte import of 
    the string.                                       

``[Bytes->Import8Bits]``
    Imports the first byte of an integer parameter.   

``[Bytes->Import16Bits]``
    Imports the first 2 bytes of an integer parameter.

``[Bytes->Import32Bits]``
    Imports the first 4 bytes of an integer parameter.

``[Bytes->Import64Bits]``
    Imports the first 8 bytes of an integer parameter.

``[Bytes->SwapBytes]``
    Swaps each two bytes with each other.             


**To cast string data as a bytes object:**

Use the ``[Byte]`` tag. The following example converts a string to a
bytes variable.

::

    [Var:'Object'=(Bytes: 'This is some text')]

**To instantiate a new bytes object:**

Use the ``[Byte]`` tag. The example below creates an empty bytes object
with a size of 1024 bytes and a growth increment of 16 bytes.

::

    [Var:'Object'=(Bytes: 1024, 16)]

**To return the size of a byte stream:**

Use the ``[Bytes->Size]`` tag. The example below uses a ``[Field]`` tag
that has been converted to a bytes type using the ``-Binary`` parameter.

::

    [Var:'Bytes'=(Field:'Name', -Binary)]
    [$Bytes->Size]

**To return a single byte from a byte stream:**

Use the ``[Bytes->Get]`` tag. An integer parameter specifies the order
number of the byte to return. Note that this tag returns a byte, not a
fragment of the orignial data (such as a string character).

::

    [Var:'Bytes'=(Field:'Name', -Binary)]
    [$Bytes->(Get: 1)]

**To find a value within a byte stream:**

Use the ``[Bytes->Find]`` tag. The example below returns the starting
byte number of the value ``LassoSoft``, which is contained within the byte
stream.

::

    [Var:'Bytes'=(Field:'Name', -Binary)]
    [$Bytes->(Find: 'LassoSoft')]

**To determine if a value is contained within a byte stream:**

Use the ``[Bytes->Contains]`` tag. The example below returns ``True`` if
the value ``LassoSoft`` is contained within the byte stream.

::

    [Var:'Bytes'=(Field:'Name', -Binary)]
    [$Bytes->(Contains: 'LassoSoft')]

**To add a string to a byte stream:**

Use the ``[Bytes->Append]`` tag. The following example adds the string
``I am`` to the end of a bytes stream.

::

    [Var:'Bytes'=(Field:'Name', -Binary)]
    [$Bytes->(Append: 'I am')]

**To find and replace values in a byte stream:**

Use the ``[Bytes->Replace]`` tag. The following example finds the string
``Blue`` and replaces with the string ``Green`` within the bytes stream.

::

    [Var:'Bytes'=(Bytes: 'Blue Red Yellow')]
    [$Bytes->(Replace: 'Blue', 'Green')]

**To export a string from a bytes stream:**

Use the ``[Bytes->ExportString]`` tag. The following example exports a
string using UTF-8 encoding.

::

    [Var:'Bytes'=(Bytes: 'This is a string')]
    [$Bytes->(ExportString: 'UTF-8')]

**To import a string into a bytes stream:**

Use the ``[Bytes->ImportString]`` tag. The following example imports a
string using ISO-8859-1 encoding.

::

    [Var:'Bytes'=(Bytes: 'This is a string')]
    [$Bytes->(ImportString: 'This is some more string', 'ISO-8859-1')]

