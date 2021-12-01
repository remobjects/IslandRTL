'''<summary>XMLHttpRequest (XHR) objects are used to interact with servers. You can retrieve data from a URL without having to do a full page refresh. This enables a Web page to update just part of a page without disrupting what the user is doing.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XMLHttpRequest]
  Inherits [EventTarget]
  '''<summary>Returns an ArrayBuffer, Blob, Document, JavaScript object, or a DOMString, depending on the value of XMLHttpRequest.responseType, that contains the response entity body.</summary>
  ReadOnly Property [response] As Dynamic
  '''<summary>Returns a DOMString that contains the response to the request as text, or null if the request was unsuccessful or has not yet been sent.</summary>
  ReadOnly Property [responseText] As String
  Property responseType As Integer
  '''<summary>Is a nsIChannel. The channel used by the object when performing the request.</summary>
  ReadOnly Property [channel] As Dynamic
  '''<summary>Is a boolean. If true, the request will be sent without cookie and authentication headers.</summary>
  ReadOnly Property [mozAnon] As Boolean
  '''<summary>Is a boolean. If true, the same origin policy will not be enforced on the request.</summary>
  ReadOnly Property [mozSystem] As Boolean
  '''<summary>Is a boolean. It indicates whether or not the object represents a background service request.</summary>
  Property [mozBackgroundRequest] As Boolean
  '''<summary>This Gecko-only feature, a boolean, was removed in Firefox/Gecko 22. Please use Server-Sent Events, Web Sockets, or responseText from progress events instead.</summary>
  Property [multipart] As Boolean
  '''<summary>Returns an unsigned short, the state of the request.</summary>
  ReadOnly Property [readyState] As Byte
  '''<summary>Returns the serialized URL of the response or the empty string if the URL is null.</summary>
  ReadOnly Property [responseURL] As String
  '''<summary>Returns a Document containing the response to the request, or null if the request was unsuccessful, has not yet been sent, or cannot be parsed as XML or HTML. Not available in workers.</summary>
  ReadOnly Property [responseXML] As Document
  '''<summary>Returns an unsigned short with the status of the response of the request.</summary>
  ReadOnly Property [status] As Integer
  '''<summary>Returns a DOMString containing the response string returned by the HTTP server. Unlike XMLHttpRequest.status, this includes the entire text of the response message ("200 OK", for example).</summary>
  ReadOnly Property [statusText] As String
  '''<summary>Is an unsigned long representing the number of milliseconds a request can take before automatically being terminated.</summary>
  Property timeout As Integer
  '''<summary>Is an XMLHttpRequestUpload, representing the upload process.</summary>
  Property upload As Dynamic
  '''<summary>Is a Boolean that indicates whether or not cross-site Access-Control requests should be made using credentials such as cookies or authorization headers.</summary>
  Property withCredentials As Boolean

  '''<summary>An EventHandler that is called whenever the readyState attribute changes.</summary>
  Property onreadystatechange As WebAssemblyDelegate
  '''<summary>Fired when a request has been aborted, for example because the program called XMLHttpRequest.abort().</summary>
  Property onabort As WebAssemblyDelegate
  '''<summary>Fired when the request encountered an error.</summary>
  Property onerror As WebAssemblyDelegate
  '''<summary>Fired when an XMLHttpRequest transaction completes successfully.</summary>
  Property onload As WebAssemblyDelegate
  '''<summary>Fired when a request has completed, whether successfully (after load) or unsuccessfully (after abort or error).</summary>
  Property onloadend As WebAssemblyDelegate
  '''<summary>Fired when a request has started to load data.</summary>
  Property onloadstart As WebAssemblyDelegate
  '''<summary>Fired periodically when a request receives more data.</summary>
  Property onprogress As WebAssemblyDelegate
  '''<summary>Fired when progress is terminated due to preset time expiring.</summary>
  Property ontimeout As WebAssemblyDelegate

  '''<summary>Aborts the request if it has already been sent.</summary>
  Sub [abort]()
  '''<summary>Returns all the response headers, separated by CRLF, as a string, or null if no response has been received.</summary>
  Function [getAllResponseHeaders]() As String
  '''<summary>Returns the string containing the text of the specified header, or null if either the response has not yet been received or the header doesn't exist in the response.</summary>
  Function [getResponseHeader]([parheaderName] As Dynamic) As String
  Sub [open](method As String, url As String, Optional [Async] As Boolean, Optional user As String, Optional password As String)
  '''<summary>Overrides the MIME type returned by the server.</summary>
  Function [overrideMimeType]([parmimeType] As Dynamic) As String
  '''<summary>Sends the request. If the request is asynchronous (which is the default), this method returns as soon as the request is sent.</summary>
  Sub [send](Optional [parbody] As Dynamic)
  '''<summary>Sets the value of an HTTP request header. You must call setRequestHeader()after open(), but before send().</summary>
  Sub [setRequestHeader]([parheader] As Dynamic, [parvalue] As Dynamic)
  '''<summary>Initializes the object for use from C++ code. Warning: This method must not be called from JavaScript. </summary>
  Function [init]() As Dynamic
End Interface