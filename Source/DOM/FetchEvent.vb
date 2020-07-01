'''<Summary>This is the event type for fetch events dispatched on the service worker global scope. It contains information about the fetch, including the request and how the receiver will treat the response. It provides the event.respondWith() method, which allows us to provide a response to this fetch.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FetchEvent]
Inherits [Event]

End Interface