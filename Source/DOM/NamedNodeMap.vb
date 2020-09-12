'''<Summary>The NamedNodeMap interface represents a collection of Attr objects. Objects inside a NamedNodeMap are not in any particular order, unlike NodeList, although they may be accessed by an index as in an array.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NamedNodeMap]
  '''<Summary>Returns the amount of objects in the map.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Replaces, or adds, the Attr identified in the map by the given name.</Summary>
  Function [setNamedItem]() As Attr
  '''<Summary>Removes the Attr identified by the given map.</Summary>
  Function [removeNamedItem]() As Attr
  '''<Summary>Returns the Attr at the given index, or null if the index is higher or equal to the number of nodes.</Summary>
  Default Property [item]() As Double
  '''<Summary>Returns a Attr identified by a namespace and related local name.</Summary>
  Function [getNamedItemNS]() As Attr
  '''<Summary>Replaces, or adds, the Attr identified in the map by the given namespace and related local name.</Summary>
  Function [setNamedItemNS]() As Attr
  '''<Summary>Removes the Attr identified by the given namespace and related local name.</Summary>
  Function [removeNamedItemNS]() As Attr
End Interface