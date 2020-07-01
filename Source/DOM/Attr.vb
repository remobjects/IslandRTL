'''<Summary>The Attr interface represents one of a DOM element's attributes as an object. In most DOM methods, you will directly retrieve the attribute as a string (e.g., Element.getAttribute()), but certain functions (e.g., Element.getAttributeNode()) or means of iterating return Attr types.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Attr]
  '''<Summary>The attribute's name.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>A DOMString representing the namespace URI of the attribute, or null if there is no namespace.</Summary>
  ReadOnly Property [namespaceURI] As String
  '''<Summary>A DOMString representing the local part of the qualified name of the attribute.</Summary>
  ReadOnly Property [localName] As String
  '''<Summary>A DOMString representing the namespace prefix of the attribute, or null if no prefix is specified.</Summary>
  ReadOnly Property [prefix] As String
  '''<Summary></Summary>
  ReadOnly Property [ownerElement] As Element
  '''<Summary>This property always returns true. Originally, it returned true if the attribute was explicitly specified in the source code or by a script, and false if its value came from the default one defined in the document's DTD.</Summary>
  ReadOnly Property [specified] As Boolean
  '''<Summary>The attribute's value.</Summary>
  Property [value] As String
End Interface