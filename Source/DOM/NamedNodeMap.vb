'''<Summary>The NamedNodeMap interface represents a collection of Attr objects. Objects inside a NamedNodeMap are not in any particular order, unlike NodeList, although they may be accessed by an index as in an array.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NamedNodeMap]
  '''<Summary>Returns the amount of objects in the map.</Summary>
  ReadOnly Property [length] As Integer
End Interface