.. _captures:

********
Captures
********

Captures are the basic frame of execution in Lasso. All code that executes does
so within a capture. When a method is invoked, a capture is first automatically
created for that method to execute in. When executing code in a source file, a
capture is again automatically created for that code to execute in.

Captures are everywhere in Lasso, and learning how to use them will give you a
powerful tool to use for solving some complex problems. This chapter provides
in-depth information about captures and examples of their use.


Overview
========

A capture is a representation of the control state of a section of code. While
methods are stateless (once they have had their code established), captures
maintain state, some of which may change frequently during execution.
This state consists of:
   
*  The current method's code

*  The current "self" and "inherited"

*  The current "params" staticarray

*  The current set of local variables, and their values

*  The current program counter, or "PC". This value is the offset within that
   capture's code at which execution is currently happening.

*  The name of the current method call

*  The current :dfn:`continuation`, which is the element to be executed after
   the current capture completes
   
*  The set of handlers that must be executed before the capture completes

*  A :dfn:`home` capture, which is the capture in which this capture was created
   
When a capture is invoked, it will in turn execute its associated code which
will execute within the context of that capture's state. The currently executing
capture is known as the :dfn:`current capture` and is made available through the
``currentCapture`` method.


Creating Captures
=================

As previously mentioned, captures are automatically created when a method is
executed. Captures can also be manually created by using curly braces as an
expression. This commonly occurs when a capture is used in a ``givenBlock``
association::
   
   #ary->forEach => {
      // ... a capture of the surrounding code ...
   }
   
In the code above, the block associated with ``array->forEach`` is a capture
object which ``array->forEach`` receives as its ``givenBlock`` and may execute
as needed.

Captures can also be assigned to variables like any other object. The following
example creates a capture and assigns it to the variable "cap"::

   local(cap) = { /*... the capture's code ...*/ }

There are two types of captures supported in Lasso 9: regular captures, like the
examples above, and auto-collect captures. An auto-collect capture concatenates
together the result of calling the "asString" method on every value produced
inside the capture when the capture is executed and produces that value. The
following example creates an auto-collect capture and assigns it to the variable
"cap"::

   local(cap) = {^ /*... the capture's code ...*/ ^}

Because all executing code occurs within a capture, every capture that is
manually created (as in the two examples above) is done so within the context of
another capture. This surrounding capture is known as the new capture's "home
capture". Not all captures will have a home. Captures which are automatically
created based on the invocation of a method will not have a home. A capture that
is created within a capture that does have a home will have its home set to its
parent capture's home. This means that nested captures will all have the same
home.
   
A capture with a home will always take the following environment values from
that home: self, locals, params, current call name. A capture without a home
will have state values based on the circumstances of the call. All other capture
state is unique to each capture. As described below, the home capture is
important for determining the behavior of ``return`` and ``yield``.


Executing Captures
==================

Captures are executed by calling their ``capture->invoke`` method::
   
   local(cap) = { /* ... the capture's code ... */ }
   #cap->invoke  // Invoke the capture
   #cap()        // Shorthand invocation

You can pass parameters to the ``capture->invoke`` method, and these are
available with the special parameter local variables (``#1``, ``#2``, etc.)::

   local(dist) = {
      local(x1) = #1
      local(y1) = #2
      local(x2) = #3
      local(y2) = #4
   }
   #dist(8,2,10,5) // Sets #x1, #y1, #x2, #y2 to 8, 2, 10, 5 respectively

When you invoke an auto-collect capture, the auto-collected value will be
returned and can be accessed using ``capture->autoCollectBuffer``::

   local(distance) = {^
      local(x1) = #1
      local(y1) = #2
      local(x2) = #3
      local(y2) = #4

      math_sqrt(math_pow(math_abs(#x2-#x1), 2) + math_pow(math_abs(#y2-#y1), 2))
   ^}
   #distance(8,2,10,5)
   '\n'
   #distance->autoCollectBuffer
   // => 
   // 3.605551
   // 3.605551

Stored captures can be executed at any point and the code contained within will
operate as if it had been executed in the context in which it was created. This
means that it will have access to the surrounding local variables where the
capture was created even when the capture is being executed in code that has a
different scope. The example below illustrates this by creating a capture in the
"method1" method whose code is set to update the local variable "my_local" in
"method1". We then invoke that capture in "method2" which changes the value for
"my_local" in "method1". Returning "my_local" confirms that the value has been
updated by "method2"::
   
   define method1 => {
      local(my_local)
      local(my_cap) = {
         #my_local->append(#1)
      }

      #my_local = 'Hello'
      method2(#my_cap)
      
      return #my_local
   }
   define method2(cap::capture) => {
      #cap(', world.')
   }

   method1
   // => Hello, world.


Producing Values and Detaching Captures
=======================================

Captures can produce values by using ``yield`` or ``return``. Both ``yield`` and
``return`` halt the execution of any of the capture's remaining code and produce
the specified value. Yielding from a capture differs from returning in how it
leaves the capture. A ``return`` will reset the capture's PC to the top while a
``yield`` will not modify the PC. This has an effect on how the capture behaves
if it is executed a second time. A capture that has been returned from will
begin executing from the start of the capture. A capture that has been yielded
from will begin executing immediately after the expression which caused it to
yield in the first place. A capture may ``yield`` many times::
   
   local(cap) = {
      yield 1
      yield 2
      yield 3
      yield 4
   }->detach
   
   #cap() 
   // => 1
   #cap() 
   // => 2 
   #cap() 
   // => 3
   #cap() 
   // => 4
   #cap() 
   // => 1   // capture reached the end and reset
   
Note that once a capture reaches its end, the PC will automatically be reset
back to the top. (Read on for a discussion of why we use ``capture->detach``
here.)

Even though a capture has yielded, it can still elect to return later in the
code, thus resetting itself::

   #cap = {
      yield  1
      yield  2
      return 3 // subsequent calls will start from beginning
      yield  4 // this is unreachable
   }
   
The current home capture is very important for determining the behavior of
``return`` and ``yield``. Because captures are intended to execute as if they
had been invoked directly within their home, ``return`` and ``yield`` will both
behave by exiting from the current home as well as itself. This type of return
is known as "non-local", and is illustrated in the following example which
implements a potential "contains" method::
   
   define contains(a::array, val) => {
      #a->forEach => {
         #val == #1?
            return true // this return is non-local
      }
      return false
   }

Even though the ``return true`` occurs within a nested capture that is
potentially several levels deep, it causes all intervening captures to halt
their execution (with all their handlers executing in the process) up to and
including the capture's home.

A capture can be detached from its home in order to escape from this behavior.
The easiest way to accomplish this is to call the capture's ``capture->detach``
method. This method detaches the capture from its home and returns itself as the
method's result. (This is what we did in the first yield example above.)

The following example creates a capture and detaches it from its home. Returning
from within the capture no longer exits the surrounding capture::

   local(cap) = { return self->type }->detach
   #cap()
   // => Produces result of self->type

Note that because the capture above is detached, the return operates as normal
and simply produces its value to the caller and allows the caller to continue
its execution. It is not a non-local return.

Captures provide two other forms of ``yield`` and ``return``: ``yieldHome`` and
``returnHome``. These are only valid when the capture has a home and can be used
to return from a capture **to** its home, instead of returning **from** its
home. These forms are special purpose and used for accomplishing some
implementation details such as certain looping constructs or control structures.
(For example, ``loop_continue`` and ``loop_abort`` both rely on using these
forms.)


Capture API
===========

.. type:: capture

   A capture is a block of Lasso code that can be passed to another method or
   invoked locally. Captures are context-aware and retain state during
   execution.

.. member:: capture->invoke(...)

   This executes the capture object and the code that is associated with it.

.. member:: capture->detach()

   Detaches the capture so that it no longer has a home capture and then returns
   itself. After this, calling ``capture->home`` will return ``void``.

.. member:: capture->restart()

   Resets the program counter (PC) for the capture and begins executing the
   capture's code again.

.. member:: capture->continuation()

   Returns the capture that will be executed after this capture completes.

.. member:: capture->home()

   Returns the home capture of the current capture object.

.. member:: capture->callSite_file()

   Returns the file name where the capture object was defined.

.. member:: capture->callSite_line()

   Returns the current line of code that is being executed in the capture object
   based on the file where the capture was defined.

.. member:: capture->callSite_col()

   Returns the current column of code that is being executed in the capture
   object based on the file where the capture was defined.

.. member:: capture->callStack()

   Returns the current call stack of the code that is being executed based on
   where the capture was called. Each line of the call stack consists of a line
   number, column number and file name for the capture invocations leading up to
   the current one. The top of the stack has the most recent capture call and
   the list works its way back through each call.

.. member:: capture->givenBlock()

   Returns the ``givenBlock`` associated with the current capture object, if
   any.

.. member:: capture->autoCollectBuffer()

   If the capture is an auto-collect capture, then this will store the current
   auto-collect value created by invoking the capture.

.. member:: capture->autoCollectBuffer=(p0)

   If the capture is an auto-collect capture, this method allows for setting the
   the auto-collect value.

.. member:: capture->calledName()

   If the capture was created to run a method, this will return the method's
   name.

.. member:: capture->methodName()

   If the capture was created to run a method, this will return the method's
   name.

.. member:: capture->invokeAutoCollect(...)

   This invokes the capture. If it is an auto-collect capture, it will return
   the auto-collecte value, but it will not update
   ``capture->autoCollectBuffer``.
