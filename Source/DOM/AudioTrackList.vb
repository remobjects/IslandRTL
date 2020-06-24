'''<Summary>The AudioTrackList interface is used to represent a list of the audio tracks contained within a given HTML media element, with each track represented by a separate AudioTrack object in the list.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioTrackList]
Inherits EventTarget

'Defined on this type 
  '''<Summary>The number of tracks in the list.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>An event handler to be called when the addtrack event is fired, indicating that a new audio track has been added to the media element.</Summary>
  Property [onaddtrack] As EventListener
  '''<Summary>An event handler to be called when the change event occurs. This occurs when one or more tracks have been enabled or disabled by their enabled flag being changed.</Summary>
  Property [onchange] As EventListener
  '''<Summary>An event handler to call when the removetrack event is sent, indicating that an audio track has been removed from the media element.</Summary>
  Property [onremovetrack] As EventListener
  '''<Summary>Returns the AudioTrack found within the AudioTrackList whose id matches the specified string. If no match is found, null is returned.</Summary>
  Sub [getTrackById]([parid] As Dynamic)
End Interface