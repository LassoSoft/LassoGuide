.. _uploading-files:

***************
Uploading Files
***************

Lasso can process and manage files uploaded to your web server by visitors to
your website. To allow visitors to upload files to your web server, you need to
use an HTML form tag along with an input tag for each file being uploaded. The
form tag must have an ``enctype`` attribute of :mimetype:`multipart/form-data`,
and the input tags for file uploads need to have a ``type`` attribute of
``"file"``. The following HTML code could be used to upload a single file to
your server::

   <form action="upload_file.lasso" method="post" enctype="multipart/form-data">
      <fieldset>
         <legend>Upload a Photo</legend>
         <input type="file" name="photo">
         <input type="submit" value="Upload">
      </fieldset>
   </form>

The ``"file"`` input tells the browser to show controls for selecting a file to
be uploaded to the web server. Once a user selects the file and then clicks
"Upload", the form will upload the data to your web server and the files can be
processed by "upload_file.lasso"; the Lasso file specified as the action of the
form submission.

Uploaded files processed by Lasso are initially stored in a temporary location.
If you do nothing with them, they will be deleted. If you wish to keep them, you
should move them to a different directory.

To inspect and process these uploaded files use the `web_request->fileUploads`
method. This method returns an array, each element of which holds information
about an uploaded file. The size of this array will be equal to the number of
files uploaded. Each element of the array is a staticarray of pairs that houses
the following information about the files:

fieldname
   The name of the ``"file"`` input type. (In our example, ``"photo"``)
contenttype
   The MIME content type of the file.
filename
   The original name of the file that was uploaded.
tmpfilename
   The path to which the file was temporarily uploaded.
filesize
   The size of the file in bytes.

The following example code will loop through all uploaded files and display this
information::

   <dl>
   [with file_info in web_request->fileUploads do {^]
      <dt>[#file_info->find('filename')->first->second]</dt>
      <dd>
         <ul>
            <li>[#file_info->find('tmpfilename')->first->second]</li>
            <li>[#file_info->find('contenttype')->first->second]</li>
            <li>[#file_info->find('filesize')->first->second]</li>
            <li>[#file_info->find('fieldname')->first->second]</li>
         </ul>
      </dd>
   [^}]
   </dl>

The preceding example produces HTML like this::

   <dl>
      <dt>MyAvatar.jpg</dt>
      <dd>
         <ul>
            <li>//tmp/lassoqM9SFY37921967.uld</li>
            <li>image/jpeg</li>
            <li>851191</li>
            <li>photo</li>
         </ul>
      </dd>
   </dl>

The following example will move uploaded files out of their temporary location
and into the ``/assets/img/avatars/`` directory in the web root::

   local(path) = '/assets/img/avatars/'
   with upload in web_request->fileUploads do {
      file(#upload->find('tmpfilename')->first->second)
         ->moveTo(#path + #upload->find('filename')->first->second, true)
   }


Monitoring Uploads
==================

If you expect the uploads to take a lot of time---either due to uploading many
files or a few large ones---you may want to provide feedback to your visitors
that the browser and server are working on the uploads. Lasso comes with a
method that will allow you to do just that.

To track files, you first need an input named ``"_lasso_upload_tracker_id"``
with a unique value in your form. You can use `lasso_uniqueId` to generate a
UUID which is essentially guaranteed to be unique each time you call it. With
that in place, while the thread that processes the form submission is working on
uploading the files, you can check the status of that process in another thread.
This is done by passing the unique ID to the `check` method of the
`upload_tracker` thread object. That method returns a staticarray whose first
element is the amount of data uploaded, the second is the total size of all the
files being uploaded, and the third is the name of the current file being
uploaded.


Monitoring Uploads Demo
-----------------------

The following basic example has a form set up properly in "index.lasso". When
the submit button is pressed it opens another window to display "progress.lasso"
before submitting the form. This page calls `upload_tracker->check` with the
unique ID that gets passed to it. It also uses ``<meta http-equiv="refresh"
content="1">`` to refresh itself every second. The result is that we get a
progress bar which is updated every second.

.. rubric:: index.lasso

::

   <!DOCTYPE html>
   <html>
   <head>
      <title>Upload A Photo</title>
      <script type="text/javascript">
      //<!--
         function trackProgress(id) {
            window.open(
              "/progress.lasso?id=" + id,
              null,
              "height=100,width=400,location=no,menubar=no,resizable=yes,scrollbars=yes,title=yes"
            );
         }
      //-->
      </script>
   </head>
   <body>
      [local(id) = lasso_uniqueid]
      <form action="upload_file.lasso" method="post" enctype="multipart/form-data">
         <input type="hidden"
            name="_lasso_upload_tracker_id" value="[#id]">
         <fieldset>
            <legend>Upload a Photo</legend>
            <input type="file" name="photo">
            <input type="submit"
               value="Upload"
               onclick="trackProgress('[#id->encodeUrl]')">
         </fieldset>
      </form>
   </body>
   </html>

.. rubric:: progress.lasso

::

   [local(info) = upload_tracker->check(web_request->param('id'))]
   <!DOCTYPE html>
   <html>
   <head>
   [if(#info->first > 0 and #info->first != #info->second)]
      <meta http-equiv="refresh" content="1">
   [/if]
   </head>
   <body>
   [if(#info->first > 0 and #info->second > 0)]
   [#info->last]
   <div style="background-color: white;border: 1px solid black;width:380px;height: 20px;">
      <div style="background-color: black;height: 20px;width: [
        380 * (decimal(#info->first) / decimal(#info->second))
      ]px;"></div>
   </div>
   [/if]
   </body>
   </html>
