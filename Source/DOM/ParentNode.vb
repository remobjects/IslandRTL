'''<summary>The ParentNode mixin contains methods and properties that are common to all types of Node objects that can have children.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ParentNode]
  '''<summary>Returns the number of children of this ParentNode which are elements.</summary>
  ReadOnly Property [childElementCount] As Double
  '''<summary>Returns a live HTMLCollection containing all of the Element objects that are children of this ParentNode, omitting all of its non-element nodes.</summary>
  ReadOnly Property [children] As HTMLCollection
  '''<summary>Returns the first node which is both a child of this ParentNode and is also an Element, or null if there is none.</summary>
  ReadOnly Property [firstElementChild] As Node
  '''<summary>Returns the last node which is both a child of this ParentNode and is an Element, or null if there is none.</summary>
  ReadOnly Property [lastElementChild] As Node
  '''<summary>Returns the first Element with the current element as root that matches the specified group of selectors.</summary>
  Function [querySelector]([parselectors] As Dynamic) As Element
  '''<summary>Returns a NodeList representing a list of elements with the current element as root that matches the specified group of selectors.</summary>
  Function [querySelectorAll]([parselectors] As Dynamic) As Node
  '''<summary>Replaces the existing children of a node with a specified new set of children.</summary>
  Function [replaceChildren]() As Dynamic
End Interface