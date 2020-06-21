'''<Summary>TextTrackCue is an abstract class which is used as the basis for the various derived cue types, such as VTTCue; you will instead work with those derived types.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TextTrackCue]
'Defined on this type 
  '''<Summary>The event handler for the enter event.</Summary>
  Property [onenter] As EventListener
  '''<Summary>The event handler for the exit event.</Summary>
  Property [onexit] As EventListener
End Interface