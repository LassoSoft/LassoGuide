.. http://www.lassosoft.com/Language-Guide-Defining-Methods
.. _methods:

*******
Methods
*******

Methods are the fundamental process abstraction in many languages, including
Lasso. :dfn:`Methods` provide a means for encapsulating a series of expressions
so that they can be called repeatedly as a group. Complex, multi-step tasks are
best expressed as a group of related methods. A method is defined under a
specific name and is associated with a signature and a code block.


Signatures
==========

Before method definitions can be understood, it is important to understand
signatures. A :dfn:`signature` is a description of a method and includes its
name, parameter names, and types, and the method's return value type. Signatures
are used when defining methods, and simplified signatures are used when defining
types and traits. This chapter will concentrate on signatures for defining
methods only.

Method names in Lasso consist of letters, numbers, and underscores. A method
name must start with a letter, or one or two leading underscores followed by a
letter. Letter case is not considered when comparing method names.

Method names beginning with an underscore are generally intended to only be used
internally, as they represent methods that could change in the future and are
therefore considered unstable.

Some valid examples of method names are shown below::

   field
   _date_msec
   Encode_Base64
   String_ReplaceRegexp

There are several other characters that are valid in specific circumstances. The
mathematical operators ``+``, ``-``, ``*``, ``/``, and ``%`` are used in method
names when supplying implementations for these operations for types. See the
section :ref:`types-overloading` in the :ref:`types` chapter for more
information.

Most signatures consist of a method name followed by parentheses which surround
a list of parameters for the method, and an optional return type.

A signature for the ``loop`` method is shown below. The parameter list includes
three parameters: a ``to`` parameter which must be an integer, and two more
integer parameters each with default values of "1". ::

   loop(to::integer, from::integer=1, by::integer=1)

When a method is called, the parameter names given in the method's signature
become the variable names for those parameters within the method's body. The
``loop`` method above would have access to the local variables "to", "from", and
"by".

A signature's parameter list allows the specification of required and optional
parameters, type constraints, keyword parameters, and rest parameters.


Empty Signature
---------------

A signature specified with an empty set of parentheses indicates that the method
will not require or accept any parameters. Giving parameters to a method defined
with an empty signature will result in a failure. The following is an example of
a signature without any parameters::

   method_name()


Rest-Only Signature
-------------------

A signature whose parameter list is just three periods (``...``) indicates that
the method will accept any number and type of parameters. A method defined with
a rest-only signature can be called with no parameters or any combination of
values and keyword parameters. ::

   method_name(...)

Note that these are three periods rather than a Unicode ellipsis character.

Within the method, the parameters that were passed in can be accessed through a
local variable named "rest". If any parameters were given, the rest variable
will be a staticarray. If no parameters are given, it will remain "void". This
signature can be useful for methods that have highly variable parameters needing
special processing, such as `inline`.


Required Parameters
-------------------

Required parameters can be specified within a signature by naming them in order.
All required parameters must be listed before any other parameter types. When
calling a method with required parameters, all parameter values must be provided
in the proper order according to the method's signature.

The name of each required parameter must be a valid variable name. Each name
should begin with a letter or an underscore followed by a letter, then zero or
more letters, numbers, underscores, or period characters.

The following signature defines two required parameters named ``firstname`` and
``lastname``. Within the method these parameters can be accessed through the
local variables "firstname" and "lastname". ::

   method_name(firstname, lastname)

When calling this method, both parameters must be given in order. ::

   method_name('Henry', 'Gibbons')

The parameter names are only used within the method so the choice of parameter
names need only make sense to the implementer of the method. However, the
parameter names may be used in documentation or reported in error messages so
they should be made descriptive when possible. Knowing a method requires the
parameter ``firstname`` is more descriptive than a method that requires the
parameter ``fn``.


Optional Parameters
-------------------

Optional parameters are those which are listed in a method's signature but are
not required to be given values when the method is called. Optional parameters
are specified within a signature by providing default values along with the
parameter names. A default value is specified after a parameter name by using an
equal sign (``=``) followed by an expression. The expression's value will be
used to assign the default value to the parameter's local variable should that
value be omitted by the caller.

The default value expression will be evaluated independently with each call as
required from within the associated method's body, so any state valid at the
beginning of the associated method is valid during the evaluation of all
optional parameter default values.

Although optional parameters may be omitted when calling a method, when optional
parameter values are provided, they must be provided in order. That is, when the
method is called, once an optional parameter is omitted, all subsequent optional
parameters must also be omitted.

The parameters in the following signature are both optional. If the ``host``
parameter is not specified the local variable "host" within the method will have
the default value ``'localhost'``. If the ``port`` parameter is not specified,
it will have the default value of "80". ::

   connect(host='localhost', port=80)

When the method is called the parameters that are passed to it will be assigned
to each of the optional parameters in turn. The method called as
``connect('www.lassosoft.com')`` will have a default port value of "80". The
method called as ``connect()`` will have both default values. And, the method
called as ``connect('www.lassosoft.com', 443)`` will use the specified values,
overriding both defaults. In this example, there is no way to only specify a
value for ``port``.


Mixing Required and Optional Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When calling a method that accepts both required and optional parameters, all
required parameter values must be specified before any optional parameter
values. The values that are passed will be assigned to the required parameters
first. While there are sufficient remaining values, the optional parameters will
be assigned in order.

For example, the following signature has one required parameter ``host`` and two
optional parameters ``port`` and ``timeout``::

   connect(host, port=80, timeout=15)

The ``host`` parameter must be provided before ``port`` can be provided with a
value, and both ``host`` and ``port`` must be provided before ``timeout`` can be
provided with a value.


Keyword Parameters
------------------

:dfn:`Keyword parameters` are named parameters that can be specified in any
order. When keyword parameter values are passed to a method, they are given with
the associated parameter name, using the following syntax::

   -parameterName = expression

If a method has any required or optional parameters, they must be specified
before the keyword parameters in both the method signature and when calling the
method.

Keyword parameters are specified by preceding the parameter name with a hyphen
(``-``). Within the method body, the keyword parameter's associated local
variable will not have the hyphen.

Keyword parameters can be either required or optional. Optional keyword
parameters are indicated in the same manner as regular optional parameters, by
following the parameter name with an equals (``=``) and a default value
expression.

For example, a hypothetical ``find_in_string`` method could have the following
signature. The required input is followed by two keyword parameters: the
required ``-find`` and the optional ``-ignoreCase``. ::

   find_in_string(input, -find::string, -ignoreCase::boolean=false)

When this method is called the input must always be given first. However, the
two keyword parameters can be given in either order, provided they follow all
non-keyword parameters. It is valid to call the method in any of the following
ways::

   find_in_string('the fox', -find='x', -ignoreCase=true)
   find_in_string('the fox', -ignoreCase=true, -find='x')
   find_in_string('the fox', -find='x')

Within the method's body, three predefined local variables will be created for
these parameters including ``input``, ``find``, and ``-ignoreCase``.

Note that calling the method as ``find_in_string('the fox')`` will generate a
failure because the ``-find`` keyword parameter is required (since it has no
default value). Calling the method as ``find_in_string(-find='x', 'the fox')``
will also generate a failure because the input is being specified after a
keyword parameter. All required parameters and any optional parameters being
passed must be specified before the first keyword parameter.


Boolean Keyword Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^

Often, keyword parameters will be used to indicate simple boolean values. For
example, as a set of options or flags given to a method to control the details
of its behavior. When calling a method, a keyword parameter can be passed
without an associated value. Doing so is implicitly the same as passing a
boolean "true" value for that parameter. Boolean keyword parameters are normally
specified with a default value of "false" so if the keyword parameter is not
specified the predefined variable will have a value of "false".

The following signature defines the method ``server_date`` as accepting either a
``-short`` keyword parameter, a ``-long`` keyword parameter, or neither::

   server_date(-short=false, -long=false)

If the method is called as ``server_date(-short)`` then the predefined local
variable "short" will have a value of "true" and the predefined local variable
"long" will have a value of "false". If the method is called as
``server_date()`` then both variables will have a value of "false".


Rest Parameters
---------------

The list of parameters may end with three periods (``...``) in order to specify
that the method should accept a variable number of additional parameters after
any specified required and optional parameters. The additional parameters are
known as :dfn:`rest parameters`. When the method is called, any additional
parameters are placed into a predefined local variable named "rest". If there
are no rest parameters, the "rest" local will be "void"; otherwise, it will be a
staticarray holding the remaining parameter values passed to the method.

The signature below specifies that the ``string_concatenate`` method requires
one parameter named ``value``, but will accept any number of additional
parameters. Within the method, the first parameter will be placed into the
predefined local variable "value", and the remaining parameters, if any, will
be placed into the predefined local variable "rest"::

   string_concatenate(value, ...)

Note that these are three periods rather than a Unicode ellipsis character.

By default, the rest parameter local variable is always named "rest", but an
alternate variable name can be specified in the signature by placing the desired
name immediately after the three periods. The following signature would rename
the rest variable to "other"::

   string_concatenate(value, ...other)


Parameter Type Constraints
--------------------------

.. index:: tag literal

In a signature, all parameter types, with the exception of the rest parameter,
can be specified with an optional type constraint. While parameter count and
ordering ensure that the caller is passing the right number of parameters in the
right order, type constraints ensure that the parameter values are of the right
type. For example, if a method that expects to receive two string parameters is
given two integers, it is being used incorrectly. If a caller passes a parameter
value that does not fit the type constraint set for that parameter, then a
failure will be generated. Any type or trait name can be used as a constraint,
and all parameter values must pass the "isA" test for their constraint before
the method body begins to execute. (The "isA" test involves calling the object's
``isA`` method with the constraint; if a non-zero value is returned, then it
passes. See `~null->isA` for details about this member method.) Additionally,
all parameter default values must produce results of a type matching the type
constraint set for their respective parameters.

A type constraint is specified by following the parameter name with two colons
(``::``) and a type name. Whitespace is permitted on either side of the double
colon (examples herein will not include whitespace). The signature below has
both of its required parameters constrained to only accept values that are of
type :type:`string`. ::

   method_name(firstname::string, lastname::string)

If the parameter has a default value, it should be placed after the type
constraint. ::

   method_name(firstname::string, lastname::string = '')

A parameter with no type constraint will accept any type of value. Constrained
and unconstrained parameters can be mixed. ::

   method_name(firstname::string, lastname)
   method_name(firstname, lastname::string)
   method_name(firstname::string, lastname::string, -age::decimal=0.0, -dept='')

Within a method body, parameters with type constraints translate into local
variables with type constraints. A parameter that is constrained to accept a
particular object type becomes a local variable that can hold only that type of
object. See the :ref:`variables` chapter for more information on
:ref:`type-constrained variables <variables-type-constraints>`.


Return Type
-----------

.. index:: tag literal

Specifying a return type for a signature enforces that the value returned by its
code block is of a specific type. If a method returns a value having a type that
does not pass the "isA" test for the specified return type, then a failure is
generated. (The "isA" test involves calling the object's ``isA`` method with the
constraint; if a non-zero value is returned, then it passes. See `~null->isA`
for details about this member method.) Specifying a return type provides
knowledge to the caller of the method about the method's resulting value. It
also ensures the method's developer that their programming is correct, at least
with respect to the method returning the proper value type. Specifying a return
type is optional, and a method without a specified return type may return values
of any type, or may return no value at all (in which case the value returned to
the caller is "void").

The return type for a signature is specified at the end of the signature,
following the parameter list parentheses, by including two colons (``::``)
and a type or trait name.

The following signature specifies that the method will always return a value of
type :type:`string`. ::

   string_concatenate(value, ...other)::string


Type Binding
------------

Signatures are also used to denote that the method belongs to a particular type.
This is referred to as the :dfn:`type binding` for the signature. A signature
with no bound type is referred to as being :dfn:`unbound`. All example
signatures given up to this point were unbound signatures. A type binding occurs
at the beginning of the signature, before the signature's name. It consists of a
type name followed by the target operator (``->``) followed by the rest of the
signature. ::

   type_name->method_name(...)
   method_name(...)

In the above example, the first signature is bound to the type ``type_name``
while the second signature is unbound. A method using the first signature cannot
be called except with a target instance of ``type_name``. The second signature
can be called at any point without a target type instance.


Signature Syntax
----------------

These are the syntax diagrams for signatures and their related elements.

.. image:: /_static/syntax_signature.*
   :align: center
   :alt: Syntax diagram for signatures


Defining Methods
================

.. index:: define keyword

Before a method can be used, it must first be defined. Defining a method
combines a signature with a method body, and allows it to be called by name from
within other methods.

The ``define`` keyword is used to define new methods, types, and traits. When
defining a method, the word ``define`` is followed by a signature, the
association operator (``=>``), and then an expression that provides the body for
the new method. ::

   define signature => expression

If a method is defined that has a signature equivalent to an already-defined
method, the new definition will replace the old and the old definition will no
longer be available. Keyword parameters cannot be used to uniquely identify a
method. A method taking, for example, two required parameters and a certain set
of keyword parameters will be overwritten by a new method that requires the same
two parameters and an entirely different set of keyword parameters.


Methods Returning Simple Expressions
------------------------------------

A simple method definition is shown below. The signature ``hello()`` describes
what and how the method will be called, in this case ``hello`` with no
parameters. After the association operator, the expression ``'Hello, world!'``
provides the method's return value. The method below simply returns a string::

   define hello() => 'Hello, world!'

Any single expression, including the ternary conditional operator or
mathematical expressions, can be used as the method's return value. Assignments,
local or thread variable declarations, or any other expression known at
compilation time not to produce a value may not be used as a method's return
value expression. ::

   define pi() => math_acos(-1)
   define times_twenty(n) => #n * 20
   define is_blank(s::string) => #s->size ? false | true


Code Blocks
-----------

.. index:: code block

Many methods do more than return a single easily calculated value. A method body
can be composed of multiple expressions enclosed by a pair of curly braces (``{
... }``). This type of method body is referred to as a :dfn:`code block`.

Code blocks provide the most flexibility when defining methods. They allow a
series of expressions to be encapsulated as the implementation of the method.
One or more ``return`` statements may be used to end execution of the method
body and to optionally return a value to the caller.

The methods used as examples above may be written using code blocks as follows::

   define pi() => {
      return math_acos(-1)
   }
   define times_twenty(n) => {
      return #n * 20
   }
   define is_blank(s::string) => {
      return #s->size ? false | true
   }

The expressions within a code block method body are generally formatted so that
they each appear on a separate line. Some expressions are terminated by an
end-of-line, and expressions may be explicitly terminated by using a semicolon
at the end of the expression.

The following definition for the hypothetical ``strings_combine`` method uses a
series of instructions within the method body to generate the return value for
the method::

   define strings_combine(value::string, with, alsoWith='') => {
      local(result) = string(#value)
      #result->append(#with->asString)
      #result->append(#alsoWith->asString)
      return #result
   }


frozen Methods
--------------

.. index:: frozen keyword

To prevent a method's definition from being modified, the ``frozen`` keyword can
be used. When inserted after the association operator, it prevents the method
from being added to with multiple dispatch or overridden. ::

   define phi => frozen (1 + math_sqrt(5)) / 2
   define phi => 500
   phi
   // => 1.618034


define Syntax
-------------

This is the syntax diagram for ``define``.

.. image:: /_static/syntax_define.*
   :align: center
   :alt: Syntax diagram for define


Multiple Dispatch
=================

:dfn:`Multiple dispatch` is a technique that permits more than one method body
and signature to be defined under a given method name. The various signatures
will differ in the number or types of parameters they are stated to receive.
When the method name is called, the parameters given by the caller (or the lack
thereof) will determine which method body will actually be executed. The process
of determining which method body to call is referred to as "dispatch".


The Dispatch Process
--------------------

The process of method dispatch first involves taking the name the caller has
used and matching it to one or more methods defined under that name. These
methods are the set of methods potentially valid for that call. Methods are
removed from this set as each parameter value is checked against each valid
method's type constraint for that parameter. If the parameter value is
acceptable according to this constraint (a lack of a type constraint on a
parameter means that any type is valid for that position), then the method
remains in the set of valid methods, otherwise it is removed. For each parameter
position, methods that accept, at most, fewer than that number of parameters are
also removed from the valid set.

In many cases, when the final parameter value is checked there will remain only
one valid method. In cases where there are multiple remaining valid methods, the
methods are sorted and the top-most method is selected as the method to be
executed for that call. The methods are sorted according to how closely related
each given parameter value is to each method's stated type constraint for that
parameter position, with each subsequent parameter having a lower priority than
the previous.

-  Methods with a type constraint for a parameter position will sort higher than
   methods that do not have a type constraint.
-  Methods having a required parameter for a position will sort higher than
   methods with an optional parameter.
-  Methods that are valid only because they accept rest parameters will sort
   lower than methods that accept an actual declared parameter.

In the case where the result of the sorting leads to two or more equally valid
methods, then the call is ambiguous and a failure will be generated. In
practice, ambiguous methods are usually handled when the conflicting method is
first defined, leading to the second definition overwriting the first, which
removes the first from future consideration during dispatch.

Keyword parameters are never considered during the method selection process
until the end where the single remaining method's keyword parameters (if any)
are validated. Two methods cannot differentiate themselves based on accepting a
different set of keyword parameters. Methods must be distinguished based solely
on their required or optional parameters.


Using Multiple Dispatch
-----------------------

Constraints Example
^^^^^^^^^^^^^^^^^^^

Multiple dispatch comes into play any time more than one method is defined under
a single name. As example, consider the scenario where special diagnostic
information needs to be created for a variety of possible types: :type:`array`,
:type:`string`, :type:`bytes` and a default :type:`any` type. In the example
below, the ``log_object`` method is defined multiple times, each accepting a
different possible type. Each of the four methods is written to handle only
their input value types. ::

   define log_object(a::array) => {
      return '[log] array with ' + #a->size + ' elements\n'
   }
   define log_object(s::string) => {
      return '[log] string with value "' + #s + '"\n'
   }
   define log_object(b::bytes) => {
      return '[log] bytes with hex value 0x' + #b->encodeHex + '\n'
   }
   define log_object(any) => {
      return '[log] unhandled object type: ' + #any->type + '\n'
   }
   log_object('Hello!')
   log_object(bytes('ABCD'))
   log_object(array(1, 2, 3, 4, 5))
   log_object(pair(1, 2))

   // =>
   // [log] string with value "Hello!"
   // [log] bytes with hex value 0x41424344
   // [log] array with 5 elements
   // [log] unhandled object type: pair

Multiple dispatch allows several related methods to be grouped under a single
name. This permits method bodies to be more succinct and tailored directly to
the input types. This promotes maintainability in a code base, as shorter
methods are easier to understand and maintain.

If the above example was instead written to have a single ``log_object`` method
that accepted any value type (we'll call it a mega-method), and within that
mega-method, inspected the parameter value type to decide what action to take,
then the method would need to be modified each time a new log object type was
added. If a log implementation needed to be added for objects of type
:type:`pair`, then a new case would need to be placed within that mega-method.

Problems arise if a user wishes to add logging implementations for their own
object types. If ``log_object`` were only this single mega-method, then the user
would likely have to resort to writing their own set of log methods, falling
back to using ``log_object`` only for object types that it is known to handle.
However, with multiple dispatch, the user may directly add their own
``log_object`` method with its own unique signature. The new method is
incorporated automatically into the system and none of the other methods need to
be modified. ::

   define log_object(p::pair) => {
      return '[log] pair with: ' + #p->first + ', ' + #p->second + '\n'
   }
   log_object('Hello!')
   log_object(bytes('ABCD'))
   log_object(array(1, 2, 3, 4, 5))
   log_object(pair(1, 2))

   // =>
   // [log] string with value "Hello!"
   // [log] bytes with hex value 0x41424344
   // [log] array with 5 elements
   // [log] pair with: 1, 2


Number of Parameters Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The number of parameters that a set of methods accepts can be used to determine
method dispatch. For example, one method may require a single parameter while a
second method requires two parameters, such as in the example that follows::

   define log_object(a::array) => {
      return '[log] array with ' + #a->size + ' elements'
   }
   define log_object(a::array, extra::boolean) => {
      local(result) = log_object(#a)
      #extra ?
         return #result + '. Elements: ' + #a->join(', ')
      return #result
   }

   log_object(array(1, 2, 3, 4, 5))
   // => [log] array with 5 elements

   log_object(array(1, 2, 3, 4, 5), true)
   // => [log] array with 5 elements. Elements: 1, 2, 3, 4, 5

Note how the body of the second method calls the first method to get the initial
result string before augmenting it and returning that value.
