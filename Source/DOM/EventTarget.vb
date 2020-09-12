'''<Summary>EventTarget is a DOM interface implemented by objects that can receive events and may have listeners for them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventTarget]
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Function [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic) As [Event]
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Function [addEventListener]([type] As Dynamic, [listener] As Dynamic, [options] As Dynamic) As [Event]
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Function [addEventListener]([type] As Dynamic, [listener] As Dynamic, [useCapture] As Boolean) As [Event]
  '''<Summary>Removes an event listener from the EventTarget.</Summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
  '''<Summary>Dispatches an event to this EventTarget.</Summary>
  Function [dispatchEvent]([parevent] As Dynamic) As [Event]
End Interface