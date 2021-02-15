'''<summary>The DocumentFragment interface represents a minimal document object that has no parent. It is used as a lightweight version of Document that stores a segment of a document structure comprised of nodes just like a standard document.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DocumentFragment]
  '''<summary>Returns the first Element node within the DocumentFragment, in document order, that matches the specified selectors.</summary>
  Function [querySelector]([parselectors] As Dynamic) As Element
  '''<summary>Returns a NodeList of all the Element nodes within the DocumentFragment that match the specified selectors.</summary>
  Function [querySelectorAll]([parselectors] As Dynamic) As HTMLElement
  '''<summary>Returns the first Element node within the DocumentFragment, in document order, that matches the specified ID. Functionally equivalent to Document.getElementById().</summary>
  Function [getElementById]() As Element
End Interface