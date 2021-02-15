'''<summary>The WorkerLocation interface defines the absolute location of the script executed by the Worker. Such an object is initialized for each worker and is available via the WorkerGlobalScope.location property obtained by calling self.location.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WorkerLocation]
  '''<summary>Is a stringifier that returns a DOMString containing the whole URL of the script executed in the Worker.</summary>
  ReadOnly Property [href] As String
  '''<summary>Is a DOMString containing the protocol scheme of the URL of the script executed in the Worker, including the final ':'.</summary>
  ReadOnly Property [protocol] As String
  '''<summary>Is a DOMString containing the host, that is the hostname, a ':', and the port of the URL of the script executed in the Worker.</summary>
  ReadOnly Property [host] As String
  '''<summary>Is a DOMString containing the domain of the URL of the script executed in the Worker.</summary>
  ReadOnly Property [hostname] As String
  '''<summary>Returns a DOMString containing the canonical form of the origin of the specific location.</summary>
  ReadOnly Property [origin] As String
  '''<summary>Is a DOMString containing the port number of the URL of the script executed in the Worker.</summary>
  ReadOnly Property [port] As String
  '''<summary>Is a DOMString containing an initial '/' followed by the path of the URL of the script executed in the Worker.</summary>
  ReadOnly Property [pathname] As String
  '''<summary>Is a DOMString containing a '?' followed by the parameters of the URL of the script executed in the Worker.</summary>
  ReadOnly Property [search] As String
  '''<summary>Is a DOMString containing a '#' followed by the fragment identifier of the URL of the script executed in the Worker.</summary>
  ReadOnly Property [hash] As String
End Interface