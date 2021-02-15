'''<summary>The TextTrackList interface is used to represent a list of the text tracks defined by the &lt;track> element, with each track represented by a separate textTrack object in the list.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TextTrackList]
Inherits EventTarget

  '''<summary>The number of tracks in the list.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>An event handler to be called when the addtrack event is fired, indicating that a new text track has been added to the media element.</summary>
  Property [onaddtrack] As EventListener
  '''<summary>An event handler to be called when the change event occurs.</summary>
  Property [onchange] As EventListener
  '''<summary>An event handler to call when the removetrack event is sent, indicating that a text track has been removed from the media element.</summary>
  Property [onremovetrack] As EventListener
  '''<summary>Returns the TextTrack found within the TextTrackList whose id matches the specified string. If no match is found, null is returned.</summary>
  Function [getTrackById]([parid] As Dynamic) As TextTrack
End Interface