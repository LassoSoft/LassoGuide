:tocdepth: 3

.. _images-media:

****************
Images and Media
****************

Lasso includes features that allow you to manipulate and serve images and media
files on the fly. The ``image_…`` methods allow you to do the following with
image files in the supported image formats:

-  Scaling and cropping images, facilitating the creation of thumbnail images on
   the fly.
-  Rotating images and changing image orientation.
-  Applying image effects such as modulation, blurring, and sharpening effects.
-  Adjusting image color depth and opacity.
-  Combining images, adding logos and watermarks.
-  Image format conversion.
-  Retrieval of image attributes, such as dimensions, bit depth, and format.
-  Executing extended ImageMagick commands.

.. note::
   The :type:`image` type and features in Lasso are implemented using
   ImageMagick 6.6.6-10 (July 7, 2011 build), which is installed as part of
   Lasso Server on OS X. Windows and Linux require ImageMagick to be installed
   separately, which is covered with their respective installation instructions.
   For more information on ImageMagick, visit `<http://www.imagemagick.org/>`_.


Image File Operations
=====================

Image files can be manipulated via Lasso by setting a variable to an instance of
the :type:`image` type, and then using various member methods to manipulate the
variable. Instantiating an image object usually involves loading data from an
image file on the server into memory as an image object. Once the image file is
manipulated, it can either be served directly to the client browser, or it can
be saved to disk on the server.


Dynamically Manipulate an Image File
------------------------------------

The following shows an example of initializing, manipulating, saving, and
serving an image file named "image.jpg" using the :type:`image` type::

   <?lasso
      local(myImage) = image('/images/image.tif')
      #myImage->scale(-height=35, -width=35, -thumbnail)
      #myImage->save('/images/image.jpg')
   ?>
   <img src="/images/image.jpg" border="0">

In the example above, an image file named "image.tif" is referenced as a Lasso
image object using the :type:`image` type, then resized to 35 x 35 pixels using
the `image->scale` method. (The optional ``-thumbnail`` parameter optimizes the
image for the web.) Then the image is converted to JPEG format and saved to disk
using the `image->save` method. Finally, the new image is displayed on the
current page using an HTML ``<img>`` tag.

This chapter explains in detail how these and other methods are used to
manipulate image and media files. This chapter also shows how to output an image
file to a client browser within the context of a Lasso page.


Supported Image Formats
-----------------------

Because the :type:`image` member methods are based on ImageMagick, Lasso
supports reading and manipulating over 88 major file formats (not including
subformats). A comprehensive list of `supported image formats`_ can be found at
the ImageMagick website.

A list of commonly used image formats that are certified to work with Lasso
out-of-the-box without requiring installation of additional components are shown
in the table :ref:`images-media-tested-formats`.

.. tabularcolumns:: lL

.. _images-media-tested-formats:

.. table:: Tested and Certified Image Formats

   =========== =================================================================
   Format      Description
   =========== =================================================================
   :dfn:`BMP`  Microsoft Windows bitmap file.
   :dfn:`CMYK` Raw cyan, magenta, yellow, and black samples.
   :dfn:`GIF`  CompuServe Graphics Interchange Format. LZW-compressed 8-bit RGB
               with up to 256 palette entries.
   :dfn:`JPEG` Joint Photographic Experts Group format. Also known as :dfn:`JPG`.
   :dfn:`PNG`  Portable Network Graphics format.
   :dfn:`PSD`  Adobe Photoshop bitmap file.
   :dfn:`RGB`  Raw red, green, and blue samples.
   :dfn:`TIFF` Tagged Image File Format. Also known as :dfn:`TIF`.
   =========== =================================================================

.. note::
   Many of the formats listed on the ImageMagick site such as EPS and
   PDF may be used with the ``image_…`` methods, but require additional
   components such as Ghostscript to be installed before they will work. These
   formats may be used, but because they rely heavily on third-party components,
   they are not officially supported.


File Permissions
----------------

In order to successfully create, manipulate, and save image files using the
``image_…`` methods, the user running the Lasso process must be allowed by the
operating system to write and execute files inside the folder. To check folder
permissions in Windows, right-click on the folder and select
:menuselection:`Properties --> Security`. For OS X or Linux, use :command:`ls
-al` from the command line to check permissions and use the :command:`chmod` and
:command:`chown` commands to adjust the permissions. (Refer to the
:manpage:`ls`, :manpage:`chmod`, and :manpage:`chown` man pages for more
information on their use).


Referencing Images as Lasso Objects
===================================

For Lasso to be able to edit an image, an image file or image data must first be
modelled as a Lasso image object using the :type:`image` type. Once a variable
has been set to an image object, various member methods can be used to
manipulate the image. Once the image data is manipulated, it can either be
served directly to the client browser, or it can be saved to disk on the server.

.. type:: image
.. method:: image()
.. method:: image(filePath::string, -info= ?)
.. method:: image(bytes::bytes, -info= ?)

   Creates an image object. Requires either the path to an image file or a bytes
   object with an image's binary data to initialize the object. Once an image
   object is initialized, it may be edited and saved using the :type:`image`
   member methods which are described throughout this chapter.

   The optional ``-info`` parameter retrieves all the attributes of an image
   without reading the pixel data. This allows for better performance and less
   memory usage when initializing an image object.

   Example of creating an image object from a file::

      local(myImage1) = image('/images/image.jpg')

   Example of creating an image object with just the attributes::

      local(myImage2) = image('/images/largeimage.jpg', -info)

   Example of creating an image object with bytes data::

      local(binary)   = file('image.jpg')->readBytes
      local(myImage3) = image(#binary)


Image Information Methods
=========================

Information about an image can be returned using special `image` member methods.
These methods return specific values representing the attributes of an image
such as size, resolution, format, and file comments. All the image information
methods in Lasso are defined below.

.. member:: image->width()::integer

   Returns the image width in pixels.

.. member:: image->height()::integer

   Returns the image height in pixels.

.. member:: image->resolutionH()::integer

   Returns the horizontal resolution of the image in dpi.

.. member:: image->resolutionV()::integer

   Returns the vertical resolution of the image in dpi.

.. member:: image->depth()::integer

   Returns the color depth of the image in bits. Can be either 8 or 16.

.. member:: image->format()

   Returns the image format (GIF, JPEG, etc).

.. member:: image->pixel(x::integer, y::integer, -hex= ?)

   Returns the color of the pixel located at the specified pixel coordinates
   (X, Y). The returned value is an array of RGB color integers (0--255) by
   default. An optional ``-hex`` parameter returns a hex color string
   ("#FFCCDD") instead of an RGB array.

.. member:: image->comments()

   Returns any comments included in the image file header.

.. member: image->describe()
.. member:: image->describe(-short= ?)

   Lists various image attributes, mostly for debugging purposes. An optional
   ``-short`` parameter displays abbreviated information.

.. member:: image->file()

   Returns the image file path and name, or "null" for in-memory images.


Return Height and Width of an Image
-----------------------------------

Use the `image->height` and `image->width` methods on an image object. This
returns an integer value representing the height and width of the image in
pixels::

   local(myImage) = image('/images/image.jpg')
   #myImage->width + ' x ' + #myImage->height

   // => 400 x 300


Return Resolution of an Image
-----------------------------

Use the `image->resolutionH` and `image->resolutionV` methods on an image
object. This returns a decimal value representing the horizontal and vertical
:abbr:`DPI (Dots Per Inch)` of the image::

   local(myImage) = image('/images/image.jpg')
   #myImage->resolutionV + ' x ' + #myImage->resolutionH

   // => 600 x 600


Return Color Depth of an Image
------------------------------

Use the `image->depth` method on an image object. This returns an integer value
representing the color depth of an image in bits::

   local(myImage) = image('/images/image.jpg')
   #myImage->depth

   // => 16


Return Format of an Image
-------------------------

Use the `image->format` method on an image object. This returns a string value
representing the file format of the image::

   image('/images/image.gif')->format

   // => GIF


Return Pixel Information About an Image
---------------------------------------

Use the `image->pixel` method on an image object. This returns a string value
representing the color of the pixel at the specified coordinates::

   local(myImage) = image('/images/image.jpg')
   #myImage->pixel(25, 125, -hex)

   // => FF00FF


Converting and Saving Images
============================

This section describes how image files can be converted from one format to
another and saved to file. This is all accomplished using the `image->save`
method, which is described below.

.. member: image->convert(ext::string)
.. member:: image->convert(ext::string, -quality::integer= ?)

   Converts an image object to a new format. Requires a file extension as a
   string parameter which represents the new format the image is being converted
   to (e.g. ``'jpg'``, ``'gif'``). A ``-quality`` parameter specifies the image
   compression ratio (integer value of 1--100) used when saving to JPEG or GIF
   format.

.. member: image->save(path::string)
.. member:: image->save(path::string, -quality::integer= ?)

   Saves the image to a file in a format defined by the file extension.
   Automatically converts images when the extension of the image to save as
   differs from that of the original image. A ``-quality`` parameter specifies
   the image compression ratio (integer value of 1--100) used when saving to JPEG
   or GIF format.

.. member:: image->addComment(comment)

   Adds a file header comment to the image before it is saved. Passing a
   "null" parameter removes any existing comments.


Convert an Image File from One Format to Another
------------------------------------------------

Use the `image->convert` and `image->save` methods on an image object,
specifying the new format as part of the `image->convert` method::

   local(myImage) = image('/images/image.gif')
   #myImage->convert('JPG', -quality=100)
   #myImage->save('/images/image.jpg', -quality=100)


Automatically Convert the Format of an Image File
-------------------------------------------------

Use the `image->save` method on an image object, changing the image file
extension to the desired image format. A ``-quality`` parameter value of "100"
specifies that the resulting JPEG file will be saved at the highest quality
resolution::

   local(myImage) = image('/images/image.gif')
   #myImage->save('/images/image.jpg', -quality=100)


Save an Image Object to a File
------------------------------

Use the `image->save` method on an image object, specifying the desired image
name, path, and format::

   local(myImage) = image('/folder/image.jpg')
   #myImage->save('/images/image_copy.jpg')


Add a Comment to an Image File Header
-------------------------------------

Use the `image->addComment` method to add a comment to an image object before it
is saved to file. This comment is not displayed, but stored with the image file
information::

   local(myImage) = image('/images/image.gif')
   #myImage->addComment('This is a comment')
   #myImage->save(/images/image.gif')


Remove All Comments from an Image File Header
---------------------------------------------

Use the `image->addComment` method with a "null" parameter to remove all
comments from an image object before it is saved to file. The following code
adds a comment and then removes all comments. The result is an image with no
comments::

   local(myImage) = image('/images/image.gif')
   #myImage->addComment('This is a comment')
   #myImage->addComment(null)
   #myImage->save('/images/image.gif')


Images Manipulation Methods
===========================

Images can be transformed and manipulated using special `image` member methods.
These methods change the appearance of the image as it served to the client
browser. This includes methods for changing image size and orientation, applying
image effects, adding text to images, and merging images, which are described in
the following subsections.


Changing Image Size and Orientation
-----------------------------------

Lasso provides methods that allow you to scale, rotate, crop, and invert images.
These methods are defined below.

.. member:: image->scale(...)

   Scales an image to a specified size. Requires either a ``-width`` or
   ``-height`` parameter, which specify the new size of the image using either
   integer pixel values (e.g. "50") or string percentage values (e.g. "50%"). An
   optional ``-sample`` parameter indicates pixel sampling should be used so no
   additional colors will be added to the image. An optional ``-thumbnail``
   parameter optimizes the image for display on the web. If only one of the
   ``-width`` or ``-height`` is specified then the other value is calculated
   proportionally.

.. member: image->rotate(deg::integer)
.. member:: image->rotate(deg::integer, -bgColor=::string= ?)

   Rotates an image counterclockwise by the specified amount in degrees (integer
   value of 0--360). An optional ``-bgColor`` parameter specifies the hex
   color to fill the blank areas of the resulting image.

.. member:: image->crop(...)

   Crops the original image by cutting off extra pixels beyond the boundaries
   specified by the parameters. Requires ``-height`` and ``-width`` parameters
   which specify the pixel size of the resulting image, and ``-left`` and
   ``-right`` parameters specify the offset of the resulting image within the
   initial image.

.. member:: image->flipV()

   Creates a vertical mirror image by reflecting the pixels around the central
   X-axis.

.. member:: image->flipH()

   Creates a horizontal mirror image by reflecting the pixels around the central
   Y-axis.


Enlarge an Image
^^^^^^^^^^^^^^^^

Use the `image->scale` method on an image object. The following example enlarges
"image.jpg" to 225 X 225 pixels. The optional ``-sample`` parameter specifies
that pixel sampling should be used::

   local(myImage) = image('/images/image.jpg')
   #myImage->scale(-height=225, -width=225, -sample)
   #myImage->save('/images/image.jpg')


Shrink an Image
^^^^^^^^^^^^^^^

Use the `image->scale` method on an image object. The following example shrinks
"image.jpg" to 25 x 25 pixels. The optional ``-thumbnail`` parameter optimizes
the image for the web::

   local(myImage) = image('/images/image.jpg')
   #myImage->scale(-height=25, -width=25, -thumbnail)
   #myImage->save('/images/image.jpg')


Rotate an Image
^^^^^^^^^^^^^^^

Use the `image->rotate` method on an image object. The following example rotates
the image 60 degrees counterclockwise on top of a white background::

   local(myImage) = image('/images/image.jpg')
   #myImage->rotate(60, -bgColor='FFFFFF')
   #myImage->save('/images/image.jpg')


Crop an Image
^^^^^^^^^^^^^

Use the `image->crop` method on an image object. The example below crops 10
pixels off of each side of a 70 x 70 image::

   local(myImage) = image('/images/image.jpg')
   #myImage->crop(-left=10, -right=10, -width=50, -height=50)
   #myImage->save('/images/image.jpg')


Mirror an Image
^^^^^^^^^^^^^^^

Use the `image->flipV` method on an image object. The following example mirrors
the image vertically::

   local(myImage) = image('/images/image.jpg')
   #myImage->flipV
   #myImage->save('/images/image.jpg')


Applying Image Effects
----------------------

Lasso provides methods that allow you to add image effects by applying special
image filters. This includes color modulation, image noise enhancement,
sharpness controls, blur controls, contrast controls, and composite image
merging. These methods are described below.

.. member:: image->modulate(bright::integer, saturation::integer, hue::integer)

   Controls the brightness, saturation, and hue of an image. Brightness,
   saturation, and hue are controlled by three comma-delimited integer
   parameters, where 100 equals the original value.

.. member:: image->contrast(increase::boolean=true)

   Enhances the intensity differences between the lighter and darker elements of
   the image. Specify "false" to reduce the image contrast, otherwise the
   contrast is increased.

.. member:: image->blur(-angle::decimal)
.. member:: image->blur(-gaussian, -radius::decimal, -sigma::decimal)

   Applies either a motion or Gaussian blur to an image. To apply a motion blur,
   an ``-angle`` parameter with a decimal degree value must be specified to
   indicate the direction of the motion. To apply a Gaussian blur, a
   ``-gaussian`` keyword parameter must be specified in addition to ``-radius``
   and ``-sigma`` parameters that require decimal values. The ``-radius``
   parameter is the radius of the Gaussian in pixels, and ``-sigma`` is the
   standard deviation of the Gaussian in pixels. For reasonable results, the
   radius should be larger than the sigma.

.. member:: image->sharpen(\
      -radius::integer, \
      -sigma::integer, \
      -amount::decimal= ?, \
      -threshold::decimal= ?)

   Sharpens an image. Requires ``-radius`` and ``-sigma`` parameters that are
   integer values. The ``-radius`` parameter is the radius of the Gaussian sharp
   effect in pixels, and ``-sigma`` is the standard deviation of the Gaussian
   sharp effect in pixels. For reasonable results, the radius should be larger
   than the sigma. Optional ``-amount`` and ``-threshold`` parameters may be
   used to add an unsharp masking effect. ``-amount`` specifies the decimal
   percentage of the difference between the original and the blur image that is
   added back into the original, and ``-threshold`` specifies the threshold in
   decimal pixels needed to apply the difference amount.

.. member:: image->enhance()

   Applies a filter that improves the quality of a noisy, lower-quality image.


Adjust Brightness of an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->modulate` method on an image object and adjust the first integer
parameter, representing brightness. The following example increases the
brightness of an image by a factor of two::

   local(myImage) = image('/images/image.jpg')
   #myImage->modulate(200, 100, 100)
   #myImage->save('/images/image.jpg')


Adjust Color Saturation of an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->modulate` method on an image object and adjust the second
integer parameter, representing color saturation. The following example
decreases the color saturation of an image by 25%::

   local(myImage) = image('/images/image.jpg')
   #myImage->modulate(100, 75, 100)
   #myImage->save('/images/image.jpg')


Adjust Hue of an Image
^^^^^^^^^^^^^^^^^^^^^^

Use the `image->modulate` method on an image object and adjust the third integer
parameter, representing hue. The following example tints the image green by
increasing the hue value. Decreasing the hue value tints the image red::

   local(myImage) = image('/images/image.jpg')
   #myImage->modulate(100, 100, 175)
   #myImage->save('/images/image.jpg')


Adjust Contrast of an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->contrast` method on an image object. The first example increases
the contrast. The second example uses a "false" parameter value, which reduces
the contrast instead::

   local(myImage) = image('/images/image.jpg')
   #myImage->contrast
   #myImage->save('/images/image.jpg')

   local(myImage) = image('/images/image.jpg')
   #myImage->contrast(false)
   #myImage->save('/images/image.jpg')


Apply a Motion Blur to an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->blur` method on an image object. The following example applies a
motion blur at 20 degrees::

   local(myImage) = image('/images/image.jpg')
   #myImage->blur(-angle=20)
   #myImage->save('/images/image.jpg')


Apply a Gaussian Blur to an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->blur` method with the ``-gaussian`` parameter on an image
object. The following example applies a Gaussian blur with a radius of 15 pixels
and a standard deviation of 10 pixels::

   local(myImage) = image('/images/image.jpg')
   #myImage->blur(-radius=15, -sigma=10, -gaussian)
   #myImage->save('/images/image.jpg')


Sharpen an Image
^^^^^^^^^^^^^^^^

Use the `image->sharpen` method on an image object. The following example
applies a Gaussian sharp effect with a radius of 20 pixels and a standard
deviation of 10 pixels::

   local(myImage) = image('/images/image.jpg')
   #myImage->sharpen(-radius=20, -sigma=10)
   #myImage->save('/images/image.jpg')


Sharpen an Image with an Unsharp Mask Effect
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->sharpen` method with the ``-amount`` and ``-threshold``
parameters on an image object. The following example applies an unsharp mask
effect with a radius of 20 pixels and a standard deviation of 10 pixels::

   local(myImage) = image('/images/image.jpg')
   #myImage->sharpen(-radius=20, -sigma=10, -amount=50, -threshold=20)
   #myImage->save('/images/image.jpg')


Enhance a Low-Quality Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->enhance` method on an image object::

   local(myImage) = image('/images/image.jpg')
   #myImage->enhance
   #myImage->save('/images/image.jpg')


Adding Text to Images
---------------------

Lasso allows text to be overlaid on top of images using the `image->annotate`
method as described below.

.. member:: image->annotate(\
      annotation::string, \
      -left::integer, \
      -top::integer, \
      -font::string= ?, \
      -size::integer= ?, \
      -color::string= ?, \
      -aliased::boolean= ?)

   Overlays text onto an image. Requires a string value as a parameter, which
   is the text to be overlaid. Required ``-left`` and ``-top`` parameters
   specify the place of the text in pixel integers relative to the upper left
   corner of the image. An optional ``-font`` parameter specifies the name (with
   extension) and full path to a system font to be used for the text, and an
   optional ``-size`` parameter specifies the text size in integer pixels. An
   optional ``-color`` parameter specifies the text color as a hex string
   ("#FFCCDD"). An optional ``-aliased`` keyword parameter turns on text
   anti-aliasing.

.. note::
   The full hard drive path to the font must be used (e.g.
   ``-font='//Library/Fonts/Arial.ttf'``) when specifying a font. True Type
   ("\*.ttf"), and Type One ("\*.pfa", "\*.pfb") font types are officially
   supported.


Add Text to an Image
^^^^^^^^^^^^^^^^^^^^

Use the `image->annotate` method on an image object. The example below adds the
text "(c) 2013 LassoSoft" to the specified image::

   local(myImage) = image('/images/image.jpg')
   #myImage->annotate(
      '(c) 2003 LassoSoft',
      -left=5,
      -top=300,
      -font='/Library/Fonts/Arial.ttf',
      -size=8,
      -color='#000000',
      -aliased
   )
   #myImage->save('/images/image.jpg')


Merging Images
--------------

Lasso allows images to be merged using the `image->composite` method. This
method supports over 20 different composite methods, which are described in the
table below.

.. member:: image->composite(\
      second::image, \
      -op::string= ?, \
      -left::integer= ?, \
      -top::integer= ?)

   Composites a second image onto the current image. Requires two Lasso image
   objects to be composited. An ``-op`` parameter specifies the composite method
   that affects how the second image is applied to the first image (a list of
   operators is shown below). Optional ``-left`` and ``-top`` parameters specify
   the horizontal and vertical offset of the second image over the first in
   integer pixels (defaults to the upper left corner). An optional ``-opacity``
   parameter attenuates the opacity of the composited second image, where a
   value of "0" is fully opaque and "1.0" is fully transparent.

   The table below shows the various composite operators that can be specified
   by the ``-op`` parameter. The descriptions for each method are adapted from
   the ImageMagick web site.

   .. tabularcolumns:: lL

   .. _images-media-composite-operators:

   .. table:: Composite Image Tag Operators

      ================== =======================================================
      Composite Operator Description
      ================== =======================================================
      ``Over``           The result is the union of the two image shapes with
                         the composite image obscuring the image in the region
                         of overlap.
      ``In``             The result is the first image cut by the shape of the
                         second image. None of the second image data is included
                         in the result.
      ``Out``            The result is the second image cut by the shape of the
                         first image. None of the first image data is included
                         in the result.
      ``Plus``           The result is the sum of the raw image data with output
                         image color channels cropped to 255.
      ``Minus``          The result is the subtraction of the raw image data
                         with color channel underflow cropped to zero.
      ``Add``            The result is the sum of the raw image data with color
                         channel overflow channel wrapping around 255 to 0.
      ``Subtract``       The result is the subtraction of the raw image data
                         with color channel underflow wrapping around 0 to 255.
      ``Difference``     Returns the difference between two images. This is
                         useful for comparing two very similar images.
      ``Bumpmap``        The resulting image is shaded by the second image.
      ``CopyRed``        The resulting image is the red layer in the image
                         replaced with the red layer in the second image.
      ``CopyGreen``      The resulting image is the green layer in the image
                         replaced with the green layer in the second image.
      ``CopyBlue``       The resulting image is the blue layer in the image
                         replaced with the blue layer in the second image.
      ``CopyOpacity``    The resulting image is the opaque layer in the image
                         replaced with the opaque layer in the second image.
      ``Displace``       Displaces part of the first image where the second
                         image is overlaid.
      ``Threshold``      Only colors in the second image that are darker than
                         the colors in the first image are overlaid.
      ``Darken``         Only dark colors in the second image are overlaid.
      ``Lighten``        Only light colors in the second image are overlaid.
      ``Colorize``       Only base spectrum colors in the second image are
                         overlaid.
      ``Hue``            Only the hue of the second image is overlaid.
      ``Saturate``       Only the saturation of the second image is overlaid.
      ``Luminize``       Only the luminosity of the second image is overlaid.
      ``Modulate``       Has the effect of the ``Hue``, ``Saturate``, and
                         ``Luminize`` functions applied at the same time.
      ================== =======================================================


Overlay an Image On Top of Another Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->composite` method to add an image object to a second image
object. The following example adds "image2.jpg" offset by five pixels in the
upper left corner of "image1.jpg"::

   local(myImage1) = image('/images/image1.jpg')
   local(myImage2) = image('/images/image2.jpg')
   #myImage1->composite(#myImage2, -left=5, -top=5)
   #myImage1->save('/images/image1.jpg')


Add a Watermark to an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->composite` method with the ``-opacity`` parameter to add an
image object to a second image object. The following example adds a mostly
transparent version of "image2.jpg" to "image1.jpg"::

   local(myImage1) = image('/images/image1.jpg')
   local(myImage2) = image('/images/image2.jpg')
   #myImage1->composite(#myImage2, -opacity=0.75)
   #myImage1->save('/images/image1.jpg')


Shade Image with a Second Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->composite` method with the "Bumpmap" operator to shade an image
object over a second image object::

   local(myImage1) = image('/images/image1.jpg')
   local(myImage2) = image('/images/image2.jpg')
   #myImage1->composite(#myImage2, -op='Bumpmap')
   #myImage1->save('/images/image1.jpg')


Return the Pixel Difference Between Two Images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `image->composite` method with the "Difference" operator to return the
pixel difference between two defined image variables::

   local(myImage1) = image('/images/image1.jpg')
   local(myImage2) = image('/images/image2.jpg')
   #myImage1->composite(#myImage2, -op='Difference')
   #myImage1->save('/images/image1.jpg')


Extended ImageMagick Commands
=============================

For users who have experience using the ImageMagick command-line utility, Lasso
provides the `image->execute` method to allow advanced users to take advantage
of additional ImageMagick commands and functionality.

.. member:: image->execute()

   Execute ImageMagick commands. Provides direct access to the ImageMagick
   command-line interface. Supports the "composite", "mogrify", and "montage"
   commands. See the `ImageMagick Command-Line Tools documentation`_ for
   detailed descriptions of these commands and their corresponding parameters.


Execute an ImageMagick Command Using Lasso
------------------------------------------

Use the `image->execute` method on an image object, with the desired command as
the parameter. The following example shows the "mogrify" command adding a
distinctive blue border to an image::

   local(myImage) = image('/images/image.gif')
   #myImage->execute('mogrify -bordercolor blue -border=3x3')
   #myImage->save('/images/image.gif')


Serving Image and Media Files
=============================

This section discusses how to serve image and media files, including referencing
files within HTML pages and serving files separately via HTTP.


Referencing Within HTML Files
-----------------------------

The easiest way to serve images and media files is by simply referencing files
stored within the web server root using standard HTML tags such as ``<img>`` or
``<embed>``. The path to the image file can be calculated in the Lasso page or
stored within a database field. Since the specified file is ultimately served by
the web server application that is optimized for serving images and media files,
this is the most efficient way to serve images and media files.


Generate the Path to an Image or Media File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows a variable "company_name" that contains "LassoSoft".
This variable is used to construct a path to an image file stored within the
"images" folder named with the company name and "_logo.gif" to form the full
file path "/images/LassoSoft_logo.gif"::

   [local(company_name) = 'LassoSoft']
   <img src="/images/[#company_name]_logo.gif" />

::

   // => <img src="/images/LassoSoft_logo.gif" />

Using the same image path described above, the path to the image file is stored
within the variable "image_path" and then referenced in the HTML ``<img>`` tag::

   [local(company_name) = 'LassoSoft']
   [local(image_path)   = '/images/' + #company_name + '_logo.gif']
   <img src="[#image_path]" />

::

   // => <img src="/images/LassoSoft_logo.gif" />

The following example shows a variable "band_name" that contains "ArtOfNoise".
This variable is used to construct a path to sound files stored within the
"sounds" folder named with the band name and "|dot| mp3" to form the full file
path "/sounds/ArtOfNoise.mp3". The path to the sound file is stored within the
variable "sound_path" and then referenced in the HTML ``<a>`` tag::

   [local(band_name)  = 'ArtOfNoise']
   [local(sound_path) = '/images/' + #band_name + '.mp3']
   <a href="[#sound_path]">Download MP3</a>

::

   // => <a href="/sounds/ArtOfNoise.mp3">Art of Noise Song</a>


Serving Files via HTTP
----------------------

Lasso can also be used to serve image and media files rather than merely
referencing them by path. Files are served through Lasso using the
`web_response->sendFile` method or a combination of the
`web_response->replaceHeader` method and `web_response->includeBytes` method.
Lasso also includes an `image->data` method that automatically converts an image
object to a bytes object, allowing an edited image object to be output using
`web_response->sendFile` without it first being written to disk.

In order to serve an image or media file through Lasso the MIME type of the file
must first be determined. Often, this can be discovered by looking at the
configuration of the web server or web browser. The MIME type for a GIF is
:mimetype:`image/gif` and the MIME type for a JPEG is :mimetype:`image/jpeg`.

.. note::
   It is not recommended that you configure your web server application to
   process all "\*.gif" and "\*.jpg" files through Lasso. Lasso will attempt to
   interpret the binary data of the image file as Lasso code. Instead, use one
   of the procedures below to serve an image file from a path with a "|dot|
   lasso" extension.

.. member:: image->data()

   Converts an image object to a binary bytes object. This is useful for serving
   images to a browser without writing the image to file.


Serve an Image File
^^^^^^^^^^^^^^^^^^^

Use the `web_response->sendFile` method to set the MIME type of the image to be
served, and use the `image->data` method to get the binary data from an image
object. The `web_response->sendFile` method aborts the current response, so it
will be the last line of code to be processed. The following example shows a GIF
named "picture.gif" being served from an "images" folder::

   local(image) = image('/images/picture.gif')
   web_response->sendFile(#image->data, -type='image/gif')

Alternatively, you can use the `web_response->replaceHeader` method to set the
MIME type of the image to be served and use the `web_response->includeBytes`
method to include data from the image file. If using this method, verify that no
stray data is inadvertently added into the outgoing data buffer as it will
corrupt the output. This includes whitespace characters. The following example
shows a GIF named "picture.gif" being served from an "images" folder. It is the
only contents of this file being called by the client browser and calls abort to
avoid any data corruption::

   <?lasso
      web_response->replaceHeader('Content-Type'='image/gif')
      web_response->includeBytes('/images/picture.gif')
      abort
   ?>

If either of the code examples above is stored in a file named "image.lasso" at
the root of the web serving folder then the image could be accessed with the
following ``<img>`` tag::

   <img src="/image.lasso" />


Serve a Media File
^^^^^^^^^^^^^^^^^^

Use the `web_response->sendFile` method to set the MIME type of the file to be
served and pass it a :type:`file` object to include data from the media file.
The following example shows a sound file named "ArtOfNoise.mp3" being served
from a "sounds" folder::

   web_response->sendFile(
      file('/sounds/ArtOfNoise.mp3'),
      'ArtOfNoise.mp3',
      -type='audio/mp3'
   )

If the code above is stored in a file named "ArtOfNoise.lasso" at the root of
the web serving folder then the sound file could be accessed with the following
``<a>`` tag::

   <a href="/ArtOfNoise.lasso">Art of Noise Song</a>

This same technique can be used to serve media files of any type by designating
the appropriate MIME type in the ``-type`` option passed to the
`web_response->sendFile` method.


Limit Access to a File
^^^^^^^^^^^^^^^^^^^^^^

Since the Lasso page can process any Lasso code before serving the image it is
easy to create a file that generates an error if an unauthorized person tries to
access a file. The following code checks the `client_username` for the name
"John". If the current user is not named "John" then a file "error.gif" is
served instead of the desired "picture.gif" file. To completely limit access to
the files, they are being served from outside the web root of the web server so
that the files can't be loaded directly by a URL. In this example, the files are
being served from the "secret" folder which is at the root level of the file
system::

   if('John' == client_username) {
      web_response->sendFile(
         file('//secret/picture.gif'),
         'picture.gif',
         -type='image/gif'
      )
   else
      web_response->sendFile(
         file('/images/error.gif'),
         'picture.gif',
         -type='image/gif'
      )
   }

This same technique can be used to restrict access to any image or media file.

.. _supported image formats: http://www.imagemagick.org/script/formats.php#supported
.. _ImageMagick Command-Line Tools documentation: http://www.imagemagick.org/script/command-line-tools.php
