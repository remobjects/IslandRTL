'''<Summary>NavigatorLanguage contains methods and properties related to the language of the navigator.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigatorLanguage]
  '''<Summary>Returns a DOMString representing the preferred language of the user, usually the language of the browser UI. The null value is returned when this is unknown.</Summary>
  ReadOnly Property [language] As String
  '''<Summary>Returns an array of DOMString representing the languages known to the user, by order of preference.</Summary>
  ReadOnly Property [languages] As String
End Interface