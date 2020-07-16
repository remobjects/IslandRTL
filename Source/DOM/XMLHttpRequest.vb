'''<Summary>XMLHttpRequest (XHR) objects are used to interact with servers. You can retrieve data from a URL without having to do a full page refresh. This enables a Web page to update just part of a page without disrupting what the user is doing.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XMLHttpRequest]
  '''<Summary>Returns an ArrayBuffer, Blob, Document, JavaScript object, or a DOMString, depending on the value of XMLHttpRequest.responseType, that contains the response entity body.</Summary>
  ReadOnly Property [response] As String
  '''<Summary>Is a nsIChannel. The channel used by the object when performing the request.</Summary>
  ReadOnly Property [channel] As Dynamic
  '''<Summary>Is a boolean. If true, the request will be sent without cookie and authentication headers.</Summary>
  ReadOnly Property [mozAnon] As Boolean
  '''<Summary>Is a boolean. If true, the same origin policy will not be enforced on the request.</Summary>
  ReadOnly Property [mozSystem] As Boolean
  '''<Summary>Is a boolean. It indicates whether or not the object represents a background service request.</Summary>
  Property [mozBackgroundRequest] As Boolean
  '''<Summary>This Gecko-only feature, a boolean, was removed in Firefox/Gecko 22. Please use Server-Sent Events, Web Sockets, or responseText from progress events instead.</Summary>
  Property [multipart] As Boolean
  '''<Summary>Aborts the request if it has already been sent.</Summary>
  Sub [abort]()
  '''<Summary>Returns all the response headers, separated by CRLF, as a string, or null if no response has been received.</Summary>
  Function [getAllResponseHeaders]() As String
  '''<Summary>Returns the string containing the text of the specified header, or null if either the response has not yet been received or the header doesn't exist in the response.</Summary>
  Function [getResponseHeader]([parheaderName] As Dynamic) As String
  '''<Summary>Overrides the MIME type returned by the server.</Summary>
  Function [overrideMimeType]([parmimeType] As Dynamic) As String
  '''<Summary>Sends the request. If the request is asynchronous (which is the default), this method returns as soon as the request is sent.</Summary>
  Sub [send]([parbody] As Dynamic)
  '''<Summary>Sets the value of an HTTP request header. You must call setRequestHeader()after open(), but before send().</Summary>
  Sub [setRequestHeader]([parheader] As Dynamic, [parvalue] As Dynamic)
  '''<Summary>Initializes the object for use from C++ code. Warning: This method must not be called from JavaScript. </Summary>
  Function [init]() As Dynamic
End Interface