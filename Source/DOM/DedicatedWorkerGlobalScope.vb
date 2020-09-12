'''<Summary>The DedicatedWorkerGlobalScope object (the Worker global scope) is accessible through the self keyword. Some additional global functions, namespaces objects, and constructors, not typically associated with the worker global scope, but available on it, are listed in the JavaScript Reference. See also: Functions available to workers.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DedicatedWorkerGlobalScope]
  '''<Summary>The name that the Worker was (optionally) given when it was created using the Worker() constructor. This is mainly useful for debugging purposes.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>Is an EventHandler representing the code to be called when the message event is raised. These events are of type MessageEvent and will be called when the worker receives a message from the document that started it (i.e. from the Worker.postMessage method.)</Summary>
  Property [onmessage] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the messageerror event is raised.</Summary>
  Property [onmessageerror] As EventListener
  '''<Summary>Discards any tasks queued in the WorkerGlobalScope's event loop, effectively closing this particular scope.</Summary>
  Function [close]() As [Event]
  '''<Summary>Sends a message — which can consist of any JavaScript object — to the parent document that first spawned the worker.</Summary>
  Function [postMessage]([paraMessage] As Dynamic, [partransferList] As Dynamic) As Document
  '''<Summary>Imports one or more scripts into the worker's scope. You can specify as many as you'd like, separated by commas. For example: importScripts('foo.js', 'bar.js');</Summary>
  Function [importScripts]() As Dynamic
  '''<Summary>Decodes a string of data which has been encoded using base-64 encoding.</Summary>
  Function [atob]([parencodedData] As Dynamic) As String
  '''<Summary>Creates a base-64 encoded ASCII string from a string of binary data.</Summary>
  Function [btoa]([parstringToEncode] As Dynamic) As String
  '''<Summary>Cancels the repeated execution set using WindowTimers.setInterval().</Summary>
  Sub [clearInterval]([parintervalID] As Dynamic)
  '''<Summary>Schedules the execution of a function every X milliseconds.</Summary>
  Function [setInterval]([parfunc] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, ParamArray args() As Dynamic) As Integer
  '''<Summary>Sets a delay for executing a function.</Summary>
  Function [setTimeout]([parfunction] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, [pararg1] As Dynamic) As Integer
End Interface