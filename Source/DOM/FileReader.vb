'''<summary>The FileReader object lets web applications asynchronously read the contents of files (or raw data buffers) stored on the user's computer, using File or Blob objects to specify the file or data to read.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FileReader]
  '''<summary>A DOMException representing the error that occurred while reading the file.</summary>
  ReadOnly Property [error] As DOMException
  '''<summary>A number indicating the state of the FileReader. This is one of the following:</summary>
  ReadOnly Property [readyState] As Double
  '''<summary>The file's contents. This property is only valid after the read operation is complete, and the format of the data depends on which of the methods was used to initiate the read operation.</summary>
  ReadOnly Property [result] As Byte()
  '''<summary>A handler for the abort event. This event is triggered each time the reading operation is aborted.</summary>
  Property [onabort] As EventListener
  '''<summary>A handler for the error event. This event is triggered each time the reading operation encounter an error.</summary>
  Property [onerror] As EventListener
  '''<summary>A handler for the load event. This event is triggered each time the reading operation is successfully completed.</summary>
  Property [onload] As EventListener
  '''<summary>A handler for the loadstart event. This event is triggered each time the reading is starting.</summary>
  Property [onloadstart] As EventListener
  '''<summary>A handler for the loadend event. This event is triggered each time the reading operation is completed (either in success or failure).</summary>
  Property [onloadend] As EventListener
  '''<summary>A handler for the progress event. This event is triggered while reading a Blob content.</summary>
  Property [onprogress] As EventListener
  '''<summary>Starts reading the contents of the specified Blob, once finished, the result attribute contains an ArrayBuffer representing the file's data.</summary>
  Function [readAsArrayBuffer]([parblob] As Dynamic) As Byte()
  '''<summary>Starts reading the contents of the specified Blob, once finished, the result attribute contains the raw binary data from the file as a string.</summary>
  Function [readAsBinaryString]([parblob] As Dynamic) As String
  '''<summary>Starts reading the contents of the specified Blob, once finished, the result attribute contains a data: URL representing the file's data.</summary>
  Function [readAsDataURL]([parblob] As Dynamic) As String
End Interface