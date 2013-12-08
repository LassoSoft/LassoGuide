.. _authentication:

**************
Authentication
**************

Lasso Server provides a built-in users and groups system. Initially, this system
is only used to secure access to the Lasso Server Admin application. It can be
used to provide authentication for your own web apps; however, Lasso is also
flexible enough to support custom security and authentication mechanisms.

Lasso's security system data is stored in a SQLite database located in the
instance's "SQLiteDBs" directory. Passwords are not stored in plain text, though
other information such as user names and group names are unencrypted.

Within the system, users are grouped into particular realms. A :dfn:`realm`
completely separates its users such that the same username+password combination
could exist in two different realms and they would be considered two unique
users. A user only ever belongs to one realm which it is assigned to when the
user is created. When a Lasso Server instance is first initialized, a "Lasso
Security" realm is created. This is the default realm used in all the
security-related methods and types. Alternate realms can be specified when
needed.

Users can be grouped together. Each :dfn:`group` can contain zero or more users.
Users can belong to multiple groups at the same time. Users from different
realms can belong to the same group. The special group "ANYUSER" always consists
of all users. The special group "ADMINISTRATORS" is used to control who can
access the Lasso Server Admin application as well as other system-related
applications.

The built-in security system is accessed through two different interfaces: the
set of ``auth_…`` methods and the :type:`security_registry` object.


Authenticating Users
====================

Web apps use the ``auth_…`` methods to execute simple security checks. The
checks acquire the username, password, and realm information from the current
web request and, therefore, require that a request be active. In all cases, if
the check fails or if no username and password are provided, then the auth
methods will generate an "HTTP 401 Unauthorized" response with a
:mailheader:`WWW-Authenticate: Digest` header. The request is then aborted, by
default. If the security checks succeed, then the methods return nothing. If
electing not to abort when the check fails, a caller can check
`web_response->getStatus` to determine the result.

.. method:: auth_admin(-realm::string = 'Lasso Security', \
   -noAbort = false, \
   -errorResponse = '', \
   -noResponse = false)

   Checks that the current authenticated HTTP client user is in the
   "ADMINISTRATORS" group. An alternate realm can be given and the default abort
   behavior can be altered. By default, a simple "Not authorized" content body
   is generated; this can be specified with the ``-errorResponse`` parameter or
   the body can be left empty by passing ``-noResponse``.

.. method:: auth_user(name::string, \
   -realm::string = 'Lasso Security', \
   -noAbort = false, \
   -errorResponse = '', \
   -noResponse = false)

   Checks that the current authenticated HTTP client user matches the given
   name.

.. method:: auth_group(group::string, \
   -realm::string = 'Lasso Security', \
   -noAbort = false, \
   -errorResponse = '', \
   -noResponse = false)

   Checks that the current authenticated HTTP client user is in the specified
   group.


Managing Users
==============

The :type:`security_registry` object provides a more complete interface to
Lasso's security system. It does not rely on an ongoing web request and can be
used freely once the system is initialized. The `security_registry` methods
permit a realm to be specified, but the object otherwise defaults to using the
"Lasso Security" realm.

Before the security system can be used, it must be initialized by calling the
`security_initialize` method. Lasso Server calls this method as it starts up and
so this step can be safely skipped by web applications. Command-line or other
tools that want to use the security system should call this method as early as
possible when starting up.

A :type:`security_registry` object can be created with zero parameters. When
created, it will open a connection to the security database. The object must be
closed once it is no longer required.

.. method:: security_initialize()

   Initializes Lasso's ability to connect to the security SQLite database. Lasso
   Server calls this automatically, but you will need to call it if you wish to
   use the :type:`security_registry` type.

.. type:: security_registry
.. method:: security_registry()

   Creates a new :type:`security_registry` object. Once created, it can be used
   to:

   -  Add/remove groups
   -  Alter group metadata (name, enabled)
   -  Add/remove users
   -  Alter user metadata (password, comment, enabled)
   -  Assign/unassign users to groups
   -  Validate username/password/realm combinations

.. member:: security_registry->close()

   Closes the :type:`security_registry` object's connection to the security
   information database.

.. member:: security_registry->addGroup(name::string, \
   enabled::boolean = true, \
   comment::string = '')

   Attempts to add the specified group. A group is enabled by default, but it
   can be explicitly disabled. A comment can be provided when the group is
   created and will be stored in the database for reference.

.. member:: security_registry->getGroupID(name::string)

   Returns the integer ID for the indicated group. This ID can be passed to
   subsequent methods to identify the group.

.. member:: security_registry->listGroups(-name::string)
.. member:: security_registry->listGroupsByUser(userid::integer)
.. member:: security_registry->listGroupsByUser(username::string)

   These methods list groups in a variety of ways. The first method will list
   all groups. A ``-name`` parameter can be specified to perform wildcard
   searches. The wildcard character is "%". The second and third methods return
   a list of groups that the indicated user belongs to.

   Each group is represented by a map object containing the keys 'id', 'name',
   'enabled', and 'comment'.

.. member:: security_registry->removeGroup(groupid::integer)
.. member:: security_registry->removeGroup(name::string)

   These methods will remove the indicated group. All users are disassociated
   from the group.

.. member:: security_registry->updateGroup(groupid::integer, \
   -name = null, \
   -enabled = null, \
   -comment = null)

   Modifies the information for the group. Passing any of the ``-name``,
   ``-enabled`` or ``-comment`` parameters will set the appropriate data.

.. member:: security_registry->addUser(username::string, password::string, \
   enabled::boolean = true, \
   comment::string = '', \
   -realm = 'Lasso Security')

   Adds a new user to the system. A username and password must be supplied. An
   optional ``enabled`` and ``comment`` parameter can be provided. The
   ``-realm`` parameter controls which realm the user is placed in. The default
   realm is "Lasso Security". The user's information record is then returned as
   a map object containing the keys 'id', 'name', 'enabled', 'comment', 'email',
   'real_name' and 'realm'.

   .. note::
      The 'email' and 'real_name' fields are not used at this time.

.. member:: security_registry->addUserToGroup(userid::integer, groupid::integer)

   Adds a user to a group. Both user and group must be indicated by their
   integer IDs.

.. member:: security_registry->checkUser(username::string, password::string, -realm::string = 'Lasso Security')

   Authenticates the given username and password and will return user's record
   if it succeeds. The return value will be a map object containing the keys
   'id', 'name', 'enabled', 'comment', 'email', 'real_name' and 'realm'. If the
   check fails, this method will return "void". The check will fail if the user
   account is not enabled.

.. member:: security_registry->countUsersByGroup(groupid::integer)

   Returns the number of users in the indicated group.

.. member:: security_registry->getUser(userid::integer)
.. member:: security_registry->getUser(name::string, -realm::string = 'Lasso Security')
.. member:: security_registry->getUserID(name::string, -realm::string = 'Lasso Security')

   The first two methods return the user record for the indicated user. The
   second method returns the ID of the indicated user.

.. member:: security_registry->listUsers(-name::string = '', -realm = null)
.. member:: security_registry->listUsersByGroup(name::string)

   These methods list users and return their user records. The first method
   permits a ``-name`` pattern to be specified as well as a realm. Not
   specifying ``-realm`` will result in all realms being searched. The second
   method lists all of the users in the indicated group.

.. member:: security_registry->removeUser(userid::integer)
.. member:: security_registry->removeUserFromGroup(userid::integer, groupid::integer)
.. member:: security_registry->removeUserFromAllGroups(userid::integer)

   These methods can be used to remove a user from the system, remove a user
   from a group, or remove a user from all groups, respectively.

.. member:: security_registry->userPassword=(password::string, userid::integer)
.. member:: security_registry->userEnabled=(enabled::boolean, userid::integer)
.. member:: security_registry->userComment=(comment::string, userid::integer)

   Given a user ID, these setter methods will assign that user's password,
   enabled state, or associated comment, respectively. Call these by specifying
   the user ID as a parameter and the value as an assignment. ::

      security_registry->userComment(1) = "I am the first user!"
