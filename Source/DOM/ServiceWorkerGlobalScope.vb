'''<Summary>The ServiceWorkerGlobalScope interface of the ServiceWorker API represents the global execution context of a service worker.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerGlobalScope]
  '''<Summary>Contains the ServiceWorkerRegistration object that represents the service worker's registration.</Summary>
  ReadOnly Property [registration] As ServiceWorkerRegistration
  '''<Summary>Allows the current service worker registration to progress from waiting to active state while service worker clients are using it.</Summary>
  Function [skipWaiting]() As Worker
  '''<Summary>Starts the process of fetching a resource. This returns a promise that resolves to the Response object representing the response to your request. This algorithm is the entry point for the fetch handling handed to the service worker context.</Summary>
  Function [fetch]([parresource] As Dynamic, [parinit] As Dynamic, [parmethod] As Dynamic, [parheaders] As Dynamic, [parbody] As Dynamic, [parmode] As Dynamic, [parcredentials] As Dynamic, [parcache] As Dynamic, [parredirect] As Dynamic, [parreferrer] As Dynamic, [parreferrerPolicy] As Dynamic, [parintegrity] As Dynamic, [parkeepalive] As Dynamic, [parsignal] As Dynamic) As Worker
End Interface