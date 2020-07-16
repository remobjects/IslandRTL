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
  '''<Summary>Imports one or more scripts into the worker's scope. You can specify as many as you'd like, separated by commas. For example: importScripts('foo.js', 'bar.js');</Summary>
  Function [importScripts]() As Dynamic
  '''<Summary>Decodes a string of data which has been encoded using base-64 encoding.</Summary>
  Function [atob]([parencodedData] As Dynamic) As String
  '''<Summary>Creates a base-64 encoded ASCII string from a string of binary data.</Summary>
  Function [btoa]([parstringToEncode] As Dynamic) As String
  '''<Summary>Cancels the repeated execution set using WindowOrWorkerGlobalScope.setInterval().</Summary>
  Function [clearInterval]([parintervalID] As Dynamic) As Dynamic
  '''<Summary>Cancels the delayed execution set using WindowOrWorkerGlobalScope.setTimeout().</Summary>
  Function [clearTimeout]([partimeoutID] As Dynamic) As Dynamic
  '''<Summary>Accepts a variety of different image sources, and returns a Promise which resolves to an ImageBitmap. Optionally the source is cropped to the rectangle of pixels originating at (sx, sy) with width sw, and height sh.</Summary>
  Function [createImageBitmap]([parimage] As Dynamic, [parsx] As Dynamic, [parsy] As Dynamic, [parsw] As Dynamic, [parsh] As Dynamic, [paroptions] As Dynamic) As Integer
  '''<Summary>Starts the process of fetching a resource from the network.</Summary>
  Function [fetch]([parresource] As Dynamic, [parinit] As Dynamic, [parmethod] As Dynamic, [parheaders] As Dynamic, [parbody] As Dynamic, [parmode] As Dynamic, [parcredentials] As Dynamic, [parcache] As Dynamic, [parredirect] As Dynamic, [parreferrer] As Dynamic, [parreferrerPolicy] As Dynamic, [parintegrity] As Dynamic, [parkeepalive] As Dynamic, [parsignal] As Dynamic) As Dynamic
  '''<Summary>Schedules a function to execute every time a given number of milliseconds elapses.</Summary>
  Function [setInterval]([parfunc] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, ParamArray args() As Dynamic) As Long
  '''<Summary>Schedules a function to execute in a given amount of time.</Summary>
  Function [setTimeout]([parfunction] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, [pararg1] As Dynamic) As Dynamic
  '''<Summary>Discards any tasks queued in the WorkerGlobalScope's event loop, effectively closing this particular scope. In newer browser versions, close() is available on DedicatedWorkerGlobalScope and SharedWorkerGlobalScope instead. This change was made to stop close() being available on service workers, as it isn't supposed to be used there and always throws an exception when called (see bug 1336043).</Summary>
  Function [close]() As Dynamic
End Interface