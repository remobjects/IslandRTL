'''<summary>The MessageChannel interface of the Channel Messaging API allows us to create a new message channel and send data through it via its two MessagePort properties.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MessageChannel]
  '''<summary>Returns port1 of the channel.</summary>
  ReadOnly Property [port1] As MessagePort
  '''<summary>Returns port2 of the channel.</summary>
  ReadOnly Property [port2] As MessagePort
  '''<Summary></summary>
  Property [MessageChannel] As MessageChannel
End Interface