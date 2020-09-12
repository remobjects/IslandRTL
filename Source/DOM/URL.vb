'''<Summary>The URL interface is used to parse, construct, normalize, and encode URLs. It works by providing properties which allow you to easily read and modify the components of a URL.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [URL]
  '''<Summary>A USVString containing a '#' followed by the fragment identifier of the URL.</Summary>
  Property [hash] As String
  '''<Summary>A USVString containing the domain (that is the hostname) followed by (if a port was specified) a ':' and the port of the URL.</Summary>
  Property [host] As String
  '''<Summary>A USVString containing the domain of the URL.</Summary>
  Property [hostname] As String
  '''<Summary>A stringifier that returns a USVString containing the whole URL.</Summary>
  Property [href] As String
  '''<Summary>Returns a USVString containing the origin of the URL, that is its scheme, its domain and its port.</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>A USVString containing the password specified before the domain name.</Summary>
  Property [password] As String
  '''<Summary>A USVString containing an initial '/' followed by the path of the URL.</Summary>
  Property [pathname] As String
  '''<Summary>A USVString containing the port number of the URL.</Summary>
  Property [port] As String
  '''<Summary>A USVString containing the protocol scheme of the URL, including the final ':'.</Summary>
  Property [protocol] As String
  '''<Summary>A USVString indicating the URL's parameter string; if any parameters are provided, this string includes all of them, beginning with the leading '?' character.</Summary>
  Property [search] As String
  '''<Summary>A URLSearchParams object which can be used to access the individual query parameters found in search.</Summary>
  ReadOnly Property [searchParams] As URLSearchParams
  '''<Summary>A USVString containing the username specified before the domain name.</Summary>
  Property [username] As String
  '''<Summary>Returns a USVString containing the whole URL. It is a synonym for URL.href, though it can't be used to modify the value.</Summary>
  Function [toString]() As String
  '''<Summary>Returns a USVString  containing the whole URL. It returns the same string as the href property.</Summary>
  Function [toJSON]() As String
End Interface