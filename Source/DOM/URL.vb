'''<summary>The URL interface is used to parse, construct, normalize, and encode URLs. It works by providing properties which allow you to easily read and modify the components of a URL.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [URL]
  '''<summary>A USVString containing a '#' followed by the fragment identifier of the URL.</summary>
  Property [hash] As String
  '''<summary>A USVString containing the domain (that is the hostname) followed by (if a port was specified) a ':' and the port of the URL.</summary>
  Property [host] As String
  '''<summary>A USVString containing the domain of the URL.</summary>
  Property [hostname] As String
  '''<summary>A stringifier that returns a USVString containing the whole URL.</summary>
  Property [href] As String
  '''<summary>Returns a USVString containing the origin of the URL, that is its scheme, its domain and its port.</summary>
  ReadOnly Property [origin] As String
  '''<summary>A USVString containing the password specified before the domain name.</summary>
  Property [password] As String
  '''<summary>A USVString containing an initial '/' followed by the path of the URL.</summary>
  Property [pathname] As String
  '''<summary>A USVString containing the port number of the URL.</summary>
  Property [port] As String
  '''<summary>A USVString containing the protocol scheme of the URL, including the final ':'.</summary>
  Property [protocol] As String
  '''<summary>A USVString indicating the URL's parameter string; if any parameters are provided, this string includes all of them, beginning with the leading '?' character.</summary>
  Property [search] As String
  '''<summary>A URLSearchParams object which can be used to access the individual query parameters found in search.</summary>
  ReadOnly Property [searchParams] As Dynamic
  '''<summary>A USVString containing the username specified before the domain name.</summary>
  Property [username] As String
  '''<summary>Returns a USVString containing the whole URL. It is a synonym for URL.href, though it can't be used to modify the value.</summary>
  Function [toString]() As String
  '''<summary>Returns a USVString  containing the whole URL. It returns the same string as the href property.</summary>
  Function [toJSON]() As String
End Interface