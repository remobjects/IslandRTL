'''<Summary>The NavigatorID interface contains methods and properties related to the identity of the browser.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigatorID]
'Defined on this type 
  '''<Summary>Always returns "Mozilla", in any browser. This property is kept only for compatibility purposes.</Summary>
  ReadOnly Property [appCodeName] As String
  '''<Summary>Always returns "Netscape", in any browser. This property is kept only for compatibility purposes.</Summary>
  ReadOnly Property [appName] As String
  '''<Summary>Returns either "4.0" or a string representing version information about the browser. Do not rely on this property to return a useful value.</Summary>
  ReadOnly Property [appVersion] As String
  '''<Summary>Returns either the empty string or a string representing the platform the browser is running on. Do not rely on this property to return a useful value.</Summary>
  ReadOnly Property [platform] As String
  '''<Summary>Always returns "Gecko", in any browser. This property is kept only for compatibility purposes.</Summary>
  ReadOnly Property [product] As String
  '''<Summary>Returns the user-agent string for the current browser.</Summary>
  ReadOnly Property [userAgent] As String
End Interface