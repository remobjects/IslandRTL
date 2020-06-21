'''<Summary>The WebSocket object provides the API for creating and managing a WebSocket connection to a server, as well as for sending and receiving data on the connection.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebSocket]
'Defined on this type 
  '''<Summary>The binary data type used by the connection.</Summary>
  Property [binaryType] As Dynamic
  '''<Summary>The number of bytes of queued data.</Summary>
  ReadOnly Property [bufferedAmount] As Double
  '''<Summary>The extensions selected by the server.</Summary>
  ReadOnly Property [extensions] As String
  '''<Summary>An event listener to be called when the connection is closed.</Summary>
  Property [onclose] As Dynamic
  '''<Summary>An event listener to be called when an error occurs.</Summary>
  Property [onerror] As Dynamic
  '''<Summary>An event listener to be called when a message is received from the server.</Summary>
  Property [onmessage] As Dynamic
  '''<Summary>An event listener to be called when the connection is opened.</Summary>
  Property [onopen] As Dynamic
  '''<Summary>The sub-protocol selected by the server.</Summary>
  ReadOnly Property [protocol] As String
  '''<Summary>The current state of the connection.</Summary>
  ReadOnly Property [readyState] As Double
  '''<Summary>The absolute URL of the WebSocket.</Summary>
  ReadOnly Property [url] As String
  '''<Summary>Returns a newly created WebSocket object.</Summary>
  Function [WebSocket]() As WebSocket
End Interface