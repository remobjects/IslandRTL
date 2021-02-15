'''<summary>The WebRTC API interface RTCTrackEvent represents the track event, which is sent when a new MediaStreamTrack is added to an RTCRtpReceiver which is part of the RTCPeerConnection.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCTrackEvent]
  '''<summary>The RTCRtpReceiver used by the track that's been added to the RTCPeerConnection.</summary>
  ReadOnly Property [receiver] As RTCRtpTransceiver
  '''<summary>An array of MediaStream objects, each representing one of the media streams to which the added track belongs. By default, the array is empty, indicating a streamless track.</summary>
  ReadOnly Property [streams] As MediaStream
  '''<summary>The MediaStreamTrack which has been added to the connection.</summary>
  ReadOnly Property [track] As MediaStreamTrack
  '''<summary>The RTCRtpTransceiver being used by the new track.</summary>
  ReadOnly Property [transceiver] As RTCRtpTransceiver
End Interface