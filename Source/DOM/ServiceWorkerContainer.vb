'''<Summary>The ServiceWorkerContainer interface of the Service Worker API provides an object representing the service worker as an overall unit in the network ecosystem, including facilities to register, unregister and update service workers, and access the state of service workers and their registrations.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerContainer]
  '''<Summary>Returns a ServiceWorker object if its state is activated (the same object returned by ServiceWorkerRegistration.active). This property returns null during a force-refresh request (Shift + refresh) or if there is no active worker.</Summary>
  ReadOnly Property [controller] As ServiceWorker
  '''<Summary>Provides a way of delaying code execution until a service worker is active. It returns a Promise that will never reject, and which waits indefinitely until the ServiceWorkerRegistration associated with the current page has an ServiceWorkerRegistration.active worker. Once that condition is met, it resolves with the ServiceWorkerRegistration.</Summary>
  ReadOnly Property [ready] As Worker
  '''<Summary>Creates or updates a ServiceWorkerRegistration for the given scriptURL.</Summary>
  Function [register]([parscriptURL] As Dynamic, [paroptions] As Dynamic) As ServiceWorkerRegistration
  '''<Summary>Gets a ServiceWorkerRegistration object whose scope matches the provided document URL.  The method returns a Promise that resolves to a ServiceWorkerRegistration or undefined. </Summary>
  Function [getRegistration]([parscope] As Dynamic) As Document
  '''<Summary>Returns all ServiceWorkerRegistration objects associated with a ServiceWorkerContainer in an array.  The method returns a Promise that resolves to an array of ServiceWorkerRegistration. </Summary>
  Function [getRegistrations]() As ServiceWorkerRegistration()
  '''<Summary>explicitly starts the flow of messages being dispatched from a service worker to pages under its control (e.g. sent via Client.postMessage()). This can be used to react to sent messages earlier, even before that page's content has finished loading.</Summary>
  Function [startMessages]() As Worker
End Interface