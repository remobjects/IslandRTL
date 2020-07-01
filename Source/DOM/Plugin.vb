'''<Summary>The Plugin interface provides information about a browser plugin.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Plugin]
  '''<Summary>A human readable description of the plugin.</Summary>
  ReadOnly Property [description] As String
  '''<Summary>The filename of the plugin file.</Summary>
  ReadOnly Property [filename] As String
  '''<Summary>The name of the plugin.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>The plugin's version number string.</Summary>
  ReadOnly Property [version] As Dynamic
End Interface