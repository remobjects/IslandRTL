'''<summary>The RTCIceParameters dictionary specifies the username fragment and password assigned to an ICE session.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceParameters]
  '''<summary>A DOMString specifying the value of the ICE session's username fragment field, ufrag.</summary>
  Property [usernameFragment] As String
  '''<summary>A DOMString specifying the session's password string.</summary>
  Property [password] As String
End Interface