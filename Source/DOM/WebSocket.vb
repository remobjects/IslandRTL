'''<summary>The WebSocket object provides the API for creating and managing a WebSocket connection to a server, as well as for sending and receiving data on the connection.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebSocket]
  Inherits [EventTarget]
  '''<summary>The binary data type used by the connection.</summary>
  Property [binaryType] As String
  '''<summary>The number of bytes of queued data.</summary>
  ReadOnly Property [bufferedAmount] As Double
  '''<summary>The extensions selected by the server.</summary>
  ReadOnly Property [extensions] As String
  '''<summary>An event listener to be called when the connection is closed.</summary>
  Property [onclose] As WebAssemblyDelegate
  '''<summary>An event listener to be called when an error occurs.</summary>
  Property [onerror] As WebAssemblyDelegate
  '''<summary>An event listener to be called when a message is received from the server.</summary>
  Property [onmessage] As WebAssemblyDelegate
  '''<summary>An event listener to be called when the connection is opened.</summary>
  Property [onopen] As WebAssemblyDelegate
  '''<summary>The sub-protocol selected by the server.</summary>
  ReadOnly Property [protocol] As String
  '''<summary>The current state of the connection.</summary>
  ReadOnly Property [readyState] As Byte
  '''<summary>The absolute URL of the WebSocket.</summary>
  ReadOnly Property [url] As String

  '''<summary>The WebSocket.close() method closes the WebSocket connection or connection attempt, if any. If the connection is already CLOSED, this method does nothing.</summary>
  Sub close(Optional code As Integer, Optional reason As Dynamic)
  '''<summary>The WebSocket.send() method enqueues the specified data to be transmitted to the server over the WebSocket connection, increasing the value of bufferedAmount by the number of bytes needed to contain the data. If the data can't be sent (for example, because it needs to be buffered but the buffer is full), the socket is closed automatically.</summary>
  Sub send(Optional data As Dynamic)

End Interface