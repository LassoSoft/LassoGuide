.. http://www.lassosoft.com/Language-Guide-Defining-Traits
.. _traits:

******
Traits
******

Traits provide a way to define type functionality in a modular fashion. Each
:dfn:`trait` includes a set of reusable method implementations along with a set
of requirements that must be satisfied in order for the included methods to
function properly.


Trait Logic
===========

Traits allow a hierarchy of types that share common functionality to be created
without relying on single or multiple inheritance. Traits are similar to mixins
and abstract classes found in other languages.

Each trait encapsulates a set of requirements and provides a set of member
methods. When a trait is applied to a type, the requirements are checked. If
they are satisfied, then the provided member methods are added to the type as if
they had been implemented directly in the type. Traits can only define public
member methods.

Lasso includes many types that have common member methods. For example, the
:type:`pair`, :type:`array`, :type:`string`, and other types implement
``first``, ``second``, and ``last`` methods which return the named element. ::

   array(1, 2, 3, 4)->last
   // => 4

   'Quick brown fox'->second
   // => u

   pair('name'='John')->first
   // => name

The ``first`` method can be implemented by calling the ``get(x)`` member method
of each type with a parameter of "1". The ``second`` method calls it with a
parameter of "2". The ``last`` method calls the ``get(x)`` method with a
parameter defined by the size of the type (usually found by calling the ``size``
member method).

The requirements for implementing the ``first``, ``second``, and ``last``
methods are that the type has to have ``get(x)`` and ``size`` member methods. In
a trait this requirement would be specified as follows::

   require get(x::integer)
   require size()::integer

The requirements take the form of a list of member method signatures. If the
type that the trait is applied to defines all of the trait's required member
method signatures, then the methods provided by the trait will work.

The methods provided by the trait are specified similar to how methods are
defined in custom types. (However, instead of using the ``public`` keyword, the
method definition starts with the ``provide`` keyword.) The implementation for
the ``first``, ``second``, and ``last`` methods would appear as follows::

   provide first() => .get(1)
   provide second() => .get(2)
   provide last() => .get(.size)

Note that the period notation is used to call the member methods of the current
object; the same as it would be used within a custom type implementation. The
implementation of the provided methods can make use of the ``get`` and ``size``
member methods because the requirements ensure that they will be available.

The full trait definition for ``trait_firstLast`` would be as follows::

   define trait_firstLast => trait {
      require get(x::integer)
      require size()::integer
      provide first()  => .get(1)
      provide second() => .get(2)
      provide last()   => .get(.size)
   }

If we define a new type (e.g. ``month``) that supports ``get`` and ``size``,
then we can import this trait to automatically get an implementation of
``first``, ``second``, and ``last``. ::

   define month => type {
      trait {
         import trait_firstlast
      }
      data y, m

      public onCreate(year::integer, month::integer) => {
         .'y' = #year
         .'m' = #month
      }

      public get(x::integer) => {
         return date(-year=.'y', -month=.'m', -day=#x)
      }

      public size()::integer => {
         local(temp) = date(-year=.'y', -month=.'m'+1, -day=1)
         #temp->subtract(-day=1)
         return #temp->dayofmonth
      }
   }


Defining Traits
===============

A trait is defined using a :dfn:`trait expression` consisting of the ``define``
keyword followed by the trait name, the association operator (``=>``), the
keyword ``trait``, and a code block containing the definition of the trait. ::

   define myTrait => trait {
      // ...
   }

The code block contains one or more sections which are each identified by a
label. Method implementations that are provided by the trait are specified in a
provide section. Requirements for the trait are specified in a require section.
Other traits can be imported in an import section.


provide
-------

.. index:: provide keyword

The member methods that a trait provides are specified similarly to the public
section of a type definition. The :dfn:`provide` section begins with the keyword
``provide``, which is followed by a comma-separated list of member method
definitions. The member list has the same form as custom method definitions.
Each method is defined using a signature, the association operator (``=>``), and
an expression or code block that defines the implementation of the method.

The following trait would provide two member methods for getting and setting a
data member::

   define myTrait => trait {
      provide getFirstName() => {
         return .firstName
      }
      provide setFirstName(value::string) => {
         .firstName = #value
      }
   }


require
-------

.. index:: require keyword

The :dfn:`require` section allows specifying a list of method signatures that
are required for the trait to operate properly. The signatures may be simple
method names, or they may be complete signatures with parameter specifications.
As many require sections as are necessary can be specified.

The section begins with the keyword ``require`` followed by a comma-separated
list of method signatures. The following trait requires a getter and setter for
the "firstName" data member::

   define myTrait => trait {
      require firstName, firstName=
      provide getFirstName() => {
         return .firstName
      }
      provide setFirstName(value::string) => {
         .firstName = #value
      }
   }


import
------

.. index:: import keyword

The :dfn:`import` section allows the characteristics of other traits to be
imported into this trait definition, thus allowing a hierarchy of traits to be
defined. As many import sections as are necessary can be specified.

The section begins with the keyword ``import`` followed by a comma-separated
list of trait names. The following trait simply imports the characteristics of
the built-in :trait:`trait_array` trait::

   define myTrait => trait {
      import trait_array
   }

All of the requirements and provided member methods of the imported trait will
be added to the trait being defined. The requirements of one of the traits may
be satisfied by the methods provided by another trait.

However, if two traits provide the same member method, there will be a conflict.
The conflict is resolved by eliminating both implementations of that member
method and adding a requirement for it to the trait. The type that the trait is
ultimately applied to must implement that member method in order for the trait
to be applied.


Trait Composition
=================

Traits can be combined together into new traits using the ``+`` operator. This
is called "composing" a new trait. The result of this expression will be a trait
that has all the requirements and provides all the member methods of the traits
that have been combined.

The same rules that are used for importing traits apply to composed traits, such
as traits satisfying each others' requirements and resolving conflicting method
names.

An alternate method of defining the trait example from the start of this chapter
would be to define three subtraits and then use the composition operator (``+``)
to compose them into a single trait. ::

   define trait_first => trait {
      require get
      provide first() => .get(1)
   }
   define trait_second => trait {
      require get
      provide second() => .get(2)
   }
   define trait_last => trait {
      require get, size
      provide last() => .get(.size)
   }
   define trait_firstLast => trait_first + trait_second + trait_last

Replacing the last line with the trait definition below would produce exactly
the same result. In general, the latter method is preferred for trait
definitions, while the trait composition is preferred for runtime changes. ::

   define trait_firstlast => trait {
      import trait_first
      import trait_second
      import trait_last
   }


Checking Traits
===============

Since traits provide member methods for a type it is often useful to check
whether a given type instance has a trait applied. The `~null->isA` method can
be used for this check. This member method can be used on any type instance and
will return a positive integer if the instance is the provided type or has the
provided trait name applied to it.

In this code the `~null->isA` method returns "2" since the ``month`` type does
have the ``trait_firstLast`` trait applied to it::

   local(mymonth) = month(2008, 12)

   #mymonth->isA(::trait_firstlast)
   // => 2


Applying Traits
===============

Traits can be applied to types as part of the type definition. This makes the
trait an integral part of the type definition. The provided member methods are
indistinguishable to the user of the type from member methods that are
implemented directly in the type.

Each type definition can include a single trait section. The trait can import as
many traits as are needed. ::

   define myType => type {
      trait {
         import ...
      }
      data ...
      public ...
   }

When an instance of the type is created, the instance has the specified trait
applied to it automatically.

The trait of any object in Lasso can be programmatically manipulated using the
`~null->trait`, `~null->setTrait`, and `~null->addTrait` methods described
in the next section.


Trait Manipulation Methods
==========================

.. member:: null->trait(t::trait)
   :noindex:

   Returns the trait for the target object. Returns "null" if the object does
   not have a trait.

.. member:: null->setTrait(t::trait)

   Sets the trait of the target object to the parameter, replacing the existing
   trait.

.. member:: null->addTrait(t::trait)

   Combines the target object's trait with the parameter.

In general, traits will be added to a type instance to provide additional
functionality rather than resetting the entire trait for a given object. The two
examples below are equivalent::

   #myinstance->addtrait(trait_firstlast)
   #myinstance->settrait(#myinstance->trait + trait_firstlast)

.. caution::
   The `~null->setTrait` method should be used with care since resetting the
   trait of a type instance may result in many of its member methods becoming
   unavailable or ceasing to function.
