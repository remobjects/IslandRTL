'''<summary>The RTCRtpSynchronizationSource dictionary of the the WebRTC API is used by getSynchronizationSources() to describe a particular synchronization source (SSRC).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpSynchronizationSource]
  '''<summary>A Boolean value indicating whether or not voice activity is included in the last RTP packet played from the source. If the peer has indicated that it's not supporting voice activity detection, this field is not provided.</summary>
  Property [voiceActivityFlag] As Boolean
End Interface