'''<Summary>The SVGFETurbulenceElement interface corresponds to the &lt;feTurbulence> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFETurbulenceElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedNumber corresponding to the X component of the baseFrequency attribute of the given element.</Summary>
  ReadOnly Property [baseFrequencyX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the Y component of the baseFrequency attribute of the given element.</Summary>
  ReadOnly Property [baseFrequencyY] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedInteger corresponding to the numOctaves attribute of the given element.</Summary>
  ReadOnly Property [numOctaves] As SVGAnimatedInteger
  '''<Summary>An SVGAnimatedNumber corresponding to the seed attribute of the given element.</Summary>
  ReadOnly Property [seed] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedEnumeration corresponding to the stitchTiles attribute of the given element. It takes one of the SVG_STITCHTYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [stitchTiles] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the type attribute of the given element. It takes one of the SVG_TURBULENCE_TYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [type] As Dynamic
End Interface