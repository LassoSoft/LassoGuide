.. _xml:

***
XML
***

Lasso provides a full suite of objects for both constructing new XML documents
and parsing existing XML documents. Lasso's implementation follows the `DOM
Level 2 Core specification`_ as closely as possible. This introduces a series of
objects each representing the various components that can be found within an XML
document. The Lasso object names match up with the objects specified in the DOM
standard with the addition of an ``xml_`` prefix. Also provided is a simplified
method for parsing existing XML data. This method is called 'xml' and does not
conform to the DOM specification.

Lasso also provides both XPath and XSLT functionality. This functionality is
integrated into the XML object model although it is not considered part of the
DOM specification itself.

In cases where elements are accessed by numeric position, Lasso's implementation
conforms to the DOM specification's zero-based indexes, as opposed to Lasso's
standard one-based positions. This will be noted in all relevant cases within
this chapter.

The following table lists all the possible objects which may be encountered
within or inserted into an XML document.

========================= ===================== ================================
Lasso Object Name         DOM Level 2 Name      Purpose
========================= ===================== ================================
xml_DOMImplementation     DOMImplementation     Creates xml_document and
                                                xml_documentType objects. Can
                                                parse existing XML documents or
                                                create new empty documents.
xml_node                  Node                  Base functionality supported by
                                                all objects.
xml_document              Document              Represents the entire document;
                                                provides access to the
                                                document's data.
xml_element               Element               Represents an XML element node.
xml_attr                  Attr                  Represents an attribute of an
                                                XML element node.
xml_characterData         CharacterData         Represents character data within
                                                the document. This is the base
                                                object type for xml_text and
                                                xml_cdataSection objects.
xml_text                  Text                  Represents the character data of
                                                an xml_element or xml_attr node.
xml_cdataSection          CDATASection          Represents  a CDATA node.
xml_entityReference       EntityReference       Represents an entity reference.
xml_entity                Entity                Represents a parsed or unparsed
                                                entity within the document.
xml_processingInstruction ProcessingInstruction Represents a processing
                                                instruction located within the
                                                document.
xml_comment               Comment               Represents the content of an XML
                                                comment node.
xml_documentType          DocumentType          Represents the doctype attribute
                                                of an XML document.
xml_documentFragment      DocumentFragment      Represents a minimal document
                                                object.
xml_notation              Notation              Represents a notation declared
                                                in the DTD.
xml_nodeList              NodeList              Represents a list of node
                                                objects. Provides random access
                                                to the list. This list uses
                                                zero-based indexes, in contrast
                                                to Lasso's standard one-based
                                                positions.
xml_namedNodeMap          NamedNodeMap          Represents a collection of nodes
                                                which can be accessed by name.
========================= ===================== ================================

Creating XML Documents
======================

XML documents are created either from existing XML character data or from
scratch. A document created from scratch will initially contain only the root
document node which can then have children or attributes added to it. A document
created from existing XML character data will be parsed and validated and the
resulting document object tree will be created. When attempting to create an XML
document from existing data, if the data is not valid then a failure will be
generated during parsing. The current ``error_msg`` will indicate the error that
was encountered.

New XML documents can be created in one of two ways: the DOM Level 2-conformant
xml_DOMImplementation object, or the xml(…) method. Both have the same
abilities, but the xml(…) method provides a simplified interface and is
compatible with earlier Lasso versions. It's important to note that xml(…) is
not itself an object, it is merely a method which provides a moderately easier
to use interface to XML document creation. Internally, the xml(…) method
utilizes the xml_DOMImplementation object and therefore provides equivalent
functionality to the xml_DOMImplementation object.

The xml(…) method is presented in five variations; two for parsing existing XML
documents and three for creating new from-scratch documents.

The first two methods parse existing XML data in either string or raw bytes
form. If the document parsing is successful, these methods return the top-level
xml_document node object.

.. method:: xml(text::string)
.. method:: xml(text::bytes)

   The subsequent three methods create a new document consisting of only the
   root xml_document node and no children. These methods return the top-level
   xml_document node object. The first two methods create the document given a
   namespace and a root element name, along with an optional document type node
   (an xml_documentType, created through the
   xml_DOMImplementation->createDocumentType method). The third method takes
   zero parameters and returns a document with no namespace and the root element
   name set to "none".

.. method:: xml(namespaceUri::string, rootNodeName::string)
.. method:: xml(namespaceUri::string, rootNodeName::string, dtd::xml_documentType)
.. method:: xml()

   In all cases, the resulting value from the xml(…) method will be the root
   element of the document. This will be an object of type xml_element. It's
   important to note that this is not the xml_document object, which differs
   from the root element node. This behavior is a departure from that of the
   xml_DOMImplementation object which does return the xml_document object
   itself. The owning xml_document object can be obtained from any node within
   that document by calling the xml_node->ownerDocument method.

Examples - Create XML document from existing data::

   local(myDocumentText = '<a><b>b content</b><c/></a>')
   local(myDocumentObj = xml(#myDocumentText))

Create XML document from scratch::

   local(myDocumentObj = xml('my_namespace', 'a'))

The xml_DOMImplementation object provides comparable functionality to the xml(…)
method, but follows the DOM Level 2 specification. The xml_DOMImplementation
object itself is stateless and can be created with zero parameters. Once an
xml_DOMImplementation object is obtained it can be used to create or parse XML
documents as well as create XML document types.

This functionality is presented in the following four methods.

.. class:: xml_DOMImplementation

.. method:: createDocument(namespaceUri::string, rootNodeName::string)
.. method:: createDocument(namespaceUri::string, rootNodeName::string, dtd::xml_documentType)
.. method:: parseDocument(text::bytes)
.. method:: createDocumentType(qname::string, publicId::string, systemId::string)

In contrast to the xml(…) method, when creating or parsing an XML document the
xml_DOMImplementation returns the document node. This will be an object of type
xml_document. It's important to note that this is not the root element node. The
root element node can be obtained through the xml_document->documentElement
method.

Examples - Create XML document from existing data::

   local(myDocumentText = '<a><b>b content</b><c/></a>')
   local(myDocumentObj =
   xml_DOMImplementation->parseDocument(
      bytes(#myDocumentText)))

Create XML document from scratch::

   local(domImpl = xml_DOMImplementation,
   docType = #domImpl->createDocumentType(
      'svg:svg',
      '-//W3C//DTD SVG 1.1//EN',
      'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'))
   local(myDocumentObj =
   #domImpl->createDocument(
      'http://www.w3.org/2000/svg',
      'svg:svg',
      #docType))

The resulting document would have the following format::

   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE svg:svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
   <svg xmlns:svg="http://www.w3.org/2000/svg"/>

Creating XML Node Objects
-------------------------

While the xml_DOMImplementation object is responsible for creating the initial
xml_document object, the xml_document object is the means through which new XML
node object types are created, including element, attribute and text nodes. All
XML objects always belong to a particular xml_document instance. No XML node
objects can be created without an existing document. Nodes can be copied into
another existing xml_document, but nodes are never shared between documents.

The following methods are use for creating new nodes:

.. class:: xml_document

.. method:: createElement(tagName::string)::xml_element
.. method:: createElementNS(
               namespaceURI::string,
               qualifiedName::string)::xml_element

   The first version of creates a new element node without a namespace. The
   second version permits a namespace to be specified.

.. method:: createAttribute(name::string)::xml_attr
.. method:: createAttributeNS(
               namespaceURI::string,
               qualifiedName::string)::xml_attr

   The first version of creates a new attribute without a namespace. The second
   version permits a namespace to be specified.

.. method:: createDocumentFragment()::xml_documentFragment
.. method:: createTextNode(data::string)::xml_text
.. method:: createComment(data::string)::xml_comment
.. method:: createCDATASection(data::string)::xml_cdataSection
.. method:: createProcessingInstruction(
               target::string,
               data::string)::xml_processingInstruction
.. method:: createEntityReference(name::string)::xml_entityReference

.. class:: xml_node

.. method:: importNode(importedNode::xml_node, deep::boolean)::xml_node

   Imports a node from another document into the document of the target object
   and returns the new node. The new node is not yet placed within the current
   document and so it has no parent. If false is given for parameter two, then
   the node's children and attributes are not copied. If true is given, then all
   attributes and child nodes are copied into the current document.

Inspecting XML Objects
----------------------

Lasso's XML interface permits all the various pieces of an XML document to be
inspected. This includes accessing attributes, node content, node children etc.
The methods listed in this section are not meant to be exhaustive but instead to
show the methods most commonly utilized when working with an XML document.

.. class:: xml_node

.. method:: nodeType()::string

   Returns the name of the type of node. For example, an xml_element node would
   return "ELEMENT_NODE". This is in contrast to the DOM Level 2 specification
   which returns an integer value.

.. method:: nodeName()::string

   Returns the name of the node. This value will depend on the type of the node
   in question. For xml_element nodes, this will be the same value as the tag
   name. For xml_attr nodes, this will be the same as the attribute name.

.. method:: prefix()

   Returns the namespace prefix of the node or null if it is unspecified.

.. method:: localName()

   Returns the local part of the qualified name of the node.

.. method:: namespaceURI()

   Returns the namespace URI of the node or null or null if it is unspecified.

.. method:: nodeValue()

   Returns the value of the node as a string. This result will vary depending on
   the node type. For example an attribute node will return the attribute value.
   A text node will return the text content for the node. Many node types, such
   as element nodes, will return null. This value is read/write for nodes that
   have values.

.. method:: parentNode()

   Returns the parent of the node or null if there is no parent. Some, such as
   attribute nodes and the document node, do not have parents.

.. method:: ownerDocument()

   Returns the xml_document which is the owner of the target node. In the case
   of the document node, this will be null.

.. class:: xml_element

.. method:: tagName()::string

   Returns the name of the element.

.. method:: getAttribute(name::string)::string

   Returns the value of the specified attribute. Returns an empty string if the
   attribute does not exist or has no value.

.. method:: getAttributeNS(namespaceURI::string, localName::string)

   Returns the value of the attribute matching the given namespace and local
   name. Returns an empty string if the attribute does not exist or has no
   value.

.. method:: getAttributeNode(name::string)

   Returns the specified attribute node. Returns null if the attribute does not
   exist.

.. method:: getAttributeNodeNS(namespaceURI::string, localName::string)

   Returns the attribute node matching the given namespace and local name.
   Returns null if the attribute does not exist.

.. method:: hasAttribute(name::string)::boolean

   Returns true if the specified attribute exists.

.. method:: hasAttributeNS(
            namespaceURI::string, localName::string)::boolean

   Returns true if the attribute matching the given namespace and local name
   exists.

.. class:: xml_attr

.. method:: name()::string

   Returns the name of the attribute.

.. method:: ownerElement()

   Returns the element node which owns the attribute or null if the attribute is
   not in use.

.. method:: value()::string

   Returns the value of the attribute. This value is read/write.

.. class:: xml_nodeList

.. method:: length()::integer

   Returns the number of nodes in the list.

.. method:: item(index::integer)

   Returns the node indicated by the index. Indexes start at zero and go up to
   length-1. Returns null if the index is invalid.

.. class:: xml_nodeMap

.. method:: length()::integer

   Returns the number of nodes in the map.

.. method:: getNamedItem(name::string)

   Returns the node matching the indicated name.

.. method:: getNamedItemNS(namespaceURI::string, localName::string)

   Returns the node matching the indicated namespace URI and local name.

.. method:: item(index::integer)

   Returns the node indicated by the index. Indexes start at zero and go up to
   length-1. Returns null if the index is invalid.

Modifying XML Objects
---------------------

Various parts of an XML document can be modified. This includes setting node
values, adding or removing child nodes, adding or removing attributes, or
removing items from node maps.

.. class:: xml_node

.. method:: nodeValue=(value::string)

   Sets the value of the node to the indicated string. Only the following node
   types can have their values set:  xml_attr, xml_cdataSection, xml_comment,
   xml_processingInstruction, xml_text

.. method:: insertBefore(new::xml_node, ref::xml_node)::xml_node

   Inserts the new node into the document immediately before the ref node.
   Returns the newly inserted node.

.. method:: replaceChild(new::xml_node, ref::xml_node)::xml_node

   Replaces the ref node in the document with the new node. Returns the new
   node.

.. method:: appendChild(new::xml_node)::xml_node

   Inserts the new node into the document at the end of the target node's child
   list. Returns the new node.

.. method:: removeChild(c::xml_node)::xml_node

   Removes the indicated child node from the document. Returns the removed node.

.. method:: normalize()

   This method modifies the document such that no two text nodes are adjacent.
   All adjacent text nodes are merged into one text node.

.. class:: xml_element

.. method:: setAttribute(name::string, value::string)

   Adds an attribute with the given name and value. If the attribute already
   exists then the value is set accordingly.

.. method:: setAttributeNS(uri::string, qname::string, value::string)

   Adds an attribute with the given namespace, name and value. If the attribute
   already exists its value is set accordingly.

.. method:: setAttributeNode(node::xml_attr)

   Adds the new attribute node. If an attribute with the same name already
   exists it is replaced. To add a namespace aware attribute, use
   setAttributeNodeNS instead.

.. method:: setAttributeNodeNS(node::xml_attr)

   Adds the new attribute node. If an attribute with the same namespace/name
   combination already exists it is replaced.

.. method:: removeAttribute(name::string)

   Removes the attribute with the indicated name.

.. method:: removeAttributeNS(uri::string, qname::string)

   Removes the attribute with the given namespace/name combination.

.. method:: removeAttributeNode(node::xml_attr)::xml_attr

   Removes the indicated attribute node. Returns the removed node.

.. class:: xml_nodeMap

   Note that some node maps are read-only and can not be modified.

.. method:: setNamedItem(node::xml_node)::xml_node

   Adds the node to the node map based on the nodeName value of the node.
   Replaces any duplicate node within the map. Returns the added node.

.. method:: setNamedItemNS(node::xml_node)::xml_node

   Adds the node to the node map based on the namespace/name combination.
   Replaces any duplicate node within the map. Returns the added node.

.. method:: removeNamedItem(name::string)

   Removes the node with the given name from the map. Returns the removed node.

.. method:: removeNamedItemNS(uri::string, qname::string)

   Removes the node with the given namespace/name combination from the map.
   Returns the removed node.

XPath
=====

Lasso's XML API supports the XPath 1.0 specification. This support is available
on any xml_node type through the extract() and extractOne() methods. Consult the
`XPath specification`_ for the specifics of XPath syntax.

XPath is used to address a specific set of nodes within an XML document. For
example, child nodes matching a node name pattern can be located, or nodes with
specific attributes can be easily found within the document.

.. class:: xml_node

.. method:: extract(xpath::string)

   Executes the XPath in the node and returns all matches as a staticarray.

.. method:: extract(xpath::string, namespaces::staticarray)

   Executes the XPath in the node and returns all matches as a staticarray. This
   method should be used for XML documents which utilize namespaces. The second
   parameter is a staticarray containing the relevant namespace prefixes and URI
   pairs which are used within the XPath expression. Note that the namespace
   prefixes used in the XPath expression do not have to match those used within
   the document itself.

.. method:: extractOne(xpath::string)

   Executes the XPath in the node and returns the first matching node or null if
   there are no matches.

.. method:: extractOne(xpath::string, namespaces::staticarray)

   Executes the XPath in the node and returns the first matching node or null if
   there are no matches. This method should be used for XML documents which
   utilize namespaces. The second parameter is a staticarray containing the
   relevant namespace prefixes and URI pairs which are used within the XPath
   expression. Note that the namespace prefixes used in the XPath expression do
   not have to match those used within the document itself.

Examples - Extract all child elements of the a node::

   local(doc = xml(
   '<a>
      <b at="val"/>
      <c at="val2">C Content</c>
   </a>'))

   #doc->extract('//a/*')

   // => staticarray(<b at="val"/>, <c at="val2">C Content</c>)

Utilizing namespaces, extract all child elements of the a node::

   local(doc = xml(
   '<a xmlns="my_uri">
      <b at="val"/>
      <c at="val2">C Content</c>
   </a>'))

   #doc->extract('//n:a/*', (:'n'='my_uri'))

   // => staticarray(<b at="val"/>, <c at="val2">C Content</c>)

Extract the first child element of the a node::

   local(doc = xml(
   '<a>
      <b at="val"/>
      <c at="val2">C Content</c>
   </a>'))

   #doc->extractOne('//a/*')

   // => <b at="val"/>

Extract the 'at' attribute from the second child element of the a node::

   local(doc = xml(
   '<a xmlns="my_uri">
      <b at="val"/>
      <c at="val2">C Content</c>
   </a>'))

   #doc->extractOne('//n:a/*[2]/@at', (:'n'='my_uri'))

   // => at="val2"

XSLT
====

Lasso's XML API supports XML transformations (XSLT) 1.0. For the specifics of
XSLT, consult the `XSLT specification`_.

XSLT support is provided on any xml_node type through the transform() method.
This method accepts an XSLT template as a string as well as a list of all
variables to be made available during the transformation. The transformation is
performed and a new XML document is returned.

.. class:: xml_node

.. method:: transform(sheet::string,
            variables::staticarray)::xml_document

   Performs an XSLT transformation on the document and returns the resulting
   newly produced document.

.. _DOM Level 2 Core specification: http://www.w3.org/TR/DOM-Level-2-Core/
.. _XPath specification: http://www.w3.org/TR/xpath/
.. _XSLT specification: http://www.w3.org/TR/xslt