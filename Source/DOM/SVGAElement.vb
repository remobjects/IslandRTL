'''<summary>The SVGAElement interface provides access to the properties of &lt;a> element, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGAElement]
Inherits SVGGraphicsElement, SVGURIReference

  '''<summary>See HTMLAnchorElement.href.</summary>
  Property [href] As String
  '''<summary>Is a DOMString that reflects the hreflang attribute, indicating the language of the linked resource.</summary>
  Property [hreflang] As String
  '''<summary>Is a DOMString that reflects the ping attribute, containing a space-separated list of URLs to which, when the hyperlink is followed, POST requests with the body PING will be sent by the browser (in the background). Typically used for tracking.</summary>
  Property [ping] As String
  '''<summary>See HTMLAnchorElement.referrerPolicy.</summary>
  Property [referrerPolicy] As Dynamic
  '''<summary>See HTMLAnchorElement.rel.</summary>
  Property [rel] As String
  '''<summary>See HTMLAnchorElement.relList.</summary>
  Property [relList] As DOMTokenList
  '''<summary>Is a DOMString being a synonym for the Node.textContent property.</summary>
  Property [text] As String
  '''<summary>Is a DOMString that reflects the type attribute, indicating the MIME type of the linked resource.</summary>
  Property [type] As Dynamic
End Interface