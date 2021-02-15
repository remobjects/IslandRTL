'''<summary>The RTCIceCandidatePair dictionary describes a pair of ICE candidates which together comprise a description of a viable connection between two WebRTC endpoints.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidatePair]
  '''<summary>An RTCIceCandidate describing the configuration of the local end of the connection.</summary>
  Property [local] As RTCIceCandidate
  '''<summary>The RTCIceCandidate describing the configuration of the remote end of the connection.</summary>
  Property [remote] As RTCIceCandidate
End Interface