'''<Summary>The RTCIceCandidate interface—part of the WebRTC API—represents a candidate Internet Connectivity Establishment (ICE) configuration which may be used to establish an RTCPeerConnection.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidate]
'Defined on this type 
  '''<Summary>A DOMString representing the transport address for the candidate that can be used for connectivity checks. The format of this address is a candidate-attribute as defined in RFC 5245. This string is empty ("") if the RTCIceCandidate is an "end of candidates" indicator.</Summary>
  ReadOnly Property [candidate] As String
  '''<Summary>A DOMString which indicates whether the candidate is an RTP or an RTCP candidate; its value is either "rtp" or "rtcp", and is derived from the  "component-id" field in the candidate a-line string. The permitted values are listed in the RTCIceComponent enumerated type.</Summary>
  ReadOnly Property [component] As String
  '''<Summary>Returns a DOMString containing a unique identifier that is the same for any candidates of the same type, share the same base (the address from which the ICE agent sent the candidate), and come from the same STUN server. This is used to help optimize ICE performance while prioritizing and correlating candidates that appear on multiple RTCIceTransport objects.</Summary>
  ReadOnly Property [foundation] As String
  '''<Summary>A DOMString containing the IP address of the candidate.</Summary>
  ReadOnly Property [ip] As String
  '''<Summary>An integer value indicating the candidate's port number.</Summary>
  ReadOnly Property [port] As Integer
  '''<Summary>A long integer value indicating the candidate's priority.</Summary>
  ReadOnly Property [priority] As Long
  '''<Summary>A string indicating whether the candidate's protocol is "tcp" or "udp". The string is one of those in the enumerated type RTCIceProtocol.</Summary>
  ReadOnly Property [protocol] As String
  '''<Summary>If the candidate is derived from another candidate, relatedAddress is a DOMString containing that host candidate's IP address. For host candidates, this value is null.</Summary>
  ReadOnly Property [relatedAddress] As String
  '''<Summary>For a candidate that is derived from another, such as a relay or reflexive candidate, the relatedPort is a number indicating the port number of the candidate from which this candidate is derived. For host candidates, the relatedPort property is null.</Summary>
  ReadOnly Property [relatedPort] As Double
  '''<Summary>A DOMString specifying the candidate's media stream identification tag which uniquely identifies the media stream within the component with which the candidate is associated, or null if no such association exists.</Summary>
  ReadOnly Property [sdpMid] As Integer
  '''<Summary>If not null, sdpMLineIndex indicates the zero-based index number of the media description (as defined in RFC 4566) in the SDP with which the candidate is associated.</Summary>
  ReadOnly Property [sdpMLineIndex] As Integer
  '''<Summary>If protocol is "tcp", tcpType represents the type of TCP candidate. Otherwise, tcpType is null.</Summary>
  ReadOnly Property [tcpType] As Dynamic
  '''<Summary>A DOMString indicating the type of candidate as one of the strings from the RTCIceCandidateType enumerated type.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>A DOMString containing a randomly-generated username fragment ("ice-ufrag") which ICE uses for message integrity along with a randomly-generated password ("ice-pwd"). You can use this string to verify generations of ICE generation; each generation of the same ICE process will use the same usernameFragment, even across ICE restarts.</Summary>
  ReadOnly Property [usernameFragment] As String
  '''<Summary>Given the RTCIceCandidate's current configuration, toJSON() returns a DOMString containing a JSON representation of that configuration in the form of a RTCIceCandidateInit object.</Summary>
  Function [toJSON]() As String
End Interface