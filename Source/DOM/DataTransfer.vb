'''<summary>The DataTransfer object is used to hold the data that is being dragged during a drag and drop operation. It may hold one or more data items, each of one or more data types. For more information about drag and drop, see HTML Drag and Drop API.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransfer]
  '''<summary>Gets the type of drag-and-drop operation currently selected or sets the operation to a new type. The value must be none, copy, link or move.</summary>
  Property [dropEffect] As String
  '''<summary>Provides all of the types of operations that are possible. Must be one of none, copy, copyLink, copyMove, link, linkMove, move, all or uninitialized.</summary>
  Property [effectAllowed] As String
  '''<summary>Contains a list of all the local files available on the data transfer. If the drag operation doesn't involve dragging files, this property is an empty list.</summary>
  Property [files] As String()
  '''<summary>Gives a DataTransferItemList object which is a list of all of the drag data.</summary>
  ReadOnly Property [items] As String()
  '''<summary>The Node over which the mouse cursor was located when the button was pressed to initiate the drag operation. This value is null for external drags or if the caller can't access the node.</summary>
  ReadOnly Property [mozSourceNode] As Node
  '''<summary>Retrieves the data for a given type, or an empty string if data for that type does not exist or the data transfer contains no data.</summary>
  Function [getData]([parformat] As Dynamic) As String
  '''<summary>Set the data for a given type. If data for the type does not exist, it is added at the end, such that the last item in the types list will be the new format. If data for the type already exists, the existing data is replaced in the same position.</summary>
  Sub [setData]([parformat] As Dynamic, [pardata] As Dynamic)
End Interface