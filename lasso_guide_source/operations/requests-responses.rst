.. only:: html

   .. _requests-responses:

   **************************
   Web Requests and Responses
   **************************

Lasso Server receives requests from whichever HTTP server it is connected to.
Each request consists of the headers and body data as sent by the requesting
user agent, as well as data from the HTTP server such as the local web server
root directory and other metadata. The request data is parsed and made available
for the code that is run to handle the request. Handling a request entails
creating the resulting headers and body data for the reply. This data is sent to
the web server, which is then sent to the connected user agent. The request is
complete after the data is sent.

The code that is chosen to handle a request is based on the path in the
:envvar:`PATH_INFO` or, if that is not present, the :envvar:`SCRIPT_NAME`
variable, as sent from the web server. That value is appended to the value of
the :envvar:`DOCUMENT_ROOT` or the :envvar:`LASSOSERVER_DOCUMENT_ROOT` variable
and the resulting file path is used as the response. That response may be a
script file located on the local file system or it may address a component of a
LassoApp. Either way, the file is compiled if necessary and executed.

If the indicated file is not present or an unhandled failure occurs while
processing the request, then Lasso will look for a file named
:file:`error.lasso` at the original file's directory path. If an
:file:`error.lasso` file is not found, then Lasso will look up one directory
level for the error file, and so on, until the web file root directory is
reached or the error file is found. If no error file is found to handle the
situation, then a standard error message and stack trace is printed.

Finally, Lasso provides a means for running code before or after a request. This
enables interception of the standard request processing flow at either point.
This can be useful when using virtual URLs and serving dynamic database-driven
content or when rewriting outgoing response data.


Web Requests
============

Lasso Server makes web request data available through a `web_request` object. An
instance of this object is created for each request before processing begins.
The request handling code can obtain its request object instance by calling the
`web_request` method.

The `web_request` object has the following purposes:

-  Making available all variables sent by the web server
-  Including all client header information
-  Making available all data sent by the web client
-  Including tokenized GET arguments
-  Including processed POST body data

A `web_request` object will process the incoming data to make access to the
various components of a web request more convenient. For example, all HTTP
cookies are found and separated to be made available through the `cookies` or
`cookie(name)` methods. Standard HTTP headers are made available through
accessors such as `requestURI` or `httpHost`.

The incoming GET arguments are tokenized and can be retrieved by name or
iterated over in their entirety. The request's POST body is processed depending
on the incoming :mailheader:`Content-Type`. Both :mimetype:`multipart/form-data`
and :mimetype:`application/x-www-form-urlencoded` content types are
automatically handled. This includes the processing of file uploads, the results
of which are made available through the `fileUploads` method.


Request Headers
---------------

The incoming HTTP request headers are pre-processed by the web server and then
further processed by Lasso. All header names are normalized to upper case by
the web server and prepended with ``HTTP_`` and all dashes (``-``) replaced with
underscores (``_``).

Once received by Lasso, any leading ``HTTP_`` which was prepended by the web
server to each variable is stripped. All underscores (``_``) are then converted
to dashes (``-``).

The `web_request` object makes header data available through the following
methods. All header names and values are treated as strings.

.. type:: web_request

.. member:: web_request->headers()::trait_forEach
.. member:: web_request->header(name::string)
.. member:: web_request->rawHeader(name::string)

   The `headers` method returns all of the headers as an object which can be
   iterated or used in a query expression. Each header element is presented as a
   pair object containing the header name and value as the pair's first and
   second elements, respectively. The next method returns the first header pair,
   which matches the name parameter. It returns "void" if the header is not
   found. The `rawHeader` method works the same, but fetches the raw
   unnormalized header name/value as sent by the web server.

The next set of methods is presented in a table matching the method name to its
corresponding raw web request variable name. For headers that return a string
value, an empty string is returned if the header has no value or is not present.
A zero or "false" is returned for other non-existent value types.

==================== ==================== ===========
Method Name          Web Request Variable Return Type
==================== ==================== ===========
`contentLength`      CONTENT_LENGTH       integer
`contentType`        CONTENT_TYPE         string
`gatewayInterface`   GATEWAY_INTERFACE    string
`httpAccept`         HTTP_ACCEPT          string
`httpAcceptEncoding` HTTP_ACCEPT_ENCODING string
`httpAcceptLanguage` HTTP_ACCEPT_LANGUAGE string
`httpCacheControl`   HTTP_CACHE_CONTROL   string
`httpConnection`     HTTP_CONNECTION      string
`httpCookie`         HTTP_COOKIE          string
`httpHost`           HTTP_HOST            string
`httpReferer`        HTTP_REFERER         string
`httpReferrer`       HTTP_REFERER         string
`httpUserAgent`      HTTP_USER_AGENT      string
`isHttps`            HTTPS                boolean
`path`               PATH                 string
`pathInfo`           SCRIPT_NAME          string
`pathTranslated`     PATH_TRANSLATED      string
`remoteAddr`         REMOTE_ADDR          string
`remotePort`         REMOTE_PORT          integer
`requestMethod`      REQUEST_METHOD       string
`requestURI`         REQUEST_URI          string
`scriptFilename`     SCRIPT_FILENAME      string
`scriptName`         SCRIPT_NAME          string
`scriptURI`          SCRIPT_URI           string
`scriptURL`          SCRIPT_URL           string
`serverAddr`         SERVER_ADDR          string
`serverAdmin`        SERVER_ADMIN         string
`serverName`         SERVER_NAME          string
`serverPort`         SERVER_PORT          integer
`serverProtocol`     SERVER_PROTOCOL      string
`serverSignature`    SERVER_SIGNATURE     string
`serverSoftware`     SERVER_SOFTWARE      string
==================== ==================== ===========


GET and POST Arguments
----------------------

Lasso automatically tokenizes GET arguments and processes the POST body into a
series of name/value pairs according to the sent content type. These two sets of
pairs can be retrieved separately or treated as a single series of elements.
File uploads are not included in the POST arguments, but are made available
through the `fileUploads` method.

The value for any GET or POST argument is always a bytes object. The name is
always a string.

.. member:: web_request->queryParam(name::string)
.. member:: web_request->postParam(name::string)
.. member:: web_request->param(name::string)
.. member:: web_request->param(name::string, joiner)
.. member:: web_request->queryParams()
.. member:: web_request->postParams()
.. member:: web_request->params()

   This set of methods refers to the GET arguments as the "``query``" params and
   any POST arguments as the "``post``" params. Both sets together are just the
   "``params``". For the methods which accept a name parameter, they return the
   first matching argument's string value. If no argument matches, then a "void"
   value is returned.

   The `param` method treats both argument sources as a single source with
   the POST arguments occurring first. The `param(name::string, joiner)`
   method presents an interface for accessing arguments which occur more than
   once. The ``joiner`` parameter is used to determine the result of the method.
   If ``void`` is passed, then the resulting argument values are returned in a
   staticarray. If a string value is passed, then the argument values are joined
   with that string in between each value. The result of passing any other
   object type will depend on the behavior of its ``+`` operator.

   The methods which accept zero parameters return all of the GET, POST, or both
   argument pairs as an object which may be iterated or used in a query
   expression.

.. member:: web_request->postString()
.. member:: web_request->queryString()

   These methods return the respective arguments in a format similar to how they
   were received. In the case of `queryString` the GET arguments are returned
   verbatim. The POST string is created by concatenating each POST argument
   together with ``&`` in between each name/value, each of which are separated
   by ``=``. This will vary from the exact given POST only in the case of
   :mimetype:`multipart/form-data` input.


Read Cookies
------------

Cookie values are sent as HTTP header fields. As such, they can be read and
parsed from the various header-related `web_request` methods. The `web_request`
object provides methods to directly access the pre-parsed cookie data.

.. member:: web_request->cookie(named::string)
.. member:: web_request->cookies()::trait_forEach

   The first method searches for the named cookie and returns its value if
   found. If the cookie is not found then "void" is returned. The second method
   returns all the cookies as an object, which can be iterated or used in a
   query expression. The cookie elements are presented as pair objects
   containing the cookie names and values as the pairs' first and second
   members.


Web Responses
=============

Sending a response to a web request is a simple as having "The Words" in the
targeted ".lasso" text file. Files requested through a web request are assumed
to begin as plain text. Lasso code can be inserted into the file using the
following text delimiters::

   <?lasso … ?>
   <?= … ?>
   [ … ]

Because supporting the ``[ … ]`` delimiters can be problematic for some data
types (i.e. JavaScript), they can be disabled for the remainder of the file by
having the literal ``[no_square_brackets]`` as the first tag.

Any code within the delimiters will have the results of the expressions within
its body converted to string objects and included in the response output string.
Code within auto-collecting captures is included as well. For example, the code
or text within ``inline(...) … /inline`` or ``inline(...) => {^ … ^}`` would be
included in the output. Such code is free to call any methods or types to
formulate the response data.

The request is completed when the initial code has run to the end, when the
`abort` method is called, or when an unhandled failure occurs. Outgoing data is
buffered for as long as possible, but can be forced out at any point using the
`sendChunk` method. Calling `abort` (either the `web_response` version or the
unbound method; both have the same behavior) will complete the request by
halting all processing and sending the existing response data as-is.

The `web_response` object automatically routes requests for LassoApps. Request
paths that begin with ``/lasso9/`` are reserved for LassoApp usage and will be
routed there. Physical file paths beginning with :file:`/lasso9/` are ignored by
Lasso Server during processing of a web request.


Include
-------

It is often useful to split up large template files into smaller reusable
components. For example, a header or footer might be split out and reused on all
pages. The `web_response` object provides a variety of methods for including
other source code files. Files included in this way behave just as a file
accessed directly would. That is, they begin executing as plain text and any
Lasso code must be included within delimiters.

The path to an include file can be full or relative. Complete paths from the
file system root are accepted as well. Consult the chapter on :ref:`files` for
more details on how file paths are treated in Lasso. Components of LassoApps can
be included as well by beginning the path with ``/lasso9/``, then the app name
and then the path to the component.

Any of the following methods can be used to include file content.

.. type:: web_response

.. member:: web_response->include(path::string)
.. member:: web_response->includeOnce(path::string)
.. member:: web_response->includeLibrary(path::string)
.. member:: web_response->includeLibraryOnce(path::string)

   These methods locate and run the file indicated by the path. The
   `includeLibrary` and `includeLibraryOnce` methods run the file but do not
   insert the result into the response. The `includeOnce` and
   `includeLibraryOnce` methods will only include the file if it has not already
   been included during the course of that request.

   These methods will fail if the indicated file does not exist.

.. member:: web_response->includeBytes(path::string)::bytes

   Locates the file and includes the raw file data as bytes. The method will
   fail if the file does not exist.

.. member:: web_response->includes()::trait_forEach

   Lasso keeps track of web files which are being executed. As execution of a
   file begins, the file's name is pushed onto an internally-kept stack. As a
   file's execution ends, that name is popped from the stack. This method
   provides access to that stack. This method returns the list of
   currently-executing file names as an object which can be iterated or used in
   a query expression.

.. member:: web_response->getInclude(path::string)

   Locates the file and will return an object which can be invoked to execute
   the file. The method will fail if the file does not exist.

For compatibility and simplicity, Lasso supports the following unbound methods
which function in the same manner as the `web_response` bound methods:

.. method:: include(path::string)
.. method:: library(path::string)

   These methods include the file indicated by the path in the same manner as
   the `web_response->include` and `web_response->includeLibrary` methods.


Response Headers
----------------

The `web_response` object provides methods for setting the outgoing response's
HTTP headers. When a request is begun, a few default HTTP headers are
established. The request handler code can add, modify or remove these headers as
needed. Headers can be set or removed freely during a request; however, once any
data has been sent then headers can no longer be effectively manipulated.

Note that the HTTP status code and message are not HTTP headers and so are not
manipulated through these methods.

.. member:: web_response->header(name::path)
.. member:: web_response->headers()::trait_ForEach

   These methods return existing outgoing headers. The first method finds the
   first occurrence of the indicated header and returns its value. The second
   method returns all the current headers as an object which can be iterated or
   used in a query expression. Each element is a pair object containing the
   header name/value and the pair's first/second.

.. member:: web_response->setHeaders(headers::trait_forEach)
.. member:: web_response->replaceHeader(header::pair)
.. member:: web_response->addHeader(header::pair)

   These methods permit headers to be set or replaced. The first method sets all
   the headers for the response. These headers should be given as a series of
   pairs containing the header names/values. The second method accepts a header
   name/value pair and replaces matching header with the new value. If the
   existing header isn't found, the new header is simply added. The third method
   accepts a new header name/value pair and adds it to the list of outgoing
   headers. This method ignores any duplicate matching headers.


Set Cookies
-----------

Outgoing cookies are added to the response HTTP headers by the `web_response`
object. It provides a method for setting a cookie and a method for enumerating
all cookies which are being set.

Setting a cookie requires specifying a name and a value and optionally a domain,
expiration, path, and SSL secure flag. These values are supplied as parameters
when setting a cookie. Cookie headers are not created until the request
processing is completed and the response is to be sent to the client.

.. member:: web_response->setCookie(nv::pair, -domain=void, -expires=void, -path=void, -secure=false)

   Sets the indicated cookie. Any duplicate cookie would be replaced. The first
   parameter must be the cookie name=value pair. If used, the ``-domain`` and
   ``-path`` keyword parameters must have string values.

   The ``-expires`` parameter can be either a date object, a duration object, an
   integer, a string or any object which will produce a suitable value when
   converted into a string. A date indicates the absolute date at which the
   cookie will expire. A duration indicates the time that the cookie should
   expire based on the time at which the cookie is being set. An integer
   indicates the number of minutes until the cookie expires. Any other object
   type is appended directly to the outgoing cookie header string.

.. member:: web_response->cookies()::trait_forEach

   Returns a list of all the cookies set for this response. The individual
   cookies are represented by map objects containing keys for 'name', 'value',
   'domain', 'expiration', 'path' and 'secure'. Manipulating a cookie value in
   the list will alter its resulting cookie header.


Bytes Response Data
-------------------

By default, the result of a request will have a :mimetype:`text/html` content
type with a UTF-8 character set and the body data will be generated from a Lasso
string object which always consists of Unicode character data. In order to
output binary data, the bytes need to be set directly and the response's
:mailheader:`Content-Type` header adjusted accordingly. The `web_response`
method `rawContent` can be used to get or set the outgoing content data.

It is advised to call `abort` soon after setting binary response data or at
least to ensure that no stray character data is inadvertently added into the
outgoing data buffer as it will corrupt the output.

When manually setting the raw content, the :mailheader:`Content-Type` header
should usually be adjusted to accommodate the change. Use the
`web_response->replaceHeader` method to replace the existing header with the
new value.

The `web_response` object provides the `sendFile` method which packages together
many of the steps required to send binary data to the client to be viewed either
inline or downloaded as an attachment.

.. member:: web_response->sendFile(data::trait_each_sub, name = null, \
                     -type = null, -disposition = 'attachment', \
                     -charset = '', -skipProbe = false, \
                     -noAbort = false, -chunkSize = fcgi_bodyChunkSize, \
                     -monitor = null)

   Sets the raw content and headers for the response. It then optionally aborts,
   ending the request and delivering the data to the client. This method
   replaces all existing headers with new
   :mailheader:`MIME-Version`, :mailheader:`Content-Type`,
   :mailheader:`Content-Disposition` and :mailheader:`Content-Length` headers.

   The first parameter can be any object which supports :trait:`trait_each_sub`.
   This includes objects such as string, bytes and file. The second parameter is
   optional, but if given it will trigger a ``"filename="`` element to be added
   to the :mailheader:`Content-Disposition` header. This controls the file name
   that the user agent will use to save a downloaded file.

   The subsequent keyword parameters control the following:

   ``-type``
      This string indicates the value for the :mailheader:`Content-Type` header.
      If this is not specified and ``-skipProbe`` is not set to ``false``, then
      the incoming data will be lightly probed to determine what type of data it
      is. The following data types are automatically recognized: GIF, PDF, PNG,
      JPEG. Unrecognized data types are set to have the
      :mimetype:`application/octet-stream` content type.
   ``-disposition``
      This string indicates the value for the :mailheader:`Content-Disposition`
      header. This value defaults to ``'attachment'``. The other possible value is
      ``'inline'``.
   ``-charset``
      If given, this string will be appended to the :mailheader:`Content-Type`
      header as a ``";charset="`` component.
   ``-skipProbe``
      This boolean parameter defaults to ``false``. If set to ``true``, no
      content type probe will occur.
   ``-noAbort``
      This boolean parameter defaults to ``false``. This means that `sendFile`
      will abort by default after the data is delivered to the client. Set this
      parameter to ``true`` in order to prevent the abort.
   ``-chunkSize``
      This parameter sets the size of the buffer with which the data is read and
      sent to the client. This mainly has a benefit when sending physical file
      data as it controls the memory usage. This value defaults to ``65535``,
      the result of the `fcgi_bodyChunkSize` method.
   ``-monitor``
      An object can be given to monitor the send process. Whatever object is
      given here will have its invoke method called for each chunk sent. The
      invoke will be passed the bytes object for the current chunk as well as an
      integer indicating the overall size of the bytes being sent.

   If the `sendFile` method succeeds and does not abort, no value is returned.


HTTP Response Status
--------------------

The HTTP response status line consists of a numeric code and a short textual
message. When a request is first started it is given a "200 OK" status line. If
a file is requested that does not exist, Lasso will respond with a "404 NOT
FOUND" status. An unhandled failure will generate a "500 Unhandled Failure"
status.

The status can be set or reset multiple times. Its value is not used until the
request data is sent to the client. However, once any data has been sent then
the status can no longer effectively be set.

The following methods get or set the HTTP response status:

.. member:: web_response->setStatus(code::integer, msg::string)
.. member:: web_response->getStatus()::pair

   The first method sets the HTTP status code and message. The second returns
   the status as a pair containing the code/message as the pair's first/second.


At Begin and End
================

Lasso permits arbitrary code to be run immediately before and immediately after
a request with full access to the `web_request` and `web_response` objects. Code
run before a request can manipulate the request data which will be use by the
request handler code. Code run after a request can manipulate the outgoing
headers and content body, doing things such as rewriting HTML links or
compressing data for efficiency.

Code to be run after a request completes is added during the request itself
through the `web_response->addAtEnd` method. Since code to be run before a
request must be added outside of any request, the `define_atBegin` method is
used. These methods are described below.

.. method:: define_atBegin(code)

   Installs code to be invoked at the beginning of each request. The code will
   have access to the `web_request` and `web_response` objects that will be
   available during the request's duration. At-begin code can set response
   headers and data and complete the request if it chooses, thus fully
   intercepting the normal request URI file request and processing routines.
   This is the recommended route for applications wanting to provide virtual
   URLs. Once an at-begin is in place it cannot be removed. Multiple at-begins
   are supported and are run in the order in which they are installed.

   The object installed as the at-begin code is copied to each request's thread
   each time. This means that a capture's local variables or any object's data
   members are deeply copied each time. The most efficient steps would be to
   define a method as the at-begin handler and then pass a reference to that
   method as the at-begin code. For example, passing ``\foo`` to
   `define_atBegin` would pass the ``foo`` method to `define_atBegin`. It would
   be invoked for each request and use the `web_request` and `web_response`
   within it.

.. method:: addAtEnd(code)

   This `web_response` method sets the parameter to be run at the request's end.
   At-end code is normally run before data is sent to the client, but this may
   not be the case if data has been manually pushed using the `sendChunk`
   method. At-begins are executed before the session link-rewriter is run.
   Multiple at-ends are supported and each are run in the order in which they
   were installed.

   At-ends are added on a per-request basis, as opposed to at-begins which are
   added globally. At-end code is not copied in any way. A capture passed to
   this method will be detached.
