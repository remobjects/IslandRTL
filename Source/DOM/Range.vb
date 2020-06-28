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
End Interface