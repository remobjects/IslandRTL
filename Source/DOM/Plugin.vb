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
  '''<Summary>Returns the MIME type of a supported content type, given the index number into a list of supported types.</Summary>
  Default Property [item]() As Dynamic
  '''<Summary>Returns the MIME type of a supported item.</Summary>
  Function [namedItem]() As Dynamic
End Interface