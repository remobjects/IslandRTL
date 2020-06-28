'''<Summary>The AbstractRange abstract interface is the base class upon which all DOM range types are defined. A range is an object that indicates the start and end points of a section of content within the document.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AbstractRange]
  '''<Summary>A Boolean value which is true if the range is collapsed. A collapsed range is one whose start position and end position are the same, resulting in a zero-character-long range.</Summary>
  ReadOnly Property [collapsed] As Boolean
  '''<Summary>The DOM Node in which the end of the range, as specified by the endOffset property, is located.</Summary>
  ReadOnly Property [endContainer] As Node
  '''<Summary>An integer value indicating the offset, in characters, from the beginning of the node's contents to the beginning of the range represented by the range object. This value must be less than the length of the endContainer node.</Summary>
  ReadOnly Property [endOffset] As Integer
  '''<Summary>The DOM Node in which the beginning of the range, as specified by the startOffset property, is located.</Summary>
  ReadOnly Property [startContainer] As Node
  '''<Summary>An integer value indicating the offset, in characters, from the beginning of the node's contents to the last character of the contents referred to  by the range object. This value must be less than the length of the node indicated in startContainer.</Summary>
  ReadOnly Property [startOffset] As Integer
End Interface