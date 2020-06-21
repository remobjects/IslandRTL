'''<Summary>The NavigationPreloadManager interface of the the Service Worker API provides methods for managing the preloading of resources with a service worker.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NavigationPreloadManager]
'Defined on this type 
  '''<Summary>Returns a Promise that resolves when navigation preloading is enabled.</Summary>
  Function [enable]() As Dynamic
  '''<Summary>Returns a Promise that resolves when navigation preloading is disabled.</Summary>
  Function [disable]() As Dynamic
  '''<Summary>Sets the value of the Service-Worker-Navigation-Preload header and returns an empty Promise.</Summary>
  Function [setHeaderValue]() As Dynamic
  '''<Summary>Returns a Promise that resolves to an object with properties indicating whether preload is enabled and the contents of the Service-Worker-Navigation-Preload.</Summary>
  Function [getState]() As Dynamic
End Interface