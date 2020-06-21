'''<Summary>The DataTransferItem object represents one drag data item. During a drag operation, each drag event has a dataTransfer property which contains a list of drag data items. Each item in the list is a DataTransferItem object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransferItem]
'Defined on this type 
  '''<Summary>The kind of drag data item, string or file.</Summary>
  ReadOnly Property [kind] As String
  '''<Summary>The drag data item's type, typically a MIME type.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>Returns the File object associated with the drag data item (or null if the drag item is not a file).</Summary>
  Function [getAsFile]() As Dynamic
  '''<Summary>Invokes the specified callback with the drag data item string as its argument.</Summary>
  Function [getAsString]([parcallback] As Dynamic) As String
End Interface