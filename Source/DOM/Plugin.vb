'''<summary>The Plugin interface provides information about a browser plugin.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Plugin]
  '''<summary>A human readable description of the plugin.</summary>
  ReadOnly Property [description] As String
  '''<summary>The filename of the plugin file.</summary>
  ReadOnly Property [filename] As String
  '''<summary>The name of the plugin.</summary>
  ReadOnly Property [name] As String
  '''<summary>The plugin's version number string.</summary>
  ReadOnly Property [version] As Dynamic
End Interface