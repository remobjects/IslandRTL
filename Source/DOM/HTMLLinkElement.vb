'''<Summary>The HTMLLinkElement interface represents reference information for external resources and the relationship of those resources to a document and vice-versa (corresponds to &lt;link> element; not to be confused with &lt;a>, which is represented by HTMLAnchorElement). This object inherits all of the properties and methods of the HTMLElement interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLLinkElement]
Inherits HTMLElement, LinkStyle

  '''<Summary>Is a DOMString representing the type of content being loaded by the HTML link.</Summary>
  Property [as] As String
  '''<Summary>Is a Boolean which represents whether the link is disabled; currently only used with style sheet links.</Summary>
  Property [disabled] As Boolean
  '''<Summary>Is a DOMString representing the URI for the target resource.</Summary>
  Property [href] As String
  '''<Summary>Is a DOMString representing the language code for the linked resource.</Summary>
  Property [hreflang] As String
  '''<Summary>Is a DOMString representing a list of one or more media formats to which the resource applies.</Summary>
  Property [media] As Dynamic
  '''<Summary>Is a DOMString representing the forward relationship of the linked resource from the document to the resource.</Summary>
  Property [rel] As String
  '''<Summary>Is a DOMTokenList that reflects the rel HTML attribute, as a list of tokens.</Summary>
  ReadOnly Property [relList] As DOMTokenList
  '''<Summary>Is a DOMSettableTokenList that reflects the sizes HTML attribute, as a list of tokens.</Summary>
  ReadOnly Property [sizes] As Dynamic
  '''<Summary>Is a DOMString representing the MIME type of the linked resource.</Summary>
  Property [type] As Dynamic
End Interface