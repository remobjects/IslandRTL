'''<summary>NavigatorLanguage contains methods and properties related to the language of the navigator.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigatorLanguage]
  '''<summary>Returns a DOMString representing the preferred language of the user, usually the language of the browser UI. The null value is returned when this is unknown.</summary>
  ReadOnly Property [language] As String
  '''<summary>Returns an array of DOMString representing the languages known to the user, by order of preference.</summary>
  ReadOnly Property [languages] As String
End Interface