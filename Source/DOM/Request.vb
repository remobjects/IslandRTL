'''<Summary>The Request interface of the Fetch API represents a resource request.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Request]
  '''<Summary>Contains the cache mode of the request (e.g., default, reload, no-cache).</Summary>
  ReadOnly Property [cache] As Dynamic
  '''<Summary>Contains the credentials of the request (e.g., omit, same-origin, include). The default is same-origin.</Summary>
  ReadOnly Property [credentials] As Dynamic
  '''<Summary>Returns a string from the RequestDestination enum describing the request's destination. This is a string indicating the type of content being requested.</Summary>
  ReadOnly Property [destination] As String
  '''<Summary>Contains the subresource integrity value of the request (e.g., sha256-BpfBw7ivV8q2jLiT13fxDYAe2tJllusRSZ273h2nFSE=).</Summary>
  ReadOnly Property [integrity] As String
  '''<Summary>Contains the request's method (GET, POST, etc.)</Summary>
  ReadOnly Property [method] As String
  '''<Summary>Contains the mode of the request (e.g., cors, no-cors, same-origin, navigate.)</Summary>
  ReadOnly Property [mode] As String
  '''<Summary>Contains the mode for how redirects are handled. It may be one of follow, error, or manual.</Summary>
  ReadOnly Property [redirect] As String
  '''<Summary>Contains the referrer of the request (e.g., client).</Summary>
  ReadOnly Property [referrer] As String
  '''<Summary>Contains the referrer policy of the request (e.g., no-referrer).</Summary>
  ReadOnly Property [referrerPolicy] As String
  '''<Summary>Contains the URL of the request.</Summary>
  ReadOnly Property [url] As String
  '''<Summary>A simple getter used to expose a ReadableStream of the body contents.</Summary>
  ReadOnly Property [body] As ReadableStream
  '''<Summary>Stores a Boolean that declares whether the body has been used in a response yet.</Summary>
  ReadOnly Property [bodyUsed] As Boolean
  '''<Summary>Creates a copy of the current Request object.</Summary>
  Function [clone]() As Request
  '''<Summary>Returns a promise that resolves with an ArrayBuffer representation of the request body.</Summary>
  Function [arrayBuffer]() As Byte()
  '''<Summary>Returns a promise that resolves with a Blob representation of the request body.</Summary>
  Function [blob]() As Byte()
  '''<Summary>Returns a promise that resolves with a FormData representation of the request body.</Summary>
  Function [formData]() As FormData
  '''<Summary>Returns a promise that resolves with a JSON representation of the request body.</Summary>
  Function [json]() As Request
  '''<Summary>Returns a promise that resolves with an USVString (text) representation of the request body.</Summary>
  Function [text]() As String
End Interface