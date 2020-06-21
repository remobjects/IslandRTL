'''<Summary>The WebRTC API's RTCIceCandidateStats dictionary provides statistics related to an RTCIceCandidate.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidateStats]
'Defined on this type 
  '''<Summary>A string containing the address of the candidate. This value may be an IPv4 address, an IPv6 address, or a fully-qualified domain name. This property was previously named ip and only accepted IP addresses.</Summary>
  Property [address] As String
  '''<Summary>A string matching one of the values in the RTCIceCandidateType enumerated type, indicating what kind of candidate the object provides statistics for.</Summary>
  Property [candidateType] As Dynamic
  '''<Summary>A Boolean value indicating whether or not the candidate has been released or deleted; the default value is false. For local candidates, it's value is true if the candidate has been deleted or released. For host candidates, true means that any network resources (usually a network socket) associated with the candidate have already been released. For TURN candidates, the TURN allocation is no longer active for deleted candidates. This property is not present for remote candidates.</Summary>
  Property [deleted] As Boolean
  '''<Summary>A string from the RTCNetworkType enumerated type which indicates the type of interface used for a local candidate. This property is only present for local candidates.</Summary>
  Property [networkType] As Dynamic
  '''<Summary>The candidate's priority, corresponding to RTCIceCandidate.priority.</Summary>
  Property [priority] As Integer
  '''<Summary>A string specifying the protocol (tcp or udp) used to transmit data on the port.</Summary>
  Property [protocol] As String
  '''<Summary>A string identifying the protocol used by the endpoint for communicating with the TURN server; valid values are tcp, udp, and tls. Only present for local candidates.</Summary>
  Property [relayProtocol] As String
  '''<Summary>A string uniquely identifiying the transport object that was inspected in order to obtain the RTCTransportStats associated with the candidate correspondin to these statistics.</Summary>
  Property [transportId] As Integer
  '''<Summary>For local candidates, the url property is the URL of the ICE server from which the candidate was received. This URL matches the one included in the RTCPeerConnectionIceEvent object representing the icecandidate event that delivered the candidate to the local peer.</Summary>
  Property [url] As String
End Interface