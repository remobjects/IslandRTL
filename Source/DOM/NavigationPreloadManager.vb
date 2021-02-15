'''<summary>The NavigationPreloadManager interface of the the Service Worker API provides methods for managing the preloading of resources with a service worker.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigationPreloadManager]
  '''<summary>Returns a Promise that resolves when navigation preloading is enabled.</summary>
  Function [enable]() As Dynamic
  '''<summary>Returns a Promise that resolves when navigation preloading is disabled.</summary>
  Function [disable]() As Dynamic
  '''<summary>Sets the value of the Service-Worker-Navigation-Preload header and returns an empty Promise.</summary>
  Function [setHeaderValue]() As Dynamic
  '''<summary>Returns a Promise that resolves to an object with properties indicating whether preload is enabled and the contents of the Service-Worker-Navigation-Preload.</summary>
  Function [getState]() As Dynamic
End Interface