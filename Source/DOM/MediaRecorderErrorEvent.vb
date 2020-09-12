'''<Summary>The MediaRecorderErrorEvent interface represents errors returned by the MediaStream Recording API. It is an Event object that encapsulates a reference to a DOMException describing the error that occurred.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaRecorderErrorEvent]
Inherits [Event]

  '''<Summary>A DOMException containing information about the error that occurred. Read only.</Summary>
  ReadOnly Property [error] As DOMException
End Interface