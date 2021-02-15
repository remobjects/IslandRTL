'''<summary>The WebRTC API's RTCTrackEventInit dictionary is used to provide information describing an RTCTrackEvent when instantiating a new track event using new RTCTrackEvent().</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCTrackEventInit]
  '''<summary>The RTCRtpReceiver which is being used to receive the track's media.</summary>
  Property [receiver] As RTCRtpTransceiver
  '''<summary>An array of MediaStream objects representing each of the streams that comprise the event's corresponding track.</summary>
  Property [streams] As MediaStream
  '''<summary>The MediaStreamTrack the event is associated with.</summary>
  Property [track] As MediaStreamTrack
  '''<summary>The RTCRtpTransceiver associated with the event.</summary>
  Property [transceiver] As RTCRtpTransceiver
End Interface