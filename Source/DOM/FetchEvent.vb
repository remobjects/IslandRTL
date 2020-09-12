'''<Summary>This is the event type for fetch events dispatched on the service worker global scope. It contains information about the fetch, including the request and how the receiver will treat the response. It provides the event.respondWith() method, which allows us to provide a response to this fetch.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FetchEvent]
Inherits [Event]

  '''<Summary>Prevent the browser's default fetch handling, and provide (a promise for) a response yourself.</Summary>
  Function [respondWith]() As Dynamic
  '''<Summary> Extends the lifetime of the event. Used to notify the browser of tasks that extend beyond the returning of a response, such as streaming and caching. </Summary>
  Function [waitUntil]() As Dynamic
End Interface