'''<Summary>EventTarget is a DOM interface implemented by objects that can receive events and may have listeners for them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventTarget]
'Defined on this type 
  '''<Summary>Creates a new EventTarget object instance.</Summary>
  Function [EventTarget]() As EventTarget
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Sub [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic)
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Sub [addEventListener]([type] As Dynamic, [listener] As Dynamic, [options] As Dynamic)
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Sub [addEventListener]([type] As Dynamic, [listener] As Dynamic, [useCapture] As Boolean)
  '''<Summary>Removes an event listener from the EventTarget.</Summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
End Interface