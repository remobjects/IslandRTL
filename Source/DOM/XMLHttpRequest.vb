'''<summary>XMLHttpRequest (XHR) objects are used to interact with servers. You can retrieve data from a URL without having to do a full page refresh. This enables a Web page to update just part of a page without disrupting what the user is doing.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XMLHttpRequest]
  '''<summary>Returns an ArrayBuffer, Blob, Document, JavaScript object, or a DOMString, depending on the value of XMLHttpRequest.responseType, that contains the response entity body.</summary>
  ReadOnly Property [response] As String
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
  '''<summary>Aborts the request if it has already been sent.</summary>
  Sub [abort]()
  '''<summary>Returns all the response headers, separated by CRLF, as a string, or null if no response has been received.</summary>
  Function [getAllResponseHeaders]() As String
  '''<summary>Returns the string containing the text of the specified header, or null if either the response has not yet been received or the header doesn't exist in the response.</summary>
  Function [getResponseHeader]([parheaderName] As Dynamic) As String
  '''<summary>Overrides the MIME type returned by the server.</summary>
  Function [overrideMimeType]([parmimeType] As Dynamic) As String
  '''<summary>Sends the request. If the request is asynchronous (which is the default), this method returns as soon as the request is sent.</summary>
  Sub [send]([parbody] As Dynamic)
  '''<summary>Sets the value of an HTTP request header. You must call setRequestHeader()after open(), but before send().</summary>
  Sub [setRequestHeader]([parheader] As Dynamic, [parvalue] As Dynamic)
  '''<summary>Initializes the object for use from C++ code. Warning: This method must not be called from JavaScript. </summary>
  Function [init]() As Dynamic
End Interface