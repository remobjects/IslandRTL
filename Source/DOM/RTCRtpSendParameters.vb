'''<Summary>The WebRTC API's RTCRtpSendParameters dictionary is used to specify the parameters for an RTCRtpSender when calling its setParameters() method.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpSendParameters]
'Defined on this type 
  '''<Summary>Specifies the preferred way the WebRTC layer should handle optimizing bandwidth against quality in constrained-bandwidth situations; the value comes from the RTCDegradationPreference enumerated string type, and the default is balanced.</Summary>
  Property [degradationPreference] As String
  '''<Summary>An array of RTCRtpEncodingParameters objects, each specifying the parameters for a single codec that could be used to encode the track's media.</Summary>
  Property [encodings] As RTCRtpEncodingParameters()
  '''<Summary>A string from the RTCPriorityType enumerated type which indicates the encoding's priority. The default value is low.</Summary>
  Property [priority] As String
  '''<Summary>A string containing a unique ID for the last set of parameters applied; this value is used to ensure that setParameters() can only be called to alter changes made by a specific previous call to getParameters().</Summary>
  Property [transactionId] As Integer
End Interface