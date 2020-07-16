'''<Summary>The Range interface represents a fragment of a document that can contain nodes and parts of text nodes.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Range]
  '''<Summary>Returns a Boolean indicating whether the range's start and end points are at the same position.</Summary>
  ReadOnly Property [collapsed] As Boolean
  '''<Summary>Returns the deepest Node that contains the startContainer and endContainer nodes.</Summary>
  ReadOnly Property [commonAncestorContainer] As Node
  '''<Summary>Returns a number representing where in the endContainer the Range ends.</Summary>
  ReadOnly Property [endOffset] As Double
  '''<Summary>Returns a number representing where in the startContainer the Range starts.</Summary>
  ReadOnly Property [startOffset] As Double
  '''<Summary>Sets the start position of a Range.</Summary>
  Function [setStart]([parstartNode] As Dynamic, [parstartOffset] As Dynamic) As String
  '''<Summary>Sets the end position of a Range.</Summary>
  Sub [setEnd]([parendNode] As Dynamic, [parendOffset] As Dynamic)
  '''<Summary>Sets the Range to contain the Node and its contents.</Summary>
  Function [selectNode]([parreferenceNode] As Dynamic) As Node
  '''<Summary>Sets the Range to contain the contents of a Node.</Summary>
  Function [selectNodeContents]([parreferenceNode] As Dynamic) As Node
  '''<Summary>Insert a Node at the start of a Range.</Summary>
  Function [insertNode]([parnewNode] As Dynamic) As Node
  '''<Summary>Compares the boundary points of the Range with another Range.</Summary>
  Function [compareBoundaryPoints]([parhow] As Dynamic, [parsourceRange] As Dynamic) As Double
  '''<Summary>Returns a Range object with boundary points identical to the cloned Range.</Summary>
  Function [cloneRange]() As Dynamic
  '''<Summary>Returns the text of the Range.</Summary>
  Function [toString]() As String
End Interface