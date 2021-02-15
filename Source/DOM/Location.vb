'''<summary>The Location interface represents the location (URL) of the object it is linked to. Changes done on it are reflected on the object it relates to. Both the Document and Window interface have such a linked Location, accessible via Document.location and Window.location respectively.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Location]
  '''<summary>Is a static DOMStringList containing, in reverse order, the origins of all ancestor browsing contexts of the document associated with the given Location object.</summary>
  Property [ancestorOrigins] As String
  '''<summary>Is a stringifier that returns a USVString containing the entire URL. If changed, the associated document navigates to the new page. It can be set from a different origin than the associated document.</summary>
  Property [href] As String
  '''<summary>Is a USVString containing the protocol scheme of the URL, including the final ':'.</summary>
  Property [protocol] As String
  '''<summary>Is a USVString containing the host, that is the hostname, a ':', and the port of the URL.</summary>
  Property [host] As String
  '''<summary>Is a USVString containing the domain of the URL.</summary>
  Property [hostname] As String
  '''<summary>Is a USVString containing the port number of the URL.</summary>
  Property [port] As String
  '''<summary>Is a USVString containing an initial '/' followed by the path of the URL.</summary>
  Property [pathname] As String
  '''<summary>Is a USVString containing a '?' followed by the parameters or "querystring" of the URL. Modern browsers provide URLSearchParams and URL.searchParams to make it easy to parse out the parameters from the querystring.</summary>
  Property [search] As String
  '''<summary>Is a USVString containing a '#' followed by the fragment identifier of the URL.</summary>
  Property [hash] As String
  '''<summary>Returns a USVString containing the canonical form of the origin of the specific location.</summary>
  ReadOnly Property [origin] As String
  '''<summary>Loads the resource at the URL provided in parameter.</summary>
  Function [assign]([parurl] As Dynamic) As String
  '''<summary>Reloads the resource from the current URL. Its optional unique parameter is a Boolean, which, when it is true, causes the page to always be reloaded from the server. If it is false or not specified, the browser may reload the page from its cache.</summary>
  Function [reload]() As Boolean
  '''<summary>Returns a USVString containing the whole URL. It is a synonym for HTMLHyperlinkElementUtils.href, though it can't be used to modify the value.</summary>
  Function [toString]() As String
End Interface