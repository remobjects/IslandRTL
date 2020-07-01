'''<Summary>The ServiceWorker interface of the ServiceWorker API provides a reference to a service worker. Multiple browsing contexts (e.g. pages, workers, etc.) can be associated with the same service worker, each through a unique ServiceWorker object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorker]
Inherits Worker

  '''<Summary>Returns the ServiceWorker serialized script URL defined as part of ServiceWorkerRegistration. The URL must be on the same origin as the document that registers the ServiceWorker.</Summary>
  ReadOnly Property [scriptURL] As String
  '''<Summary>Returns the state of the service worker. It returns one of the following values: installing, installed, activating, activated, or redundant.</Summary>
  ReadOnly Property [state] As ServiceWorkerState
  '''<Summary>An EventListener property called whenever an event of type statechange is fired; it is basically fired anytime the ServiceWorker.state changes.</Summary>
  Property [onstatechange] As EventListener
End Interface