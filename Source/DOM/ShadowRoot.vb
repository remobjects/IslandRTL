'''<summary>The ShadowRoot interface of the Shadow DOM API is the root node of a DOM subtree that is rendered separately from a document's main DOM tree.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ShadowRoot]
  '''<summary>Returns a reference to the DOM element the ShadowRoot is attached to.</summary>
  ReadOnly Property [host] As Element
  '''<summary>The mode of the ShadowRoot — either open or closed. This defines whether or not the shadow root's internal features are accessible from JavaScript.</summary>
  ReadOnly Property [mode] As Dynamic
  '''<summary>Returns the topmost element at the specified coordinates.</summary>
  Sub [elementFromPoint]([parx] As Dynamic, [pary] As Dynamic)
End Interface