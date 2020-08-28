'''<Summary>The interface of the the WebRTC API provides an object represents a certificate that an RTCPeerConnection uses to authenticate.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCCertificate]
  '''<Summary>Returns the expiration date of the certificate.</Summary>
  ReadOnly Property [expires] As DateTime
End Interface