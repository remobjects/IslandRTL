'''<summary>The MessagePort interface of the Channel Messaging API represents one of the two ports of a MessageChannel, allowing messages to be sent from one port and listening out for them arriving at the other.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MessagePort]
  '''<summary>An EventListener called when MessageEvent of type message is fired on the port—that is, when the port receives a message.</summary>
  Property [onmessage] As EventListener
  '''<summary>An EventListener called when a MessageEvent of type MessageError is fired—that is, when it receives a message that cannot be deserialized.</summary>
  Property [onmessageerror] As EventListener
  '''<summary>Fired when a MessagePort object receives a message. Also available via the onmessage property.</summary>
  Property [message] As EventListener
  '''<summary>Fired when a MessagePort object receives a message that can't be deserialized. Also available via the onmessageerror property.</summary>
  Property [messageerror] As EventListener
End Interface