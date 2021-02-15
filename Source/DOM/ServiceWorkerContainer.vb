'''<summary>The ServiceWorkerContainer interface of the Service Worker API provides an object representing the service worker as an overall unit in the network ecosystem, including facilities to register, unregister and update service workers, and access the state of service workers and their registrations.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerContainer]
  '''<summary>Returns a ServiceWorker object if its state is activated (the same object returned by ServiceWorkerRegistration.active). This property returns null during a force-refresh request (Shift + refresh) or if there is no active worker.</summary>
  ReadOnly Property [controller] As Dynamic
  '''<summary>Provides a way of delaying code execution until a service worker is active. It returns a Promise that will never reject, and which waits indefinitely until the ServiceWorkerRegistration associated with the current page has an ServiceWorkerRegistration.active worker. Once that condition is met, it resolves with the ServiceWorkerRegistration.</summary>
  ReadOnly Property [ready] As Dynamic
  '''<summary>Creates or updates a ServiceWorkerRegistration for the given scriptURL.</summary>
  Function [register]([parscriptURL] As Dynamic, [paroptions] As Dynamic) As Dynamic
  '''<summary>Gets a ServiceWorkerRegistration object whose scope matches the provided document URL.  The method returns a Promise that resolves to a ServiceWorkerRegistration or undefined. </summary>
  Function [getRegistration]([parscope] As Dynamic) As Dynamic
  '''<summary>Returns all ServiceWorkerRegistration objects associated with a ServiceWorkerContainer in an array.  The method returns a Promise that resolves to an array of ServiceWorkerRegistration. </summary>
  Function [getRegistrations]() As ServiceWorkerRegistration()
  '''<summary>explicitly starts the flow of messages being dispatched from a service worker to pages under its control (e.g. sent via Client.postMessage()). This can be used to react to sent messages earlier, even before that page's content has finished loading.</summary>
  Function [startMessages]() As Dynamic
End Interface