.. _dns:

.. direct from book

***
DNS
***

Lasso provides several tags which allow Domain Name Servers to be queried.

-  `Overview`_ provides an introduction of the DNS system and what types of
   information is available.
-  `DNS Lookup`_ documents the ``[DNS_Lookup]`` tag.

Overview
========

The Domain Name System (DNS) is an essential part of the Internet infrastructure
which maps friendly domain names like `www.lassosoft.com
<http://www.lassosoft.com/>`_ to machine friendly IP addresses like
``127.0.0.1``. Every URL which is entered into a Web browser or email address
which is entered into an email client is first looked up through the DNS system
to determine what actual server to submit the request or route the message to.

DNS servers can handle many different types of requests. Some of the most common
are listed here.

`*`
   Returns all available information about the domain name. The results of this
   type are returned in human readable form.
`A`
   This is the most common type of request and simply returns the IP address
   which corresponds with the domain name.
`CNAME`
   This is a request for the common name associated with a domain name.
`MX`
   This is a request for the mail server that is associated with a domain name.
   A prioritized list of mail servers are returned.
`NS`
   This is a request for the name servers which are responsible for providing
   definitive information about domain name.
`PTR`
   This type allows a reverse lookup to be performed which returns the domain
   name which is associated with an IP address.
`TXT`
   Domain name servers can store additional information about any domain name.
   Specially formatted domain names are sometimes used as keys which will return
   useful information when queried with this type.

Any query can return either a single value or an array of values. For example, a
single domain name may be served by a collection of Web servers. When the A
record for that domain name is looked up a list of servers will be returned. The
DNS server may round-robin the list of servers so a different server is on top
for each request. This effectively spreads traffic among all the servers in the
pool more or less evenly.

Domain Names
------------

Domain names are written as a series of words separated by periods. Reading from
left to right the domain name gets progressively more general. In a typical
three word domain name like `www.lassosoft.com <http://www.lassosoft.com/>`_ the
first word represents a particular machine or a particular service, the second
word represents the domain in which the machine or service resides, and the
third word represents the top-level domain which has authorized use of that
domain name.

Top-level domains are controlled by an organization which has been designated by
the IANA (Internet Assigned Name Authority). ``.com`` and ``.net`` are two
common general purpose top-level domains, ``.edu`` is a top-level domain
reserved for educational institutions, ``.gov`` is a top-level domain reserved
for U.S. government institutions, ``.org`` is a top-level domain reserved for
non-profit organizations.

Each country has its own top level domain defined by its standard two letter
abbreviation. ``.us`` is the top-level domain for the United States, ``.uk`` is
the top-level domain for the United Kingdom, ``.cn`` is the top-level domain for
China. The domain ``.to`` is actually the country domain for Tonga. Each country
decides how it wants to assign domain names within their own top-level domain.
Some have created virtual top-level domains like ``.com.uk``, ``.org.uk``,
``.edu.uk``, etc.

IP Addresses
------------

IP addresses consist of four numbers from 0 to 255 separated by periods. Each
number represents a single 8 bit integer and the entire IP address represents a
32 bit integer. There are thus effectively about 4 billion IP addresses. A
typical IP address appears as follows.

::

   127.0.0.1

IPv6
----

In order to expand the range of IP addresses which are available a new Internet
Protocol has been implemented and is in the process of being adopted. This is
version 6 of the Internet Protocol and is abbreviated IPv6. The most recent
versions of Windows, Mac OS X, and Linux all support IPv6 addresses. The DNS
lookup tags in Lasso do not support IPv6 addresses at this time. IPv6 addresses
are essentially 128-bit integers. A typical IPv6 address may appear as follows.

::

   fe80:0000:0000:0000:0000:0000:0000:0000

DNS Lookup
==========

A DNS server can be queried using the ``[DNS_Lookup]`` tag. The result will be
an array, string, or a ``[DNS_Response]`` data type which can be inspected using
its member tags.

``[DNS_Lookup]``
   This tag is used to query the DNS server for information about a specific
   domain name. The parameters for this tag are described in a following table.

``[DNS_Response]``
   An object of this data type can be returned in response to a ``[DNS_Lookup]``
   depending on its parameters. The member tags of this type are described in a
   following table.


The ``[DNS_Lookup]`` tag is called in order to return information about a domain
name or IP address. The ``[DNS_Response]`` type can be returned as a result of
calling ``[DNS_Lookup]``, but should never need to be called directly.

.. _dns-table-2:

``-Name``
   The domain name to look up or the IP address for a reverse lookup. Required.

``-Type``
   The type of data to look up. Defaults to ``*`` if ``-Name`` is a domain name
   or ``PTR`` if ``-Name`` is an IP address. Possible values include ``*``,
   ``A``, ``NS``, ``MD``, ``MF``, ``CNAME``, ``SOA``, ``MB``, ``MG``, ``MR``,
   ``NULL``, ``WKS``, ``PTR``, ``HINFO``, ``MINFO``, ``MX``, ``TXT``, ``AXFR``,
   ``MAILB``, ``MAILA``.

``-Class``
   The class in which to perform the lookup. Defaults to IN which represents the
   Internet DNS system. Searching other classes is very rare. Possible values
   include ``*``, ``IN``, ``CS``, ``CH``.

``-NoRecurse``
   By default the local DNS server will automatically query other DNS servers to
   find the answer to a request. If this parameter is included then the query
   will only return information which is known directly by the local DNS server.

``-Inverse``
   Sets the inverse bit in the DNS query.

``-Status``
   Sets the status bit in the DNS query.

``-HostName``
   The name of a specific DNS server to query. Defaults to the DNS server set up
   in the OS. Optional.

``-Format``
   If specified a string is returned which describes the response from the DNS
   server.

``-BitFormat``
   If specified a string is returned which shows the low-level bit
   representation of the response from the DNS server.

``-ShowResponse``
   If specified the response is returned as ``[DNS_Response]`` object which can
   be inspected using the member tags described in the table that follows.

``-FormatQuery``
   If specified the query is not actually performed, but a string is returned
   which describes the query that was constructed.

``-BitQuery``
   If specified the query is not actually performed, but a string is returned
   which shows the low-level bit representation of the query that was
   constructed.

``-ShowQuery``
   If specified the query is not actually performed, but a ``[DNS_Response]``
   object representing the query is returned.


The result of the ``[DNS_Lookup]`` tag depends on what type of query was
performed and what parameters were passed to the tag. The following return
values are possible.

-  When called with a domain name, most types will return an array of IP
   addresses which are in the same order as they were reported by the DNS
   server. Note that an array will be returned even if only one IP address was
   reported. An empty array will be returned if information about the specified
   domain name could not be found.

::

   [DNS_Lookup: 'www.lassosoft.com', -type='A'] -> array('216.242.238.28')

-  Reverse lookups which are performed when an IP address is passed to the
   ``[DNS_Lookup]`` tag or when the PTR type is specified return an array of
   domain names. An empty array will be returned if no domain name could be
   found for the specified IP address.

::

   [DNS_Lookup: '216.242.238.28'] -> array('www.lassosoft.com')

-  MX lookups return an array of pairs. The first element of each pair is a
   priority and the second element of each pair is an IP address. The mail
   servers should be used in order of priority to provide fallback if the
   preferred mail servers cannot be reached.

::

   [DNS_Lookup: 'www.lassosoft.com', -Type='MX'] -> array(pair(10='216.242.238.28'))

-  If ``-Format``, ``-BitFormat``, ``-FormatQuery``, or ``-BitQuery`` are
   specified then a string surrounded by HTML ``<pre> ... </pre>`` tags is
   returned. The following output shows the human readable response to a DNS
   request.

::

   [DNS_Lookup: 'www.lassosoft.com', -Format]

::

   ->
   Length: 131
   ID: 146
   Type: Answer
   Flags: RD, RA
   Counts: QD 1, AN 1, NS 2, AR 2
   QD 1: www.lassosoft.com. * *
   AN 1: www.lassosoft.com. CNAME IN 86400 www.lassosoft.com.
   NS 1: lassosoft.com. NS IN 86400 ns2.starmark.com.
   NS 2: lassosoft.com. NS IN 86400 ns1.starmark.com.
   AR 1: ns1.starmark.com. A IN 12418 216.242.238.2
   AR 2: ns2.starmark.com. A IN 12418 216.242.238.3

The following output shows the low-level bit formatting of a DNS response. The
actual response is about 32 lines long.

::

   [DNS_Lookup: 'www.lassosoft.com', -BitFormat]

::

  -->
   00000000 10011110 00000000 10111101 | 0 158 0 189 | |
   10000001 10000000 00000000 00000001 | 129 128 0 1 | |
   00000000 00000001 00000000 00000010 | 0 1 0 2 | |
   00000000 00000010 00000010 00110010 | 0 2 2 50``2``
   00111000 00000011 00110010 00110011 | 56 3 50 51 | 8 2 3 |
   00111000 00000011 00110010 00110100 | 56 3 50 52 | 8 2 4 |
   00110010 00000011 00110010 00110001 | 50 3 50 49 | 2 2 1 |
   00110110 00000111 01101001 01101110 | 54 7 105 110 | 6 i n |
       ...

-  If ``-ShowResponse`` or ``-ShowQuery`` are specified then a
   ``[DNS_Response]`` object is returned. The member tags of ``[DNS_Response]``
   can be used to further interrogate or manipulate the DNS results. Usually,
   this type of interaction is only required when debugging low-level details
   about a DNS response or when implementing additional DNS services.

``[DNS_Response->Format]``
   Returns a formatted display of the entire response from the DNS server.

``[DNS_Response->BitFormat]``
   Returns a formatted display of the raw bits returned by the DNS server.

``[DNS_Response->Answer]``
   Returns the answer from the DNS server. This differs based on the type.

``[DNS_Response->Data]``
   Returns the raw byte stream.
