'''<Summary>The WebRTC API's RTCTrackEventInit dictionary is used to provide information describing an RTCTrackEvent when instantiating a new track event using new RTCTrackEvent().</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCTrackEventInit]
  '''<Summary>The RTCRtpReceiver which is being used to receive the track's media.</Summary>
  Property [receiver] As RTCRtpTransceiver
  '''<Summary>An array of MediaStream objects representing each of the streams that comprise the event's corresponding track.</Summary>
  Property [streams] As MediaStream
  '''<Summary>The MediaStreamTrack the event is associated with.</Summary>
  Property [track] As MediaStreamTrack
  '''<Summary>The RTCRtpTransceiver associated with the event.</Summary>
  Property [transceiver] As RTCRtpTransceiver
End Interface