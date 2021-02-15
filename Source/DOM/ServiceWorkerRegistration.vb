'''<summary>The ServiceWorkerRegistration interface of the Service Worker API represents the service worker registration. You register a service worker to control one or more pages that share the same origin.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ServiceWorkerRegistration]
  '''<summary>Returns a service worker whose state is installing. This is initially set to null.</summary>
  ReadOnly Property [installing] As Dynamic
  '''<summary>Returns a service worker whose state is installed. This is initially set to null.</summary>
  ReadOnly Property [waiting] As Dynamic
  '''<summary>Returns a service worker whose state is either activating or activated. This is initially set to null. An active worker will control a ServiceWorkerClient if the client's URL falls within the scope of the registration (the scope option set when ServiceWorkerContainer.register is first called.)</summary>
  ReadOnly Property [active] As String
  '''<summary>Returns the instance of NavigationPreloadManager associated with the current service worker registration.</summary>
  ReadOnly Property [navigationPreload] As Dynamic
  '''<summary>Returns a reference to the PushManager interface for managing push subscriptions including subscribing, getting an active subscription, and accessing push permission status.</summary>
  ReadOnly Property [pushManager] As Dynamic
  '''<summary>An EventListener property called whenever an event of type updatefound is fired; it is fired any time the ServiceWorkerRegistration.installing property acquires a new service worker.</summary>
  Property [onupdatefound] As EventListener
  '''<summary>Returns a Promise that resolves to an array of Notification objects.</summary>
  Function [getNotifications]([paroptions] As Dynamic) As Dynamic
  '''<summary>Displays the notification with the requested title.</summary>
  Function [showNotification]([partitle] As Dynamic, [paroptions] As Dynamic) As Dynamic
  '''<summary>Checks the server for an updated version of the service worker without consulting caches.</summary>
  Function [update]() As Integer
  '''<summary>Unregisters the service worker registration and returns a Promise. The service worker will finish any ongoing operations before it is unregistered.</summary>
  Function [unregister]() As Dynamic
End Interface