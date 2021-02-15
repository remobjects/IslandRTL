'''<summary>The RTCRtpCodecParameters dictionary, part of the WebRTC API, is used to describe the configuration parameters for a single media codec.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpCodecParameters]
  '''<summary>The RTP payload type used to identify this codec.</summary>
  Property [payloadType] As Dynamic
  '''<summary>The codec's MIME media type and subtype specified as a DOMString of the form "type/subtype". IANA maintains a registry of valid MIME types.</summary>
  Property [mimeType] As Dynamic
  '''<summary>An unsigned long integer value specifying the codec's clock rate in hertz (Hz). The clock rate is the rate at which the codec's RTP timestamp advances. Most codecs have specific values or ranges of values they permit; see the IANA payload format media type registry for details.</summary>
  Property [clockRate] As DateTime
  '''<summary>An unsigned short integer indicating the number of channels the codec should support. For example, for audio codecs, a value of 1 specifies monaural sound while 2 indicates stereo.</summary>
  Property [channels] As Dynamic
  '''<summary>A DOMString containing the format-specific parameters field from the "a=fmtp" line in the codec's SDP, if one is present; see section 5.8 of the IETF specification for JSEP.</summary>
  Property [sdpFmtpLine] As String
End Interface