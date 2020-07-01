'''<Summary>The RTCIceCandidatePair dictionary describes a pair of ICE candidates which together comprise a description of a viable connection between two WebRTC endpoints.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidatePair]
  '''<Summary>An RTCIceCandidate describing the configuration of the local end of the connection.</Summary>
  Property [local] As RTCIceCandidate
  '''<Summary>The RTCIceCandidate describing the configuration of the remote end of the connection.</Summary>
  Property [remote] As RTCIceCandidate
End Interface