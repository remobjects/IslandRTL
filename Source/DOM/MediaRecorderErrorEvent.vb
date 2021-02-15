'''<summary>The MediaRecorderErrorEvent interface represents errors returned by the MediaStream Recording API. It is an Event object that encapsulates a reference to a DOMException describing the error that occurred.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaRecorderErrorEvent]
Inherits [Event]

  '''<summary>A DOMException containing information about the error that occurred. Read only.</summary>
  ReadOnly Property [error] As DOMException
  '''<summary>Creates and returns a new MediaRecorderErrorEvent event object with the given parameters.</summary>
  Property [MediaStreamRecorderEvent] As Dynamic
End Interface