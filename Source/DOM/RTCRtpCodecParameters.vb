'''<Summary>The RTCRtpCodecParameters dictionary, part of the WebRTC API, is used to describe the configuration parameters for a single media codec.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpCodecParameters]
  '''<Summary>The RTP payload type used to identify this codec.</Summary>
  Property [payloadType] As Dynamic
  '''<Summary>The codec's MIME media type and subtype specified as a DOMString of the form "type/subtype". IANA maintains a registry of valid MIME types.</Summary>
  Property [mimeType] As Dynamic
  '''<Summary>An unsigned long integer value specifying the codec's clock rate in hertz (Hz). The clock rate is the rate at which the codec's RTP timestamp advances. Most codecs have specific values or ranges of values they permit; see the IANA payload format media type registry for details.</Summary>
  Property [clockRate] As DateTime
  '''<Summary>An unsigned short integer indicating the number of channels the codec should support. For example, for audio codecs, a value of 1 specifies monaural sound while 2 indicates stereo.</Summary>
  Property [channels] As Dynamic
  '''<Summary>A DOMString containing the format-specific parameters field from the "a=fmtp" line in the codec's SDP, if one is present; see section 5.8 of the IETF specification for JSEP.</Summary>
  Property [sdpFmtpLine] As String
End Interface