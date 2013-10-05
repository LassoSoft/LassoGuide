.. _sending-email:

*************
Sending Email
*************

Lasso includes a built-in system for queuing and sending email messages to SMTP
servers. Email messages can be sent to site visitors to notify them when they
create a new account or to remind them of their login information. Email
messages can be sent to administrators when various errors or other conditions
occur. Email messages can even be sent in bulk to many email addresses to notify
site visitors of updates to the Web site or other news.


Overview
========

Email messages are queued using the ``email_send`` method. All outgoing messages
are stored in tables of the Site database. The queue can be examined and
messages removed in the
:ref:`Email Queue section of Instance Administration <instance-administration-email>`.

Lasso’s email system checks the queue periodically and sends any messages which
are waiting. If the email system encounters an error when sending an email then
it stores the error in the database and requeues the message. If too many errors
are encountered then the message send will be cancelled.

By default, Lasso sends queued messages directly to the SMTP server which
corresponds to each recipient address. This means that a single message may end
up being sent to multiple SMTP servers in order to deliver it to each recipient.
It is also possible to specify SMTP hosts directly within the ``email_send``
method.

.. note::
   If a local SMTP server is being used then Lasso must either have valid SMTP
   AUTH credentials or be otherwise allowed to send unrestricted messages
   through the SMTP server . Consult the SMTP server documentation for details
   about how to setup SMTP AUTH security or how to allow specific IP addresses
   to relay messages.

By default Lasso will send up to 100 messages to each SMTP server every
connection. Lasso will open up to 5 outgoing SMTP connections at a time. Lasso
selects messages to send in priority order, but once it connects to an SMTP
server it delivers as many messages as possible. This means that a batch send to
an SMTP server will contain high priority messages as well as medium and low
priority messages.

.. note::
   The maximum size of an email message including all attachments should be less
   than 8MB using the ``email_send`` method . If necessary, larger messages can
   be sent using the ``email_immediate`` method described in the
   :ref:`Email Composing<email-composing>` section.


Email Structure
---------------

The structure of a composed email message will depend on what type of message is
being sent. Lasso supports the following structure variations depending on what
parameters are specified in the ``email_send`` or ``email_compose`` methods.

Plain Text
   Simple messages specified with a ``-Body`` parameter are sent as a single
   text/plain part with no boundaries.

HTML
   Simple HTML messages with an ``-HTML`` parameter are sent as a single
   text/html part with no boundaries.

HTML with Plain Text
   Messages which have both an ``-HTML`` parameter and a ``-Body`` parameter are
   sent as multipart/alternative messages with both text/plain and text/html
   parts.

HTML with Embedded Images
   Messages which use ``-HTMLImages`` replace the text/html part with a
   multipart/related part with enclosed text/html and inline attachment parts.

Attachments
   Messages with attachments are sent multipart/mixed and include the
   text/plain, text/html, multipart/alternative, or multipart/related part which
   is appropriate based on the type of message and the attachment parts.

See each of the following sections for details about how other ``email_send``
and ``email_compose`` parameters affect the composition of each part.


Email Send Method
=================

The ``email_send`` method is used to send email messages from Lasso. This method
supports the most common types of email including plain text, HTML, HTML with a
plain text alternative, embedded HTML images, and attachments.

.. method:: email_send(\
         -host= ?, \
         -username= ?, \
         -password= ?, \
         -port= ?, \
         -timeout= ?, \
         -priority= ?, \
         -to= ?, \
         -cc= ?, \
         -bcc= ?, \
         -from= ?, \
         -replyto= ?, \
         -sender= ?, \
         -subject= ?, \
         -body= ?, \
         -html= ?, \
         -transferencoding= ?, \
         -contenttype= ?, \
         -characterset= ?, \
         -attachments= ?, \
         -extramimeheaders= ?, \
         -simpleform= ?, \
         -tokens= ?, \
         -merge= ?, \
         -date= ?, \
         -immediate= ?, \
         -ssl= ?\
      )

   Adds a message to the email queue. The method requires a ``-subject``
   parmameter, a ``-from`` parameter, and one of either ``-to``, ``-cc``, or
   ``-bcc`` parameters. Below is a description of each of the parameters.

   ``-from``
      The sender of the message. Required.

   ``-subject``
      The subject of the message. Required.

   ``-to``
      The recipient of the message. Multiple recipients can be specified by
      separating their email addresses with commas.

   ``-cc``
      Carbon copy recipients of the message.

   ``-bcc``
      Blind carbon copy recipients of the message.

   ``-body``
      The body of the message. Either a -Body or -HTML part (or both) is
      required. See the following section on HTML Messages for details about how
      to create HTML and mixed message.

   ``-html``
      The HTML part of the message. Either a -Body or -HTML part (or both) is
      required.

   ``-htmlImages``
      Specifies a list of files which will be used as images for the HTML part
      of an outgoing message. Accepts either an array of file paths or an array
      of pairs which include a file name as the first part and the data for the
      file as the second part.

   ``-attachments``
      Specifies a list of files that will be attached to the outgoing message.
      Accepts either an array of file paths or an array of pairs which include a
      file name as the first part and the data for the file as the second part.

   ``-tokens``
      Specifies a map of token names and values which will be merged into the
      email message. The same tokens will be used on every message.

   ``-merge``
      Specifies a map of email addresses. Each email address should have as its
      value a map of token names and values. The values in this merge map will
      override those in the tokens map if both are specified.

   ``-priority``
      Specifies the priority of the message. Valid values include 'High' or
      'Low'. Default is 'Medium'.

   ``-replyTo``
      The email address that should be used for replies to this message.

   ``-sender``
      The email address that should be reported as the sender of this message.

   ``-contentType``
      The value for the Content-Type header of the message.

   ``-transferEncoding``
      The value for the Transfer-Encoding header of the message.

   ``-characterSet``
      The character set in which the message should be encoded.

   ``-contentDisposition``
      Can be set to 'inline' in order to embed all attachments inline. Defaults
      to 'attachment'.

   ``-extraMIMEHeaders``
      A pair array which defines extra MIME headers that should be added to the
      email message.

   ``-immediate``
      If specified then the email is sent immediately without using the outgoing
      message queue. This option can be used for messages which have very large
      attachments.

   ``-host``
      SMTP host through which to send messages.

   ``-port``
      SMTP port. Defaults to 25.

   ``-username``
      Specifies the username for SMTP AUTH if required by the SMTP server. If
      specified a ``-Password`` is also required.

   ``-password``
      Specifies the password for SMTP AUTH if required by the SMTP server. If
      specified a ``-Username`` is also required.

   ``-timeout``
      Specifies the timeout for the SMTP server in seconds.


Sending a Plain Text Message
----------------------------

An email can be sent with a hard-coded body by specifying the message directly
within the ``email_send`` method. The following example shows an email sent to
"example@example.com" with a hard-coded message body::

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = 'This is the body of the email.'
   )

The body of an email message can be assembled in a variable in the current Lasso
page and then sent using the ``email_send`` method. The following example shows
a variable "email_body" which has several items added to it before the message
is finally sent::

   local(email_body) = 'This is the body of the email'
   #email_body += '\nSent on: ' + server_date + ' at ' + server_time
   #email_body += '\nCurrent visitor: ' + client_username + ' at ' + client_ip

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = #email_body
   )

A Lasso page on the web server can be used as the message body for an email
message using the ``include`` method. A Lasso page created to be a message body
should contain no extra white space. The following example shows a Lasso page
"format.lasso", which is in the same folder as the current Lasso page, being
used as the message body for an email. Any Lasso code within "format.lasso" will
be executed before the email is sent::

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = include('format.lasso')
   )


Send An Email Message To Multiple Recipients
--------------------------------------------

Email can be sent to multiple recipients by including their addresses as a comma
delimited list in the ``-to`` parameter, the ``-cc`` parameter, or the ``-bcc``
parameter.

The following example shows an ``email_send`` method with two recipients in the
``-to`` parameter. The recipients' email addresses are specified with a comma
between them: "example@example.com, somone@example.com". No extraneous
information such as the recipients real names needs to be included::

   email_send(
      -to      = 'example@example.com, somone@example.com',
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = include('format.lasso')
   )

The following example shows an ``email_send`` method with one recipient in the
``-to`` parameter and two recipients in the ``-cc`` parameter. The carbon copy
parameter is generally used to include recipients who are not the primary
recipient of the email, but need to be informed of the correspondence. The
addresses for the carbon copied recipients are stored in variables and
concatenated together with a comma between them::

   local(president) = 'president@example.com'
   local(someone)   = 'someone@example.com'

   email_send(
      -to      = 'example@example.com',
      -cc      = #president + ',' + #someone,
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = include('format.lasso')
   )

The following example shows an ``email_send`` method with one recipient in the
``-to`` parameter and two recipients in the ``-bcc`` parameter. The Blind Carbon
Copy parameter can be used to send email to many recipients without disclosing
the full list of recipients to everyone who receives the email. Each recipient
will receive an email that contains only the address in the ``-to`` parameter:
"announce@example.com"::

   email_send(
      -to      = 'announce@example.com',
      -bcc     = 'example@example.com, someone@example.com',
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = include('format.lasso')
   )


Sending HTML Messages
---------------------

HTML messages can be sent from Lasso by specifying the HTML body for the message
using the ``-html`` parameter. Images can be embedded in the email message using
the ``-htmlImages`` parameter. If a message includes both an ``-html`` parameter
and a ``-body`` parameter then it will be sent as a "multipart/alternative"
message so mail clients that do not recognize HTML messages will see only the
plain text part.

An HTML page can be sent as the body of the message by using the ``include``
method as the value to the ``-html`` parameter. Image references or URLs in the
HTML page should be specified including the "http://" prefix and server name.
(Alternatively, images can be embedded within the email using the
``-htmlImages`` parameter as shown in a later example.)

For example, the following HTML would reference an example web page and an image
which shows a coupon graphic. Both addresses are fully specified since they will
need to be loaded from within the email client without any other information
about the Web server::

   <h2>Money Saving Coupon</h2>
   <p>Print out the money saving coupon below or click on it to order directly from our Web site.<br />
      <a href="http://www.example.com/couponoffer.html">
         <img src="http://www.example.com/couponoffer.gif" border="0" width="288" height="288" />
      </a>
   </p>

If that HTML were in a file named "email_body.html", then a lasso page in the
same folder could contain the following code to email it out::

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'An HTML Email',
      -html    = include('email_body.html')
   )

A  plaintext/HTML alternative email can be sent by specifying both a ``-body``
parameter and an ``-html`` parameter. The message of both parts should be
equivalent. (If equivalent text and HTML parts can’t be generated then it is
preferable to send just an HTML part. Email clients which don’t render HTML will
display the raw HTML to the user, but this is preferable to seeing a message
which simply says that the message was sent as HTML.) Recipients with text-based
email clients will see the text part while recipients with HTML-based email
clients will see the HTML part::

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'A Multi-Part Email',
      -body    = include('format.lasso'),
      -html    = include('email_body.html')
   )

HTML messages can include embedded images using the ``-htmlImages`` parameter.
This parameter can be specified with either a single file name or an array of
file names. Within the email message the images can be referenced in two ways.

If the ``email_send`` method contains the parameter
``-htmlImages=Array('/apache_pb.gif')`` then Lasso will automatically fix any
HTML ``<img>`` tags that have that same image referenced in their src parameter.
Note that the path must be exactly the same for Lasso to be able to make this
replacement.

Ex::

   email_send(
      -to         = 'example@example.com',
      -from       = 'example@example.com',
      -subject    = 'An HTML Email With Embedded Image',
      -html       = '<h2>Embedded Image</h2><br /><img src="/apache_pb.gif" />',
      -htmlImages = Array('/apache_pb.gif')
   )

Alternatively, the ``Content-ID`` of the embedded image should be referenced in
the ``<img>`` tag following a "cid:" prefix. Lasso automatically uses the image
file name as the ``Content-ID`` without any path information so the same image
referenced above can also be referenced like this:
``<img src="cid:apache_pb.gif" />``

Ex::

   email_send(
      -to         = 'example@example.com',
      -from       = 'example@example.com',
      -subject    = 'An HTML Email With Embedded Image',
      -html       = '<h2>Embedded Image</h2><br /><img src="cid:apache_pb.gif" />',
      -htmlImages = Array('/apache_pb.gif')
   )

Images which are generated programatically can be embedded in an HTML message by
specifying a pair including the name of the image and the data of the image. In
the example below the image data comes from the ``include_raw`` method, but it
could also be generated using the ``image`` methods or retrieved from a database
field. Note that the name of the image does not have to match, but the name
which is specified in the first part of the pair should be used within the HTML
body::

   email_send(
      -to         = 'example@example.com',
      -from       = 'example@example.com',
      -subject    = 'An HTML Email With Embedded Image',
      -html       = '<h2>Embedded Image</h2><br /><img src="myimage.jpg" />',
      -htmlImages = Array('myimage.jpg'=include_raw('/apache_pb.jpg'))
   )


Send Attachments with an Email Message
--------------------------------------

Files can be included as attachments to email messages using the
``-attachments`` parameter. This parameter takes an array of file paths as a
value. When the email is sent, each file is read from disk and encoded using
Base-64 encoding. The recipient’s email client will automatically decode the
attached files and make them available.

.. note::
   The maximum size of an email message including all attachments must be less
   than 8MB using the ``email_send`` method. If necessary, larger messages can
   be sent using the ``-immediate`` parameter or the ``email_immediate`` method
   described in the :ref:`Email Composing<email-composing>` section.

The following example shows a pair of files being sent with an email message.
The attachments are named "MyAttachment.txt" and "MyAttachment2.txt". They are
located in the same folder as the Lasso page which is sending the email. These
text files will not be processed by Lasso before they are sent::

   email_send(
      -to          = 'example@example.com',
      -from        = 'example@example.com',
      -subject     = 'An Email with Two Attachments',
      -body        = 'This is the body of the Email.',
      -attachments = array('MyAttachment.txt', 'MyAttachment2.txt')
   )

Files can be generated programmatically and attached to an email message by
specifying a pair with the name of the file and the contents of the file. For
example, the following ``email_send`` method uses the ``pdf_doc`` type to to
create a PDF file. The generated PDF file is sent as an attachment without it
ever being written to disk::

   local(my_file) = pdf_doc(-size='A4', -margin=(: 144.0, 144.0, 72.0, 72.0))
   #my_file->Add(
      PDF_Text("I'm a PDF document", -font=pdf_font(-face='Helvetica', -size=36))
   )

   email_send(
      -to          = 'example@example.com',
      -from        = 'example@example.com',
      -subject     = 'An Email with a PDF',
      -body        = 'This is the body of the Email.',
      -attachments = array('MyPDF.pdf' = string(#my_file))
   )


Change the Priority of a Message
--------------------------------

Most messages should be sent at the default priority. Sending bulk messages like
a newsletter at "Low" priority will ensure that the normal email from the site
is sent as soon as possible rather than waiting for the entire newsletter to be
sent first. The "High" priority should be reserved for time dependent messages
such as confirmation emails that a site visitor will be looking for immediately
within their email client.

To specify the priority, use the ``-priority`` parameter::

   email_send(
      -to       = 'example@example.com',
      -from     = 'example@example.com',
      -subject  = 'Password Reset Instructions',
      -body     = include('password_reset.lasso'),
      -priority = 'High'
   )


Send a Message with a "Reply-To" and "Sender" Header
----------------------------------------------------

The ``-replyTo`` parameter specifies a different address from the ``-from``
address which should be used for replies. Most email clients will use this
address when composing a response to a message. The ``-sender`` parameter allows
an alternate sender from the ``-from`` address to be specified. This can be
useful if a message is forwarded by Lasso, but the original sender should still
be recorded::

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -replyTo = 'repsonses@example.com',
      -sender  = 'otheruser@example.com',
      -subject = 'An Email',
      -body    = include('format.lasso')
   )


Send a Message with Extra Headers
---------------------------------

The ``-extraMIMEHeaders`` parameter can be used to send any additional header
parameters that are required. The value should be an array of name/value pairs.
Each of the pairs will be inserted into the email as an additional header::

   email_send(
      -to               = 'example@example.com',
      -from             = 'example@example.com',
      -subject          = 'An Email',
      -body             = include('format.lasso'),
      -extraMIMEHeaders = Array( 'Header' = 'Value', 'Header' = 'Value')
   )


Use an Alternate SMTP Server
----------------------------

Specify the ``-host`` parameter in the ``email_send`` method directly. If
required the port of the SMTP server can be changed with the ``-port``
parameter. An SMTP AUTH username and password can be provided with the
``-username`` and ``-password`` parameters. And the ``-timeout`` parameter sets
the timeout for the SMTP server in seconds::

   email_send(
      -host     = 'mail.example.com',
      -username = 'SMTP_USER',
      -password = 'USER_PASS',
      -timeout  = 120,
      -to       = 'example@example.com',
      -from     = 'example@example.com',
      -subject  = 'An Email',
      -body     = include('format.lasso')
   )


Email Merge
===========

Lasso can merge values into email messages just before it sends them. This
allows a single email message to be composed and then customized for several
recipients. The ``-tokens`` and ``-merge`` parameters make this possible.

In order to use the ``-tokens`` and ``-merge`` parameters the email message must
contain one or more email tokens. The preferred method of specifying tokens is
to use the ``email_token`` method. In plain text messages or messages that can’t
be processed through Lasso the ``#TOKEN#`` marker can be used instead. For
example, the method ``email_token('FirstName')`` corresponds to the marker
``#FirstName#``.

.. method:: email_token(name::string)

   Email tokens are created using this method. It requires a single value which
   is the name of the email token.


For example, an email message can be marked up with email tokens for the first
name and last name of the recipient. The start of the message, stored in a file
called "body.lasso" might be as follows::

   Dear [email_token('FirstName')] [email_token('LastName')],

The email message is going to be sent to two recipients: "John Doe" at
"john@example.com" and "Jane Doe" at "jane@example.com". The merge map is
constructed as follows. Each element of the map includes an email address as the
key and a map of token values as its value::

   local(myMergeTokens) = map(
      'john@example.com' = map('FirstName'='John', 'LastName'='Doe'),
      'jane@example.com' = map('FirstName'='Jane', 'LastName'='Doe')
   )

A default token map can also be constructed. The values from this map would be
used if any tokens are missing from the email address specified maps shown
above::

   local(myDefaultTokens) = map('FirstName'='Lasso User','LastName' = '')

The ``email_send`` method would be written as follows. The email message is
being sent to two recipients. The method references "body.lasso" as the
``-body`` of the email message which has the included ``email_token`` methods,
``-merge`` specifies ``#myMergeTokens``, and ``-tokens`` specifies
``#myDefaultTokens``::

   email_send(
      -to      = 'john@example.com, jane@example.com',
      -from    = 'example@example.com',
      -subject = 'Mail Merge',
      -body    = include('body.lasso'),
      -merge   = #myMergeTokens,
      -tokens  = #myDefaultTokens

The message to John Doe would contain this text::

   Dear John Doe,


Email Status
============

Email messages which are sent using the ``email_send`` method are stored in an
outgoing email queue temporarily and then sent by a background process. Any
errors encountered when sending a message can be viewed in the Email Queue
section of Lasso Administration.

However, it is often desirable to get information about a message that was sent
programatically without examining the queue table. The following documented
methods allow the status of a recently sent message to be examined.

.. method:: email_result

   Can be called immediately after calling ``email_send`` to get a unique ID
   string for the message that was queued.

.. method:: email_status(id)

   Accepts an ID from the ``email_result`` method and returns the status of the
   queued message: "sent", "queued", or "error".

.. note::
   The email sender may take from a few seconds or longer to send an email
   message. Checking the status immediately after calling ``email_send`` will
   always return "queued". So make sure to always delay a bit before checking
   the status.

The following example shows an ``email_send`` method that sends a message. The
``Email_Result`` method is called immediately after to store the unique ID of
the message that was sent. After a delay of 30 seconds the ``email_status``
method is called to see if the message was successfully sent::

   email_send(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'An Email',
      -body    = 'This is the body of the email.'
   )
   local(my_email) = email_result
   sleep(30000)
   email_status(#my_email)

In a practical solution the unique ID returned by ``email_result`` would be
stored in a session variable or in a database table and then would be checked
some time later using ``email_status`` to see if the email message was sent or
if the address it was sent to was invalid.


.. _email-composing:

Composing Email
===============

The ``email_send`` method handles all of the most common types of email that can
be sent through Lasso including plaintext messages, HTML messages, HTML messages
with a plain text alternative messages, and messages with attachments.

For more complex messages structures the ``email_compose`` type can be used
directly to create the MIME text of the message. The message can then be sent
with the ``Email_Queue`` method. Both of these method are used internally by
``email_send``.

The ``email_compose`` type accepts the same parameters as ``email_send`` except
those which specify the SMTP server and priority of the outgoing message. After
creating an object with ``email_compose``, member methods can be used to add
additional text parts, html parts, attachments, or generic MIME parts. This
allows very complex email structures to be created with a lot more control than
``email_send`` provides.

The ``email_compose`` type can also be used to create email parts. When the
creator method is called without a ``-to``, ``-from``, or ``-subject``, then a
MIME part is created rather than a complete email message. This part can then be
fed into the ``email_compose->addPart`` method or into the ``-attachments`` or
``-htmlImages`` parameters to place the part within a complex email message.

The ``email_queue`` method is designed to be fed an ``email_compose`` object. It
requires three parameters, the ``-data``, ``-from``, and ``-recipients``
parameters as attributes of an ``email_compose`` object. In addition, SMTP
server parameters and the sending priority can be specified just like in
``email_send``. Queued emails must be less than 8MB in size including all
encoded attachments.

The ``email_immediate`` method takes the same parameters as the ``email_queue``
method, but sends the message immediately rather than adding it to the email
queue. This tag can be used to send messages larger than 8MB if required. Use of
the ``email_immediate`` method is not recommended since it bypasses the
priority, error handling, and connection handling features of the email sending
system.

.. type:: email_compose
.. method:: email_compose(\
      -to= ?, \
      -from= ?, \
      -cc= ?, \
      -bcc= ?, \
      -subject= ?, \
      -sender= ?, \
      -replyto= ?, \
      -body= ?, \
      -html= ?, \
      -date= ?, \
      -contenttype= ?, \
      -characterset= ?, \
      -transferencoding= ?, \
      -contentdisposition= ?, \
      -headertype= ?, \
      -extramimeheaders= ?, \
      -attachments= ?, \
      -attachment= ?, \
      -htmlimages= ?, \
      -parts= ?\
   )

   Creates an ``email_compose`` object, accepting similar parameters as
   ``email_send``. if the ``-to``, ``-from``, and ``-subject`` parameters are
   not specified then a MIME part is created, otherwise a full MIME email is
   created.

.. member:: email_compose->addAttachment(-data= ?, -name= ?, -path= ?, -type= ?)

   Adds an attachment to an email object. The data of the attachment can be
   specified directly in the ``-data`` parameter or the path to a file can be
   specified in the ``-path`` parameter. The name of the attachment can be
   specified in the ``-name`` parameter. The MIME type can be specified with the
   ``-type`` parameter.

.. member:: email_compose->addHTMLPart(-data= ?, -path= ?, -images= ?)

   Adds an HTML part to an email object. The text of the HTML part can be
   specified directly in the ``-data`` parameter or the path to a file can be
   specified in the ``-path`` parameter. Additionally, the ``-images`` parameter
   can take the same values as the ``-htmlImages`` parameter of the
   ``email_send`` method.

.. member:: email_compose->addTextPart(-data= ?, -path= ?)

   Adds a text part to an email object. The text of the part can be specified
   directly in the ``-data`` parameter or the path to a file can be specified in
   the ``-path`` parameter.

.. member:: email_compose->addPart(-data= ?)

   Adds a generic part to an email object. Requires a parameter ``-data`` which
   specifies the data for the part. The part must be properly formatted as a
   MIME part. No formatting or encoding will be performed by Lasso.

.. member:: email_compose->data(-prefix::boolean= ?, -force::boolean= ?)

   Returns the MIME text of the composed email.

.. member:: email_compose->from()

   Returns the from address of the composed email.

.. member:: email_compose->recipients()

   Returns a list of recipients of the composed email.


.. method:: email_batch()

   Takes a block of code, and with in this code it temporarily suspends some
   back-end operations of the email queue so that a batch of email messages can
   be queued quickly. Any messages which are already queued will continue to
   send while the code in the specified block is running.

.. method:: email_queue(\
         -data= ?, \
         -recipients= ?, \
         -from= ?, \
         -host= ?, \
         -username= ?, \
         -password= ?, \
         -port= ?, \
         -timeout= ?, \
         -priority= ?, \
         -tokens= ?, \
         -merge= ?, \
         -date= ?, \
         -ssl= ?\
      )

   Queues a message for sending. Requires either a ``-data`` parameter with the
   MIME text of the email to send, ``-from`` specifying the from address for the
   email, and ``-recipients`` an array of recipients for the email. Can also
   accept ``-priority`` and SMTP server ``-host``, ``-port``, ``-timeout,
   ``-username``, and ``-password`` parameters. A different ``-tokens``
   parameter can be specified for each queued message to perform email merge.

.. method:: email_immediate(\
         -data, \
         -recipients =?, \
         -from =?, \
         -host =?, \
         -username =?, \
         -password =?, \
         -port =?, \
         -timeout =?, \
         -ssl =?\
      )

   The same as ``email_queue``, but sends the message immediately without
   storing it in the database.

.. method:: email_merge(data, tokens, charset= ?, transferencoding= ?)

   Allows the email merge operation to be performed on any text. Requires two
   parameters: the text which is to be modified and a map of tokens to be
   replaced in the text. Optional ``charset`` and ``transferEncoding``
   parameters can specify what type of encoding should be applied to the merged
   tokens.


Send a Batch of Messages
------------------------

The ``email_batch`` method can be used when a number of messages needs to be
queued all at once. The method temporarily suspends some back-end operations of
the email queue so that the messages can be queued faster. When the given block
is processed the queue is allowed to resume sending the queue messages.

The example below shows how an inline might be used to find a collection of
email addresses. The ``email_batch`` method ensure that the messages are queued
as fastly as possible::

   email_batch => {
      inline(-search, ...) => {
         records => {
            email_send(-from='sender@example.com', -to=field('email_address'), ...)
         }
      }
   }

.. note::
   The email merge method discussed earlier in this chapter can also be used to
   send an email message to a collection of recipients quickly.


Compose an Email Message
------------------------

The ``email_compose`` type can be used to compose an email message. In this
example a simple email message is created in a variable message::

   local(message) = email_compose(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'Example Message',
      -body    = 'Example Message'
   )

The text of the composed email message can be viewed by outputing the variable
"message" to the page. Note that ``encode_html`` should always be used since
certain headers of the email message use angle brackets to surround values.
Also, HTML ``<pre> </pre>`` tags make it a lot easier to see the formatting of
the email message::

   <pre>[#message->asString->encodeHtml]</pre>

Additional text or html parts or attachments can be added using the appropriate
member methods on the object in the "message" variable. For example, an
attachment can be added using the ``email_compose->addAttachment`` method as
follows::

   #message->addAttachment(-path='ExampleFile.txt')


Queue an Email Message
----------------------

An email message that was created using the ``email_compose`` object can be
queued for sending using the ``email_queue`` method. The following example shows
how to send the email message created above. The three required parameters
``-data``, ``-from``, and ``-recipients`` are all fetched from the
``email_compose`` object::

   email_queue(
      -data       = #message->data,
      -from       = #message->from,
      -recipients = #message->recipients
   )


SMTP Type
=========

All communication with remote SMTP servers is handled by a data type called
``email_smtp``. These connections are normally handled automatically by the
``email_send``, ``email_queue``, ``email_immediate``, and background email
sending process.

The ``email_smtp`` type can be used directly for low-level access to remote SMTP
servers, but this is not generally necessary.

.. type:: email_smtp
.. method:: email_smtp(\
      -host::string= ?, \
      -port::integer= ?, \
      -timeout::integer= ?, \
      -username= ?, \
      -password= ?, \
      -ssl::boolean= ?, \
      -clientip= ?\
   )

   Creates a new SMTP connection object. Can optionally pass in the SMTP server
   parameters.

.. member:: email_smtp->open(\
      -host= ?, \
      -port= ?, \
      -timeout= ?, \
      -username= ?, \
      -password= ?, \
      -ssl= ?, \
      -clientip= ?\
   )

   Requires a ``-host`` that specifies the SMTP host to connect to. Also accepts
   optional ``-port``, ``-username``, ``-password``, and ``-timeout``
   parameters.

.. member:: email_smtp->command(\
      -send= ?, \
      -expect= ?, \
      -multi= ?, \
      -read= ?, \
      -timeout= ?\
   )

   Sends a raw command to the SMTP server. The ``-send`` parameter specifies the
   command to send. The ``-expects`` parameter specifies the numeric result code
   that is expected as a result. This method normally returns ``True`` or
   ``False`` depending on whether the expected result code was found. The
   ``-read`` parameter can be specified to have it return the result from the
   SMTP server.

.. member:: email_smtp->send(-from::string, -recipients::array, -message::string)

   Sends a single message to the SMTP server. Requires a ``-message`` parameter
   with the MIME data for the message, ``-recipients`` with an array of recpient
   email address, and ``-from`` with the email address of the sender.

.. member:: email_smtp->close()

   Closes the connection to the remote server.


.. method:: email_mxlookup(domain, -refresh= ?, -hostname= ?)

   This method takes a domain as a parameter and returns a map that describes
   the MX server for the domain. The map includes the domain, host, username,
   password, timeout, and SSL preference for the MX server.


Lookup an SMTP Server
---------------------

Use the email_mxlookup method. This tag returns a map that describes the
preferred MX server for the domain. An example lookup for AOL is shown below.
The first time an MX record is looked up it will be cached and the same
information will be returned on subsequent lookups::

   email_mxlookup('gmail.com')
   // =>
   // map(domain = gmail.com, host = gmail-smtp-in.l.google.com, priority = 5)


Communicate with an SMTP Server
-------------------------------

The ``email_smtp`` type can be used to send one or more messages directly to an
SMTP server. In the following example a message is created using the
``Email_Compose`` type. That message is then sent to an example SMTP server
"smtp.example.com" using an SMTP AUTH username and password. Once the message is
sent the connection is closed.

This example does not perform any error checking and only sends one message. The
actual source code for the built-in email sender background process presents a
good example of how this code looks in a full working solution::

   local(message) = email_compose(
      -to      = 'example@example.com',
      -from    = 'example@example.com',
      -subject = 'Example Message',
      -body    = 'Example Message'
   )
   local(smtp) = email_smtp

   #smtp->open(
      -host     = 'smtp.example.com',
      -port     = 25,
      -username = 'SMTPUSER',
      -password = 'mysecretpassword',
      -timeout  = 60
   )
   #smtp->send(
      -from       = #message->from,
      -recipients = #message->recipients,
      -message    = #message->data + '\r\n'
   )
   #smtp->close
