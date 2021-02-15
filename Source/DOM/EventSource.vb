'''<summary>The EventSource interface is web content's interface to server-sent events. An EventSource instance opens a persistent connection to an HTTP server, which sends events in text/event-stream format.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventSource]
Inherits EventTarget

  '''<summary>A number representing the state of the connection. Possible values are CONNECTING (0), OPEN (1), or CLOSED (2).</summary>
  ReadOnly Property [readyState] As Double
  '''<summary>A DOMString representing the URL of the source.</summary>
  ReadOnly Property [url] As String
  '''<summary>A Boolean indicating whether the EventSource object was instantiated with cross-origin (CORS) credentials set (true), or not (false, the default).</summary>
  ReadOnly Property [withCredentials] As Boolean
  '''<summary>Is an EventHandler called when an error occurs and the error event is dispatched on an EventSource object.</summary>
  Property [onerror] As EventListener
  '''<summary>Is an EventHandler called when a message event is received, that is when a message is coming from the source.</summary>
  Property [onmessage] As EventListener
  '''<summary>Is an EventHandler called when an open event is received, that is when the connection was just opened.</summary>
  Property [onopen] As EventListener
  '''<summary>Closes the connection, if any, and sets the readyState attribute to CLOSED. If the connection is already closed, the method does nothing.</summary>
  Sub [close]()
End Interface