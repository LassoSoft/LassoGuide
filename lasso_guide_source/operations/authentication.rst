.. _authentication:

**************
Authentication
**************

Lasso Server provides a built-in users and groups system. Initially, this system
is only used to secure access to the Lasso Admin application. It can be used to
provide authentication for your own web apps, however, Lasso is also flexible
enough to support custom security & authentication mechanisms.

Lasso's security system data is stored in a SQLite database located in the
instance's SQLiteDBs directory. Passwords are not stored in plain text, although
other information such as user names and group names are not encrypted.

Within the system, users are grouped into particular realms. Realms completely
separate their users such that the same username/password combination could
exist in two different realms and they would be considered two unique users. A
user only ever belongs to one realm which it is assigned to when the user is
created. When a Lasso Server instance is first initialized, a "Lasso Security"
realm is created. This is the default realm used in all the security-related
methods and types. Alternate realms can be specified when needed.

Users can be grouped together. Each group can contain zero or more users. Users
can belong to multiple groups at the same time. Users from different realms can
belong to the same group. The special group "ANYUSER" always consists of all
users. The special group "ADMINISTRATORS" is used to control who can access the
Lasso Admin application as well as other system-related applications.

The built-in security system is accessed through two different interfaces: the
set of ``auth_*`` methods and the ``security_registry`` object.

Auth
====

The ``auth`` methods are used by web apps to execute simple security checks. The
checks acquire the username, password and realm information from the current web
request and therefore require that a request be active. In all cases, if the
check fails or if no username and password was provided, then the auth methods
will generate a HTTP 401 Unauthorized response with a ``WWW-Authenticate:
Digest`` header. The request is then aborted, by default. If the security checks
succeed, then the methods return nothing. If electing to not abort when the
check fails, a caller can check ``web_response->getStatus`` to determine the
result.

.. method:: auth_admin(-realm::string = 'Lasso Security',
   -noAbort = false,
   -errorResponse = '',
   -noResponse = false)

   This method checks that the current authenticated HTTP client user is in the
   "ADMINISTRATORS" group. An alternate realm can be given and the default abort
   behavior can be altered. By default, a simple "Not authorized" content body
   is generated, which body can be specified with the ``-errorResponse``
   parameter or the body can be left empty by passing ``-noResponse``.

.. method:: auth_user(name::string,
   -realm::string = 'Lasso Security',
   -noAbort = false,
   -errorResponse = '',
   -noResponse = false)

   This method checks that the current authenticated HTTP client user matches
   the given name.

.. method:: auth_group(group::string,
   -realm::string = 'Lasso Security',
   -noAbort = false,
   -errorResponse = '',
   -noResponse = false)

   This method checks that the current authenticated HTTP client user is in the
   specified group.

The ``security_registry`` Object
=================================

The ``security_registry`` object provides a more complete interface to Lasso's
security system. It does not rely on an ongoing web request and can be used
freely once the system is initialized. The ``security_registry`` methods permit
a realm to be specified, but the object otherwise defaults to using the 'Lasso
Security' realm.

Before the security system be be used, it must be initialized by calling the
``security_initialize()`` method. Lasso Server calls this method as it starts up
and so this can be safely ignored by web applications. Command line or other
tools that want to use the security system should call this method as early as
possible when starting up.

A ``security_registry`` object can be created with zero parameters. When
created, it will open a connection to the security database. A
``security_registry`` object must be closed once it is no longer required.

.. class:: security_registry

.. method:: security_registry()

   Creates a new security_registry object.

.. method:: close()

   This method closes the ``security_registry`` object's connection to the
   security information database.

Once created, a security_registry can be used to:

-  Add/remove groups
-  Alter group meta-data (name, enabled)
-  Add/remove users
-  Alter user meta-data (password, comment, enabled)
-  Assign/unassign users to groups
-  Validate username/password/realm combinations

.. method:: addGroup(name::string, 
   enabled::boolean = true,
   comment::string = '')

   This method attempts to add the specified group. A group is by default
   enabled but it can be explicitly disabled. A comment can be provided when the
   group is created and will be stored in the database for reference.

.. method:: getGroupID(name::string)

   This method returns the integer id for the indicated group. This id can be
   passed to subsequent methods to identify the group.

.. method:: listGroups(-name::string)
.. method:: listGroupsByUser(userid::integer)
.. method:: listGroupsByUser(username::string)

   These methods list groups in a variety of ways. The first method will list
   all groups. A ``-name`` parameter can be specified to perform wild card
   searches. The wildcard character is ``%``. The second and third methods
   return a list of group that the indicated user belongs to.

   Each group is represented by a map object containing the following keys: id,
   name, enabled, comment.

.. method:: removeGroup(groupid::integer)
.. method:: removeGroup(name::string)

   These methods will remove the indicated group. All users are disassociated
   from the group.

.. method:: updateGroup(groupid::integer, 
   -name = null,
   -enabled = null,
   -comment = null)

   This method will modify the information for the group. Passing any of the
   ``-name``, ``-enabled`` or ``-comment`` parameters will set the appropriate
   data.

.. method:: addUser(username::string, password::string,
   enabled::boolean = true, 
   comment::string = '',
   -realm = 'Lasso Security')

   This method adds a new user to the system. A username and password must be
   supplied. An optional enabled and comment parameter can be provided. The
   ``-realm`` keyword controls which realm the user is placed in. The default is
   'Lasso Security'. The user's information record is returned. This is a map
   object containing the user's: id, name, enabled, comment, email, real_name
   and realm. Note: the ``email`` and ``real_name`` fields are not utilized at
   this time.

.. method:: addUserToGroup(userid::integer, groupid::integer)

   This method is utilized to add a user to a group. Both user and group must be
   indicated by their integer ids.

.. method:: checkUser(username::string, password::string, -realm::string = 'Lasso Security')

   This method will authenticate the given username and password and will return
   user's record if it succeeds. The return value will be a map containing keys
   for: id, name, enabled, comment, email, real_name and realm. If the check
   fails, this method will return ``void``. The check will fail if the user
   account is not enabled.

.. method:: countUsersByGroup(groupid::integer)

   This method returns the number of users in the indicated group.

.. method:: getUser(userid::integer)
.. method:: getUser(name::string, -realm::string = 'Lasso Security')
.. method:: getUserID(name::string, -realm::string = 'Lasso Security')

   The first two methods return the user record for the indicated user. The
   second method returns the id of the indicated user.

.. method:: listUsers(-name::string = '', -realm = null)
.. method:: listUsersByGroup(name::string)

   These methods list users and return their user records. The first method
   permits a ``-name`` pattern to be specified as well as a realm. Not passing a
   ``-realm`` will result in all realms being searched.

   The second method lists all of the users in the indicated group.

.. method:: removeUser(userid::integer)
.. method:: removeUserFromGroup(userid::integer, groupid::integer)
.. method:: removeUserFromAllGroups(userid::integer)

   These methods can be used to remove a user from the system, remove a user
   from a group, or remove a user from all groups, respectively.

.. method:: userPassword(userid::integer) = password::string
.. method:: userEnabled(userid::integer) = enabled::boolean
.. method:: userComment(userid::integer) = comment::string

   Given a user id, these methods will assign that user's password, enabled
   state or associated comment.
