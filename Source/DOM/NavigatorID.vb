'''<summary>The NavigatorID interface contains methods and properties related to the identity of the browser.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigatorID]
  '''<summary>Always returns "Mozilla", in any browser. This property is kept only for compatibility purposes.</summary>
  ReadOnly Property [appCodeName] As String
  '''<summary>Always returns "Netscape", in any browser. This property is kept only for compatibility purposes.</summary>
  ReadOnly Property [appName] As String
  '''<summary>Returns either "4.0" or a string representing version information about the browser. Do not rely on this property to return a useful value.</summary>
  ReadOnly Property [appVersion] As String
  '''<summary>Returns either the empty string or a string representing the platform the browser is running on. Do not rely on this property to return a useful value.</summary>
  ReadOnly Property [platform] As String
  '''<summary>Always returns "Gecko", in any browser. This property is kept only for compatibility purposes.</summary>
  ReadOnly Property [product] As String
  '''<summary>Returns the user-agent string for the current browser.</summary>
  ReadOnly Property [userAgent] As String
End Interface