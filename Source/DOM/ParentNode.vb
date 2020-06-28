'''<Summary>The ParentNode mixin contains methods and properties that are common to all types of Node objects that can have children.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ParentNode]
  '''<Summary>Returns the number of children of this ParentNode which are elements.</Summary>
  ReadOnly Property [childElementCount] As Double
  '''<Summary>Returns a live HTMLCollection containing all of the Element objects that are children of this ParentNode, omitting all of its non-element nodes.</Summary>
  ReadOnly Property [children] As HTMLCollection
  '''<Summary>Returns the first node which is both a child of this ParentNode and is also an Element, or null if there is none.</Summary>
  ReadOnly Property [firstElementChild] As Node
  '''<Summary>Returns the last node which is both a child of this ParentNode and is an Element, or null if there is none.</Summary>
  ReadOnly Property [lastElementChild] As Node
End Interface