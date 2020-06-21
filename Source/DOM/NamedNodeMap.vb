'''<Summary>The NamedNodeMap interface represents a collection of Attr objects. Objects inside a NamedNodeMap are not in any particular order, unlike NodeList, although they may be accessed by an index as in an array.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NamedNodeMap]
'Defined on this type 
  '''<Summary>Returns the amount of objects in the map.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Returns the Attr at the given index, or null if the index is higher or equal to the number of nodes.</Summary>
  Function [item]() As Double
End Interface