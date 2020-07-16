'''<Summary>The ServiceWorkerRegistration interface of the Service Worker API represents the service worker registration. You register a service worker to control one or more pages that share the same origin.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerRegistration]
  '''<Summary>Returns a service worker whose state is installing. This is initially set to null.</Summary>
  ReadOnly Property [installing] As Dynamic
  '''<Summary>Returns a service worker whose state is installed. This is initially set to null.</Summary>
  ReadOnly Property [waiting] As Dynamic
  '''<Summary>Returns a service worker whose state is either activating or activated. This is initially set to null. An active worker will control a ServiceWorkerClient if the client's URL falls within the scope of the registration (the scope option set when ServiceWorkerContainer.register is first called.)</Summary>
  ReadOnly Property [active] As String
  '''<Summary>Returns the instance of NavigationPreloadManager associated with the current service worker registration.</Summary>
  ReadOnly Property [navigationPreload] As Dynamic
  '''<Summary>Returns a reference to the PushManager interface for managing push subscriptions including subscribing, getting an active subscription, and accessing push permission status.</Summary>
  ReadOnly Property [pushManager] As Dynamic
  '''<Summary>An EventListener property called whenever an event of type updatefound is fired; it is fired any time the ServiceWorkerRegistration.installing property acquires a new service worker.</Summary>
  Property [onupdatefound] As EventListener
  '''<Summary>Returns a Promise that resolves to an array of Notification objects.</Summary>
  Function [getNotifications]([paroptions] As Dynamic) As Dynamic
  '''<Summary>Displays the notification with the requested title.</Summary>
  Function [showNotification]([partitle] As Dynamic, [paroptions] As Dynamic) As Dynamic
  '''<Summary>Checks the server for an updated version of the service worker without consulting caches.</Summary>
  Function [update]() As Integer
  '''<Summary>Unregisters the service worker registration and returns a Promise. The service worker will finish any ongoing operations before it is unregistered.</Summary>
  Function [unregister]() As Dynamic
End Interface