'''<Summary>The SVGFEImageElement interface corresponds to the &lt;feImage> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEImageElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes, SVGURIReference

  '''<Summary>An SVGAnimatedPreserveAspectRatio corresponding to the preserveAspectRatio attribute of the given element.</Summary>
  ReadOnly Property [preserveAspectRatio] As SVGAnimatedPreserveAspectRatio
  '''<Summary>An SVGAnimatedString reflects the crossorigin attribute of the given element, limited to only known values.</Summary>
  ReadOnly Property [crossOrigin] As SVGAnimatedString
End Interface