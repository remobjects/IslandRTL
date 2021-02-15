'''<summary>The AudioTrackList interface is used to represent a list of the audio tracks contained within a given HTML media element, with each track represented by a separate AudioTrack object in the list.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioTrackList]
Inherits EventTarget

  '''<summary>The number of tracks in the list.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>An event handler to be called when the addtrack event is fired, indicating that a new audio track has been added to the media element.</summary>
  Property [onaddtrack] As EventListener
  '''<summary>An event handler to be called when the change event occurs. This occurs when one or more tracks have been enabled or disabled by their enabled flag being changed.</summary>
  Property [onchange] As EventListener
  '''<summary>An event handler to call when the removetrack event is sent, indicating that an audio track has been removed from the media element.</summary>
  Property [onremovetrack] As EventListener
  '''<summary>Returns the AudioTrack found within the AudioTrackList whose id matches the specified string. If no match is found, null is returned.</summary>
  Sub [getTrackById]([parid] As Dynamic)
End Interface