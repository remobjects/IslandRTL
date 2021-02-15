'''<summary>The UIEvent interface represents simple user interface events.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [UIEvent]
  '''<summary>Returns a long with details about the event, depending on the event type.</summary>
  ReadOnly Property [detail] As Dynamic
  '''<summary>Returns a WindowProxy that contains the view that generated the event.</summary>
  ReadOnly Property [view] As Window
End Interface