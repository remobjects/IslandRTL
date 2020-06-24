'''<Summary>The TreeWalker object represents the nodes of a document subtree and a position within them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TreeWalker]
'Defined on this type 
  '''<Summary>Returns a Node representing the root node as specified when the TreeWalker was created.</Summary>
  ReadOnly Property [root] As Node
  '''<Summary>Returns a NodeFilter used to select the relevant nodes.</Summary>
  ReadOnly Property [filter] As Node
  '''<Summary>Is the Node on which the TreeWalker is currently pointing at.</Summary>
  Property [currentNode] As Node
End Interface