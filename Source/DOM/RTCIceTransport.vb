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
  '''<Summary>Returns an array of RTCIceCandidate objects, each describing one of the ICE candidates that have been gathered so far for the local device. These are the same candidates which have already been sent to the remote peer by sending an icecandidate event to the RTCPeerConnection for transmission.</Summary>
  Function [getLocalCandidates]() As RTCIceCandidate()
  '''<Summary>Returns a RTCIceParameters object describing the ICE parameters established by a call to the RTCPeerConnection.setLocalDescription() method. Returns null if parameters have not yet been received.</Summary>
  Function [getLocalParameters]() As RTCIceParameters
  '''<Summary>Returns an array of RTCIceCandidate objects, one for each of the remote device's ICE candidates that have been received by the local end of the RTCPeerConnection and delivered to ICE by calling addIceCandidate().</Summary>
  Function [getRemoteCandidates]() As RTCIceCandidate
  '''<Summary>Returns a RTCIceParameters object containing the ICE parameters for the remote device, as set by a call to RTCPeerConnection.setRemoteDescription(). If setRemoteDescription() hasn't been called yet, the return value is null.</Summary>
  Function [getRemoteParameters]() As RTCIceParameters
  '''<Summary>Returns a RTCIceCandidatePair object that identifies the two candidates—one for each end of the connection—that have been selected so far. It's possible that a better pair will be found and selected later; if you need to keep up with this, watch for the selectedcandidatepairchange event. If no candidate pair has been selected yet, the return value is null.</Summary>
  Function [getSelectedCandidatePair]() As RTCIceCandidatePair
End Interface