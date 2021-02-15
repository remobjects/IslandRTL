'''<summary>The RTCRtpReceiver interface of the WebRTC API manages the reception and decoding of data for a MediaStreamTrack on an RTCPeerConnection.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpReceiver]
  '''<summary>Returns the MediaStreamTrack associated with the current RTCRtpReceiver instance. </summary>
  ReadOnly Property [track] As MediaStreamTrack
  '''<summary>Returns the RTCDtlsTransport instance over which RTCP is sent and received.</summary>
  ReadOnly Property [rtcpTransport] As Dynamic
  '''<summary>Returns the RTCDtlsTransport instance over which the media for the receiver's track is received.</summary>
  ReadOnly Property [transport] As Dynamic
  '''<summary>Returns an array of RTCRtpContributingSource instances for each unique CSRC (contributing source) identifier received by the current RTCRtpReceiver in the last ten seconds.</summary>
  Function [getContributingSources]() As RTCRtpContributingSource()
  '''<summary>Returns an RTCRtpParameters object which contains information about how the RTC data is to be decoded.</summary>
  Function [getParameters]() As Dynamic
  '''<summary>Returns a Promise whose fulfillment handler receives a RTCStatsReport which contains statistics about the incoming streams and their dependencies.</summary>
  Function [getStats]() As Dynamic
  '''<summary>Returns an array including one RTCRtpSynchronizationSource instance for each unique SSRC (synchronization source) identifier received by the current RTCRtpReceiver in the last ten seconds.</summary>
  Function [getSynchronizationSources]() As Dynamic
End Interface