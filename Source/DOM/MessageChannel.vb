'''<Summary>The MessageChannel interface of the Channel Messaging API allows us to create a new message channel and send data through it via its two MessagePort properties.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MessageChannel]
'Defined on this type 
  '''<Summary>Returns port1 of the channel.</Summary>
  ReadOnly Property [port1] As MessagePort
  '''<Summary>Returns port2 of the channel.</Summary>
  ReadOnly Property [port2] As MessagePort
  '''<Summary></Summary>
  Property [MessageChannel] As MessageChannel
End Interface