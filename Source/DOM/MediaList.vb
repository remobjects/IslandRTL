'''<Summary>The MediaList interface represents the media queries of a stylesheet, e.g. those set using a &lt;link> element's media attribute.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaList]
  '''<Summary>A stringifier that returns a DOMString representing the MediaList as text, and also allows you to set a new MediaList.</Summary>
  Property [mediaText] As String
  '''<Summary>Returns the number of media queries in the MediaList.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Adds a media query to the MediaList.</Summary>
  Function [appendMedium]() As Dynamic
  '''<Summary>Removes a media query from the MediaList.</Summary>
  Function [deleteMedium]() As Dynamic
End Interface