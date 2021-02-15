'''<summary>The SVGStyleElement interface corresponds to the SVG &lt;style> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGStyleElement]
Inherits SVGElement, LinkStyle

  '''<summary>A DOMString corresponding to the type attribute of the given element.</summary>
  Property [type] As Dynamic
  '''<summary>A DOMString corresponding to the media attribute of the given element.</summary>
  Property [media] As Dynamic
  '''<summary>A DOMString corresponding to the title attribute of the given element.</summary>
  Property [title] As String
End Interface