.. _protocols-pipes:

**********************************
Networking Protocols & Named Pipes
**********************************

Lasso provides objects for TCP, TCP/SSL and UDP networking. It also provides
objects for local communications over named pipes. These networking objects are
designed to fit tightly into the language runtime's threading model. Each method
call which might block accepts a timeout parameter. All such timeouts are in
seconds.


TCP
===

TCP networking is provided through the `net_tcp` object. This object represents
either the client or the server end of a connection.


Creating net_tcp Objects
------------------------

A `net_tcp` object is created with no parameters. Once an object is obtained it
can be used to open or accept TCP connections. ::

   net_tcp()


Opening TCP Connections
-----------------------

.. type:: net_tcp
.. method:: net_tcp()
.. method:: net_tcp(fd::filedesc)

.. member:: net_tcp->connect(to::string, port::integer, timeout::integer = 4)

   Opens a TCP connection to the indicated server. TCP connections are made
   based on an address string and a port number. A server must be listening at
   the address and port before connections can be made to it. The address can be
   either a host name or a dotted IP address. The addresses '0.0.0.0' or
   '127.0.0.1' can be used for local connections.

   If the connection succeeds this method will return "true", otherwise it
   returns "false". The method does not cause a failure if the connection cannot
   be made. By default, this method will timeout after 4 seconds and return
   "false" if a connection cannot be made. It will return faster than that in
   cases where the indicated server is not on the network or has no server
   listening on the indicated port. This timeout is more likely to be hit when
   connecting to a server which is available but under heavy load and not
   processing new connections in a timely manner. This timeout value can be
   tailored for the expected network conditions. A value of "-1" indicates no
   timeout.


Accepting TCP Connections
-------------------------

A TCP server listens on a specific port for client connections. Once a client
connects, a new `net_tcp` object is returned for that connection. There are
several steps for establishing a server. The series of methods is generally:
`~net_tcp->bind`, `~net_tcp->listen` and then either `~net_tcp->accept` or
`~net_tcp->forEachAccept`.

.. member:: net_tcp->bind(port::integer, address::string = '0.0.0.0')
.. member:: net_tcp->listen(backlog::integer = 128)

   When acting as a server, the `net_tcp` object must first be bound to a local
   port and optional address. The address can be ignored in most cases, but is
   useful on machines which have multiple network interfaces. `bind` can be
   called before a client connection is made as well, however the operating
   system will automatically bind a client connection to a random port if it is
   not already bound, so binding a client connection is usually skipped.

   When creating a server, `listen` is called after `bind`. This method begins
   the `net_tcp` object accepting client connections.

.. member:: net_tcp->accept(timeoutSeconds::integer = -1)
.. member:: net_tcp->forEachAccept()

   After a `net_tcp` object has been bound and is listening, client connections
   can then be accepted. The `accept` method is called to accept one connection.
   The process of accepting a connection does not actually connect the `net_tcp`
   server object. Instead, a new `net_tcp` object is returned for that
   connection. Usually, the new connection will be passed to new thread. This
   permits the server's thread to continue accepting new connections in a loop
   while the newly accepted connection is free to handle itself independently.

   By default, `accept` will wait forever for a client to connect. The timeout
   parameter can be used to have the call return null if no client has connected
   in that period.

   The `forEachAccept` method is used to accept connections in a loop. This
   method is called and given a capture. Each accepted connection will be passed
   to that capture to be handled.

Example of creating a simple multi-threaded server::

   net_tcp->bind(8080) & listen & forEachAccept => {
     local(con = #1) // new client connection

     // move connection into new thread
     split_thread => {
       #con->writeString('HTTP/1.1 404 NOT FOUND\r\n\
               Connection: close\r\n\
               Server: Lasso\r\n\
               Content-Length: 11\r\n\r\n\
               NOT FOUND\r\n')
         & close
     }
   }


Closing TCP Connections
-----------------------

.. member:: net_tcp->close()

   TCP connections should be closed as soon as they are no longer needed. Once a
   `net_tcp` object has been closed it should not be used again.

.. member:: net_tcp->shutdownRd()
.. member:: net_tcp->shutdownWr()
.. member:: net_tcp->shutdownRdWr()

   These methods give greater control over closing the connection at the TCP
   level. Respectively, these methods close down communications channels for the
   read, write or read and write directions. `close` should still be called
   after a shutdown.


Reading TCP Data
----------------

.. member:: net_tcp->readSomeBytes(count::integer, timeoutSeconds::integer)

   Attempts to read up to the indicated number of bytes. If any bytes are
   immediately available then those will be returned and may be fewer than the
   requested amount. The timeout parameter controls how long the method will
   wait for data if there is none to be read. The method will return "null" if
   the timeout is reached.


Writing TCP Data
----------------

.. member:: net_tcp->writeBytes(data::bytes, offset::integer = 0, length::integer = -1)

   Attempts to send the indicated bytes. An optional zero-based ``offset``
   parameter indicates how far in the bytes to skip before sending. An optional
   ``length`` parameter indicates how many bytes to sent. The default value of
   "-1" indicates that all the bytes should be sent.

   This method returns the number of bytes which were sent. However, this number
   will always match the number of bytes requested to be sent. This method
   automatically handles TCP flow control, but does not accept a timeout value.


TCP/SSL
=======

Secure sockets layer (SSL) support is provided through the `net_tcp_ssl` object.
This type inherits from `net_tcp`, and so inherits all of its methods plus a few
SSL-specific additions. SSL is turned on and off for connections which are
already established. When being used as a server, the `net_tcp_ssl` object will
return new `net_tcp_ssl` objects with SSL turned on.


Creating net_tcp_ssl Objects
----------------------------

This creates and returns a new `net_tcp_ssl` object. It accepts no parameters.
::

   net_tcp_ssl()


Loading SSL Certificates
------------------------

.. type:: net_tcp_ssl
.. method:: net_tcp_ssl()
.. method:: net_tcp_ssl(fd::filedesc)

.. member:: net_tcp_ssl->loadCerts(cert::string, privateKey::string)

   Accepts the file paths to a certificate file and a private key file. This
   method is required when creating a TCP SSL server. The paths should be full
   OS-specific paths to the files. This method calls through to OpenSSL to the
   functions ``SSL_CTX_use_certificate_chain_file`` and
   ``SSL_CTX_use_PrivateKey_file``. This method will fail if an error is
   returned from the OpenSSL functions, in which case the OpenSSL-specific error
   code and message will be set.


Beginning & Ending SSL Sessions
-------------------------------

.. member:: net_tcp_ssl->beginTLS(timeoutSecs::integer = 5)

   Begins SSL communications for the connection. Because starting SSL requires a
   series of communications between the two hosts, this method accepts a timeout
   parameter which will terminate the action if it takes too long to complete.

   This method returns no value, but will fail if an error is produced by the
   underlying OpenSSL library.

.. member:: net_tcp_ssl->endTLS()

   Ends the SSL session and returns the connection to its non-SSL state. The
   connection is not terminated in any way.


Accepting SSL Connections
-------------------------

Accepting SSL connections is accomplished in the same manner as accepting
non-SSL connections. However, serving SSL requires setting the certificate and
private key files through the `net_tcp_ssl->loadCerts` method.

The `net_tcp_ssl` object supports both `accept` and `forEachAccept` just as
`net_tcp` does. Accepting a connection using either of those methods will
returns a `net_tcp_ssl` object which has started the SSL session. Because some
protocols require connections to be established first and then switched to SSL,
`net_tcp_ssl` also provides an `~net_tcp_ssl->acceptNoSSL` method.

.. member:: net_tcp_ssl->acceptNoSSL(timeoutSeconds::integer = -1)::net_tcp_ssl

   Accepts a new connection and returns a `net_tcp_ssl` object for it. This
   connections has not yet started an SSL session and operates just as a
   `net_tcp` connection would. SSL can be started though the
   `net_tcp_ssl->beginTLS` method.


UDP
===

UDP is a connectionless protocol. It is used to transmit individual packets of
data to a server.


Creating net_udp Objects
------------------------

This method accepts no parameters and returns a new `net_udp` object. ::

   net_udp()


Reading UDP Data
----------------

Reading UDP data requires first binding the `net_udp` object to a specific port
and optional address. Once bound, data can be read through the
`net_udp->readPacket` method. Data is returned as a `net_udp_packet` object
which contains the bytes data sent as well as the address of the sender and the
port from which it was sent.

.. type:: net_udp
.. method:: net_udp()
.. method:: net_udp(fd::filedesc)

.. member:: net_udp->readPacket(maxBytes::integer, timeoutSeconds::integer = -1)

   Waits to receive a new UDP packet. The ``maxBytes`` parameter indicates the
   maximum size of data to receive. The number of bytes returned may be fewer
   than indicated, though individual packets will not be segmented. This value
   affects the size of the memory buffer allocated internally to hold incoming
   data.

   The timeout parameter indicates how long the method should wait before
   returning a "null" value. The default value of "-1" indicates that the method
   should wait forever.

   When successful, this method returns a `net_udp_packet` object.

.. type:: net_udp_packet
.. method:: net_udp_packet(bytes, name, port)

.. member:: net_udp_packet->bytes()::bytes

   Returns the bytes received.

.. member:: net_udp_packet->fromName()::string
.. member:: net_udp_packet->fromPort()::integer

0

Writing UDP Data
----------------

With a `net_udp` object, data is sent one packet at a time to a particular
address and port combination. The receivers must be waiting to accept packets
from other hosts.

.. member:: net_udp->writeBytes(b::bytes, toAddress::string, toPort::integer)::integer

   Sends the specified bytes to the indicated host. It returns the number of
   bytes which were sent.


Closing net_udp Objects
-----------------------

.. member:: net_udp->close()

   Although `net_udp` objects do not maintain a connection, they must still be
   closed when they are no longer needed to free up resources.


Named Pipes
===========

A named pipe is a means of communication between processes on a single local
machine. One process begins listening on a pipe with a particular name. Other
processes connect to that pipe and data is exchanged. `net_named_pipe` objects
inherit from `net_tcp` and so all of the same methods for reading and writing
bytes data are available. Named pipe usage differs in that the bind and connect
methods takes a pipe name parameter (with no port number). The
`net_named_pipe->accept` method will return a `net_named_pipe` object for the
new connection.

`net_named_pipe` objects are implemented as UNIX domain sockets on UNIX-based
systems and as Named Pipes on Windows.


Creating net_named_pipe Objects
-------------------------------

No parameters are required to create a new `net_named_pipe` object. ::

   net_named_pipe()


Opening Named Pipe Connections
------------------------------

.. type:: net_named_pipe
.. method:: net_named_pipe()
.. method:: net_named_pipe(fd::filedesc)

.. member:: net_named_pipe->connect(to::string, timeoutSeconds::integer = 4)

   Attempts to connect to the indicated named pipe. This method returns "true"
   if the connection was made, and "false" otherwise.


Accepting Named Pipe Connections
--------------------------------

.. member:: net_named_pipe->bind(to::string)
.. member:: net_named_pipe->listen(backlog::integer = 128)
.. member:: net_named_pipe->accept(timeoutSeconds::integer = -1)

   The `bind` method attempts to create a pipe with the given name. It accepts
   one parameter which is the name of the pipe to create. There can be only one
   listener on any given pipe name. The method will fail if there is a problem
   creating the pipe.

   The `listen` and `accept` methods operate as described for `net_tcp`,
   except that `net_named_pipe->accept` will return new `net_named_pipe`
   objects for each new connection.
