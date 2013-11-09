.. _curl:

**************************
Network Requests with Curl
**************************

Lasso provides a complete interface to the open source `cURL library`_. Curl
transfers data with URL syntax, supporting a wide variety of protocols such as
"DICT", "FILE", "FTP", "FTPS", "Gopher", "HTTP", "HTTPS", "IMAP", "IMAPS",
"LDAP", "LDAPS", "POP3", POP3S, "RTMP", "RTSP", "SCP", "SFTP", "SMTP", "SMTPS",
"Telnet" and "TFTP".

Curl has built-in support for SSL certificates, HTTP POST, HTTP PUT, FTP
uploading, proxies, cookies, user+password authentication, proxy tunnelling, and
more.


Lasso Curl API
==============

.. type:: curl
.. method:: curl()
.. method:: curl(url::string, -username::string= ?, -password::string= ?)

   There are two `curl` creator methods. The first creates an empty curl object.
   The second takes a string representing the URL to be eventually called, and
   it optionally takes a username and password to be used for authentication.

.. member:: curl->url()

   Returns the current URL set for the curl object.

.. member:: curl->url=(s::string)

   Sets the URL for the current curl object.

.. member:: curl->postFields=(s::string)
.. member:: curl->postFields=(b::bytes)

   Sets the full data to post in an HTTP POST operation. You must make sure that
   the data is formatted the way you want the server to receive it. The curl
   object will not convert or encode it. Most web servers will assume this data
   will be URL encoded.

   Use the method taking a bytes object in order to have control over the
   encoding of the data to be sent to the destination server. An example of this
   would be sending a binary image file.

.. member:: curl->contentType=(s::string)

   Override the default HTTP :mailheader:`Content-Type:` header by setting this
   value.

.. member:: curl->close()

   Close the current curl object.

.. member:: curl->asString()

   Return the result of performing the current curl object's action as a string.
   If no URL is set, it will just return an empty string.

.. member:: curl->asBytes()

   Returns the result of performing the current curl object's action as bytes.

.. member:: curl->done()

   Returns "true" or "false", indicating the completion state of the current
   curl operation.

.. member:: curl->get(key)

   Request internal information from the curl session. The key should be one of
   the ``CURLINFO_…`` methods.

.. member:: curl->set(key, value)

   Used to set specific curl option behavior. The key should be one of the
   ``CURLOPT_…`` methods. These options and appropriate values can be reviewed
   in the `curl documentation`_.

.. member:: curl->header()

   Returns the header data as a bytes object for the current curl request.

.. member:: curl->result()

   Returns the result of performing the current curl object's action as bytes.
   (For HTTP requests, it just returns the body portion, not the headers.)

.. member:: curl->statusCode()

   Return the last received HTTP, FTP or SMTP response code. The value will be
   zero if no server response code has been received.

.. member:: curl->raw()

   Returns the result of performing the current curl object request as a
   staticarray containing the ready state (boolean), the header response
   (bytes), and the body response (bytes).

.. member:: curl->reset()

   Resets the current curl object to an empty curl object.

.. member:: curl->version(info= ?)

   Returns a string of the version of curl currently deployed on the host
   system. If the optional "info" parameter is supplied as "true", then more
   detailed information will be returned as a staticarray.

.. member:: curl->readSomeBytes()

   This is a low-level function and is not recommended to be for casual use. If
   a request is still in progress, it returns the current response as a bytes
   object and clears the internal mechanism that is buffering those bytes.

.. member:: curl->download(f::string= ?, -asBytes::boolean= ?)

   Triggers the download of the file specified by the URL. The default is to
   download the file to the path specified in the first optional parameter. If
   the ``-asBytes`` option is passed or set to "true", then it will just return
   a bytes object representing the file's data. Refer to the detailed
   documentation later in this chapter for example usage.

.. member:: curl->upload(f::string)
.. member:: curl->upload(f::file)
.. member:: curl->upload(f::bytes)

   Triggers the uploading of a specified file to the file location specified by
   the URL. The file to be uploaded can be specified as either a string of
   the file path and name, a file object, or a bytes object of the data.
   Refer to the detailed documentation later in this chapter for example usage.

.. member:: curl->ftpDeleteFile()

   Deletes the file specified by the URL from the FTP server.

.. member:: curl->ftpGetListing(-listOnly::boolean= ?, -options::array= ?)

   Retrieves the directory listing from the FTP server and directory path
   specified by the URL. If the ``-listOnly`` option is specified, the result
   will just be returned as a staticarray while the default is to return an
   array of maps with each map having the following data about the files:
   "filetype", "filesize", "filemoddate", and "filename".

   There is an optional ``-options`` parameter that can take an array of pairs
   specifying additional curl options. The first item in the pair should be one
   of the ``CURLOPT_…`` methods and the second should be the corresponding value
   you wish to set.


Curl Options
============

A myriad of curl options can be set for the current curl object to customize its
behavior. This can be done by using the `curl->set` method, passing it the
``CURLOPT_…`` macro methods representing the option you wish to set and the
value you wish to set it to as the second param. What follows is a list of
options that can be set on Lasso's curl object. It has been adapted from the
`curl documentation`_, with the options grouped in a similar manner as you find
there. This should allow you to easily find the option if you need more detail.


Behavior Options
----------------

.. method:: CURLOPT_VERBOSE()

   Used with `curl->set`. If set to "1", it directs curl to output a lot of
   verbose information about its operations. This is very useful for debugging.
   The verbose information will be sent to STDERR which gets logged to
   :file:`lasso.err.txt` in your instances home directory for Lasso Server. You
   will almost never want to set this in production, but you will want to use it
   to help you debug and report problems.

.. method:: CURLOPT_HEADER()

   Used with `curl->set`. If set to "1", it directs the library to include the
   header in the body output. This is only relevant for protocols that actually
   have headers preceding the data (like HTTP).

.. method:: CURLOPT_NOPROGRESS()

   Used with `curl->set`. If set to "1", it tells the library to shut off the
   progress meter completely. It will also prevent the CURLOPT_PROGRESSFUNCTION
   from getting called. Future versions of libcurl are likely not to have any
   built-in progress meter at all.


Callback Options
----------------

.. method:: CURLOPT_WRITEDATA()

   Used with `curl->set`. This option expects a filedesc object which curl will
   use when calling its file write function.

.. method:: CURLOPT_READDATA()

   Used with `curl->set`. This option expects either a filedesc or bytes object
   to be used when curl calls its file read function.


Error Options
-------------

.. method:: CURLOPT_FAILONERROR()

   Used with `curl->set`. If set to a value of "1", curl should fail silently if
   the HTTP status code is equal to or larger than 400. The default action would
   be to return the page normally, ignoring that code. This method is not fail-
   safe, and there are scenarios where unsuccessful response codes will slip
   through.


Network Options
---------------

.. method:: CURLOPT_URL()

   Used with `curl->set`. You can use this instead of `curl->url=` to change the
   URL for the curl object. All URLs should be in the general form of
   "scheme://host:port/path" as detailed in :rfc:`3986`.

.. method:: CURLOPT_PROXY()

   Used with `curl->set`. Sets the HTTP proxy to use for the current curl
   object's request. This value should be passed as a string.

.. method:: CURLOPT_PROXYPORT()

   Used with `curl->set`. Sets the proxy port to connect to unless it is
   specified in the proxy string `CURLOPT_PROXY`. This value should be an
   integer.

.. method:: CURLOPT_PROXYTYPE()

   Used with `curl->set`. Sets type of the proxy. The value should be one of the
   following methods: ``CURLPROXY_HTTP``, ``CURLPROXY_SOCKS4``,
   ``CURLPROXY_SOCKS5``.

.. method:: CURLOPT_HTTPPROXYTUNNEL()

   Used with `curl->set`. If set to a value of "1", curl will tunnel all
   operations through a given HTTP proxy. This is different to simply using a
   proxy.

.. method:: CURLOPT_INTERFACE()

   Used with `curl->set`. Sets the interface name to use as the outgoing network
   interface. The name can be an interface name, an IP address, or a host name.
   This value should be passed as a string.

.. method:: CURLOPT_BUFFERSIZE()

   Used with `curl->set`. Pass an integer that will be used to indicate your
   preferred size (in bytes) for the receive buffer used by curl. This is just a
   request to the library, the actual buffer size used may be different than
   your request.

.. method:: CURLOPT_PORT()

   Used with `curl->set`. Specifies which remote port number to connect to
   instead of the one specified in the URL, or specifies the default port for
   the protocol used. This value should be an integer.

.. method:: CURLOPT_TCP_NODELAY()

   Used with `curl->set`. Specifies whether the TCP_NODELAY option is to be set
   or cleared (1 = set, 0 = clear). The option is cleared by default. Setting
   this option after the connection has been established will have no effect.


Authentication Options
----------------------

.. method:: CURLOPT_NETRC()

   Used with `curl->set`. This option controls the preference of curl between
   using user names and passwords from your :file:`~/.netrc` file, relative to
   user names and passwords in the URL. The value passed should be one of the
   following methods:

   .. method:: CURL_NETRC_OPTIONAL()

      The use of your :file:`~/.netrc` file is optional, and information in the
      URL is to be preferred.

   .. method:: CURL_NETRC_IGNORED()

      The library will ignore the :file:`~/.netrc` file and use only the
      information in the URL.

   .. method:: CURL_NETRC_REQUIRED()

      The use of your :file:`~/.netrc` file is required, and the library should
      ignore the information in the URL.


.. method:: CURLOPT_NETRC_FILE()

   Used with `curl->set`. Set to a string containing the full path name to the
   file you want libcurl to use as the :file:`.netrc` file. If this option is
   omitted and `CURLOPT_NETRC` is set to use a :file:`.netrc` file then curl
   will attempt to find a :file:`.netrc` file in the current user's home
   directory.

.. method:: CURLOPT_USERPWD()

   Used with `curl->set`. The option expects a string that will be used to
   authenticate with the remote server. The string should be formatted to
   include both username and password in the following manner:
   "myname:mypassword".

.. method:: CURLOPT_PROXYUSERPWD()

   Used with `curl->set`. This option expects a string that specifies the
   authentication for the HTTP proxy in the format of "username:password". Use
   `CURLOPT_PROXYAUTH` to specify the authentication method.

.. method:: CURLOPT_HTTPAUTH()

   Used with `curl->set`. Use this option to specify which HTTP authentication
   method(s) you want curl to use. If you specify more than one method, curl
   will first query the server to see which methods it supports and pick the
   best one you allow it to use.

   The value should be one or more of the following methods added together:
   ``CURLAUTH_BASIC``, ``CURLAUTH_DIGEST``, ``CURLAUTH_GSSNEGOTIATE``, or
   ``CURLAUTH_NTLM``. If you want to allow any method, you can use
   ``CURLAUTH_ANY``, and ``CURLAUTH_ANYSAFE`` allows for any method except
   ``CURLAUTH_BASIC``.

.. method:: CURLOPT_PROXYAUTH()

   Used with `curl->set`. Use this option to specify which HTTP authentication
   method(s) you want curl to use. See `CURLOPT_HTTPAUTH` for a list of values
   for this option.


HTTP Options
------------

.. method:: CURLOPT_ENCODING()

   Used with `curl->set`. This option takes a string value specifying the
   :mailheader:`Accept-Encoding` header which also enables decoding of a
   response when a :mailheader:`Content-Encoding` header is received. The string
   value passed should be one of the following: "identity", which does nothing;
   "deflate", which requests the server to compress its response using the zlib
   algorithm; or "gzip", which requests the gzip algorithm.

.. method:: CURLOPT_AUTOREFERER()

   Used with `curl->set`. If set to "1", then curl will set the
   :mailheader:`Referer` header when it follows a :mailheader:`Location`
   redirect.

.. method:: CURLOPT_FOLLOWLOCATION()

   Used with `curl->set`. If set to "1", then curl will follow any
   :mailheader:`Location` header the server sends as part of its HTTP response.
   This means that curl will send the same request to the new location and
   follow any new :mailheader:`Location` headers all the way until no more such
   headers are returned. `CURLOPT_MAXREDIRS` can be used to limit the number of
   redirects curl will follow.

.. method:: CURLOPT_UNRESTRICTED_AUTH()

   Used with `curl->set`. If set to "1", then curl will continue to send
   authentication (username & password) when following locations, even if the
   hostname changes. (This option is meaningful only when setting
   `CURLOPT_FOLLOWLOCATION`.)

.. method:: CURLOPT_MAXREDIRS()

   Used with `curl->set`. Expects an integer value specifying the number of
   times curl will repeat the recursive following of the :mailheader:`Location`
   header. A value of "0" will mean that no redirects will be followed while a
   value of "-1" (the default) means that an infinite number of redirects will
   be followed.

.. method:: CURLOPT_PUT()

   .. deprecated:: 7.12.1
      This option is deprecated in curl in favor of using `CURLOPT_UPLOAD`.

   Used with `curl->set`. If set to "1", then curl will use the HTTP PUT method
   to transfer data. The data should be set with `CURLOPT_READDATA` and
   `CURLOPT_INFILESIZE`.

.. method:: CURLOPT_POST()

   Used with `curl->set`. If set to "1", then curl will use the HTTP POST method
   for its request. This will also have the request use a
   :mailheader:`Content-Type: application/x-www-form-urlencoded` header (by far
   the most commonly used :mailheader:`Content-Type` for the POST method). You
   can override this header by setting your own with `CURLOPT_HTTPHEADER`.

   Use `CURLOPT_POSTFIELDS` to specify what data to post and
   `CURLOPT_POSTFIELDSIZE` or `CURLOPT_POSTFIELDSIZE_LARGE` to set the data
   size.

.. method:: CURLOPT_POSTFIELDS()

   Used with `curl->set`. You can use this instead of `curl->postFields=` to
   specify the data to post in an HTTP POST operation. The value can be either
   bytes or a string. You must make sure that the data is formatted the way you
   want the server to receive it; curl will not convert or encode it for you.
   Most web servers will assume this data will be URL encoded.

   Using `CURLOPT_POSTFIELDS` implies `CURLOPT_POST`; that option will be
   automatically set along with all of its other side effects.

   If you want to do a zero-byte POST, you need to set `CURLOPT_POSTFIELDSIZE`
   explicitly to zero. Simply setting `CURLOPT_POSTFIELDS` to NULL or an empty
   string effectively disables the sending of the specified string, and curl
   will instead assume that you'll send the POST data using the read callback.


.. method:: CURLOPT_POSTFIELDSIZE()

   Used with `curl->set`. By default, curl will use ``strlen()`` (the C function
   for getting a string's length) to measure the size of the post data field
   being sent. This option allows you to pass an integer value specifying the
   size of the post field data. Generally speaking, posting binary data will
   require you to set this option.

.. method:: CURLOPT_POSTFIELDSIZE_LARGE()

   Used with `curl->set`. This is the large file version of
   `CURLOPT_POSTFIELDSIZE`.

.. method:: CURLOPT_REFERER()

   Used with `curl->set`. This option takes a string value that specifies the
   value for the :mailheader:`Referer` header in the HTTP request sent to the
   remote server.

.. method:: CURLOPT_USERAGENT()

   Used with `curl->set`. This option takes a string value that specifies the
   value for the :mailheader:`User-Agent` header in the HTTP request sent to the
   remote server.

.. method:: CURLOPT_HTTPHEADER()

   Used with `curl->set`. This option allows for adding new headers, replacing
   automatically generated internal headers, and removing automatically
   generated internal headers. The value passed should be an array of pairs with
   the first element in the pair being the string value of the header and the
   second value being the data to set it to. Header values specified here will
   override any automatically generated headers of the same name. Setting the
   value to an empty string will remove the header from the request.

.. method:: CURLOPT_HTTP200ALIASES()

   Used with `curl->set`. Some server responses use a custom response status
   line. For example, IceCast servers respond with "ICY 200 OK". This option
   allows you to specify that response is the same as "HTTP/1.0 200 OK". The
   value passed should be an array of strings, each string specifying another
   alias for the success status.

.. method:: CURLOPT_COOKIE()

   Used with `curl->set`. This option expects a string value that sets the
   cookie value for the HTTP header. The format of the string should be
   :samp:`{NAME}={CONTENTS}`, where *NAME* is the cookie name and *CONTENTS* is
   what the cookie should contain. To send multiple cookies, separate each
   cookie in the string with a semi-colon and a space like this:
   ``"name1=content1; name2=content2;"``. Using this option multiple times will
   only make the latest string override the previous ones.

.. method:: CURLOPT_COOKIEFILE()

   Used with `curl->set`. This option takes a string value that is the path and
   file name to a file holding cookie data to read and send with the request.
   The cookie data may be in Netscape / Mozilla cookie data format or just
   regular HTTP-style headers dumped to a file.

.. method:: CURLOPT_COOKIEJAR()

   Used with `curl->set`. This option takes a string value specifying the path
   and file name for curl to store cookies in. If the file can't be created, no
   error will be reported. (Using `CURLOPT_VERBOSE` will have a warning printed,
   but this is the only way to get this feedback.)

.. method:: CURLOPT_COOKIESESSION()

   Used with `curl->set`. If set to "1", curl will not use any session cookies
   that had been previously set by requests in the session. (Session cookies are
   cookies without expiry date and they are meant to be alive and existing for
   this "session" only.)

.. method:: CURLOPT_HTTPGET()

   Used with `curl->set`. If set to "1", it will force the curl request to use
   the HTTP GET method. Useful if an HTTP POST, PUT, or HEAD request had been
   set.

.. method:: CURLOPT_HTTP_VERSION()

   Used with `curl->set`. This option forces curl to use a specific HTTP
   version. (This is not recommended unless you have a good reason.) The value
   passed should be one of the following methods:

   .. method:: CURL_HTTP_VERSION_NONE()

      Let curl use whichever version it wants.

   .. method:: CURL_HTTP_VERSION_1_0()

      Force HTTP 1.0 requests.

   .. method:: CURL_HTTP_VERSION_1_1()

      Force HTTP 1.1 requests.


FTP Options
-----------

.. method:: CURLOPT_FTPPORT()

   Used with `curl->set`. This option expects a string value specifying the
   address to use for the FTP PORT instruction. The string may be an IP address,
   a host name, a network interface name (under Unix) or just adash character
   (``-``) to let the library use your system's default IP address. The address
   can then be followed by a colon and a port number or port range separated by
   a dash.

.. method:: CURLOPT_QUOTE()

   Used with `curl->set`. The value for this option should be an array of
   strings specifying FTP commands to run on the server prior to the FTP
   request. These will be done before any other commands are issued (even before
   the CWD command for FTP).

.. method:: CURLOPT_POSTQUOTE()

   Used with `curl->set`. The value for this option should be an array of
   strings specifying FTP commands to run on the server after the FTP transfer
   request has been completed. The commands will only be run if no error
   occurred in the request.

.. method:: CURLOPT_PREQUOTE()

   Used with `curl->set`. The value for this option should be an array of
   strings specifying FTP commands to run on the server after the transfer type
   is set.

.. method:: CURLOPT_FTPLISTONLY()

   Used with `curl->set`. If set to "1", curl will just list the file names in a
   folder instead of doing a full listing of names, sizes, dates, etc.

.. method:: CURLOPT_FTPAPPEND()

   Used with `curl->set`. If set to "1", curl will append to the remote file the
   data it's uploading instead of overwriting it.

.. method:: CURLOPT_FTP_USE_EPRT()

   Used with `curl->set`. If the value is set to "1", curl will use EPRT and
   LPRT command for active FTP downloads.

.. method:: CURLOPT_FTP_USE_EPSV()

   Used with `curl->set`. If set to "1", curl will use the EPSV command for
   passive FTP downloads. (This is actually the default; turn it off by setting
   it to "0".)

.. method:: CURLOPT_FTP_CREATE_MISSING_DIRS()

   Used with `curl->set`. If set to "1", curl will try to create directories
   that don't exist for it to CWD into.

.. method:: CURLOPT_FTP_RESPONSE_TIMEOUT()

   Used with `curl->set`. This option takes an integer value that specifies the
   number of seconds to wait for the server to respond to a command before
   considering the session hung.

.. method:: CURLOPT_FTPSSLAUTH()

   Used with `curl->set`. When doing FTP over SSL, this option specifies which
   authentication method to use. The value passed should be one of the following
   methods:

   .. method:: CURLFTPAUTH_DEFAULT()

      Let curl decide.

   .. method:: CURLFTPAUTH_SSL()

      Try "AUTH SSL" first, but if it fails try "AUTH TLS".

   .. method:: CURLFTPAUTH_TLS()

      Try "AUTH TLS" first, but if it fails try "AUTH SSL".

.. method:: CURLOPT_FTP_ACCOUNT()

   Used with `curl->set`. This option takes a string that specifies the data
   sent in an ACCT command when an FTP server asks for "account data" after a
   user name and password have been provided.


Protocol Options
----------------

.. method:: CURLOPT_TRANSFERTEXT()

   Used with `curl->set`. If set to "1", curl will use ASCII mode for FTP
   transfers instead of binary.

.. method:: CURLOPT_CRLF()

   Used with `curl->set`. If set to "1", curl will convert Unix newlines to
   CRLF.

.. method:: CURLOPT_RANGE()

   Used with `curl->set`. This option takes a string for its value specifying
   the range you want in the form of :samp:`{X}-{Y}` where either "X" or "Y" may
   be omitted. Ranges work for HTTP, FTP, and FILE. transfers only. HTTP
   transfers also support intervals separated by commas, such as "X-Y,N-M".

.. method:: CURLOPT_RESUME_FROM()

   Used with `curl->set`. This option takes an integer value that specifies the
   offset in number of bytes to start the transfer from.

.. method:: CURLOPT_RESUME_FROM_LARGE()

   Used with `curl->set`. This is the large file version of
   `CURLOPT_RESUME_FROM` and also takes an integer for its value.

.. method:: CURLOPT_CUSTOMREQUEST()

   Used with `curl->set`. This option takes a string value specifying a custom
   HTTP, FTP, or POP3 request. This is particularly useful, for example, for
   performing an HTTP DELETE request.

.. method:: CURLOPT_FILETIME()

   Used with `curl->set`. If set to "1", curl will try and get the modification
   date for the document in the transfer.

.. method:: CURLOPT_NOBODY()

   Used with `curl->set`. If set to "1", curl will only output the header
   portion of the received response. (Only relevant for protocols such as HTTP
   that have separate header and body parts.)

.. method:: CURLOPT_INFILESIZE()

   Used with `curl->set`. This option takes an integer specifying the expected
   size of the infile for an upload. It does not limit how much data curl
   actually sends.

.. method:: CURLOPT_INFILESIZE_LARGE()

   Used with `curl->set`. This is the large file version of
   `CURLOPT_INFILESIZE`.

.. method:: CURLOPT_UPLOAD()

   Used with `curl->set`. Set this option to "1" to tell curl to prepare for an
   upload.

.. method:: CURLOPT_MAXFILESIZE()

   Used with `curl->set`. This option takes an integer value specifying the
   maximum size of the file to download in bytes. If the requested file is
   larger then this size, nothing will be transferred and an error of
   ``CURLE_FILESIZE_EXCEEDED`` will be produced.

.. method:: CURLOPT_MAXFILESIZE_LARGE()

   Used with `curl->set`. This is the large file version of
   `CURLOPT_MAXFILESIZE`.

.. The values for CURLOPT_TIMECONDITION aren't available
..   .. method:: CURLOPT_TIMECONDITION()
..   .. method:: CURLOPT_TIMEVALUE()


Connection Options
------------------

.. method:: CURLOPT_TIMEOUT()

   Used with `curl->set`. This option takes an integer value specifying the
   maximum time in seconds to wait for the curl transfer.

.. method:: CURLOPT_LOW_SPEED_LIMIT()

   Used with `curl->set`. This option takes an integer value that specifies the
   number of bytes per second the transfer should be below for the duration of
   `CURLOPT_LOW_SPEED_TIME` for curl to consider too slow and abort.

.. method:: CURLOPT_LOW_SPEED_TIME()

   Used with `curl->set`. This option takes an integer value that specifies the
   number of seconds a curl transfer must be below the rate set by
   `CURLOPT_LOW_SPEED_LIMIT` for curl to abort due to bad connection.

.. method:: CURLOPT_MAXCONNECTS()

   Used with `curl->set`. This option takes an integer value specifying the
   maximum number of persistent cached connections this curl operation can have
   simultaneously opened. The default is 5.

.. method:: CURLOPT_FRESH_CONNECT()

   Used with `curl->set`. Set this to "1" to force the next operation to use a
   new connection. (This option should be used with caution and only if you
   understand what it does.)

.. method:: CURLOPT_FORBID_REUSE()

   Used with `curl->set`. If set to "1", curl will close the connection for the
   next operation after it finishes. (This option should be used with caution
   and only if you understand what it does.)

.. method:: CURLOPT_CONNECTTIMEOUT()

   Used with `curl->set`. This option takes an integer value that specifies the
   number of seconds to wait before timing out during the connection phase.
   (Once connected, this option is of no value.) The default is 300 seconds.

.. method:: CURLOPT_IPRESOLVE()

   Used with `curl->set`. This option specifies which type of IP address to use
   if a host name resolves to more than one kind of IP address. The value passed
   should be one of the following methods:

   .. method:: CURL_IPRESOLVE_WHATEVER()

      This is the default, and it will resolve to all that your system allows.

   .. method:: CURL_IPRESOLVE_V4()

      Specifies using IPv4 addresses.

   .. method:: CURL_IPRESOLVE_V6()

      Specifies using IPv6 addresses.


.. method:: CURLOPT_FTP_SSL()
.. method:: CURLOPT_USE_SSL()

   Used with `curl->set`. This option specifies your SSL connection preferences
   to curl. The value passed should be one of the following methods:

   .. method:: CURLFTPSSL_NONE()

      Don't attempt to use SSL.

   .. method:: CURLFTPSSL_TRY()

      Try using SSL, but proceed as normal otherwise.

   .. method:: CURLFTPSSL_CONTROL()

      Require SSL for the control part of the connection or fail with
      ``CURLE_USE_SSL_FAILED``.

   .. method:: CURLFTPSSL_ALL()

      Require SSL for all communication or fail with ``CURLE_USE_SSL_FAILED``.


SSL & Security Options
----------------------

.. method:: CURLOPT_SSLCERT()

   Used with `curl->set`. This option expects a string value that specifies the
   path and file name to your certificate, or, with NSS, the nickname of the
   certificate you want to use. (If you want to use a file from the current
   directory, precede it with a "./" prefix in order to avoid confusion
   with a nickname.)

.. method:: CURLOPT_SSLCERTTYPE()

   Used with `curl->set`. This option expects a string value of either "PEM" or
   "DER". It is used to tell curl the format of your certificate. The default is
   "PEM".

.. method:: CURLOPT_SSLKEY()

   Used with `curl->set`. This option expects a string value that specifies the
   path and file name to your private key.

.. method:: CURLOPT_SSLKEYTYPE()

   Used with `curl->set`. This option expects a string value of either "PEM",
   "DER", or "ENG". It is used to tell curl the format of your private key. The
   default is "PEM".

.. method:: CURLOPT_SSLKEYPASSWD()

   Used with `curl->set`. If your private key needs a password to be used, then
   pass a string value of the password with this option.

.. method:: CURLOPT_SSLENGINE()

   Used with `curl->set`. This option expects a string value specifying which
   crypto engine to use. If the crypto device cannot be loaded, a
   ``CURLE_SSL_ENGINE_NOTFOUND`` error is returned.

.. method:: CURLOPT_SSLENGINE_DEFAULT()

   Used with `curl->set`. If set to any value (recommended you set it to "1"),
   this option will set the crypto engine to curl's default asymmetric crypto
   engine. If the crypto engine cannot be set, a ``CURLE_SSL_ENGINE_SETFAILED``
   error is returned.

.. method:: CURLOPT_SSLVERSION()

   Used with `curl->set`. This option is used to control which version(s) of
   SSL/TLS can be used. The value passed should be one of the following methods
   to force using the version specified by the method name:
   ``CURL_SSLVERSION_TLSv1``, ``CURL_SSLVERSION_SSLv2``,  or
   ``CURL_SSLVERSION_SSLv3``. ``CURL_SSLVERSION_DEFAULT`` can be passed to tell
   curl to figure out the remote server's protocol, though it won't use
   ``CURL_SSLVERSION_SSLv2``.

.. method:: CURLOPT_SSL_VERIFYPEER()

   Used with `curl->set`. This option expects an integer value of either "1" or
   "0", and it defaults to "1". It is used to specify whether or not curl
   verifies the authenticity of the peer's certificate with a value of "1"
   meaning it does the verification and "0" meaning it does not.

.. method:: CURLOPT_CAINFO()

   Used with `curl->set`. This option expects a string value that specifies the
   path and file name to a file containing one or more certificates needed to do
   peer verification. By default, this option is set to the path curl believes
   your system keeps its CA cert bundle.

.. method:: CURLOPT_CAPATH()

   Used with `curl->set`. This option expects a string value that specifies the
   path to a directory containing multiple CA certificates to be used for peer
   verification.

.. method:: CURLOPT_SSL_VERIFYHOST()

   Used with `curl->set`. This option expects an integer value of either "0",
   "1", or "2". When the value is "0", the connection to the remote server will
   succeed regardless of the SSL credentials. When the value is "1", curl will
   return a failure if the authenticity of the server's SSL credentials cannot
   be verified, and when the value is "2", the connection will fail without
   verification. The default for this option is "2".

.. method:: CURLOPT_RANDOM_FILE()

   Used with `curl->set`. This option expects a string value that specifies the
   path and file name to a file whose contents will be used in seeding the
   random engine for SSL.

.. method:: CURLOPT_EGDSOCKET()

   Used with `curl->set`. This option expects a string value that specifies the
   path and file name to the Entropy Gathering Daemon socket which will be used
   when seeding the random engine for SSL.

.. method:: CURLOPT_SSL_CIPHER_LIST()

   Used with `curl->set`. This option expects a string value specifying the list
   of ciphers that can be used in the SSL connection. See the `curl
   documentation for CURLOPT_SSL_CIPHER_LIST`_ for a discussion of the proper
   syntax needed.

.. method:: CURLOPT_KRB4LEVEL()

   Used with `curl->set`. This option expects a string value of either "clear",
   "safe", "confidential", or "private". It is used to set the kerberos security
   level for FTP and enable kerberos awareness. Set the option to "null" to
   disable kerberos.


Using the curl Type
===================

The :type:`curl` type is meant to be a low-level implementation, which means
that it is usually not necessary to use it directly. For the most part, the
`include_url` method is all that is needed for HTTP requests and the ``ftp_…``
methods handle your FTP needs. In fact, the examples below could have easily
been done using one of those methods, but are provided to give you an
understanding of how to use the :type:`curl` type in case you find yourself
needing more control.


Making an HTTP Request
----------------------

The following example uses the :type:`curl` type to make a HEAD request to an
HTTP server::

   local(req) = curl("http://www.example.com")
   handle => { #req->close }

   // Not verifying the return status of setting the option
   local(_) = #req->set(CURLOPT_NOBODY, 1)

   #req->raw
   #req->close

   // =>
   // staticarray(true, HTTP/1.1 200 OK
   // Accept-Ranges: bytes
   // Cache-Control: max-age=604800
   // Content-Type: text/html
   // Date: Wed, 28 Aug 2013 13:42:53 GMT
   // Etag: "3012602696"
   // Expires: Wed, 04 Sep 2013 13:42:53 GMT
   // Last-Modified: Fri, 09 Aug 2013 23:54:35 GMT
   // Server: ECS (atl/5834)
   // X-Cache: HIT
   // x-ec-custom-error: 1
   // Content-Length: 1270
   //
   // , )


Listing an FTP Directory
------------------------

The following example lists the file and folder names at the specified FTP
location::

   local(req) = curl(
      "ftp://ftp.example.com/",
      -username=`MyUsername`,
      -password=`Shh...Secret`
   )
   handle => { #req->close }

   #req->set(CURLOPT_FTPLISTONLY, 1)

   #req->result

   // =>
   // .
   // ..
   // file1
   // file2
   // folder1


The include_url Method
======================

The `include_url` method is a nice wrapper around the curl type for requesting
data via HTTP. We strongly recommend using this method for your HTTP request
needs if possible.

.. method:: include_url(\
      url::string, \
      -getParams= ?, \
      -postParams= ?, \
      -sendMimeHeaders= ?, \
      -username= ?, \
      -password= ?, \
      -noData= ?, \
      -verifyPeer= ?, \
      -sslCert= ?, \
      -sslCertType= ?, \
      -sslKey= ?, \
      -sslKeyType= ?, \
      -sslKeyPasswd= ?, \
      -timeout= ?, \
      -connectTimeout= ?, \
      -retrieveMimeHeaders= ?, \
      -options= ?, \
      -string= ?, \
      -basicAuthOnly= ?\
   )

   This method requires a string representing a URL in the form of
   "http://www.example.com" ("https://" can also be used). By default, this
   method returns the HTML body result of performing an HTTP GET request at the
   specified URL.

   This method has several optional parameters that modify its behavior:

   :param -getParams:
      Pass this parameter a staticarray or array of key/value pairs. This data
      is then converted into a query string and appended to the URL when making
      the HTTP request.

   :param -postParams:
      This option can take either a string, bytes, or :trait:`trait_forEach`
      object. For string and bytes objects, the data is set as the POST field
      (`CURLOPT_POSTFIELDS`) for the request without modification. If passed a
      :trait:`trait_forEach` object, each value should be a key/value pair
      object that will then first be converted into the query string format
      before being set as the POST field.

   :param -sendMimeHeaders:
      This option can take either a string, bytes, or :trait:`trait_forEach`
      object. For string and bytes objects, the data is set as additional HTTP
      headers for the request without modification. If passed a
      :trait:`trait_forEach` object, each value should be a key/value pair
      object whose first value is the header name and the second value is the
      value. These will then first be converted into the form "Header: Value"
      and joined with "\\r\\n" before being set as additional HTTP headers.

   :param -username:
      This option allows you to specify the username for connections that
      require authentication.

   :param -password:
      This option allows you to specify the password for connections that
      require authentication.
   
   :param -noData:
      Passing this option does not change any aspect of the curl HTTP request,
      but tells `include_url` not to return any data.
   
   :param -verifyPeer:
      Use this option to specify whether or not Lasso should verify the SSL
      certificate of the HTTP peer being connected to. The default is "true".
   
   :param -sslCert:
      This parameter is used to set the `CURLOPT_SSLCERT` option.
   
   :param -sslCertType:
      This parameter is used to set the `CURLOPT_SSLCERTTYPE` option.
   
   :param -sslKey:
      This parameter is used to set the `CURLOPT_SSLKEY` option.
   
   :param -sslKeyType:
      This parameter is used to set the `CURLOPT_SSLKEYTYPE` option.
   
   :param -sslKeyPasswd:
      This parameter is used to set the `CURLOPT_SSLKEYPASSWD` option.
   
   :param -timeout:
      This parameter is used to set the `CURLOPT_TIMEOUT` option.
   
   :param -connectTimeout:
      This parameter is used to set the `CURLOPT_CONNECTTIMEOUT` option.
   
   :param -retrieveMimeHeaders:
      This parameter expect a string specifying the name of a thread variable to
      store the HTTP response header data in.
   
   :param -options:
      Pass this parameter a staticarray or array of pairs, the first value of
      the pair should be one of the ``CURLOPT_…`` methods and the second value
      should be the appropriate setting for that curl option.
   
   :param -string:
      The default is for `include_url` to return a bytes object, but if this
      parameter is set, then it will return a string object. You can pass a
      string to this parameter to specify the character set to use. Setting the
      parameter to "true" causes `include_url` to first check the curl headers
      for the character set to use, otherwise Lasso will try and determine the
      character set itself from the body of the response. If that fails, the
      default is to use UTF-8 encoding.
   
   :param -basicAuthOnly:
      Setting this option to "true" causes `include_url` to only use HTTP Basic
      authentication.


Basic HTTP Request
------------------

The following example issues a basic HTTP GET request for the specified URL::

   include_url('http://www.example.com/')

   // =>
   // <!doctype html>
   // <html>
   // <head>
   //     <title>Example Domain</title>
   // (... You get the idea ...)


Sending Data with an HTTP PUT Request
-------------------------------------

The following example issues an HTTP PUT request, passing data in the body of
the request. The example result is a JSON-formatted string, but would be the
body of the HTTP response given by your server. ::

   include_url(
      'http://www.example.com/',
      -postParams = (: 'id'= 5, 'animal'='rhino'),
      -options    = (: CURLOPT_CUSTOMREQUEST = 'PUT')
   )

   // => {"status": "Success"}


Specifying HTTP Headers
-----------------------

The following example adds a :mailheader:`User-Agent` header to the HTTP
request::

   include_url(
      'http://www.example.com/',
      -sendMimeHeaders = (: 'User-Agent' = 'LassoBrowse/1.0')
   )

   // =>
   // <!doctype html>
   // <html>
   // <head>
   //     <title>Example Domain</title>
   // (... rest of response ...)


Reading Response Headers
------------------------

The following example gets the response headers for the request stored in a
variable named "my_headers" and then displays them::

   local(my_body) = include_url(
      'http://www.example.com/',
      -retrieveMimeHeaders = 'my_headers'
   )
   $my_headers

   // =>
   // HTTP/1.1 200 OK
   // Accept-Ranges: bytes
   // Cache-Control: max-age=604800
   // Content-Type: text/html
   // Date: Wed, 28 Aug 2013 20:00:21 GMT
   // Etag: "3012602696"
   // Expires: Wed, 04 Sep 2013 20:00:21 GMT
   // Last-Modified: Fri, 09 Aug 2013 23:54:35 GMT
   // Server: ECS (atl/FCAA)
   // X-Cache: HIT
   // x-ec-custom-error: 1
   // Content-Length: 1270


FTP Methods
===========

The ``ftp_…`` methods are nice wrappers around the curl type for requesting and
sending data via FTP. We strongly recommend using these methods for your FTP
needs if possible.


Retrieve the Contents of a Remote File
--------------------------------------

.. method:: ftp_getData(\
      url::string, \
      -username::string= ?, \
      -password::string= ?, \
      -options::array= ?\
   )

   This method returns a bytes object representing the remote file's contents at
   the specified FTP URL. It can also optionally take a username and password to
   be used for authentication to the FTP server. Also, the "-options" parameter
   can be passed an array of pairs, the first value of the pair should be one of
   the ``CURLOPT_…`` methods and the second value should be the appropriate
   setting for that curl option.

   The following example downloads the data in a file named "test.txt" from the
   remote server, and then displays it::

      ftp_getData(
         'ftp://example.com/test.txt',
         -username=`MyUsername`,
         -password=`Shh...Secret`
      )

      // => "Hello, world."


Download a Remote File
----------------------

.. method:: ftp_getFile(\
      url::string, \
      -file::string, \
      -username::string= ?, \
      -password::string= ?, \
      -options::array= ?\
   )

   This method downloads the remote file specified by the FTP URL in the first
   parameter to the location specified by the "-file" parameter. It can also
   optionally take a username and password to be used for authentication to the
   FTP server. Also, the "-options" parameter can be passed an array of
   pairs, the first value of the pair should be one of the ``CURLOPT_…``
   methods and the second value should be the appropriate setting for that curl
   option.

   The following example downloads the remote file "test.txt" to "/tmp/file.txt"
   from the root of the file system::

      ftp_getFile(
         'ftp://example.com/test.txt',
         -file='//tmp/file.txt',
         -username = `MyUsername`,
         -password = `Shh...Secret`
      )


List the Contents of a Remote Directory
---------------------------------------

.. method:: ftp_getListing(\
      url::string, \
      -username= ?, \
      -password= ?, \
      -listonly::boolean= ?, \
      -options::array= ?\
   )

   This method gets a directory listing of the remote directory specified by the
   FTP URL. If you only want the names of the files and folders in the specified
   remote directory, pass the "-listOnly" parameter. You can also optionally
   specify a username and password to be used for authentication to the FTP
   server. The method can also take the "-options" parameter which expects an
   array of pairs, the first value of the pair should be one of the
   ``CURLOPT_…`` methods and the second value should be the appropriate setting
   for that curl option.

   The following example gets a list of all the files and folders at the FTP
   root of the "example.com" server and displays its size and then its name
   (with a trailing slash if it is a directory)::

      local(listing) = ftp_getListing(
         'ftp://example.com/test.txt',
         -username = `MyUsername`,
         -password = `Shh...Secret`
      )
      with item in #listing
         let item_type = #item->find('filetype')
         let item_size = #item->find('filesize')
         let item_name = #item->find('filename') + (#item_type == 'directory' ? '/' | '')
      do {^ #item_size + "B  " + #item_name ^}

      // =>
      // 170B  ./
      // 170B  ../
      // 387B  directory/
      // 15B  test.txt


Update an Existing Remote File
------------------------------

.. method:: ftp_putData(\
      url::string, \
      -data::bytes, \
      -username= ?, \
      -password= ?, \
      -options::array= ?\
   )

   This method takes an FTP URL and a bytes object representing file data. If a
   file doesn't exist at the location specified by the URL, one will be created
   with the data specified by the "-data" parameter. If a file does exist at the
   path specified by the URL then its contents will be overwritten with the new
   data. (See the example below for how to change the behavior to append the
   data instead.)

   This method can optionally take a username and password to be used for
   authentication to the FTP server. Also, the "-options" parameter can be
   passed an array of pairs, the first value of the pair should be one of the
   ``CURLOPT_…`` methods and the second value should be the appropriate setting
   for that curl option.

   The following example will take the data "\\nAs You Wish" and append it to
   the remote "test.txt" file. (The `CURLOPT_FTPAPPEND` method changes the
   behavior to append the data.) ::

      ftp_putData(
         'ftp://example.com/test.txt',
         -data     = bytes("\nAs You Wish"),
         -username = `MyUsername`,
         -password = `Shh...Secret`,
         -options  = array(CURLOPT_FTPAPPEND=1)
      )


Upload a Local File to the Remote Server
----------------------------------------

.. method:: ftp_putFile(\
      url::string, \
      -file, \
      -username= ?, \
      -password= ?, \
      -options::array= ?\
   )

   This method uploads the local file specified by the "-file" parameter to the
   remote location specified by the FTP URL passed as the first parameter. If a
   file doesn't exist at the location specified by the URL, one will be created,
   otherwise the contents of the existing remote file will be overwritten with
   the new data from the local file.

   This method can optionally take a username and password to be used for
   authentication to the FTP server. Also, the "-options" parameter can be
   passed an array of pairs, the first value of the pair should be one of the
   ``CURLOPT_…`` methods and the second value should be the appropriate setting
   for that curl option.

   The following example takes the local file "test.txt" at the current webroot
   and uploads it as "file.txt" to the specified path in the URL. The
   `CURLOPT_FTP_CREATE_MISSING_DIRS` option specifies that any missing
   intermediary directories on the remote server will be created. ::

      ftp_putFile(
         'ftp://example.com/new_dir/test.txt',
         -file     = "/test.txt",
         -username = `MyUsername`,
         -password = `Shh...Secret`,
         -options  = array(CURLOPT_FTP_CREATE_MISSING_DIRS=1)
      )


Delete a Remote File
--------------------

.. method:: ftp_deleteFile(\
      url::string, \
      -username= ?, \
      -password= ?, \
      -options::array= ?\
   )

   This method will delete the remote file specified by the FTP URL in the first
   parameter. It can optionally take a username and password to be used for
   authentication to the FTP server. Also, the "-options" parameter can be
   passed an array of pairs, the first value of the pair should be one of the
   ``CURLOPT_…`` methods and the second value should be the appropriate setting
   for that curl option.

   The following example will delete the "test.txt" file at the FTP root of the
   remote server::

      ftp_deleteFile(
         'ftp://example.com/test.txt',
         -username = `MyUsername`,
         -password = `Shh...Secret`
      )

.. _curl library: http://curl.haxx.se/
.. _curl documentation: http://curl.haxx.se/libcurl/c/curl_easy_setopt.html
.. _curl documentation for CURLOPT_SSL_CIPHER_LIST: http://curl.haxx.se/libcurl/c/curl_easy_setopt.html#CURLOPTSSLCIPHERLIST
