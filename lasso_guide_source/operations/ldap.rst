.. _ldap:

****
LDAP
****

LDAP is an industry-standard method of publishing directory information within
an organization. LDAP servers are used for many different tasks. They can be
used to publish the contact information for employees. They can be used to
publish publicly accessible information. LDAP servers are also used to publish
authentication information so all servers within an organization can use the
same usernames and passwords.

An LDAP server provides access to a directory information tree (DIT). Each
element in the tree is called an entry and has several attributes. Any element
in the tree can be found using its distinguished name (DN). The distinguished
name is like the path to a file in an operating system. For example, the DN of
the record for John Doe in the directory might be "cn=John Doe, ou=People,
o=LassoSoft".

The DN is made up of three parts separated by commas. Each part of the DN is
called a relative distinguished name (RDN) and must be unique for all entries at
that level. The RDN functions much like a primary key and includes one or more
name/value pairs which uniquely identify the element from all of its siblings.

The attributes of each entry make up the data of the entry. Every entry will
have an "objectClass" which tells what kind of entry it is. The remainder of the
attributes will be determined by the type of directory that is being searched,
but may include first name, last name, email address, phone number, etc. The
attributes are often named with one or two character abbreviations like "cn" for
combined name, "ln" for last name, "fn" for first name, or "ou" for operational
unit. Attributes might also have longer names like "email", "telephonenumber",
etc.


LDAP Searches
=============

A search is defined starting at a DN within the directory tree. This DN will
usually be provided by the LDAP server administrator. The scope allows the
search to be limited to the object itself (i.e. is the object contained within
the tree), children of the object, or the entire tree below the object. Some
possible DNs are shown below:

.. code-block:: none

   dc=omnipilot, dc=com
   ou=People, o=LassoSoft

The filter actually defines the search query. It is a series of query terms
(attributes and values) joined by logical operators. The most basic filter
specifies that all objects in the tree should be returned:

.. code-block:: none

   (objectClass=*)

This is actually a special case of the exists filter. This filter returns any
entries which have a defined objectClass. Similarly, all entries which have a
full name attribute "cn" could be found with this filter:

.. code-block:: none

   (cn=*)

A filter can specify an attribute name, operator, and value. Any of the
attributes of the entries in the directory tree can be used in the filter. The
operators include "=" equals, "~=" sounds like, ">=" greater than, and "<=" less
than. The equals operator supports "*" asterisk as a wildcard character allowing
for contains, begins with, and ends with searches. Greater than and less than
operators may only be supported on numeric fields. For example, the following
simple filters would find all entries whose full name started with "John", ended
with "Doe", or were exactly "John Doe":

.. code-block:: none

   (cn=John*)
   (cn=*Doe)
   (cn=John Doe)

Two or more filters can be combined using a logical operator "&" for and, "|"
for or, or a filter can be negated using "!" for not. The following three
filters would find all entries who have a first name of "John" and a last name
of "Doe", a first name of "John" or a last name of "Doe", and a first name which
is not "John" and a last name which is not "Doe":

.. code-block:: none

   (& (cn=John*) (cn=*Doe))
   (| (cn=John*) (cn=*Doe))
   (& (! (cn=John*)) (! (cn=*Doe)))

Note that there are no quotes around the values in the filters. The parentheses
are used to delimit the values. In order to find a value which contains
parentheses "()", an asterisk "*", a backslash "\", or a null character the
following escape sequences can be used. "\\2a" for "(", "\\28" for ")", "\\29"
for "*", "\\5c" for "\\", and "\\00" for null.


LDAP Results
============

The results of an LDAP search will be an array of pairs. The first element of
each pair will be the distinguished name (DN) of the entry. The second element
of each pair will be an array of pairs including the attribute names and values
for the entry. For example, a search which found entries for "John Doe" and
"Jane Doe" might contain the following elements::

   (:
      pair('cn=John Doe, ou=People, o=LassoSoft' = (:
         pair('cn' = 'John Doe'),
         pair('mail'='john@example.com')
      )),
      pair('cn=Jane Doe, ou=People, o=LassoSoft' = (:
         pair('cn' = 'Jane Doe'),
         pair('mail'='jane@example.com')
      ))
   )

LDAP allows the results to be customized in two ways. A list of desired
attributes can be passed with the search. The results will only include those
attributes. A wild card of asterisk "*" specifies that all attributes should be
returned (the default). A wild card of plus sign "+" specifies that only
operational attributes should be returned (these are attributes that are
generally used internally by the LDAP directory). Finally, a flag allows only
attribute names to be returned without any values. By default both attribute
names and values are returned.


LDAP Type
=========

The :type:`ldap` data type can be used to create a connection to an LDAP server and
then to send queries to the server.

.. type:: ldap
.. method:: ldap(...)

   Creates a new `ldap` object. Accepts an optional host name and port to
   immediately open a connection to a server.

.. member:: ldap->open(...)

   Opens a connection to an LDAP server. Requires a host name and optionally a
   port.

.. member:: ldap->authenticate(...)

   Logs into the LDAP server. Requires a username and password.

.. member:: ldap->search(...)

   Performs a search on the remote LDAP server. Requires a parameter specifying
   the base of the query. Additional parameters specify the scope, filter,
   attributes, and attributes-only option for the query. See the following list
   for details about these parameters. Returns no value.

   :param base:
      The distinguished name (DN) of the entry at which to start the search.
      Required.
   :param scope:
      The scope of the search. Optional. This parameter should be one of the
      following values:

      -  ``ldap_scope_base`` - Search the object itself.
      -  ``ldap_scope_onelevel`` - Search the object's immediate children.
      -  ``ldap_scope_subtree`` - Search the object and all its descendants.

   :param filter:
      The filter to apply to the search. Optional.
   :param attributes:
      An array of strings specifying the attribute types to return in the search
      results. Optional.

      -  "*" (asterisk) may be specified in the array to indicate that all
         attributes are to be returned.
      -  "+" (plus sign) may be specified in the array to indicate that all
         operational attributes should be returned.
      -  "1.1" may be specified in the array to indicate that no attributes
         should be returned.

   :param attribute-only:
      A boolean indicating that only attributes and no values should be
      returned. Defaults to "False". Optional.

.. member:: ldap->results()

   Returns results from the last search operation as an array containing a
   series of nested array and pair values. Each element in the top level array
   is a pair representing an entry found in the search. The first element of the
   pair is the distinguished name (DN) of the found entry. The second element of
   the pair is an array of pairs containing the entry s attribute names and
   values.

.. member:: ldap->referrals()

   Returns an array of referral strings if any are generated by the server.

.. member:: ldap->code()

   Returns the code generated by the previous operation. A code of "0" means
   success. The most common codes are included in a chart below.

.. member:: ldap->close(...)

   Closes the connection to the LDAP server.

For example, the following code performs an LDAP query against a server
"ldap.example.com". The base of the query is "dc=example,dc=com". The scope is
``ldap_scope_subtree`` indicating that the object and all of its descendants
should be searched. The filter is "(objectClass=*)" indicating that all object
classes are to be returned. The filter is "*" indicating that all attributes are
to be returned. And, attribute-only is set to "False" indicating that both
attributes and values should be returned. After each line is executed the return
code is checked to make sure that it is "0" indicating success. If the result
code is greater than "0" then an error is reported::

   local(my_ldap) = ldap

   #my_ldap->open('ldap.example.com')
   fail_if(#my_ldap->code != 0, #my_ldap->code, 'LDAP Error ' + #my_ldap->code)

   #my_ldap->authenticate('myusername', 'mysecretpassword')
   fail_if(#my_ldap->code != 0, #my_ldap->code, 'LDAP Error ' + #my_ldap->code)

   #my_ldap->search('dc=example,dc=com', ldap_scope_subtree, '(objectClass=*)')
   fail_if(#my_ldap->code != 0, #my_ldap->code, 'LDAP Error ' + #my_ldap->code)

   local(my_result) = #my_ldap->results

   #my_ldap->close

The results of this operation will be a staticarray of pairs. The first element
of each pair is the distinguished name (DN) of the entry. The second element of
each pair is a pair staticarray containing the names and attributes of the
element.

.. table:: Common LDAP Status Codes

   ==== =================================
   Code Description
   ==== =================================
   0    Success (No Error)
   1    Operations Error
   2    Protocol Error
   3    Time Limit Exceeded
   4    Size Limit Exceeded
   5    Compare False
   6    Compare True
   7    Auth Method Not Supported
   8    Strong Auth Required
   10   Referral
   11   Admin Limit Exceeded
   12   Unavailable Critical Extension
   13   Confidentiality Required
   14   SASL Bind In Progress
   16   No Such Attribute
   17   Undefined Attribute Type
   18   Inappropriate Matching
   19   Constraint Violation
   20   Attribute Or Value Exists
   21   Invalid Attribute Syntax
   32   No Such Object
   33   Alias Problem
   34   Invalid DN Syntax
   36   Alias Dereferencing Problem
   48   Inappropriate Authentication
   49   Invalid Credentials
   50   Insufficient Access Rights
   51   Busy
   52   Unavailable
   53   Unwilling To Perform
   54   Loop Detect
   64   Naming Violation
   65   Object Class Violation
   66   Not Allowed On Non-Leaf
   67   Not Allowed On RDN
   68   Entry Already Exists
   69   Object Class Mods Prohibited
   71   Affects Multiple DSAs
   80   Other
   ==== =================================
