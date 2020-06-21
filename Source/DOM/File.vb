'''<Summary>The File interface provides information about files and allows JavaScript in a web page to access their content.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [File]
'Defined on this type 
  '''<Summary>Returns the last modified time of the file, in millisecond since the UNIX epoch (January 1st, 1970 at Midnight).</Summary>
  ReadOnly Property [lastModified] As Date
  '''<Summary>Returns the name of the file referenced by the File object.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>Returns the size of the file in bytes.</Summary>
  ReadOnly Property [size] As Dynamic
  '''<Summary>Returns the MIME type of the file.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>Returns a newly constructed File.</Summary>
  Function [File]() As File
  '''<Summary>Returns a new Blob object containing the data in the specified range of bytes of the source Blob.</Summary>
  Function [slice]([parstart] As Dynamic, [parend] As Dynamic, [parcontentType] As Dynamic) As Dynamic
  '''<Summary>Transforms the File into a ReadableStream that can be used to read the File contents.</Summary>
  Function [stream]() As Dynamic
  '''<Summary>Transforms the File into a stream and reads it to completion. It returns a promise that resolves with a USVString (text).</Summary>
  Function [text]() As Dynamic
  '''<Summary>Transforms the File into a stream and reads it to completion. It returns a promise that resolves with an ArrayBuffer.</Summary>
  Function [arrayBuffer]() As Dynamic
End Interface