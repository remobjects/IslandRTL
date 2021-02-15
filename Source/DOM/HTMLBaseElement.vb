'''<summary>The HTMLBaseElement interface contains the base URI for a document. This object inherits all of the properties and methods as described in the HTMLElement interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLBaseElement]
Inherits HTMLElement

  '''<summary>Is a DOMString that reflects the href HTML attribute, containing a base URL for relative URLs in the document.</summary>
  Property [href] As String
  '''<summary>Is a DOMString that reflects the target HTML attribute, containing a default target browsing context or frame for elements that do not have a target reference specified.</summary>
  Property [target] As String
End Interface