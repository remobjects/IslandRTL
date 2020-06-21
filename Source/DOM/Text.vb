'''<Summary>The Text interface represents the textual content of Element or Attr. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Text]
'Defined on this type 
  '''<Summary>Returns a DOMString containing the text of all Text nodes logically adjacent to this Node, concatenated in document order.</Summary>
  ReadOnly Property [wholeText] As String
  '''<Summary>Returns the HTMLSlotElement object associated with the element.</Summary>
  ReadOnly Property [assignedSlot] As HTMLElement
  '''<Summary>Breaks the node into two nodes at a specified offset.</Summary>
  Property [splitText] As String
End Interface