'''<Summary>The SharedWorker interface represents a specific kind of worker that can be accessed from several browsing contexts, such as several windows, iframes or even workers. They implement an interface different than dedicated workers and have a different global scope, SharedWorkerGlobalScope.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SharedWorker]
'Defined on this type 
  '''<Summary>Returns a MessagePort object used to communicate with and control the shared worker.</Summary>
  ReadOnly Property [port] As Dynamic
End Interface