'''<summary>The NamedNodeMap interface represents a collection of Attr objects. Objects inside a NamedNodeMap are not in any particular order, unlike NodeList, although they may be accessed by an index as in an array.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NamedNodeMap]
  '''<summary>Returns the amount of objects in the map.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Returns the Attr at the given index, or null if the index is higher or equal to the number of nodes.</summary>
  Default Property [item](parIndex as String) As Integer
End Interface