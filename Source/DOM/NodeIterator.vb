'''<Summary>The NodeIterator interface represents an iterator over the members of a list of the nodes in a subtree of the DOM. The nodes will be returned in document order.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NodeIterator]
  '''<Summary>Returns a Node representing the root node as specified when the NodeIterator was created.</Summary>
  ReadOnly Property [root] As Node
  '''<Summary>Returns a NodeFilter used to select the relevant nodes.</Summary>
  ReadOnly Property [filter] As Node
  '''<Summary>Returns the previous Node in the document, or null if there are none.</Summary>
  Function [previousNode]() As Node
  '''<Summary>Returns the next Node in the document, or null if there are none.</Summary>
  Function [nextNode]() As Node
End Interface