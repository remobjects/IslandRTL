'''<summary>The NodeIterator interface represents an iterator over the members of a list of the nodes in a subtree of the DOM. The nodes will be returned in document order.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NodeIterator]
  '''<summary>Returns a Node representing the root node as specified when the NodeIterator was created.</summary>
  ReadOnly Property [root] As Node
  '''<summary>Returns a NodeFilter used to select the relevant nodes.</summary>
  ReadOnly Property [filter] As Node
End Interface