'''<summary>The MessageEvent interface represents a message received by a target object.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MessageEvent]
Inherits [Event]

  '''<summary>The data sent by the message emitter.</summary>
  ReadOnly Property [data] As Dynamic
  '''<summary>A USVString representing the origin of the message emitter.</summary>
  ReadOnly Property [origin] As String
  '''<summary>A DOMString representing a unique ID for the event.</summary>
  ReadOnly Property [lastEventId] As Integer
  '''<summary>A MessageEventSource (which can be a WindowProxy, MessagePort, or ServiceWorker object) representing the message emitter.</summary>
  ReadOnly Property [source] As Window
  '''<summary>An array of MessagePort objects representing the ports associated with the channel the message is being sent through (where appropriate, e.g. in channel messaging or when sending a message to a shared worker).</summary>
  ReadOnly Property [ports] As MessagePort()
End Interface