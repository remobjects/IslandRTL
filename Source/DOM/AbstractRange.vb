'''<summary>The AbstractRange abstract interface is the base class upon which all DOM range types are defined. A range is an object that indicates the start and end points of a section of content within the document.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AbstractRange]
  '''<summary>A Boolean value which is true if the range is collapsed. A collapsed range is one whose start position and end position are the same, resulting in a zero-character-long range.</summary>
  ReadOnly Property [collapsed] As Boolean
  '''<summary>The DOM Node in which the end of the range, as specified by the endOffset property, is located.</summary>
  ReadOnly Property [endContainer] As Node
  '''<summary>An integer value indicating the offset, in characters, from the beginning of the node's contents to the beginning of the range represented by the range object. This value must be less than the length of the endContainer node.</summary>
  ReadOnly Property [endOffset] As Integer
  '''<summary>The DOM Node in which the beginning of the range, as specified by the startOffset property, is located.</summary>
  ReadOnly Property [startContainer] As Node
  '''<summary>An integer value indicating the offset, in characters, from the beginning of the node's contents to the last character of the contents referred to  by the range object. This value must be less than the length of the node indicated in startContainer.</summary>
  ReadOnly Property [startOffset] As Integer
End Interface