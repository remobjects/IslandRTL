'''<summary>The SharedWorker interface represents a specific kind of worker that can be accessed from several browsing contexts, such as several windows, iframes or even workers. They implement an interface different than dedicated workers and have a different global scope, SharedWorkerGlobalScope.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SharedWorker]
Inherits EventTarget, AbstractWorker

  '''<summary>Returns a MessagePort object used to communicate with and control the shared worker.</summary>
  ReadOnly Property [port] As Dynamic
End Interface