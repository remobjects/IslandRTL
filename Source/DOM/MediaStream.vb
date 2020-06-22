'''<Summary>The MediaStream interface represents a stream of media content. A stream consists of several tracks such as video or audio tracks. Each track is specified as an instance of MediaStreamTrack.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStream]
'Defined on this type 
  '''<Summary>A Boolean value that returns true if the MediaStream is active, or false otherwise.</Summary>
  ReadOnly Property [active] As Boolean
  '''<Summary>A DOMString containing 36 characters denoting a universally unique identifier (UUID) for the object.</Summary>
  ReadOnly Property [id] As Integer
  '''<Summary>An EventHandler containing the action to perform when an addtrack event is fired when a new MediaStreamTrack object is added.</Summary>
  Property [onaddtrack] As EventListener
  '''<Summary>An EventHandler containing the action to perform when a removetrack event is fired when a MediaStreamTrack object is removed from it.</Summary>
  Property [onremovetrack] As EventListener
  '''<Summary>Stores a copy of the MediaStreamTrack given as argument. If the track has already been added to the MediaStream object, nothing happens.</Summary>
  Function [addTrack]([partrack] As Dynamic) As MediaStream
  '''<Summary>Returns a clone of the MediaStream object. The clone will, however, have a unique value for id.</Summary>
  Function [clone]() As MediaStream
  '''<Summary>Returns a list of the MediaStreamTrack objects stored in the MediaStream object that have their kind attribute set to audio. The order is not defined, and may not only vary from one browser to another, but also from one call to another.</Summary>
  Function [getAudioTracks]() As MediaStream
  '''<Summary>Returns the track whose ID corresponds to the one given in parameters, trackid. If no parameter is given, or if no track with that ID does exist, it returns null. If several tracks have the same ID, it returns the first one.</Summary>
  Function [getTrackById]([parid] As Dynamic) As String
  '''<Summary>Returns a list of the MediaStreamTrack objects stored in the MediaStream object that have their kind attribute set to "video". The order is not defined, and may not only vary from one browser to another, but also from one call to another.</Summary>
  Function [getVideoTracks]() As MediaStream
  '''<Summary>Removes the MediaStreamTrack given as argument. If the track is not part of the MediaStream object, nothing happens.</Summary>
  Function [removeTrack]() As MediaStream
End Interface