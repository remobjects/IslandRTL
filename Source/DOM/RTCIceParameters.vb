'''<Summary>The RTCIceParameters dictionary specifies the username fragment and password assigned to an ICE session.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceParameters]
  '''<Summary>A DOMString specifying the value of the ICE session's username fragment field, ufrag.</Summary>
  Property [usernameFragment] As String
  '''<Summary>A DOMString specifying the session's password string.</Summary>
  Property [password] As String
End Interface