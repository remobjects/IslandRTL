'''<summary>The RTCRtpContributingSource dictionary of the the WebRTC API is used by getContributingSources() to provide information about a given contributing source (CSRC), including the most recent time a packet that the source contributed was played out.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpContributingSource]
  '''<summary>A double-precision floating-point value between 0 and 1 specifying the audio level contained in the last RTP packet played from this source.</summary>
  Property [audioLevel] As Double
  '''<summary>The RTP timestamp of the media played out at the time indicated by timestamp. This value is a source-generated time value which can be used to help with sequencing and synchronization.</summary>
  Property [rtpTimestamp] As DateTime
  '''<summary>A 32-bit unsigned integer value specifying the CSRC identifier of the contributing source.</summary>
  Property [source] As Integer
  '''<summary>A DOMHighResTimeStamp indicating the most recent time at which a frame originating from this source was delivered to the receiver's MediaStreamTrack</summary>
  Property [timestamp] As DOMHighResTimeStamp
End Interface