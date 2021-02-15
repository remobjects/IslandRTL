'''<summary>The WebRTC API's RTCOfferAnswerOptions dictionary is used to specify options that configure and control the process of creating WebRTC offers or answers.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCOfferAnswerOptions]
  '''<summary>For configurations of systems and codecs that are able to detect when the user is speaking and toggle muting on and off automatically, this option enables and disables that behavior. The default value is true, enabling this functionality</summary>
  Property [voiceActivityDetection] As Boolean
End Interface