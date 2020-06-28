'''<Summary>The ServiceWorkerGlobalScope interface of the ServiceWorker API represents the global execution context of a service worker.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerGlobalScope]
  '''<Summary>Contains the Clients object associated with the service worker.</Summary>
  ReadOnly Property [clients] As Dynamic
  '''<Summary>Contains the ServiceWorkerRegistration object that represents the service worker's registration.</Summary>
  ReadOnly Property [registration] As Dynamic
  '''<Summary>Contains the CacheStorage object associated with the service worker.</Summary>
  ReadOnly Property [caches] As Dynamic
End Interface