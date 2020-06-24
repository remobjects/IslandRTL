'''<Summary>The DataTransfer object is used to hold the data that is being dragged during a drag and drop operation. It may hold one or more data items, each of one or more data types. For more information about drag and drop, see HTML Drag and Drop API.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransfer]
'Defined on this type 
  '''<Summary>Gets the type of drag-and-drop operation currently selected or sets the operation to a new type. The value must be none, copy, link or move.</Summary>
  Property [dropEffect] As String
  '''<Summary>Provides all of the types of operations that are possible. Must be one of none, copy, copyLink, copyMove, link, linkMove, move, all or uninitialized.</Summary>
  Property [effectAllowed] As String
  '''<Summary>Contains a list of all the local files available on the data transfer. If the drag operation doesn't involve dragging files, this property is an empty list.</Summary>
  Property [files] As String()
  '''<Summary>Gives a DataTransferItemList object which is a list of all of the drag data.</Summary>
  ReadOnly Property [items] As String()
  '''<Summary>The Node over which the mouse cursor was located when the button was pressed to initiate the drag operation. This value is null for external drags or if the caller can't access the node.</Summary>
  ReadOnly Property [mozSourceNode] As Node
  '''<Summary>Retrieves the data for a given type, or an empty string if data for that type does not exist or the data transfer contains no data.</Summary>
  Function [getData]([parformat] As Dynamic) As String
  '''<Summary>Set the data for a given type. If data for the type does not exist, it is added at the end, such that the last item in the types list will be the new format. If data for the type already exists, the existing data is replaced in the same position.</Summary>
  Sub [setData]([parformat As Dynamic, data] As Dynamic)
End Interface