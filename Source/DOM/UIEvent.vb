'''<Summary>The UIEvent interface represents simple user interface events.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [UIEvent]
'Defined on this type 
  '''<Summary>Returns a long with details about the event, depending on the event type.</Summary>
  ReadOnly Property [detail] As Dynamic
  '''<Summary>Returns a WindowProxy that contains the view that generated the event.</Summary>
  ReadOnly Property [view] As Window
End Interface