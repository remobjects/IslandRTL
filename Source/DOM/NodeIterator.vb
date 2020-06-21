'''<Summary>The NodeIterator interface represents an iterator over the members of a list of the nodes in a subtree of the DOM. The nodes will be returned in document order.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NodeIterator]
'Defined on this type 
  '''<Summary>Returns a Node representing the root node as specified when the NodeIterator was created.</Summary>
  ReadOnly Property [root] As Node
  '''<Summary>Returns a NodeFilter used to select the relevant nodes.</Summary>
  ReadOnly Property [filter] As Node
End Interface