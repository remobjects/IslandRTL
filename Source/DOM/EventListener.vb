'''<summary>The EventListener interface represents an object that can handle an event dispatched by an EventTarget object.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventListener]
  '''<summary>A function that is called whenever an event of the specified type occurs.</summary>
  Function [handleEvent]([parevent] As Dynamic) As Dynamic
End Interface