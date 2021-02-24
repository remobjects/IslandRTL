'''<summary>The Attr interface represents one of a DOM element's attributes as an object. In most DOM methods, you will directly retrieve the attribute as a string (e.g., Element.getAttribute()), but certain functions (e.g., Element.getAttributeNode()) or means of iterating return Attr types.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Attr]
  '''<summary>The attribute's name.</summary>
  ReadOnly Property [name] As String
  '''<summary>A DOMString representing the namespace URI of the attribute, or null if there is no namespace.</summary>
  ReadOnly Property [namespaceURI] As String
  '''<summary>A DOMString representing the local part of the qualified name of the attribute.</summary>
  ReadOnly Property [localName] As String
  '''<summary>A DOMString representing the namespace prefix of the attribute, or null if no prefix is specified.</summary>
  ReadOnly Property [prefix] As String
  '''<summary></summary>
  ReadOnly Property [ownerElement] As Element
  '''<summary>This property always returns true. Originally, it returned true if the attribute was explicitly specified in the source code or by a script, and false if its value came from the default one defined in the document's DTD.</summary>
  ReadOnly Property [specified] As Boolean
  '''<summary>The attribute's value.</summary>
  Property [value] As String
End Interface