'''<summary>The DOM StaticRange interface extends AbstractRange to provide a method to specify a range of content in the DOM whose contents don't update to reflect changes which occur within the DOM tree.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [StaticRange]
  '''<summary>Returns a Boolean value which is true if the range's start and end positions are the same, resulting in a range of length 0.</summary>
  ReadOnly Property [collapsed] As Boolean
  '''<summary>Returns the DOM Node which contains the ending point of the range. The offset into the node at which the end position is located is indicated by endOffset.</summary>
  ReadOnly Property [endContainer] As Node
  '''<summary>Returns an integer value indicating the offset into the node given by endContainer at which the last character of the range is found.</summary>
  ReadOnly Property [endOffset] As Integer
  '''<summary>Returns the DOM Node which contains the starting point of the range (which is in turn identified by startOffset.</summary>
  ReadOnly Property [startContainer] As Node
  '''<summary>Returns an integer value indicating the offset into the node specified by startContainer at which the first character of the range is located.</summary>
  ReadOnly Property [startOffset] As Integer
End Interface