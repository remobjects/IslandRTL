'''<summary>The WebRTC API's RTCRtpSendParameters dictionary is used to specify the parameters for an RTCRtpSender when calling its setParameters() method.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpSendParameters]
  '''<summary>Specifies the preferred way the WebRTC layer should handle optimizing bandwidth against quality in constrained-bandwidth situations; the value comes from the RTCDegradationPreference enumerated string type, and the default is balanced.</summary>
  Property [degradationPreference] As String
  '''<summary>An array of RTCRtpEncodingParameters objects, each specifying the parameters for a single codec that could be used to encode the track's media.</summary>
  Property [encodings] As RTCRtpEncodingParameters()
  '''<summary>A string from the RTCPriorityType enumerated type which indicates the encoding's priority. The default value is low.</summary>
  Property [priority] As String
  '''<summary>A string containing a unique ID for the last set of parameters applied; this value is used to ensure that setParameters() can only be called to alter changes made by a specific previous call to getParameters().</summary>
  Property [transactionId] As Integer
End Interface