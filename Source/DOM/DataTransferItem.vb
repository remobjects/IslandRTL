'''<summary>The DataTransferItem object represents one drag data item. During a drag operation, each drag event has a dataTransfer property which contains a list of drag data items. Each item in the list is a DataTransferItem object.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DataTransferItem]
  '''<summary>The kind of drag data item, string or file.</summary>
  ReadOnly Property [kind] As String
  '''<summary>The drag data item's type, typically a MIME type.</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>Returns the File object associated with the drag data item (or null if the drag item is not a file).</summary>
  Function [getAsFile]() As Dynamic
  '''<summary>Invokes the specified callback with the drag data item string as its argument.</summary>
  Function [getAsString]([parcallback] As Dynamic) As String
End Interface