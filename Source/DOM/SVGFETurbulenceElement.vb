'''<summary>The SVGFETurbulenceElement interface corresponds to the &lt;feTurbulence> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFETurbulenceElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<summary>An SVGAnimatedEnumeration corresponding to the stitchTiles attribute of the given element. It takes one of the SVG_STITCHTYPE_* constants defined on this interface.</summary>
  ReadOnly Property [stitchTiles] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the type attribute of the given element. It takes one of the SVG_TURBULENCE_TYPE_* constants defined on this interface.</summary>
  ReadOnly Property [type] As Dynamic
End Interface