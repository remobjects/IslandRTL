'''<Summary>The WorkerLocation interface defines the absolute location of the script executed by the Worker. Such an object is initialized for each worker and is available via the WorkerGlobalScope.location property obtained by calling self.location.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WorkerLocation]
  '''<Summary>Is a stringifier that returns a DOMString containing the whole URL of the script executed in the Worker.</Summary>
  ReadOnly Property [href] As String
  '''<Summary>Is a DOMString containing the protocol scheme of the URL of the script executed in the Worker, including the final ':'.</Summary>
  ReadOnly Property [protocol] As String
  '''<Summary>Is a DOMString containing the host, that is the hostname, a ':', and the port of the URL of the script executed in the Worker.</Summary>
  ReadOnly Property [host] As String
  '''<Summary>Is a DOMString containing the domain of the URL of the script executed in the Worker.</Summary>
  ReadOnly Property [hostname] As String
  '''<Summary>Returns a DOMString containing the canonical form of the origin of the specific location.</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>Is a DOMString containing the port number of the URL of the script executed in the Worker.</Summary>
  ReadOnly Property [port] As String
  '''<Summary>Is a DOMString containing an initial '/' followed by the path of the URL of the script executed in the Worker.</Summary>
  ReadOnly Property [pathname] As String
  '''<Summary>Is a DOMString containing a '?' followed by the parameters of the URL of the script executed in the Worker.</Summary>
  ReadOnly Property [search] As String
  '''<Summary>Is a DOMString containing a '#' followed by the fragment identifier of the URL of the script executed in the Worker.</Summary>
  ReadOnly Property [hash] As String
End Interface