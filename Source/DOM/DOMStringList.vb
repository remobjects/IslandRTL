'''<Summary>A type returned by some APIs which contains a list of DOMString (strings).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMStringList]
  '''<Summary>Returns the length of the list.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Returns a DOMString.</Summary>
  Default Property [item]() As String
  '''<Summary>Returns Boolean indicating if the given string is in the list</Summary>
  Function [contains]() As String
End Interface