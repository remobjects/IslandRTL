﻿'''<Summary>The Worker interface of the Web Workers API represents a background task that can be created via script, which can send messages back to its creator.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Worker]
Inherits EventTarget, AbstractWorker

  '''<Summary>An EventListener called whenever a MessageEvent of type message bubbles through the worker — i.e. when a message is sent to the parent document from the worker via DedicatedWorkerGlobalScope.postMessage. The message is stored in the event's data property.</Summary>
  Property [onmessage] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the messageerror event is raised.</Summary>
  Property [onmessageerror] As EventListener
  '''<Summary>Immediately terminates the worker. This does not let worker finish its operations; it is halted at once. ServiceWorker instances do not support this method.</Summary>
  Function [terminate]() As ServiceWorker
End Interface