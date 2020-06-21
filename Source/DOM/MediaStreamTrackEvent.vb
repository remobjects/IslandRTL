'''<Summary>The MediaStreamTrackEvent interface represents events which indicate that a MediaStream has had tracks added to or removed from the stream through calls to Media Stream API methods. These events are sent to the stream when these changes occur.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStreamTrackEvent]
Inherits [Event]

'Defined on this type 
  '''<Summary>Constructs a new MediaStreamTrackEvent with the specified configuration.</Summary>
  Property [MediaStreamTrackEvent] As MediaStreamTrackEvent
  '''<Summary>Constructs a new MediaStreamTrackEvent with the specified configuration.</Summary>
  Function [MediaStreamTrackEvent]() As MediaStreamTrackEvent
End Interface