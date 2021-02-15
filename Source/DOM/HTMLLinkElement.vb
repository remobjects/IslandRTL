'''<summary>The HTMLLinkElement interface represents reference information for external resources and the relationship of those resources to a document and vice-versa (corresponds to &lt;link> element; not to be confused with &lt;a>, which is represented by HTMLAnchorElement). This object inherits all of the properties and methods of the HTMLElement interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLLinkElement]
Inherits HTMLElement, LinkStyle

  '''<summary>Is a DOMString representing the type of content being loaded by the HTML link.</summary>
  Property [as] As String
  '''<summary>Is a Boolean which represents whether the link is disabled; currently only used with style sheet links.</summary>
  Property [disabled] As Boolean
  '''<summary>Is a DOMString representing the URI for the target resource.</summary>
  Property [href] As String
  '''<summary>Is a DOMString representing the language code for the linked resource.</summary>
  Property [hreflang] As String
  '''<summary>Is a DOMString representing a list of one or more media formats to which the resource applies.</summary>
  Property [media] As Dynamic
  '''<summary>Is a DOMString representing the forward relationship of the linked resource from the document to the resource.</summary>
  Property [rel] As String
  '''<summary>Is a DOMTokenList that reflects the rel HTML attribute, as a list of tokens.</summary>
  ReadOnly Property [relList] As DOMTokenList
  '''<summary>Is a DOMSettableTokenList that reflects the sizes HTML attribute, as a list of tokens.</summary>
  ReadOnly Property [sizes] As Dynamic
  '''<summary>Is a DOMString representing the MIME type of the linked resource.</summary>
  Property [type] As Dynamic
End Interface