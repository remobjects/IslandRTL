'''<Summary>The HTMLAnchorElement interface represents hyperlink elements and provides special properties and methods (beyond those of the regular HTMLElement object interface that they inherit from) for manipulating the layout and presentation of such elements. This interface corresponds to &lt;a> element; not to be confused with &lt;link>, which is represented by HTMLLinkElement)</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLAnchorElement]
Inherits HTMLElement

  '''<Summary>Is a USVString representing the fragment identifier, including the leading hash mark ('#'), if any, in the referenced URL.</Summary>
  Property [hash] As String
  '''<Summary>Is a USVString representing the hostname and port (if it's not the default port) in the referenced URL.</Summary>
  Property [host] As String
  '''<Summary>Is a USVString representing the hostname in the referenced URL.</Summary>
  Property [hostname] As String
  '''<Summary>Is a USVString that is the result of parsing the href HTML attribute relative to the document, containing a valid URL of a linked resource.</Summary>
  Property [href] As String
  '''<Summary>Is a DOMString that reflects the hreflang HTML attribute, indicating the language of the linked resource.</Summary>
  Property [hreflang] As String
  '''<Summary>Is a DOMString that reflects the media HTML attribute, indicating the intended media for the linked resource.</Summary>
  Property [media] As Dynamic
  '''<Summary>Is a USVString containing the password specified before the domain name.</Summary>
  Property [password] As String
  '''<Summary>Returns a USVString containing the origin of the URL, that is its scheme, its domain and its port.</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>Is a USVString representing the path name component, if any, of the referenced URL.</Summary>
  Property [pathname] As String
  '''<Summary>Is a USVString representing the port component, if any, of the referenced URL.</Summary>
  Property [port] As String
  '''<Summary>Is a USVString representing the protocol component, including trailing colon (':'), of the referenced URL.</Summary>
  Property [protocol] As String
  '''<Summary>Is a DOMString that reflects the rel HTML attribute, specifying the relationship of the target object to the linked object.</Summary>
  Property [rel] As String
  '''<Summary>Returns a DOMTokenList that reflects the rel HTML attribute, as a list of tokens.</Summary>
  ReadOnly Property [relList] As DOMTokenList
  '''<Summary>Is a USVString representing the search element, including leading question mark ('?'), if any, of the referenced URL.</Summary>
  Property [search] As String
  '''<Summary>Is a DOMString that reflects the target HTML attribute, indicating where to display the linked resource.</Summary>
  Property [target] As String
  '''<Summary>Is a DOMString being a synonym for the Node.textContent property.</Summary>
  Property [text] As String
  '''<Summary>Is a DOMString that reflects the type HTML attribute, indicating the MIME type of the linked resource.</Summary>
  Property [type] As Dynamic
  '''<Summary>Is a USVString containing the username specified before the domain name.</Summary>
  Property [username] As String
  '''<Summary>Removes the keyboard focus from the current element.</Summary>
  Sub [blur]()
  '''<Summary>Returns a USVString containing the whole URL. It is a synonym for HTMLHyperlinkElementUtils.href, though it can't be used to modify the value.</Summary>
  Function [toString]() As String
End Interface