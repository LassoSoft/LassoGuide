.. _xml-documents:

*************
XML Documents
*************

Lasso provides a full suite of objects both for constructing new XML documents
and parsing existing XML documents. Lasso's implementation follows the `DOM
Level 2 Core specification`_ as closely as possible. This introduces a series of
objects each representing the various components that can be found within an XML
document. The Lasso object names match up with the objects specified in the DOM
standard with the addition of an ``xml_`` prefix. Also provided is a simplified
method for parsing existing XML data. This method is called `xml` and does not
conform to the DOM specification.

Lasso also provides both XPath and XSLT functionality. This functionality is
integrated into the XML object model, though it is not considered part of the
DOM specification itself.

In cases where elements are accessed by numeric position, Lasso's implementation
conforms to the DOM specification's zero-based indexes, as opposed to Lasso's
standard one-based positions. This will be noted in all relevant cases within
this chapter.

The following table lists all the possible objects that may be encountered
within or inserted into an XML document.

.. tabularcolumns:: |l|l|L|

.. _xml-object-names:

.. table:: XML Object Names

   ============================= ===================== ===================================
   Lasso XML Object Name         XML DOM Level 2 Name  Description
   ============================= ===================== ===================================
   ``xml_DOMImplementation``     DOMImplementation     Creates `xml_document` and
                                                       `xml_documentType` objects. Can
                                                       parse existing XML documents or
                                                       create new empty documents.
   ``xml_node``                  Node                  Base functionality supported by all
                                                       objects.
   ``xml_document``              Document              Represents the entire document and
                                                       provides access to the document's
                                                       data.
   ``xml_element``               Element               Represents an XML element node.
   ``xml_attr``                  Attr                  Represents an attribute of an XML
                                                       element node.
   ``xml_characterData``         CharacterData         Represents character data within
                                                       the document. This is the base
                                                       object type for `xml_text` and
                                                       `xml_cdataSection` objects.
   ``xml_text``                  Text                  Represents the character data of
                                                       an `xml_element` or `xml_attr`
                                                       node.
   ``xml_cdataSection``          CDATASection          Represents a CDATA node.
   ``xml_entityReference``       EntityReference       Represents an entity reference.
   ``xml_entity``                Entity                Represents a parsed or unparsed
                                                       entity within the document.
   ``xml_processingInstruction`` ProcessingInstruction Represents a processing instruction
                                                       located within the document.
   ``xml_comment``               Comment               Represents the content of an XML
                                                       comment node.
   ``xml_documentType``          DocumentType          Represents the doctype attribute of
                                                       an XML document.
   ``xml_documentFragment``      DocumentFragment      Represents a minimal document
                                                       object.
   ``xml_notation``              Notation              Represents a notation declared in
                                                       the DTD.
   ``xml_nodeList``              NodeList              Represents a list of node objects.
                                                       Provides random access to the list.
                                                       This list uses zero-based indexes,
                                                       in contrast to Lasso's standard
                                                       one-based positions.
   ``xml_namedNodeMap``          NamedNodeMap          Represents a collection of nodes
                                                       that can be accessed by name.
   ============================= ===================== ===================================


Creating XML Documents
======================

XML documents are created either from existing XML character data or as empty
documents. An empty XML document will initially contain only the root document
node which can then have children or attributes added to it. A document created
from existing XML character data will be parsed and validated and the resulting
document object tree will be created. When attempting to create an XML document
from existing data, if the data is not valid, then a failure will be generated
during parsing. The current `error_msg` will indicate the encountered error.

New XML documents can be created in one of two ways: the DOM Level 2-conformant
:type:`xml_DOMImplementation` type, or the `xml` method. Both have the same
abilities, but the `xml` method provides a simplified interface and is
compatible with earlier Lasso versions. It's important to note that `xml` is not
itself an object, it is merely a method that provides a moderately easier to use
interface to XML document creation. Internally, the `xml` method uses the
:type:`xml_DOMImplementation` type and therefore provides equivalent
functionality to the :type:`xml_DOMImplementation` type.


Using xml
---------

The `xml` method is presented in five variations; two for parsing existing XML
documents and three for creating new blank documents.

.. method:: xml(text::string)
.. method:: xml(text::bytes)

   These first two methods parse existing XML data in either string or raw bytes
   form. If the document parsing is successful, these methods return the
   top-level :type:`xml_document` node object.

.. method:: xml(namespaceUri::string, rootNodeName::string)
.. method:: xml(namespaceUri::string, rootNodeName::string, dtd::xml_documentType)
.. method:: xml()

   These subsequent three methods create a new document consisting of only the
   root :type:`xml_document` node and no children. These methods return the
   top-level :type:`xml_document` node object. The first two methods create the
   document given a namespace and a root element name, along with an optional
   document type node (an :type:`xml_documentType`, created through the
   `xml_DOMImplementation->createDocumentType` method). The third method takes
   zero parameters and returns a document with no namespace and the root element
   name set to "none".

In all cases, the resulting value from the `xml` method will be the root element
of the document. This will be an object of type :type:`xml_element`. It's
important to note that this is not the :type:`xml_document` object, which
differs from the root element node. This behavior is a departure from that of
the :type:`xml_DOMImplementation` type which does return the
:type:`xml_document` object itself. The owning :type:`xml_document` object can
be obtained from any node within that document by calling the
`xml_node->ownerDocument` method.


xml Examples
^^^^^^^^^^^^

Example of creating an XML document from existing data::

   local(myDocumentText) = '<a><b>b content</b><c/></a>'
   local(myDocumentObj)  = xml(#myDocumentText)

Example of creating a blank XML document::

   local(myDocumentObj) = xml('my_namespace', 'a')


Using xml_DOMImplementation
---------------------------

The :type:`xml_DOMImplementation` type provides comparable functionality to the
`xml` method, but follows the DOM Level 2 specification. An object of the type
:type:`xml_DOMImplementation` is stateless and can be created with zero
parameters. Once an :type:`xml_DOMImplementation` object is obtained it can be
used to create or parse XML documents as well as create XML document types.

This functionality is presented in the following four methods.

.. type:: xml_DOMImplementation

.. member:: xml_DOMImplementation->createDocument(namespaceUri::string, rootNodeName::string)
.. member:: xml_DOMImplementation->createDocument(namespaceUri::string, rootNodeName::string, dtd::xml_documentType)
.. member:: xml_DOMImplementation->createDocumentType(qname::string, publicid::string, systemid::string)
.. member:: xml_DOMImplementation->parseDocument(text::bytes)

In contrast to the `xml` method, when creating or parsing an XML document the
:type:`xml_DOMImplementation` object returns the document node. This will be an
object of type :type:`xml_document`. It's important to note that this is not the
root element node. The root element node can be obtained through the
`xml_document->documentElement` method.


xml_DOMImplementation Examples
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Example of creating an XML document from existing data::

   local(myDocumentText) = '<a><b>b content</b><c/></a>'
   local(myDocumentObj)  =
      xml_DOMImplementation->parseDocument(
         bytes(#myDocumentText)
      )

Example of creating a blank XML document::

   local(domImpl) = xml_DOMImplementation
   local(docType) = #domImpl->createDocumentType(
      'svg:svg',
      '-//W3C//DTD SVG 1.1//EN',
      'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'
   )
   local(myDocumentObj) = #domImpl->createDocument(
      'http://www.w3.org/2000/svg',
      'svg:svg',
      #docType
   )

The resulting document would have the following format:

.. code-block:: xml

   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE svg:svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
   <svg xmlns:svg="http://www.w3.org/2000/svg"/>


Creating XML Node Objects
-------------------------

While the :type:`xml_DOMImplementation` object is responsible for creating the
initial :type:`xml_document` object, the :type:`xml_document` object is the
means through which new XML node object types are created, including element,
attribute, and text nodes. All XML objects always belong to a particular
instance of the :type:`xml_document` type. No XML node objects can be created
without an existing document. Nodes can be copied into another existing
:type:`xml_document`, but nodes are never shared between documents.

The following methods are use for creating new nodes:

.. type:: xml_document

.. member:: xml_document->createElement(tagName::string)::xml_element
.. member:: xml_document->createElementNS(namespaceURI::string, qualifiedName::string)::xml_element

   The first version creates a new element node without a namespace. The second
   version permits a namespace to be specified.

.. member:: xml_document->createAttribute(name::string)::xml_attr
.. member:: xml_document->createAttributeNS(namespaceURI::string, qualifiedName::string)::xml_attr

   The first version creates a new attribute without a namespace. The second
   version permits a namespace to be specified.

.. member:: xml_document->createDocumentFragment()::xml_documentFragment
.. member:: xml_document->createTextNode(data::string)::xml_text
.. member:: xml_document->createComment(data::string)::xml_comment
.. member:: xml_document->createCDATASection(data::string)::xml_cdataSection
.. member:: xml_document->createProcessingInstruction(target::string, data::string)::xml_processingInstruction
.. member:: xml_document->createEntityReference(name::string)::xml_entityReference

.. member:: xml_document->importNode(importedNode::xml_node, deep::boolean)::xml_node

   Imports a node from another document into the document of the target object
   and returns the new node. The new node is not yet placed within the current
   document and so it has no parent. If "false" is given for the second
   parameter, then the node's children and attributes are not copied. If
   "true" is given, then all attributes and child nodes are copied into the
   current document.


Inspecting XML Objects
----------------------

Lasso's XML interface permits all the various pieces of an XML document to be
inspected. This includes accessing attributes, node content, node children etc.
The methods listed in this section are not meant to be exhaustive, but instead
to show the methods most commonly used when working with an XML document.

.. type:: xml_node

.. member:: xml_node->nodeType()::string

   Returns the name of the type of node. For example, an :type:`xml_element`
   node would return "ELEMENT_NODE". This is in contrast to the DOM Level 2
   specification which returns an integer value.

.. member:: xml_node->nodeName()::string

   Returns the name of the node. This value will depend on the type of the node
   in question. For :type:`xml_element` nodes, this will be the same value as
   the tag name. For :type:`xml_attr` nodes, this will be the same as the
   attribute name.

.. member:: xml_node->prefix()

   Returns the namespace prefix of the node or "null" if it is unspecified.

.. member:: xml_node->localName()

   Returns the local part of the qualified name of the node.

.. member:: xml_node->namespaceURI()

   Returns the namespace URI of the node or "null" if it is unspecified.

.. member:: xml_node->nodeValue()

   Returns the value of the node as a string. This result will vary depending on
   the node type. For example an attribute node will return the attribute value.
   A text node will return the text content for the node. Many node types, such
   as element nodes, will return "null". This value is read/write for nodes that
   have values (see the `xml_node->nodeValue=` method).

.. member:: xml_node->parentNode()

   Returns the parent of the node or "null" if there is no parent. Some, such as
   attribute nodes and the document node, do not have parents.

.. member:: xml_node->ownerDocument()

   Returns the :type:`xml_document` that is the owner of the target node. In the
   case of the document node, this will be "null".

.. type:: xml_element

.. member:: xml_element->tagName()::string

   Returns the name of the element.

.. member:: xml_element->getAttribute(name::string)::string

   Returns the value of the specified attribute. Returns an empty string if the
   attribute does not exist or has no value.

.. member:: xml_element->getAttributeNS(namespaceURI::string, localName::string)

   Returns the value of the attribute matching the given namespace and local
   name. Returns an empty string if the attribute does not exist or has no
   value.

.. member:: xml_element->getAttributeNode(name::string)

   Returns the specified attribute node. Returns "null" if the attribute does
   not exist.

.. member:: xml_element->getAttributeNodeNS(namespaceURI::string, localName::string)

   Returns the attribute node matching the given namespace and local name.
   Returns "null" if the attribute does not exist.

.. member:: xml_element->hasAttribute(name::string)::boolean

   Returns "true" if the specified attribute exists.

.. member:: xml_element->hasAttributeNS(namespaceURI::string, localName::string)::boolean

   Returns "true" if the attribute matching the given namespace and local name
   exists.

.. type:: xml_attr

.. member:: xml_attr->name()::string

   Returns the name of the attribute.

.. member:: xml_attr->ownerElement()

   Returns the element node that owns the attribute or "null" if the attribute
   is not in use.

.. member:: xml_attr->value()::string

   Returns the value of the attribute. This value is read/write.

.. type:: xml_nodeList

.. member:: xml_nodeList->length()::integer

   Returns the number of nodes in the list.

.. member:: xml_nodeList->item(index::integer)

   Returns the node indicated by the index. Indexes start at zero and go up to
   length-1. Returns "null" if the index is invalid.

.. type:: xml_nodeMap

.. member:: xml_nodeMap->length()::integer

   Returns the number of nodes in the map.

.. member:: xml_nodeMap->getNamedItem(name::string)

   Returns the node matching the indicated name.

.. member:: xml_nodeMap->getNamedItemNS(namespaceURI::string, localName::string)

   Returns the node matching the indicated namespace URI and local name.

.. member:: xml_nodeMap->item(index::integer)

   Returns the node indicated by the index. Indexes start at zero and go up to
   length-1. Returns "null" if the index is invalid.


Modifying XML Objects
---------------------

Various parts of an XML document can be modified. This includes setting node
values, adding or removing child nodes, adding or removing attributes, or
removing items from node maps.

.. member:: xml_node->nodeValue=(value::string)

   Sets the value of the node to the indicated string. Only the following node
   types can have their values set:  :type:`xml_attr`, :type:`xml_cdataSection`,
   :type:`xml_comment`, :type:`xml_processingInstruction`, :type:`xml_text`.

.. member:: xml_node->insertBefore(new::xml_node, ref::xml_node)::xml_node

   Inserts the new node into the document immediately before the ref node.
   Returns the newly inserted node.

.. member:: xml_node->replaceChild(new::xml_node, ref::xml_node)::xml_node

   Replaces the ref node in the document with the new node. Returns the new
   node.

.. member:: xml_node->appendChild(new::xml_node)::xml_node

   Inserts the new node into the document at the end of the target node's child
   list. Returns the new node.

.. member:: xml_node->removeChild(c::xml_node)::xml_node

   Removes the indicated child node from the document. Returns the removed node.

.. member:: xml_node->normalize()

   Modifies the document such that no two text nodes are adjacent. All adjacent
   text nodes are merged into one text node.

.. member:: xml_element->setAttribute(name::string, value::string)

   Adds an attribute with the given name and value. If the attribute already
   exists then the value is set accordingly.

.. member:: xml_element->setAttributeNS(uri::string, qname::string, value::string)

   Adds an attribute with the given namespace, name, and value. If the attribute
   already exists its value is set accordingly.

.. member:: xml_element->setAttributeNode(node::xml_attr)

   Adds the new attribute node. If an attribute with the same name already
   exists it is replaced. To add a namespace-aware attribute, use
   `xml_element->setAttributeNodeNS` instead.

.. member:: xml_element->setAttributeNodeNS(node::xml_attr)

   Adds the new attribute node. If an attribute with the same namespace/name
   combination already exists it is replaced.

.. member:: xml_element->removeAttribute(name::string)

   Removes the attribute with the indicated name.

.. member:: xml_element->removeAttributeNS(uri::string, qname::string)

   Removes the attribute with the given namespace/name combination.

.. member:: xml_element->removeAttributeNode(node::xml_attr)::xml_attr

   Removes the indicated attribute node. Returns the removed node.

.. note:: Some node maps are read-only and cannot be modified.

.. member:: xml_nodeMap->setNamedItem(node::xml_node)::xml_node

   Adds the node to the node map based on the "nodeName" value of the node.
   Replaces any duplicate node within the map. Returns the added node.

.. member:: xml_nodeMap->setNamedItemNS(node::xml_node)::xml_node

   Adds the node to the node map based on the namespace/name combination.
   Replaces any duplicate node within the map. Returns the added node.

.. member:: xml_nodeMap->removeNamedItem(name::string)

   Removes the node with the given name from the map. Returns the removed node.

.. member:: xml_nodeMap->removeNamedItemNS(uri::string, qname::string)

   Removes the node with the given namespace/name combination from the map.
   Returns the removed node.


XPath
=====

Lasso's XML API supports the XPath 1.0 specification. This support is available
on any :type:`xml_node` type through the `xml_node->extract` and
`xml_node->extractOne` methods. Consult the `XPath specification`_ for the
specifics of XPath syntax.


Using XPath
-----------

XPath is used to address a specific set of nodes within an XML document. For
example, child nodes matching a node name pattern can be located, or nodes with
specific attributes can be easily found within the document.

.. member:: xml_node->extract(xpath::string)

   Executes the XPath in the node and returns all matches as a staticarray.

.. member:: xml_node->extract(xpath::string, namespaces::staticarray)

   Executes the XPath in the node and returns all matches as a staticarray. This
   method should be used for XML documents that use namespaces. The second
   parameter is a staticarray containing the relevant namespace prefixes and URI
   pairs that are used within the XPath expression. Note that the namespace
   prefixes used in the XPath expression do not have to match those used within
   the document itself.

.. member:: xml_node->extractOne(xpath::string)

   Executes the XPath in the node and returns the first matching node or "null"
   if there are no matches.

.. member:: xml_node->extractOne(xpath::string, namespaces::staticarray)

   Executes the XPath in the node and returns the first matching node or "null"
   if there are no matches. This method should be used for XML documents that
   use namespaces. The second parameter is a staticarray containing the relevant
   namespace prefixes and URI pairs that are used within the XPath expression.
   Note that the namespace prefixes used in the XPath expression do not have to
   match those used within the document itself.


XPath Examples
^^^^^^^^^^^^^^

Extract all child elements of the a node::

   local(doc) = xml(
      '<a>
         <b at="val"/>
         <c at="val2">C Content</c>
      </a>')
   #doc->extract('//a/*')

   // => staticarray(<b at="val"/>, <c at="val2">C Content</c>)

Using namespaces, extract all child elements of the a node::

   local(doc) = xml(
      '<a xmlns="my_uri">
         <b at="val"/>
         <c at="val2">C Content</c>
      </a>')
   #doc->extract('//n:a/*', (: 'n'='my_uri'))

   // => staticarray(<b at="val"/>, <c at="val2">C Content</c>)

Extract the first child element of the a node::

   local(doc) = xml(
      '<a>
         <b at="val"/>
         <c at="val2">C Content</c>
      </a>')
   #doc->extractOne('//a/*')

   // => <b at="val"/>

Extract the ``"at"`` attribute from the second child element of the a node::

   local(doc) = xml(
      '<a xmlns="my_uri">
         <b at="val"/>
         <c at="val2">C Content</c>
      </a>')
   #doc->extractOne('//n:a/*[2]/@at', (: 'n'='my_uri'))

   // => at="val2"


XSLT
====

Lasso's XML API supports XSL Transformations (XSLT) 1.0. For the specifics of
XSLT, consult the `XSLT specification`_.

XSLT support is provided on any :type:`xml_node` type through the
`~xml_node->transform` method. This method accepts an XSLT template as a string
as well as a list of all variables to be made available during the
transformation. The transformation is performed and a new XML document is
returned.

.. member:: xml_node->transform(sheet::string, variables::staticarray)::xml_document

   Performs an XSLT transformation on the document and returns the resulting
   newly produced document.

.. _DOM Level 2 Core specification: http://www.w3.org/TR/DOM-Level-2-Core/
.. _XPath specification: http://www.w3.org/TR/xpath/
.. _XSLT specification: http://www.w3.org/TR/xslt/
