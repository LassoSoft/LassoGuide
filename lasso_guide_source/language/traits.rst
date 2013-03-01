.. _traits:
.. http://www.lassosoft.com/Language-Guide-Defining-Traits

******
Traits
******

This chapter provides details about how traits are defined and used in
Lasso 9. Topics include an introduction to traits, defining traits, and
trait arithmetic.

Introduction
============

Traits provide a way to define data types in a modular fashion. Each
trait includes a set of reusable tag implementations along with a set of
requirements which must be satisfied in order for the included tags to
function properly.

Traits allow a hierarchy of data types which share common functionality
to be created without relying on single or multiple inheritance. Traits
are similar to mixins and abstract classes found in other languages.

Each trait encapsulates a set of requirements and provides a set of tag
members. When a trait is applied to a data type the requirements are
checked. If they are satisfied then the provided tag members are added
to the type as if they had been implemented directly in the type. Traits
can only define public tag members.

Lasso includes many types which have common tags. For example, the pair,
array, string, and other data types implement ->first, ->second, ->last
tags which return the named element.

::

   array(1, 2, 3, 4)->last
   // => 4
   'Quick brown fox'->second
   // => u
   pair('name'='John')->first
   // => name

The ->first tag can be implemented by calling the ->get(x) tag member of
each type with a parameter of 1. The ->second tag calls the same tag
with a parameter of 2. The ->last tag calls the same tag with a
parameter defined by the ->size of the type.

The requirements for implementing the ->first, ->second, and ->last tags
is that the type we applyt the trait to has ->get(x) and ->size member
tags. In a trait this requirement would be specified as follows.

::

   require get(x::integer)
   require size()::integer

The requirements take the form of a list of tag memeber signatures. If
all of the tag member signatures are defined by the type which the trait
is applied to then the tags which are provided by the trait will work.

The tags provided by the trait are specified similar to how tags are
defined in custom types. The implementation for the ->first, ->second,
->last tags would appear as follows.

::

   provide first() => .get(1)
   provide second() => .get(2)
   provide last() => .get(.size)

Note that the period . notation is used to call the member tags of the
current object the same as it would be used within a custom type
implementation. The implementation of the provided tags can make use of
the ->get and ->size tags because the requirements ensure that they will
be available.

The full trait definition for trait_firstlast would be as follows.

::

   define trait_firstlast => trait {
     require get(x::integer)
     require size()::integer
     provide first() => .get(1)
     provide second() => .get(2)
     provide last() => .get(.size)
   }

If we define a new type, e.g. month which supports ->get and ->size then
we can import this trait to automatically get an implementation of
->first, ->second, and ->last.

::

   define month => type {
     data y, m
     public onCreate(year::integer, month::integer) => {
       .'y' = #year;
       .'m' = #month;
     }
     public get(x::integer) => {
       return date(-year=.'y', -month=.'m', -day=#x);
     }
     public size()::integer => {
       local(temp = date(-year=.'y', -month=.'m'+1, -day=1));
       #temp->subtract(-day=1);
       return #temp->dayofmonth;
     }
     trait {
       import trait_firstlast
     }
   }

Defining Traits
===============

A trait is defined using the define reserved word. The define for a
trait consists of the trait name followed by the association operator
=>, the reserved word trait and a codeblock containing the definition of
the trait.

::

   define myTrait => trait {
     ...
   }

The codeblock contains one or more sections which are each identified by
a label. Tag implementations which are provided by the trait are
specified in a provide section. Requirements for the trait are specified
in a require section. Other traits can be imported in a import section.
Each section will be introduced in this chapter and discussed in more
detail in the *Defining Traits* chapter.

Provide
-------

The tag members which a trait provides are specified similar to the
public section of a data type definition. The section begins with the
reserved word provide which is followed by a comma separated list of tag
member definitions. The member list has the same form as custom tag
definitions. Each tag is defined using a signature, the association
operator =>, and an expression which defines the implementation of the
tag.

The following trait would provide two tag members for getting and
setting a data member.

::

   define myTrait => trait {
     provide getFirstName() => {
       return .firstName;
     }
     provide setFirstName(value::string) => {
       .firstName = #value;
     }
   }

Require
-------

The require section allows a list of tag signatures to be specified
which are required for the tag to operate properly. The signatures may
be simple tag names or they may be complete signatures with parameter
specifications. As many require sections as are necessary can be
specified.

The section begins with the reserved word require[/require] followed by
a comma separated list of tag signatures. The following trait requires a
getter and setter for the [code]firstName data member.

::

   define myTrait => trait {
     require firstName, firstName=
     provide getFirstName() => {
       return .firstName;
     }
     provide setFirstName(value::string) => {
       .firstName = #value;
     }
   }

Import
------

The import section allows the characteristics of other traits to be
imported into this trait definition. Using import a hierarchy of traits
can be defined. As many import sections as are necessary can be
specified.

The section begins with the reserved word import[/require] followed by a
comma separated list of trait names. The following trait simply imports
the characteristics of the built-in trait_array trait.

::

   define myTrait => trait {
     import trait_array
   }

All of the requirements and provided tag members of the imported trait
will be added to the trait being defined. The requirements of one of the
traits may be satisfied by the tags provided by the other trait.

However, if both traits provide the same tag member then there is a
conflict. The conflict is resolved by eliminating both implementations
of that tag member and adding a requirement for it to the trait. The
type which which the trait is ultimately applied to must implement that
tag member in order for the trait to be applied.

Trait Arithmetic
================

Traits can be combined together into new traits using the addition
``+`` operator. This is called composing a new trait. The result of
this expression will be a trait that has all the requirements and
provides all the member tags of the traits that have been combined.

The same rules which are used for importing traits apply to composed
traits. The requirements of one trait may be satisified by a member tag
provided by the other trait in the composition.

However, if both traits provide the same tag member then there is a
conflict. The conflict is resolved by eliminating both implementations
of that tag member and adding a requirement for it to the trait. The
type which which the trait is ultimately applied to must implement that
tag member in order for the trait to be applied.

An alternate method of defining the trait example from the start of this
chapter would be to define three sub-traits and then use the composition
operator + to compose them into a single trait.

::

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
   define trait_firstlast => trait_first + trait_second + trait_last

Replacing the last line with this trait definition would product exactly
the same result. In general the latter method is preferred for trait
definitions, while the composition operator + is preferred for runtime
changes.

::

   define trait_firstlast => trait {
     import trait_first
     import trait_second
     import trait_last
   }

Checking Traits
===============

Since traits provide member tags for a type it is often useful to check
whether a given type instance has a trait applied. The ->isa tag can be
used for this check. This member tag can be used on any type instance
and will return True if the instance has the provided trait name applied
to it.

In this code the ->isa tag returns True since the month data type does
have the trait trait_firstlast applied to it.

::

   local(mymonth = month(2008, 12));
   #mymonth->isa(::trait_firstlast)
   // => True

Trait Checking Tags
-------------------

``->IsA(name::tag)``
    Checks whether an instance is of the given type. The tag will return
    True if the name of the type is specified or the name of any parent
    type other than ``null``. The tag will also return True for any
    trait name which the type has applied to it. The tag ``->Isa(::Null)``
    will only return True for the ``null`` type instance itself.

``->IsNotA(name::tag)``
    The opposite of ->IsA.

Applying Traits
===============

Traits can be applied to types as part of the type definition. This
makes the trait an integral part of the type definition. The provided
tag members are indistinguishable to the user of the type from tag
members that are implemented directly in the type.

Each type definition can include a single trait section. The trait can
import as many traits as are needed. Requirements and tag members can be
provided directly within the trait.

::

   define myType => type { 
     trait { 
       import ... 
       provide ... 
     }
     data ... 
     public ...
   }

When an instance of the type is create the instance has the specified
trait applied to it automatically.

The trait of any object in Lasso can be manipulated using the ->trait,
->settrait, and ->addtrait tags.

Trait Manipulation Tags
-----------------------

``->trait()``
    Returns the trait for the target object. Returns ``null`` if the
    object does not have a trait.

``->setTrait(trait::trait)``
    Sets the trait of the target object to the parameter. The existing
    trait is replaced.

``->addTrait(trait::trait)``
    Combines the target objects trait with the parameter.

The ``->settrait`` tag should be used with care since resetting the trait of
a type instance may result in many of its member tags becoming
unavailable. In general traits will be added to a type instance to
provide additional functionality rather than resetting the entire trait
for a given object. Using ``#myinstance->addtrait(trait_firstlast)`` is
equivalent to using ``#myinstance->settrait(#myinstance->trait + trait_firstlast)``.
