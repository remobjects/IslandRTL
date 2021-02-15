'''<summary>The DedicatedWorkerGlobalScope object (the Worker global scope) is accessible through the self keyword. Some additional global functions, namespaces objects, and constructors, not typically associated with the worker global scope, but available on it, are listed in the JavaScript Reference. See also: Functions available to workers.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DedicatedWorkerGlobalScope]
  '''<summary>The name that the Worker was (optionally) given when it was created using the Worker() constructor. This is mainly useful for debugging purposes.</summary>
  ReadOnly Property [name] As String
  '''<summary>Is an EventHandler representing the code to be called when the message event is raised. These events are of type MessageEvent and will be called when the worker receives a message from the document that started it (i.e. from the Worker.postMessage method.)</summary>
  Property [onmessage] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the messageerror event is raised.</summary>
  Property [onmessageerror] As EventListener
  '''<summary>Sends a message — which can consist of any JavaScript object — to the parent document that first spawned the worker.</summary>
  Function [postMessage]([paraMessage] As Dynamic, [partransferList] As Dynamic) As Dynamic
  '''<summary>Imports one or more scripts into the worker's scope. You can specify as many as you'd like, separated by commas. For example: importScripts('foo.js', 'bar.js');</summary>
  Function [importScripts]() As Dynamic
  '''<summary>Decodes a string of data which has been encoded using base-64 encoding.</summary>
  Function [atob]([parencodedData] As Dynamic) As String
  '''<summary>Creates a base-64 encoded ASCII string from a string of binary data.</summary>
  Function [btoa]([parstringToEncode] As Dynamic) As String
  '''<summary>Cancels the repeated execution set using WindowTimers.setInterval().</summary>
  Function [clearInterval]([parintervalID] As Dynamic) As Dynamic
  '''<summary>Cancels the repeated execution set using WindowTimers.setTimeout().</summary>
  Function [clearTimeout]([partimeoutID] As Dynamic) As Dynamic
  '''<summary>Schedules the execution of a function every X milliseconds.</summary>
  Function [setInterval]([parfunc] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, ParamArray args() As Dynamic) As Long
  '''<summary>Sets a delay for executing a function.</summary>
  Function [setTimeout]([parfunction] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, [pararg1] As Dynamic) As Dynamic
End Interface