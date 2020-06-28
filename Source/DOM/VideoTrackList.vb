'''<Summary>The VideoTrackList interface is used to represent a list of the video tracks contained within a &lt;video> element, with each track represented by a separate VideoTrack object in the list.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [VideoTrackList]
Inherits EventTarget

  '''<Summary>The number of tracks in the list.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>The index of the currently selected track, if any, or −1 otherwise.</Summary>
  ReadOnly Property [selectedIndex] As Integer
  '''<Summary>An event handler to be called when the addtrack event is fired, indicating that a new video track has been added to the media element.</Summary>
  Property [onaddtrack] As EventListener
  '''<Summary>An event handler to be called when the change event occurs — that is, when the value of the selected property for a track has changed, due to the track being made active or inactive.</Summary>
  Property [onchange] As EventListener
  '''<Summary>An event handler to call when the removetrack event is sent, indicating that a video track has been removed from the media element.</Summary>
  Property [onremovetrack] As EventListener
End Interface