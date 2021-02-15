'''<summary>The Range interface represents a fragment of a document that can contain nodes and parts of text nodes.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Range]
  '''<summary>Returns a Boolean indicating whether the range's start and end points are at the same position.</summary>
  ReadOnly Property [collapsed] As Boolean
  '''<summary>Returns the deepest Node that contains the startContainer and endContainer nodes.</summary>
  ReadOnly Property [commonAncestorContainer] As Node
  '''<summary>Returns a number representing where in the endContainer the Range ends.</summary>
  ReadOnly Property [endOffset] As Double
  '''<summary>Returns a number representing where in the startContainer the Range starts.</summary>
  ReadOnly Property [startOffset] As Double
  '''<summary>Sets the start position of a Range.</summary>
  Function [setStart]([parstartNode] As Dynamic, [parstartOffset] As Dynamic) As String
  '''<summary>Sets the end position of a Range.</summary>
  Sub [setEnd]([parendNode] As Dynamic, [parendOffset] As Dynamic)
  '''<summary>Sets the Range to contain the Node and its contents.</summary>
  Function [selectNode]([parreferenceNode] As Dynamic) As Node
  '''<summary>Sets the Range to contain the contents of a Node.</summary>
  Function [selectNodeContents]([parreferenceNode] As Dynamic) As Node
  '''<summary>Insert a Node at the start of a Range.</summary>
  Function [insertNode]([parnewNode] As Dynamic) As Node
  '''<summary>Compares the boundary points of the Range with another Range.</summary>
  Function [compareBoundaryPoints]([parhow] As Dynamic, [parsourceRange] As Dynamic) As Double
  '''<summary>Returns a Range object with boundary points identical to the cloned Range.</summary>
  Function [cloneRange]() As Dynamic
  '''<summary>Returns the text of the Range.</summary>
  Function [toString]() As String
End Interface