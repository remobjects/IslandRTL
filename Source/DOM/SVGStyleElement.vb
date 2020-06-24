'''<Summary>The SVGStyleElement interface corresponds to the SVG &lt;style> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGStyleElement]
Inherits SVGElement, LinkStyle

'Defined on this type 
  '''<Summary>A DOMString corresponding to the type attribute of the given element.</Summary>
  Property [type] As Dynamic
  '''<Summary>A DOMString corresponding to the media attribute of the given element.</Summary>
  Property [media] As Dynamic
  '''<Summary>A DOMString corresponding to the title attribute of the given element.</Summary>
  Property [title] As String
End Interface