.. _encryption:

**********
Encryption
**********

Lasso provides a set of data encryption methods which support the most commonly
used encryption and hash functions used on the Internet today. These encryption
methods make it possible to interoperate with other systems that require
encryption and to store data in a secure fashion in data sources or files.

Lasso has built-in methods for the BlowFish encryption algorithm and for the
SHA1 and MD5 hash algorithms.

Lasso's cipher methods provide access to a wide range of industry standard
encryption algorithms. The ``cipher_list`` method lists which algorithms are
available on your system and the ``cipher_encrypt``, ``cipher_decrypt``, and
``cipher_digest`` methods allow values to be encrypted, decrypted, or digest
values to be generated respectively.

Finally, Lasso provides a set of methods to compress or decompress data for more
efficient data transmission.


Encryption Methods
==================

Lasso provides a number of methods which allow data to be encrypted for secure
storage or transmission. Three different types of encryption are supplied:

BlowFish
   This is a fast, popular encryption algorithm. Lasso provides tools to encrypt
   and decrypt string values using a developer-defined seed. This is the best
   method to use for data which needs to be stored in a database or transmitted
   securely and decrypted later.

MD5
   This is a one-way encryption algorithm that is often used for passwords.
   There is no way to decrypt data which has been encrypted using MD5.

SHA1
   This is a one-way encryption algorithm that is often used for passwords.
   There is no way to decrypt data which has been encrypted using SHA.

.. method:: encrypt_blowfish(plaintext, -seed::string)

   Encrypts a string using an industry standard BlowFish algorithm. Accepts two
   parameters, a string to be encrypted and a ``-seed`` keyword with the key or
   password for the encryption. It returns an encrypted bytes object.

   The BlowFish methods are not binary-safe. The output of the tag will be
   truncated after the first null character. It is necessary to use
   ``encode_base64``, ``encode_hex``, or ``encode_utf8`` prior to encrypting
   data that might contain binary characters using these methods.

.. method:: decrypt_blowfish(cyphertext, -seed::string)

      Decrypts a string encrypted using the industry standard BlowFish
      algorithm. Accepts two parameters, a string to be decrypted and a
      ``-seed`` keyword parameter with the key or password for the decryption.
      Returns a decrypted bytes object.

.. method:: encrypt_md5(data::bytes)::string
.. method:: encrypt_md5(data::any)::string

      Encrypts a string using the one-way MD5 hash algorithm. Accepts one
      parameter, the data to be encrypted. Returns a fixed size hash value in
      hexadecimal which cannot be decrypted.

.. method:: encrypt_hmac(\
      -password, \
      -token, \
      -digest= ?, \
      -base64::boolean= ?, \
      -hex::boolean= ?, \
      -cram::boolean= ?, \
      ...\
   )

   Generates a keyed hash message authentication code for a given input and
   password. The method requires a ``-password`` parameter which specifies the
   key for the hash and a ``-token`` parameter which specifies the text message
   which is to be hashed. These parameters should be specified as a string or as
   a byte stream. The digest algorithm used for the hash can be specified using
   an optional ``-digest`` parameter. The digest algorithm defaults to "MD5".
   "SHA1" is another common option. However, any of the digest algorithms
   returned by ``cipher_list(-digest)`` can be used. The output is a byte stream
   by default. The ``-base64`` parameter specifies the output should be a Base64
   encoded string. The ``-hex`` parameter specifies the output should be a hex
   format string like "0x0123456789abcdef". The ``-cram`` parameter specifies
   the output should be in a cram hex format like "0123456789ABCDEF".


BlowFish Seeds
--------------

BlowFish requires a seed in order to encrypt or decrypt a string. The same seed
which was used to encrypt data using the ``encrypt_blowfish`` method must be
passed to the ``decrypt_blowfish`` method to decrypt that data. If you lose the
key used to encrypt data then the data will be essentially unrecoverable.

Seeds can be any string between 4 characters and 112 characters long. Pick the
longest string possible to ensure a secure encryption. Ideal seeds contain a mix
of letters, digits, and punctuation.

The security considerations of storing, transmitting, and hard coding seed
values is beyond the scope of this manual. In the examples that follow, we
present methodologies which are easy to use, but may not provide the highest
level of security possible. You should consult a security expert if security is
very important for your web site.


Store Data Securely in a Database
---------------------------------

Use the ``encrypt_blowfish`` and ``decrypt_blowfish`` methods to encrypt data
which will be stored in a database and then to decrypt the data when it is
retrieved from the database.

In the example below, the data in the variable "plaintext" is encrypted and
stored in the "ciphertext" variable. This is then used to store the data in the
"ciphertext" field of the "people" table in the "contacts" database::

   local(plaintext) = 'The data to be encrypted.'
   local(ciphertext) = encrypt_blowfish(#plaintext, -seed='My Insecure Seed')

   inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe',
      'ciphertext'=encode_base64(#ciphertext)
   ) => {}

The example below retrieves the record created above and sticks the Base64
decoded "ciphertext" field in a variable of the same name. It then decrypts the
data into the "plaintext" variable and displays that variable::

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe'
   ) => {
      local(ciphertext) = decode_base64(field('ciphertext'))
   }

   local(plaintext) = decrypt_blowfish(#ciphertext, -seed='My Insecure Seed')
   #plaintext

   // => The data to be encrypted.


Store and Check Encrypted Passwords
-----------------------------------

The ``encrypt_md5`` method can be used to store a secure version of a password
for a site visitor. On every subsequent visit, the password given by the visitor
is encrypted using the same method and compared to the stored value. If they
match, then the visitor has supplied the same password they initially supplied.

The following example takes a vistor-supplied password from a form and stores it
into the "people" table in the "contacts" database::

   local(visitor_password) = web_request->param('password')
   inline(
      -add,
      -database='contacts',
      -table='people',
      -keyField='id',
      'first_name'='John',
      'last_name'='Doe',
      'username'='dodo',
      'password'=encrypt_md5(#visitor_password)
   ) => {}

On subsequent visits, prompt the visitor for their username and password. The
following example shows how you can verify the credentials they pass in a form::

   local(username) = web_request->param('username')
   local(password) = web_request->param('passowrd')

   inline(
      -search,
      -database='contacts',
      -table='people',
      -keyField='id',
      'username' = #username,
      'password' = encrypt_md5(#password)
   ) => {
      local(is_authenticated) = (found_count > 0)
   }
   if(#is_authenticated) => {
      // Log in successfull
      // ...
   else
      // Credentials don't match
      // ...
   }

.. note::
   For more security, most log-in solutions require both a username and a
   password. The password is not checked unless the username matches first. This
   prevents site visitors from guessing passwords unless they know a valid
   username. Also, many login solutions restrict the number of login attempts
   that they will accept from a client s IP address, use salts, and iterate over
   the encryption algorithm thousands of times. To reiterate: You should consult
   a security expert if security is very important for your web site.


Cipher Methods
==============

Lasso includes a set of methods that allow access to a wide variety of
encryption algorithms. These cipher methods provide implementations of many
industry standard encryption methods and can be very useful when communicating
using Internet protocols or communicating with legacy systems.

The table below lists the ``[Cipher_ ]`` tags in Lasso. The following tables
list several of the cipher algorithms and digest algorithms that can be used
with the ``[Cipher_ ]`` tags. The ``[Cipher_List]`` tag can be used to list what
algorithms are supported in a particular Lasso installation.

.. note::
   The actual list of supported algorithms may vary from Lasso installation to
   Lasso installation depending on the platform and system version. The
   algorithms listed in this manual should be available on all systems, but
   other more esoteric algorithms may be available on some systems and not on
   others.

.. method:: cipher_encrypt(data, -cipher::string, -key, -seed= ?)::bytes

   Encrypts a string using a specified algorithm. Requires three parameters: The
   data to be encrypted, a ``-cipher`` keyword parameter specifying which
   algorithm to use, and a ``-key`` keyword parameter specifying the key for the
   algorithm. An optional ``-seed`` parameter can be used to seed some
   algorithms with a random component.

.. method:: cipher_decypt(data, -cipher::string, -key, -seed= ?)::bytes

   Decrypts a string using a specified algorithm. Requires three parameters: The
   data to be decrypted, a ``-cipher`` keyword parameter specifying which
   algorithm to use, and a ``-key`` keyword parameter specifying the key for the
   algorithm. An optional ``-seed`` parameter can be used to seed some
   algorithms with a random component.

.. method:: cipher_digest(data, -digest, -hex::boolean= ?)::bytes

   Encrypts data using a specified digest algorithm. Requires two parameters:
   The data to be encrypted and a ``-digest`` parameter that specifies the
   algorithm to be used. Optional ``-hex`` parameter encodes the result as a
   hexadecimal string.

.. method:: cipher_list(-digest::boolean= ?)

   Lists the algorithms that the cipher methods support. With the opitonal
   ``-digest`` parameter, it returns only digest algorithms.


The following list some of the cipher algorithms that can be used
with ``cipher_encrypt`` and some of the digest algorithms that can be used with
``cipher_digest``. Use ``cipher_list`` for a full list of supported algorithms.

AES
   Advanced Encryption Standard. A symmetric key encryption algorithm which is
   slated to be the replacement for DES. An implementation of the Rijndael
   algorithm.

DES
   Data Encryption Standard. A block cipher developed by IBM in 1977 and used as
   the government standard encryption algorithm for years.

3DES
   Triple DES. This algorithm uses the DES algorithm three times in succession
   with different keys.

RSA
   A public key algorithm named after Rivest, Shamir, and Adelmen. One of the
   most commonly used encyrption algorithsm. Note: Lasso does not generate
   public/private key pairs.

DSA
   Digital Signature Algorithm. Part of the Digital Signature Standard. Can be
   used to sign messages, but not for general encryption.

SHA1
   Secure Hash Algorithm. Produces a 160-bit hash value. Used by DSA.

MD5
   Message Digest. A hash function that generates a 128-bit message digest.
   Replaces the MD4 and MD2 algorithms (which are also supported). Also
   implemented in Lasso as ``encrypt_md5``.


List All Supported Algorithms
-----------------------------

Use the ``Cipher_List`` method. The following example will return a list of all
the cipher algorithms supported by this installation of Lasso::

   cipher_list
   // => staticarray(DES-ECB, DES-EDE, DES-CFB, DES-OFB, DES-CBC, DES-EDE3-CBC, RC4, RC2-CBC, BF-CBC, CAST5-CBC, RC5-CBC)

With a ``-digest`` parameter the method will limit the returned list to all of
the digest algorithms supported by this installation of Lasso::

   cipher_list(-digest)
   // => staticarray(MD2, MD4, MD5, SHA, SHA1, DSA-SHA, DSA, RIPEMD160)


Calculate a Digest Value
------------------------

Use the ``cipher_digest`` method. The following example will return the DSA
signature for the value of a database field "message"::

   cipher_digest(field('message'), -digest='DSA')


Encrypt a Value Using 3DES
--------------------------

Use the ``cipher_encrypt`` method. The following example will return the 3DES
encryption for the value of a database field "message"::

   cipher_encrypt(field('message'), -cipher='3DES', -key='My Secret Key')


Compression Methods
===================

Lasso provides two methods that allow data to be stored or transmitted more
efficiently. The ``compress`` method can be used to compress any text string
into an efficient byte stream that can be stored in a binary field in a database
or transmitted to another server. The ``decompress`` method can then be used to
restore a compressed byte stream into the original string.

The compression algorithm should only be used on large string values. For
strings of less than one hundred characters the algorithm may actually result in
a larger string than the source.

These methods can be used in concert with the ``null->serialize`` method that
creates a string representation of a type that implements ``trait_serializable``
and the ``serialization_reader->read`` method that returns the original value
based on a string representation. An example below shows how to compress and
decompress an array object.

.. method:: compress(b::bytes)
.. method:: compress(s::string)

   Compresses a string or bytes object.

.. method:: uncompress(b::bytes)
.. method:: decompress(b::bytes)

   Decompresses a byte stream.


Compress and Decompress a String
--------------------------------

The following example takes the string value stored in the variable "input" and
compresses it and stores that information in "smaller". Finally, it decompresses
the data into the variable "output" and then displays the value now stored in
output::

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
then displayed::

   local(my_array) = array('one', 'two', 'three', 'four', 'five')
   local(input)    = #my_array->serialize
   local(smaller)  = compress(#input)
   local(output)   = serialization_reader(xml(decompress(#smaller)))->read
   #output

   // => array(one, two, three, four, five)
