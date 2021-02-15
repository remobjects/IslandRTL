'''<summary>The TreeWalker object represents the nodes of a document subtree and a position within them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TreeWalker]
  '''<summary>Returns a Node representing the root node as specified when the TreeWalker was created.</summary>
  ReadOnly Property [root] As Node
  '''<summary>Returns a NodeFilter used to select the relevant nodes.</summary>
  ReadOnly Property [filter] As Node
  '''<summary>Is the Node on which the TreeWalker is currently pointing at.</summary>
  Property [currentNode] As Node
End Interface