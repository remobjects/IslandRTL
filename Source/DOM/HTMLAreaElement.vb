'''<summary>The HTMLAreaElement interface provides special properties and methods (beyond those of the regular object HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of &lt;area> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLAreaElement]
Inherits HTMLElement

  '''<summary>Is a DOMString that reflects the alt HTML attribute, containing alternative text for the element.</summary>
  Property [alt] As String
  '''<summary>Is a DOMString that reflects the coords HTML attribute, containing coordinates to define the hot-spot region.</summary>
  Property [coords] As String
  '''<summary>Is a USVString containing the fragment identifier (including the leading hash mark (#)), if any, in the referenced URL.</summary>
  Property [hash] As String
  '''<summary>Is a USVString containing the hostname and port (if it's not the default port) in the referenced URL.</summary>
  Property [host] As String
  '''<summary>Is a USVString containing the hostname in the referenced URL.</summary>
  Property [hostname] As String
  '''<summary>Is a USVString containing that reflects the href HTML attribute, containing a valid URL of a linked resource.</summary>
  Property [href] As String
  '''<summary>Is a DOMString containing that reflects the hreflang HTML attribute, indicating the language of the linked resource.</summary>
  Property [hreflang] As String
  '''<summary>Is a DOMString containing that reflects the media HTML attribute, indicating target media of the linked resource.</summary>
  Property [media] As Dynamic
  '''<summary>Is a USVString containing the password specified before the domain name.</summary>
  Property [password] As String
  '''<summary>Returns a USVString containing the origin of the URL, that is its scheme, its domain and its port.</summary>
  ReadOnly Property [origin] As String
  '''<summary>Is a USVString containing the path name component, if any, of the referenced URL.</summary>
  Property [pathname] As String
  '''<summary>Is a USVString containing the port component, if any, of the referenced URL.</summary>
  Property [port] As String
  '''<summary>Is a USVString containing the protocol component (including trailing colon ':'), of the referenced URL.</summary>
  Property [protocol] As String
  '''<summary>Is a DOMString that reflects the rel HTML attribute, indicating relationships of the current document to the linked resource.</summary>
  Property [rel] As String
  '''<summary>Returns a DOMTokenList that reflects the rel HTML attribute, indicating relationships of the current document to the linked resource, as a list of tokens.</summary>
  ReadOnly Property [relList] As DOMTokenList
  '''<summary>Is a USVString containing the search element (including leading question mark '?'), if any, of the referenced URL.</summary>
  Property [search] As String
  '''<summary>Is a DOMString that reflects the shape HTML attribute, indicating the shape of the hot-spot, limited to known values.</summary>
  Property [shape] As String
  '''<summary>Is a DOMString that reflects the target HTML attribute, indicating the browsing context in which to open the linked resource.</summary>
  Property [target] As String
  '''<summary>Is a DOMString that reflects the type HTML attribute, indicating the MIME type of the linked resource.</summary>
  Property [type] As Dynamic
  '''<summary>Is a USVString containing the username specified before the domain name.</summary>
  Property [username] As String
  '''<summary>Returns a USVString containing the whole URL of the script executed in the Worker. It is a synonym for HTMLHyperlinkElementUtils.href.</summary>
  Function [toString]() As String
End Interface