'''<Summary>The MessageEvent interface represents a message received by a target object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MessageEvent]
'Defined on this type 
  '''<Summary>The data sent by the message emitter.</Summary>
  ReadOnly Property [data] As Dynamic
  '''<Summary>A USVString representing the origin of the message emitter.</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>A DOMString representing a unique ID for the event.</Summary>
  ReadOnly Property [lastEventId] As Integer
  '''<Summary>A MessageEventSource (which can be a WindowProxy, MessagePort, or ServiceWorker object) representing the message emitter.</Summary>
  ReadOnly Property [source] As Window
  '''<Summary>An array of MessagePort objects representing the ports associated with the channel the message is being sent through (where appropriate, e.g. in channel messaging or when sending a message to a shared worker).</Summary>
  ReadOnly Property [ports] As MessagePort()
End Interface