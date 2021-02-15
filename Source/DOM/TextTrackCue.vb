'''<summary>TextTrackCue is an abstract class which is used as the basis for the various derived cue types, such as VTTCue; you will instead work with those derived types.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TextTrackCue]
  '''<summary>The event handler for the enter event.</summary>
  Property [onenter] As EventListener
  '''<summary>The event handler for the exit event.</summary>
  Property [onexit] As EventListener
End Interface