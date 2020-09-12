'''<Summary>The XPathNSResolver interface permits prefix strings in an XPath expression to be properly bound to namespace URI strings.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XPathNSResolver]
  '''<Summary>Looks up the namespace URI associated to the given namespace prefix.</Summary>
  Function [lookupNamespaceURI]([parprefix] As Dynamic) As String
End Interface