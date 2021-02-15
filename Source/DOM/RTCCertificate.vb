'''<summary>The interface of the the WebRTC API provides an object represents a certificate that an RTCPeerConnection uses to authenticate.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCCertificate]
  '''<summary>Returns the expiration date of the certificate.</summary>
  ReadOnly Property [expires] As DateTime
End Interface