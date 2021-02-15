'''<summary>The WebSocket object provides the API for creating and managing a WebSocket connection to a server, as well as for sending and receiving data on the connection.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebSocket]
  '''<summary>The binary data type used by the connection.</summary>
  Property [binaryType] As Dynamic
  '''<summary>The number of bytes of queued data.</summary>
  ReadOnly Property [bufferedAmount] As Double
  '''<summary>The extensions selected by the server.</summary>
  ReadOnly Property [extensions] As String
  '''<summary>An event listener to be called when the connection is closed.</summary>
  Property [onclose] As Dynamic
  '''<summary>An event listener to be called when an error occurs.</summary>
  Property [onerror] As Dynamic
  '''<summary>An event listener to be called when a message is received from the server.</summary>
  Property [onmessage] As Dynamic
  '''<summary>An event listener to be called when the connection is opened.</summary>
  Property [onopen] As Dynamic
  '''<summary>The sub-protocol selected by the server.</summary>
  ReadOnly Property [protocol] As String
  '''<summary>The current state of the connection.</summary>
  ReadOnly Property [readyState] As Dynamic
  '''<summary>The absolute URL of the WebSocket.</summary>
  ReadOnly Property [url] As String
End Interface