'''<Summary>The File interface provides information about files and allows JavaScript in a web page to access their content.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [File]
  '''<Summary>Returns the last modified time of the file, in millisecond since the UNIX epoch (January 1st, 1970 at Midnight).</Summary>
  ReadOnly Property [lastModified] As Date
  '''<Summary>Returns the name of the file referenced by the File object.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>Returns the size of the file in bytes.</Summary>
  ReadOnly Property [size] As Double
  '''<Summary>Returns the MIME type of the file.</Summary>
  ReadOnly Property [type] As Dynamic
End Interface