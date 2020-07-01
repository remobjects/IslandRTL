'''<Summary>The RTCIceTransport interface provides access to information about the ICE transport layer over which the data is being sent and received.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceTransport]
Inherits EventTarget

  '''<Summary>The ICE component being used by the transport. The value is one of the strings from the RTCIceTransport enumerated type: "RTP" or "RTSP".</Summary>
  ReadOnly Property [component] As String
  '''<Summary>A DOMString indicating which gathering state the ICE agent is currently in. The value is one of those included in the RTCIceGathererState enumerated type: "new", "gathering", or "complete".</Summary>
  ReadOnly Property [gatheringState] As String
  '''<Summary>Returns a DOMString whose value is one of the members of the RTCIceRole enumerated type: "controlling" or "controlled"; this indicates whether the ICE agent is the one that makes the final decision as to the candidate pair to use or not.</Summary>
  ReadOnly Property [role] As String
  '''<Summary>A DOMString indicating what the current state of the ICE agent is. The value of state can be used to determine whether the ICE agent has made an initial connection using a viable candidate pair ("connected"), made its final selection of candidate pairs ("completed"), or in an error state ("failed"), among other states. See the RTCIceTransportState enumerated type for a complete list of states.</Summary>
  ReadOnly Property [state] As String
End Interface