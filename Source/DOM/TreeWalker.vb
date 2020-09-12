'''<Summary>The TreeWalker object represents the nodes of a document subtree and a position within them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TreeWalker]
  '''<Summary>Returns a Node representing the root node as specified when the TreeWalker was created.</Summary>
  ReadOnly Property [root] As Node
  '''<Summary>Returns a NodeFilter used to select the relevant nodes.</Summary>
  ReadOnly Property [filter] As Node
  '''<Summary>Is the Node on which the TreeWalker is currently pointing at.</Summary>
  Property [currentNode] As Node
  '''<Summary>Moves the current Node to the first visible ancestor node in the document order, and returns the found node. It also moves the current node to this one. If no such node exists, or if it is before that the root node defined at the object construction, returns null and the current node is not changed.</Summary>
  Function [parentNode]() As Node
  '''<Summary>Moves the current Node to the first visible child of the current node, and returns the found child. It also moves the current node to this child. If no such child exists, returns null and the current node is not changed.</Summary>
  Function [firstChild]([parExamplevar treeWalker = document.createTreeWalker(  document.body] As Dynamic, [parNodeFilter.SHOW_ELEMENT] As Dynamic, [par{ acceptNode: function(node] As Dynamic) As Node
  '''<Summary>Moves the current Node to the last visible child of the current node, and returns the found child. It also moves the current node to this child. If no such child exists, null is returned and the current node is not changed.</Summary>
  Function [lastChild]() As Node
  '''<Summary>Moves the current Node to its previous sibling, if any, and returns the found sibling. If there is no such node, return null and the current node is not changed.</Summary>
  Function [previousSibling]() As Node
  '''<Summary>Moves the current Node to its next sibling, if any, and returns the found sibling. If there is no such node, null is returned and the current node is not changed.</Summary>
  Function [nextSibling]() As Node
  '''<Summary>Moves the current Node to the previous visible node in the document order, and returns the found node. It also moves the current node to this one. If no such node exists, or if it is before that the root node defined at the object construction, returns null and the current node is not changed.</Summary>
  Function [previousNode]() As Node
  '''<Summary>Moves the current Node to the next visible node in the document order, and returns the found node. It also moves the current node to this one. If no such node exists, returns null and the current node is not changed.</Summary>
  Function [nextNode]() As Node
End Interface