'''<summary>The WebRTC API's RTCIceCandidateStats dictionary provides statistics related to an RTCIceCandidate.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidateStats]
  '''<summary>A string containing the address of the candidate. This value may be an IPv4 address, an IPv6 address, or a fully-qualified domain name. This property was previously named ip and only accepted IP addresses.</summary>
  Property [address] As String
  '''<summary>A string matching one of the values in the RTCIceCandidateType enumerated type, indicating what kind of candidate the object provides statistics for.</summary>
  Property [candidateType] As Dynamic
  '''<summary>A Boolean value indicating whether or not the candidate has been released or deleted; the default value is false. For local candidates, it's value is true if the candidate has been deleted or released. For host candidates, true means that any network resources (usually a network socket) associated with the candidate have already been released. For TURN candidates, the TURN allocation is no longer active for deleted candidates. This property is not present for remote candidates.</summary>
  Property [deleted] As Boolean
  '''<summary>A string from the RTCNetworkType enumerated type which indicates the type of interface used for a local candidate. This property is only present for local candidates.</summary>
  Property [networkType] As Dynamic
  '''<summary>The network port number used by the candidate.</summary>
  Property [port] As Integer
  '''<summary>The candidate's priority, corresponding to RTCIceCandidate.priority.</summary>
  Property [priority] As Integer
  '''<summary>A string specifying the protocol (tcp or udp) used to transmit data on the port.</summary>
  Property [protocol] As String
  '''<summary>A string identifying the protocol used by the endpoint for communicating with the TURN server; valid values are tcp, udp, and tls. Only present for local candidates.</summary>
  Property [relayProtocol] As String
  '''<summary>A string uniquely identifiying the transport object that was inspected in order to obtain the RTCTransportStats associated with the candidate correspondin to these statistics.</summary>
  Property [transportId] As Integer
  '''<summary>For local candidates, the url property is the URL of the ICE server from which the candidate was received. This URL matches the one included in the RTCPeerConnectionIceEvent object representing the icecandidate event that delivered the candidate to the local peer.</summary>
  Property [url] As String
End Interface