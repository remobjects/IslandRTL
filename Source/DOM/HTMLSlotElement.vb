'''<Summary>Fired on an HTMLSlotElement instance (&lt;slot> element) when the node(s) contained in that slot change.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLSlotElement]
  '''<Summary>DOMString: Can be used to get and set the slot's name.</Summary>
  Property [name] As String
  '''<Summary>Returns a sequence of the nodes assigned to this slot, and if the flatten option is set to true, the assigned nodes of any other slots that are descendants of this slot. If no assigned nodes are found, it returns the slot's fallback content.</Summary>
  Function [assignedNodes]([paroptions] As Dynamic) As Node
  '''<Summary>Returns a sequence of the elements assigned to this slot (and no other nodes). If the flatten option is set to true, it also returns the assigned elements of any other slots that are descendants of this slot. If no assigned nodes are found, it returns the slot's fallback content.</Summary>
  Function [assignedElements]([paroptions] As Dynamic) As HTMLElement
End Interface