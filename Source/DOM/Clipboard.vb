'''<summary>The Clipboard interface implements the Clipboard API, providing—if the user grants permission—both read and write access to the contents of the system clipboard.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Clipboard]
  '''<summary>Requests arbitrary data (such as images) from the clipboard, returning a Promise. When the data has been retrieved, the promise is resolved with a DataTransfer object that provides the data.</summary>
  Function [read]() As DataTransfer
  '''<summary>Requests text from the system clipboard; returns a Promise which is resolved with a DOMString containing the clipboard's text once it's available.</summary>
  Function [readText]() As String
  '''<summary>Writes arbitrary data to the system clipboard. This asynchronous operation signals that it's finished by resolving the returned Promise.</summary>
  Function [write]([pardata] As Dynamic) As Dynamic
  '''<summary>Writes text to the system clipboard, returning a Promise which is resolved once the text is fully copied into the clipboard.</summary>
  Function [writeText]([parnewClipText] As Dynamic) As String
End Interface