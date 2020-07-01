'''<Summary>The DOMTokenList interface represents a set of space-separated tokens. Such a set is returned by Element.classList, HTMLLinkElement.relList, HTMLAnchorElement.relList, HTMLAreaElement.relList, HTMLIframeElement.sandbox, or HTMLOutputElement.htmlFor. It is indexed beginning with 0 as with JavaScript Array objects. DOMTokenList is always case-sensitive.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMTokenList]
  '''<Summary>Is an integer representing the number of objects stored in the object.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>A stringifier property that returns the value of the list as a DOMString.</Summary>
  Property [value] As String
End Interface