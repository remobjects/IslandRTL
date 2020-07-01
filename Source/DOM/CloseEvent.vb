'''<Summary>A CloseEvent is sent to clients using WebSockets when the connection is closed. This is delivered to the listener indicated by the WebSocket object's onclose attribute.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CloseEvent]
Inherits [Event]

  '''<Summary>Returns an unsigned short containing the close code sent by the server. The following values are permitted status codes. The following definitions are sourced from the IANA website [Ref]. Note that the 1xxx codes are only WebSocket-internal and not for the same meaning by the transported data (like when the application-layer protocol is invalid). The only permitted codes to be specified in Firefox are 1000 and 3000 to 4999 [Source, Bug].</Summary>
  ReadOnly Property [code] As UShort
  '''<Summary>Returns a DOMString indicating the reason the server closed the connection. This is specific to the particular server and sub-protocol.</Summary>
  ReadOnly Property [reason] As String
  '''<Summary>Returns a Boolean that Indicates whether or not the connection was cleanly closed.</Summary>
  ReadOnly Property [wasClean] As Boolean
End Interface