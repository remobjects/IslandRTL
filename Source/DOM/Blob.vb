'''<Summary>The Blob object represents a blob, which is a file-like object of immutable, raw data; they can be read as text or binary data, or converted into a ReadableStream so its methods can be used for processing the data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Blob]
  '''<Summary>The size, in bytes, of the data contained in the Blob object.</Summary>
  ReadOnly Property [size] As Dynamic
  '''<Summary>A string indicating the MIME type of the data contained in the Blob. If the type is unknown, this string is empty.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>Returns a promise that resolves with an ArrayBuffer containing the entire contents of the Blob as binary data.</Summary>
  Function [arrayBuffer]() As Byte()
  '''<Summary>Returns a new Blob object containing the data in the specified range of bytes of the blob on which it's called.</Summary>
  Function [slice]([parstart] As Dynamic, [parend] As Dynamic, [parcontentType] As Dynamic) As Dynamic
  '''<Summary>Returns a ReadableStream that can be used to read the contents of the Blob.</Summary>
  Function [stream]() As Dynamic
  '''<Summary>Returns a promise that resolves with a USVString containing the entire contents of the Blob interpreted as UTF-8 text.</Summary>
  Function [text]() As String
End Interface