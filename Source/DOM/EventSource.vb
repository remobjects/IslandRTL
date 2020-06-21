'''<Summary>The EventSource interface is web content's interface to server-sent events. An EventSource instance opens a persistent connection to an HTTP server, which sends events in text/event-stream format.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventSource]
'Defined on this type 
  '''<Summary>A number representing the state of the connection. Possible values are CONNECTING (0), OPEN (1), or CLOSED (2).</Summary>
  ReadOnly Property [readyState] As Double
  '''<Summary>A DOMString representing the URL of the source.</Summary>
  ReadOnly Property [url] As String
  '''<Summary>A Boolean indicating whether the EventSource object was instantiated with cross-origin (CORS) credentials set (true), or not (false, the default).</Summary>
  ReadOnly Property [withCredentials] As Boolean
  '''<Summary>Is an EventHandler called when an error occurs and the error event is dispatched on an EventSource object.</Summary>
  Property [onerror] As EventListener
  '''<Summary>Is an EventHandler called when a message event is received, that is when a message is coming from the source.</Summary>
  Property [onmessage] As EventListener
  '''<Summary>Is an EventHandler called when an open event is received, that is when the connection was just opened.</Summary>
  Property [onopen] As EventListener
  '''<Summary>Creates a new EventSource to handle receiving server-sent events from a specified URL, optionally in credentials mode.</Summary>
  Function [EventSource]() As EventSource
End Interface