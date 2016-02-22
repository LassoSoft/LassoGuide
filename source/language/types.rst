.. http://www.lassosoft.com/Language-Guide-Defining-Types
.. _types:

*****
Types
*****

Types are the fundamental data abstraction concept in Lasso. Since Lasso is an
object-oriented language, every piece of data is an object and every object is
of a particular type. A :dfn:`type` is a predefined layout of data combined with
a particular set of methods. Types provide a means for encapsulating data with
the collection of methods designed to modify :dfn:`objects` representing that
data in predetermined ways.


Defining Types
==============

.. index:: define keyword

Before a type can be used, it must first be defined. Defining a type is done
in the same manner as other entities (traits, methods). The word ``define`` is
used, followed by the name for the type, the association operator (``=>``), and
a type expression that provides the description of the type's methods and data
members. ::

   define typeName => type expression


Type Expressions
----------------

A :dfn:`type expression` consists of the word ``type`` followed by a set of
curly braces (``{ ... }``). Between those curly braces reside a series of
sections; each describing a different aspect of the type. These sections
include: "parent"; "data"; "trait"; and "public", "protected", and "private"
member methods. Each section begins with one of those words and ends at the
beginning of the next section or the end of the type expression (which would be
a close curly brace). Each section is optional. Sections can occur in any order.
The sections "trait" and "parent" can occur only once.

The most simple type definition is shown below. It defines a type named "person"
and contains no sections. Therefore, the ``person`` type contains no methods or
data members of its own. It is a completely valid, if somewhat useless, type. ::

   define person => type { }


Data Members
------------

.. index:: data keyword

Each data section defines one or more :dfn:`data members` for the type, which
are other objects contained by the type. In a data member section, the word
``data`` is followed by one or more data member names. Data member names follow
the same rules as variable and method names. They can begin with an underscore
or the characters A--Z and then can be followed by zero or more underscores,
letters, numbers, or period characters. Character case is irrelevant for data
member names.

Like variables, data members store values. Three values are unique to each
instance of the type. If a person type was created then it could contain data
members for the first and last name of the person, his/her birthdate, social
security number, address, etc. Just as every individual has his own values for
these items, so would every instantiated object.

The following example type implementation shows several different methods for
defining data members. These methods can be mixed and matched in a single type
to provide the best readability. Data sections can also be interspersed with the
other sections in the type expression if necessary. ::

   define person => type {
      data firstName, lastName
      data age
      data
         birthdate
      data ssn
      data address1, address2, city,
         state, zip, country
   }


Type Constraints
^^^^^^^^^^^^^^^^

.. index:: tag literal

Data member values can be constrained to hold only particular types of objects.
To do this, follow the data member name with two colons (``::``) and then a type
or trait name. When a data member is constrained, it cannot be assigned any
value that does not fit the constraint. The following type constrains
"firstName" and "lastName" to be string objects and "age" to be an integer
value::

   define person => type {
      data firstName::string, lastName::string
      data age::integer
   }


Default Values
^^^^^^^^^^^^^^

Data members can be given default values. When a type instance is first created,
before it can be otherwise used, its data members are assigned their default
values. A default value can be any single expression. The following type
definition uses both type constraints and default values for "firstName" and
"lastName", but just a default value for "age"::

   define person => type {
      data firstName::string = '', lastName::string = ''
      data age = 0
   }


Accessing Data Members
^^^^^^^^^^^^^^^^^^^^^^

.. index:: self keyword

Data members can be accessed from within the methods of a type by targeting the
current type instance using the keyword ``self`` and the target operator
(``->``) followed by the name of the data member between single quotes. The
following expression would set the value of the data member "age" to "36"::

   self->'age' = 36

The following expression produces the value of the "age" data member::

   self->'age'
   // => 36

Equivalently, Lasso supports a shortcut syntax for targeting "self" by using a
single period. The examples above could be rewritten using a period in place of
``self->``. ::

   .'age' = 36

   .'age'
   // => 36

All of the data members in a type are private. This means that a data member can
*only* be directly accessed using either of the above syntaxes; only when
"self" is the target object. Optionally, data members can be exposed to the
outside world. The following section describes how getters and setters can be
used to access data member values from outside of the owning type.


.. _types-getters-setters:

Getters and Setters
-------------------

A :dfn:`getter` is a member method that produces the value of a data member,
while a :dfn:`setter` is a member method that permits the value of a data member
to be assigned. If the value of a data member should be accessible from outside
of the owning type, then it is necessary to create a getter and/or a setter
method for that data member.

If the word ``public``, ``protected``, or ``private`` is given in front of a
data member name, Lasso will automatically create a getter method and a setter
method with the appropriate access level as described in the section on
:ref:`member methods <types-member-methods>`. The following code defines three
publicly accessible data members::

   define person => type {
      data public firstName, public lastName
      data public age::integer=0
   }

The automatically created getter method has the same name as the data member.
Parentheses are optional after the getter (as they are with all methods
accepting zero parameters). The current value for the data member can be
returned as follows::

   #person->firstName
   // => // Produces the value stored in the "firstName" data member

   #person->lastName()
   // => // Produces the value stored in the "lastName" data member

The automatically created setter permits the assignment (``=``) or the
assign-produce (``:=``) operators to assign a new value to the data member. As
with the getter, parentheses are optional. ::

   // Sets "firstName" to a new value
   #person->firstName = 'John'

   // Sets "lastName" to a new value
   #person->lastName() := 'Doe'
   // => Doe

Exposing a data member in this manner always creates both the getter and setter.
However, getters and setters can also be added manually without automatically
exposing both get and set behaviors. One hypothetical use for this is a type
that wants to provide to the outside world read-only access to one of its data
members. Additionally, a getter or a setter can be added manually in order to
override or replace the automatically provided behavior; perhaps to validate
the values in a particular manner.

The following example defines a ``person`` type that manually exposes its
"firstName" data member by defining two member methods, one for the getter and
another for the setter. See the section on :ref:`member methods
<types-member-methods>` for more information on creating member methods. ::

   define person => type {

      // The firstName data member
      data firstName

      // The firstName getter
      public firstName() => {
         return .'firstName'
      }

      // The firstName setter
      public firstName=(value) => {
         .'firstName' = #value
      }
   }

The type definition above would operate identically if it instead omitted the
manual getter and setter methods and made its "firstName" data member public.

Implementing getter and setter methods for a data member allows :ref:`assignment
operators <operators-arithmetical>` to be used with it. For example, since the
``+``, ``-``, and ``*`` operators are implemented for the string type (see the
section on :ref:`types-overloading` below), they can be used to modify the
"firstName" data member::

   local(someone = person)
   #someone->firstName = "Bob"
   #someone->firstName += "by"   // Bobby
   #someone->firstName -= "y"    // Bobb
   #someone->firstName *= 2      // BobbBobb

Setters can be defined to accept more than one parameter. When called, the
additional parameters are given in the method call's parentheses, just as with a
regular method. When defining such a setter method, the first parameter is
always the new value for the assignent. All additional parameters follow. For
example, with a "firstName" setter that includes an optional nickname::

      public firstName=(value, nick) => {
         .'firstName' = `"` + #nick + `" ` + #value
      }

it would be called like this::

   #someone->firstName("Big Wheels") = "Bob"    // "Big Wheels" Bob

For another multi-parameter setter example, see `security_registry->userComment=`.

Within a manual getter or setter, it is vital to refer to the data member using
the single-quoted name syntax. Otherwise, an infinite recursion situation may
arise as the getter/setter continually re-calls itself.


.. _types-member-methods:

Member Methods
--------------

.. index:: public keyword, private keyword, protected keyword

A :dfn:`member method` is a method that belongs to a particular type, as opposed
to an :dfn:`unbound method` which does not, thus acting as a standalone
function. A member method can operate on the data members of its owning type in
addition to any parameters the method may receive.

Member methods are created in sections of a type expression beginning with the
word ``public``, ``private``, or ``protected``, followed by a method signature,
the association operator (``=>``), and the implementation of the method. Each
section can define one or more methods separated by commas. The choice of word
used to begin a member methods section influences how the methods are permitted
to be accessed. There are three such access levels.

public
   Public member methods can be called without any restrictions. They represent
   the public interface of the type. When the type is documented for others to
   use, only the public methods are described.

private
   Private member methods can only be called from methods defined within the
   owning type. Private methods are to be used for low-level implementation
   details that shouldn't be exposed to the end user or to inheriting types.

protected
   Protected member methods can be called from within the owning type
   implementation or any type that inherits from that type. Protected methods
   represent functionality that is not intended to be exposed to the public, but
   which may be overridden, modified, or used from within types inheriting from
   the owning type.

The following type expression defines three data members and three member
methods. The method ``describe`` returns a description of the person and is
intended to be called by users of the type. The methods ``describeName`` and
``describeAge`` are private and protected methods, not intended to be used by
the outside world. ::

   define person => type {
      data
         public firstName,
         public lastName,
         public age

      public describe() => {
         return .describeName + ', ' + .describeAge
      }
      private describeName() => .firstName + ' ' + .lastName
      protected describeAge() => 'age ' + .age
   }

Given the definition above, the following example illustrates valid and invalid
use of a ``person`` object::

   local(p) = person

   #p->describe
   // =>  , age

   #p->describeAge
   // => // FAILURE: access not permitted

The second usage fails because the ``describeAge`` method is protected. A type
that inherits from person can access ``describeAge``, but it cannot access
``describeName`` because that method is marked as private.


Inheritance
-----------

Every type inherits from one or more parent types. To :dfn:`inherit` from
another type means that every instance of the type will automatically possess
all of the data members and methods of the parent type, plus those defined in
the type expression itself. The concept of inheritance is used to build more
complex types out of more generalized types.

A more general type may have several different more specific types inheriting
from it as it provides a basic set of functionality that each inheriting type
will also possess. Lasso only supports single-inheritance, that is, each type
has only one immediate parent and that parent has only one immediate parent. All
types can eventually trace down to a :type:`null` parent. If a parent is not
explicitly specified when a type is defined then the parent of the type is
:type:`null`.

All of the public or protected member methods belonging to a parent type will be
made available to the types that inherit from it. Any method defined in a parent
type that conflicts with those of an inheriting type will be replaced by the
inheriting type's method. This permits inheriting types to override or replace
functionality provided by a parent.


Parent Section
^^^^^^^^^^^^^^

.. index:: parent keyword

The :dfn:`parent` section names the parent that the type being defined is to
inherit from. For example, the ``person`` type can inherit from the ``entity``
type by naming it in its parent section. Each person object that gets created
will then possess all of the data members and methods found in the ``entity``
type, whatever those might be. ::

   define person => type {
      parent entity
   }

Only one parent type can be listed. The parent section can appear only once in a
type expression. While you can place it anywhere in the type expression, it is
recommended that you place it at the top.

The following code defines two simple types: ``one`` and ``two``. Type ``two``
inherits from type ``one``. Notice that the ``second`` method is overridden by
the second type, but the ``first`` method is not. ::

   define one => type {
      public first() => 'alpha'
      public second() => 'beta'
   }

   define two => type {
      parent one
      public second() => 'gamma'
   }

When the ``first`` method of a ``two`` object is called, the value "alpha" is
returned since it is automatically calling the method from the parent type. The
``second`` method returns "gamma" since it is calling the overridden method from
type ``two``. ::

   two->first
   // => alpha

   two->second
   // => gamma


Accessing Inherited Methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. index:: inherited keyword

Sometimes it is necessary to call "down" to an inherited method. A method
inherited from an ancestor (any of the parents down the chain to :type:`null`)
can be accessed by using the ``inherited`` keyword followed by the target
operator (``->``) followed by the method call (name and any parameters).

In the following example, the method ``third`` is defined to call the inherited
method ``second``. The method from type ``two`` will be bypassed in favor of the
corresponding method from type ``one``. ::

   define one => type {
      public first() => 'alpha'
      public second() => 'beta'
   }

   define two => type {
      parent one
      public second() => 'gamma'
      public third() => inherited->second
   }

   two->third
   // => beta

Equivalently, Lasso supports a shortcut syntax for targeting "inherited" by
using two periods, which can be used to access the methods of a parent type. The
example above can be rewritten using ``..`` in place of ``inherited->``. ::

   define two => type {
      parent one
      public second() => 'gamma'
      public third() => ..second
   }


Trait Section
^^^^^^^^^^^^^

Every type has a single trait which may be composed of other subtraits. A type
inherits all of the methods that its trait defines, provided that the type
implements the requirements for the trait. For example, a type must be
serializable for it to be stored in a session, which means importing the
:trait:`trait_serializable` trait. See the :ref:`traits` chapter for a
complete description of how traits are created.

The trait section of a type expression can import one or more other traits.
These traits are combined to form the trait for the type. The following code
shows a type definition that imports the :trait:`trait_array` and
:trait:`trait_map` traits::

   define mytype => type {
      trait {
         import trait_array, trait_map
      }
   }

A trait section can appear anywhere within a type expression, but can appear
only once.


Type Creators
-------------

A :dfn:`type creator` is a method that returns a new instance of a type. For
example, calling the method named `string` produces a new string object. By
default each type has a creator method that corresponds to the name of the type
and requires no parameters.

The example type ``person`` would automatically have a creator method ``person``
that returns a new instance of the type. ::

   // Assigns a new person object to #myperson
   local(myperson) = person()

If a type does not define its own creator method(s), then it is provided with a
default zero-parameter type creator. Attempting to provide parameters to a type
creator that does not accept any parameters will fail. ::

   local(myperson) = person(264)
   // => // FAILURE: person() accepts no parameters


.. _types-oncreate:

onCreate
^^^^^^^^

.. index:: onCreate callback

Many types allow one or more parameters to be provided when a new object is
created in order to customize the object before it is used. A type can specify
its own type creators by defining one or more methods named ``onCreate``. When a
new object is created, the ``onCreate`` method corresponding to the given
parameters is immediately called before the new object is returned to the user.
Each ``onCreate`` must be a public member method.

To illustrate, the following type definition defines an ``onCreate`` method that
requires three parameters: "firstName", "lastName", and "birthdate". These
parameters correspond to the data members of the type and allow them to be set
when the object is first created. The creator simply assigns the parameter
values to the data members. ::

   define person => type {
      data firstName::string, lastName::string
      data birthdate::date

      public onCreate(firstName::string, lastName::string, birthdate::date) => {
         .'firstName' = #firstName
         .'lastName' = #lastName
         .'birthdate' = #birthdate
      }
   }

To create an instance of this type, the creator must be called with the required
parameters. The following code will create a new instance of the ``person``
type::

   local(myperson) = person('Cathy', 'Cunningham', date('1/1/1974'))

Note that when a creator has been specified, the default creator, which requires
no parameters, is not automatically provided. Lasso will not supply a default
type creator when the author has included their own. Also note that if a type
overrides its parent's creator, it needs to include a call to the parent's
creator method, passing on any arguments as required. ::

   public onCreate(...) => ..onCreate(:#rest)

Many type creators can be defined by specifying multiple ``onCreate`` methods.
The following type defines three type creators. The first permits ``person``
objects to be created with no parameters; the second, with first and last names;
and the third, with first and last names and a birthdate. ::

   define person => type {
      data firstName::string, lastName::string
      data birthdate::date

      public onCreate() => {}
      public onCreate(firstName, lastName) => {
         .'firstName' = string(#firstName)
         .'lastName' = string(#lastName)
      }
      public onCreate(
               firstName::string,
               lastName::string,
               birthdate::date) => {
         .'firstName' = #firstName
         .'lastName' = #lastName
         .'birthdate' = #birthdate
      }
   }


Callback Methods
----------------

In addition to the ``onCreate`` method, Lasso reserves a number of other method
names as callbacks which are automatically used in different situations. Lasso
provides default behavior so all callbacks are optional, but by defining a
callback a type can customize its behavior.


asString
^^^^^^^^

.. index:: asString callback

The ``asString`` method is called when an object is expressed as a string. By
default, a type instance will simply output the name of the object's type.
Overriding this method allows a type to control how it is output. The following
code defines a simple type that outputs a greeting when its ``asString`` method
is called::

   define mytype => type {
      public asString() => 'Hello World!'
   }

   mytype
   // => Hello World!


.. _types-oncompare:

onCompare
^^^^^^^^^

.. index:: onCompare callback

The ``onCompare`` method is called whenever an object is compared against
another object. This includes when the equality (``==``), and inequality
(``!=``) operators are used and when objects are compared for ordinality using
any of the relative equality operators (``<``, ``<=``, ``>``, ``>=``).

An ``onCompare`` method must accept one parameter and must return an integer
value. ::

   public onCompare(rhs)::integer

If the parameter is equal to the current type instance then a value of "0"
should be returned. If the current type instance is less than the parameter then
an integer less than zero should be returned (e.g. "-1"). If the current type
instance is greater than the parameter then an integer greater than zero should
be returned (e.g. "1").

For example, the following ``person`` type has an ``onCompare`` method that
gives ``person`` objects the ability to compare themselves with each other::

   define person => type {
      data public firstName::string,
            public lastName::string

      public onCompare(other::person) => {
         .firstName != #other->firstName ?
            return .firstName < #other->firstName ? -1 | 1
         .lastName != #other->lastName ?
            return .lastName < #other->lastName ? -1 | 1
         return 0
      }

      public onCreate(firstName::string, lastName::string) => {
         .firstName = string(#firstName)
         .lastName = string(#lastName)
      }
   }

Given the above type definition, the following examples use the
``onCompare`` method behind the scenes to provide the ability to compare
persons::

   person('Bob', 'Barker') == person('Bob', 'Barker')
   // => true

   person('Bob', 'Barker') == person('Bob', 'Parker')
   // => false

Multiple ``onCompare`` methods can be provided, each specialized to compare
against particular object types. For example, an ``integer`` type would want to
permit itself to be compared against other integer objects, but it should also
want to be comparable to decimal objects. Such an ``integer`` type would have
one ``onCompare`` method for integer objects and another for decimal objects.
This example also shows how the ``onCompare`` method can be manually called on
objects. In this case, the "value" data member is responsible for doing the
actual comparisons, so its ``onCompare`` method is called and the value
returned. ::

   define myint => type {
      data private value

      public onCompare(i::integer) => .value->onCompare(#i)
      public onCompare(d::decimal) => .value->onCompare(integer(#d))
   }


.. _types-contains:

contains
^^^^^^^^

.. index:: contains callback

The ``contains`` method is called whenever an object is compared using the
contains (``>>``) or not contains (``!>>``) operators. A ``contains`` method
definition should accept one parameter and must return a boolean value, either
"true" or "false". ::

   public contains(rhs)::boolean

If the parameter is contained within the current type instance (using whatever
logic makes sense for the type) then a value of "true" should be returned;
otherwise, a value of "false" should be returned.

For example, the type ``odds`` below overrides the contains operators so that
``odds >> 3`` will return "true" and ``odds >> 4`` will return "false". ::

   define odds => type {
      public contains(rhs::integer)::boolean => {
         return #rhs % 2 == 1
      }
   }

Other types that implement their own ``contains`` methods include :type:`array`
and :type:`map`, which search their contained objects for a match before
returning "true" or "false".


.. _types-invoke:

invoke
^^^^^^

.. index:: invoke callback

The ``invoke`` method is called whenever an object is invoked by applying
parentheses to it. By default, invoking an object produces a copy of the invoked
object. However, objects can add their own ``invoke`` methods to alter this
behavior. The following code shows how an instance of the ``person`` type might
be invoked::

   define person => type {
      data
         public firstName::string,
         public lastName::string

      public invoke() => .firstName + ' ' + .lastName + ' was invoked!'
      public onCreate(firstName::string, lastName::string) => {
         .firstName = string(#firstName)
         .lastName = string(#lastName)
      }
   }

The following shows how a ``person`` object would be invoked, by either directly
calling the ``invoke`` method or by applying parentheses::

   local(per) = person('Bob', 'Parker')

   #per()
   // => Bob Parker was invoked!

   #per->invoke
   // => Bob Parker was invoked!


\_unknowntag
^^^^^^^^^^^^

.. index:: _unknowntag callback

Implementing the ``_unknowntag`` method allows a type to handle requests for
methods that it does not have. When a search for a member method fails, the
system will call the ``_unknowntag`` method if it is defined. The originally
sought method name is available by calling ``method_name``.

The following example creates a type whose only member method is
``_unknowntag``, which returns the name of the called method::

   define echo_method => type {
      public _unknowntag => method_name->asString
   }

   echo_method->rhino
   // => rhino


.. _types-overloading:

Operator Overloading
--------------------

Types can provide their own routines to be called when the standard arithmetical
operators (``+ - * / %``) are used with an instance of the type on the left-hand
side of the expression.

If the standard operators are overloaded they should be mapped as closely as
possible to the standard arithmetical meanings of the operators. For example,
the addition operator (``+``) is also used for string concatenation.


Overloading Arithmetical Operators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An arithmetical operator is overloaded by defining a member method whose name is
the same as the operator symbol. The method must accept one parameter and return
an appropriate value. The type instance should not be modified by these
operations. ::

   public +(rhs)
   public -(rhs)
   public *(rhs)
   public /(rhs)
   public %(rhs)

The following example provides a full set of arithmetical operators for the
``myint`` type::

   define myint => type {
      data private value

      public onCreate(value = 0) => { .value = #value }
      public asString() => string(.value)
      public +(rhs::integer) => myint(.value + #rhs)
      public -(rhs::integer) => myint(.value - #rhs)
      public *(rhs::integer) => myint(.value * #rhs)
      public /(rhs::integer) => myint(.value / #rhs)
      public %(rhs::integer) => myint(.value % #rhs)
   }

   myint(9) + 5 * 40
   // => 209


Overloading Equality Operators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

See the section on the :ref:`onCompare method <types-oncompare>` for information
about how to overload the equality operators (``==``, ``!=``, ``<``, ``<=``,
``>``, ``>=``, ``===``, ``!==``).


Overloading Containment Operators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

See the section on the :ref:`contains method <types-contains>` for information
about how to overload the containment operators (``>>``, ``!>>``).


Modifying Types
===============

Lasso permits types to have methods added to them outside of the original
defining type expression. This is done by defining the method using the word
``define`` followed by the name of the type, the target operator (``->``), and
then the rest of the method signature and body. The following example adds the
method ``speak`` to the ``person`` type::

   define person->speak() => 'Hello, world!'


Type/Object Introspection Methods
=================================

Lasso provides a number of methods that can be used to gain information about a
type or object. These methods are summarized below.

.. type:: null

.. member:: null->type()

   Returns the type name for any type instance. The value is the name that was
   used when the type was defined.

.. member:: null->isA(name::tag)

   Checks whether an object is of the given type. The method will return "1" if
   the type specified by the ``name`` parameter matches the type of the
   instance, or "2" if the trait specified by ``name`` is implemented by the
   type of the instance. The method call `null->isA(::null)` will only return
   "1" for the :type:`null` type instance itself.

.. member:: null->isNotA(name::tag)

   The opposite of `null->isA`.

.. member:: null->listMethods()

   Returns a staticarray of :type:`signature` objects for all of the methods
   that are available for the type.

.. member:: null->hasMethod(name::tag)

   Returns "true" if the type implements a method with the given name.

.. member:: null->parent()

   Returns the name of the parent of the target object. If the method returns
   "null" then the final parent has been reached.

.. member:: null->trait()

   Returns the trait for the target object. Returns "null" if the object does
   not have a trait.

   .. seealso::
      `~null->setTrait` and `~null->addTrait` in the :ref:`traits` chapter
