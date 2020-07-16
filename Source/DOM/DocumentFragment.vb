'''<Summary>The DocumentFragment interface represents a minimal document object that has no parent. It is used as a lightweight version of Document that stores a segment of a document structure comprised of nodes just like a standard document.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DocumentFragment]
  '''<Summary>Returns the first Element node within the DocumentFragment, in document order, that matches the specified selectors.</Summary>
  Function [querySelector]([parselectors] As Dynamic) As Element
  '''<Summary>Returns a NodeList of all the Element nodes within the DocumentFragment that match the specified selectors.</Summary>
  Function [querySelectorAll]([parselectors] As Dynamic) As HTMLElement
  '''<Summary>Returns the first Element node within the DocumentFragment, in document order, that matches the specified ID. Functionally equivalent to Document.getElementById().</Summary>
  Function [getElementById]() As Element
End Interface