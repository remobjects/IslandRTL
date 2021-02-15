'''<summary>EventTarget is a DOM interface implemented by objects that can receive events and may have listeners for them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventTarget]
  '''<summary>Registers an event handler of a specific event type on the EventTarget.</summary>
  Sub [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic)
  '''<summary>Registers an event handler of a specific event type on the EventTarget.</summary>
  Sub [addEventListener]([type] As Dynamic, [listener] As Dynamic, [options] As Dynamic)
  '''<summary>Registers an event handler of a specific event type on the EventTarget.</summary>
  Sub [addEventListener]([type] As Dynamic, [listener] As Dynamic, [useCapture] As Boolean)
  '''<summary>Removes an event listener from the EventTarget.</summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
End Interface