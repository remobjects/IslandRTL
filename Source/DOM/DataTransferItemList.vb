'''<summary>The DataTransferItemList object is a list of DataTransferItem objects representing items being dragged. During a drag operation, each DragEvent has a dataTransfer property and that property is a DataTransferItemList.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransferItemList]
  '''<summary>An unsigned long that is the number of drag items in the list.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Adds an item (either a File object or a string) to the drag item list and returns a DataTransferItem object for the new item.</summary>
  Function [add]([pardata] As Dynamic, [partype] As Dynamic) As DataTransfer
  '''<summary>Getter that returns a DataTransferItem at the given index.</summary>
  Function [DataTransferItem]([parindex] As Dynamic) As DataTransfer
End Interface