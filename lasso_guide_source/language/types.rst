.. _types:
.. http://www.lassosoft.com/Language-Guide-Defining-Types

*****
Types
*****

This chapter provides details about how new data types are defined and
used in Lasso 9. Topics include type definitions, member methods, data
members, getters and setters, callbacks, implementable operators,
inheritance and traits.

-  `Introduction`_ introduces "types"
-  `Defining Types`_ describes how new types are created and details
   the format of a type expression
-  `Introspection`_
-  `Modifying Types`_

Introduction
============

Types are the fundamental data abstraction concept in Lasso 9. Lasso is
an object-oriented language, and every piece of data is an object and
every object is of a particular type. A type is a particular layout of
data combined with a particular set of methods. Types provide a means
for encapsulating data with the collection of methods designed to modify
that data in predetermined ways.

Defining Types
==============

Before a type can be utilized, it must first be defined. Defining a type
is done in the same manner as other entities (traits, methods). The word
``define`` is used, followed by the name for the type, the association
operator ``=>``, and a type expression which provides the description of the
type's methods and data members.

::

   define typeName => type expression

Type Expressions
----------------

A type expression consists of the word type followed by a set of curly
braces ``{ ... }``. Within those curly braces reside a series of sections
each describing a different aspect of the type. These sections include:
**parent**, **data**, **trait**, and **public**, **protected** and
**private** methods. Each section begins with one of those words and
ends at the beginning of the next section or the end of the type
expression (which would be a close curly ``}`` ). Each section is optional.
Sections can occur in any order. The sections *trait* and *parent* can
occur only once.

The most simple type definition is shown below. It defines a type named
person and contains no sections, thus, the person type contains no
methods or data members of its own, but it is a completely valid type.

::

   define person => type { }

Data Members
------------

Each data section defines one or more data members for the type. Data
members are other objects contained by the type. In a data member
section, the word data is followed by one or more data member names.
Data member names follow the same rules as variable and method names.
They can begin with an underscore or the characters A-Z and then can be
followed by zero or more underscores, letters, numbers or period
characters. Character case is irrelevant for data member names.

A data member is a variable which is unique to each instance of the
type. If a person type was created then it could contain data members
for the first and last name of the person, their birthdate, social
security number, address, etc. Every individual has their own values.

The following example type implementation shows several different
methods for defining data members. These methods can be mixed and
matched in a single type to provide the best readability. Data sections
can also be interspersed with the other sections in the type expression
if necessary.

::

   define person => type {
     data firstName, lastName
     data age
     data birthdate
     data ssn
     data address1, address2, city,
         state, zip, country
   }

Type Constraints
^^^^^^^^^^^^^^^^

Data member values can be constrained to hold only particular types of
objects. The data member name is followed by two colons ``::`` and then a
type or trait name. When a data member is constrained, it cannot be
assigned any value which does not fit the constraint. The following type
constrains firstName and lastName to be strings and the age to be an
integer value.

::

   define person => type {
     data firstName::string, lastName::string
     data age::integer
   }

Data members can be given default values. When a type instance is first
created, before it can be otherwise used, its data members are assigned
their default values. A default value can be any single expression. The
following type definition uses both type constraints and default values
for firstName and lastName, but just a default value for age.

::

   define person => type {
     data firstName::string = '', lastName::string = ''
     data age = 0
   }

Accessing Data Members
^^^^^^^^^^^^^^^^^^^^^^

Data members can be accessed from within the methods of a type using a
period . and then name of the data member within single quotes. The
following expression would set the value of the data member age to 36.

::

   .'age' = 36

The following expression produces the value of the age data member.

::

   .'age'
   // => 36

Equivalently, the word self refers to the current type instance. The
examples above could be rewritten using self in place of the period .
operator.

::

   self->'age' = 36
   self->'age'
   // => 36

All of the data members in a type are private. This means that a data
member can **only** be directly accessed using either of the above
syntaxes; only when "self" is the target object. Optionally, data
members can be exposed to the outside world. The following section
describes how getters and setters can be used to access data member
values from outside of the owning type.

Getters and Setters
-------------------

A **getter** is a member method which produces the value of a data
member and a **setter** is a member method which permits the value of a
data member to be assigned. If the value of a data member should be
accessible from outside of the owning type then it is necessary to
create a getter and/or a setter for that data member. Doing so permits a
data member to be accessed by name, but without the surrounding
quotation marks.

Lasso will automatically create a getter and setter if the word
**public**, **protected** or **private** is given in front of the data
member name. The following code defines three publicly accessible data
members.

::

   define person => type {
     data public firstName, public lastName
     data public age::integer=0
   }

The automatically created getter method has the same name as the data
member. Parentheses are optional after the getter (as they are with all
methods accepting zero parameters). The current value for the data
member can be returned as follows.

::

   #person->firstName
   // => the 'firstName' data member value
   #person->lastName()
   // => the 'lastName' data member value

The automatically created setter permits the assignment operator = to
assign a new value to the data member. As with the getter, parentheses
are optional. Either the = or := assignment operators can be used.

::

   #person->firstName = 'John'
   // => 'firstName' assigned a new value
   #person->lastName() := 'Doe'
   // => 'lastName' assigned, value produced

Exposing a data member in this manner always creates both the getter and
setter. However, getters and setters can also be added manually, without
automatically exposing both get and set behaviors. One hypothetical use
for this is a type that wants to provide to the outside world read-only
access to one of its data members. Additionally, a getter or a setter
can be added manually in order to override, or replace the automatically
provided behavior, perhaps to validate the values in a particular
manner.

The following example defines a person type which manually exposes its
firstName data member by defining two member methods, one for the getter
and another for the setter. See the area of this chapter on *Member
Methods* for more information on creating member methods.

::

   define person => type {
     // the firstName data member
     data firstName
     // the firstName getter
     public firstName() => {
       return .'firstName'
     }
     // the firstName setter
     public firstName=(value) => {
       .'firstName' = #value
       return .'firstName'
     }
   }

The type definition above would operate identically if it instead
omitted the manual getter and setter and made its firstName data member
public.

Within a manual getter or setter, it is vital to refer to the data
member using the quoted name syntax. Otherwise, an infinite recursion
situation may arise as the getter/setter continually re-calls itself.

Member Methods
--------------

A member method is a method that belongs to a particular type. A member
method can operate on the data members of its owning type, in addition
to any parameters the method may receive.

Defining Member Methods
^^^^^^^^^^^^^^^^^^^^^^^

Member methods are created in sections of a type expression beginning
with the word public, private, or protected, followed by a method
signature, the association operator =>, and the implementation of the
method. Each section can define one or more methods separated by commas.
The choice of word used to begin a member methods section influences how
the methods are permitted to be accessed. There are three such access
levels.

-  `Public` member methods can be called without any restrictions.
   They represent the public interface of the data type. When the type
   is documented for others to use the public methods are described.
-  `Private` member methods can only be called from methods defined
   within the owning type. Private methods are to be used for lower
   level implementation details. Details which shouldn't be exposed to
   the end user, or to inheriting types.
-  `Protected` member methods can be called from within the owning
   type implementation or any type that inherits from the that type.
   Protected methods represent functionality that is not intended to be
   exposed to the public but which can be overridden, modified or used
   from within types inheriting from the owning type.

The following type expression defines three data members and three
member methods. The method ``describe()`` returns a description of the
person and is intended to be called by users of the type. The methods
``describeName()`` and ``describeAge()`` are private and protected methods, not
intended to be used by the outside world.

::

   define person => type {
     data public firstName,
         public lastName,
         public age
     public describe() => {
       return .describeName + ', ' + .describeAge
     }
     private describeName() => .firstName + ' ' + .lastName
     protected describeAge() => 'age ' + .age
   }

Given the definition above, the following example illustrates valid and
invalid usage of a person.

::

   local(p = person)
   #p->describe
   // => the description returned by the person
   #p->describeAge
   // => FAILURE: access not permitted

The second usage fails because the ``describeAge()`` method was protected.
A type which inherits from person could access ``describeAge()``, but it
could never access ``describeName()`` because that method is marked as
private.

Inheritance
-----------

Every type inherits from one or more parent types. To inherit from
another type means that every instance of the type will automatically
possess all of the data members and methods of the parent type, plus
those defined in the type expression itself. The concept of inheritance
is used to build more complex types out of more generalized types.

A more general type may have several different more specific types
inheriting from it as it provides a basic set of functionality that each
inheriting type will also possess. Lasso supports only
single-inheritance, that is, each type has only one immediate parent and
that parent has only one immediate parent. All types can eventually
trace down to a null parent. If a parent is not explicitly specified
when a type is defined then the parent of the type is null.

All of the public or protected member methods belonging to a parent type
will be made available to the types that inherit from it. Any method
defined in a parent type which conflicts with those of an inheriting
type will be replaced by the inheriting type's method. This permits
inheriting types to override or replace functionality provided by a
parent.

Parent
^^^^^^

The *parent* section names the parent that the type being defined is to
inherit from. For example, the person type can inherit from the entity
type by naming it in its *parent* section. Each person object that gets
created will then possess all of entity's data members and methods,
whatever those might be.

::

   define person => type {
     parent entity
   }

Only one parent type can be listed. The parent section can appear only
once in a type expression.

The following code defines a simple type one and a type two. Type two
inherits from type one. Notice that the ``second()`` method is overridden
by the second type, but the ``first()`` method is not.

::

   define one => type {
     public first() => 'alpha'
     public second() => 'beta'
   }
   define two => type {
     parent one
     public second() => 'gamma'
   }

When the methods of a two object are called the ``first()`` method returns
alpha since it is automatically calling the method from the parent type.
The ``second()`` method returns gamma since it is calling the overridden
method from type two.

::

   two->first
   // => 'alpha'
   two->second
   // => 'gamma'

Accessing Inherited Methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes it is necessary to call "down" to an inherited method. A
method inherited from a parent can be accessed by using two periods ..
in front of the method call.

In the following example, the method ``third()`` is defined to call the
inherited method ``second()``. The method from type two will be bypassed
in favor of the corresponding method from type one.

::

   define one => type {
     public first() => 'alpha'
     public second() => 'beta'
   }
   define two => type {
     parent one
     public second() => 'gamma'
     public third() => ..second
   }

The result of calling the new method is the value defined in type one.

::

   two->third
   // => 'beta'

Equivalently, the word inherited can be used to access the methods of a
parent type. The example above can be rewritten using inherited in place
of the double period .. operator.

::

   public third() => inherited->second

Type Creators
-------------

A type creator is a method which returns a new instance of a type. For
example, calling the method named ``string()`` produces a new string object.
By default each type has a creator method that corresponds to the name
of the type and requires no parameters.

The example type person would automatically have a creator method
``person()`` which returns a new instance of the type.

::

   local(myperson = person())
   // => assigns a new person object to #myperson

If a type does not define its own creator method(s), then it is provided
with a default zero-parameter type creator. Attempting to provide
parameters to a type creator which does not accept any parameters will
fail.

::

   local(myperson = person(264))
   // => FAILURE: person() accepts no parameters

Many types allow one or more parameters to be provided when a new object
is created in order to customize the object before it is used. A type
can specify its own type creators by defining one or more methods named
onCreate. When a new object is created, the onCreate method
corresponding to the given parameters is immediately called, before the
new object is returned to the user. Each onCreate must be a public
member method.

To illustrate, the following type definition defines an onCreate method
which requires three parameters firstName, lastName, and birthdate.
These parameters correspond to the data members of the type and allow
them to be set when the object is first created. The creator simply
assigns the parameter values to the data members.

::

   define person => type {
     data firstName::string, lastName::string
     data birthdate::date
     public onCreate(
         firstName::string,
         lastName::string,
         birthdate::date) => {
       .'firstName' = #firstName
       .'lastName' = #lastName
       .'birthdate' = #birthdate
     }
   }

To create an instance of the type, the creator must be called with the
required parameters. The following code will create a new instance of
the person type.

::

   local(myperson = person('John', 'Doe', date('1/1/1974')))

Note that when a creator has been specified, the default creator, which
requires no parameters, is not automatically provided. Lasso will not
supply a default type creator when the author has included their own.

Many type creators can be defined by specifying multiple onCreate
methods. The following type defines three type creators. The first
permits persons to be created with no parameters. The second permits
persons to be created with first and last names. The third, with first
and last names and a birthdate.

::

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

Callbacks
---------

In addition to the onCreate method, Lasso reserves a number of other
method names as callbacks which are automatically used in different
situations. Lasso provides default behavior so all callbacks are
optional, but by defining a callback a type can customize its behavior.

onCompare
^^^^^^^^^

The onCompare method is called whenever an object is compared against
another object. This includes when the equality ==, and inequality !=
operators are used and when objects are compared for ordinality using
any of the greater than or less than operators < <= > >=.

An onCompare method must accept one parameter and must return an integer
value.

::

   public onCompare(rhs)::integer

If the parameter is equal to the current type instance then a value of 0
should be returned. If the current type instance is less than the
parameter then an integer less than 0 should be returned, e.g. -1. If
the current type instance is greater than the parameter then an integer
greater than 0 should be returned, e.g. 1.

For example, the following person type has an onCompare method that
gives person objects the ability to compare themselves with other
persons.

::

   define person => type {
     data public firstName::string,
         public lastName::string
     public onCompare(other::person) => {
       .firstName != #other->firstName ?
           return .firstName < #other->firstName? -1 | 1
       .lastName != #other->lastName ?
           return .lastName < #other->lastName? -1 | 1
       return 0
     }
     public onCreate(firstName::string, lastName::string) => {
       .firstName = string(#firstName)
       .lastName = string(#lastName)
     }
   }

Given the above type definition, the following examples utilize the
onCompare method, behind the scenes, to provide the ability to compare
persons.

::

   person('Bob', 'Barker') == person('Bob', 'Barker')
   // => true

::

   person('Bob', 'Barker') == person('Bob', 'Parker')
   // => false

Multiple onCompare methods can be provided, each specialized to compare
against particular object types. For example, an integer type would want
to permit itself to be compared against other integers, but it might
also want to be comparable to decimals. Such an integer type would have
one onCompare method for integers, and another for decimals. This
example also shows how the onCompare method can be manually called on
objects. In this case, the 'value' data member is responsible for doing
the actual comparisons, so its onCompare method is called and the value
returned.

::

   define myint => type {
     data private value
     public onCompare(i::integer) => .value->onCompare(#i)
     public onCompare(d::decimal) => .value->onCompare(integer(#d))
   }

Contains
^^^^^^^^

The contains method is called whenever the contains >> or not contains
!>> operators are used.

A contains method should have the following signature. The method
accepts one parameter and must return a boolean value, true or false.

::

   public contains(rhs)::boolean

If the parameter is contained within the current type instance (using
whatever logic makes sense for the type) then a value of true should be
returned. Otherwise, a value of false should be returned.

For example, the type odds, overrides the contains operators so that
odds >> 3 will return true and odds >> 4 will return false.

::

   define odds => type {
     public contains(rhs::integer)::boolean => {
       return #rhs % 2 == 1
     }
   }

Other types which implement their own contains methods include arrays
and maps, which search their contained objects for a match before
returning true or false.

Invoke
^^^^^^

The invoke callback is used by the system when an object is invoked by
applying parentheses to it. By default, invoking an object produces a
copy of the object that was invoked. However, objects can add their own
invoke methods to alter this behavior. The following code shows how an
instance of the person type might be invoked.

::

   define person => type {
     data public firstName::string,
         public lastName::string
     public invoke() => .firstName + ' ' + .lastName + ' was invoked!'
     public onCreate(firstName::string, lastName::string) => {
       .firstName = string(#firstName)
       .lastName = string(#lastName)
     }
   }

The following shows how a person object would be invoked, by either
directly calling the invoke method or by applying parentheses.

::

   local(per = person('Bob', 'Parker'))
   #per()
   // => Bob Parker was invoked!
   #per->invoke
   // => Bob Parker was invoked!

\_unknowntag
^^^^^^^^^^^^

The \_unknowntag callback can be utilized in order to let a type handle
requests for methods which it does not have. When a search for a member
method fails, the system will call the \_unknowntag method if it is
defined. The method name that was originally sought is available by
calling method_name.

asString
^^^^^^^^

The asString method can be called when a type should be converted into a
string. By default, a type instance will simply output the name of the
type. Overriding this method allows a type to control how it is output.
The following code defines a simple type which outputs a greeting when
its asString method is called.

::

   define mytype => type {
     public asString() => 'Hello World!'
   }

Operator Overloading
--------------------

Types can provide their own routines to be called when the standard
arithmetic operators + - * / % are used with an instance of the type on
the left hand side of the expression.

If the standard operators are overloaded they should be mapped as
closely as possible to the standard arithmetic meanings of the
operators. For example, the addition operator + is also used for string
concatenation.

Overloading +, -, \*, /, %
^^^^^^^^^^^^^^^^^^^^^^^^^^

An arithmetic operator is overloaded by defining a member method whose
name is the same as the operator symbol. The method must accept one
parameter and return an appropriate value. The type instance should not
be modified by these operations.

::

   public +(rhs)
   public -(rhs)
   public *(rhs)
   public /(rhs)
   public %(rhs)

The following example provides a full set of arithmetic operators for
the myint type. The operators can be called in expressions like::

   myint + 35
   // => 35.

::

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

The type can now be used naturally in arithmetic expressions.

::

   myint(9) + 5 * 40
   // => 209

Overloading ==, !=, <, <=, >, >=, ===, !==
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

See *onCompare* for information about how to overload these operators.

Overloading >>, !>>
^^^^^^^^^^^^^^^^^^^

See *Contains* for information about how to overload these operators.

Trait
-----

Every type has a single trait which may be composed of other sub-traits.
A type inherits all of the methods which its trait defines provided that
the type implements the requirements for the trait.

See the chapter *Traits* for a complete description of how
traits are created.

The trait section of a type expression can import one or more other
traits. These traits are combined to form the trait for the type. The
following code shows a type definition which imports the traits of both
the map and array types.

::

   define mytype => type {
     trait {
       import trait_array, trait_map
     }
   }

A trait section can appear anywhere within a type expression, but can
appear only once.

Introspection
=============

Lasso provides a number of methods which can be used to gain information
about an object. These methods are summarized in the table below.

Introspection Methods
---------------------

.. method:: null->type()

   Returns the type name for any instance. The value is the name which was used
   when the type was defined.

.. method:: null->isA(name::tag)

   Checks whether an instance is of the given type. The method will return true
   if the name of the type is specified or the name of any parent type other
   than ``null``. The method will also return true for any trait name which the
   type has applied to it. The method call ``null->isa(::null)`` will only
   return true for the ``null`` type instance itself.

.. method:: null->isNotA(name::tag)

   The opposite of ``null->isA``.

.. method:: null->listMethods()

   Returns a staticarray containing the signatures for all of the methods which
   are available for the type.

.. method:: null->hasMethod(name::tag)

   Returns true if the type implements a method with the given name.

.. method:: null->parent()

   Returns the name of the parent of the target object. If the method returns
   "null" then the final parent has been reached.

.. method:: null->trait()

   Returns the trait for the target object. Returns ``null`` if the object does
   not have a trait.

.. method:: null->setTrait(trait::trait)

   Sets the trait of the target object to the parameter. The existing trait is
   replaced.

.. method:: null->addTrait(trait::trait)

   Combines the target object's trait with the parameter.

Modifying Types
===============

Lasso permits types to have methods added to them outside of the
original defining type expression. This is done by defining the method
using the word define. followed by the name of the type, followed by the
target operator ``->`` and then the rest of the method signature and body.

The following adds the method speak to the person type.

::

   define person->speak() => 'Hello, world!'
