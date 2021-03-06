.. _files:

***********
File System
***********

Lasso provides access to the local file system through the :type:`file` and
:type:`dir` types. File objects are used to create, delete, read, and write
file data. Dir objects are use to create and delete directories and to iterate
through directory contents. Each are front ends for the :type:`filedesc` and
:type:`dirdesc` types, which are internal interfaces used by these and other
methods for communication with the filesystem and other processes (e.g.
:type:`net_tcp`, `split_thread`).


.. _files-paths:

Paths
=====

Individual files and directories are identified by their paths. Paths may
include "|dot| ." or "|dot| " components to indicate "parent" or "current"
locations, respectively. Path components are generally separated by forward
slashes, though backward slashes are acceptable as well and may be more natural
on Windows operating systems. Regardless of which type of slash is used, Lasso
will normalize all paths to match the conventions of the operating system before
using the path in any system function.

Paths can be either relative or full. Full paths always start with at least one
slash, or in the case of Windows, may start with a drive letter designation
(e.g. "C:"). Full file paths are based from the file system root. When serving
web requests under Lasso Server, the file system root defaults to the host
document root as indicated by the web server for that request (IIS, Apache,
etc.) or as set by the :envvar:`LASSOSERVER_DOCUMENT_ROOT` web request variable.
This applies to the current thread only. Any new threads will not inherit the
request-specific file system root.

It is possible to escape the host document root and target the real file system
root by using a full path with either a drive letter designation in the case of
Windows, or by prefixing the path with two additional forward slashes. For
example, "//foo/bar" and "C:\\foo\\bar" would both reference the same file on
Windows, provided "C:" is the system drive.

When not serving a web request, such as when running items from "LassoStartup"
or when running scripts through the :program:`lasso9` command-line tool, the
file system root is set to the system's natural root which is "/" for UNIX-based
systems or "C:" (for example) on Windows-based systems.

Relative paths do not begin with a slash or drive designation and indicate a
file or directory that is located based on the current working directory. During
a web request, the current working directory is the directory location of the
currently active source file. For example, when processing a request for the
file "/foo/bar.lasso", "/foo/" is the current working directory and a file with
a relative path of "baz.lasso" will be looked for as "/foo/baz.lasso". To
illustrate, consider the following three example files. Within the first two are
tests checking for the existence of the next file.

.. code-block:: none

   /test.lasso - file 'dir/test.lasso' exists
   /dir/test.lasso - file 'dir2/test.lasso' exists
   /dir/dir2/test.lasso

When not serving a web request or when running shell scripts via lasso9, the
current working directory is as set by the operating system or shell. In this
situation, the current working directory path can be retrieved with the
`io_file_getcwd` method, and the current working directory can be set with the
`io_file_chdir` method. Manipulating the working directory in this way changes
it globally for all threads in the current process.


File Type
=========

.. type:: file
.. method:: file()
.. method:: file(path::string)

   File objects can be instantiated with or without an initial path. Creating a
   file object does not open the file. If created without a path, a path must be
   specified when later opening the file.


Opening Files
-------------

A file must be opened before it can be read from or written to. Once a file is
opened, it should be closed when it is no longer needed. While Lasso will close
all files that become garbage-collected, it is recommended to immediately close
files once their tasks are completed. Many operating systems have limitations on
the number of simultaneously opened files, and ensuring that they are closed
promptly will improve system performance.

.. member:: file->openRead()
.. member:: file->openWrite()
.. member:: file->openWriteOnly()
.. member:: file->openAppend()
.. member:: file->openTruncate()

   These methods open the file using the open mode indicated in the method name.

   -  `~file->openRead` will open the file in read-only mode.
   -  `~file->openWrite` will open the file in read/write mode.
   -  `~file->openAppend` will open the file in read/write mode and will set the
      current write position to the end of the file.
   -  `~file->openTruncate` will open the file in read/write mode and will set
      the file's size to zero.

   Write, append, and truncate modes will create the file if it does not exist.
   Read-only mode will fail if the file does not exist.

   All the methods will fail if the process does not have access to the file in
   question. In this case the `error_code` and `error_msg` will be set to the
   values generated by the operating system.

.. member:: file->openRead(path::string)
.. member:: file->openWrite(path::string, okCreate::boolean= ?)
.. member:: file->openWriteOnly(path::string, okCreate::boolean= ?)
.. member:: file->openAppend(path::string, okCreate::boolean= ?)
.. member:: file->openTruncate(path::string, okCreate::boolean= ?)

   These methods will open the file in the same manner as the preceding methods,
   however these methods allow the file path to be given at the time the file is
   opened. An optional second boolean parameter can be given indicating whether
   the file should be created if it does not exist. If "false" is given for this
   parameter then the file will not be created and a failure will be generated
   using the operating system's error code and message.


Closing Files
-------------

Once a file is opened, it must later be closed. Once a file is closed it can no
longer be read from or written to until it is reopened.

.. member:: file->doWithClose()

   Requires a capture block when called. The capture block will be invoked and
   then the file will be closed. This is the safest method to use when working
   with files as it will ensure the file is closed even if a failure occurs
   within the capture block.

   Example of writing to a file within a capture block::

      local(f) = file('n.txt')
      #f->doWithClose => {
         #f->openWrite
         // ... work with file ...
      }

.. member:: file->close()

   This method simply closes the file.


Reading File Data
-----------------

File data can be read as either bytes or string objects. By default, string
objects, which are always Unicode, are created with the assumption that the file
contains UTF-8 encoded data. This assumption can be changed by settings the file
objects's character encoding value. When reading the data as a bytes object, the
unaltered file data is returned.

Data can be read line by line or as individual bytes or in chunks of bytes. Each
read will return the bytes immediately following the previously read bytes
unless the file's read/write position is moved. Attempts to read past the end of
the file will return a zero-sized bytes object.

.. member:: file->readBytes(count::integer= ?)::bytes

   Reads and returns all the remaining data from the file, or reads up to the
   requested number of bytes. There may be fewer bytes available than requested.

.. member:: file->readString(count::integer= ?)::string

   Reads and returns all the remaining data from the file, or reads up to the
   requested number of bytes and attempts to convert it into a string object.
   This method is generally not safe when dealing with multi-byte characters as
   the read end point may come in the middle of a character sequence, producing
   invalid Unicode data.

.. member:: file->marker()::integer
.. member:: file->marker=(m::integer)

   These methods respectively get and set the file object's current read/write
   marker. This value controls where the next read or write will take place. The
   marker value is zero-based. Settings the marker to zero moves the marker to
   the beginning of the file.

.. member:: file->encoding()::string
.. member:: file->encoding=(e::string)

   These methods respectively get and set the file object's character encoding
   value. This value controls how the `file->readString` method converts the
   data read from the file into a string object. This value defaults to UTF-8.

.. member:: file->forEach()
.. member:: file->forEachLine()

   These methods provide iteration over the file's bytes either one at a time or
   line by line.

   Example of performing an operation for each line of a file::

      #f->forEachLine => {
         local(theLine) = #1
         // ...
      }


Writing File Data
-----------------

Data can be written to files using either bytes or string objects as the source.
When writing Unicode string data to a file, the file's encoding value is used.
Writing past the end of the file will increase the file's size. Manipulating the
file's marker will adjust where the next write takes place.

.. member:: file->writeBytes(b::bytes)::integer
.. member:: file->writeString(s::string)::integer

   These methods write bytes or string data to the file and return the number of
   bytes that were written.

.. member:: file->moveTo(path::string, overwrite::boolean= false)
.. member:: file->copyTo(path::string, overwrite::boolean= false)

   These two methods attempt to move or copy the file to a new location or fail
   trying. The overwrite parameter indicates that if the destination file
   already exists the method should fail. Setting overwrite to "true" will have
   it replace the existing file with the file referenced by the file object.

.. member:: file->delete()

   This methods will delete the file from the system. The file is closed first.


File Manipulation Methods
-------------------------

.. member:: file->exists()::boolean

   Returns "true" if the file exists on the system.

.. member:: file->path()::string

   Returns the path to the file.

.. member:: file->parentDir()::dir

   Returns a :type:`dir` object set to the file's parent directory.

.. member:: file->size()::integer
.. member:: file->size=(s::integer)

   These methods get and set the file's size. Setting the size in this manner
   will change the file's size on disk.

.. member:: file->modificationTime()::integer
.. member:: file->modificationDate()::date

   These methods return the raw file modification time as an integer and the
   modification time as a date object, respectively.

.. member:: file->lastAccessTime()::integer
.. member:: file->lastAccessDate()::date

   These methods return the raw file last access time as an integer and the last
   access time as a date object, respectively.

.. member:: file->linkTo(path::string, hard::boolean= false)

   Attempts to create a hard or soft link of the file at the specified location.
   This method may not be available or may not operate consistently across all
   supported operating systems.

.. member: file->chown(user::string)
.. member:: file->chown(user::string, group::string= ?)
.. member:: file->chown(uid::integer, gid::integer)
.. member:: file->chmod(to::integer)
.. member:: file->perms()::integer

   These methods are used to set and get the permissions of the file. These
   operations are currently supported on UNIX-based systems only.


Standard File Objects
---------------------

.. method:: file_stdin()::file
.. method:: file_stdout()::file
.. method:: file_stderr()::file

   Lasso makes the standard in, out, and error files available using these
   methods. In general, these file objects should not be closed. The file
   objects returned from these methods will not close the underlying system file
   when they are garbage-collected.


Dir Type
========

.. type:: dir
.. method:: dir(path::string, -resolveLinks= false)

   Dir objects are instantiated with a path and an optional ``-resolveLinks``
   keyword parameter. This parameter defaults to "false". If set to "true", then
   the dir object will resolve symbolic links when iterating over its contents,
   when returning its own `file->perms` and when determining if it is indeed a
   directory through the `dir->isDir` method.


Creating Directories
--------------------

.. member:: dir->create(perms::integer= integer_bitOr(\
                     io_file_s_irwxg, \
                     io_file_s_irwxu, \
                     io_file_s_irwxo))

   Attempts to create the directory at the path indicated when the dir object
   was created. The perms parameter indicates the permissions that the directory
   should be given. This defaults to the equivalent of "rwxrwxrwx".

   This method will attempt to create any non-existent intermediate directories
   along the path with the same permissions. It does not alter the permissions
   of any existing directories.


Iterating Directory Contents
----------------------------

The contents of a directory can be explored in a variety of ways. The contents
can be returned as a series of string paths or as a series of file and dir
objects. Sub-directory contents can be returned recursively.

The paths of subdirectories produced by these methods will have a trailing
forward slash. A dir object never returns a path or object representing the
"|dot| ." or "|dot| " directory entries.

Each of the values returned by these methods can be used in query expressions or
in `iterate`. A dir object itself can be used in a query expression or iterate.
In this case, the behavior will be the same as with the `dir->eachPath` method,
described below.

.. member:: dir->eachPath()
.. member:: dir->eachFilePath()
.. member:: dir->eachDirPath()

   These methods are used to operate on the relative paths of the contents of
   the directory. The `~dir->eachPath` method will return both files and
   subdirectories, while `~dir->eachFilePath` and `~dir->eachDirPath` return
   only the file or subdirectory paths, respectively.

.. member:: dir->eachPathRecursive()
.. member:: dir->eachFilePathRecursive()
.. member:: dir->eachDirPathRecursive()

   These methods are used to operate on the relative paths or the contents of
   the directory. When a subdirectory is encountered, its contents are also
   included, and so on as deep as the directory tree goes.

.. member:: dir->each()
.. member:: dir->eachFile()
.. member:: dir->eachDir()

   These methods return the directory contents as file or dir objects. The
   `~dir->each` method returns both the files and directories within the
   directory. The `~dir->eachFile` and `~dir->eachDir` methods return only the
   files or directories, respectively.


List Directory Contents
^^^^^^^^^^^^^^^^^^^^^^^

Use a :type:`dir` object in a query expression to list the contents of the
current working directory::

   with path in dir('.')
   sum #path + '\n'

   // =>
   // A Folder/
   // My_File.txt
   // Sub_Directory/

Use a :type:`dir` object to list a directory's contents as :type:`file`
objects::

   with f in dir('foo/')->eachFile
   // f is a file object
   sum #f->size->asString(-padding=10) + ' ' + #f->name + '\n'

   // =>
   //     12779 An Example File.pdf
   //         0 empty_file
   //      1063 Rhino Habitats.txt
   //    109572 Rhino Running.jpg
   //      3270 Summary.txt


Directory Manipulation Methods
------------------------------

.. member:: dir->moveTo(path::string)

   Attempts to rename, or "move", the directory. A failure is generated if the
   operation fails.

.. member:: dir->delete()

   Attempts to delete the directory. A directory must be empty before it can be
   successfully deleted. A failure is generated if the operation fails.

.. member:: dir->exists()::boolean

   Returns "true" if the directory exists on disk.

.. member:: dir->path()::string

   Returns the directory's path as a string.

.. member:: dir->parentDir()::dir

   Returns the directory's parent directory as a :type:`dir` object.
