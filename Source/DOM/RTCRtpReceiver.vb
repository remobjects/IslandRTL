'''<Summary>The RTCRtpReceiver interface of the WebRTC API manages the reception and decoding of data for a MediaStreamTrack on an RTCPeerConnection.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpReceiver]
  '''<Summary>Returns the MediaStreamTrack associated with the current RTCRtpReceiver instance. </Summary>
  ReadOnly Property [track] As MediaStreamTrack
  '''<Summary>Returns the RTCDtlsTransport instance over which RTCP is sent and received.</Summary>
  ReadOnly Property [rtcpTransport] As Dynamic
  '''<Summary>Returns the RTCDtlsTransport instance over which the media for the receiver's track is received.</Summary>
  ReadOnly Property [transport] As Dynamic
End Interface