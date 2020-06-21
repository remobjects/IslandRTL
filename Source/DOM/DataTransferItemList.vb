'''<Summary>The DataTransferItemList object is a list of DataTransferItem objects representing items being dragged. During a drag operation, each DragEvent has a dataTransfer property and that property is a DataTransferItemList.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransferItemList]
'Defined on this type 
  '''<Summary>An unsigned long that is the number of drag items in the list.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Adds an item (either a File object or a string) to the drag item list and returns a DataTransferItem object for the new item.</Summary>
  Function [add]([partoken] As Dynamic) As DataTransfer
  '''<Summary>Removes the drag item from the list at the given index.</Summary>
  Sub [remove]([partoken] As Dynamic)
  '''<Summary>Getter that returns a DataTransferItem at the given index.</Summary>
  Function [DataTransferItem]() As DataTransfer
End Interface