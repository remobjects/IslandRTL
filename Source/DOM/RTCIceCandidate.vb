'''<summary>The RTCIceCandidate interface—part of the WebRTC API—represents a candidate Internet Connectivity Establishment (ICE) configuration which may be used to establish an RTCPeerConnection.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidate]
  '''<summary>A DOMString representing the transport address for the candidate that can be used for connectivity checks. The format of this address is a candidate-attribute as defined in RFC 5245. This string is empty ("") if the RTCIceCandidate is an "end of candidates" indicator.</summary>
  ReadOnly Property [candidate] As String
  '''<summary>A DOMString which indicates whether the candidate is an RTP or an RTCP candidate; its value is either "rtp" or "rtcp", and is derived from the  "component-id" field in the candidate a-line string. The permitted values are listed in the RTCIceComponent enumerated type.</summary>
  ReadOnly Property [component] As String
  '''<summary>Returns a DOMString containing a unique identifier that is the same for any candidates of the same type, share the same base (the address from which the ICE agent sent the candidate), and come from the same STUN server. This is used to help optimize ICE performance while prioritizing and correlating candidates that appear on multiple RTCIceTransport objects.</summary>
  ReadOnly Property [foundation] As String
  '''<summary>A DOMString containing the IP address of the candidate.</summary>
  ReadOnly Property [ip] As String
  '''<summary>An integer value indicating the candidate's port number.</summary>
  ReadOnly Property [port] As Integer
  '''<summary>A long integer value indicating the candidate's priority.</summary>
  ReadOnly Property [priority] As Long
  '''<summary>A string indicating whether the candidate's protocol is "tcp" or "udp". The string is one of those in the enumerated type RTCIceProtocol.</summary>
  ReadOnly Property [protocol] As String
  '''<summary>If the candidate is derived from another candidate, relatedAddress is a DOMString containing that host candidate's IP address. For host candidates, this value is null.</summary>
  ReadOnly Property [relatedAddress] As String
  '''<summary>For a candidate that is derived from another, such as a relay or reflexive candidate, the relatedPort is a number indicating the port number of the candidate from which this candidate is derived. For host candidates, the relatedPort property is null.</summary>
  ReadOnly Property [relatedPort] As Double
  '''<summary>A DOMString specifying the candidate's media stream identification tag which uniquely identifies the media stream within the component with which the candidate is associated, or null if no such association exists.</summary>
  ReadOnly Property [sdpMid] As Integer
  '''<summary>If not null, sdpMLineIndex indicates the zero-based index number of the media description (as defined in RFC 4566) in the SDP with which the candidate is associated.</summary>
  ReadOnly Property [sdpMLineIndex] As Integer
  '''<summary>If protocol is "tcp", tcpType represents the type of TCP candidate. Otherwise, tcpType is null.</summary>
  ReadOnly Property [tcpType] As Dynamic
  '''<summary>A DOMString indicating the type of candidate as one of the strings from the RTCIceCandidateType enumerated type.</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>A DOMString containing a randomly-generated username fragment ("ice-ufrag") which ICE uses for message integrity along with a randomly-generated password ("ice-pwd"). You can use this string to verify generations of ICE generation; each generation of the same ICE process will use the same usernameFragment, even across ICE restarts.</summary>
  ReadOnly Property [usernameFragment] As String
  '''<summary>Given the RTCIceCandidate's current configuration, toJSON() returns a DOMString containing a JSON representation of that configuration in the form of a RTCIceCandidateInit object.</summary>
  Function [toJSON]() As String
End Interface