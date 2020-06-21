'''<Summary>The EventListener interface represents an object that can handle an event dispatched by an EventTarget object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [EventListener]
'Defined on this type 
  '''<Summary>A function that is called whenever an event of the specified type occurs.</Summary>
  Function [handleEvent]([parevent] As Dynamic) As Dynamic
End Interface