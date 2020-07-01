'''<Summary>The TextTrackList interface is used to represent a list of the text tracks defined by the &lt;track> element, with each track represented by a separate textTrack object in the list.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TextTrackList]
Inherits EventTarget

  '''<Summary>The number of tracks in the list.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>An event handler to be called when the addtrack event is fired, indicating that a new text track has been added to the media element.</Summary>
  Property [onaddtrack] As EventListener
  '''<Summary>An event handler to be called when the change event occurs.</Summary>
  Property [onchange] As EventListener
  '''<Summary>An event handler to call when the removetrack event is sent, indicating that a text track has been removed from the media element.</Summary>
  Property [onremovetrack] As EventListener
End Interface