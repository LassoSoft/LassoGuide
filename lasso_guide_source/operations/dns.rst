.. _dns:

***
DNS
***

The Domain Name System (DNS) is an essential part of the Internet infrastructure
which maps people-friendly domain names like "`www.lassosoft.com
<http://www.lassosoft.com/>`_" to machine-friendly IP addresses like
"127.0.0.1". Every URL entered into a Web browser or email address entered into
an email client requires a look up through the DNS system to determine which
actual server to submit the request or route the message to.

DNS servers can handle many different types of requests. Some of the most common
are listed here:

\*
   Returns all available information about the domain name. The results of this
   type are returned in human readable form.

A
   This is the most common type of request and simply returns the IP address
   which corresponds with the domain name.

CNAME
   This is a request for the common name associated with a domain name.

MX
   This is a request for the mail server that is associated with a domain name.
   A prioritized list of mail servers are returned.

NS
   This is a request for the name servers which are responsible for providing
   definitive information about the domain name.

PTR
   This type allows a reverse lookup to be performed which returns the domain
   name associated with an IP address.

TXT
   Domain name servers can store additional information about a domain name.
   Specially formatted domain names are sometimes used as keys which will return
   useful information when queried with this type.

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
the top-level domain which has authorized use of that domain name.

Top-level domains are controlled by an organization which has been designated by
the IANA (Internet Assigned Name Authority). ".com" and ".net" are two common
general purpose top-level domains, ".edu" is a top-level domain reserved for
educational institutions, ".gov" is a top-level domain reserved for U.S.
government institutions, ".org" is a top-level domain reserved for non-profit
organizations.

Each country has its own top level domain defined by its standard two letter
abbreviation. ".us" is the top-level domain for the United States, ".uk" is the
top-level domain for the United Kingdom, ".cn" is the top-level domain for
China. The domain ".to" is actually the country domain for Tonga. Each country
decides how it wants to assign domain names within their own top-level domain.
Some have created virtual top-level domains like ".com.uk", ".org.uk",
".edu.uk", etc.


IPv4 Addresses
==============

IPv4 addresses consist of four numbers from 0 to 255 separated by periods. Each
number represents a single 8 bit integer and the entire IP address represents a
32 bit integer. There are thus effectively about 4 billion IPv4 addresses. A
typical IP address appears as follows:

.. code-block:: none

   127.0.0.1


IPv6 Addresses
==============

In order to expand the range of IP addresses which are available, a new Internet
Protocol has been implemented and is in the process of being adopted. This is
version 6 of the Internet Protocol and is abbreviated IPv6. The most recent
versions of Windows, Mac OS X, and Linux all support IPv6 addresses. The DNS
lookup methods in Lasso do not support IPv6 addresses at this time. IPv6
addresses are essentially 128-bit integers. A typical IPv6 address may appear as
follows:

.. code-block:: none

   fe80:0000:0000:0000:0000:0000:0000:0000


DNS Lookup
==========

.. method:: dns_lookup(\
      name::string, \
      -type= ?, \
      -class= ?, \
      -noRecurse::boolean= ?, \
      -inverse::boolean= ?, \
      -status::boolean= ?, \
      -showQuery::boolean= ?, \
      -formatQuery::boolean= ?, \
      -bitQuery::boolean= ?, \
      -showResponse::boolean= ?, \
      -format::boolean= ?, \
      -bitFormat::boolean= ?, \
      -hostname= ?, \
      -port::integer= ?, \
      -timeout::integer= ?\
   )

   This method is used to query a DNS server for information about a specified
   domain name. It requires one parameter: the domain name being queried. The
   optional parameters are described in the table below. This method will return
   either a string, array, or :type:`dns_response` object.

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
      query will only return information which is known directly by the local
      DNS server.
   :param boolean -inverse:
      Sets the inverse bit in the DNS query.
   :param boolean -status:
      Sets the status bit in the DNS query.
   :param boolean -showQuery:
      If specified the query is not actually performed, but a
      :type:`dns_response` object representing the query is returned.
   :param boolean -formatQuery:
      If specified the query is not actually performed, but a string is returned
      which describes the query that was constructed.
   :param boolean -bitQuery:
      If specified the query is not actually performed, but a string is returned
      which shows the low-level bit representation of the query that was
      constructed.
   :param boolean -showResponse:
      If specified the response is returned as :type:`dns_response` object which
      can be inspected using the member methods described in the documentation
      below.
   :param boolean -format:
      If specified a string is returned which describes the response from the
      DNS server.
   :param boolean -bitFormat:
      If specified a string is returned which shows the low-level bit
      representation of the response from the DNS server.
   :param -hostname:
      The name of a specific DNS server to query. Defaults to the DNS server set
      up in the OS.
   :param integer -port:
      The port of the DNS server to connect to when doing a DNS lookup.
   :param integer -timeout:
      How long to wait for a response when doing a DNS lookup.


IP Lookup Example
-----------------

The following example looks up the associated IP address(es) for a specified
domain name. Using a ``-type`` of "A" will always return an array, even if there
is only one IP address. An empty array will be returned if no information about
the specified domain name can be found::

   dns_lookup('www.lassosoft.com', -type='A')

   // => array(64.34.221.14)


Reverse Lookup Example
----------------------

Reverse lookups which are performed when an IP address is passed to the
``dns_lookup`` method or when the "PTR" type is specified return an array of
domain names. An empty array will be returned if no domain name could be found
for the specified IP address::

   dns_lookup('64.34.221.14')

   // => array(www.lassosoft.com)


MX Records Lookup
-----------------

"MX" lookups return an array of pairs. The first element of each pair is a
priority and the second element of each pair is an IP address. The mail servers
should be used in order of priority to provide fallback if the preferred mail
servers cannot be reached::

   dns_lookup('lassosoft.com', -Type='MX')

   // => array((10 = smtp1.lassosoft.com), (15 = smtp2.lassosoft.com))


Using Different Formats
-----------------------

The following output shows the human readable response to a DNS request::

   dns_lookup('www.lassosoft.com', -format)

   // =>
   // Length: 51
   // ID: 21006
   // Type: Answer
   // Flags: RD, RA
   // Counts: QD 1, AN 1
   // QD 1: www.lassosoft.com.. * IN
   // AN 1: www.lassosoft.com.. A IN 3156 64.34.221.14

The following output shows the low-level bit formatting of a DNS response. The
actual response is fairly long and not shown here::

   dns_lookup('www.lassosoft.com', -bitFormat)

   // => // Long response here // <= //


DNS Response Type
=================

.. type:: dns_response
.. method:: dns_response

   An object of this data type can be returned in response to a
   :type:`dns_lookup` depending on its parameters. The member methods of this
   type are described below.

.. member:: dns_response->format

   Returns a formatted display of the entire response from the DNS server.

.. member:: dns_response->bitFormat

   Returns a formatted display of the raw bits returned by the DNS server.

.. member:: dns_response->answer

   Returns the answer from the DNS server. This differs based on the type.

.. member:: dns_response->data

   Returns the raw byte stream.
