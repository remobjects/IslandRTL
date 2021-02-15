'''<summary>The MediaStream interface represents a stream of media content. A stream consists of several tracks such as video or audio tracks. Each track is specified as an instance of MediaStreamTrack.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStream]
Inherits EventTarget

  '''<summary>A Boolean value that returns true if the MediaStream is active, or false otherwise.</summary>
  ReadOnly Property [active] As Boolean
  '''<summary>A DOMString containing 36 characters denoting a universally unique identifier (UUID) for the object.</summary>
  ReadOnly Property [id] As Integer
  '''<summary>An EventHandler containing the action to perform when an addtrack event is fired when a new MediaStreamTrack object is added.</summary>
  Property [onaddtrack] As EventListener
  '''<summary>An EventHandler containing the action to perform when a removetrack event is fired when a MediaStreamTrack object is removed from it.</summary>
  Property [onremovetrack] As EventListener
  '''<summary>Stores a copy of the MediaStreamTrack given as argument. If the track has already been added to the MediaStream object, nothing happens.</summary>
  Function [addTrack]([partrack] As Dynamic) As MediaStream
  '''<summary>Returns a clone of the MediaStream object. The clone will, however, have a unique value for id.</summary>
  Function [clone]() As MediaStream
  '''<summary>Returns a list of the MediaStreamTrack objects stored in the MediaStream object that have their kind attribute set to audio. The order is not defined, and may not only vary from one browser to another, but also from one call to another.</summary>
  Function [getAudioTracks]() As MediaStream
  '''<summary>Returns the track whose ID corresponds to the one given in parameters, trackid. If no parameter is given, or if no track with that ID does exist, it returns null. If several tracks have the same ID, it returns the first one.</summary>
  Function [getTrackById]([parid] As Dynamic) As String
  '''<summary>Returns a list of the MediaStreamTrack objects stored in the MediaStream object that have their kind attribute set to "video". The order is not defined, and may not only vary from one browser to another, but also from one call to another.</summary>
  Function [getVideoTracks]() As MediaStream
  '''<summary>Removes the MediaStreamTrack given as argument. If the track is not part of the MediaStream object, nothing happens.</summary>
  Function [removeTrack]() As MediaStream
End Interface