'''<Summary>The DataTransferItemList object is a list of DataTransferItem objects representing items being dragged. During a drag operation, each DragEvent has a dataTransfer property and that property is a DataTransferItemList.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransferItemList]
  '''<Summary>An unsigned long that is the number of drag items in the list.</Summary>
  ReadOnly Property [length] As Integer
End Interface