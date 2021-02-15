'''<summary>The File interface provides information about files and allows JavaScript in a web page to access their content.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [File]
  '''<summary>Returns the last modified time of the file, in millisecond since the UNIX epoch (January 1st, 1970 at Midnight).</summary>
  ReadOnly Property [lastModified] As DateTime
  '''<summary>Returns the name of the file referenced by the File object.</summary>
  ReadOnly Property [name] As String
  '''<summary>Returns the size of the file in bytes.</summary>
  ReadOnly Property [size] As Double
  '''<summary>Returns the MIME type of the file.</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>Returns a new Blob object containing the data in the specified range of bytes of the source Blob.</summary>
  Function [slice]([parstart] As Dynamic, [parend] As Dynamic, [parcontentType] As Dynamic) As Dynamic
  '''<summary>Transforms the File into a ReadableStream that can be used to read the File contents.</summary>
  Function [stream]() As Dynamic
  '''<summary>Transforms the File into a stream and reads it to completion. It returns a promise that resolves with a USVString (text).</summary>
  Function [text]() As Dynamic
  '''<summary>Transforms the File into a stream and reads it to completion. It returns a promise that resolves with an ArrayBuffer.</summary>
  Function [arrayBuffer]() As Dynamic
End Interface