'''<Summary>The HashChangeEvent interface represents events that fire when the fragment identifier of the URL has changed.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HashChangeEvent]
  '''<Summary>The new URL to which the window is navigating.</Summary>
  ReadOnly Property [newURL] As String
  '''<Summary>The previous URL from which the window was navigated.</Summary>
  ReadOnly Property [oldURL] As String
End Interface