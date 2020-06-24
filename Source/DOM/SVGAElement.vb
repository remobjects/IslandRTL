'''<Summary>The SVGAElement interface provides access to the properties of &lt;a> element, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGAElement]
Inherits SVGGraphicsElement, SVGURIReference

'Defined on this type 
  '''<Summary>See HTMLAnchorElement.href.</Summary>
  Property [href] As String
  '''<Summary>Is a DOMString that reflects the hreflang attribute, indicating the language of the linked resource.</Summary>
  Property [hreflang] As String
  '''<Summary>Is a DOMString that reflects the ping attribute, containing a space-separated list of URLs to which, when the hyperlink is followed, POST requests with the body PING will be sent by the browser (in the background). Typically used for tracking.</Summary>
  Property [ping] As String
  '''<Summary>See HTMLAnchorElement.referrerPolicy.</Summary>
  Property [referrerPolicy] As Dynamic
  '''<Summary>See HTMLAnchorElement.rel.</Summary>
  Property [rel] As String
  '''<Summary>See HTMLAnchorElement.relList.</Summary>
  Property [relList] As DOMTokenList
  '''<Summary>Is a DOMString being a synonym for the Node.textContent property.</Summary>
  Property [text] As String
  '''<Summary>Is a DOMString that reflects the type attribute, indicating the MIME type of the linked resource.</Summary>
  Property [type] As Dynamic
End Interface