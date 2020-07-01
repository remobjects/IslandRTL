'''<Summary>The AbstractWorker interface of the Web Workers API is an abstract interface that defines properties and methods that are common to all types of worker, including not only the basic Worker, but also ServiceWorker and SharedWorker.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AbstractWorker]
  '''<Summary>An EventListener which is invoked whenever an ErrorEvent of type error bubbles through the worker.</Summary>
  Property [onerror] As EventListener
End Interface