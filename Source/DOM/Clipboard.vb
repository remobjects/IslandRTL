'''<Summary>The Clipboard interface implements the Clipboard API, providing—if the user grants permission—both read and write access to the contents of the system clipboard.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Clipboard]
'Defined on this type 
  '''<Summary>Requests arbitrary data (such as images) from the clipboard, returning a Promise. When the data has been retrieved, the promise is resolved with a DataTransfer object that provides the data.</Summary>
  Function [read]() As DataTransfer
  '''<Summary>Requests text from the system clipboard; returns a Promise which is resolved with a DOMString containing the clipboard's text once it's available.</Summary>
  Function [readText]() As String
  '''<Summary>Writes arbitrary data to the system clipboard. This asynchronous operation signals that it's finished by resolving the returned Promise.</Summary>
  Function [write]([pardata] As Dynamic) As Dynamic
  '''<Summary>Writes text to the system clipboard, returning a Promise which is resolved once the text is fully copied into the clipboard.</Summary>
  Function [writeText]([parnewClipText] As Dynamic) As String
End Interface