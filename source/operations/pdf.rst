:tocdepth: 3

.. _pdf:

************************
Portable Document Format
************************

Lasso provides support for creating :abbr:`PDF (Portable Document Format)`
files. The PDF file format is a widely accepted standard for electronic
documentation, and facilitates superb printer-quality documents from simple
graphs to complex forms such as tax forms, escrow documents, loan applications,
stock reports, and user manuals. See this page for more `information on PDF
technology`_.

.. note::
   The ``pdf_…`` methods in Lasso are implemented in LJAPI, and based on the
   iText Java library. For more information on the iText Java library, visit
   `<http://www.itextpdf.com/>`_.


Lasso and PDF Files
===================

PDF files are created in Lasso by using the :type:`pdf_doc` type, and calling
various member methods and other ``pdf_…`` methods to add data to the object.
The PDF is then written to file when the Lasso page containing all code is
served by the web server.


Create a Basic PDF File Using Lasso
-----------------------------------

The following shows an example of creating and outputting a PDF file named
"MyFile.pdf" using the ``pdf_…`` methods::

   local(my_file) = pdf_doc(
      -file='MyFile.pdf',
      -size='A4',
      -margin=(: 144.0, 144.0, 72.0, 72.0)
   )
   local(font) = pdf_font(-face='Helvetica', -size=36)
   local(text) = pdf_text('I am a PDF document', -font=#font)
   #my_file->add(#text)
   #my_file->close

In the example above, a variable named "my_file" is set to a :type:`pdf_doc`
type with a file name of "MyFile.pdf". A single font type is defined for the
document using the :type:`pdf_font` type. Then, the text "I am a PDF document"
is defined using the :type:`pdf_text` type, and added using the `pdf_doc->add`
member method. The PDF is then written to file upon execution of
``#my_file->close``. Since no path information was specified along with the file
name to the ``-file`` parameter, the file "MyFile.pdf" is created in the same
folder as the page whose code created it.

This chapter explains in detail how these and other methods are used to create
and edit PDF files. This chapter also shows how to output a PDF file to a client
browser within the context of a Lasso page, which is described in the
:ref:`pdf-serving-files` section.

.. note::
   When creating files, the user running the Lasso Server instance or
   command-line process must be allowed to write to the folder by the operating
   system. For more information, see the :ref:`files` chapter.


Reading PDF Files
=================

Lasso provides a type that allows existing PDF files to be read and manipulated.
A PDF file is read using :type:`pdf_read`. The file can then be inspected for
page count, page size, and the values of any embedded form elements. Pages from
the file can be placed within a new PDF file. A range of pages from the PDF file
can be saved as a new PDF file and encryption options can be added to the new
PDF file.

.. type:: pdf_read
.. method:: pdf_read(-file::string, -password::string= ?)

   Reads an existing PDF file into an object. Requires one parameter ``-file``
   which specifies the name of the PDF file to be read. Optional ``-password``
   parameter specifies the owner's password for the file.

.. member:: pdf_read->pageCount()::integer

   Returns the number of pages in the file.

.. member:: pdf_read->pageSize(page::integer= ?)::staticarray

   Returns the size of a page in the file as a staticarray of width and height.
   Optional integer parameter specifies which page in the PDF to return the size
   of and defaults to the first page.

.. member:: pdf_read->getHeaders()::map
.. member:: pdf_read->getHeaders(name::string)

   Returns a map of header elements from the PDF file, or the value for a
   specified header name.

.. member:: pdf_read->fieldNames()::array

   Returns an array of form elements embedded in the PDF file.

.. member:: pdf_read->fieldType(name::string)

   Returns the type of a single form element. Requires one parameter which is
   the name of the field element to be inspected. Types include "Checkbox",
   "Combobox", "List", "PushButton", "RadioButton", "Text", and "Signature".

.. member:: pdf_read->fieldValue(name::string)

   Returns the value of a single form element. Requires one parameter which is
   the name of the field element to be inspected.

.. member:: pdf_read->setFieldValue(field::string, value::string, -display::string= ?)

   Sets the value of a single form element. Requires two parameters: the name of
   a form element and a new value for the element. Optional ``-display``
   parameter specifies a display string for the element.

.. member:: pdf_read->importFDF(file::string, -noFields= ?, -noComments= ?)
.. member:: pdf_read->importFDF(data::bytes, -noFields= ?, -noComments= ?)

   Merges an FDF file into the current PDF file. Any form elements within the
   file will be populated with the values from the FDF file. Accepts a parameter
   that specifies the path to the FDF file. Alternately, accepts a bytes object
   containing the file data. Optional ``-noFields`` and ``-noComments``
   parameters prevent either fields or comments from being merged.

.. member:: pdf_read->exportFDF(path::string= ?)

   Exports an FDF file from the current PDF file. The FDF file will contain
   values for each of the form elements in the PDF file. If a parameter is
   specified then the FDF file will be written to that path. Otherwise, a byte
   object containing the data for the FDF file will be returned.

.. member:: pdf_read->javaScript()

   Returns the global document JavaScript action for the current PDF file.

.. member:: pdf_read->addJavaScript(script::string)

   Adds a JavaScript action to the current PDF file.

.. member:: pdf_read->save(file::string, \
      -encryptStrong= false, \
      -permissions= '', \
      -userPassword= '', \
      -ownerPassword= '')

   Saves a copy of the current PDF file. Requires one parameter which specifies
   the path to the file where the PDF file should be saved. Also accepts
   ``-userPassword``, ``-ownerPassword``, ``-encryptStrong``, and
   ``-permissions`` parameters. See the descriptions in the following
   documentation on the :type:`pdf_doc` type for more information about these
   parameters.

.. member:: pdf_read->setPageRange(to::string)

   Selects a range of pages to save into a new PDF file. Multiple ranges can be
   specified separated by commas. Ranges take the form "4-10" to specify a start
   and end page number. Optional "e" or "o" prefixes specify to only select even
   or odd pages. An optional "|bang| " prefix specifies a range of pages that
   should not be included. For example, "o4-10" would select the pages 5, 7, and
   9 while "1-10,!2-9" would select the pages 1 and 10.

.. tip::
   A pdf_read object can be used in concert with the `pdf_doc->insertPage`
   method described below to insert pages from an existing PDF file into a new
   PDF file.

.. |bang| unicode:: 0x21
   :trim:


Read In an Existing PDF File
----------------------------

In order to work with an existing PDF file, it must first be read in as a
pdf_read object. ::

   local(old_pdf) = pdf_read('/documents/somepdf.pdf')


Determine Attributes of an Existing PDF File
--------------------------------------------

The number of pages and the dimensions of an existing PDF file can be returned
using the `pdf_read->pageCount` and `pdf_read->pageSize` methods. ::

   local(old_pdf) = pdf_read('/documents/somepdf.pdf')
   'Number of pages: ' + #old_pdf->pageCount + '<br />\n'
   'Page size: ' + #old_pdf->pageSize(1)

   // =>
   // Number of pages: 12<br />
   // Page size: staticarray(0.000000, 792.000000, 612.000000, 792.000000)


Creating PDF Files
==================

PDF files are initialized and created using the :type:`pdf_doc` type. This is
the basic type used to create PDF documents with Lasso, and is used in concert
with all methods described in this chapter.

.. type:: pdf_doc
.. method:: pdf_doc(...)

   Initializes a PDF file. Uses optional parameters that set the basic
   specifications for the file being created. Data is added to the object using
   member methods, which are described throughout this chapter. The table below
   outlines the optional parameters that can be passed to a `pdf_doc` creator
   method.

   :param -file:
      Defines the file name and path of the PDF file. If omitted, the PDF
      file is created in RAM (see the :ref:`pdf-serving-files` section for more
      information). If a file name is specified without a folder path, the file
      is created in the same location as the Lasso page containing the ``pdf_…``
      methods.
   :param -size:
      Define the page size of the file. Values for this parameter are standard
      print sizes, and can be "A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7",
      "A8", "A9", "A10", "B0", "B1", "B2", "B3", "B4", "B5", "ARCH_A", "ARCH_B",
      "ARCH_C", "ARCH_D", "ARCH_E", "FLSA", "FLSE", "HALFLETTER", "LEDGER",
      "LEGAL", "LETTER", "NOTE", and "TABLOID". Defaults to "A4". Optional.
   :param -height:
      Defines a custom page height for the file. Accepts an integer value which
      represents the size in points. This can be used in combination with the
      ``-width`` parameter instead of the ``-size`` parameter. Optional.
   :param -width:
      Defines a custom page width for the file. Requires an integer value which
      represents the size in points. This can be used in combination with the
      ``-height`` parameter instead of the ``-size`` parameter. Optional.
   :param -margins:
      Defines the margin size for the page. Requires an array of four decimal
      values which define the left, right, top, and bottom margins for the page
      ( :samp:`{left}, {right}, {top}, {bottom}` ). Optional.
   :param -color:
      Defines the initial text color of the PDF file. Requires a hex color
      string. Defaults to "#000000" if not specified. Optional.
   :param -useDate:
      Adds the current date and time to the document header. Optional.
   :param -noCompress:
      Produces a PDF without compression to allow PDF code to be viewed. PDF
      files are compressed by default if not used. Optional.
   :param -pageNo:
      Sets the starting page number for the PDF file. Requires an integer value,
      which is the page number of the first page. Optional.
   :param -pageHeader:
      Sets text that will be displayed at the top of each page in the PDF.
      Requires a text string as a value. Optional.
   :param 'Header'='Content':
      Adds defined document headers to the PDF file. ``'Header'`` is replaced
      with the name of the document header (e.g. "Title", "Author"), and
      ``'Content'`` is replaced with the header value. Optional.
   :param -userPassword:
      Specifies a password that will be required to open the resulting PDF in a
      reader application including Adobe Reader, Preview, etc. The file will be
      encrypted if this parameter is specified. Optional.
   :param -ownerPassword:
      Specifies a password that will be required to open the resulting PDF in
      an editor including Acrobat Pro, Lasso's :type:`pdf_read` type, etc. The
      file will be encrypted if this parameter is specified. Optional.
   :param -encryptStrong:
      If specified then strong 128-bit encryption is used rather than 40-bit
      encryption. Note that encryption will only be performed if either
      ``-userPassword`` or ``-ownerPassword`` is specified. Optional.
   :param -permissions:
      A comma-delimited list of permissions for the PDF file. Values include
      "Print", "Modify", "Copy", or "Annotate". Four additional options are
      available only if ``-encryptStrong`` is used: "FillIn", "Assemble",
      "ScreenReader", and "DegradedPrint". Optional.

The examples below show creating basic pdf_doc objects, though these objects
contain little or no data. Calling `pdf_doc->close` on an object with no data
will have no result, and no PDF file will be created. Various types of data can
be added to these objects using the methods described in the remainder of this
chapter.


Start a Basic PDF File
----------------------

Use the :type:`pdf_doc` type to create a PDF file which could eventually be
saved to a hard drive location on the machine running Lasso. Use the ``-file``
parameter to define the location and file name, and the ``-size`` parameter to
define a predefined standard size. This basic example creates a pdf_doc object
that is ready to have data added to the first page::

   local(my_file) = pdf_doc(-file='my_file.pdf', -size='A4')


Start a PDF File with a Custom Page Size
----------------------------------------

Use the :type:`pdf_doc` type with the ``-height`` and ``-width`` parameters to
define a custom page size in points. One inch is equal to 72 points. ::

   local(my_file) = pdf_doc(-file='MyFile.pdf', -height='648.0', -width='468.0')


Start a PDF File with Custom Margins
------------------------------------

Use the :type:`pdf_doc` type with the ``-margins`` parameter to define custom
page margins (in points). The following example adds a margin of 72 points (one
inch) to the left and right sides of the page, but adds no margin to the top and
bottom. This example also adds the date and time of creation to the document
header using the ``-useDate`` parameter::

   local(my_file) = pdf_doc(
      -file='MyFile.pdf',
      -size='A4',
      -margins=(: 72.0, 72.0, 0.0, 0.0),
      -useDate
   )


Start an Uncompressed PDF File
------------------------------

Use the :type:`pdf_doc` type with the ``-noCompress`` parameter. ::

   local(my_file) = pdf_doc(-file='MyFile.pdf', -size='A4', -noCompress)


Start a PDF File with Custom Document Headers
---------------------------------------------

Use the :type:`pdf_doc` type with appropriate header. ::

   local(my_file) = PDF_Doc(
      -file='MyFile.pdf',
      -size='A4',
      -title='My PDF File',
      -subject='How to create PDF files',
      -author='John Doe'
   )


Adding Content to PDFs
======================

There are several different types of data that can be added to a PDF file. Many
of these types are first defined as objects using methods such as `pdf_text`,
`pdf_list`, `pdf_image`, `pdf_table`, or `pdf_barcode` and then added to a
pdf_doc object using the `pdf_doc->add` member method. Each type is described
separately in subsequent sections of this chapter.

.. member:: pdf_doc->add(object, ...)

   Adds a PDF content object to a file. This can be used to add
   :type:`pdf_text`, :type:`pdf_list`, :type:`pdf_image`, :type:`pdf_table`, or
   :type:`pdf_barcode` objects. If no position information is specified then the
   object is added to the flow of the page, otherwise it is drawn at the
   specified location. Requires one parameter, which is the object to be added.
   Optional parameters are described below.

   :param -align:
      Sets the alignment of the object in the page (``'Left'``, ``'Center'``, or
      ``'Right'``). Defaults to "Left". Works only for pdf_image and pdf_barcode
      objects. Optional.
   :param -wrap:
      Keyword parameter specifies that text should flow around the embedded
      object. Works only for pdf_image and pdf_barcode objects. Optional.
   :param -left:
      Specifies the placement of the object relative to the left side of the
      document. Requires a decimal value, which is the placement offset in
      points. Works only for pdf_image and pdf_barcode objects. Optional.
   :param -top:
      Specifies the placement of the object relative to the top of the document.
      Requires a decimal value, which is the placement offset in points. Works
      only for pdf_image and pdf_barcode objects. Optional.
   :param -height:
      Scales the object to the specified height. Requires a decimal value which
      is the desired object height in points. Works only for pdf_image and
      pdf_barcode objects. Optional.
   :param -width:
      Scales the object to the specified width. Requires a decimal value which
      is the desired object width in points. Works only for pdf_image and
      pdf_barcode objects. Optional.

For examples of using the `pdf_doc->add` method to add text, image, table, and
barcode PDF objects to a pdf_doc object, see the corresponding sections in this
chapter.

.. member:: pdf_doc->getVerticalPosition()

   Returns the current vertical position where text will next be inserted on the
   page.


Adding Pages
------------

If the content of a PDF file will span more than one page, additional pages can
be added using special :type:`pdf_doc` member methods. These methods signal
where pages start and stop within the flow of the Lasso PDF creation methods.

.. member:: pdf_doc->addPage()

   Adds additional blank pages to the pdf_doc object. When used, this method
   ends in the current page and starts a new page. Note that a new page will not
   be added if there is no content on the current page.

   The following example ends a preceding page, and starts a new page::

      #my_file->add('Thus, ends the discussion on page 1.')
      #my_file->addPage
      #my_file->add('On page 2, we will discuss something else.')

.. member:: pdf_doc->addChapter(text::string, -number::integer, -hideNumber= ?)
.. member:: pdf_doc->addChapter(text::pdf_text, -number::integer, -hideNumber= ?)

   Adds a page with a named chapter title (and bookmark) to a pdf_doc object.
   Requires a text string or pdf_text object as a parameter, which specifies the
   chapter title. An additional ``-number`` parameter sets an integer chapter
   number for the chapter. An optional ``-hideNumber`` parameter specifies that
   no number will be shown.

   The following example adds a page with the text "30. Important Chapter" to
   the pdf_doc object with a defined chapter number of 30::

      #my_file->addChapter(pdf_text('Important Chapter'), -number=30)

.. member:: pdf_doc->setPageNumber(page::integer)

   Sets a page number for a new page. Requires an integer value.

   The following example sets a page number of 5 for the current page::

      #my_file->setPageNumber(5)

.. member:: pdf_doc->getPageNumber()::integer

   Returns the current page number.

   The following example returns a page number of 1 when used within the first
   page of the file::

      #my_file->getPageNumber
      // => 1


Adding Pages from Existing PDFs
-------------------------------

Pages in existing PDF files can be added to a pdf_doc object using the
:type:`pdf_read` type. This type makes it possible to use existing PDF files
as templates.

.. note::
   Lasso cannot change existing text or graphics that are contained within a PDF
   file read in using `pdf_read`. Instead, Lasso is able to overlay text,
   graphics, and other elements on the PDF.

Once an existing PDF file has been read in as a Lasso object using `pdf_read`,
it may be added to a pdf_doc object using the `pdf-doc->insertPage` method.

.. member:: pdf_doc->insertPage(pdf::pdf_read, number::integer, ...)

   Inserts a page from a pdf_read object into a pdf_doc object. Requires a
   reference to a pdf_read object, followed by a comma and the number of the
   page to insert. This method has many optional parameters for specifying how
   an existing page should be inserted into a pdf_doc object. These parameters
   are explained below.

   :param -newPage:
      Keyword parameter specifying that the new page should be appended at the
      end of the file. Otherwise the page is drawn over the first page in
      the pdf_doc object by default.
   :param -top:
      If the page being inserted is shorter than the current pages in the
      pdf_doc object, this parameter may be used to specify the offset of the
      new page from the top of the current page frame in points.
   :param -left:
      If the page being inserted is not as wide the current pages in the pdf_doc
      object, this parameter may be used to specify the offset of the new page
      from the left of the current page frame in points.
   :param -width:
      Scales the inserted page by width. Requires either a point width value, or
      a percentage string (e.g. '50%').
   :param -height:
      Scales the inserted page by height. Requires either a point height value,
      or a percentage string (e.g. '50%').


Insert an Existing Page Into a New PDF File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->insertPage` method with a defined pdf_read object. The example
below makes the first page of "somepdf.pdf" the first page of the pdf_doc
object. Content may then be overlaid on top of the new page using the methods
described in the rest of this chapter::

   local(new_pdf) = pdf_doc(-file='MyFile.pdf', -size='A4')
   local(old_pdf) = pdf_read('/documents/somepdf.pdf')
   #new_pdf->insertPage(#old_pdf, 1)


Insert an Existing Page at End of a New PDF File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->insertPage` method with the optional ``-newPage`` parameter.
The example below adds the first page of the "somepdf.pdf" PDF after all
existing pages in the pdf_doc object::

   local(new_pdf) = pdf_doc(-file='MyFile.pdf', -size='A4')
   local(old_pdf) = pdf_read('/documents/somepdf.pdf')
   #new_pdf->insertPage(#old_pdf, 1, -newPage)


Position an Inserted Page
^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->insertPage` method with the optional ``-top`` and/or ``-left``
parameters. The example below places the inserted page 50 points away from the
top and left sides of the new document page frame::

   local(new_pdf) = pdf_doc(-file='MyFile.pdf', -size='A4')
   local(old_pdf) = pdf_read('/documents/somepdf.pdf')
   #new_pdf->insertPage(#old_pdf, 1, -top=50, -left=50)


Accessing PDF File Information
==============================

Parameter values of a pdf_doc object can be returned using special accessor
methods. These methods return specific values such as the page size, margin
size, or the value of any other pdf_doc data members described in the previous
section. All PDF accessor methods are defined below.

.. member:: pdf_doc->getMargins()::staticarray

   Returns the current page margins as a staticarray :samp:`(: {left, right,
   top, bottom})`.

.. member:: pdf_doc->getSize()::staticarray

   Returns the current page size as a staticarray of width and height point
   values :samp:`(: {width, height})`.

.. member:: pdf_doc->getColor()::string

   Returns the current color as a hex string.

.. member:: pdf_doc->getHeaders()

   Returns all document headers as a map object in the form
   ``map('header1' = 'content1', 'header2' = 'content2', ...)``.

.. member:: pdf_doc->setFont(font::pdf_font)

   Sets a font for all following text. The value is a pdf_font object.


Return PDF Page Margins
-----------------------

Use the `pdf_doc->getMargins` method. The following example returns the current
margins of a defined pdf_doc object::

   #my_file->getMargins
   // => staticarray(72.0, 72.0, 72.0, 72.0)


Return PDF Page Size
--------------------

Use the `pdf_doc->getSize` method. The following example returns the current
sizes of a defined pdf_doc object::

   #my_file->getSize
   // => staticarray(595, 842)


Return PDF Base Font Color
--------------------------

Use the `pdf_doc->getColor` method. The following example returns the base font
color of a defined pdf_doc object::

   #my_file->getColor
   // => #333333


Saving PDF Files
================

Once a pdf_doc object has been filled with the desired content, the
`pdf_doc->close` method must be used to signal that the PDF file is finished and
is ready to be written to file or served to a visitor's browser.

.. member:: pdf_doc->close()

   Closes a pdf_doc object and commits it to file after all desired data has
   been added to it. Additional data may not be added to the specified object
   after this method is called.


Close a PDF File
----------------

Use the `pdf_doc->close` method after all desired modifications have been
performed on the pdf_doc object. ::

   local(my_file) = pdf_doc(
      -file='MyFile.pdf',
      -size='A4',
      -margins=(: 144.0, 144.0, 72.0, 72.0)
   )
   local(font) = pdf_font(-face='Helvetica', -size=36)
   local(text) = pdf_text('I am a PDF document', -font=#font)
   #my_file->add(#text)
   #my_file->close


.. _pdf-creating-text-content:

Creating Text Content
=====================

Text content is the most basic type of data within a PDF file. PDF text is first
defined as a pdf_text object, and then added to a pdf_doc object using the
`pdf_doc->add` method.

A pdf_text object may be positioned within the current PDF page using the
``-left`` and ``-top`` parameters of the `pdf_doc->add` method. Otherwise, if no
positioning parameters are specified, the text will be added to the top left
corner of the page by default.


.. _pdf-using-fonts:

Setting Fonts
-------------

Before adding text, it is important to first define the font and style for the
text to determine how it will appear. This is done using the :type:`pdf_font`
type.

.. type:: pdf_font
.. method:: pdf_font(\
      -face= ?, \
      -file= ?, \
      -size= ?, \
      -color= ?, \
      -encoding::string= ?, \
      -embed= ?)

   Stores all the specifications for a font style. This includes font family,
   size, style, and color. Parameters are used with the `pdf_font` creator
   method that define the font family, size, color, and specifications. The
   following parameters may be used with the `pdf_font` creator method.

   :param -face:
      Specifies the font by its family name. Allowed font names are "Courier",
      "Courier-Bold", "Courier-BoldOblique", "Courier-Oblique", "Helvetica",
      "Helvetica-Bold", "Helvetica-BoldOblique", "Helvetica-Oblique", "Symbol",
      "Times-Roman", "Times-Bold", "Times-BoldItalic", "Times-Italic", and
      "ZapfDingbats". Optional.
   :param -file:
      Uses a font from a local font file. The file name and path to the font
      must be specified (e.g. "/Fonts/Courier.ttf"). This parameter may be used
      instead of the ``-face`` parameter. Optional.
   :param -size:
      Sets the font size in points. Requires an integer point value as a
      parameter (e.g. "14"). Optional.
   :param -color:
      Sets the font color. Requires a hex color string as a parameter (e.g.
      "#550000"). Defaults to "#000000" if not specified. Optional.
   :param -encoding:
      Sets the desired font encoding. The font encoding defaults to "CP1252" if
      not specified. TrueType fonts can be asked to return an array of supported
      encodings via the `pdf_font->getSupportedEncodings` method. Optional.
   :param -embed:
      Embeds the fonts used within the PDF file as opposed to relying on the
      client PDF reader for font information. Optional.

The following examples show how to set variables as pdf_font objects that define
the font styles to be used with a pdf_text object.


Set a Basic Font Style
^^^^^^^^^^^^^^^^^^^^^^

Set a variable as a pdf_font object. The following example sets a font style to
be a standard "Helvetica" font with a size of 14 points. The font color is also
set to green::

   local(my_font) = pdf_font(-face='Helvetica', -size=14, -color='#005500')

Individual parameters may be viewed and changed in a pdf_font object using
:type:`pdf_font` member methods. These parameters are most useful for retrieving
and setting information about a pdf_font object that was defined using the
``-file`` parameter, and are summarized below.

.. member:: pdf_font->setFace(face::string)

   Changes the font face of the pdf_font object to one of the allowed font
   names.

.. member:: pdf_font->setColor(color::string)
.. member:: pdf_font->setColor(color::pdf_color)

   Changes the font color of the pdf_font object.

.. member:: pdf_font->setSize(size::integer)

   Changes the font size of the pdf_font object.

.. member:: pdf_font->setEncoding(encoding::string)

   Changes the encoding of the pdf_font object.

.. member:: pdf_font->setUnderline(on::boolean=true)

   Sets or unsets the pdf_font object style to underlined.

.. member:: pdf_font->setBold(on::boolean=true)

   Sets or unsets the pdf_font object style to bold.

.. member:: pdf_font->setItalic(on::boolean=true)

   Sets or unsets the pdf_font object style to italic.

.. member:: pdf_font->getFace()

   Returns the current font face of a pdf_font object.

.. member:: pdf_font->getColor()

   Returns the current font color of a pdf_font object.

.. member:: pdf_font->getSize()

   Returns the current font size of a pdf_font object.

.. member:: pdf_font->getEncoding()

   Returns the current encoding of a pdf_font object.

.. member:: pdf_font->getPSFontName()

   Returns the exact PostScript font name of the current font of a pdf_font
   object, e.g. "AdobeCorIDMinBd".

.. member:: pdf_font->isTrueType()

   Returns "true" if the current font is a TrueType font.

.. member:: pdf_font->getSupportedEncodings()

   Returns an array of all supported encodings for a current TrueType font face,
   e.g. "array('1252 Latin 1', '1253 Greek')".

.. member:: pdf_font->getFullFontName()

   Returns the full TrueType name of the current font of a pdf_font object (e.g.
   "Comic Sans", "MS Negreta").

.. member:: pdf_font->textWidth(text::string)

   Returns an integer value representing how wide (in pixels) the text would be
   using the current pdf_font object. Requires a string value that is the text
   for which the width is desired.


Change a Font Face
^^^^^^^^^^^^^^^^^^

Use the `pdf_font->setFace` method. The following example sets a defined
pdf_font object to a standard "Courier" font::

   #my_font->setFace('Courier')


Change a Font Color
^^^^^^^^^^^^^^^^^^^

Use the `pdf_font->setColor` method. The following example sets a defined
pdf_font object to the color red::

   #my_font->setColor('#990000')


Underline a Font
^^^^^^^^^^^^^^^^

Use the `pdf_font->setUnderline` method. The following example sets a predefined
pdf_font object to use an underlined style::

   #my_font->setUnderline


Return a Font Face
^^^^^^^^^^^^^^^^^^

Use the `pdf_font->getFace` method. The following example returns the current
font face of a defined pdf_font object::

   #my_font->getFace
   // => Courier


Return a Font Encoding
^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_font->getEncoding` method. The following example returns the
encoding of the current font face of a defined pdf_font object::

   #my_font->getEncoding
   // => Cp1252


Adding Text
-----------

PDF text content is constructed using the :type:`pdf_text` type, which is then
added to a pdf_doc object using the `pdf_doc->add` method. The `pdf_text`
constructor method and parameters are described below.

.. type:: pdf_text
.. method:: pdf_text(text::string, ...)

   Creates a text object to be added to a pdf_doc object. The constructor method
   requires the text string to be added to the PDF file as the first parameter.
   Optional parameters are listed below.

   :param -type:
      Specifies the text type. This can be "Chunk", "Phrase", or "Paragraph".
      Different parameters are available for each of these types, as described
      below. Defaults to the "Paragraph" type if no ``-type`` parameter is
      specified. Optional.
   :param -color:
      Sets the font color. Requires a hex color string as a parameter (e.g.
      "#550000"). Defaults to "#000000" if not specified. Optional.
   :param -backgroundColor:
      Sets the text background color. Require a hex color string as a parameter
      (e.g. "#550000"). Optional.
   :param -underline:
      Keyword parameter underlines the text. Optional.
   :param -textRise:
      Sets the baseline shift for superscript. Requires a decimal value that
      specifies the text rise in points. Optional.
   :param -font:
      Sets the font for the specified text using a pdf_font object. The font
      defaults to the current inherited font if no ``-font`` parameter is
      specified. Optional.
   :param -anchor:
      Links the specified text to a URL. The value of the parameter is the URL
      string (e.g. :ref:`!http://www.example.com`). Optional.
   :param -name:
      Sets the name of an anchor destination within a page. The value of the
      parameter is the anchor name (e.g. "Name"). Optional.
   :param -goTo:
      Links the specified text to a local anchor destination to go to. The value
      of the parameter is the local anchor name (e.g. "Name"). Optional.
   :param -file:
      Links the specified text to a PDF file. The value of the parameter is a
      PDF file name (e.g. "Somefile.pdf"). The ``-goTo`` parameter can be used
      concurrently to specify an anchor name within the destination file.
      Optional.
   :param -leading:
      Sets the leading space in points (the space above each line of text),
      requires a decimal value. For "Phrase" and "Paragraph" types only.
   :param -align:
      Sets the alignment of the text in the page (``'Left'``, ``'Center'``, or
      ``'Right'``). Optional.
   :param -indentLeft:
      Sets the left indent of the text object. Requires a decimal value which is
      the number of points to indent the text. Optional. Available for
      "Paragraph" types only.
   :param -indentRight:
      Sets the right indent of the text object. Requires a decimal value which
      is the number of points to indent the text. Optional. Available for
      "Paragraph" types only.

The following examples show how to add text to a defined PDF variable named
"my_file" that has been initialized previously using the `pdf_doc` method.


Add a Chunk of Text
^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_text` type with the ``-type='Chunk'`` parameter. The
following example adds the text "LassoSoft" to the pdf_doc object with a
predefined font. The text is positioned in the top left corner of the page by
default::

   local(text) = pdf_text('LassoSoft', -type='Chunk', -font=#my_font)
   #my_file->add(#text)


Add a Paragraph of Text
^^^^^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_text` type with the ``-type='Paragraph'`` parameter. The
following example adds three sentences of text to the pdf_doc object with a
predefined font::

   local(text) = pdf_text(
      "The mysterious file cabinet in orbit has been successfully lassoed. The \
         file cabinet had been traveling at a velocity of 300 meters per \
         second. Top scientists suspect that the cabinet had been in orbit for \
         some time.",
      -type='Paragraph',
      -font=#my_font,
      -leading=10.0,
      -indentLeft=20.0
   )
   #my_file->add(#text)


Add a Linked Phrase
^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_text` type with the ``-anchor`` parameter. The following
example adds the text "Click here to go somewhere" to the pdf_doc object with a
predefined font, and links the phrase to :ref:`!http://www.example.com`::

   local(text) = pdf_text(
      "Click here to go somewhere",
      -type='Chunk',
      -font=#my_font,
      -anchor='http://www.example.com',
      -underline
   )
   #my_file->add(#text, -left=100.0, -top=100.0)


Adding Floating Text
--------------------

Instead of adding text to the flow of the page, text can also be positioned on a
page using the `pdf_doc->drawText` method. The `pdf_doc->drawText` method
accepts coordinates that allow the text to be placed at an absolute position on
the page.

.. member:: pdf_doc->drawText(text::string, \
      -font= ?, \
      -alignment= ?, \
      -leading::decimal= ?, \
      -rotate::decimal= ?, \
      -left::integer= ?, \
      -top::integer= ?, \
      -width::integer= ?, \
      -height::integer= ?)

   Adds specified text that is positioned on a page using point coordinates. An
   optional ``-leading`` parameter (decimal value) sets the text leading space
   in points (the space above each line of the text). A ``-left`` parameter
   specifies the placement of the left side of the text from the left side of
   the page in points, and a ``-top`` parameter specifies the placement of the
   bottom of the image from the bottom of the page in points (decimal value).

   .. note::
      The `pdf_doc->drawText` method is a graphics operation. It relies on the
      fill color set using the `pdf_doc->setColor` method. The color of the
      ``-font`` parameter will not be recognized.


Add Floating Text
^^^^^^^^^^^^^^^^^

Use the `pdf_doc->drawText` method. The following example adds the text "Some
floating text" to the pdf_doc object with a predefined font at the coordinates
specified in the ``-top`` and ``-left`` parameters. The coordinates represent
the distance in points from the lower and left sides of the page::

   #my_file->drawText('Some floating text',
      -font=#my_font,
      -left=144.0,
      -top=480.0
   )


Adding Lists
------------

A list of items can be constructed using the :type:`pdf_list` type, which can be
added to a pdf_doc object. The `pdf_list` constructor method and parameters are
described below.

.. type:: pdf_list
.. method:: pdf_list(...)

   Creates a list object to be added to a pdf_doc object. Text list items are
   added to this object using the `pdf_list->add` method. Optional parameters
   for this object are described in the table below.

   :param -format:
      Specifies whether the list is numbered, lettered, or bulleted. Requires a
      value of ``'Number'``, ``'Letter'``, ``'Bullet'``. Defaults to
      "Bullet" if no ``-format`` parameter is specified. Optional.
   :param -bullet:
      Specifies a custom character to use as the bullet character. Requires a
      character as a parameter (e.g. ``'x'``). Defaults to the empty string if
      not specified. Optional.
   :param -indent:
      Sets the space between the bullet and the list item. Requires a decimal or
      integer parameter which is the width of the indentation in points.
      Optional.
   :param -font:
      Sets the font for the specified text using a pdf_font object. The font
      defaults to the current inherited font if no ``-font`` parameter is
      specified.
   :param -align:
      Sets the alignment of the list in the page (``'Left'``, ``'Center'``, or
      ``'Right'``). Optional.
   :param -color:
      Sets the font color. Requires a hex color string as a parameter (e.g.
      ``'#550000'``). Defaults to "#000000" if not used. Optional.
   :param -backgroundColor:
      Sets the text background color. Require a hex color string as a parameter
      (e.g. ``'#550000'``). Optional.
   :param -leading:
      Sets the list leading space in points (the space above
      each line of text), requires a decimal value. Optional.

.. member:: pdf_list->add(text::string)
.. member:: pdf_list->add(text::pdf_text)

   Add objects to the list. Requires a text string or a pdf_text object as a
   parameter.


Add a Numbered List
^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_list` type with the ``-format='Number'`` parameter to define
the list, and the `pdf_list->add` method to add items to the list. The example
below creates a numbered list with three items::

   local(list) = pdf_list(-format='Number', -align='Center', -font=#my_font)
   #list->add('This is item one')
   #list->add('This is item two')
   #list->add('This is item three')
   #my_file->add(#list)


Add a Bulleted List
^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_list` type with the ``-format='Bullet'`` parameter to define
the list, and the `pdf_list->add` method to add items to the list. The example
below adds a bulleted list with four items, where a hyphen (``-``) is used as
the bullet character::

   local(list) = pdf_list(-format='Bullet', -bullet='-', -font=#my_font)
   #list->add('This is item one')
   #list->add('This is item two')
   #list->add('This is item three')
   #list->add('This is item four')
   #my_file->add(#list)


Special Characters
------------------

When adding text to a pdf_doc object, escape sequences can be used to insert
special characters such as line breaks, tabs, and more. These characters are
summarized in the table below.

.. tabularcolumns:: lL

.. _pdf-escape-sequences:

.. table:: Supported PDF Escape Sequences

   =============== =============================================================
   Escape Sequence Description
   =============== =============================================================
   ``\n``          line break (OS X and Linux)
   ``\r\n``        line break (Windows)
   ``\t``          tab
   ``\"``          double quote
   ``\'``          single quote
   ``\\``          backslash
   =============== =============================================================


Use Special Characters in a Text String
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example shows how to use special characters within a pdf_doc text
object::

   #my_file->add('\\ \t \'Single Quotes\', \"Double Quotes\" ')


Creating and Using Forms
========================

Forms can be created in PDF files for submitting information to a website. PDF
forms use the same attributes as HTML forms, making them useful for submitting
information to a website in place of an HTML form. This section describes how to
create form elements within a PDF file, and also how PDF forms can be used to
submit data to a Lasso-enabled database.

.. note::
   Due to the iText implementation of PDF support in Lasso, created PDF files
   may contain only one form.


Creating Forms
--------------

Form elements are created in pdf_doc objects using :type:`pdf_doc` form member
methods which are described below.

.. member:: pdf_doc->addTextField(\
      name::string, \
      value::string, \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a text field to a form. Requires the first parameter to specify the name
   of the text field, and the second parameter to specify the default value
   entered. An optional ``-font`` parameter can be used to specify a pdf_font
   object for the font of the text.

.. member:: pdf_doc->addPasswordField(\
      name::string, \
      value::string, \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a password field to a form. Requires the first parameter to specify the
   name of the password field, and the second parameter to specify the default
   value entered. An optional ``-font`` parameter can be used to specify a
   pdf_font object for the font of the text.

.. member:: pdf_doc->addTextArea(\
      name::string, \
      value::string, \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a text area to a form. Requires the first parameter to specify the name
   of the text area, and the second parameter to specify the default value
   entered. An optional ``-font`` parameter can be used to specify a pdf_font
   object for the font of the text.

.. member:: pdf_doc->addCheckBox(\
      name::string, \
      value::string, \
      -left, \
      -top, \
      -width, \
      -height, \
      -checked::boolean= ?)

   Adds a checkbox to a form. Requires the first parameter to specify the name
   of the checkbox, and the second parameter to specify the value for the
   checkbox. An optional ``-checked`` parameter specifies that the checkbox is
   checked by default.

.. member:: pdf_doc->addRadioGroup(name::string)

   Adds a radio button group to a form. Requires a parameter specifying the name
   of the radio button group. Radio buttons must be assigned to the group using
   the `pdf_doc->addRadioButton` method.

.. member:: pdf_doc->addRadioButton(\
      group::string, \
      value::string, \
      -left, \
      -top, \
      -width, \
      -height)

   Adds a radio button to a form. Requires the first parameter to specify the
   name of the radio button group, and the second parameter to specify the value
   of the radio button.

.. member:: pdf_doc->addComboBox(\
      name::string, \
      values::trait_forEach, \
      -default::string= ?, \
      -editable::boolean= ?, \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a drop-down menu to a form. Requires the first parameter to specify the
   name of the drop-down menu, and the second parameter to specify the array of
   values contained in the menu ``(: 'Value1', 'Value2')``. Optionally, the
   array passed as the second parameter can contain a pair for each value. The
   first element in the pair is the value to be used upon form submission, and
   the second element is the human-readable label to be used for display only.

   An optional ``-default`` parameter specifies the name of a default value
   to select. An optional ``-editable`` parameter specifies that the user may
   edit the values on the menu. An optional ``-font`` parameter can be used to
   specify a pdf_font object for the font of the text.

.. member:: pdf_doc->addSelectList(\
      name::string, \
      values::trait_forEach, \
      -default='', \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a select list to a form. Requires the first parameter to specify the
   name of the select list, and the second parameter to specify the array of
   values contained in the select list ``(: 'Value1', 'Value2')``. Optionally,
   the array passed as the second parameter can contain a pair for each value.
   The first element in the pair is the value to be used upon form submission,
   and the second element is the human-readable label to be used for display
   only.

   An optional ``-default`` parameter specifies the name of a default value to
   select. An optional ``-font`` parameter can be used to specify a pdf_font
   object for the font of the text.

.. member:: pdf_doc->addHiddenField(name::string, value::string)

   Adds a hidden field to a form. Requires the first parameter to specify the
   name of the hidden field and the second parameter to specify the default
   value entered.

.. member:: pdf_doc->addSubmitButton(\
      name::string, \
      caption::string, \
      value::string, \
      url::string, \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a submit button to a form. Also specifies the URL to which the form data
   will be submitted. Requires the first parameter to specify the name of the
   button. The second parameter specifies a caption (displayed name) for the
   button. The third parameter is the value for the submit button, and the
   fourth parameter specifies the URL of the response page. An optional
   ``-font`` parameter can be used to specify a pdf_font object for the font of
   the text.

.. member:: pdf_doc->addResetButton(\
      name::string, \
      caption::string, \
      value::string, \
      -left, \
      -top, \
      -width, \
      -height, \
      -font= ?)

   Adds a reset button to a form. Requires the first parameter to specify the
   name of the button, the second parameter specifies a caption (displayed name)
   for the button, and the third parameter specifies the value for the button.
   An optional ``-font`` parameter can be used to specify a pdf_font object for
   the font of the text.

.. note::
   With the exception of the `pdf_doc->addSubmitButton` and
   `pdf_doc->addResetButton` methods, no form input element methods include
   captions or labels with the field elements. Field captions and labels can be
   applied using the `pdf_text` and `pdf_doc->add` methods to position text
   appropriately. See the :ref:`pdf-creating-text-content` section for more
   information.

.. note::
   All :type:`pdf_doc` form member methods, with the exception of
   `~pdf_doc->addHiddenField` and `~pdf_doc->addRadioButtonGroup`, require
   placement parameters for specifying the exact positioning of form elements
   within a page. These parameters are summarized in the table
   :ref:`pdf-form-placement`.

.. tabularcolumns:: lL

.. _pdf-form-placement:

.. table:: Form Placement Parameters

   =========== =================================================================
   Parameter   Description
   =========== =================================================================
   ``-left``   Specifies the placement of the left side of the form element from
               the left side of the current page in points. Requires a decimal
               value.
   ``-top``    Specifies the placement of the bottom of the form element from
               the bottom of the current page in points. Requires a decimal
               value.
   ``-width``  Specifies the width of the form element in points. Requires a
               decimal value.
   ``-height`` Specifies the height of the form element in points. Requires a
               decimal value.
   =========== =================================================================


Add a Text Field
^^^^^^^^^^^^^^^^

Use the `pdf_doc->addTextField` method. The example below adds a field named
"Field_Name" that has "Some Text" entered by default. The field size is 144.0
points (two inches) wide and 36.0 points high::

   #my_file->addTextField(
      'Field_Name',
      'Some Text',
      -font=#my_font,
      -left=72.0, -top=350.0, -width=144.0, -height=36.0
   )


Add a Text Area
^^^^^^^^^^^^^^^

Use the `pdf_doc->addTextArea` method. The example below adds a text area named
"Field_Name" that has the text "Insert default text here" entered by default.
The field size is 144.0 points wide and 288.0 points high::

   #my_file->addTextArea(
      'Field_Name',
      'Insert default text here',
      -font=#my_font,
      -left=72.0, -top=300.0, -width=144.0, -height=288.0
   )


Add a Checkbox
^^^^^^^^^^^^^^

Use the `pdf_doc->addCheckbox` method. The example below adds a field named
"Field_Name" with a checked value of "Checked_Value" that is checked by default.
The checkbox is 4.0 points wide and 4.0 points high, and is positioned 272.0
points from the bottom and left sides of the page::

   #my_file->addCheckBox(
      'Field_Name',
      'Checked_Value',
      -checked,
      -left=272.0, -top=272.0, -width=4.0, -height=4.0
   )


Add a Group of Radio Buttons
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addRadioGroup` and `pdf_doc->addRadioButton` methods. The
example below adds a radio button group named "Group_Name" and adds two radio
buttons with the values of "Yes" and "No". The radio buttons are 6.0 points wide
and 6.0 points high each::

   #my_file->addRadioGroup('Group_Name')
   #my_file->addRadioButton(
      'Group_Name',
      -value='Yes',
      -left=72.0, -top=372.0, -width=6.0, -height=6.0
   )
   #my_file->addRadioButton(
      'Group_Name',
      -value='No',
      -left=90.0, -top=372.0, -width=6.0, -height=6.0
   )

.. note::
   If the `pdf_doc->addRadioGroup` method is not used, then radio buttons will
   not appear in the form.


Add an Editable Drop-Down Menu
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addComboBox` method. The example below adds a drop-down menu
named "Menu_Name" with the values "One", "Two", "Three", and "Four" as menu
values. The value "One" is selected by default, and an ``-editable`` parameter
allows the users to edit the values if desired. The drop-down menu size is 144.0
points wide and 36.0 points high::

   #my_file->addComboBox(
      'List_Name',
      (: 'One', 'Two', 'Three', 'Four'),
      -default='One',
      -editable,
      -left=72.0, -top=272.0, -width=144.0, -height=36.0
   )


Add a Drop-Down Menu with Different Displayed Values
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addComboBox` method whose values are each pairs. The example
below adds a drop-down menu named "Menu_Name" with the values "1", "2", "3", and
"4" as submittable menu values, but displays the names "One", "Two", "Three",
and "Four" for each value. No value is selected by default::

   #my_file->addComboBox(
      'List_Name',
      (: pair(1 = 'One'),
         pair(2 = 'Two'),
         pair(3 = 'Three'),
         pair(4 = 'Four')
      ),
      -left=72.0, -top=272.0, -width=144.0, -height=36.0
   )


Add a Select List
^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addSelectList` methods. The example below adds a select list
named "List_Name" with the values "One", "Two", "Three", and "Four" as list
items. The select list is 144.0 points wide and 288.0 points high, and is
positioned 72.0 points from the bottom and left sides of the page::

   #my_file->addSelectList(
      'List_Name',
      (: 'One', 'Two', 'Three', 'Four'),
      -default='One',
      -left=72.0, -top=72.0, -width=144.0, -height=288.0
   )


Add a Hidden Field
^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addHiddenField` method. The example below adds a hidden field
named "Field_Name" with a value of "Hidden_Value" to a pdf_doc object named
"my_file". No placement coordinates are needed because the field is not
displayed on the page::

   #my_file->addHiddenField('Field_Name', 'Some_Value')


Add a Submit Button
^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addSubmitButton` method. The example below adds a submit
button named "Button_Name" with a value of "Submitted_Value". A caption
parameter specifies the displayed name of the button, which is "Submit This
Form". The URL parameter specifies that the user will be taken to
:ref:`!http://www.example.com/response.lasso` when the button is selected in the
form::

   #my_file->addSubmitButton(
      'Button_Name',
      'Submit This Form',
      'Submitted_Value',
      'http://www.example.com/response.lasso',
      -left=72.0, -top=72.0, -width=144.0, -height=36.0
   )


Add a Reset Button
^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->addResetButton` method. The example below adds a reset button
named "Button_Name" with a value of "Reset_Value". The caption parameter
specifies the displayed name of the button, which is "Reset This Form"::

   #my_file->addResetButton(
      'Button_Name',
      'Reset This Form',
      'Reset_Value',
      -left=72.0, -top=72.0, -width=144.0, -height=36.0
   )


Submitting Form Data to Lasso-Enabled Databases
-----------------------------------------------

Using Lasso Server, one has the ability to submit data from a PDF form to a
Lasso-enabled site for interaction with a database. PDF forms may be used in the
same way as HTML forms to submit request parameters to a Lasso response page,
where database actions can occur via an `inline` method.


Submit Information to a Database Using a PDF Form
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. In the "form.lasso" page, name the PDF form fields to correspond to the names
   of fields in the desired database. The names of these fields will be used in
   the `inline` method in the Lasso response page. ::

      local(my_file) = pdf_doc(-file='form.pdf', -size='A4')
      local(my_font) = pdf_font(-face='Helvetica', -size=12)
      #my_file->drawText('First Name:', -font=#my_font, -left=80.0, -top=60.0)
      #my_file->drawText('Last Name:',  -font=#my_font, -left=80.0, -top=60.0)
      #my_file->addTextField(
         'First Name',
         'Enter First Name',
         -left=144.0, -top=72.0, -width=144.0, -height=36.0
      )
      #my_file->addTextField(
         'Last Name',
         'Enter Last Name',
         -left=144.0, -top=92.0, -width=144.0, -height=36.0
      )

#. Create a submit button in the "form.lasso" page that contains the name and
   URL of the Lasso response page. ::

      #my_file->addSubmitButton(
         'Search',
         'Click here to Search',
         'Search',
         'http://www.example.com/response.lasso',
         -font=#my_font,
         -left=144.0, -top=122.0, -width=80.0, -height=36.0
      )
      #my_file->close

   After the pdf_doc object is closed and executed on the server, a "form.pdf"
   file will be created with the form.

#. In the "response.lasso" page, create an `inline` method that uses the action
   parameters passed from the PDF form to perform a database action. This
   example performs a search on the "Contacts" database using the values for
   "first_name" and "last_name" passed from the PDF form. ::

      inline(
         -search,
         -database='contacts',
         -table='people',
         -keyField='id',
         'first_name'=web_request->param('first_name'),
         'last_name'=web_request->param('last_name')
      ) => {^
         'There were ' + found_count + ' record(s) found in the People table.\n'
         records => {^
            '<br />' + field('first_name') + ' ' + field('last_name') + '\n'
         ^}
      ^}

   If the user of the PDF form entered "Jane" for the first name and "Doe" for
   the last name, then the following results would be returned::

      // =>
      // There were 1 record(s) found in the People table.
      // <br />Jane Doe

   You could also use this method to update data in a database.


Creating Tables
===============

Tables can be created in PDF files for displaying data. These are created using
the :type:`pdf_table` type and added to a PDF object using :type:`pdf_doc`
member methods, which are described in this section.


Defining Tables
---------------

Tables for organizing data can be defined for use in a PDF file using the
:type:`pdf_table` type. Objects of this type are added to a pdf_doc object.

.. type:: pdf_table
.. method:: pdf_table(cols::integer, rows::integer, ...)

   Creates a table to be placed in a PDF. Uses parameters that set the basic
   specifications of the table to be created. The first parameter is required
   and specifies the number of columns in the table. The second parameter is
   also required and specifies the number of rows in the table. Below is a list
   of optional parameters for the `pdf_table` constructor method.

   :param -spacing:
      Specifies the spacing around a table cell. Defaults to "0" (no spacing)
      if not specified. Optional.
   :param -padding:
      Specifies the padding within a table cell. Defaults to "0" (no padding)
      if not specified. Optional.
   :param -width:
      Specifies the width of the table as a percentage of the current page
      width. Defaults to the width of the cell text plus spacing, padding, and
      borders if not specified. Optional.
   :param -borderWidth:
      Specifies the border width of the table in points. Requires a decimal
      value. Optional.
   :param -borderColor:
      Specifies the border color of the table. Requires a hex color string (e.g.
      ``'#000000'``). Optional.
   :param -backgroundColor:
      Specifies the background color of the table. Requires a hex color string
      (e.g. ``'#CCCCCC'``). Optional.
   :param -colWidth:
      Sets the column width for each column in the table. Requires an array of
      decimals representing the width percentage of each column. Optional.

Member methods can be used to set additional specifications for a pdf_table
object, as well as access data member values from pdf_table objects. These
methods are summarized below.

.. member:: pdf_table->getColumnCount()

   Returns the number of columns in a pdf_table object.

.. member:: pdf_table->getRowCount()

   Returns the number of rows in a pdf_table object.

.. member:: pdf_table->getAbsWidth()

   Returns the total pdf_table object width in pixels.


Create a Basic Table
^^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_table` type. The example below creates a table with two
columns and five rows, with table cell spacing of one point and cell padding of
two points. The width of the table is set at 75% of the current page width::

   local(my_table) = pdf_table(
      2,
      5,
      -spacing=1,
      -padding=2,
      -width=75,
      -backgroundColor='#CCCCCC'
   )


Create a Table with a Border
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_table` type with the ``-borderWidth`` and ``-borderColor``
parameters. The example below creates a basic table, and then adds a black
border with a width of 3 points to the table::

   local(my_table) = pdf_table(
      2,
      5,
      -spacing=1,
      -padding=2,
      -borderWidth=3,
      -borderColor='#000000'
   )


Rotate a Table
^^^^^^^^^^^^^^

Use the :type:`pdf_table` type with the ``-rotate`` parameter. The example below
creates a basic table, and then rotates it by 90 degrees clockwise::

   local(my_table) = pdf_table(
      2,
      5,
      -spacing=1,
      -padding=2,
      -rotate=90
   )


Create a Table with Specific Column Widths
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_table` type with the ``-colWidth`` parameter. The example
below creates a basic table with percentage widths for three columns::

   local(my_table) = pdf_table(
      2,
      5,
      -spacing=1,
      -padding=2,
      -colWidth=(: '50.0', '25.0', '25.0')
   )


Adding Content to Table Cells
-----------------------------

Content is added to table cells using additional :type:`pdf_table` member
methods which are summarized below.

.. member:: pdf_table->add(str::string, col::integer, row::integer, ...)
.. member:: pdf_table->add(text::pdf_text, col::integer, row::integer, ...)
.. member:: pdf_table->add(table::pdf_table, col::integer, row::integer, ...)
.. member:: pdf_table->add(image::pdf_image, col::integer, row::integer, ...)
.. member:: pdf_table->add(barcode::pdf_barcode, col::integer, row::integer, ...)

   Inserts text content, a new nested table, an image, or a barcode into a cell.
   Requires a string, :type:`pdf_text`, :type:`pdf_table`, :type:`pdf_image`, or
   :type:`pdf_barcode` object to be inserted as the first parameter. Also
   requires specifying the column number as the second parameter and row number
   as the third parameter. Row and columns numbers start from "0" with rows
   increasing from top to bottom and columns increasing from left to right. The
   table below lists the optional parameters that can also be specified.

   :param -colspan:
      Specifies the number of columns a cell should span. If specified, requires
      an integer value "1" or greater. Optional.
   :param -rowspan:
      Specifies the number of rows a cell should span. If specified, requires an
      integer value "1" or greater. Optional.
   :param -verticalAlignment:
      Vertical alignment for text within a cell. Accepts a value of ``'Top'``,
      ``'Center'``, or ``'Bottom'``. Defaults to "Center" if not specified.
      Optional.
   :param -horizontalAlignment:
      Horizontal alignment for text within a cell. Accepts a value of
      ``'Left'``, ``'Center'``, or ``'Right'``. Defaults to "Center" if not
      specified. Optional.
   :param -borderColor:
      Specifies the border color for the cell (e.g. ``'#440000'``). Defaults to
      "#000000" if not specified. Optional.
   :param -borderWidth:
      Specifies the border width of the cell in points. Requires an integer
      value. Defaults to "0" if not specified. Optional.
   :param -header:
      Specifies that the cell is a table header. This is typically used for
      cells in the first row. Optional.
   :param -noWrap:
      Specifies that the text contained in a cell should not wrap to conform to
      the cell size specifications. If used, the cell will expand to the right
      to accommodate longer text strings. Optional.


Add a Cell to a Table
^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_table->add` method. The example below adds a cell to the first
row and column in a table. Note that the first row and column are numbered "0"::

   #my_table->add(
      'This is the first cell in my table',
      0,
      0,
      -colspan=1,
      -rowspan=1
   )


Add a Multi-Column Cell to a Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_table->add` method with the number of columns to span for the
``-column`` parameter. The example below adds a cell to the first row that spans
three columns. The ``-noWrap`` parameter is used to indicate that the added text
will not be wrapped into multiple lines::

   #my_table->add(
      'This text will only stay on one line regardless of the table size',
      0,
      0,
      -colspan=3,
      -rowspan=1,
      -noWrap
   )


Add a Header Cell to a Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_table->add` method with the ``-header`` parameter. The example
below adds the header "My Column Title" to the first column of the table::

   #my_table->add(
      'My Column Title',
      0,
      0,
      -header
   )


Add a Cell with a Border to a Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_table->add` method with the ``-borderWidth`` and ``-borderColor``
parameter. The example below adds a cell with a red border to the first column
of the table::

   #my_table->add(
      'This cell has a border',
      0,
      0,
      -borderWidth=45.0,
      -borderColor='#440000'
   )


Adding Tables
-------------

Once a pdf_table object is completely defined and has cell content, it may then
be added to a pdf_doc object using the `pdf_doc->add` method.


Add a Table to a pdf_doc Object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->add` method. The following example adds a predefined pdf_table
object named "my_table" to a pdf_doc object named "my_file"::

   #my_file->add(#my_table)


Creating Graphics
=================

This section describes how to draw custom graphic objects and insert image files
within a PDF file.


Inserting Images
----------------

Image files can be placed within PDF pages using the :type:`pdf_image` type in
conjunction with the `pdf_doc->addImage` method as documented below.

.. type:: pdf_image
.. method:: pdf_image(...)

   Reads an image file as a Lasso object so it can be placed into a PDF file.
   Requires either a ``-file``, ``-url``, or ``-raw`` parameter, as described in
   the list below. Only images in JPEG, GIF, PNG, and WMF formats may be used.

   :param -file:
      Specifies the local path to an image file. Required if the ``-url`` or
      ``-raw`` parameters are not used.
   :param -url:
      Specifies a URL to an image file. Required if the ``-file`` or ``-raw``
      parameters are not used.
   :param -raw:
      Inputs a raw string of bits representing the image. Required if the
      ``-url`` or ``-file`` parameters are not used.
   :param -height:
      Scales the image to the specified height. Requires a decimal value which
      is the desired image height in points. Optional.
   :param -width:
      Scales the image to the specified width. Requires a decimal value which is
      the desired image width in points. Optional.
   :param -proportional:
      Keyword parameter specifying that all scaling should preserve the aspect
      ratio of the inserted page. Optional.
   :param -rotate:
      Rotates the image by the specified degrees clockwise. Optional.


Add an Image File to a pdf_doc Object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_image` type. The following example adds a file named
"Image.jpg" in a "/Documents/Images/" folder to a pdf_doc object named
"my_file"::

   local(image) = pdf_image(-file='/Documents/Images/Image.jpg')
   #my_file->add(#image, -left=144.0, -top=300.0)


Scale an Image File
^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_image` type with the ``-height`` or ``-width`` parameter. The
following example proportionally reduces the size of the added image by 50%::

   local(image) = pdf_image(-file='/Documents/Images/Image.jpg', -height='50%')
   #my_file->add(#image, -left=144.0, -top=300.0)


Rotate an Image File
^^^^^^^^^^^^^^^^^^^^

Use the :type:`pdf_image` type with the ``-rotate`` parameter. The following
example rotates the added image by 90 degrees clockwise::

   local(image) = pdf_image(-file='/Documents/Images/Image.jpg', -rotate=90.0)
   #my_file->add(#image, -left=144.0, -top=300.0)


Drawing Graphics
----------------

To draw custom graphics, Lasso uses a coordinate system to determine the
placement of each graphical object. This coordinate system is a standard
coordinate plane with horizontal (X) vertical (Y) axis, where a point on a page
is defined by an array containing horizontal and vertical position values "(X,
Y)". The base point of the coordinate plane "(0, 0)" is located in the lower
left corner for the current page. Increasing an X-Value moves a point to the
right in the page, and increasing the Y-Value moves the point up in the page.
The current width and height of the page in points defines the maximum X and Y
values.

Custom graphics may be drawn in PDF pages using :type:`pdf_doc` drawing member
methods. These member methods operate by controlling a "virtual pen" which draws
graphics similar to a true graphics editor. These member methods are summarized
below.

.. member:: pdf_doc->setColor(type::string, color::pdf_color)
.. member:: pdf_doc->setColor(type::string, color::string, ...)

   Sets the color and style for subsequent drawing operations on the page.
   Requires the first parameter to specify whether the drawing action is of type
   "Stroke", "Fill", or "Both". The second parameter is also required and is
   either a pdf_color object or a string that specifies a color type of "Gray",
   "RGB", or "CMYK". If "Gray" is specified, a decimal specifies a color
   strength value. If "RGB" is specified, three decimal values specify red,
   green, and blue values, respectively. If "CMYK" is specified, four decimal
   values specify cyan, magenta, yellow, and black values, respectively. Color
   values are specified as decimals ranging from "0" to "1.0".

.. member:: pdf_doc->setLineWidth(width::decimal)

   Sets the line width for subsequent drawing actions on the page in points.
   Requires a decimal point value.

.. member:: pdf_doc->line(x1, y1, x2, y2)

   Draws a line. Requires a set of integer points which specifies the starting
   point and ending point of the line.

.. member:: pdf_doc->curveTo(x1, y1, x2, y2, x3, y3)

   Draws a curve. Requires a set of integer points as parameters which specifies
   the starting point, middle point, and ending point of the curve.

.. member:: pdf_doc->rect(x, y, width, height, -fill::boolean= ?)

   Draws a rectangle. Requires the first two parameters to be a set of "X" and
   "Y" integer points which specifies the lower right corner of the rectangle,
   and the next two parameters specify the height and width of the rectangle
   sides from that coordinate. An optional ``-fill`` parameter draws a filled
   rectangle.

.. member:: pdf_doc->circle(x, y, radius, -fill::boolean= ?)

   Draws a circle. Requires the first two parameters to be a set of integer
   points for the center coordinates of the circle and the third parameter to be
   the length of the radius. An optional ``-fill`` parameter draws a filled
   circle.

.. member:: pdf_doc->arc(x, y, radius, start, end, -fill::boolean= ?)

   Draws an arc. Requires the first two parameters to be a set of integer points
   for the center coordinates of the arc and the third parameter to be the
   radius of the invisible circle to which the arc belongs. The fourth parameter
   must be a starting degree which specifies the degrees of the circle at which
   the arc starts, and the fifth parameter must be an ending degree which
   specifies the circle degrees at which the arc ends. Angles start with "0" to
   the right of the center and increase counter-clockwise. An optional ``-fill``
   parameter draws a filled arc.

.. note::
   The color and line width must be set on each new page of the PDF prior to
   calling any drawing methods.


Set Color and Style for a Drawing Action
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->setColor` method. The example below sets a color of red for
all subsequent drawing action until another `pdf_doc->setColor` method is
called::

   #my_file->setColor('Stroke', 'RBG', 0.1, 0.9, 0.9)

The example below sets the fill color of red for all subsequent drawing action
until another `pdf_doc->setColor` method is called. The methods to draw
rectangles, circles, or arcs must be called with the optional ``-fill``
parameter for this color choice to be applied::

   #my_file->setColor('Fill', 'RBG', 0.1, 0.9, 0.9)


Set Line Width of a Drawing Action
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->setLineWidth` method. The example below sets a line width of 5
points for all subsequent drawing action until another `pdf_doc->setLineWidth`
method is called::

   #my_file->setLineWidth(5.0)


Draw a Line
^^^^^^^^^^^

Use the `pdf_doc->line` method. The example below draws a horizontal line from
points "(8, 8)" to points "(32, 32)"::

   #my_file->line(8, 8, 32, 32)


Draw a Curve
^^^^^^^^^^^^

Use the `pdf_doc->curveTo` method. The example below draws a curve starting
from points "(8, 8)", peaking at points "(32, 32)", and ending at points
"(56, 8)"::

   #my_file->curveTo(8, 8, 32, 32, 56, 8)


Draw a Filled Rectangle
^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_doc->rect` method. The example below draws a rectangle whose
lower left corner is at coordinates "(10, 60)", has left and right sides that
are 50 points long, and has top and bottom sides that are 20 points long. The
optional ``-fill`` parameter ensures this rectangle has the current fill color
applied::

   #my_file->rect(10, 60, 20, 50, -fill)


Draw a Circle
^^^^^^^^^^^^^

Use the `pdf_doc->circle` method. The example below draws a circle whose center
is at coordinates "(50, 50)" and has a radius of 20 points::

   #my_file->circle(50, 50, 20)


Draw an Arc
^^^^^^^^^^^

Use the `pdf_doc->arc` method. The example below draws an arc whose center is
at coordinates (50, 50), has a radius of 20 points, and runs from 0 degrees to
90 degrees from the center::

   #my_file->arc(50, 50, 20, 0, 90)


Creating Barcodes
=================

Barcodes are special device-readable images that can be created in PDF files
using the :type:`pdf_barcode` type, and added to a pdf_doc using member methods,
which are described in this section. Lasso can be used to create the following
industry-standard barcodes:

-  Code 39 (alphanumeric, ASCII subset)
-  Code 39 Extended (alphanumeric, escaped text)
-  Code 128
-  Code 128 UCC/EAN
-  Code 128 Raw
-  EAN (8 digits)
-  EAN (13 digits)
-  POSTNET
-  PLANET

Barcodes can be defined for use in a PDF file using the :type:`pdf_barcode`
type. Objects of this type can then be added to pdf_doc objects.

.. type:: pdf_barcode
.. method:: pdf_barcode(...)

   Creates a barcode image to be placed in a PDF. Uses parameters which set the
   basic specifications of the barcode to be created.

   :param -type:
      Specifies the type of barcode to be created. Available parameters are
      ``'CODE39'``, ``'CODE39_EX'``, ``'CODE128'``, ``'CODE128_UCC'``,
      ``'CODE128_RAW'``, ``'EAN8'``, ``'EAN13'``, ``'POSTNET'``, and
      ``'PLANET'``. Required.
   :param -code:
      Specifies the numeric or alphanumeric barcode data. Some formats require
      specific data strings: "EAN8" requires an 8-digit integer, "EAN13"
      requires a 13-digit integer, "POSTNET" requires a ZIP code, and "CODE39"
      requires uppercase characters. Required.
   :param -color:
      Specifies the color of the bars in the barcode. Requires a hex string
      color value. Defaults to "#000000" if not specified. Optional.
   :param -supplemental:
      Adds an additional two or five-digit supplemental barcode to "EAN8" or
      "EAN13" barcode types. Requires a two or five-digit integer as a
      parameter. Optional.
   :param -generateChecksum:
      Generates a checksum for the barcode. Optional.
   :param -showCode39StartStop:
      Displays start and stop characters ("``*``") in the text for Code 39
      barcodes. Optional.
   :param -showEANGuardBars:
      Show the guard bars for "EAN" barcodes. Optional.
   :param -barHeight:
      Sets the height of the bars in points. Requires a decimal value.
   :param -barWidth:
      Sets the width of the bars in points. Requires a decimal value.
   :param -baseLine:
      Sets the text baseline in points. Requires a decimal value.
   :param -showChecksum:
      Keyword parameter sets the generated checksum to be shown in the text.
   :param pdf_font -font:
      Sets the text font. Requires a pdf_font object.
   :param -barMultiplier:
      Sets the bar multiplier for wide bars. Requires a decimal value.
   :param -textSize:
      Sets the size of the text. Requires a decimal value.


Create a Barcode
----------------

Use the :type:`pdf_barcode` type. The example below creates a basic Code 39
barcode with the data "1234567890", and uses the optional Code 39 start and stop
characters ("``*``"). The barcode is then added to a pdf_doc object using
`pdf_doc->add`::

   local(barcode) = pdf_barcode(
      -type='CODE39',
      -code='1234567890',
      -showCode39StartStop
   )
   #my_pdf->add(#barcode, -left=150.0, -top=100.0)


Create a Barcode with a Specified Bar Width
-------------------------------------------

Use the :type:`pdf_barcode` type with the ``-barWidth`` parameter. The following
example sets a pdf_barcode object with a bar width of 0.2 points::

   local(barcode) = pdf_barcode(
      -type='CODE39',
      -code='1234567890',
      -barWidth=0.2
   )
   #my_pdf->add(#barcode, -left=150.0, -top=100.0)


Create a Barcode with a Specified Bar Multiplier
------------------------------------------------

Use the :type:`pdf_barcode` type with the ``-barMultiplier`` parameter. The
following example sets a pdf_barcode object with a bar multiplier constant of
"4.0". The barcode is then added to a pdf_doc object using `pdf_doc->add`::

   local(barcode) = pdf_barcode(
      -type='CODE39',
      -code='1234567890',
      -barMultiplier=4.0
   )
   #my_pdf->add(#barcode, -left=150.0, -top=100.0)


Create a Barcode with a Specified Text Size
-------------------------------------------

Use the :type:`pdf_barcode` type with the ``-textSize`` parameter. The following
example sets a pdf_barcode object with a text size of 6.0 points. The barcode is
then added to a pdf_doc object using `pdf_doc->add`::

   local(barcode) = pdf_barcode(
      -type='CODE39',
      -code='1234567890',
      -textSize=6.0
   )
   #my_pdf->add(#barcode, -left=150.0, -top=100.0)


Create a Barcode with a Specified Font
--------------------------------------

Use the :type:`pdf_barcode` type with the ``-font`` parameter. The following
example sets a pdf_barcode object font specified in a pdf_font object named
"my_font". The barcode is then added to a pdf_doc object using `pdf_doc->add`::

   local(barcode) = pdf_barcode(
      -type='CODE39',
      -code='1234567890',
      -font=#my_font
   )
   #my_pdf->add(#barcode, -left=150.0, -top=100.0)


PDF File Examples
=================

This section provides complete examples of creating PDF files using the methods
described in this chapter. Examples include a two-page PDF file with multiple
text styles, a PDF file with a form, a PDF file with a table, a PDF file with
drawn graphics, and a PDF file with a barcode.

.. note::
   All examples in this section use the OS X and Linux line break character
   ``"\n"`` in the text sections. If creating PDF files on the Windows version
   of Lasso, change all instances of ``"\n"`` to ``"\r\n"``.


PDF Text Example
----------------

The following example creates a PDF file that contains two pages of text with
multiple text styles::

   local(text_example) = pdf_doc(-file='Text_Example.pdf', -size='A4')
   #text_example->addPage
   #text_example->setPageNumber(1)

   local(font1) = pdf_font(-face='Helvetica', -size='24', -color='#990000')
   local(font2) = pdf_font(-face='Helvetica', -size='14', -color='#000000')
   local(font3) = pdf_font(-face='Helvetica', -size='14', -color='#0000CC')

   local(title) = pdf_text('Lasso Server', -type='Chunk', -font=#font1)
   #text_example->add(#title, -number=1)

   local(text1) = pdf_text("\n\nThe Lasso product line consists of authoring and
      serving tools that allow web designers and web developers to quickly build
      and serve powerful data-driven web sites with maximum productivity and
      ease. The product line includes Lasso Server for serving and administering
      data-driven web sites, and LassoLab for building and testing data-driven
      web sites within a graphical editor.\n\nLasso Server works with the
      following data sources:",
      -type='Paragraph',
      -leading=15,
      -font=#font2
   )
   #text_example->add(#text1)

   local(list) = pdf_list(
      -format='Bullet',
      -bullet='-',
      -font=#font2,
      -indent=30
   )
   #list->add('FileMaker Server')
   #list->add('MySQL')
   #list->add('Microsoft SQL Server')
   #list->add('Frontbase')
   #list->add('Sybase')
   #list->add('PostgreSQL')
   #list->add('DB2')
   #list->add('Plus many other ODBC-compliant databases')
   #text_example->add(#list)

   local(text2) = pdf_text("\nLasso's innovative architecture provides an
      industry-first multi-platform, database-independent and open standards
      approach to delivering database-driven web sites firmly positioning Lasso
      technology within the rapidly evolving server-side web tools market. Lasso
      technology is used on hundreds of thousands of web sites worldwide.\n\n",
      -type='Paragraph',
      -font=#font2
   )
   #text_example->add(#text2)

   local(text3) = pdf_text(
      "Click here to go to the LassoSoft website",
      -type='Phrase',
      -font=#font3,
      -underline='true',
      -anchor='http://www.lassosoft.com'
   )
   #text_example->add(#text3)

   #text_example->drawText(
      #text_example->getPageNumber->asString,
      -font=#font2,
      -top=30,
      -left=560
   )
   #text_example->addPage

   #text_example->setPageNumber(2)

   local(text4) = pdf_text("Lasso Server is server-side software that adds a
      suite of dynamic functionality and administration to your web server. This
      functionality empowers you to build and serve just about any dynamic web
      application and do so with maximum productivity and ease.\n\n",
      -type='Paragraph',
      -leading=15,
      -font=#font2
   )
   #text_example->add(#text4)

   local(text5) = pdf_text("Lasso works by using a simple scripting language,
      which can be embedded in web pages and scripts residing on your web
      server. By default, Lasso Server is designed to run on the most prevalent
      modern web server platforms with the most popular web serving
      applications. Additionally, Lasso's extensibility allows web server
      connectors to be authored for any web server for which default
      connectivity is not provided.\n\n",
      -type='Paragraph',
      -leading=15,
      -font=#font2
   )
   #text_example->add(#text5)

   #text_example->drawText(
      #text_example->getPageNumber->asString,
      -font=#font2,
      -top=30,
      -left=560
   )
   #text_example->close


PDF Form Example
----------------

The following example creates a PDF file that contains both text and a form::

   local(form_example) = pdf_doc(-file='Form_Example.pdf', -size='a4')
   local(myFont)       = pdf_font(-face='Helvetica', -size='12')

   #form_example->addText(
      'This PDF file contains a form. See below.\n',
      -font=#myFont
   )
   #form_example->drawText('Select List', -font=#myFont, -left=90, -top=116)
   #form_example->addSelectList(
      'mySelectList',
      (: 'one', 'two', 'three', 'four'),
      -default='one',
      -left=216, -top=104, -width=144, -height=72,
      -font=#myFont
   )
   #form_example->drawText(
      'Drop-Down Menu',
      -font=#myFont,
      -left=90,
      -top=200
   )
   #form_example->addComboBox(
      'myComboBox',
      (: 'one', 'two', 'three', 'four'),
      -default='one',
      -left=216, -top=188, -width=144, -height=18,
      -font=#myFont
   )
   #form_example->drawText('Text Area', -font=#myFont, -left=90, -top=238)
   #form_example->addTextArea(
      'myTextArea',
      'Some text',
      -left=216, -top=230, -width=144, -height=72,
      -font=#myFont
   )
   #form_example->drawText('Password Field', -font=#myFont, -left=90, -top=334)
   #form_example->addPasswordField(
      'myPassword',
      '***',
      -left=216, -top=322, -width=144, -height=18,
      -font=#myFont
   )
   #form_example->drawText('Text Field', -font=#myFont, -left=90, -top=368)
   #form_example->addTextField(
      'myTextField',
      'Some More Text',
      -left=216, -top=360, -width=144, -height=18,
      -font=#myFont
   )
   #form_example->addHiddenField('myHiddenField', 'Shh')
   #form_example->addSubmitButton(
      'myButton',
      'Submit Form',
      'Submit',
      'http://www.example.com/response.lasso',
      -left=216, -top=400, -width=100, -height=26,
      -font=#myFont
   )
   #form_example->addResetButton(
      'Reset',
      'Reset Form',
      'Reset',
      -left=365, -top=400, -width=100, -height=26,
      -font=#myFont
   )
   #form_example->close


PDF Table Example
-----------------

The following example creates a PDF file that contains both text and a table::

   local(table_example) = pdf_doc(-file='Table_Example.pdf', -size='A4')

   local(font1) = pdf_font(-face='Helvetica', -size='24')
   local(text)  = pdf_text(
      "This PDF file contains a table. See below.\n\n",
      -leading=15,
      -font=#font1
   )
   #table_example->add(#text)

   local(font2)    = pdf_font(-face='Helvetica', -size='12')
   local(cell1)    = pdf_text('Cell One',   -font=#font2)
   local(cell2)    = pdf_text('Cell Two',   -font=#font2)
   local(cell3)    = pdf_text('Cell Three', -font=#font2)
   local(cell4)    = pdf_text('Cell Four',  -font=#font2)
   local(my_table) = pdf_table(2, 2,
      -spacing=4, -padding=4, -width=75, -borderWidth=7
   )
   #my_table->add(#cell1, 0, 0, -borderWidth=4)
   #my_table->add(#cell2, 0, 1, -borderWidth=4)
   #my_table->add(#cell3, 1, 0, -borderWidth=4)
   #my_table->add(#cell4, 1, 1, -borderWidth=4)

   #table_example->add(#my_table)
   #table_example->close


PDF Graphics Example
--------------------

The following example shows how to create a PDF file that contains drawn graphic
objects::

   local(graphic_example) = pdf_doc(-file='Graphic_Example.pdf', -height=650, -width=550)
   local(text) = pdf_text("This PDF file contains lines and circles. See below.\n")
   #graphic_example->add(#text)
   #graphic_example->line(200, 400, 400, 400)
   #graphic_example->line(200, 500, 400, 500)
   #graphic_example->line(266, 333, 266, 566)
   #graphic_example->line(333, 333, 333, 566)
   #graphic_example->line(200, 333, 400, 566)
   #graphic_example->circle(233, 366, 20)
   #graphic_example->circle(300, 452, 20)
   #graphic_example->circle(366, 533, 20)
   #graphic_example->line(220, 432, 240, 472)
   #graphic_example->line(220, 472, 240, 432)
   #graphic_example->line(360, 432, 380, 472)
   #graphic_example->line(360, 472, 380, 432)
   #graphic_example->line(220, 517, 240, 558)
   #graphic_example->line(220, 558, 240, 517)
   #graphic_example->close


PDF Barcode Example
-------------------

The following example shows how to create a PDF file that contains text
accompanied by a barcode::

   local(barcode_example) = pdf_doc(
      -file='Barcode_Example.pdf',
      -height=172,
      -width=300
   )
   local(font1)     = pdf_font(-face='Courier', -size=12)
   local(myBarcode) = pdf_barcode(
      -type='CODE39',
      -code='1234567890',
      -generateCheckSum,
      -showCode39StartStop,
      -textSize=6.0
   )
   #barcode_example->drawText('The Shipping Company\n',
      -font=#font1,
      -left=72,
      -top=90
   )
   #barcode_example->add(#myBarcode, -left=72, -top=40)
   #barcode_example->close


.. _pdf-serving-files:

Serving PDF Files
=================

This section describes how PDF files can be served using Lasso Server. This can
be done by supplying a download link to the created PDF file, or by using the
`pdf_serve` method described below.


Linking to PDF Files
--------------------

Named PDF files may be linked to in a Lasso page using basic HTML. Once a user
clicks on a link to a file with a "|dot| pdf" extension, the client browser
should prompt to download the file or launch the file in PDF reader (if
configured to do so).


Link to a PDF file
^^^^^^^^^^^^^^^^^^

The example below shows how a PDF can be created and written to file, and then
linked to from the Lasso page::

   <?lasso
      local(my_file) = pdf_doc(-file='MyFile.pdf', -size='A4')
      local(my_text) = pdf_text('Hello World')
      #my_file->add(#my_text)
      #my_file->close
   ?>
   <html>
      <body>
         <p>Click on the following link to download MyFile.pdf.</p>
         <p><a href="MyFile.pdf">Click Here</a></p>
      </body>
   </html>


Serving PDF Files to Client Browsers
------------------------------------

PDF files may also be served directly to a client browser using the `pdf_serve`
method. This method automatically informs the client web browser that the data
being loaded is a PDF file, and outputs the file with the correct file name. If
the client web browser is configured to handle PDF files via a reader, then the
served PDF file will automatically be opened in the client's configured PDF
reader. Otherwise, the client web browser should prompt the user to save the
file.

.. method:: pdf_serve(doc::pdf_doc, -file, -type= ?)

   Serves a PDF file to a client browser with a MIME type of
   :mimetype:`application/pdf`. Requires the first parameter to specify the
   pdf_doc object to serve, and the second parameter, ``-file``, specifies the
   name of the file to be output to the browser. An optional ``-type`` parameter
   may be used to specify additional MIME types.


Serve a PDF File to a Client Browser
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the `pdf_serve` method to serve the created PDF file. The file parameter
specifies the file name that should be output. ::

   local(my_file) = pdf_doc(-file='MyFile.pdf', -size='A4', -noCompress)
   #my_file->add(pdf_text('Hello World'))
   #my_file->close
   pdf_serve(#my_file, -file='MyFile.PDF')


Serve a PDF File Without Writing to File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PDF files may be served to the client browser without ever writing them to file
on the local server. This is done by creating a pdf_doc object without the
``-file`` parameter. This allows a PDF file to be created in the system memory,
but does not the save the file to a hard drive location. The resulting file can
be saved by the end user to a location on the end user's hard drive. ::

   local(my_file) = pdf_doc(-size='A4', -noCompress)
   #my_file->add(pdf_text('Hello World'))
   #my_file->close
   pdf_serve(#my_file, -file='MyFile.PDF')

.. _information on PDF technology: http://www.adobe.com/products/acrobat/adobepdf.html
