'''<summary>An object implementing the StyleSheet interface represents a single style sheet. CSS style sheets will further implement the more specialized CSSStyleSheet interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [StyleSheet]
  '''<summary>Is a Boolean representing whether the current stylesheet has been applied or not.</summary>
  Property [disabled] As Boolean
  '''<summary>Returns a DOMString representing the location of the stylesheet.</summary>
  ReadOnly Property [href] As String
  '''<summary>Returns a MediaList representing the intended destination medium for style information.</summary>
  ReadOnly Property [media] As Dynamic
  '''<summary>Returns a Node associating this style sheet with the current document.</summary>
  ReadOnly Property [ownerNode] As Node
  '''<summary>Returns a DOMString representing the advisory title of the current style sheet.</summary>
  ReadOnly Property [title] As String
  '''<summary>Returns a DOMString representing the style sheet language for this style sheet.</summary>
  ReadOnly Property [type] As Dynamic
End Interface