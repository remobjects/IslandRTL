'''<Summary>The WorkerGlobalScope interface of the Web Workers API is an interface representing the scope of any worker. Workers have no browsing context; this scope contains the information usually conveyed by Window objects — in this case event handlers, the console or the associated WorkerNavigator object. Each WorkerGlobalScope has its own event loop.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WorkerGlobalScope]
  '''<Summary>Returns the WorkerLocation associated with the worker. It is a specific location object, mostly a subset of the Location for browsing scopes, but adapted to workers.</Summary>
  ReadOnly Property [location] As Dynamic
  '''<Summary>Returns the CacheStorage object associated with the current context. This object enables functionality such as storing assets for offline use, and generating custom responses to requests.</Summary>
  ReadOnly Property [caches] As Dynamic
  '''<Summary>Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object.</Summary>
  ReadOnly Property [indexedDB] As Dynamic
  '''<Summary>Returns a boolean indicating whether the current context is secure (true) or not (false).</Summary>
  ReadOnly Property [isSecureContext] As Boolean
  '''<Summary>Returns the global object's origin, serialized as a string. (This does not yet appear to be implemented in any browser.)</Summary>
  ReadOnly Property [origin] As String
End Interface