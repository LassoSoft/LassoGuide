.. _retrieving-email:

****************
Retrieving Email
****************

Lasso allows messages to be downloaded from an account on a POP email server.
This enables developers to create solutions such as:

-  A list archive for a mailing list
-  A webmail interface allowing users to check POP accounts
-  An auto-responder that can reply to incoming messages with information

Lasso's flexible POP implementation allows messages to be easily retrieved from
a POP server with a minimal amount of coding. Additionally, Lasso allows the
messages available on the POP server to be inspected without downloading or
deleting them. Mail can be downloaded but left on the server so it can be
checked by other clients (and deleted at a later point if necessary).

All messages are downloaded as raw MIME text. The :type:`email_parse` type can
be used to extract the different parts of the downloaded messages, inspect their
headers, or extract attachments from them.

.. note::
   Lasso does not support downloading email via the IMAP protocol.


.. _retrieving-email-pop:

Sending POP Commands
====================

.. index:: POP

The :type:`email_pop` type is used to establish a connection to a POP email
server, inspect the available messages, download one or more messages, and mark
messages for deletion.


POP Methods
-----------

The following describes the :type:`email_pop` type and some of its member
methods:

.. type:: email_pop
.. method:: email_pop(\
      -server= ?, \
      -port= ?, \
      -username= ?, \
      -password= ?, \
      -APOP= ?, \
      -timeout= ?, \
      -log= ?, \
      -debug= ?, \
      -get= ?, \
      -host= ?, \
      -ssl= ?, \
      ...\
   )

   Creates a new POP object. Requires a ``-host`` parameter. Takes optional
   ``-port`` and ``-timeout`` parameters. The ``-APOP`` parameter selects
   authentication method. If ``-username`` and ``-password`` are specified then
   a connection is opened to the server with authentication. The ``-get``
   parameter specifies which command to perform when calling `email_pop->get`.

.. member:: email_pop->size()

   Returns the number of messages available for download.

.. member:: email_pop->get()
.. member:: email_pop->get(command::string)

   Performs the command specified when the object was created. "UniqueID" by
   default, or can be set to "Retrieve", "Headers", or "Delete".

.. member:: email_pop->retrieve()
.. member:: email_pop->retrieve(position::integer)
.. member:: email_pop->retrieve(position::integer, maxLines::integer)

   Retrieves the current message from the server. Optionally accepts a position
   to retrieve a specific message. Optional second parameter specifies the
   maximum number of lines to fetch for each email.

.. member:: email_pop->headers()
.. member:: email_pop->headers(position::integer)

   Retrieves the headers of the current message from the server. Optionally
   accepts a position to get the headers of a specific message.

.. member:: email_pop->uniqueID()
.. member:: email_pop->uniqueID(position::integer)

   Retrieves the unique ID of the current message from the server. Optionally
   accepts a position to get the unique ID of a specific message.

.. member:: email_pop->delete()
.. member:: email_pop->delete(position::integer)

   Marks the current message for deletion. Optionally accepts a position to mark
   a specific message.

.. member:: email_pop->close()

   Closes the POP connection, performing any specified deletes.

.. member:: email_pop->cancel()

   Closes the POP connection, but does not perform any deletes.

.. member:: email_pop->noOp()

   Sends a ping to the server. Allows the connection to be kept open without
   timing out.

.. member:: email_pop->authorize(\
      -username::string, \
      -password::string, \
      -APOP::boolean=true\
   )

   Requires a ``-username`` and ``-password`` parameter. Optional ``-APOP``
   parameter specifies whether APOP authentication should be used or not. Opens
   a connection to the server if one is not already established.


Message Retrieval
-----------------

The :type:`email_pop` type is intended to be used with the `iterate` method to
quickly loop through all available messages on the server. The `email_pop->size`
method returns the number of available messages. The `email_pop->get` method
fetches the "UniqueID" of the current message by default or can be set to
"Retrieve" the current message, the "Headers" of the current message, or even to
"Delete" the current message.

The ``-host``, ``-username``, and ``-password`` should be passed to the
:type:`email_pop` object when it is created. The ``-get`` parameter specifies
what command the `email_pop->get` method will perform. In this case it is set to
"UniqueID" (the default). ::

   local(myPOP) = email_pop(
      -host     = 'mail.example.com',
      -username = 'POPUSER',
      -password = 'MySecretPassword',
      -get      = 'UniqueID')

The `iterate` method can then be used on the "myPOP" variable. For example, this
code will download and delete every message from the target server. The variable
"myID" is set to the unique ID of each message in turn. The
`email_pop->retrieve` method fetches the current message and the
`email_pop->delete` method marks it for deletion. ::

   iterate(#myPOP, local(myID)) => {^
      #myID + '<br />'
      #myPOP->retrieve
      #myPOP->delete
      '<hr />'
   ^}

   // =>
   // 000000025280dd26
   // <br />
   // Return-Path: <joe@example.com>
   // X-Original-To: jane@example.com
   // Delivered-To: jane@example.com
   // Received: from mail.example.com (mail.example.com [127.0.0.1])
   //     by mail.example.com (Postfix) with ESMTP id 1B11410A37
   //     for <jane@example.com>; Mon, 11 Nov 2013 08:33:59 -0500 (EST)
   // Received: (qmail 4313 invoked from network); 11 Nov 2013 08:36:28 -0500
   // Message-ID: <5280DCC0.6070809@example.com>
   // Date: Mon, 11 Nov 2013 08:33:52 -0500
   // From: joe@example.com
   // MIME-Version: 1.0
   // To: jane@example.com
   // Subject: Test
   // Content-Type: text/plain; charset=ISO-8859-1; format=flowed
   // Content-Transfer-Encoding: 7bit
   //
   // Testing
   // <hr />

Both `email_pop->retrieve` and `email_pop->delete` could be specified with the
current `loop_count` as a parameter, but it is unnecessary since they pick up
the loop count from the surrounding `iterate` method. This example only
downloads and displays the text of each message. Most solutions will use the
:type:`email_parse` type defined below to parse and process the downloaded
:messages.

None of the deletes will actually be performed until the connection to the
remote server is closed. The `email_pop->close` method performs all deletes and
closes the connection. The `email_pop->cancel` method closes the connection, but
cancels all of the marked deletes. ::

   #myPOP->close


Using Email_Pop
---------------

This section includes examples of the most common tasks that are performed using
the :type:`email_pop` type. See the section :ref:`retrieving-email-parsing`
for examples of downloading messages and parsing them for storage in a database.


Download and Delete All Emails from a POP Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Open a connection to the POP server using `email_pop` with the appropriate host,
username, and password. The following example shows how to use
`email_pop->retrieve` and `email_pop->delete` to download and delete each
message from the server::

   local(myPOP) = email_pop(
      -host     = 'mail.example.com',
      -username = 'POPUSER',
      -password = 'MySecretPassword')

   iterate(#myPOP, local(myID)) => {
      local(myMSG) = #myPOP->retrieve
      // ... process message ...
      #myPOP->delete
   }
   #myPOP->close

Each downloaded message can be processed using the techniques described in the
section :ref:`retrieving-email-parsing` or can be stored in a database.


Leave Mail on Server and Only Download New Messages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to download only new messages it is necessary to store a list of all
the unique IDs of messages that have already been downloaded from the server.
This is usually done by storing the unique ID of each message in a database. As
messages are inspected the unique ID is compared to see if the message is new or
not. No deletion of messages is performed in this example.

For the purposes of this example, it is assumed that unique IDs are being stored
in a variable array called "myUniqueIDs". For each waiting message this
variable is checked to see if it contains the unique ID of the current message.
If it does not then the message is downloaded and the unique ID is inserted into
"myUniqueIDs". ::

   local(myPOP) = email_pop(
      -host = 'mail.example.com',
      -username = 'POPUSER',
      -password = 'MySecretPassword'
   )
   iterate(#myPOP, local(myID)) => {
      #myUniqueIDs->contains(#myID) ? loop_continue

      #myUniqueIDs->insert(#myID)
      // ... process message ...
   }
   #myPOP->close


Inspect Message Headers
^^^^^^^^^^^^^^^^^^^^^^^

The `email_pop->headers` method can be used to fetch the headers of each waiting
email message. This allows the headers to be inspected prior to deciding which
emails to actually download. In the following example the headers are fetched
with `email_pop->headers` and two variables, "needDownload" and "needDelete",
are set to determine whether either action should take place. ::

   local(myPOP) = email_pop(
      -host     = 'mail.example.com',
      -username = 'POPUSER',
      -password = 'MySecretPassword',
      -get      = 'UniqueID'
   )
   iterate(#myPOP, local(myID)) => {
      local(needDownload) = false
      local(needDelete)   = false
      local(myHeaders)    = #myPOP->headers
      // ... process headers and set #needDownload or #needDelete to true ...
      #needDownload ? #myPOP->retrieve
      #needDelete ? #myPOP->delete
   }
   #myPOP->close

The downloaded headers can be processed using the techniques described in the
section :ref:`retrieving-email-parsing`.


.. _retrieving-email-parsing:

Parsing Email
=============

Each of the messages that are downloaded from a POP server is returned in raw
MIME text form. This section describes the basic structure of email messages,
the :type:`email_parse` type that can be used to parse them into headers
and parts, and finally gives some examples of parsing messages.


Email Structure
---------------

The basic structure of a simple email message is shown below. The message starts
with a series of headers. The headers of the message are followed by a blank
line, then the body of the message.

Each server that handles the message adds its own :mailheader:`Received`
headers, so there may be many of them. The :mailheader:`Mime-Version`,
:mailheader:`Content-Type`, and :mailheader:`Content-Transfer-Encoding` headers
specify what type of email message it is and how it is encoded. The
:mailheader:`Message-ID` is a unique ID given to the message by the email
server. The :mailheader:`To`, :mailheader:`From`, :mailheader:`Subject`, and
:mailheader:`Date` headers are all specified by the sending user in their email
client (or in Lasso using `email_send`).

.. code-block:: none

   Received: From [127.0.0.1] BY example.com ([127.0.0.1]) WITH ESMTP;
      Thu, 08 Jul 2004 08:07:42 -0700
   Mime-Version: 1.0
   Content-Type: text/plain; charset=US-ASCII;
   Message-Id: <8F6A8289-D0F0-11D8-B21D-0003936AD948@example.com>
   Content-Transfer-Encoding: 7bit
   From: Example Sender <example@example.com>
   Subject: Test Message
   Date: Thu, 8 Jul 2004 08:07:42 -0700
   To: Example Recipient <example@example.com>

   This is the email message!

The order of headers is unimportant and each header is usually specified only
once (except for the :mailheader:`Received` headers which are in reverse
chronological order). A header can be continued on the following line by
starting the second line with a space or tab. Beyond those standard headers
shown here, email messages can also contain many other headers identifying the
sending software, logging spam and virus filtering actions, or even adding meta
information like a picture of the sender.

A more complex email message is shown below. This message has a
:mailheader:`Content-Type` of :mimetype:`multipart/alternative`. The body of the
message is divided into two parts, one text part and one HTML part. The parts
are divided using the boundary specified in the :mailheader:`Content-Type`
header (``---=_NEXT_fda4fcaab6``).

Each of the parts is formatted similarly to an email message. They have several
headers followed by a blank line and the body of the part. Each part has a
:mailheader:`Content-Type` and a :mailheader:`Content-Transfer-Encoding` which
specify the type part (either :mimetype:`text/plain` or :mimetype:`text/html`)
and encoding.

.. code-block:: none

   Received: From [127.0.0.1] BY example.com ([127.0.0.1]) WITH ESMTP;
   Thu, 08 Jul 2004 08:07:42 -0700
   Mime-Version: 1.0
   Message-Id: <14501276655.1089394748105@example.com>
   From: Example Sender <example@example.com>
   Subject: Test Message
   Date: Thu, 8 Jul 2004 08:07:42 -0700
   To: Example Recipient <example@example.com>
   Content-Type: multipart/alternative; boundary="---=_NEXT_fda4fcaab6";

   -----=_NEXT_fda4fcaab6
   Content-Type: text/plain; charset=ISO-8859-1
   Content-Transfer-Encoding: 8bit

   This is the text part of the email message!

   -----=_NEXT_fda4fcaab6
   Content-Type: text/html; charset=ISO-8859-1
   Content-Transfer-Encoding: 8bit

   <html>
   <body>
   <h3>This is the HTML part of the email message!</h3>
   </body>
   </html>
   -----=_NEXT_fda4fcaab6--

Attachments to an email message are included as additional parts. Typically, the
file that is attached is encoded using Base64 encoding so it appears as a block
of random letters and numbers. It is possible for one part of an email to itself
have a :mailheader:`Content-Type` of :mimetype:`multipart/alternative` and its
own boundary. In this way, very complex recursive email structures can be
created.

Lasso allows access to the headers and each part (including recursive parts) of
downloaded email messages through the :type:`email_parse` type.


Parsing Methods
---------------

The :type:`email_parse` type requires the raw MIME text of an email message as a
parameter when it is created. It returns an object whose member methods can be
used to inspect the headers and parts of the email message. Outputting an
:type:`email_parse` object to the page will result in a message formatted with
the most common headers and the default body part. An :type:`email_parse` object
can be used with the `iterate` method to inspect each part of the message in
turn.

.. type:: email_parse
.. method:: email_parse(mime::string)

   Parses the raw MIME text of an email. Requires a single string parameter.
   Outputs the raw data of the email if displayed on the page or converted to a
   string.

.. member:: email_parse->headers()

   Returns an array of pairs containing all the headers of the message.

.. member:: email_parse->header(name::string, ...)

   Returns a single specified header. Requires one parameter, the name of the
   header to be returned. See also the shortcuts for specific headers listed
   below. If ``-extract`` is specified then any comments in the header will be
   stripped. If ``-comment`` is specified then only the comments will be
   returned. If ``-safeEmail`` is specified then the email address will be
   obscured for display on the web. If ``-noDecode`` is specified then the raw
   header is returned without Quoted-Printable or BinHex decoding. This method
   returns an array if multiple headers with the same name are found.
   Optionally, ``-join`` can be used to specify a character to be used to
   combine the values in the array into a string.

.. member:: email_parse->mode()

   Returns the mode from the :mailheader:`Content-Type` for the message. Usually
   either text or multipart.

.. member:: email_parse->body(-type = void, -preamble = void, -array = void, ...)

   Returns the body of the message. Optional parameter specifies the preferred
   type of body to return (e.g. :mimetype:`text/plain` or
   :mimetype:`text/html`). If the body is encoded using Quoted-Printable or
   Base64 encoding then it is automatically decoded before being returned by
   this method.

.. member:: email_parse->size()::integer

   Returns the number of parts in the message.

.. member:: email_parse->get(position::integer)

   Returns the specified part of the message. Requires a position parameter. The
   part is returned as an :type:`email_parse` object that can be further
   inspected.

.. member:: email_parse->data()

   Returns the raw data of the message.

.. member:: email_parse->rawHeaders()

   Returns the raw data of the headers.

.. member:: email_parse->recipients()

   Returns an array containing all of the email addresses in the
   :mailheader:`To`, :mailheader:`Cc`, and :mailheader:`Bcc` headers.

.. member:: email_parse->to(...)
.. member:: email_parse->from(...)
.. member:: email_parse->cc(...)
.. member:: email_parse->bcc(...)
.. member:: email_parse->subject()
.. member:: email_parse->date()
.. member:: email_parse->content_type()
.. member:: email_parse->boundary()
.. member:: email_parse->charset()
.. member:: email_parse->content_disposition()
.. member:: email_parse->content_transfer_encoding()

   These methods are shortcuts that return the value for the corresponding
   header from the email message. The table below maps the method to the header.
   (The Bcc header will always be empty for received emails.)

   .. tabularcolumns:: |l|L|

   .. _retrieving-email-header-methods:

   .. table:: Email Header Methods

      ========================================== =========================================
      Email Header Method                        Email Header
      ========================================== =========================================
      ``email_parse->to``                        :mailheader:`To`
      ``email_parse->from``                      :mailheader:`From`
      ``email_parse->cc``                        :mailheader:`CC`
      ``email_parse->bcc``                       :mailheader:`BCC`
      ``email_parse->subject``                   :mailheader:`Subject`
      ``email_parse->date``                      :mailheader:`Date`
      ``email_parse->content_type``              :mailheader:`Content-Type (MIME Type)`
      ``email_parse->boundary``                  :mailheader:`Content-Type (boundary)`
      ``email_parse->charset``                   :mailheader:`Content-Type (charset)`
      ``email_parse->content_disposition``       :mailheader:`Content-Disposition`
      ``email_parse->content_transfer_encoding`` :mailheader:`Content-Transfer-Encoding`
      ========================================== =========================================

   The methods `email_parse->to`, `email_parse->from`, `email_parse->cc`, and
   `email_parse->bcc` also accept ``-extract``, ``-comment``, and ``-safeEmail``
   parameters like the `email_parse->header` method. These methods join multiple
   parameters by default, but ``-join=null`` can be specified to return an array
   instead.


Using Email_Parse
-----------------

This section includes examples of the most common tasks that are performed using
the :type:`email_parse` type. See the preceding section on the :ref:`email_pop
type <retrieving-email-pop>` for examples of downloading messages from a POP
email server.


Display a Downloaded Message
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Simply use the :type:`email_parse` type on the downloaded message and display it
on the page. The :type:`email_parse` object will output a formatted version of
the email message including a plain text body if one exists.

The following example shows how to download and display all the waiting messages
on an example POP mail server. The unique ID of each downloaded message is shown
as well as the output of `email_parse` in a set of ``<pre>`` tags. ::

   <?lasso
      local(myPOP) = email_pop(
         -host     = 'mail.example.com',
         -username = 'POPUSER',
         -password = 'MySecretPassword'
      )
      iterate(#myPOP, local(myID))
         local(myMSG) = #myPOP->retrieve
   ?>
   <h3>Message: [#myID]</h3>
   <pre>[email_parse(#myMSG)]</pre>
   <hr />
   <?lasso
      /iterate
      #myPOP->close
   ?>

   // =>
   // <h3>Message: 000000045280dd26</h3>
   // <pre>Date: Mon 11 Nov 2008 9:0:0 -0500
   // From: joe@example.com
   // To: jane@example.com
   // Subject: Test
   // Content-Type: text/plain; charset=ISO-8859-1; format=flowed
   // Content-Transfer-Encoding: 7bit
   //
   // Just Testing
   // </pre>
   // <hr />


Inspect Headers of a Downloaded Message
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are three ways to inspect the headers of a downloaded message.

#. The basic headers of a message can be inspected using the shortcut methods
   such as `email_parse->from`, `email_parse->to`, `email_parse->subject`, etc.
   The following example shows how to display the basic headers for a message,
   where the variable "myMSG" is assumed to be the output from an
   `email_pop->retrieve` method::

      [local(myParse) = email_parse(#myMSG)]
      <br />To:      [#myParse->to->encodeHTML]
      <br />From:    [#myParse->from->encodeHTML]
      <br />Subject: [#myParse->subject->encodeHTML]
      <br />Date:    [#myParse->date->asString->encodeHTML]

      // =>
      // To: Example Recipient
      // From: Example Sender
      // Subject: Test Message
      // Date: Thu 8 Jul 2004 08:07:42 -0700

   These headers can be used in conditionals or other code as well. For example,
   this conditional would perform different tasks based on whether the message
   is to one address or another::

      local(myParse) = email_parse(#myMSG)
      if(#myParse->to >> 'mailinglist@example.com') => {
         // ... store the message in the mailing list database ...
      else(#myParse->to >> 'help@example.com')
         // ... forward the message to technical support ...
      else
         // ... unknown recipient ...
      }

#. The value for any header, including application-specific headers, headers
   added by mail processing gateways, etc. can be inspected using the
   `email_parse->header` method. For example, the following code can check
   whether the message has SpamAssassin headers::

      [local(myParse)      = email_parse(#myMSG)]
      [local(spam_version) = string(#myParse->header('X-Spam-Checker-Version'))]
      [local(spam_level)   = string(#myParse->header('X-Spam-Level'))]
      [local(spam_status)  = string(#myParse->header('X-Spam-Status'))]
      <br />Spam Version: [#spam_version->encodeHTML]
      <br />Spam Level:   [#spam_level->encodeHTML]
      <br />Spam Status:  [#spam_status->encodeHTML]

      // =>
      // <br />Spam Version: SpamAssassin 2.61
      // <br />Spam Level:
      // <br />Spam Status: No, hits=-4.6 required=5.0 tests=AWL,BAYES_00 autolearn=ham

   The spam status can then be checked with a conditional in order to ignore any
   messages that have been marked as spam (note that the details will depend on
   what server-side spam checker is being used and which version). ::

      if(#spam_status >> 'Yes') => {
         // ... message is spam ...
      else
         // ... message is not spam ...
      }

#. The value for all the headers in the message can be displayed using the
   `email_parse->headers` method, as the following example shows::

      local(myParse) = email_parse(#myMSG)
      iterate(#myParse->headers, local(header))
         `<br />` + #header->first->encodeHTML + `: ` + #header->second->encodeHTML
      /iterate

      // =>
      // <br />Received: From [127.0.0.1] BY example.com ([127.0.0.1]) WITH ESMTP;
      //    Thu, 08 Jul 2004 08:07:42 -0700
      // <br />Mime-Version: 1.0
      // <br />Content-Type: text/plain; charset=US-ASCII;
      // <br />Message-Id: <8F6A8289-D0F0-11D8-B21D-0003936AD948@example.com>
      // <br />Content-Transfer-Encoding: 7bit
      // <br />From: Example Sender <example@example.com>
      // <br />Subject: Test Message
      // <br />Date: Thu, 8 Jul 2004 08:07:42 -0700
      // <br />To: Example Recipient <example@example.com>


Locate Parts of a Downloaded Message
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `email_parse->body` method can be used to find the plain text and HTML parts
of a message. The following example shows both the plain text and HTML parts of
a downloaded message::

   [local(myParse) = email_parse(#myMSG)]
   <pre>[#myParse->body(-type='text/plain')->encodeHTML]</pre>
   <hr />[#myParse->body(-type='text/html')->encodeHTML]<hr />

The `email_parse->size` and `email_parse->get` methods can be used with the
`iterate` method to inspect every part of an email message in turn. This will
show information about plain text and HTML parts as well as information about
attachments. The headers and body of each part is shown::

   [local(myParse) = email_parse(#myMSG)]
   [iterate(#myParse, local(myPart))]
      [iterate(#myPart->header, local(header))]
         <br />[#header->first->encodeHTML]: [#header->second->encodeHTML]
      [/iterate]
      <br />[#myPart->body->encodeHTML]
      <hr />
   [/iterate]

   // =>
   // <br />Content-Type: text/plain; charset=ISO-8859-1
   // <br />Content-Transfer-Encoding: 8bit
   // <br />This is the text part of the email message!
   // <hr />
   // <br />Content-Type: text/html; charset=ISO-8859-1
   // <br />Content-Transfer-Encoding: 8bit
   // <br />&lt;html&gt;
   // &lt;body&gt;
   // &lt;h3&gt;This is the HTML part of the email message!&lt;/h3&gt;
   // &lt;/body&gt;
   // &lt;/html&gt;
   // <hr />


Extract Attachments of a Downloaded Message
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Attachments of a multipart message appear as parts with a
:mailheader:`Content-Disposition` of "attachment". The name of the attachment
can be found by looking at the "name" field of the :mailheader:`Content-Type`
header. The data for the attachment is returned as the body of the part.

The attachments can be extracted and written out as files that re-create the
attached file, or they can be stored in a database, processed by the `image`
methods, or served immediately using `web_response->sendFile`.

The following example finds all of the attachments for a message using the
`iterate` method to cycle through each part in the message and inspect the
:mailheader:`Content-Disposition` header using
`email_parse->content_disposition`. The name
(``email_parse->content_type('name')``) and data (``email_parse->body``) of each
part that includes an attachment is used to write out a file using
`file->openWrite` and `file->writeBytes` which re-creates the attachment. ::

   local(myParse) = email_parse(#myMSG)
   if(#myParse->mode >> 'multipart') => {
      iterate(#myParse, local(myPart)) => {
         if(#myPart->content_disposition >> 'attachment') => {
            local(myFile)     = file('/Attachments/' + #myPart->content_type('name'))
            local(myFileData) = #myPart->body
            #myFile->doWithClose => {
               #myFile->openWrite&writeBytes(#myFileData)
            }
         }
      }
   }

.. note::
   In order for this code to work, the "Attachments" folder should already exist
   and Lasso Server should have permission to write to it.


Store a Downloaded Message in a Database
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Messages can be stored in a database in several different ways depending on how
the messages are going to be used later.

-  The simple headers and body of a message can be stored by calling
   `email_parse->asString` directly in an inline::

      local(myPOP) = email_pop(
         -host = 'mail.example.com',
         -username = 'POPUSER',
         -password = 'MySecretPassword'
      )
      handle => {
         #myPOP->close
      }
      iterate(#myPOP, local(myID)) => {
         local(myMSG)   = #myPOP->retrieve
         local(myParse) = email_parse(#myMSG)

         inline(
            -add,
            -database = 'example',
            -table = 'archive',
            'email_format' = #myParse->asString
         ) => {}
      }

-  Often it is desirable to store the common headers of the message in
   individual fields as well as the different body parts. This example shows how
   to do this::

      local(myPOP) = email_pop(
         -host = 'mail.example.com',
         -username = 'POPUSER',
         -password = 'MySecretPassword'
      )
      handle => {
         #myPOP->close
      }
      iterate(#myPOP, local(myID)) => {
         local(myMSG)   = #myPOP->retrieve
         local(myParse) = email_parse(#myMSG)

         inline(
            -add,
            -database       = 'example',
            -table          = 'archive',
            'email_format'  = #myParse->asString,
            'email_to'      = #myParse->to,
            'email_from'    = #myParse->from,
            'email_subject' = #myParse->subject,
            'email_date'    = #myParse->date,
            'email_cc'      = #myParse->cc,
            'email_text'    = #myParse->body(-type='text/plain'),
            'email_html'    = #myParse->body(-type='text/html')
         ) => {}
      }

-  The raw text of messages can be stored using `email_parse->data`. It is
   generally recommended that the raw text of a message be stored in addition to
   a more friendly format. This allows additional information to be extracted
   from the message later if required. ::

      local(myPOP) = email_pop(
         -host     = 'mail.example.com',
         -username = 'POPUSER',
         -password = 'MySecretPassword')
      handle => {
         #myPOP->close
      }
      iterate(#myPOP, local(myID)) => {
         local(myMSG)   = #myPOP->retrieve
         local(myParse) = email_parse(#myMSG)
         Inline(
            -add,
            -database    = 'example',
            -table       = 'archive',
            'email_text' = #myParse->asString,
            'email_raw'  = #myParse->data
         ) => {}
      }
      #myPOP->close

Ultimately, the choice of which parts of the email message need to be stored in
the database will be solution dependent.


Email Helper Methods
====================

The email methods use a number of helper methods for their implementation. The
following describes a number of these methods and how they can be used
independently.

.. method:: email_extract()

   Strips all comments out of a MIME header. If specified with a ``-comment``
   parameter returns the comments instead. Used as a utility method by
   `email_parse->header`.

   `email_extract` allows the different parts of email headers to be extracted.
   Email headers containing email addresses are often formatted in one of the
   three formats below::

      john@example.com
      "John Doe" <john@example.com>
      john@example.com (John Doe)

   In all three of these cases the `email_extract` method will return
   ":ref:`!john@example.com`". The angle brackets in the second example identify
   the email address as the important part of the header. The parentheses in the
   third example identify that portion of the header as a comment.

   If `email_extract` is called with the optional ``-comment`` parameter then it
   will return ":ref:`!john@example.com`" for the first example and "John Doe"
   for the two following examples.

.. method:: email_findEmails()

   Returns an array of all email addresses found in the input. Used as a utility
   method by `email_parse->recipients`.

.. method:: email_safeEmail()

   This method is used as a utility method by `email_parse->header`. It
   obscures an email address by returning the comment portion or only the
   username before the "@" character, and can be used to safely display email
   headers on the web without attracting email address harvesters. This method
   returns the following output for the example headers above::

      // =>
      // john
      // John Doe
      // John Doe

.. method:: email_translateBreaksToCRLF()

   Translates all return characters and line feeds in the input into ``"\r\n"``
   pairs.
