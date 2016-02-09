.. _browser-requests:

***************************
Inspecting Browser Requests
***************************

So far, we have talked in general terms about a web server using Lasso to put
together an HTML document for a web browser to view, but we haven't talked about
how a server and browser communicate. Briefly, web browsers and web servers
communicate over a protocol called HTTP. Think of the HTTP protocol as the
language that browsers and servers speak to each other. It starts with the
client (the browser) requesting a resource (usually an HTML page) from the
server. The server puts together a response and sends it back.

To build interactive web applications, Lasso gives programmers the ability to
inspect the request being made using the `web_request` object. In this tutorial,
we'll explore using and inspecting query parameters.

.. note::
   For a list and description of all the methods of the `web_request` object
   that can be used to examine client requests, see the table
   :ref:`requests-responses-variable-methods`.


What Are Query Parameters?
==========================

Query parameters are key/value data sent as part of the URL string requested by
a client. Let's look at the following example URL:

| ``http://example.com/rhino.lasso?first=hello&second=42``

It starts with the protocol ("http") followed by ``://``. Next comes the host
name followed by a slash-delimited path. The last part is the query string which
starts with a question mark to separate itself from the path. The query string
contains the key/value data for the query parameters. Query parameters are
separated by ampersands. In our example above, we have two query parameters:
"first=hello" and "second=42". The keys and values are separated from each other
by an equal sign.

It is important that the data in the query string be encoded for use in the URL
so that it doesn't conflict with reserved URL characters. For example, if we
wanted to use an ampersand in either the key or the value it must be properly
encoded so it doesn't look like we're starting a new query parameter. URL
encoded characters start with a percent sign, so to encode an ampersand we would
replace it with "%26". Luckily, Lasso has a method to do all the replacements
for us: ``bytes->encodeUrl``.


Using Query Parameters
======================

Our current example code sets the greeting and the background color based on the
current time of day. This may be what we usually want, but perhaps we would also
like the ability to demonstrate what the different greetings look like. In order
to do this there is no need to update our type definition, we just need to make
some adjustments to our web page code::

   <?lasso
      if(web_request->queryParam('hour')) => {
         local(time_of_day) = time_of_day(integer(web_request->queryParam('hour')))
      else
         local(time_of_day) = time_of_day
      }
   ?>
   <html>
      <body style="background-color: [#time_of_day->bgcolor]">
         [#time_of_day->greeting] I am an HTML document.
         <div>
            <a href="?hour=10">See Morning</a> |
            <a href="?hour=14">See Afternoon</a> |
            <a href="?hour=18">See Evening</a>
         </div>
      </body>
   </html>

The code has been changed to first check to see if a query parameter with the
name of hour has been sent. If it has, it will use that value, otherwise it will
just use the current hour. The code has also added links at the bottom that can
be clicked on to request this same page, but with a query parameter setup to
specify which time of day we would like to see.

Notice that if the "hour" query param has been sent that we are calling a method
named "integer" on the value. The integer method takes in data of any type and
tries to convert it to an integer value. For example, the string "73d" would be
changed to the integer 73. This is called casting. The ``time_of_day`` method is
expecting an integer, but all query param data are of type ``bytes`` (this is
because the data is taken from the query string which is sent as bytes via the
HTTP connection), so we must cast the byte data into an integer value.


What Are POST Parameters?
=========================

POST parameters are like query parameters: they are key/value data sent to the
web server. However, instead of being in the URL, they are sent in the body of
the client's request. The format of the body is just like that of the query
string, including the need to encode reserved URL characters in the key and the
value. To notify the web server about the POST parameters, the HTTP request sets
its method to "POST". (Note: POST requests can also have query parameters.)

The most common way to generate a POST request is to create an HTML form and set
its method to "post". This tells the browser to create a POST HTTP request when
it submits the form.


Using POST Parameters
=====================

It's nice that our code can now demonstrate how the page looks for each time of
day, but it could be better to be able to choose a specific hour and see what it
looks like for that hour. The sample code below allows for that::

   <?lasso
      if(web_request->queryParam('hour')) => {
         local(time_of_day) = time_of_day(integer(web_request->postParam('hour')))
      else
         local(time_of_day) = time_of_day
      }
   ?>
   <html>
      <body style="background-color: [#time_of_day->bgcolor]">
         [#time_of_day->greeting] I am an HTML document.
         <form action="" method="post">
            <select name="hour">
               <option value="0">12:00 AM</option>
            [loop(11)]
               <option value="[loop_count]">[loop_count]:00 AM</option>
            [/loop]
               <option value="12">12:00 PM</option>
            [loop(11)]
               <option value="[12 + loop_count]">[loop_count]:00 PM</option>
            [/loop]
            </select>
            <button type="submit">See This Hour</button>
         </div>
      </body>
   </html>

We got rid of the links and replaced it with a form that will create the POST
HTTP request. The form has a ``<select>`` tag which is setup to allow us to
choose any hour of the day. It uses two ``loop`` statements to automate building
the options for us. There's also a submit button to click after we've selected
the hour we wish to view. This will cause the form to submit its request.

We also changed `web_request->queryParam` to `web_request->postParam` in the top
part of the code since we are now looking for a POST parameter named "hour".

.. note::
   If you want to be able to expect a parameter to be passed as either a POST or
   a query param, then you can use `web_request->param`.


Conclusion
==========

This concludes the Beginner's Guide tutorial. To continue learning about Lasso,
dig into the other parts of this guide, start using Lasso for your own projects,
and consult the `LassoTalk`_ list should you run into problems.

.. _LassoTalk: http://www.lassotalk.com/
