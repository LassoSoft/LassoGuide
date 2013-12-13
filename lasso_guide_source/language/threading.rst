.. http://www.lassosoft.com/Language-Guide-Threading
.. _threading:

*********
Threading
*********

In computing, a :dfn:`thread` is a sequence of instructions being managed by an
operating system. Lasso has integrated support for running multiple threads,
allowing it to handle many application requests at the same time. Threading in
Lasso is designed to be easy to use and safe. Lasso does not feature global
variables, so all data is local to individual threads. Threads can communicate
with one another by sending object messages back and forth. These objects are
copied as they are transmitted to ensure that data structures remain consistent.

Lasso supports creating or splitting a new thread given a block of code. It also
supports creating thread objects which run in their own thread.


Splitting Threads
=================

A new thread can be created by calling the `split_thread` method. This method
requires a capture block. The capture given to `split_thread` will be run in a
new thread. This new thread will contain copies of the local variables that are
active at the time the new thread is created. Changing the value of a variable
in the new thread will not affect the variables that were active at the creation
point. Additionally, the current self is cleared for the new thread.

.. method:: split_thread()::pair

   Takes a capture assigned as a capture block and runs that capture in a
   separate thread. Any local variables that would normally be available to that
   capture are copied and available in the new thread. This method also returns
   a pair object with file descriptors for writing and reading messages to and
   from the newly created thread.


Thread with Capture
-------------------

The following example shows a new thread being created. The new thread simply
prints a message to the console. This illustrates how `split_thread` is used and
how a new capture (between curly braces ``{ ... }``) is given to `split_thread`
which will be run in a new thread. ::

   split_thread => {
      stdoutnl("I'm alive in a new thread!")
   }


Thread Communication
--------------------

When a new thread is created by calling `split_thread`, the return value of that
method call is a pair of filedesc objects. Similarly, the parameter given to the
new thread is a pair of filedesc objects. (This can be accessed in the new
thread by the pseudo-local variable ``#1``.) The :type:`filedesc` type
represents a file descriptor or pipe over which data can be sent or received.
These objects provide the means for the new thread and the creator thread to
communicate. Two filedesc objects are required for thread communication, one
representing the *write* end of the pipe and the other representing the *read*
end. Objects are written to the write filedesc and read from the read filedesc.

Within this context of the given pair of filedescs, the write filedesc is always
the first member of the pair while the read filedesc is always the second
member. The creator thread writes objects to the new thread using the write
filedesc, and reads objects from the new thread using the read. The newly
created thread operates in the same manner, writing and reading objects to and
from its creator thread.


Send and Receive Objects Between Threads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The next example creates a new thread and illustrates how objects can be sent
and received::

   // Create the new thread, saving the filedesc pair in #creatorPipes
   local(creatorPipes) = split_thread => {

      // Save the filedescs sent to this new thread
      local(
         writePipe = #1->first,
         readPipe = #1->second
      )

      // Loop forever, reading messages and sending replies
      while(true) => {

         // Read an object
         local(o) = #readPipe->readObject

         // Print a message
         stdoutnl("I read an object: " + #o)

         // Write a reply object
         #writePipe->writeObject("Reply from the new thread")
      }
   }

   // Write an object to our new thread
   #creatorPipes->first->writeObject("Sent from the creator!")

   // Read the reply from the new thread
   stdoutnl(#creatorPipes->second->readObject)

   // Do it again
   #creatorPipes->first->writeObject("Sent from the creator 2!")
   stdoutnl(#creatorPipes->second->readObject)

   // =>
   // I read an object: Sent from the creator!
   // Reply from the new thread
   // I read an object: Sent from the creator 2!
   // Reply from the new thread

Threads created with `split_thread` exit when they reach the end of their code
body. If the example thread above did not loop reading/writing messages, it
would read one message, write one reply, reach the end of its code, and then
exit.


Thread Objects
==============

Thread objects represent a second way to create new threads in Lasso. A
:dfn:`thread object` is an object that exists in its own thread. This means that
any method calls to a thread object run serially in the object's thread. Thread
objects exist as singletons, which means that only one instance of a particular
thread type can exist. Thread objects permit data to be globally available, yet
forces access to that data to be synchronized.

Thread objects are created and begin running at the point where they are
defined. Thread types are defined similarly to how normal types are defined,
except that in such a definition, the word ``type`` is replaced with the word
``thread``.


Simple Counter Thread
---------------------

The following example creates a simple thread object. This object maintains a
counter that can be advanced and retrieve its current value. Because this is a
thread object, it is globally available and other threads can safely advance the
counter. ::

   define counter_thread => thread {
      data private val = 0

      public advanceBy(value::integer) => {
         .val += #value
         return .val
      }
   }

The above example defines a ``counter_thread`` object. This object exists and
begins running as soon as it is defined. Clients can access the thread object by
calling it by name; in this case by calling the ``counter_thread`` method::

   counter_thread->advanceBy(40)
   // => 40

   counter_thread->advanceBy(10)
   // => 50

Note that each time ``counter_thread`` is called, the same thread object is
retrieved. Hence, after the second call to ``counter_thread->advanceBy``, the
"val" data member has a value of "50".

Thread objects can be composed of the same elements as a regular type, including
public and private data members, and can have any other (non-thread) object
type as a parent.


Simple Map Thread
-----------------

This next example creates a thread type that inherits from type :type:`map`.
This results in creating a global map of values that can be safely accessed by
other threads. ::

   define map_thread => thread {
      parent map
      public onCreate() => ..onCreate
   }

   map_thread->insert('one'=1) & insert('two'=2)

   map_thread->get('two')
   // => 2

Thread objects cannot be copied. Additionally, thread objects will continue to
run forever, though they can terminate themselves by calling `abort`. Also,
all parameter values given to a thread object method are copied, as well as any
return value of a thread object method. This ensures that no two threads are
ever operating on the same data at the same time, a situation that can have
catastrophic results.


Thread Objects and onCreate
---------------------------

Because thread objects are created as soon as they are defined, a thread object
must have a zero parameter ``onCreate`` method, or no ``onCreate`` methods at
all. If a thread object requires further configuration, as would normally be
done at the point of object creation, it should be done immediately following
the thread object's definition. For example, the ``counter_thread`` could be
defined to permit its "val" data member to have an initial value set, as shown
in the following code::

   define counter_thread => thread {
      data private val = 0

      // Default zero-parameter onCreate
      public onCreate() => {}

      // Additional onCreate, letting val be initialized
      public onCreate(initValue::integer) => {
         .val = #initValue
      }

      public advanceBy(value::integer) => {
         .val += #value
         return .val
      }
   }

   // Initialize the counter
   counter_thread->onCreate(900)

   // Now it can be used
   counter_thread->advanceBy(20)
   // => 920


active_tick
-----------

Thread objects can define a method named ``active_tick``. If defined, this
method will be called periodically by the system. This lets a thread object
carry out periodic activity regardless of any methods called by clients. The
``active_tick`` method should accept zero parameters, and should return an
integer value. The integer value tells the system how many seconds *at the
latest* the ``active_tick`` method should be called again. The ``active_tick``
method may be called sooner than the indicated time as it provides the timeout
value for reading messages for that thread. Threads requiring precise timing for
events should not rely on the ``active_tick`` calls only being called after the
timeout value.

The next example defines a thread object that prints a message to the console
every 2 seconds::

   define lazy_ticker => thread {
      public active_tick() => {
         stdoutnl("Hello, from lazy ticker")
         return 2
      }
   }

The ``active_tick`` method can be one of several member methods, can reference
and call other member methods, and the tick timer (return value) can be
programmatically manipulated so that it does not have to be a hard-coded value.
In this way, a single ``active_tick``-enabled thread can manage multiple tasks
and conditionally perform additional tasks based on the results of its basic
task, can put itself to sleep or adjust the sleep timer, and have methods that
are called completely separately from the ``active_tick`` method. In short, any
thread type can also contain an ``active_tick`` method to perform periodic
maintenance or time-sensitive tasks.
