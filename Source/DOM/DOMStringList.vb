'''<summary>A type returned by some APIs which contains a list of DOMString (strings).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMStringList]
  '''<summary>Returns the length of the list.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Returns a DOMString.</summary>
  Function [item]() As String
  '''<summary>Returns Boolean indicating if the given string is in the list</summary>
  Function [contains]() As String
End Interface