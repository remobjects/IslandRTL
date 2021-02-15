'''<summary>The Text interface represents the textual content of Element or Attr. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Text]
Inherits CharacterData

  '''<summary>Returns a DOMString containing the text of all Text nodes logically adjacent to this Node, concatenated in document order.</summary>
  ReadOnly Property [wholeText] As String
  '''<summary>Returns the HTMLSlotElement object associated with the element.</summary>
  ReadOnly Property [assignedSlot] As HTMLElement
  '''<summary>Breaks the node into two nodes at a specified offset.</summary>
  Property [splitText] As String
End Interface