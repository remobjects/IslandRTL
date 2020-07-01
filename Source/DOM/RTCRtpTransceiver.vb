'''<Summary>The WebRTC interface RTCRtpTransceiver describes a permanent pairing of an RTCRtpSender and an RTCRtpReceiver, along with some shared state.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpTransceiver]
  '''<Summary>A string from the enum RTCRtpTransceiverDirection which indicates the transceiver's current directionality, or null if the transceiver is stopped or has never participated in an exchange of offers and answers.</Summary>
  ReadOnly Property [currentDirection] As String
  '''<Summary>A string from the enum RTCRtpTransceiverDirection which is used to set the transceiver's desired direction.</Summary>
  Property [direction] As String
  '''<Summary>The media ID of the m-line associated with this transceiver. This association is established, when possible, whenever either a local or remote description is applied. This field is null if neither a local or remote description has been applied, or if its associated m-line is rejected by either a remote offer or any answer.</Summary>
  ReadOnly Property [mid] As Integer
  '''<Summary>The RTCRtpReceiver object that handles receiving and decoding incoming media.</Summary>
  ReadOnly Property [receiver] As Dynamic
  '''<Summary>The RTCRtpSender object responsible for encoding and sending data to the remote peer.</Summary>
  ReadOnly Property [sender] As Dynamic
  '''<Summary>Indicates whether or not sending and receiving using the paired RTCRtpSender and RTCRtpReceiver has been permanently disabled, either due to SDP offer/answer, or due to a call to stop().</Summary>
  Property [stopped] As Boolean
End Interface