'''<summary>XMLHttpRequestEventTarget is the interface that describes the event handlers you can implement in an object that will handle events for an XMLHttpRequest.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XMLHttpRequestEventTarget]
  '''<summary>Contains the function to call when a request is aborted and the abort event is received by this object.</summary>
  Property [onabort] As Dynamic
  '''<summary>Contains the function to call when a request encounters an error and the error event is received by this object.</summary>
  Property [onerror] As Dynamic
  '''<summary>Contains the function to call when an HTTP request returns after successfully fetching content and the load event is received by this object.</summary>
  Property [onload] As Dynamic
  '''<summary>Contains the function that gets called when the HTTP request first begins loading data and the loadstart event is received by this object.</summary>
  Property [onloadstart] As Dynamic
  '''<summary>Contains the function that is called periodically with information about the progress of the request and the progress event is received by this object.</summary>
  Property [onprogress] As Dynamic
  '''<summary>Contains the function that is called if the event times out and the timeout event is received by this object; this only happens if a timeout has been previously established by setting the value of the XMLHttpRequest object's timeout attribute.</summary>
  Property [ontimeout] As Dynamic
  '''<summary>Contains the function that is called when the load is completed, even if the request failed, and the loadend event is received by this object.</summary>
  Property [onloadend] As Dynamic
End Interface