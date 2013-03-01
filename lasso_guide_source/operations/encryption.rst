.. _encryption:

.. direct from book

**********
Encryption
**********

Lasso's built-in encryption tags allow data to be stored or transmitted
securely.

-  `Overview`_ describes the different encryption types that Lasso
   supports.
-  `Encryption Tags`_ describes Lasso s built-in tags for securely
   storing and transmitting data using industry standard algorithms.
-  `Cipher Tags`_ describes tags that allow many different encryption
   and hash algorithms to be used within Lasso.
-  `Compression Tags`_ describes tags for compressing string data for
   more efficient storage or transmission.

Overview
========

Lasso provides a set of data encryption tags which support the most
commonly used encryption and hash functions used on the Internet today.
These encryption tags make it possible to interoperate with other
systems that require encryption and to store data in a secure fashion in
data sources or files.

Lasso has built-in tags for the BlowFish encryption algorithm and for
the SHA1 and MD5 hash algorithms. The new BlowFish2 algorithm is
implemented in an industry standard fashion in order to allow values
encrypted with Lasso to be decrypted by other BlowFish implementation or
vice versa. (The original BlowFish algorithm is also provided for
backward compatibility.)

Lasso s cipher tags provide access to a wide range of industry standard
encryption algorithms. The ``[Cipher_List]`` tag lists what algorithms
are available and the ``[Cipher_Encrypt]``, ``[Cipher_Decrypt]``, and
``[Cipher_Digest]`` tags allow values to be encrypted or decrypted or
digest values to be generated.

Finally, Lasso provides a set of tags to compress or decompress data for
more efficient data transmission.

Encryption Tags
===============

LassoScript provides a number of tags which allow data to be encrypted
for secure storage or transmission. Three different types of encryption
are supplied.

-  ``BlowFish`` is a fast, popular encryption algorithm. Lasso provides
   tools to encrypt and decrypt string values using a developer-defined
   seed. This is the best tag to use for data which needs to be stored
   in a database or transmitted securely.

   .. Note:: Lasso Professional 8 includes a new implementation of
      BlowFish which should be interoperable with most other products
      that support BlowFish. The new algorithm is implemented as
      ``[Encrypt_BlowFish2]``. The older algorithm is still supported as
      ``[Encrypt_BlowFish]`` for backward compatibility.
-  ``MD5`` is a one-way encryption algorithm that is often used for
   passwords. There is no way to decrypt data which has been encrypted
   using MD5. See below for an example of how to use MD5 to store and
   check passwords securely.
-  ``SHA1`` is a one-way encryption algorithm that is often used for
   passwords. There is no way to decrypt data which has been encrypted
   using SHA.


   ``[Encrypt_BlowFish2]``
      Encrypts a string using an industry standard      
      BlowFish algorithm. Accepts two parameters, a     
      string to be encrypted and a ``-Seed`` keyword    
      with the key or password for the encryption.      
   
   ``[Decrypt_BlowFish2]``
      Decrypts a string encrypted using the industry    
      standard BlowFish algorithm. Accepts two          
      parameters, a string to be decrypted and a        
      ``-Seed`` keyword with the key or password for the decryption.
   
   ``[Encrypt_BlowFish]``
      Encrypts a string using the BlowFish              
      implementation from earlier versions of           
      Lasso. Accepts two parameters, a string to be     
      encrypted and a ``-Seed`` keyword with the key or 
      password for the encryption.                      
   
   ``[Decrypt_BlowFish]``
      Decrypts a string encrypted by the BlowFish       
      implementation from earlier versions of           
      Lasso. Accepts two parameters, a string to be     
      decrypted and a ``-Seed`` keyword with the key or 
      password for the decryption.                      
   
   ``[Encrypt_MD5]``
      Encrypts a string using the one-way MD5 hash      
      algorithm. Accepts one parameter, a string to be  
      encrypted. Returns a fixed size hash value in     
      hexadecimal for the string which cannot be        
      decrypted.

   ``[Encrypt_HMAC]``
    Generates a keyed hash message authentication code
      for a given input and password. The tag requires a
      ``-Password`` parameter which specifies the key   
      for the hash and a ``-Token`` parameter which     
      specifies the text message which is to be         
      hashed. These parameters should be specified as a 
      string or as a byte stream. The digest algorithm  
      used for the hash can be specified using an       
      optional ``-Digest`` parameter. The digest        
      algorithm defaults to ``MD5``. ``SHA1`` is another
      common option. However, any of the digest         
      algorithms returned by ``[Cipher_List: -Digest]`` 
      can be used. The output is a byte stream by       
      default. ``-Base64`` specifies the output should  
      be a Base64 encoded string. ``-Hex`` specifies the
      output should be a hex format string like         
      ``0x0123456789abcdef``. ``-Cram`` specifies the   
      output should be in a cram hex format like        
      ``0123456789ABCDEF``.


.. Note:: The BlowFish tags are not binary-safe. The output of the tag
    will be truncated after the first null character. It is necessary to
    use ``[Encode_Base64]`` or ``[Encode_UTF8]`` prior to encrypting
    data that might contain binary characters using these tags.

BlowFish Seeds
--------------

BlowFish requires a seed in order to encrypt or decrypt a string. The
same seed which was used to encrypt data using the
``[Encrypt_BlowFish2]`` tag must be passed to the
``[Decrypt_BlowFish2]`` tag to decrypt that data. If you lose the key
used to encrypt data then the data will be essentially unrecoverable.

Seeds can be any string between 4 characters and 112 characters long.
Pick the longest string possible to ensure a secure encryption. Ideal
seeds contain a mix of letters, digits, and punctuation.

The security considerations of storing, transmitting, and hard coding
seed values is beyond the scope of this manual. In the examples that
follow, we present methodologies which are easy to use, but may not
provide the highest level of security possible. You should consult a
security expert if security is very important for your Web site.

.. Note:: The BlowFish algorithm will return random results if you
    attempt to decrypt data which was not actually encrypted using the
    same algorithm.

**To store data securely in a database:**

Use the ``[Encrypt_BlowFish2]`` and ``[Decrypt_BlowFish2]`` tags to
encrypt data which will be stored in a database and then to decrypt the
data when it is retrieved from the database.

#. Store the data to be encrypted into a string variable, ``PlainText``.

   ::

        [Variable: 'PlainText' = 'The data to be encrypted.']

#. Encrypt the data using the ``[Encrypt_BlowFish2]`` tag with a
   hard-coded ``-Seed`` value. Store the result in the variable
   ``CipherText``.

   ::

        [Variable: 'CipherText' = (Encrypt_BlowFish2: (Variable: 'PlainText'),
            -Seed='This is the blowfish seed')]

#. Store the data in ``CipherText`` in the database. The data will not
   be viewable without the seed. The following ``[Inline]   [/Inline]``
   creates a new record in an ``Contacts`` database for ``John Doe``
   with the ``CipherText``.

   ::

        [Inline: -Add,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID',
            'First_Name'='John',
            'Last_Name'='Doe',
            'CipherText'=(Variable: 'CipherText')]
        [/Inline]

#. Retrieve the data from the database. The following ``[Inline]
   [/Inline]`` fetches the record from the database for ``John Doe``
   and places the ``CipherText`` into a variable named ``CipherText``.

   ::

        [Inline: -Search,
            -Database='Contacts',
            -Table='People',
            -KeyField='ID',
            'First_Name'='John',
            'Last_Name'='Doe']
            [Variable: 'CipherText' = (Field: 'CipherText')]
        [/Inline]

#. Decrypt the data using the ``[Decrypt_BlowFish2]`` tag with the same
   hard-coded ``-Seed`` value. Store the result in the variable
   ``PlainText``.

   ::

        [Variable: 'PlainText' = (Decrypt_BlowFish2: (Variable: 'CipherText'),
            -Seed='This is the blowfish seed')]

#. Display the new value stored in ``PlainText``.

   ::

        [Variable: 'PlainText']

        ->
        The data to be encrypted.

.. Note:: This example uses the ``[Encrypt_BlowFish2]`` and
    ``[Decrypt_BlowFish2]`` tags. These are the preferred BlowFish
    implementation to use with Lasso. The ``[Encrypt_BlowFish]`` and
    ``[Decrypt_BlowFish]`` tags should only be used for interoperability
    with older versions of Lasso.

**To store and check encrypted passwords:**

The ``[Encrypt_MD5]`` tag can be used to store a secure version of a
password for a site visitor. On every subsequent visit, the password
given by the visitor is encrypted using the same tag and compared to the
stored value. If they match, then the visitor has supplied the same
password they initially supplied.

#. When the visitor creates an account use ``[Encrypt_MD5]`` to create
   an encrypted version a fixed size hash value of the password they
   supply. In the following example, the password they supply is stored
   in the variable ``VisitorPassword`` and the encrypted version is
   stored in ``SecurePassword``.

   ::

        [Variable: 'SecurePassword' = (Encrypt_MD5: (Variable: 'VisitorPassword'))]

#. Store this MD5 hash value for the password in a database along with
   the visitor s username.

#. On the next visit, prompt the visitor for their username and
   password. Fetch the record identified by the visitor s specified
   username and retrieve the MD5 hash value stored in the field
   ``SecurePassword``.

#. Use ``[Encrypt_MD5]`` to encrypt the password that the visitor has
   supplied and compare the result to the stored, encrypted MD5 hash
   value that was generated from the password they supplied when they
   created their account.

   ::

        [If: (Encrypt_MD5: (Variable: 'VisitorPassword')) == (Field: 'SecurePassword')]
            Log in successful.
        [Else]
            Password does not match.
        [/If]

.. Note:: For more security, most log-in solutions require both a
    username and a password. The password is not checked unless the
    username matches first. This prevents site visitors from guessing
    passwords unless they know a valid username. Also, many login
    solutions restrict the number of login attempts that they will
    accept from a client s IP address.

Cipher Tags
===========

Lasso includes a set of tags that allow access to a wide variety of
encryption algorithms. These cipher tags provide implementations of many
industry standard encryption methods and can be very useful when
communicating using Internet protocols or communicating with legacy
systems.

The table below lists the ``[Cipher_ ]`` tags in Lasso. The following
tables list several of the cipher algorithms and digest algorithms that
can be used with the ``[Cipher_ ]`` tags. The ``[Cipher_List]`` tag can
be used to list what algorithms are supported in a particular Lasso
installation.

.. Note:: The actual list of supported algorithms may vary from Lasso
    installation to Lasso installation depending on platform and system
    version. The algorithms listed in this manual should be available on
    all systems, but other more esoteric algorithms may be available on
    some systems and not on others.

``[Cipher_Encrypt]``
  Encrypts a string using a specified               
  algorithm. Requires three parameters. The data to 
  be encrypted, a ``-Cipher`` parameter specifying  
  what algorithm to use, and a ``-Key`` parameter   
  specifying the key for the algorithm. An optional 
  ``-Seed`` parameter can be used to seed algorithms
  with a random component.                          

``[Cipher_Decypt]``
  Decrypts a string using a specified               
  algorithm. Requires three parameters. The data to 
  be decrypted, a ``-Cipher`` parameter specifying  
  what algorithm to use, and a ``-Key`` parameter   
  specifying the key for the algorithm.             

``[Cipher_Digest]``
  Encrypts a string using a specified digest        
  algorithm. Requires two parameters. The data to be
  encrypted and a ``-Digest`` parameter that        
  specifies the algorithm to be used. Optional      
  ``-Hex`` parameter encodes the result as a        
  hexadecimal string.                               

``[Cipher_List]``
  Lists the algorithms that the cipher tags         
  support. With a ``-Digest`` parameter returns only
  digest algorithms. With ``-SSL2`` or ``-SSL3``    
  returns only algorithms for that protocol.        
   

The following two tables list some of the cipher algorithms that can be
used with ``[Cipher_Encrypt]`` and some of the digest algorithms that
can be used with ``[Cipher_Digest]``. Use ``[Cipher_List]`` for a full
list of supported algorithms.

   ``AES``
    Advanced Encryption Standard. A symmetric key     
      encryption algorithm which is slated to be the    
      replacement for DES. An implementation of the     
      Rijndael algorithm.                               
   
   ``DES``
    Data Encryption Standard. A block cipher developed
      by IBM in 1977 and used as the government standard
      encryption algorithm for years.                   
   
   ``3DES``
    Triple DES. This algorithm uses the DES algorithm 
      three times in succession with different keys.    
   
   ``RSA``
    A public key algorithm named after Rivest, Shamir,
      and Adelmen. One of the most commonly used        
      encyrption algorithsm. Note: Lasso does not       
      generate public/private key pairs.                
   

   ``DSA``
    Digital Signature Algorithm. Part of the Digital  
      Signature Standard. Can be used to sign messages, 
      but not for general encryption.                   
   
   ``SHA1``
    Secure Hash Algorithm. Produces a 160-bit hash    
      value. Used by DSA.                               
   
   ``MD5``
    Message Digest. A hash function that generates a  
      128-bit message digest. Replaces the MD4 and MD2  
      algorithms (which are also supported). Also       
      implemented in Lasso as ``[Encrypt_MD5]``.        
   

**To list all supported algorithms:**

Use the ``[Cipher_List]`` tag. The following tag will return a list of
all the cipher algorithms supported by Lasso.

::

        [Cipher_List]

With a ``-Digest`` parameter the tag will return a list of all the
digest algorithms supported by Lasso.

::

        [Cipher_List: -Digest]

**To calculate a digest value:**

Use the ``[Cipher_Digest]`` tag. The following tag will return the DSA
signature for the value of a database field Message.

::

        [Cipher_Digest: (Field: 'Message'), -Digest='DSA']

**To encrypt a value using 3DES:**

Use the ``[Cipher_Encrypt]`` tag. The following tag will return the 3DES
encryption for the value of a database field Message.

::

        [Cipher_Encrypt: (Field: 'Message'), -Cipher='3DES', -Key='My Secret Key']

Serialization Tags
==================

LassoScript provides several tags which allow Lasso s native data types
to be transformed into an XML data stream that can be stored in a
database field, transmitted to a remote machine, or otherwise
manipulated. The ``[Serialize]`` and ``[Deserialize]`` tags are
equivalent to the ``[Null->Serialize]`` and ``[Null->Deserialize]`` tags
which are documented in another chapter.

.. Important:: Built-in data types can be serialized and deserialized at
   any time. In order to deserialize a custom data type the data type
   must be defined in the current context. Custom data types defined in
   the Lasso startup folder or earlier on the page than the
   ``[Deserialize]`` tag will work properly.


``[Serialize]``
  Accepts a single parameter. Converts the parameter
  to a byte stream representation. The returned     
  string can be stored in a database.               

``[Deserialize]``
  Accepts a single parameter which is a byte stream 
  that represents a Lasso value. Returns the value  
  represented by the parameter.                     
   

**To store a complex data type:**

Use the ``[Serialize]`` to transform the data type into a byte stream
string representation that can be stored in a database field. Then use
``[Deserialize]`` to transform the byte stream string representation
back into the original data type. The following example shows how to
convert an array into a string and then back again.

#. Store the array in a variable ``ArrayVariable``.

   ::

        [Variable: 'ArrayVariable'=(Array: 'one', 'two', 'three', 'four', 'five')]

#. Use the ``[Null->Serialize]`` tag to change the array into a string
   stored in ``TempVariable``.
   
   ::

        [Variable: 'TempVariable'=(Serialize: $ArrayVariable)]

#. The string representation of the array can now be changed back into
   the array by calling the ``[Deserialize]`` tag with ``TempVariable``
   as a parameter.

   ::

        [Variable: 'ArrayVariable'=(Deserialize: $TempVariable)]

#. Finally, the original array is output.

   ::

        [Variable: 'ArrayVariable']

        ->
        (Array: (one), (two), (three), (four), (five))

Compression Tags
================

LassoScript provides two tags which allow data to be stored or
transmitted more efficiently. The ``[Compress]`` tag can be used to
compress any text string into an efficient byte stream that can be
stored in a text field in a database or transmitted to another server.
The ``[Decompress]`` tag can then be used to restore a compressed byte
stream into the original string.

The compression algorithm should only be used on large string values.
For strings of less than one hundred characters the algorithm may
actually result in a larger string than the source.

These tags can be used in concert with the ``[Null->Serialize]`` tag
that creates a string representation of any data type in LassoScript and
the ``[Null->Deserialize]`` tag that returns the original value based on
a string representation. An example below shows how to compress and
decompress an array variable.

   ``[Compress]``
    Compresses a string parameter.
   
   ``[Decompress]``
    Decompresses a byte stream.   
   

**To compress and decompress a string:**

#. Use the ``[Compress]`` tag on the variable ``InputVariable`` holding
   the string value you want to compress. The result is a byte stream
   that represents the string which is stored in ``CompressedVariable``.

   ::

        [Variable: 'InputVariable'='This is the string to be compressed.']
        [Variable: 'CompressedVariable'=(Compress: $InputVariable)]

#. The ``CompressedVariable`` can now be decompressed using the
   ``[Decompress]`` tag. The result is stored in ``OutputVariable`` and
   finally displayed.

   ::

        [Variable: 'OutputVariable'=(Decompress: $CompressedVariable)]
        [Variable: 'OutputVariable']

        ->
        This is the string to be compressed.

**To compress and decompress an array:**

#. Store the array in a variable ``ArrayVariable``.

   ::

        [Variable: 'ArrayVariable'=(Array: 'one', 'two', 'three', 'four', 'five')]

#. Use the ``[Serialize]`` tag to change the array into a string stored
   in ``InputVariable``.

   ::

        [Variable: 'InputVariable'=(Serialize: $ArrayVariable)]

#. Use the ``[Compress]`` tag on the variable ``InputVariable`` holding
   the string representation for the array. The result is a byte stream
   which is stored in ``CompressedVariable``.

   ::

        [Variable: 'CompressedVariable'=(Compress: $InputVariable)]

#. The ``CompressedVariable`` can now be decompressed using the
   ``[Decompress]`` tag. The result is a string stored in
   ``OutputVariable``.

   ::

        [Variable: 'OutputVariable'=(Decompress: $CompressedVariable)]

#. The string representation of the array can now be changed back into
   the array by calling the ``[Deserialize]`` tag with
   ``OutputVariable`` as a parameter.

   ::

        [Variable: 'ArrayVariable'=(Deserialize: $OutputVariable)]

#. Finally, the original array can be output.

   ::

        [Variable: 'ArrayVariable']

        ->
        (Array: (one), (two), (three), (four), (five))
