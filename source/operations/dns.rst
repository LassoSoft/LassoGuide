.. _dns:

***
DNS
***

:abbr:`DNS (Domain Name System)` is an essential part of the Internet's
infrastructure for mapping people-friendly domain names like "www.lassosoft.com"
to machine-friendly IP addresses like "127.0.0.1". Every URL entered into a web
browser or email address entered into an email client requires consulting the
DNS system to determine which server to submit the request or route the message
to.

DNS servers can handle many different types of requests. Some of the most common
are listed here:

\*
   Returns all available information about the domain name. The results of this
   type of request are returned in human-readable form.

A
   This is the most common type of request and simply returns the IP address
   that corresponds with the domain name.

CNAME
   This is a request for the common name associated with a domain name.

MX
   This is a request for the mail server that is associated with a domain name.
   A prioritized list of mail servers are returned.

NS
   This is a request for the name servers responsible for providing definitive
   information about the domain name.

PTR
   This type of request allows a reverse lookup to be performed, returning the
   domain name associated with an IP address.

TXT
   Domain name servers can store additional information about a domain name.
   Specially formatted domain names are sometimes used as keys that will return
   useful information when queried with this option.

Any query can return either a single value or an array of values. For example, a
single domain name may be served by a collection of web servers. When the A
record for that domain name is looked up, a list of servers will be returned.
The DNS server may round-robin the list of servers so a different server is on
top for each request. This effectively spreads traffic among all the servers in
the pool more or less evenly.


Domain Names
============

Domain names are written as a series of words separated by periods. Reading from
left to right the domain name gets progressively more general. In a typical
three word domain name like "www.lassosoft.com" the first word represents a
particular machine or a particular service, the second word represents the
domain in which the machine or service resides, and the third word represents
the top-level domain that has authorized the use of the domain name.

Top-level domains are controlled by an organization that has been designated by
the :abbr:`IANA (Internet Assigned Name Authority)`. Two common, general-purpose
top-level domains are "|dot| com" and "|dot| net", "|dot| edu" is a top-level
domain reserved for educational institutions, "|dot| gov" is a top-level domain
reserved for U.S. government institutions, "|dot| org" is a top-level domain
intended for non-profit organizations.

Each country has its own top-level domain defined by its standard two letter
abbreviation, e.g. "|dot| us" is the top-level domain for the United States,
"|dot| uk" is the top-level domain for the United Kingdom, and "|dot| cn" is the
top-level domain for China. The domain "|dot| tv", frequently used to refer to
television, is actually the country domain for Tuvalu. Each country decides how
it wants to assign domain names within their own top-level domain. Some have
created virtual top-level domains like "|dot| com.uk", "|dot| org.uk", "|dot|
edu.uk", etc.


IP Addresses
============

IPv4 addresses consist of four numbers from 0 to 255 separated by periods. Each
number represents a single 8-bit integer and the entire IP address represents a
32-bit integer, so there are effectively about 4 billion IPv4 addresses. A
typical IPv4 address appears as follows:

.. code-block:: none

   17.149.160.49

In order to expand the range of IP addresses that are available, a new Internet
Protocol has been designed and is in the process of being adopted. This is
version 6 of the Internet Protocol and is abbreviated IPv6. The most recent
versions of Windows, OS X, and Linux all support IPv6 addresses. IPv6 addresses
are essentially 128-bit integers. A typical IPv6 address may appear as follows,
though abbreviated forms also exist:

.. code-block:: none

   2001:0db8:0000:0000:0000:ff00:0042:8329

.. note::
   The DNS lookup methods in Lasso do not support IPv6 addresses at this time.


Querying for DNS Records
========================

DNS queries are performed with the `dns_lookup` method.

.. method:: dns_lookup(name::string, ...)

   This method is used to query a DNS server for information about a specified
   domain name. It requires one parameter, the domain name being queried. The
   optional parameters are described in below. This method will return either a
   string, array, or :type:`dns_response` object.

   :param string name:
      The domain name being queried.
   :param -type:
      The type of data to look up. Defaults to "*" if the name parameter is a
      domain name or "PTR" if it is an IP address. Possible values include "*",
      "A", "NS", "MD", "MF", "CNAME", "SOA", "MB", "MG", "MR", "NULL", "WKS",
      "PTR", "HINFO", "MINFO", "MX", "TXT", "AXFR", "MAILB", "MAILA".
   :param -class:
      The class in which to perform the lookup. Defaults to "IN" which
      represents the Internet DNS system. Searching other classes is very rare.
      Possible values include "*", "IN", "CS", "CH".
   :param boolean -noRecurse:
      By default the local DNS server will automatically query other DNS servers
      to find the answer to a request. If this parameter is included then the
      query will only return information that is known directly by the local DNS
      server.
   :param boolean -inverse:
      Sets the inverse bit in the DNS query.
   :param boolean -status:
      Sets the status bit in the DNS query.
   :param boolean -showQuery:
      If specified the query is not actually performed, but a
      :type:`dns_response` object representing the query is returned.
   :param boolean -formatQuery:
      If specified the query is not actually performed, but a string describing
      the constructed query is returned.
   :param boolean -bitQuery:
      If specified the query is not actually performed, but a string is returned
      that shows the low-level bit representation of the constructed query.
   :param boolean -showResponse:
      If specified the response is returned as :type:`dns_response` object that
      can be inspected using the member methods described in the documentation
      below.
   :param boolean -format:
      If specified a string is returned that describes the response from the
      DNS server.
   :param boolean -bitFormat:
      If specified a string is returned that shows the low-level bit
      representation of the response from the DNS server.
   :param -hostname:
      Allows you to specify the name of a specific DNS server to query. Defaults
      to the DNS server set up in the OS.
   :param integer -port:
      The port of the DNS server to connect to when doing a DNS lookup.
   :param integer -timeout:
      How long to wait for a response when doing a DNS lookup.


IP Lookup
---------

The following example looks up the associated IP address(es) for a specified
domain name. Using a ``-type`` of "A" will always return an array, even if there
is only one IP address. An empty array will be returned if no information about
the specified domain name can be found. ::

   dns_lookup('www.apple.com', -type='A')
   // => array(17.149.160.49, 17.178.96.59, 17.172.224.47)


Reverse Lookup
--------------

Reverse lookups are performed when an IP address is passed to the
`dns_lookup` method, or when the "PTR" type is specified, and return an array of
domain names. An empty array will be returned if no domain name could be found
for the specified IP address. ::

   dns_lookup('23.208.45.15')
   // => array(a23-208-45-15.deploy.static.akamaitechnologies.com)


MX Records Lookup
-----------------

"MX" lookups return an array of pairs. The first element of each pair is a
priority and the second element of each pair is an IP address. The mail servers
should be used in order of priority to provide fallback if the preferred mail
servers cannot be reached. ::

   dns_lookup('lassosoft.com', -type='MX')
   // => array((10 = smtp1.lassosoft.com), (15 = smtp2.lassosoft.com))


Return Different Formats
------------------------

The following output shows the human-readable response to a DNS request::

   dns_lookup('www.apple.com', -format)

   // =>
   // Length: 73
   // ID: 32569
   // Type: Answer
   // Flags: RD, RA
   // Counts: QD 1, AN 1
   // QD 1: www.apple.com.. * IN
   // AN 1: www.apple.com.. CNAME IN 1331 www.isg-apple.com.akadns.net..

The following output shows the low-level bit formatting of a DNS response. The
actual response is fairly long and not shown here::

   dns_lookup('www.lassosoft.com', -bitFormat)

   // =>
   // ASCII
   // 3  T  X
   // ... rest of response ...


DNS Response Helper Type
========================

The :type:`dns_response` type is a helper type which is used to format both DNS
requests and responses. Normally a value of this type will only be returned from
the `dns_lookup` method when ``-showResponse`` is specified. However, this type
can also be used to parse raw DNS requests or responses if necessary.

.. type:: dns_response
.. method:: dns_response(message::bytes)

   Create a new :type:`dns_response` object. An object of this type can be
   returned from the `dns_lookup` method when ``-showResponse`` is specified.

.. member:: dns_response->format()

   Returns a formatted display of the entire response from the DNS server.

.. member:: dns_response->bitFormat()

   Returns a formatted display of the raw bits returned by the DNS server.

.. member:: dns_response->answer()

   Returns an array of answers for most DNS responses. Address lookups or
   reverse lookups will return an array of IP addresses or host names. MX record
   lookups will return an array of pairs, each with a priority and an IP
   address. Other lookups may return an array of strings or other data.

.. member:: dns_response->data()

   Returns the response as a raw byte stream.
