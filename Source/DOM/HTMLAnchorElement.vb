'''<summary>The HTMLAnchorElement interface represents hyperlink elements and provides special properties and methods (beyond those of the regular HTMLElement object interface that they inherit from) for manipulating the layout and presentation of such elements. This interface corresponds to &lt;a> element; not to be confused with &lt;link>, which is represented by HTMLLinkElement)</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLAnchorElement]
Inherits HTMLElement

  '''<summary>Is a USVString representing the fragment identifier, including the leading hash mark ('#'), if any, in the referenced URL.</summary>
  Property [hash] As String
  '''<summary>Is a USVString representing the hostname and port (if it's not the default port) in the referenced URL.</summary>
  Property [host] As String
  '''<summary>Is a USVString representing the hostname in the referenced URL.</summary>
  Property [hostname] As String
  '''<summary>Is a USVString that is the result of parsing the href HTML attribute relative to the document, containing a valid URL of a linked resource.</summary>
  Property [href] As String
  '''<summary>Is a DOMString that reflects the hreflang HTML attribute, indicating the language of the linked resource.</summary>
  Property [hreflang] As String
  '''<summary>Is a DOMString that reflects the media HTML attribute, indicating the intended media for the linked resource.</summary>
  Property [media] As Dynamic
  '''<summary>Is a USVString containing the password specified before the domain name.</summary>
  Property [password] As String
  '''<summary>Returns a USVString containing the origin of the URL, that is its scheme, its domain and its port.</summary>
  ReadOnly Property [origin] As String
  '''<summary>Is a USVString representing the path name component, if any, of the referenced URL.</summary>
  Property [pathname] As String
  '''<summary>Is a USVString representing the port component, if any, of the referenced URL.</summary>
  Property [port] As String
  '''<summary>Is a USVString representing the protocol component, including trailing colon (':'), of the referenced URL.</summary>
  Property [protocol] As String
  '''<summary>Is a DOMString that reflects the rel HTML attribute, specifying the relationship of the target object to the linked object.</summary>
  Property [rel] As String
  '''<summary>Returns a DOMTokenList that reflects the rel HTML attribute, as a list of tokens.</summary>
  ReadOnly Property [relList] As DOMTokenList
  '''<summary>Is a USVString representing the search element, including leading question mark ('?'), if any, of the referenced URL.</summary>
  Property [search] As String
  '''<summary>Is a DOMString that reflects the target HTML attribute, indicating where to display the linked resource.</summary>
  Property [target] As String
  '''<summary>Is a DOMString being a synonym for the Node.textContent property.</summary>
  Property [text] As String
  '''<summary>Is a DOMString that reflects the type HTML attribute, indicating the MIME type of the linked resource.</summary>
  Property [type] As Dynamic
  '''<summary>Is a USVString containing the username specified before the domain name.</summary>
  Property [username] As String
  '''<summary>Removes the keyboard focus from the current element.</summary>
  Sub [blur]()
  '''<summary>Returns a USVString containing the whole URL. It is a synonym for HTMLHyperlinkElementUtils.href, though it can't be used to modify the value.</summary>
  Function [toString]() As String
End Interface