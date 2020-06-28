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
End Interface