'''<Summary>The FileReader object lets web applications asynchronously read the contents of files (or raw data buffers) stored on the user's computer, using File or Blob objects to specify the file or data to read.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FileReader]
  '''<Summary>A DOMException representing the error that occurred while reading the file.</Summary>
  ReadOnly Property [error] As DOMException
  '''<Summary>A number indicating the state of the FileReader. This is one of the following:</Summary>
  ReadOnly Property [readyState] As Double
  '''<Summary>The file's contents. This property is only valid after the read operation is complete, and the format of the data depends on which of the methods was used to initiate the read operation.</Summary>
  ReadOnly Property [result] As Byte()
  '''<Summary>A handler for the abort event. This event is triggered each time the reading operation is aborted.</Summary>
  Property [onabort] As EventListener
  '''<Summary>A handler for the error event. This event is triggered each time the reading operation encounter an error.</Summary>
  Property [onerror] As EventListener
  '''<Summary>A handler for the load event. This event is triggered each time the reading operation is successfully completed.</Summary>
  Property [onload] As EventListener
  '''<Summary>A handler for the loadstart event. This event is triggered each time the reading is starting.</Summary>
  Property [onloadstart] As EventListener
  '''<Summary>A handler for the loadend event. This event is triggered each time the reading operation is completed (either in success or failure).</Summary>
  Property [onloadend] As EventListener
  '''<Summary>A handler for the progress event. This event is triggered while reading a Blob content.</Summary>
  Property [onprogress] As EventListener
  '''<Summary>Starts reading the contents of the specified Blob, once finished, the result attribute contains an ArrayBuffer representing the file's data.</Summary>
  Function [readAsArrayBuffer]([parblob] As Dynamic) As Byte()
  '''<Summary>Starts reading the contents of the specified Blob, once finished, the result attribute contains the raw binary data from the file as a string.</Summary>
  Function [readAsBinaryString]([parblob] As Dynamic) As String
  '''<Summary>Starts reading the contents of the specified Blob, once finished, the result attribute contains a data: URL representing the file's data.</Summary>
  Function [readAsDataURL]([parblob] As Dynamic) As String
End Interface