'''<Summary>An object implementing the StyleSheet interface represents a single style sheet. CSS style sheets will further implement the more specialized CSSStyleSheet interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [StyleSheet]
  '''<Summary>Is a Boolean representing whether the current stylesheet has been applied or not.</Summary>
  Property [disabled] As Boolean
  '''<Summary>Returns a DOMString representing the location of the stylesheet.</Summary>
  ReadOnly Property [href] As String
  '''<Summary>Returns a MediaList representing the intended destination medium for style information.</Summary>
  ReadOnly Property [media] As Dynamic
  '''<Summary>Returns a Node associating this style sheet with the current document.</Summary>
  ReadOnly Property [ownerNode] As Node
  '''<Summary>Returns a StyleSheet including this one, if any; returns null if there aren't any.</Summary>
  ReadOnly Property [parentStyleSheet] As StyleSheet
  '''<Summary>Returns a DOMString representing the advisory title of the current style sheet.</Summary>
  ReadOnly Property [title] As String
  '''<Summary>Returns a DOMString representing the style sheet language for this style sheet.</Summary>
  ReadOnly Property [type] As Dynamic
End Interface