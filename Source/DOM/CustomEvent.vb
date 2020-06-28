'''<Summary>The CustomEvent interface represents events initialized by an application for any purpose.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CustomEvent]
Inherits [Event]

  '''<Summary>Any data passed when initializing the event.</Summary>
  ReadOnly Property [detail] As Dynamic
End Interface