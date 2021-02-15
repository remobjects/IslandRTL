'''<summary>The parameter passed into the oninstall handler, the InstallEvent interface represents an install action that is dispatched on the ServiceWorkerGlobalScope of a ServiceWorker. As a child of ExtendableEvent, it ensures that functional events such as FetchEvent are not dispatched during installation. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [InstallEvent]
Inherits [Event]

  '''<summary>Returns the ServiceWorker that is currently controlling the page.</summary>
  ReadOnly Property [activeWorker] As ServiceWorker
End Interface