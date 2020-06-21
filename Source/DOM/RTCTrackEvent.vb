'''<Summary>The WebRTC API interface RTCTrackEvent represents the track event, which is sent when a new MediaStreamTrack is added to an RTCRtpReceiver which is part of the RTCPeerConnection.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCTrackEvent]
'Defined on this type 
  '''<Summary>The RTCRtpReceiver used by the track that's been added to the RTCPeerConnection.</Summary>
  ReadOnly Property [receiver] As RTCRtpTransceiver
  '''<Summary>An array of MediaStream objects, each representing one of the media streams to which the added track belongs. By default, the array is empty, indicating a streamless track.</Summary>
  ReadOnly Property [streams] As MediaStream
  '''<Summary>The MediaStreamTrack which has been added to the connection.</Summary>
  ReadOnly Property [track] As MediaStreamTrack
  '''<Summary>The RTCRtpTransceiver being used by the new track.</Summary>
  ReadOnly Property [transceiver] As RTCRtpTransceiver
  '''<Summary>Creates and returns a new RTCTrackEvent object, initialized with properties taken from the specified RTCTrackEventInit dictionary. You will probably not need to create new track events yourself, since they're typically created by the WebRTC infrastructure and sent to the connection's ontrack event handler.</Summary>
  Function [RTCTrackEvent]() As RTCTrackEvent
End Interface