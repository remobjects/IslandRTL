'''<Summary>The RTCRtpSynchronizationSource dictionary of the the WebRTC API is used by getSynchronizationSources() to describe a particular synchronization source (SSRC).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpSynchronizationSource]
'Defined on this type 
  '''<Summary>A Boolean value indicating whether or not voice activity is included in the last RTP packet played from the source. If the peer has indicated that it's not supporting voice activity detection, this field is not provided.</Summary>
  Property [voiceActivityFlag] As Boolean
End Interface