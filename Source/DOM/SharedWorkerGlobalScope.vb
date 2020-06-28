'''<Summary>The SharedWorkerGlobalScope object (the SharedWorker global scope) is accessible through the self keyword. Some additional global functions, namespaces objects, and constructors, not typically associated with the worker global scope, but available on it, are listed in the JavaScript Reference. See the complete list of functions available to workers.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SharedWorkerGlobalScope]
  '''<Summary>The name that the SharedWorker was (optionally) given when it was created using the SharedWorker() constructor. This is mainly useful for debugging purposes.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>Is an EventHandler representing the code to be called when the connect event is raised — that is, when a MessagePort connection is opened between the associated SharedWorker and the main thread.</Summary>
  Property [onconnect] As EventListener
End Interface