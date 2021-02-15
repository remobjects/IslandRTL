'''<summary>The HashChangeEvent interface represents events that fire when the fragment identifier of the URL has changed.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HashChangeEvent]
  '''<summary>The new URL to which the window is navigating.</summary>
  ReadOnly Property [newURL] As String
  '''<summary>The previous URL from which the window was navigated.</summary>
  ReadOnly Property [oldURL] As String
End Interface