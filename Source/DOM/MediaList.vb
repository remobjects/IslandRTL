'''<summary>The MediaList interface represents the media queries of a stylesheet, e.g. those set using a &lt;link> element's media attribute.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaList]
  '''<summary>A stringifier that returns a DOMString representing the MediaList as text, and also allows you to set a new MediaList.</summary>
  Property [mediaText] As String
  '''<summary>Returns the number of media queries in the MediaList.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Adds a media query to the MediaList.</summary>
  Function [appendMedium]() As Dynamic
  '''<summary>Removes a media query from the MediaList.</summary>
  Function [deleteMedium]() As Dynamic
End Interface