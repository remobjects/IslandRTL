'''<Summary>The MessagePort interface of the Channel Messaging API represents one of the two ports of a MessageChannel, allowing messages to be sent from one port and listening out for them arriving at the other.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MessagePort]
  '''<Summary>An EventListener called when MessageEvent of type message is fired on the port—that is, when the port receives a message.</Summary>
  Property [onmessage] As EventListener
  '''<Summary>An EventListener called when a MessageEvent of type MessageError is fired—that is, when it receives a message that cannot be deserialized.</Summary>
  Property [onmessageerror] As EventListener
  '''<Summary>Fired when a MessagePort object receives a message. Also available via the onmessage property.</Summary>
  Property [message] As EventListener
  '''<Summary>Fired when a MessagePort object receives a message that can't be deserialized. Also available via the onmessageerror property.</Summary>
  Property [messageerror] As EventListener
End Interface