'''<summary>The Request interface of the Fetch API represents a resource request.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Request]
  '''<summary>Contains the cache mode of the request (e.g., default, reload, no-cache).</summary>
  ReadOnly Property [cache] As Dynamic
  '''<summary>Contains the credentials of the request (e.g., omit, same-origin, include). The default is same-origin.</summary>
  ReadOnly Property [credentials] As Dynamic
  '''<summary>Returns a string from the RequestDestination enum describing the request's destination. This is a string indicating the type of content being requested.</summary>
  ReadOnly Property [destination] As String
  '''<summary>Contains the associated Headers object of the request.</summary>
  ReadOnly Property [headers] As Dynamic
  '''<summary>Contains the subresource integrity value of the request (e.g., sha256-BpfBw7ivV8q2jLiT13fxDYAe2tJllusRSZ273h2nFSE=).</summary>
  ReadOnly Property [integrity] As String
  '''<summary>Contains the request's method (GET, POST, etc.)</summary>
  ReadOnly Property [method] As Dynamic
  '''<summary>Contains the mode of the request (e.g., cors, no-cors, same-origin, navigate.)</summary>
  ReadOnly Property [mode] As Dynamic
  '''<summary>Contains the mode for how redirects are handled. It may be one of follow, error, or manual.</summary>
  ReadOnly Property [redirect] As String
  '''<summary>Contains the referrer of the request (e.g., client).</summary>
  ReadOnly Property [referrer] As Dynamic
  '''<summary>Contains the referrer policy of the request (e.g., no-referrer).</summary>
  ReadOnly Property [referrerPolicy] As Dynamic
  '''<summary>Contains the URL of the request.</summary>
  ReadOnly Property [url] As String
  '''<summary>Stores a Boolean that declares whether the body has been used in a response yet.</summary>
  ReadOnly Property [bodyUsed] As Boolean
  '''<summary>Creates a copy of the current Request object.</summary>
  Function [clone]() As Request
  '''<summary>Returns a promise that resolves with an ArrayBuffer representation of the request body.</summary>
  Function [arrayBuffer]() As Byte()
  '''<summary>Returns a promise that resolves with a Blob representation of the request body.</summary>
  Function [blob]() As Byte()
  '''<summary>Returns a promise that resolves with a FormData representation of the request body.</summary>
  Function [formData]() As Dynamic
  '''<summary>Returns a promise that resolves with a JSON representation of the request body.</summary>
  Function [json]() As Dynamic
  '''<summary>Returns a promise that resolves with an USVString (text) representation of the request body.</summary>
  Function [text]() As String
End Interface