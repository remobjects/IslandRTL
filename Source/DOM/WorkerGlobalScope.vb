'''<summary>The WorkerGlobalScope interface of the Web Workers API is an interface representing the scope of any worker. Workers have no browsing context; this scope contains the information usually conveyed by Window objects — in this case event handlers, the console or the associated WorkerNavigator object. Each WorkerGlobalScope has its own event loop.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WorkerGlobalScope]
  '''<summary>Returns the WorkerLocation associated with the worker. It is a specific location object, mostly a subset of the Location for browsing scopes, but adapted to workers.</summary>
  ReadOnly Property [location] As Dynamic
  '''<summary>Returns the CacheStorage object associated with the current context. This object enables functionality such as storing assets for offline use, and generating custom responses to requests.</summary>
  ReadOnly Property [caches] As Dynamic
  '''<summary>Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object.</summary>
  ReadOnly Property [indexedDB] As Dynamic
  '''<summary>Returns a boolean indicating whether the current context is secure (true) or not (false).</summary>
  ReadOnly Property [isSecureContext] As Boolean
  '''<summary>Returns the global object's origin, serialized as a string. (This does not yet appear to be implemented in any browser.)</summary>
  ReadOnly Property [origin] As String
  '''<summary>Imports one or more scripts into the worker's scope. You can specify as many as you'd like, separated by commas. For example: importScripts('foo.js', 'bar.js');</summary>
  Function [importScripts]() As Dynamic
  '''<summary>Decodes a string of data which has been encoded using base-64 encoding.</summary>
  Function [atob]([parencodedData] As Dynamic) As String
  '''<summary>Creates a base-64 encoded ASCII string from a string of binary data.</summary>
  Function [btoa]([parstringToEncode] As Dynamic) As String
  '''<summary>Cancels the repeated execution set using WindowOrWorkerGlobalScope.setInterval().</summary>
  Function [clearInterval]([parintervalID] As Dynamic) As Dynamic
  '''<summary>Cancels the delayed execution set using WindowOrWorkerGlobalScope.setTimeout().</summary>
  Function [clearTimeout]([partimeoutID] As Dynamic) As Dynamic
  '''<summary>Accepts a variety of different image sources, and returns a Promise which resolves to an ImageBitmap. Optionally the source is cropped to the rectangle of pixels originating at (sx, sy) with width sw, and height sh.</summary>
  Function [createImageBitmap]([parimage] As Dynamic, [parsx] As Dynamic, [parsy] As Dynamic, [parsw] As Dynamic, [parsh] As Dynamic, [paroptions] As Dynamic) As Integer
  '''<summary>Starts the process of fetching a resource from the network.</summary>
  Function [fetch]([parresource] As Dynamic, [parinit] As Dynamic, [parmethod] As Dynamic, [parheaders] As Dynamic, [parbody] As Dynamic, [parmode] As Dynamic, [parcredentials] As Dynamic, [parcache] As Dynamic, [parredirect] As Dynamic, [parreferrer] As Dynamic, [parreferrerPolicy] As Dynamic, [parintegrity] As Dynamic, [parkeepalive] As Dynamic, [parsignal] As Dynamic) As Dynamic
  '''<summary>Schedules a function to execute every time a given number of milliseconds elapses.</summary>
  Function [setInterval]([parfunc] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, ParamArray args() As Dynamic) As Long
  '''<summary>Schedules a function to execute in a given amount of time.</summary>
  Function [setTimeout]([parfunction] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, [pararg1] As Dynamic) As Dynamic
  '''<summary>Discards any tasks queued in the WorkerGlobalScope's event loop, effectively closing this particular scope. In newer browser versions, close() is available on DedicatedWorkerGlobalScope and SharedWorkerGlobalScope instead. This change was made to stop close() being available on service workers, as it isn't supposed to be used there and always throws an exception when called (see bug 1336043).</summary>
  Function [close]() As Dynamic
End Interface