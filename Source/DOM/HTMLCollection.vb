'''<Summary>The HTMLCollection interface represents a generic collection (array-like object similar to arguments) of elements (in document order) and offers methods and properties for selecting from the list.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLCollection]
  '''<Summary>Returns the number of items in the collection.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Returns the specific node at the given zero-based index into the list. Returns null if the index is out of range.</Summary>
  Default Property [item]([parindex] As Dynamic) As Node
  '''<Summary>Returns the specific node whose ID or, as a fallback, name matches the string specified by name. Matching by name is only done as a last resort, only in HTML, and only if the referenced element supports the name attribute. Returns null if no node exists by the given name.</Summary>
  Function [namedItem]() As String
End Interface