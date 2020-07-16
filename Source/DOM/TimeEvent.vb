'''<Summary>The TimeEvent interface, a part of SVG SMIL animation, provides specific contextual information associated with Time events.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TimeEvent]
  '''<Summary>Is a long that specifies some detail information about the Event, depending on the type of the event. For this event type, indicates the repeat number for the animation.</Summary>
  ReadOnly Property [detail] As Dynamic
  '''<Summary>Is a WindowProxy that identifies the Window from which the event was generated.</Summary>
  ReadOnly Property [view] As Window
  '''<Summary>The initTimeEvent method is used to initialize the value of a TimeEvent created through the DocumentEvent interface. This method may only be called before the TimeEvent has been dispatched via the dispatchEvent method, though it may be called multiple times during that phase if necessary.</Summary>
  Function [initTimeEvent]() As Dynamic
End Interface