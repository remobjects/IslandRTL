'''<Summary>The RTCRtpReceiver interface of the WebRTC API manages the reception and decoding of data for a MediaStreamTrack on an RTCPeerConnection.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpReceiver]
  '''<Summary>Returns the MediaStreamTrack associated with the current RTCRtpReceiver instance. </Summary>
  ReadOnly Property [track] As MediaStreamTrack
  '''<Summary>Returns the RTCDtlsTransport instance over which RTCP is sent and received.</Summary>
  ReadOnly Property [rtcpTransport] As Dynamic
  '''<Summary>Returns the RTCDtlsTransport instance over which the media for the receiver's track is received.</Summary>
  ReadOnly Property [transport] As Dynamic
  '''<Summary>Returns an array of RTCRtpContributingSource instances for each unique CSRC (contributing source) identifier received by the current RTCRtpReceiver in the last ten seconds.</Summary>
  Function [getContributingSources]() As RTCRtpContributingSource
  '''<Summary>Returns an RTCRtpParameters object which contains information about how the RTC data is to be decoded.</Summary>
  Function [getParameters]() As Dynamic
  '''<Summary>Returns a Promise whose fulfillment handler receives a RTCStatsReport which contains statistics about the incoming streams and their dependencies.</Summary>
  Function [getStats]() As RTCStatsReport
  '''<Summary>Returns an array including one RTCRtpSynchronizationSource instance for each unique SSRC (synchronization source) identifier received by the current RTCRtpReceiver in the last ten seconds.</Summary>
  Function [getSynchronizationSources]() As RTCRtpSynchronizationSource
End Interface