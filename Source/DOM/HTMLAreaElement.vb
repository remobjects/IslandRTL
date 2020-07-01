'''<Summary>The HTMLAreaElement interface provides special properties and methods (beyond those of the regular object HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of &lt;area> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLAreaElement]
Inherits HTMLElement

  '''<Summary>Is a DOMString that reflects the alt HTML attribute, containing alternative text for the element.</Summary>
  Property [alt] As String
  '''<Summary>Is a DOMString that reflects the coords HTML attribute, containing coordinates to define the hot-spot region.</Summary>
  Property [coords] As String
  '''<Summary>Is a USVString containing the fragment identifier (including the leading hash mark (#)), if any, in the referenced URL.</Summary>
  Property [hash] As String
  '''<Summary>Is a USVString containing the hostname and port (if it's not the default port) in the referenced URL.</Summary>
  Property [host] As String
  '''<Summary>Is a USVString containing the hostname in the referenced URL.</Summary>
  Property [hostname] As String
  '''<Summary>Is a USVString containing that reflects the href HTML attribute, containing a valid URL of a linked resource.</Summary>
  Property [href] As String
  '''<Summary>Is a DOMString containing that reflects the hreflang HTML attribute, indicating the language of the linked resource.</Summary>
  Property [hreflang] As String
  '''<Summary>Is a DOMString containing that reflects the media HTML attribute, indicating target media of the linked resource.</Summary>
  Property [media] As Dynamic
  '''<Summary>Is a USVString containing the password specified before the domain name.</Summary>
  Property [password] As String
  '''<Summary>Returns a USVString containing the origin of the URL, that is its scheme, its domain and its port.</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>Is a USVString containing the path name component, if any, of the referenced URL.</Summary>
  Property [pathname] As String
  '''<Summary>Is a USVString containing the port component, if any, of the referenced URL.</Summary>
  Property [port] As String
  '''<Summary>Is a USVString containing the protocol component (including trailing colon ':'), of the referenced URL.</Summary>
  Property [protocol] As String
  '''<Summary>Is a DOMString that reflects the rel HTML attribute, indicating relationships of the current document to the linked resource.</Summary>
  Property [rel] As String
  '''<Summary>Returns a DOMTokenList that reflects the rel HTML attribute, indicating relationships of the current document to the linked resource, as a list of tokens.</Summary>
  ReadOnly Property [relList] As DOMTokenList
  '''<Summary>Is a USVString containing the search element (including leading question mark '?'), if any, of the referenced URL.</Summary>
  Property [search] As String
  '''<Summary>Is a DOMString that reflects the shape HTML attribute, indicating the shape of the hot-spot, limited to known values.</Summary>
  Property [shape] As String
  '''<Summary>Is a DOMString that reflects the target HTML attribute, indicating the browsing context in which to open the linked resource.</Summary>
  Property [target] As String
  '''<Summary>Is a DOMString that reflects the type HTML attribute, indicating the MIME type of the linked resource.</Summary>
  Property [type] As Dynamic
  '''<Summary>Is a USVString containing the username specified before the domain name.</Summary>
  Property [username] As String
End Interface