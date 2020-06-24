'''<Summary>The AudioScheduledSourceNode interface—part of the Web Audio API—is a parent interface for several types of audio source node interfaces which share the ability to be started and stopped, optionally at specified times. Specifically, this interface defines the start() and stop() methods, as well as the onended event handler.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioScheduledSourceNode]
Inherits AudioNode

'Defined on this type 
  '''<Summary>Schedules the node to begin playing the constant sound at the specified time. If no time is specified, the node begins playing immediately.</Summary>
  Sub [start]([parwhen] As Dynamic, [paroffset] As Dynamic, [parduration] As Dynamic)
  '''<Summary>Schedules the node to stop playing at the specified time. If no time is specified, the node stops playing at once.</Summary>
  Sub [stop]([parwhen] As Dynamic)
End Interface