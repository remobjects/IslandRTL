'''<Summary>The DataTransferItem object represents one drag data item. During a drag operation, each drag event has a dataTransfer property which contains a list of drag data items. Each item in the list is a DataTransferItem object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransferItem]
  '''<Summary>The kind of drag data item, string or file.</Summary>
  ReadOnly Property [kind] As String
  '''<Summary>The drag data item's type, typically a MIME type.</Summary>
  ReadOnly Property [type] As Dynamic
End Interface