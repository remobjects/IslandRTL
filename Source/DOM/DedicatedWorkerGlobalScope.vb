'''<Summary>The DedicatedWorkerGlobalScope object (the Worker global scope) is accessible through the self keyword. Some additional global functions, namespaces objects, and constructors, not typically associated with the worker global scope, but available on it, are listed in the JavaScript Reference. See also: Functions available to workers.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DedicatedWorkerGlobalScope]
  '''<Summary>The name that the Worker was (optionally) given when it was created using the Worker() constructor. This is mainly useful for debugging purposes.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>Is an EventHandler representing the code to be called when the message event is raised. These events are of type MessageEvent and will be called when the worker receives a message from the document that started it (i.e. from the Worker.postMessage method.)</Summary>
  Property [onmessage] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the messageerror event is raised.</Summary>
  Property [onmessageerror] As EventListener
End Interface