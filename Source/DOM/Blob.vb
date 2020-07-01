'''<Summary>The Blob object represents a blob, which is a file-like object of immutable, raw data; they can be read as text or binary data, or converted into a ReadableStream so its methods can be used for processing the data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Blob]
  '''<Summary>The size, in bytes, of the data contained in the Blob object.</Summary>
  ReadOnly Property [size] As Dynamic
  '''<Summary>A string indicating the MIME type of the data contained in the Blob. If the type is unknown, this string is empty.</Summary>
  ReadOnly Property [type] As Dynamic
End Interface