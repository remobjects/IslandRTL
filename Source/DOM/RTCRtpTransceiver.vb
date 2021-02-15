'''<summary>The WebRTC interface RTCRtpTransceiver describes a permanent pairing of an RTCRtpSender and an RTCRtpReceiver, along with some shared state.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpTransceiver]
  '''<summary>A string from the enum RTCRtpTransceiverDirection which indicates the transceiver's current directionality, or null if the transceiver is stopped or has never participated in an exchange of offers and answers.</summary>
  ReadOnly Property [currentDirection] As String
  '''<summary>A string from the enum RTCRtpTransceiverDirection which is used to set the transceiver's desired direction.</summary>
  Property [direction] As String
  '''<summary>The media ID of the m-line associated with this transceiver. This association is established, when possible, whenever either a local or remote description is applied. This field is null if neither a local or remote description has been applied, or if its associated m-line is rejected by either a remote offer or any answer.</summary>
  ReadOnly Property [mid] As Integer
  '''<summary>The RTCRtpReceiver object that handles receiving and decoding incoming media.</summary>
  ReadOnly Property [receiver] As Dynamic
  '''<summary>The RTCRtpSender object responsible for encoding and sending data to the remote peer.</summary>
  ReadOnly Property [sender] As Dynamic
  '''<summary>Indicates whether or not sending and receiving using the paired RTCRtpSender and RTCRtpReceiver has been permanently disabled, either due to SDP offer/answer, or due to a call to stop().</summary>
  Property [stopped] As Boolean
  '''<summary>A list of RTCRtpCodecParameters objects which override the default preferences used by the user agent for the transceiver's codecs.</summary>
  Function [setCodecPreferences]([parcodecs] As Dynamic) As RTCRtpCodecParameters()
  '''<summary>Permanently stops the RTCRtpTransceiver. The associated sender stops sending data, and the associated receiver likewise stops receiving and decoding incoming data.</summary>
  Sub [stop]()
End Interface