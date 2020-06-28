'''<Summary>The MediaStream interface represents a stream of media content. A stream consists of several tracks such as video or audio tracks. Each track is specified as an instance of MediaStreamTrack.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStream]
Inherits EventTarget

  '''<Summary>A Boolean value that returns true if the MediaStream is active, or false otherwise.</Summary>
  ReadOnly Property [active] As Boolean
  '''<Summary>A DOMString containing 36 characters denoting a universally unique identifier (UUID) for the object.</Summary>
  ReadOnly Property [id] As Integer
  '''<Summary>An EventHandler containing the action to perform when an addtrack event is fired when a new MediaStreamTrack object is added.</Summary>
  Property [onaddtrack] As EventListener
  '''<Summary>An EventHandler containing the action to perform when a removetrack event is fired when a MediaStreamTrack object is removed from it.</Summary>
  Property [onremovetrack] As EventListener
End Interface