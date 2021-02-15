'''<summary>The VideoTrackList interface is used to represent a list of the video tracks contained within a &lt;video> element, with each track represented by a separate VideoTrack object in the list.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [VideoTrackList]
Inherits EventTarget

  '''<summary>The number of tracks in the list.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>The index of the currently selected track, if any, or −1 otherwise.</summary>
  ReadOnly Property [selectedIndex] As Integer
  '''<summary>An event handler to be called when the addtrack event is fired, indicating that a new video track has been added to the media element.</summary>
  Property [onaddtrack] As EventListener
  '''<summary>An event handler to be called when the change event occurs — that is, when the value of the selected property for a track has changed, due to the track being made active or inactive.</summary>
  Property [onchange] As EventListener
  '''<summary>An event handler to call when the removetrack event is sent, indicating that a video track has been removed from the media element.</summary>
  Property [onremovetrack] As EventListener
  '''<summary>Returns the VideoTrack found within the VideoTrackList whose id matches the specified string. If no match is found, null is returned.</summary>
  Sub [getTrackById]([parid] As Dynamic)
End Interface