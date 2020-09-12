'''<Summary>The RTCRtpContributingSource dictionary of the the WebRTC API is used by getContributingSources() to provide information about a given contributing source (CSRC), including the most recent time a packet that the source contributed was played out.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpContributingSource]
  '''<Summary>A double-precision floating-point value between 0 and 1 specifying the audio level contained in the last RTP packet played from this source.</Summary>
  Property [audioLevel] As Double
  '''<Summary>The RTP timestamp of the media played out at the time indicated by timestamp. This value is a source-generated time value which can be used to help with sequencing and synchronization.</Summary>
  Property [rtpTimestamp] As Integer
  '''<Summary>A 32-bit unsigned integer value specifying the CSRC identifier of the contributing source.</Summary>
  Property [source] As Integer
  '''<Summary>A DOMHighResTimeStamp indicating the most recent time at which a frame originating from this source was delivered to the receiver's MediaStreamTrack</Summary>
  Property [timestamp] As DOMHighResTimeStamp
End Interface