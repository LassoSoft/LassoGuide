.. _sending-email:

*************
Sending Email
*************

This tutorial outlines how to assemble the information required to send an email
with Lasso 9 in response to a contact form on a website.

-  First, we will set up the form in the web page the user will use to enter the
   information.
-  Second, we will add the code you will need to assemble the email and send it.

Contact Page Setup
==================

Below is an example HTML form on a "Contact Us" page that a user would use to
enter their contact information. On submit of the form, a response page 
(conveniently named "response.lasso") is loaded which processes the form and
sends the email.

::

    <form action="response.lasso" method="post">
        Your Name: <input type="text" name="yourName" value="" /><br />
        Your Email: <input type="text" name="yourEmail" value="" /><br />
        Your Comment:<br /><textarea name="yourComment"></textarea><br />
        <input type="submit" name="Send" value="submit" />
    </form>

 

Process the Form and Send the Email
===================================

This section describes the code on the response page, "response.lasso", which
processes the form data and sends the email.

The form parameters from the HTML form are accessible to Lasso via the
``web_request->param(name)`` method. For example, to see what the user entered
in the form, one could use the following code::

    Name entered was:    [web_request->param('yourName')]<br />
    Email entered was:   [web_request->param('yourEmail')]<br />
    Comment entered was: [web_request->param('yourComment')]

To send an email you will need the following information:

-  **Host** - The mail server you will be using to send the email (also known as
   an SMTP server).
-  **Username** and **Password** - To send via thie above mail server, you will
   need an account. Lasso uses these username and password parameters to 
   authenticate with the server and send your email.
-  **From** address - This is the from email address you wish to display you are
   sending the message from.
-  **To** address - The email address of the recipient of your email.
-  **Subject** - The subject of your message which we will customize below.
-  **Body** - The contents of the message you are sending.

The following code assembles the subject and body, and then it sends an email 
while outputting a "thank you" message::

    <?lasso
    local(subject) = 'A new website contact: ' + web_request->param('yourName')
    local(body) = 'Contact received on: ' + date            + '\r'   +
        'Contact name: ' + web_request->param('yourName')   + '\r'   + 
        'Contact email: ' + web_request->param('yourEmail') + '\r\r' +
        'Comment: \r' + web_request->param('yourComment')   + '\r\r' +
        'Contact recieved from IP Address: ' + web_request->remoteAddr

    email_send(
        -host     = 'mail.example.com', 
        -username = 'myMailAccount', 
        -password = 'myMailAccountPassword', 
        -from     = 'myMailAccount@example.com',
        -to       = 'recipient@example.com',
        -subject  = #subject,
        -body     = #body
    )

    'Thank you ' + web_request->param('yourName') + '; we will be in touch soon!'
    ?>

Troubleshooting
===============

One of the common problems with sending emails is authenticating with the
sending SMTP mail server. If no error is reported in the sending script and the
email has not beed received after a reasonable length of time, it is likely that
the email has been queued by Lasso but the athentication credentials are not
being accepted by the specified remote server.

To check this, visit the Lasso 9 administration console
(http://yourserver.com/lasso9/Admin/) and view the email queue. If your email is
still present in the queue it will display an error message outlining the reason
it has been unable to send. Common causes for email sending failures include
authentication failures, SMTP relay restrictions at the remote server, and 
TCP/IP Port restrictions in corporate or ISP firewalls.