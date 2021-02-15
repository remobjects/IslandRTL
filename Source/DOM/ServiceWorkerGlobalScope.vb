'''<summary>The ServiceWorkerGlobalScope interface of the ServiceWorker API represents the global execution context of a service worker.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerGlobalScope]
  '''<summary>Contains the Clients object associated with the service worker.</summary>
  ReadOnly Property [clients] As Dynamic
  '''<summary>Contains the ServiceWorkerRegistration object that represents the service worker's registration.</summary>
  ReadOnly Property [registration] As Dynamic
  '''<summary>Contains the CacheStorage object associated with the service worker.</summary>
  ReadOnly Property [caches] As Dynamic
  '''<summary>Starts the process of fetching a resource. This returns a promise that resolves to the Response object representing the response to your request. This algorithm is the entry point for the fetch handling handed to the service worker context.</summary>
  Function [fetch]([parresource] As Dynamic, [parinit] As Dynamic, [parmethod] As Dynamic, [parheaders] As Dynamic, [parbody] As Dynamic, [parmode] As Dynamic, [parcredentials] As Dynamic, [parcache] As Dynamic, [parredirect] As Dynamic, [parreferrer] As Dynamic, [parreferrerPolicy] As Dynamic, [parintegrity] As Dynamic, [parkeepalive] As Dynamic, [parsignal] As Dynamic) As Dynamic
End Interface